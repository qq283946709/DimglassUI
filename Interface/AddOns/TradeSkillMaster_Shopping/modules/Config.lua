-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Shopping - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_shopping.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


local TSM = select(2, ...)
local Config = TSM:NewModule("Config", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Shopping") -- loads the localization table

function Config:Load(parent)
	local treeGroup = AceGUI:Create("TSMTreeGroup")
	treeGroup:SetLayout("Fill")
	treeGroup:SetCallback("OnGroupSelected", function(...) Config:SelectTree(...) end)
	treeGroup:SetStatusTable(TSM.db.global.treeGroupStatus)
	parent:AddChild(treeGroup)
	
	Config.treeGroup = treeGroup
	Config:UpdateTree()
	Config.treeGroup:SelectByPath(1)
end

function Config:UpdateTree()
	if not Config.treeGroup then return end
	
	local folderTreeIndex = {[0]=1}
	local folderLookup = {}
	local pageNum
	local tchildren = {{value="~", text="|cffaaff11"..L["<Unorganized Items>"].."|r", disabled=true}}
	local treeGroups = {{value=1, text=L["Options"]}, {value=2, text="Profiles"}, {value=3, text=L["Dealfinding"], children=tchildren}}
	
	for folderName, items in pairs(TSM.db.profile.folders) do
		for item in pairs(items) do
			folderLookup[item] = folderName
		end
		tinsert(tchildren, {value=folderName, text="|cff99ff99"..folderName.."|r"})
		folderTreeIndex[folderName] = #(tchildren)
	end
	for itemID, data in pairs(TSM.db.profile.dealfinding) do
		data.name = GetItemInfo(itemID) or data.name or itemID
		local text = data.name.." ("..TSM:FormatTextMoney(data.maxPrice)..")"
		local index = folderTreeIndex[folderLookup[itemID] or 0]
		tchildren[index].children = tchildren[index].children or {}
		tinsert(tchildren[index].children, {value=itemID, text=text, icon=select(10, GetItemInfo(itemID))})
	end
	sort(tchildren, function(a, b) return strlower(a.text) < strlower(b.text) end)
	for _, data in pairs(tchildren) do
		if data.children then
			sort(data.children, function(a, b) return strlower(a.text) < strlower(b.text) end)
		end
	end
	Config.treeGroup:SetTree(treeGroups)
end

function Config:SelectTree(treeFrame, _, selection)
	TSMAPI:SetStatusText()
	treeFrame:ReleaseChildren()
	local selectedParent, selectedChild, selectedSubChild = ("\001"):split(selection)
	
	local content = AceGUI:Create("TSMSimpleGroup")
	content:SetLayout("Fill")
	treeFrame:AddChild(content)
	
	if tonumber(selectedParent) == 1 then
		Config:LoadOptionsPage(content)
	elseif tonumber(selectedParent) == 2 then
		Config:LoadProfilesPage(content)
	elseif tonumber(selectedParent) == 3 then
		if not selectedChild then
			Config:LoadDealfindingOptions(content)
		elseif not selectedSubChild then
			local tg = AceGUI:Create("TSMTabGroup")
			tg:SetLayout("Fill")
			tg:SetFullHeight(true)
			tg:SetFullWidth(true)
			tg:SetTabs({{value=1, text=L["Add / Remove Items"]}, {value=2, text=L["Folder Management"]}})
			tg:SetCallback("OnGroupSelected", function(self,_,value)
				tg:ReleaseChildren()
				content:DoLayout()
				
				if value == 1 then
					Config:LoadFolderAddRemove(self, selectedChild)
				else
					Config:LoadFolderManagement(self, selectedChild)
				end
			end)
			content:AddChild(tg)
			tg:SelectTab(1)
		else
			Config:LoadDealfindingItemOptions(content, tonumber(selectedSubChild))
		end
	end
end

function Config:LoadOptionsPage(container)
	local page = {
		{
			type = "ScrollFrame",
			layout = "list",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["General Options"],
					children = {
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Shopping - Milling/Disenchanting/Prospecting/Transforming Options"],
					children = {
						{
							type = "Label",
							text = L["The options below apply to \"Shopping - Milling/Disenchanting/Prospecting/Transforming\" searches (including those done while shopping for crafting mats)."],
							relativeWidth = 1,
						},
						{
							type = "HeadingLine",
						},
						{
							type = "CheckBox",
							value = TSM.db.profile.fullStacksOnly,
							label = L["Even Stacks Only"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSM.db.profile.fullStacksOnly = value end,
							tooltip = L["If checked, when buying ore / herbs only stacks that are evenly divisible by 5 will be purchased."],
						},
						{
							type = "CheckBox",
							value = TSM.db.profile.herbsOreOnly,
							label = L["Herbs / Ore Only"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSM.db.profile.herbsOreOnly = value end,
							tooltip = L["If checked, only herbs / ore will be searched for; not inks / raw gems."],
						},
						{
							type = "CheckBox",
							value = TSM.db.profile.tradeInks,
							label = L["Buy Inks to Trade if Cheaper"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSM.db.profile.tradeInks = value end,
							tooltip = L["If checked, blackfallow ink will be shopped for in order to trade down to lower inks if it's cheaper."],
						},
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Shopping - Crafting Mats Options"],
					children = {
						{
							type = "Label",
							text = L["The options below apply to \"Shopping - Crafting Mats\" searches."],
							relativeWidth = 1,
						},
						{
							type = "HeadingLine",
						},
						{
							type = "CheckBox",
							value = TSM.db.profile.noProspecting,
							label = L["Disable prospecting for gems"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSM.db.profile.noProspecting = value end,
							tooltip = L["If checked, you will not be given the option to buy ore in order to obtain raw gems."],
						},
						{
							type = "CheckBox",
							value = TSM.db.profile.noDisenchanting,
							label = L["Disable disenchanting for mats"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSM.db.profile.noDisenchanting = value end,
							tooltip = L["If checked, you will not be given the option to buy items to disenchant to obtain enchanting mats."],
						},
						{
							type = "CheckBox",
							value = TSM.db.profile.skipAutoModeIntro,
							label = L["Skip Intro Screen"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSM.db.profile.skipAutoModeIntro = value end,
							tooltip = L["If checked, the intro screen for scanning for crafting mats will be skipped and the scanning will start immediately after clicking on the sidebar icon."],
						},
					},
				},
			},
		},
	}
	
	if select(4, GetAddOnInfo("Auc-Advanced")) == 1 then
		tinsert(page[1].children[1].children,
			{
				type = "CheckBox",
				value = TSM.db.global.blockAuc,
				label = L["Block Auctioneer while Scanning"],
				relativeWidth = 0.5,
				callback = function(_,_,value) TSM.db.global.blockAuc = value end,
				tooltip = L["Prevents Auctioneer from scanning / processing while Shopping is doing a scan."],
			})
	end
	
	TSMAPI:BuildPage(container, page)
end

function Config:LoadDealfindingOptions(container)
	local function AddItem(eb,_,item, try)
		item = item:trim()
		-- make sure the item is valid
		local itemID = tonumber(item) or TSMAPI:GetItemID(item)
		try = try or 0
		if itemID and not GetItemInfo(itemID) and try < 3 then
			return TSMAPI:CreateTimeDelay("dealfindingAddItem", 0.1, function() AddItem(eb, nil, tostring(itemID), try+1) end)
		end
		local ok, name, link = pcall(function() return GetItemInfo(itemID or item) end)
		if not (ok and name and link) and not (itemID and itemID < 100000 and itemID > 0) then
			TSMAPI:SetStatusText(format(L["The item you entered was invalid. See the tooltip for the \"%s\" editbox for info about how to add items."], L["Item to Add"]))
			eb:SetFocus()
			return
		elseif itemID and itemID < 100000 and itemID > 0 then
			TSM:Print(L["This item has not been seen on the server recently. Until the server has seen the item, Dealfinding will not be able to search for it on the AH and it will show up as the itemID in the Shopping options."])
		end
		
		-- make sure we don't already have this item in dealfinding
		itemID = itemID or TSMAPI:GetItemID(link)
		if TSM.db.profile.dealfinding[itemID].maxPrice > 0 then
			TSMAPI:SetStatusText(L["Item has already been added to dealfinding."])
			eb:SetFocus()
			return
		end
		
		TSM.db.profile.dealfinding[itemID] = {name=(name or itemID), maxPrice=1}
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(3, "~", itemID)
	end
	
	local function AddFolder(eb,_,name)
		name = name:trim()
		-- make sure the folder name is valid
		if not name or name == "" or TSM.db.profile.folders[name] then
			TSMAPI:SetStatusText(format(L["Invalid folder name. A folder with this name may already exist."]))
			eb:SetFocus()
			return
		end
		
		TSMAPI:SetStatusText()
		TSM.db.profile.folders[name] = {}
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(3, name)
	end

	local page = {
		{
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Add Item"],
					children = {
						{
							type = "Label",
							relativeWidth = 1,
							fontObject = GameFontNormal,
							text = L["Adds an item to the dealfinding list. When you run a dealfinding scan, this item will be searched for and you will be prompted to buy any auctions of this item that meet the criteria you set."],
						},
						{
							type = "EditBox",
							label = L["Item to Add"],
							relativeWidth = 0.8,
							callback = AddItem,
							tooltip = L["You can either drag an item into this box, paste (shift click) an item link into this box, or enter an itemID."],
						},
					},
				},
				{
					type = "Spacer"
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Create Folder"],
					children = {
						{
							type = "Label",
							relativeWidth = 1,
							text = L["Folders are simply for organization of your dealfinding items. They do not provide any additional settings. You can add items to a folder by clicking on the folder name in the list on the left."],
						},
						{
							type = "EditBox",
							label = L["Folder Name"],
							relativeWidth = 0.8,
							callback = AddFolder,
							tooltip = L["Name of the new folder."],
						},
					},
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

function Config:LoadProfilesPage(container)
	local text = {
		default = L["Default"],
		intro = L["You can change the active database profile, so you can have different settings for every character."],
		reset_desc = L["Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."],
		reset = L["Reset Profile"],
		choose_desc = L["You can either create a new profile by entering a name in the editbox, or choose one of the already exisiting profiles."],
		new = L["New"],
		new_sub = L["Create a new empty profile."],
		choose = L["Existing Profiles"],
		copy_desc = L["Copy the settings from one existing profile into the currently active profile."],
		copy = L["Copy From"],
		delete_desc = L["Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."],
		delete = L["Delete a Profile"],
		profiles = L["Profiles"],
		current = L["Current Profile:"] .. " |cff99ffff" .. TSM.db:GetCurrentProfile() .. "|r",
	}
	
	-- Popup Confirmation Window used in this module
	StaticPopupDialogs["TSMShopProfiles.DeleteConfirm"] = StaticPopupDialogs["TSMShopProfiles.DeleteConfirm"] or {
		text = L["Are you sure you want to delete the selected profile?"],
		button1 = L["Accept"],
		button2 = L["Cancel"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		OnCancel = false,
		-- OnAccept defined later
	}
	
	-- Returns a list of all the current profiles with common and nocurrent modifiers.
	-- This code taken from AceDBOptions-3.0.lua
	local function GetProfileList(db, common, nocurrent)
		local profiles = {}
		local tmpprofiles = {}
		local defaultProfiles = {["Default"] = L["Default"]}
		
		-- copy existing profiles into the table
		local currentProfile = db:GetCurrentProfile()
		for i,v in pairs(db:GetProfiles(tmpprofiles)) do 
			if not (nocurrent and v == currentProfile) then 
				profiles[v] = v 
			end 
		end
		
		-- add our default profiles to choose from ( or rename existing profiles)
		for k,v in pairs(defaultProfiles) do
			if (common or profiles[k]) and not (nocurrent and k == currentProfile) then
				profiles[k] = v
			end
		end
		
		return profiles
	end
	
	local page = {
		{	-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "Label",
					text = "TradeSkillMaster_Shopping" .. "\n",
					fontObject = GameFontNormalLarge,
					fullWidth = true,
					colorRed = 255,
					colorGreen = 0,
					colorBlue = 0,
				},
				{
					type = "Label",
					text = text["intro"] .. "\n" .. "\n",
					fontObject = GameFontNormal,
					fullWidth = true,
				},
				{
					type = "Label",
					text = text["reset_desc"],
					fontObject = GameFontNormal,
					fullWidth = true,
				},
				{	--simplegroup1 for the reset button / current profile text
					type = "SimpleGroup",
					layout = "flow",
					fullWidth = true,
					children = {
						{
							type = "Button",
							text = text["reset"],
							callback = function()
									TSM.db:ResetProfile()
									Config:UpdateTree()
									Config.treeGroup:SelectByPath(2)
								end,
						},
						{
							type = "Label",
							text = text["current"],
							fontObject = GameFontNormal,
						},
					},
				},
				{
					type = "Spacer",
					quantity = 2,
				},
				{
					type = "Label",
					text = text["choose_desc"],
					fontObject = GameFontNormal,
					fullWidth = true,
				},
				{	--simplegroup2 for the new editbox / existing profiles dropdown
					type = "SimpleGroup",
					layout = "flow",
					fullWidth = true,
					children = {
						{
							type = "EditBox",
							label = text["new"],
							value = "",
							callback = function(_,_,value) 
									TSM.db:SetProfile(value)
									Config:UpdateTree()
									Config.treeGroup:SelectByPath(2)
								end,
						},
						{
							type = "Dropdown",
							label = text["choose"],
							list = GetProfileList(TSM.db, true, nil),
							value = TSM.db:GetCurrentProfile(),
							callback = function(_,_,value)
									if value ~= TSM.db:GetCurrentProfile() then
										TSM.db:SetProfile(value)
										Config:UpdateTree()
										Config.treeGroup:SelectByPath(2)
									end
								end,
						},
					},
				},
				{
					type = "Spacer",
					quantity = 1,
				},
				{
					type = "Label",
					text = text["copy_desc"],
					fontObject = GameFontNormal,
					fullWidth = true,
				},
				{
					type = "Dropdown",
					label = text["copy"],
					list = GetProfileList(TSM.db, true, nil),
					value = "",
					disabled = not GetProfileList(TSM.db, true, nil) and true,
					callback = function(_,_,value)
							if value ~= TSM.db:GetCurrentProfile() then
								TSM.db:CopyProfile(value)
								Config:UpdateTree()
								Config.treeGroup:SelectByPath(2)
							end
						end,
				},
				{
					type = "Spacer",
					quantity = 2,
				},
				{
					type = "Label",
					text = text["delete_desc"],
					fontObject = GameFontNormal,
					fullWidth = true,
				},
				{
					type = "Dropdown",
					label = text["delete"],
					list = GetProfileList(TSM.db, true, nil),
					value = "",
					disabled = not GetProfileList(TSM.db, true, nil) and true,
					callback = function(_,_,value)
							StaticPopupDialogs["TSMShopProfiles.DeleteConfirm"].OnAccept = function()
									TSM.db:DeleteProfile(value)
									Config:UpdateTree()
									Config.treeGroup:SelectByPath(2)
								end
							StaticPopup_Show("TSMShopProfiles.DeleteConfirm")
						end,
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

function Config:LoadDealfindingItemOptions(container, itemID)
	local function RemoveItem()
		TSM.db.profile.dealfinding[itemID] = nil
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(3)
	end

	local page = {
		{
			type = "ScrollFrame",
			layout = "list",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["General Options"],
					children = {
						{
							type = "Label",
							relativeWidth = 1,
							text = L["Below are some general options dealfinding will follow for this item."],
						},
						{
							type = "HeadingLine",
						},
						{
							type = "CheckBox",
							label = L["Even Stacks Only"],
							relativeWidth = 0.5,
							value = TSM.db.profile.dealfinding[itemID].evenStacks,
							callback = function(self,_,value) TSM.db.profile.dealfinding[itemID].evenStacks = value end,
							tooltip = L["Only even stacks (5/10/15/20) of this item will be purchased. This is useful for buying herbs / ore to mill / prospect."],
						},
					},
				},
				{
					type = "Spacer"
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Maximum Price"],
					children = {
						{
							type = "Label",
							relativeWidth = 1,
							text = L["Here, you can set the maximum price you want to pay."], 
						},
						{
							type = "HeadingLine",
						},
						{
							type = "EditBox",
							label = L["Maximum Price Per Item"],
							relativeWidth = 0.5,
							value = TSM:FormatTextMoney(TSM.db.profile.dealfinding[itemID].maxPrice),
							callback = function(self,_,value)
									local copper = TSM:UnformatTextMoney(value)
									if not copper then
										TSMAPI:SetStatusText(L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."])
										self:SetFocus()
									else
										self:ClearFocus()
										TSM.db.profile.dealfinding[itemID].maxPrice = copper
									end
								end,
							tooltip = L["This is the maximum price you want to pay per item (NOT per stack) for this item. You will be prompted to buy all items on the AH that are below this price."],
						},
					},
				},
				{
					type = "Spacer"
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Item Management"],
					children = {
						{
							type = "Label",
							relativeWidth = 1,
							text = L["Below are general management options for this item."], 
						},
						{
							type = "HeadingLine",
						},
						{
							type = "Button",
							text = L["Remove Item from Dealfinding"],
							relativeWidth = 1,
							callback = RemoveItem,
							tooltip = L["Removes this item from dealfinding completely."],
						},
					},
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

function Config:LoadFolderAddRemove(container, folderName)
	local unorganizedItems, itemsInFolder, folderLookup = {}, {}, {}
	
	for folderName, items in pairs(TSM.db.profile.folders) do
		for item in pairs(items) do
			folderLookup[item] = folderName
		end
	end
	
	for itemID in pairs(TSM.db.profile.folders[folderName]) do
		local _,link,_,_,_,_,_,_,_,texture = GetItemInfo(itemID)
		TSM.db.profile.dealfinding[itemID].name = GetItemInfo(itemID) or TSM.db.profile.dealfinding[itemID].name or itemID
		local iLink = link or TSM.db.profile.dealfinding[itemID].name
		tinsert(itemsInFolder, {value=itemID, text=iLink, icon=texture, name=TSM.db.profile.dealfinding[itemID].name})
	end
	sort(itemsInFolder, function(a,b) return strlower(a.name) < strlower(b.name) end)
	
	for itemID, data in pairs(TSM.db.profile.dealfinding) do
		if not folderLookup[itemID] then
			local _,link,_,_,_,_,_,_,_,texture = GetItemInfo(itemID)
			TSM.db.profile.dealfinding[itemID].name = GetItemInfo(itemID) or TSM.db.profile.dealfinding[itemID].name or itemID
			local iName = data.name
			local iLink = link or iName
			tinsert(unorganizedItems, {value=itemID, text=iLink, icon=texture, name=iName})
		end
	end
	sort(unorganizedItems, function(a,b) return strlower(a.name) < strlower(b.name) end)

	local page = {
		{	-- scroll frame to contain everything
			type = "SimpleGroup",
			layout = "Fill",
			children = {
				{
					type = "SelectionList",
					leftTitle = L["Items not in any folder:"],
					rightTitle = L["Items in this folder:"],
					leftList = unorganizedItems,
					rightList = itemsInFolder,
					onAdd = function(_,_,selected)
							for i=#selected, 1, -1 do
								TSM.db.profile.folders[folderName][selected[i]] = true
							end
							Config:UpdateTree()
							container:SelectTab(1)
						end,
					onRemove = function(_,_,selected)
							for i=#selected, 1, -1 do
								TSM.db.profile.folders[folderName][selected[i]] = nil
							end
							Config:UpdateTree()
							container:SelectTab(1)
						end,
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

function Config:LoadFolderManagement(container, folderName)
	local function RenameFolder(eb,_,newName)
		newName = newName:trim()
		-- make sure the folder name is valid
		if not newName or newName == "" or TSM.db.profile.folders[newName] then
			TSMAPI:SetStatusText(format(L["Invalid folder name. A folder with this name may already exist."]))
			eb:SetFocus()
			return
		end
		
		TSMAPI:SetStatusText()
		TSM.db.profile.folders[newName] = CopyTable(TSM.db.profile.folders[folderName])
		TSM.db.profile.folders[folderName] = nil
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(3, newName)
	end
	
	local function DeleteFolder()
		TSM.db.profile.folders[folderName] = nil
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(3)
	end

	local page = {
		{
			type = "ScrollFrame",
			layout = "list",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Rename Folder"],
					children = {
						{
							type = "EditBox",
							label = L["New Folder Name"],
							relativeWidth = 0.5,
							callback = RenameFolder,
						},
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Delete Folder"],
					children = {
						{
							type = "Button",
							text = L["Delete Folder"],
							relativeWidth = 0.5,
							callback = DeleteFolder,
						},
					},
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end