-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Crafting - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_crafting.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local GUI = TSM:NewModule("GUI", "AceEvent-3.0", "AceHook-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Crafting") -- loads the localization table
local debug = function(...) TSM:Debug(...) end -- for debugging

-- some static variables for easy changing of frame dimmensions
-- these values are what the frame starts out using but the user can resize it from there
local TREE_WIDTH = 150 -- the width of the tree part of the frame
local FRAME_WIDTH = 780 -- width of the entire frame
local FRAME_HEIGHT = 700 -- height of the entire frame
local BIG_NUMBER = 100000000000 -- 10 million gold
local ROW_HEIGHT = 16

-- color codes
local CYAN = "|cff99ffff"
local BLUE = "|cff5555ff"
local GREEN = "|cff00ff00"
local RED = "|cffff0000"
local WHITE = "|cffffffff"
local GOLD = "|cffffbb00"
local YELLOW = "|cffffd000"

-- scrolling tables
local matST

local function getIndex(t, value)
	for i, v in pairs(t) do
		if v == value then
			return i
		end
	end
end

function GUI:OnEnable()
	GUI.queueList = {}
	GUI.offsets = {}
	GUI.currentPage = {}
	TSM.mode = "Enchanting"

	-- Popup Confirmation Window used in this module
	StaticPopupDialogs["TSMCrafting.DeleteConfirm"] = {
		text = L["Are you sure you want to delete the selected profile?"],
		button1 = L["Accept"],
		button2 = L["Cancel"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		OnCancel = false,
		-- OnAccept defined later
	}

	local names, textures = {}, {}
	for _, data in pairs(TSM.tradeSkills) do
		local name, _, texture = GetSpellInfo(data.spellID)
		tinsert(names, name)
		tinsert(textures, texture)
	end

	for i=1, #(names) do
		TSMAPI:RegisterIcon("Crafting - "..names[i], textures[i], function(...) GUI:LoadGUI(i, ...) end, "TradeSkillMaster_Crafting", "crafting")
	end

	TSMAPI:RegisterIcon(L["Crafting Options"], "Interface\\Icons\\Inv_Jewelcrafting_DragonsEye02", function(...) GUI:SelectTree(...) end, "TradeSkillMaster_Crafting", "options")
end

-- setup the main GUI frame / structure
function GUI:LoadGUI(num, parent)
	TSMAPI:SetFrameSize(FRAME_WIDTH, FRAME_HEIGHT)
	local treeGroupStatus = {treewidth = TREE_WIDTH, groups = TSM.db.global.treeStatus}
	TSM.onOptions = false

	-- Create the main tree-group that will control and contain the entire GUI
	GUI.TreeGroup = AceGUI:Create("TSMTreeGroup")
	GUI.TreeGroup:SetLayout("Fill")
	GUI.TreeGroup:SetCallback("OnGroupSelected", function(...) GUI:SelectTree(...) end)
	GUI.TreeGroup:SetStatusTable(treeGroupStatus)
	parent:AddChild(GUI.TreeGroup)

	local treeStructure = {
			{value = 1, text = L["Crafts"], children = {}},
			{value = 2, text = L["Materials"]},
			{value = 3, text = L["Options"]},
		}

	if num <= #(TSM.tradeSkills) then
		TSM.onOptions = false
		TSM.mode = TSM.tradeSkills[num].name
		local slotList = TSM[TSM.mode].slotList
		if TSM.mode == "Inscription" then
			slotList = TSM.Inscription:GetSlotList()
		end
		for i=1, #(slotList) do
			tinsert(treeStructure[1].children, {value = i, text = slotList[i]})
		end
		GUI.TreeGroup:SetTree(treeStructure)
		GUI.TreeGroup:SelectByPath(1)

		local lastScan = TSM.db.profile.lastScan[TSM.mode]
		if not lastScan or (time() - lastScan) > 60*60 then
			TSM.Data:ScanProfession(TSM.mode)
		elseif TSM.mode == "Inscription" then
			for itemID, craft in pairs(TSM.Data[TSM.mode].crafts) do
				craft.group = TSM[TSM.mode]:GetSlot(itemID, craft.mats)
			end
		end
	end
end

-- controls what is drawn on the right side of the GUI window
-- this is based on what is selected in the "tree" on the left (ex 'Options'->'Remove Crafts')
function GUI:SelectTree(treeFrame, optionsPage, selection)
	if not selection then
		TSM.onOptions = true
		GUI:DrawOptions(treeFrame)
		return
	end

	-- decodes and seperates the selection string from AceGUIWidget-TreeGroup
	local selectedParent, selectedChild = ("\001"):split(selection)
	selectedParent = tonumber(selectedParent) -- the main group that's selected (Crafts, Materials, Options, etc)
	selectedChild = tonumber(selectedChild) -- the child group that's if there is one (2H Weapon, Boots, Chest, etc)

	if treeFrame.children and treeFrame.children[1] and treeFrame.children[1].children and treeFrame.children[1].children[1] and treeFrame.children[1].children[1].type == "TSMScrollFrame" and treeFrame.children[1].children[1].localstatus then
		GUI.offsets[GUI.currentPage.parent][GUI.currentPage.child] = treeFrame.children[1].children[1].localstatus.offset
	end

	-- prepare the TreeFrame for a new container which will hold everything that is drawn on the right part of the GUI
	treeFrame:ReleaseChildren()
	if not TSM.onOptions then
		GUI:UpdateQueue(true)
	end
	GUI.currentPage = {parent=selectedParent, child=(selectedChild or 0)}

	-- a simple group to provide a fresh layout to whatever is put inside of it
	-- just acts as an invisible layer between the TreeGroup and whatever is drawn inside of it
	local container = AceGUI:Create("TSMSimpleGroup")
	container:SetLayout("Fill")
	treeFrame:AddChild(container)

	-- figures out which tree element is selected
	-- then calls the correct function to build that part of the GUI
	if selectedParent == 1 then
		local slot = selectedChild or 0
		if selectedChild then
			GUI:DrawSubCrafts(container, selectedChild)
		else
			GUI:DrawStatus(container)
		end
	elseif selectedParent == 2 then -- Materials summary page
		GUI:DrawMaterials(container)
	elseif selectedParent == 3 then -- Options page
		GUI:DrawProfessionOptions(container)
	end

	GUI.offsets[GUI.currentPage.parent] = GUI.offsets[GUI.currentPage.parent] or {}
	GUI.offsets[GUI.currentPage.parent][GUI.currentPage.child] = GUI.offsets[GUI.currentPage.parent][GUI.currentPage.child] or 0
	if container.children and container.children[1] and container.children[1].type == "TSMScrollFrame" then
		container.children[1].localstatus.offset = GUI.offsets[GUI.currentPage.parent][GUI.currentPage.child]
	end
end

 -- Front Crafts page
function GUI:DrawStatus(container)
	-- checks if a table has at least one element in it
	local function hasElements(sTable)
		local isTable = false
		for i, v in pairs(sTable) do
			return true
		end
	end

	local page = {
		{
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "Label",
					text = "TradeSkillMaster_Crafting v" .. TSM.version .. " " .. L["Status"] .. ": " .. GOLD .. TSM.mode .. "|r\n",
					fontObject = GameFontNormalHuge,
					fullWidth = true,
					colorRed = 255,
					colorGreen = 0,
					colorBlue = 0,
				},
				{
					type = "Spacer"
				},
				{
					type = "Label",
					text = CYAN .. L["Use the links on the left to select which page to show."] .. "|r",
					fontObject = GameFontNormalLarge,
					fullWidth = true,
				},
				{
					type = "Spacer",
					quantity = 2,
				},
				{
					type = "Button",
					text = L["Show Craft Management Window"],
					relativeWidth = 1,
					height = 30,
					callback = function()
							TSMAPI:CloseFrame()
							TSM.Crafting:OpenFrame()
						end,
				},
				{
					type = "Spacer",
					quantity = 2,
				},
				{
					type = "Button",
					text = L["Force Rescan of Profession (Advanced)"],
					relativeWidth = 1,
					callback = function()
							TSM.Data:ScanProfession(TSM.mode)
						end,
				},
			},
		},
	}

	if TSM.db.profile.minRestockQuantity.default > TSM.db.profile.maxRestockQuantity.default then
		-- Popup Confirmation Window used in this module
		StaticPopupDialogs["TSMCrafting.Warning2"] = StaticPopupDialogs["TSMCrafting.Warning2"] or {
			text = L["Warning: Your default minimum restock quantity is higher than your maximum restock " ..
				"quantity! Visit the \"Craft Management Window\" section of the Crafting options to fix this!" ..
				"\n\nYou will get error messages printed out to chat if you try and perform a restock queue without fixing this."],
			button1 = L["OK"],
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
		StaticPopup_Show("TSMCrafting.Warning2")
	end

	TSMAPI:BuildPage(container, page)
end

-- Craft Pages
function GUI:DrawSubCrafts(container, slot)
	GUI:HookScript(container.frame, "OnHide", function() GUI:UnhookAll() if GUI.OpenWindow then GUI.OpenWindow:Hide() end end)
	local function ShowAdditionalSettings(parent, itemID, data)
		if GUI.OpenWindow then GUI.OpenWindow:Hide() end

		local window = AceGUI:Create("TSMWindow")
		window.frame:SetParent(container.frame)
		window:SetWidth(500)
		window:SetHeight(440)
		window:SetTitle(L["Add Item to TSM_Auctioning"])
		window:SetLayout("Flow")
		window:EnableResize(false)
		window.frame:SetPoint("TOPRIGHT", parent.frame, "TOPLEFT")
		window:SetCallback("OnClose", function(self)
				self:ReleaseChildren()
				GUI.OpenWindow = nil
				window.frame:Hide()
			end)
		GUI.OpenWindow = window

		local groupSelection, newGroupName, inAuctioningGroup
		local auctioningGroupList = {}
		local auctioningGroups = TSMAPI:GetData("auctioningGroups")
		for groupName, items in pairs(TSMAPI:GetData("auctioningGroups")) do
			auctioningGroupList[groupName] = groupName
			if items[itemID] then
				inAuctioningGroup = groupName
			end
		end

		if tonumber(TSM.db.profile.maxRestockQuantity) then
			TSM.db.profile.maxRestockQuantity = {default = 3}
		end

		local page = {
			{
				type = "InteractiveLabel",
				text = select(2, GetItemInfo(itemID)) or data.name,
				fontObject = GameFontHighlight,
				relativeWidth = 1,
				callback = function() SetItemRef("item:".. itemID, itemID) end,
				tooltip = itemID,
			},
			{
				type = "HeadingLine"
			},
			{
				type = "Dropdown",
				label = L["TSM_Auctioning Group to Add Item to:"],
				list = auctioningGroupList,
				value = 1,
				relativeWidth = 0.49,
				callback = function(self, _, value)
						value = value:trim()
						groupSelection = value
						local i = getIndex(self.parent.children, self)
						self.parent.children[i+2]:SetDisabled(not value or value == "")
					end,
				tooltip = L["Which group in TSM_Auctioning to add this item to."],
			},
			{
				type = "Label",
				text = "",
				relativeWidth = 0.02,
			},
			{
				type = "Button",
				text = L["Add Item to Selected Group"],
				relativeWidth = 0.49,
				disabled = true,
				callback = function(self)
						if groupSelection then
							TSM:SendMessage("TSMAUC_NEW_GROUP_ITEM", groupSelection, itemID)
							window.frame:Hide()
						end
					end,
			},
			{
				type = "Spacer"
			},
			{
				type = "EditBox",
				label = L["Name of New Group to Add Item to:"],
				relativeWidth = 0.49,
				callback = function(self, _, value)
						value = value:trim()
						local i = getIndex(self.parent.children, self)
						self.parent.children[i+2]:SetDisabled(not value or value == "")
						newGroupName = value
					end,
			},
			{
				type = "Label",
				text = "",
				relativeWidth = 0.02,
			},
			{
				type = "Button",
				text = L["Add Item to New Group"],
				relativeWidth = 0.49,
				disabled = true,
				callback = function(self)
						if newGroupName then
							TSM:SendMessage("TSMAUC_NEW_GROUP_ITEM", newGroupName, itemID, true)
							window.frame:Hide()
						end
					end,
			},
			{
				type = "HeadingLine"
			},
			{
				type = "CheckBox",
				label = L["Override Max Restock Quantity"],
				value = TSM.db.profile.maxRestockQuantity[itemID] and true,
				relativeWidth = 0.5,
				callback = function(self, _, value)
						if value then
							TSM.db.profile.maxRestockQuantity[itemID] = TSM.db.profile.maxRestockQuantity.default
						else
							TSM.db.profile.maxRestockQuantity[itemID] = nil
						end
						local siblings = self.parent.children --aw how cute...siblings ;)
						local i = getIndex(siblings, self)
						siblings[i+2]:SetDisabled(not value)
						siblings[i+2]:SetText(TSM.db.profile.maxRestockQuantity[itemID] or "")
						siblings[i+3]:SetDisabled(not value)
						siblings[i+4]:SetDisabled(not value)
					end,
				tooltip = "Allows you to set a custom maximum queue quantity for this item.",
			},
			{
				type = "Label",
				text = "",
				relativeWidth = 0.1,
			},
			{
				type = "EditBox",
				label = L["Max Restock Quantity"],
				value = TSM.db.profile.maxRestockQuantity[itemID],
				disabled = TSM.db.profile.maxRestockQuantity[itemID] == nil,
				relativeWidth = 0.2,
				callback = function(self, _, value)
						value = tonumber(value)
						if value and value >= 0 then
							TSM.db.profile.maxRestockQuantity[itemID] = value
						end
					end,
			},
			{	-- plus sign for incrementing the number
				type = "Icon",
				image = "Interface\\Buttons\\UI-PlusButton-Up",
				width = 24,
				imageWidth = 24,
				imageHeight = 24,
				disabled = TSM.db.profile.maxRestockQuantity[itemID] == nil,
				callback = function(self)
						local value = (TSM.db.profile.maxRestockQuantity[itemID] or 0) + 1
						TSM.db.profile.maxRestockQuantity[itemID] = value

						local i = getIndex(self.parent.children, self)
						self.parent.children[i-1]:SetText(value)
					end,
			},
			{	-- minus sign for decrementing the number
				type = "Icon",
				image = "Interface\\Buttons\\UI-MinusButton-Up",
				disabled = true,
				width = 24,
				imageWidth = 24,
				imageHeight = 24,
				disabled = TSM.db.profile.maxRestockQuantity[itemID] == nil,
				callback = function(self)
						local value = (TSM.db.profile.maxRestockQuantity[itemID] or 0) - 1
						if value < 1 then value = 0 end

						if value < (TSM.db.profile.minRestockQuantity[itemID] or TSM.db.profile.minRestockQuantity.default) then
							value = TSM.db.profile.minRestockQuantity[itemID] or TSM.db.profile.minRestockQuantity.default
							TSM:Print(format(L["Can not set a max restock quantity below the minimum restock quantity of %d."], value))
						end
						TSM.db.profile.maxRestockQuantity[itemID] = value

						local i = getIndex(self.parent.children, self)
						self.parent.children[i-2]:SetText(value)
					end,
			},
			{
				type = "CheckBox",
				label = L["Override Min Restock Quantity"],
				value = TSM.db.profile.minRestockQuantity[itemID] and true,
				relativeWidth = 0.6,
				callback = function(self, _, value)
						if value then
							TSM.db.profile.minRestockQuantity[itemID] = TSM.db.profile.minRestockQuantity.default
						else
							TSM.db.profile.minRestockQuantity[itemID] = nil
						end
						local siblings = self.parent.children
						local i = getIndex(siblings, self)
						siblings[i+1]:SetDisabled(not value)
						siblings[i+1]:SetText(TSM.db.profile.minRestockQuantity[itemID] or "")
						siblings[i+2]:SetDisabled(not value)
						siblings[i+3]:SetDisabled(not value)
					end,
				tooltip = L["Allows you to set a custom minimum queue quantity for this item."],
			},
			{
				type = "EditBox",
				label = L["Min Restock Quantity"],
				value = TSM.db.profile.minRestockQuantity[itemID],
				disabled = TSM.db.profile.minRestockQuantity[itemID] == nil,
				relativeWidth = 0.2,
				callback = function(_, _, value)
						value = tonumber(value)
						if value and value >= 0 then
							TSM.db.profile.minRestockQuantity[itemID] = value
						end
					end,
				tooltip = L["This item will only be added to the queue if the number being added " ..
					"is greater than or equal to this number. This is useful if you don't want to bother with " ..
					"crafting singles for example."],
			},
			{	-- plus sign for incrementing the number
				type = "Icon",
				image = "Interface\\Buttons\\UI-PlusButton-Up",
				width = 24,
				imageWidth = 24,
				imageHeight = 24,
				disabled = TSM.db.profile.minRestockQuantity[itemID] == nil,
				callback = function(self)
						local value = (TSM.db.profile.minRestockQuantity[itemID] or 0) + 1
						if value > (TSM.db.profile.maxRestockQuantity[itemID] or TSM.db.profile.maxRestockQuantity.default) then
							value = TSM.db.profile.maxRestockQuantity[itemID] or TSM.db.profile.maxRestockQuantity.default
							TSM:Print(format("Can not set a min restock quantity above the max restock quantity of %d.", value))
						end
						TSM.db.profile.minRestockQuantity[itemID] = value

						local i = getIndex(self.parent.children, self)
						self.parent.children[i-1]:SetText(value)
					end,
			},
			{	-- minus sign for decrementing the number
				type = "Icon",
				image = "Interface\\Buttons\\UI-MinusButton-Up",
				disabled = true,
				width = 24,
				imageWidth = 24,
				imageHeight = 24,
				disabled = TSM.db.profile.minRestockQuantity[itemID] == nil,
				callback = function(self)
						local value = TSM.db.profile.minRestockQuantity[itemID] - 1
						if value < 1 then value = 1 end
						TSM.db.profile.minRestockQuantity[itemID] = tonumber(value)

						local i = getIndex(self.parent.children, self)
						self.parent.children[i-2]:SetText(value)
					end,
			},
			{
				type = "CheckBox",
				label = L["Ignore Seen Count Filter"],
				value = TSM.db.profile.ignoreSeenCountFilter[itemID],
				relativeWidth = 0.5,
				callback = function(_, _, value)
						TSM.db.profile.ignoreSeenCountFilter[itemID] = value
					end,
				tooltip = L["Allows you to set a custom minimum queue quantity for this item."],
			},
			{
				type = "Label",
				text = "",
				relativeWidth = 0.4
			},
			{
				type = "CheckBox",
				label = L["Don't queue this item."],
				value = TSM.db.profile.dontQueue[itemID],
				relativeWidth = 0.5,
				callback = function(_, _, value)
						TSM.db.profile.dontQueue[itemID] = value
					end,
				tooltip = L["This item will not be queued by the \"Restock Queue\" ever."],
			},
			{
				type = "CheckBox",
				label = L["Always queue this item."],
				value = TSM.db.profile.alwaysQueue[itemID],
				relativeWidth = 0.5,
				callback = function(_, _, value)
						TSM.db.profile.alwaysQueue[itemID] = value
					end,
				tooltip = L["This item will always be queued (to the max restock quantity) regardless of price data."],
			},
		}

		if inAuctioningGroup then
			for i=1, 7 do
				tremove(page, 3)
			end
			tinsert(page, 3, {
					type = "Label",
					text = format(L["This item is already in the \"%s\" Auctioning group."], inAuctioningGroup),
					relativeWidth = 1,
				})
		end

		TSMAPI:BuildPage(window, page)
	end

	local sortMethod = TSM:GetDBValue("craftSortMethod", TSM.mode)
	local sortOrder = TSM:GetDBValue("craftSortOrder", TSM.mode)
	local sortedData = TSM.Data:GetSortedData(TSM.Data[TSM.mode].crafts, function(a, b)
			if sortOrder == "ascending" then
				if sortMethod == "name" then
					return a.name < b.name
				elseif sortMethod == "cost" then
					return (TSM.Data:CalcPrices(a) or 0) < (TSM.Data:CalcPrices(b) or 0)
				elseif sortMethod == "profit" then
					return (select(3, TSM.Data:CalcPrices(a)) or math.huge) < (select(3, TSM.Data:CalcPrices(b)) or math.huge)
				elseif sortMethod == "scount" then
					return (TSM.Data:GetSeenCount(a.originalIndex) or 0) < (TSM.Data:GetSeenCount(b.originalIndex) or 0)
				elseif sortMethod == "ccount" then
					return (TSM.db.profile.craftHistory[a.spellID] or 0) < (TSM.db.profile.craftHistory[b.spellID] or 0)
				elseif sortMethod == "ilvl" then
					return (select(4, GetItemInfo(a.originalIndex)) or 0) < (select(4, GetItemInfo(b.originalIndex)) or 0)
				end
			else
				if sortMethod == "name" then
					return a.name > b.name
				elseif sortMethod == "cost" then
					return (TSM.Data:CalcPrices(a) or 0) > (TSM.Data:CalcPrices(b) or 0)
				elseif sortMethod == "profit" then
					return (select(3, TSM.Data:CalcPrices(a)) or math.huge) > (select(3, TSM.Data:CalcPrices(b)) or math.huge)
				elseif sortMethod == "scount" then
					return (TSM.Data:GetSeenCount(a.originalIndex) or 0) > (TSM.Data:GetSeenCount(b.originalIndex) or 0)
				elseif sortMethod == "ccount" then
					return (TSM.db.profile.craftHistory[a.spellID] or 0) > (TSM.db.profile.craftHistory[b.spellID] or 0)
				elseif sortMethod == "ilvl" then
					return (select(4, GetItemInfo(a.originalIndex)) or 0) > (select(4, GetItemInfo(b.originalIndex)) or 0)
				end
			end
		end)

	local function DrawCreateAuctioningGroups(parent)
		if GUI.OpenWindow then GUI.OpenWindow:Hide() end

		local window = AceGUI:Create("TSMWindow")
		window.frame:SetParent(container.frame)
		window:SetWidth(560)
		window:SetHeight(250)
		window:SetTitle(L["Export Crafts to TradeSkillMaster_Auctioning"])
		window:SetLayout("flow")
		window:EnableResize(false)
		window.frame:SetPoint("TOPRIGHT", parent.frame, "TOPLEFT")
		window:SetCallback("OnClose", function(self)
				self:ReleaseChildren()
				GUI.OpenWindow = nil
				window.frame:Hide()
			end)
		GUI.OpenWindow = window

		local moveCrafts = false
		local onlyEnabled = true
		local targetCategory = "None"
		local groupStyle = "oneGroup"
		local groupSelection = "newGroup"

		local auctioningGroups = {["newGroup"] = "<New Group>"}
		for name in pairs(TSMAPI:GetData("auctioningGroups")) do
			auctioningGroups[name] = name
		end
		local auctioningCategories = {["None"]="<No Category>"}
		for name in pairs(TSMAPI:GetData("auctioningCategories")) do
			auctioningCategories[name] = name
		end

		local page = {
			{
				type = "Label",
				text = L["Select the crafts you would like to add to Auctioning and use the settings / buttons below to do so."],
				relativeWidth = 1,
			},
			{
				type = "HeadingLine",
			},
			{
				type = "Dropdown",
				list = auctioningCategories,
				value = targetCategory,
				relativeWidth = 0.5,
				label = "Category to put groups into:",
				callback = function(_,_,value) targetCategory = value end,
				tooltip = L["You can select a category that group(s) will be added to or select \"<No Category>\" to not add the group(s) to a category."],
			},
			{
				type = "Dropdown",
				list = {["indivGroups"]=L["All in Individual Groups"], ["oneGroup"]=L["All in Same Group"]},
				value = groupStyle,
				relativeWidth = 0.5,
				label = L["How to add crafts to Auctioning:"],
				callback = function(self,_,value)
						groupStyle = value
						local i = getIndex(self.parent.children, self)
						self.parent.children[i+1]:SetDisabled(value ~= "oneGroup")
					end,
				tooltip = L["You can either add every craft to one group or make individual groups for each craft."],
			},
			{
				type = "Dropdown",
				list = auctioningGroups,
				relativeWidth = 0.5,
				value = groupSelection,
				label = L["Group to Add Crafts to:"],
				disabled = groupStyle ~= "oneGroup",
				callback = function(self,_,value)
						groupSelection = value
					end,
				tooltip = L["Select an Auctioning group to add these crafts to."],
			},
			{
				type = "CheckBox",
				label = L["Include Crafts Already in a Group"],
				value = moveCrafts,
				relativeWidth = 0.5,
				callback = function(_,_,value) moveCrafts = value end,
				tooltip = L["If checked, any crafts which are already in an Auctioning group will be removed from their current group and a new group will be created for them. If you want to maintain the groups you already have setup that include items in this group, leave this unchecked."],
			},
			{
				type = "CheckBox",
				label = L["Only Included Enabled Crafts"],
				value = onlyEnabled,
				relativeWidth = 1,
				callback = function(_,_,value) onlyEnabled = value end,
				tooltip = L["If checked, Only crafts that are enabled (have the checkbox to the right of the item link checked) below will be added to Auctioning groups."],
			},
			{
				type = "Button",
				text = L["Add Crafted Items from this Group to Auctioning Groups"],
				relativeWidth = 1,
				callback = function(self)
						local groups = TSMAPI:GetData("auctioningGroups")
						local function CreateGroupName(name)
							for i=1, 100 do -- it's the user's fault if they have more than 100 groups named this...
								local gName = strlower(name..(i==1 and "" or i))
								if not groups[gName] then
									return gName
								end
							end
						end

						local itemLookup = {}
						for groupName, items in pairs(groups) do
							for itemID in pairs(items) do
								itemLookup[itemID] = groupName
							end
						end

						local groupName
						local currentSlot = (TSM.mode == "Inscription" and TSM.Inscription:GetSlotList() or TSM[TSM.mode].slotList)[slot]
						if groupStyle == "oneGroup" then
							groupName = (groupSelection ~= "newGroup" and groupSelection or CreateGroupName(TSM.mode.." - "..currentSlot))
							TSM:SendMessage("TSMAUC_NEW_GROUP_ITEM", groupName, nil, groupSelection == "newGroup", targetCategory ~= "None" and targetCategory)
						end

						local count = 0
						for _, sData in pairs(sortedData) do
							local itemID = sData.originalIndex
							local data = TSM.Data[TSM.mode].crafts[itemID]
							if data.group == slot then
								-- make sure the item isn't already in a group (or the checkbox is checked to ignore this)
								if (not itemLookup[itemID] or moveCrafts) and (onlyEnabled and data.enabled or not onlyEnabled) then
									count = count + 1
									if not groupName then
										local tempName = CreateGroupName(GetItemInfo(itemID) or data.name)
										TSM:SendMessage("TSMAUC_NEW_GROUP_ITEM", tempName, itemID, true, targetCategory ~= "None" and targetCategory)
									else
										TSM:SendMessage("TSMAUC_NEW_GROUP_ITEM", groupName, itemID)
									end
								end
							end
						end

						if groupName then
							TSM:Print(format(L["Added %s crafted items to: %s."], count, "\""..groupName.."\""))
						else
							TSM:Print(format(L["Added %s crafted items to %s individual groups."], count, count))
						end
						self.parent:Hide()
					end,
				tooltip = L["Adds all items in this Crafting group to Auctioning group(s) as per the above settings."],
			},
		}

		TSMAPI:BuildPage(window, page)
	end

	local page = {
		{
			type = "ScrollFrame",
			layout = "Flow",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Help"],
					children = {
						{	-- label at the top of the page
							type = "Label",
							text = L["The checkboxes in next to each craft determine enable / disable the craft being shown in the Craft Management Window."],
							relativeWidth = 1,
						},
						{	-- add all button
							type = "Button",
							text = L["Enable All Crafts"],
							relativeWidth = 0.3,
							callback = function(self)
									for _, sData in pairs(sortedData) do
										local itemID = sData.originalIndex
										if TSM.Data[TSM.mode].crafts[itemID].group == slot then
											TSM.Data[TSM.mode].crafts[itemID].enabled = true
										end
									end
									GUI.TreeGroup:SelectByPath(1, slot)
								end,
						},
						{	-- add all button
							type = "Button",
							text = L["Disable All Crafts"],
							relativeWidth = 0.3,
							callback = function(self)
									for _, sData in pairs(sortedData) do
										local itemID = sData.originalIndex
										if TSM.Data[TSM.mode].crafts[itemID].group == slot then
											TSM.Data[TSM.mode].crafts[itemID].enabled = nil
										end
									end
									GUI.TreeGroup:SelectByPath(1, slot)
								end,
						},
						{	-- add all button
							type = "Button",
							text = L["Create Auctioning Groups"],
							disabled = not TSMAPI:GetData("auctioningCategories"), -- they don't have a recent enough version of auctioning
							relativeWidth = 0.4,
							callback = function(self) DrawCreateAuctioningGroups(self) end,
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Crafts"],
					children = {},
				},
			},
		},
	}

	if not select(4, GetAddOnInfo("TradeSkillMaster_Auctioning")) then
		for i, v in ipairs(page[1].children[1].children) do
			if v.text == L["Create Auctioning Groups"] then
				tremove(page[1].children[1].children, i)
				break
			end
		end
	end

	-- local variable to store the parent table to add children widgets to
	local inline = page[1].children[2].children

	-- Creates the widgets for the tab
	-- loops once for every craft contained in the tab
	for _, sData in pairs(sortedData) do
		local itemID = sData.originalIndex
		local data = TSM.Data[TSM.mode].crafts[itemID]
		if data.group == slot then

			-- The text below the links of each item
			local numCrafted = YELLOW .. (TSM.db.profile.craftHistory[data.spellID] or 0) .. "|r" .. WHITE

			-- calculations / widget for printing out the cost, lowest buyout, and profit of the scroll
			local cost, buyout, profit = TSM.Data:CalcPrices(data)
			if buyout and profit then
				local color = GREEN
				if profit <= 0 then color = RED end
				buyout = TSM:FormatTextMoney(buyout, CYAN, true)
				profit = (profit<=0 and RED.."-|r" or "")..(TSM:FormatTextMoney(abs(profit), color, true, true) or (RED..profit.."|cffffd700g|r"))
			else
				buyout = CYAN .. "?|r"
				profit = CYAN .. "?|r"
			end
			cost = TSM:FormatTextMoney(cost, CYAN, true, true) or (CYAN .. "?|r")
			local ts = "       " -- tabspace

			-- the line that lists the cost, buyout, and profit
			local rString = format(L["Cost: %s Market Value: %s Profit: %s Times Crafted: %s"],  cost..ts, buyout..ts, profit..ts, numCrafted)

			local inlineChildren = {
				{
					type = "CheckBox",
					relativeWidth = 0.05,
					value = data.enabled,
					tooltip = L["Enable / Disable showing this craft in the craft management window."],
					callback = function(_,_,value)
							if not value then
								data.queued = 0
							end
							data.enabled = value and true or nil
						end,
				},
				{
					type = "InteractiveLabel",
					text = select(2, GetItemInfo(itemID)) or data.name,
					fontObject = GameFontHighlight,
					relativeWidth = 0.61,
					callback = function() SetItemRef("item:".. itemID, itemID) end,
					tooltip = itemID,
				},
				{
					type = "Button",
					text = L["Additional Item Settings"],
					relativeWidth = 0.33,
					callback = function(self) ShowAdditionalSettings(self, itemID, data) end,
				},
				{
					type = "Label",
					text = rString,
					fontObject = GameFontWhite,
					fullWidth = true,
				},
				{
					type = "HeadingLine",
				},
			}

			foreach(inlineChildren, function(_, data) tinsert(inline, data) end)
		end
	end

	-- if no crafts have been added for this slot, show a message to alert the user
	if #(inline) == 0 then
		local text = L["No crafts have been added for this profession. Crafts are automatically added when you click on the profession icon while logged onto a character which has that profession."]
		tinsert(inline, {
				type = "Label",
				text = text,
				fullWidth=true,
			})
	else
		-- remove the last headingline
		tremove(inline)
	end

	TSMAPI:BuildPage(container, page)
end

-- Materials Page
function GUI:DrawMaterials(container)
	GUI:HookScript(container.frame, "OnHide", function()
			GUI:UnhookAll()
			if matST then
				matST:Hide()
			end
			if GUI.OpenWindow then
				GUI.OpenWindow:Hide()
			end
		end)

	if not TSMAPI.CreateScrollingTable then
		local page = {
			{
				type = "ScrollFrame",
				layout = "Flow",
				children = {
					{
						type = "InlineGroup",
						layout = "Flow",
						children = {
							{
								type = "Label",
								relativeWidth = 1,
								fontObject = GameFontNormalLarge,
								text = "Warning: This page requires v0.2.2 or higher of the main TSM addon. Please update yours in order to view this page. http://wow.curse.com/downloads/wow-addons/details/tradeskill-master.aspx",
							},
						},
					},
				},
			},
		}
		return TSMAPI:BuildPage(container, page)
	end

	local colData = {}
	local matList = TSM.Data:GetMats()
	local sources = {["craft"]=L["Craft"], ["mill"]=L["Mill"], ["vendor"]=L["Vendor"], ["vendortrade"]=L["Vendor Trade"], ["auction"]=L["Auction House"]}
	for i=1, #(matList) do
		local itemID = matList[i]
		local mat = TSM.Data[TSM.mode].mats[itemID]
		local name, link = GetItemInfo(itemID)
		link = link or mat.name
		name = name or mat.name
		local cost = TSM.Data:GetMatCost(TSM.mode, itemID)

		colData[i] = {
			cols = {
				{
					value = link,
					args = {name, ""},
				},
				{
					value = function(copper)
							if copper and copper < BIG_NUMBER and copper > 0 then
								return TSM:FormatTextMoney(copper)
							else
								return "---"
							end
						end,
					args = {cost, 0},
				},
				{
					value = function(rSource)
							return sources[rSource or ""] or L["Custom"]
						end,
					args = {mat.source, L["Custom"]},
				},
				{
					value = function(num) return num end,
					args = {TSM.Data:GetTotalQuantity(itemID)},
				},
			},
			itemID = itemID,
		}
	end

	local function ColSortMethod(st, aRow, bRow, col)
		local a, b = st:GetCell(aRow, col), st:GetCell(bRow, col)
		local column = st.cols[col]
		local direction = column.sort or column.defaultsort or "dsc"

		local aValue, bValue
		aValue = a.args[1] or a.args[2]
		bValue = b.args[1] or b.args[2]

		if direction == "asc" then
			return aValue < bValue
		else
			return aValue > bValue
		end
	end

	local matCols = {
		{
			name = L["Item Name"],
			width = 0.3,
			defaultsort = "asc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Mat Price"],
			width = 0.2,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Price Source"],
			width = 0.2,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Number Owned"],
			width = 0.2,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
	}

	local function GetColInfo(width)
		local colInfo = CopyTable(matCols)
		for i=1, #colInfo do
			colInfo[i].width = floor(colInfo[i].width*width)
		end

		return colInfo
	end

	local page = {
		{
			type = "SimpleGroup",
			layout = "Flow",
			fullHeight = true,
			children = {
				{
					type = "Label",
					text = L["You can click on one of the rows of the scrolling table below to view or adjust how the price of a material is calculated."],
					relativeWidth = 1,
				},
				{
					type = "HeadingLine",
				},
				{
					type = "SimpleGroup",
					layout = "Flow",
					fullHeight = true,
					children = {},
				},
			},
		},
	}
	TSMAPI:BuildPage(container, page)
	local stParent = container.children[1].children[3].frame

	local colInfo = GetColInfo(stParent:GetWidth())
	if not matST then
		matST = TSMAPI:CreateScrollingTable(colInfo)
	end
	matST.frame:SetParent(stParent)
	matST.frame:SetPoint("BOTTOMLEFT", 2, 2)
	matST.frame:SetPoint("TOPRIGHT", -2, -16)
	matST.frame:SetScript("OnSizeChanged", function(_,width, height)
			matST:SetDisplayCols(GetColInfo(width))
			matST:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
		end)
	matST:Show()
	matST:SetData(colData)

	local font, size = GameFontNormal:GetFont()
	for i, row in ipairs(matST.rows) do
		for j, col in ipairs(row.cols) do
			col.text:SetFont(font, size-1)
		end
	end

	matST:RegisterEvents({
		["OnClick"] = function(_, self, _, _, _, rowNum)
			if not rowNum then return end
			GUI:ShowMatOptionsWindow(self, colData[rowNum].itemID)
		end,
		["OnEnter"] = function(_, self, _, _, _, rowNum)
			if not rowNum then return end

			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetHyperlink("item:"..colData[rowNum].itemID)
			GameTooltip:Show()
		end,
		["OnLeave"] = function()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end})
end

function GUI:ShowMatOptionsWindow(parent, itemID)
	if GUI.OpenWindow then GUI.OpenWindow:Hide() end
	local mat = TSM.Data[TSM.mode].mats[itemID]
	if not mat then return end
	local link = select(2, GetItemInfo(itemID)) or mat.name
	local cost = TSM.Data:GetMatCost(TSM.mode, itemID)

	local window = AceGUI:Create("TSMWindow")
	window.frame:SetParent(parent)
	window:SetWidth(600)
	window:SetHeight(545)
	window:SetTitle(L["Material Cost Options"])
	window:SetLayout("Flow")
	window:EnableResize(false)
	window.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
	window:SetCallback("OnClose", function(self)
			self:ReleaseChildren()
			GUI.OpenWindow = nil
			window.frame:Hide()
		end)
	GUI.OpenWindow = window

	local RefreshPage

	local page = {
		{
			type = "InteractiveLabel",
			text = link,
			fontObject = GameFontHighlight,
			relativeWidth = 0.6,
			callback = function() SetItemRef("item:".. itemID, itemID) end,
			tooltip = itemID,
		},
		{
			type = "Label",
			text = CYAN..L["Price:"].." |r"..(TSM:FormatTextMoney(cost) or "---"),
			relativeWidth = 0.39,
		},
		{
			type = "HeadingLine",
		},
		{
			type = "ScrollFrame",
			layout = "Flow",
			fullHeight = true,
			children = {},
		},
	}

	TSMAPI:BuildPage(window, page)

	local function ChangeSource(newSource)
		mat.customMultiplier = nil
		mat.customID = nil
		mat.source = newSource
		return GUI:ShowMatOptionsWindow(parent, itemID)
	end

	local function GetMoneyText(copperValue, additionalRequirement)
		if mat.override and additionalRequirement ~= false then
			return TSM:FormatTextMoney(copperValue) or "---"
		else
			return TSM:FormatTextMoney(copperValue, "|cff777777", nil, nil, true) or "---"
		end
	end

	local prices = {}
	local matSources = {"auction", "vendor", "vendortrade", "craft", "mill", "customitem"}
	for i=1, #matSources do
		prices[matSources[i]] = TSM.Data:GetMatSourcePrice(TSM.mode, itemID, matSources[i])
	end

	if mat.source ~= "custom" then
		mat.customValue = nil
	end
	if mat.source ~= "customitem" then
		mat.customID = nil
		mat.customMultiplier = nil
	end

	local sPage = {
		{
			type = "SimpleGroup",
			layout = "Flow",
			children = {
				{
					type = "Label",
					text = L["Here you can view and adjust how Crafting is calculating the price for this material."],
					relativeWidth = 1,
				},
				{
					type = "HeadingLine",
				},
				{
					type = "CheckBox",
					label = L["Override Price Source"],
					relativeWidth = 1,
					value = mat.override,
					callback = function(_,_,value)
							mat.override = value and true or nil -- use nil instead of false to save space
							GUI:ShowMatOptionsWindow(parent, itemID)
						end,
					tooltip = L["If checked, you can change the price source for this mat by clicking on one of the checkboxes below. This source will be used to determine the price of this mat until you remove the override or change the source manually. If this setting is not checked, Crafting will automatically pick the cheapest source."],
				},
			},
		},
		{
			type = "InlineGroup",
			layout = "Flow",
			title = L["General Price Sources"],
			children = {
				{
					type = "CheckBox",
					label = GetMoneyText(prices.auction).." - "..L["Auction House Value"],
					relativeWidth = 1,
					disabled = not mat.override,
					value = mat.source == "auction",
					callback = function() ChangeSource("auction") end,
					tooltip = L["Use auction house data from the addon you have selected in the Crafting options for the value of this mat."],
				},
				{
					type = "HeadingLine"
				},
			},
		},
		{
			type = "Spacer",
		},
		{
			type = "InlineGroup",
			layout = "Flow",
			title = L["User-Defined Price"],
			children = {
				{
					type = "CheckBox",
					label = GetMoneyText(mat.customValue).." - "..L["Custom Value"],
					value = mat.source == "custom",
					relativeWidth = 0.6,
					disabled = not mat.override,
					callback = function() ChangeSource("custom") end,
					tooltip = L["Checking this box will allow you to set a custom, fixed price for this item."],
				},
				{
					type = "EditBox",
					label = L["Edit Custom Value"],
					value = mat.customValue and GetMoneyText(mat.customValue, (mat.source=="custom" or false)) or "",
					disabled = mat.source ~= "custom" or not mat.override,
					relativeWidth = 0.39,
					callback = function(self,_,value)
							mat.customID = nil
							mat.customMultiplier = nil
							local copper = TSM:GetMoneyValue(value:trim())
							if copper and copper ~= 0 then
								mat.customValue = copper
								GUI:ShowMatOptionsWindow(parent, itemID)
							else
								self:SetFocus()
								TSM:Print(L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."])
							end
						end,
					tooltip = L["Enter a value that Crafting will use as the cost of this material."],
				},
				{
					type = "CheckBox",
					label = GetMoneyText(prices.customItem).." - "..L["Multiple of Other Item Cost"],
					value = mat.source == "customitem",
					relativeWidth = 0.6,
					disabled = not mat.override,
					callback = function()
							mat.source = "customitem",
							GUI:ShowMatOptionsWindow(parent, itemID)
							GUI:ShowMatOptionsWindow(parent, itemID)
						end,
					tooltip = L["This will allow you to base the price of this item on the price of some other item times a multiplier. Be careful not to create circular dependencies (ie Item A is based on the cost of Item B and Item B is based on the price of Item A)!"],
				},
				{
					type = "InteractiveLabel",
					text = mat.customID and (select(2, GetItemInfo(mat.customID)) or "item:"..mat.customID) or (mat.override and "---" or "|cff777777---|r"),
					fontObject = GameFontHighlight,
					disabled = not mat.override,
					relativeWidth = 0.39,
					callback = function() if mat.customID then SetItemRef("item:"..mat.customID, mat.customID) end end,
					tooltip = mat.customID or "",
				},
				{
					type = "Label",
					relativeWidth = 0.1,
				},
				{
					type = "EditBox",
					label = L["Other Item"],
					value = mat.customID and (select(2, GetItemInfo(mat.customID)) or mat.customID) or "",
					disabled = mat.source ~= "customitem",
					relativeWidth = 0.55,
					callback = function(self,_,value)
							value = tonumber(value) or (strfind(value, "item:") and TSMAPI:GetItemID(value))
							if value then
								mat.customID = value
								mat.source = "customitem",
								GUI:ShowMatOptionsWindow(parent, itemID)
								GUI:ShowMatOptionsWindow(parent, itemID)
							else
								self:SetFocus()
								TSM:Print(L["Invalid item entered. You can either link the item into this box or type in the itemID from wowhead."])
							end
						end,
					tooltip = L["The item you want to base this mat's price on. You can either link the item into this box or type in the itemID from wowhead."],
				},
				{
					type = "Label",
					relativeWidth = 0.05,
				},
				{
					type = "EditBox",
					label = L["Price Multiplier"],
					value = mat.customMultiplier or "",
					disabled = mat.source ~= "customitem",
					relativeWidth = 0.29,
					callback = function(self,_,value)
							if tonumber(value) then
								mat.customMultiplier = value
								GUI:ShowMatOptionsWindow(parent, itemID)
								GUI:ShowMatOptionsWindow(parent, itemID)
							else
								self:SetFocus()
								TSM:Print(L["Invalid Number"])
							end
						end,
					tooltip = L["Enter what you want to multiply the cost of the other item by to calculate the price of this mat."],
				},
			},
		},
		{
			type = "Spacer",
		},
	}

	if prices.vendor then
		tinsert(sPage[2].children, 2, {
				type = "CheckBox",
				label = GetMoneyText(prices.vendor).." - "..L["Buy From Vendor"],
				relativeWidth = 1,
				disabled = not mat.override,
				value = mat.source == "vendor",
				callback = function() ChangeSource("vendor") end,
				tooltip = L["Use the price that a vendor sells this item for as the cost of this material."],
			})
	end

	if prices.vendortrade then -- vendor trade
		local tradeItemID, tradeQuantity = TSM:GetItemVendorTrade(itemID)
		local widgets = {
			{
				type = "CheckBox",
				label = GetMoneyText(prices.vendortrade).." - "..format(L["Vendor Trade (x%s)"], (floor((tradeQuantity)*100)/100)),
				relativeWidth = 0.6,
				disabled = not mat.override,
				value = mat.source == "vendortrade",
				callback = function() ChangeSource("vendortrade") end,
			},
			{
				type = "InteractiveLabel",
				text = select(2, GetItemInfo(tradeItemID)) or "item:"..tradeItemID,
				fontObject = GameFontHighlight,
				relativeWidth = 0.39,
				callback = function() SetItemRef("item:"..tradeItemID, tradeItemID) end,
				tooltip = tradeItemID,
			},
		}
		for i=1, #widgets do
			tinsert(sPage[2].children, widgets[i])
		end
	end
	if TSM.mode == "Inscription" and prices.mill then -- milling
		local _,pigmentData = TSM.Inscription:GetInkFromPigment(itemID)
		tinsert(sPage[2].children, {
				type = "Label",
				text = L["Note: By default, Crafting will use the second cheapest value (herb or pigment cost) to calculate the cost of the pigment as this provides a slightly more accurate value."],
				relativeWidth = 1,
			})
		local widgets = {
			{
				type = "CheckBox",
				label = GetMoneyText(prices.mill).." - "..L["Milling"],
				relativeWidth = 1,
				disabled = not mat.override,
				value = mat.source == "mill",
				callback = function() ChangeSource("mill") end,
				tooltip = L["Use the price of buying herbs to mill as the cost of this material."],
			},
		}
		for i=1, #widgets do
			tinsert(sPage[2].children, widgets[i])
		end
		for i=1, #pigmentData.herbs do
			local herbID = pigmentData.herbs[i].itemID
			local pigmentPerMill = pigmentData.herbs[i].pigmentPerMill
			local cost = floor(TSM.Data:GetItemMarketPrice(herbID, "mat")*5/pigmentPerMill + 0.5)
			local widgets = {
				{
					type = "Label",
					relativeWidth = 0.1,
				},
				{
					type = "InteractiveLabel",
					text = select(2, GetItemInfo(herbID)) or "item:"..herbID,
					fontObject = GameFontHighlight,
					relativeWidth = 0.49,
					callback = function() SetItemRef("item:"..herbID, herbID) end,
					tooltip = herbID,
				},
				{
					type = "Label",
					text = (mat.override and "|cffffffff" or "|cff777777")..GetMoneyText(cost).." "..L["per pigment"],
					relativeWidth = 0.4,
				},
			}
			for i=1, #widgets do
				tinsert(sPage[2].children, widgets[i])
			end
		end
	end
	if prices.craft then
		local craft = TSM.Data[TSM.mode].crafts[itemID]
		local inkMatInfo = TSM.Inscription:GetInkMats(itemID)
		local widgets = {
			{
				type = "CheckBox",
				label = GetMoneyText(prices.craft).." - "..format(L["Craft Item (x%s)"], floor((1/craft.numMade)*100)/100),
				relativeWidth = 0.6,
				disabled = not mat.override,
				value = mat.source == "craft",
				callback = function() ChangeSource("craft") end,
			},
			{
				type = "InteractiveLabel",
				text = GetSpellLink(craft.spellID),
				fontObject = GameFontHighlight,
				relativeWidth = 0.39,
				callback = function() SetItemRef("enchant:"..craft.spellID, craft.spellID) end,
				tooltip = tostring(craft.spellID),
			},
			{
				type = "Label",
				text = L["NOTE: Milling prices can be viewed / adjusted in the mat options for pigments. Click on the button below to go to the pigment options."],
				relativeWidth = 1,
			},
			{
				type = "Button",
				text = L["Open Mat Options for Pigment"],
				relativeWidth = 1,
				callback = function() GUI:ShowMatOptionsWindow(parent, inkMatInfo.pigment) end,
			},
			{
				type = "HeadingLine",
			},
		}
		if not (TSM.mode == "Inscription" and inkMatInfo) then
			tremove(widgets, #widgets)
			tremove(widgets, #widgets)
		end
		for i=1, #widgets do
			tinsert(sPage[2].children, widgets[i])
		end
	end

	if window.children[4] then
		window.children[4]:ReleaseChildren()
	end
	TSMAPI:BuildPage(window.children[4], sPage)
end

-- Profession Options Page
function GUI:DrawProfessionOptions(container)
	-- scroll frame to contain everything
	local page = {
		{
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["General Setting Overrides"],
					children = {
						{
							type = "Label",
							text = L["Here, you can override general settings."],
							fullWidth = true,
						},
						{
							type = "HeadingLine",
						},
						{
							type = "CheckBox",
							label = L["Override Craft Sort Method"],
							value = TSM.db.profile.craftSortMethod[TSM.mode] and true,
							relativeWidth = 0.5,
							callback = function(self, _, value)
									if value then
										TSM.db.profile.craftSortMethod[TSM.mode] = TSM.db.profile.craftSortMethod.default
									else
										TSM.db.profile.craftSortMethod[TSM.mode] = nil
									end

									local i = getIndex(self.parent.children, self)
									self.parent.children[i+1]:SetDisabled(not value)
								end,
							tooltip = L["Allows you to set a different craft sort method for this profession."],
						},
						{
							type = "Dropdown",
							label = L["Sort Crafts By"],
							list = {["name"]=L["Name"], ["cost"]=L["Cost to Craft"], ["profit"]=L["Profit"], ["scount"]=L["Seen Count"], ["ccount"]=L["Times Crafted"], ["ilvl"]=L["Item Level"]},
							value = TSM.db.profile.craftSortMethod[TSM.mode],
							disabled = TSM.db.profile.craftSortMethod[TSM.mode] == nil,
							relativeWidth = 0.49,
							callback = function(_,_,value)
									TSM.db.profile.craftSortMethod[TSM.mode] = value
								end,
							tooltip = L["This setting determines how crafts are sorted in the craft group pages (NOT the Craft Management Window)."],
						},
						{
							type = "CheckBox",
							label = L["Override Craft Sort Order"],
							value = TSM.db.profile.craftSortOrder[TSM.mode] and true,
							relativeWidth = 0.5,
							callback = function(self, _, value)
									if value then
										TSM.db.profile.craftSortOrder[TSM.mode] = TSM.db.profile.craftSortOrder.default
									else
										TSM.db.profile.craftSortOrder[TSM.mode] = nil
									end

									local siblings = self.parent.children
									local i = getIndex(siblings, self)
									if value then
										siblings[i+1]:SetColor(1, 1, 1)
									else
										siblings[i+1]:SetColor(0.5, 0.5, 0.5)
									end
									siblings[i+2]:SetDisabled(not value)
									siblings[i+2]:SetValue(TSM.db.profile.craftSortOrder[TSM.mode] == "ascending")
									siblings[i+3]:SetDisabled(not value)
									siblings[i+3]:SetValue(TSM.db.profile.craftSortOrder[TSM.mode] == "descending")
								end,
							tooltip = L["Allows you to set a different craft sort order for this profession."],
						},
						{
							type = "Label",
							text = L["Sort Order:"],
							relativeWidth = 0.12,
							colorRed = TSM.db.profile.craftSortOrder[TSM.mode] == nil and 0.5 or 1,
							colorGreen = TSM.db.profile.craftSortOrder[TSM.mode] == nil and 0.5 or 1,
							colorBlue = TSM.db.profile.craftSortOrder[TSM.mode] == nil and 0.5 or 1,
						},
						{
							type = "CheckBox",
							label = L["Ascending"],
							cbType = "radio",
							relativeWidth = 0.16,
							value = TSM.db.profile.craftSortOrder[TSM.mode] == "ascending",
							disabled = TSM.db.profile.craftSortOrder[TSM.mode] == nil,
							callback = function(self,_,value)
									if value then
										TSM.db.profile.craftSortOrder[TSM.mode] = "ascending"
										local i = getIndex(self.parent.children, self)
										self.parent.children[i+1]:SetValue(false)
									end
								end,
							tooltip = L["Sort crafts in ascending order."],
						},
						{
							type = "CheckBox",
							label = L["Descending"],
							cbType = "radio",
							relativeWidth = 0.16,
							value = TSM.db.profile.craftSortOrder[TSM.mode] == "descending",
							disabled = TSM.db.profile.craftSortOrder[TSM.mode] == nil,
							callback = function(self,_,value)
									if value then
										TSM.db.profile.craftSortOrder[TSM.mode] = "descending"
										local i = getIndex(self.parent.children, self)
										self.parent.children[i-1]:SetValue(false)
									end
								end,
							tooltip = L["Sort crafts in descending order."],
						},
						{
 							type = "HeadingLine",
 						},
 						{
 							type = "Label",
 							text = L["Min ilvl to craft:"],
 							relativeWidth = 0.12,
 						},
 						{
 							type = "CheckBox",
 							label = L["Place lower limit on ilvl to craft"],
 							value = TSM.db.profile.limitIlvl[TSM.mode] and true,
 							relativeWidth = 0.5,
 							callback = function(self, _, value)
 									if value then
 										TSM.db.profile.limitIlvl[TSM.mode] = true
 									else
 										TSM.db.profile.limitIlvl[TSM.mode] = nil
 									end
 									local siblings = self.parent.children --aw how cute...siblings ;)
 									local i = getIndex(siblings, self)
 									siblings[i+1]:SetDisabled(not value)
 									siblings[i+1]:SetText(TSM.db.profile.minilvlToCraft[TSM.mode] or "")
 								end,
 							tooltip = L["Allows you to set a custom minimum ilvl to queue."],
 						},
 
 						{
 							type = "EditBox",
 							label = L["Min Craft ilvl"],
 							value = TSM.db.profile.minilvlToCraft[TSM.mode],
 							disabled = TSM.db.profile.limitIlvl[TSM.mode] == nil,
 							relativeWidth = 0.2,
 							callback = function(self, _, value)
 									value = tonumber(value)
 									if value and value >= 0 then
 										TSM.db.profile.minilvlToCraft[TSM.mode] = tonumber(value)
 									end
 								end,
 						},
					}
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Restock Queue Overrides"],
					children = {
						{
							type = "Label",
							text = L["Here, you can override default restock queue settings."],
							fullWidth = true,
						},
						{
							type = "HeadingLine",
						},
						{
							type = "CheckBox",
							label = L["Override Max Restock Quantity"],
							value = TSM.db.profile.maxRestockQuantity[TSM.mode] and true,
							relativeWidth = 0.5,
							callback = function(self, _, value)
									if value then
										TSM.db.profile.maxRestockQuantity[TSM.mode] = TSM.db.profile.maxRestockQuantity.default
									else
										TSM.db.profile.maxRestockQuantity[TSM.mode] = nil
									end
									local siblings = self.parent.children --aw how cute...siblings ;)
									local i = getIndex(siblings, self)
									siblings[i+2]:SetDisabled(not value)
									siblings[i+2]:SetText(TSM.db.profile.maxRestockQuantity[TSM.mode] or "")
									siblings[i+3]:SetDisabled(not value)
									siblings[i+4]:SetDisabled(not value)
								end,
							tooltip = L["Allows you to set a custom maximum queue quantity for this profession."],
						},
						{
							type = "Label",
							text = "",
							relativeWidth = 0.1,
						},
						{
							type = "EditBox",
							label = L["Max Restock Quantity"],
							value = TSM.db.profile.maxRestockQuantity[TSM.mode],
							disabled = TSM.db.profile.maxRestockQuantity[TSM.mode] == nil,
							relativeWidth = 0.2,
							callback = function(self, _, value)
									value = tonumber(value)
									if value and value >= 0 then
										TSM.db.profile.maxRestockQuantity[TSM.mode] = value
									end
								end,
						},
						{	-- plus sign for incrementing the number
							type = "Icon",
							image = "Interface\\Buttons\\UI-PlusButton-Up",
							width = 24,
							imageWidth = 24,
							imageHeight = 24,
							disabled = TSM.db.profile.maxRestockQuantity[TSM.mode] == nil,
							callback = function(self)
									local value = (TSM.db.profile.maxRestockQuantity[TSM.mode] or 0) + 1
									TSM.db.profile.maxRestockQuantity[TSM.mode] = value

									local i = getIndex(self.parent.children, self)
									self.parent.children[i-1]:SetText(value)
								end,
						},
						{	-- minus sign for decrementing the number
							type = "Icon",
							image = "Interface\\Buttons\\UI-MinusButton-Up",
							disabled = true,
							width = 24,
							imageWidth = 24,
							imageHeight = 24,
							disabled = TSM.db.profile.maxRestockQuantity[TSM.mode] == nil,
							callback = function(self)
									local value = (TSM.db.profile.maxRestockQuantity[TSM.mode] or 0) - 1
									if value < 1 then value = 0 end

									if value < (TSM.db.profile.minRestockQuantity[TSM.mode] or TSM.db.profile.minRestockQuantity.default) then
										value = TSM.db.profile.minRestockQuantity[TSM.mode] or TSM.db.profile.minRestockQuantity.default
										TSM:Print(format(L["Can not set a max restock quantity below the minimum restock quantity of %d."], value))
									end
									TSM.db.profile.maxRestockQuantity[TSM.mode] = value

									local i = getIndex(self.parent.children, self)
									self.parent.children[i-2]:SetText(value)
								end,
						},
						{
							type = "CheckBox",
							label = L["Override Min Restock Quantity"],
							value = TSM.db.profile.minRestockQuantity[TSM.mode] and true,
							relativeWidth = 0.6,
							callback = function(self, _, value)
									if value then
										TSM.db.profile.minRestockQuantity[TSM.mode] = TSM.db.profile.minRestockQuantity.default
									else
										TSM.db.profile.minRestockQuantity[TSM.mode] = nil
									end

									local siblings = self.parent.children --aw how cute...siblings ;)
									local i = getIndex(siblings, self)
									siblings[i+1]:SetDisabled(not value)
									siblings[i+1]:SetText(TSM.db.profile.minRestockQuantity[TSM.mode] or "")
									siblings[i+2]:SetDisabled(not value)
									siblings[i+3]:SetDisabled(not value)
								end,
							tooltip = L["Allows you to set a custom minimum queue quantity for this profession."],
						},
						{
							type = "EditBox",
							label = L["Min Restock Quantity"],
							value = TSM.db.profile.minRestockQuantity[TSM.mode],
							disabled = TSM.db.profile.minRestockQuantity[TSM.mode] == nil,
							relativeWidth = 0.2,
							callback = function(_, _, value)
									value = tonumber(value)
									if value and value >= 0 then
										TSM.db.profile.minRestockQuantity[TSM.mode] = value
									end
								end,
							tooltip = L["This item will only be added to the queue if the number being added " ..
								"is greater than or equal to this number. This is useful if you don't want to bother with " ..
								"crafting singles for example."],
						},
						{	-- plus sign for incrementing the number
							type = "Icon",
							image = "Interface\\Buttons\\UI-PlusButton-Up",
							width = 24,
							imageWidth = 24,
							imageHeight = 24,
							disabled = TSM.db.profile.minRestockQuantity[TSM.mode] == nil,
							callback = function(self)
									local value = (TSM.db.profile.minRestockQuantity[TSM.mode] or 0) + 1
									if value > (TSM.db.profile.maxRestockQuantity[TSM.mode] or TSM.db.profile.maxRestockQuantity.default) then
										value = TSM.db.profile.maxRestockQuantity[TSM.mode] or TSM.db.profile.maxRestockQuantity.default
										TSM:Print(format("Can not set a min restock quantity above the max restock quantity of %d.", value))
									end
									TSM.db.profile.minRestockQuantity[TSM.mode] = value

									local i = getIndex(self.parent.children, self)
									self.parent.children[i-1]:SetText(value)
								end,
						},
						{	-- minus sign for decrementing the number
							type = "Icon",
							image = "Interface\\Buttons\\UI-MinusButton-Up",
							disabled = true,
							width = 24,
							imageWidth = 24,
							imageHeight = 24,
							disabled = TSM.db.profile.minRestockQuantity[TSM.mode] == nil,
							callback = function(self)
									local value = TSM.db.profile.minRestockQuantity[TSM.mode] - 1
									if value < 1 then value = 1 end
									TSM.db.profile.minRestockQuantity[TSM.mode] = tonumber(value)

									local i = getIndex(self.parent.children, self)
									self.parent.children[i-2]:SetText(value)
								end,
						},
						{
							type = "HeadingLine",
						},
						{
							type = "CheckBox",
							label = L["Override Minimum Profit"],
							value = TSM.db.profile.queueProfitMethod[TSM.mode] ~= nil,
							relativeWidth = 0.5,
							callback = function(self, _, value)
									if value then
										TSM.db.profile.queueProfitMethod[TSM.mode] = TSM.db.profile.queueProfitMethod.default
										TSM.db.profile.queueMinProfitGold[TSM.mode] = TSM.db.profile.queueMinProfitGold.default
										TSM.db.profile.queueMinProfitPercent[TSM.mode] = TSM.db.profile.queueMinProfitPercent.default
									else
										TSM.db.profile.queueProfitMethod[TSM.mode] = nil
										TSM.db.profile.queueMinProfitGold[TSM.mode] = nil
										TSM.db.profile.queueMinProfitPercent[TSM.mode] = nil
									end
									GUI.TreeGroup:SelectByPath(3)
								end,
							tooltip = L["Allows you to override the minimum profit settings for this profession."],
						},
						{	-- dropdown to select the method for setting the Minimum profit for the main crafts page
							type = "Dropdown",
							label = L["Minimum Profit Method"],
							list = {["gold"]=L["Gold Amount"], ["percent"]=L["Percent of Cost"],
								["none"]=L["No Minimum"], ["both"]=L["Percent and Gold Amount"]},
							value = TSM.db.profile.queueProfitMethod[TSM.mode],
							disabled = TSM.db.profile.queueProfitMethod[TSM.mode] == nil,
							relativeWidth = 0.49,
							callback = function(self,_,value)
									TSM.db.profile.queueProfitMethod[TSM.mode] = value
									GUI.TreeGroup:SelectByPath(3)
								end,
							tooltip = L["You can choose to specify a minimum profit amount (in gold or by " ..
								"percent of cost) for what crafts should be added to the craft queue."],
						},
						{
							type = "Slider",
							value = TSM.db.profile.queueMinProfitPercent[TSM.mode] or TSM.db.profile.queueMinProfitPercent.default or 0,
							label = L["Minimum Profit (in %)"],
							tooltip = L["If enabled, any craft with a profit over this percent of the cost will be added to " ..
								"the craft queue when you use the \"Restock Queue\" button."],
							min = 0,
							max = 2,
							step = 0.01,
							relativeWidth = 0.49,
							isPercent = true,
							disabled = TSM.db.profile.queueProfitMethod[TSM.mode] == nil or TSM.db.profile.queueProfitMethod[TSM.mode] == "none" or TSM.db.profile.queueProfitMethod[TSM.mode] == "gold",
							callback = function(_,_,value)
									TSM.db.profile.queueMinProfitPercent[TSM.mode] = floor(value*100)/100
								end,
						},
						{
							type = "Slider",
							value = TSM.db.profile.queueMinProfitGold[TSM.mode] or TSM.db.profile.queueMinProfitGold.default or 0,
							label = L["Minimum Profit (in gold)"],
							tooltip = L["If enabled, any craft with a profit over this value will be added to the craft queue " ..
								"when you use the \"Restock Queue\" button."],
							min = 0,
							max = 300,
							step = 1,
							relativeWidth = 0.49,
							disabled = TSM.db.profile.queueProfitMethod[TSM.mode] == nil or TSM.db.profile.queueProfitMethod[TSM.mode] == "none" or TSM.db.profile.queueProfitMethod[TSM.mode] == "percent",
							callback = function(_,_,value)
									TSM.db.profile.queueMinProfitGold[TSM.mode] = floor(value)
								end,
						},
					},
				},
			},
		},
	}

	if TSM.mode == "Inscription" then
		tinsert(page[1].children, 1, {
				type = "InlineGroup",
				layout = "flow",
				title = L["Profession-Specific Settings"],
				children = {
					{	-- dropdown to select how to calculate material costs
						type = "Dropdown",
						label = L["Group Inscription Crafts By:"],
						list = {L["Ink"], L["Class"]},
						value = TSM.db.profile.inscriptionGrouping,
						relativeWidth = 0.49,
						callback = function(_,_,value)
								TSM.db.profile.inscriptionGrouping = value
								for itemID, craft in pairs(TSM.Data["Inscription"].crafts) do
									craft.group = TSM.Inscription:GetSlot(itemID, craft.mats)
								end

								-- clicks on the icon in order to reload the treeGroup
								for i=1, #TSM.tradeSkills do
									if TSM.tradeSkills[i].name == TSM.mode then
										TSMAPI:SelectIcon("TradeSkillMaster_Crafting", "Crafting - "..GetSpellInfo(TSM.tradeSkills[i].spellID))
										break
									end
								end
								GUI.TreeGroup:SelectByPath(3)
							end,
						tooltip = L["Inscription crafts can be grouped in TradeSkillMaster_Crafting either by class or by the ink required to make them."],
					},
				},
			})
	end

	TSMAPI:BuildPage(container, page)
end

-- Options Page
function GUI:DrawOptions(container)
	local tg = AceGUI:Create("TSMTabGroup")
	tg:SetLayout("Fill")
	tg:SetFullHeight(true)
	tg:SetFullWidth(true)
	tg:SetTabs({{value=1, text=L["General Settings"]}, {value=2, text=L["Price / Inventory Settings"]}, {value=3, text=L["Queue Settings"]}, {value=4, text=L["Profiles"]}})
	container:AddChild(tg)

	local ddList1 = {["Manual"] = L["Manual Entry"]}
	if select(4, GetAddOnInfo("Auc-Advanced")) == 1 then
		ddList1["AucMarket"]=L["Auctioneer - Market Value"]
		ddList1["AucAppraiser"]=L["Auctioneer - Appraiser"]
		ddList1["AucMinBuyout"]=L["Auctioneer - Minimum Buyout"]
	end

	if select(4, GetAddOnInfo("Auctionator")) == 1 then
		ddList1["AtrValue"]=L["Auctionator - Auction Value"]
	end
	if select(4, GetAddOnInfo("TheUndermineJournal")) == 1 then
		ddList1["TUJMarket"]=L["TheUndermineJournal - Market Price"]
		ddList1["TUJMean"]=L["TheUndermineJournal - Mean"]
	end

	if select(4, GetAddOnInfo("TradeSkillMaster_AuctionDB")) == 1 then
		ddList1["DBMarket"]=L["AuctionDB - Market Value"]
		ddList1["DBMinBuyout"]=L["AuctionDB - Minimum Buyout"]
	end
	local ddList2 = CopyTable(ddList1)
	ddList2["Manual"] = nil

	local function GetTab(num)
		local altCharacters, altGuilds, altCharactersValue, altGuildsValue = {}, {}, {}, {}
		if TSM.db.profile.altAddon == "DataStore" and DataStore and DataStore.GetCharacters and DataStore.GetGuilds then
			if TSM.db.profile.altCharacters == nil then
				for account in pairs(DataStore:GetAccounts()) do
					for name, character in pairs(DataStore:GetCharacters(nil, account)) do
						TSM.db.profile.altCharacters[name] = true
					end
				end
			end
			for account in pairs(DataStore:GetAccounts()) do
				for name, character in pairs(DataStore:GetCharacters(nil, account)) do
					tinsert(altCharacters, name)
					tinsert(altCharactersValue, TSM.db.profile.altCharacters[name] or false)
				end
			end

			if TSM.db.profile.altGuilds == nil then
				for account in pairs(DataStore:GetAccounts()) do
					for name in pairs(DataStore:GetGuilds(nil, account)) do
						TSM.db.profile.altGuilds[name] = true
					end
				end
			end
			for account in pairs(DataStore:GetAccounts()) do
				for name in pairs(DataStore:GetGuilds(nil, account)) do
					tinsert(altGuilds, name)
					tinsert(altGuildsValue, TSM.db.profile.altGuilds[name] or false)
				end
			end
		elseif TSM.db.profile.altAddon == "Gathering" and select(4, GetAddOnInfo("TradeSkillMaster_Gathering")) == 1 then
			altCharacters = TSMAPI:GetData("playerlist")
			altGuilds = TSMAPI:GetData("guildlist")

			for _, name in pairs(altCharacters) do
				tinsert(altCharactersValue, TSM.db.profile.altCharacters[name] or false)
			end
			for _, name in pairs(altGuilds) do
				tinsert(altGuildsValue, TSM.db.profile.altGuilds[name] or false)
			end
		end

		local addonList, fullAddonList = {}, {["DataStore"] = L["DataStore"], ["Gathering"] = L["Gathering"]}
		if select(4, GetAddOnInfo("DataStore_Auctions")) == 1 and DataStore then
			addonList["DataStore"] = L["DataStore"]
		end
		if select(4, GetAddOnInfo("TradeSkillMaster_Gathering")) == 1 then
			addonList["Gathering"] = L["Gathering"]
		end

		local unknownProfitList = {["unknown"]=L["Mark as Unknown (\"----\")"]}
		if not select(2, TSMAPI:GetData("auctioningFallback")) then
			unknownProfitList["fallback"] = L["Set Crafted Item Cost to Auctioning Fallback"]
		end

		local page = {}

		page[1] = {
			{	-- scroll frame to contain everything
				type = "ScrollFrame",
				layout = "List",
				children = {
					{
						type = "InlineGroup",
						layout = "flow",
						title = L["General Settings"],
						children = {
							{
								type = "CheckBox",
								label = L["Show Crafting Cost in Tooltip"],
								relativeWidth = 0.5,
								value = TSM.db.profile.tooltip,
								callback = function(self,_,value)
										if value then
											TSMAPI:RegisterTooltip("TradeSkillMaster_Crafting", function(...) return TSM:LoadTooltip(...) end)
										else
											TSMAPI:UnregisterTooltip("TradeSkillMaster_Crafting")
										end
										TSM.db.profile.tooltip = value
									end,
								tooltip = L["If checked, the crafting cost of items will be shown in the tooltip for the item."],
							},
						},
					},
					{
						type = "InlineGroup",
						layout = "flow",
						title = L["Profession Page Settings"],
						children = {
							{
								type = "Dropdown",
								label = L["Sort Crafts By"],
								list = {["name"]=L["Name"], ["cost"]=L["Cost to Craft"], ["profit"]=L["Profit"], ["scount"]=L["Seen Count"], ["ccount"]=L["Times Crafted"], ["ilvl"]=L["Item Level"]},
								value = TSM.db.profile.craftSortMethod.default,
								relativeWidth = 0.49,
								callback = function(_,_,value)
										TSM.db.profile.craftSortMethod.default = value
									end,
								tooltip = L["This setting determines how crafts are sorted in the craft group pages (NOT the Craft Management Window)."],
							},
							{
								type = "Label",
								text = "",
								relativeWidth = 0.06,
							},
							{
								type = "Label",
								text = L["Sort Order:"],
								relativeWidth = 0.12,
							},
							{
								type = "CheckBox",
								label = L["Ascending"],
								cbType = "radio",
								relativeWidth = 0.16,
								value = TSM.db.profile.craftSortOrder.default == "ascending",
								callback = function(self,_,value)
										if value then
											TSM.db.profile.craftSortOrder.default = "ascending"
											local i = getIndex(self.parent.children, self)
											self.parent.children[i+1]:SetValue(false)
										end
									end,
								tooltip = L["Sort crafts in ascending order."],
							},
							{
								type = "CheckBox",
								label = L["Descending"],
								cbType = "radio",
								relativeWidth = 0.16,
								value = TSM.db.profile.craftSortOrder.default == "descending",
								callback = function(self,_,value)
										if value then
											TSM.db.profile.craftSortOrder.default = "descending"
											local i = getIndex(self.parent.children, self)
											self.parent.children[i-1]:SetValue(false)
										end
									end,
								tooltip = L["Sort crafts in descending order."],
							},
							{
								type = "CheckBox",
								label = L["Enable New TradeSkills"],
								relativeWidth = 0.5,
								value = TSM.db.profile.enableNewTradeskills,
								callback = function(self,_,value)
										TSM.db.profile.enableNewTradeskills = value
									end,
								tooltip = L["If checked, when Crafting scans a tradeskill for the first time (such as after you learn a new one), it will be enabled by default."],
							},
						},
					},
					{
						type = "InlineGroup",
						layout = "flow",
						title = L["Craft Management Window Settings"],
						children = {
							{	-- dropdown to select the method for setting the Minimum profit for the main crafts page
								type = "Dropdown",
								label = L["Unknown Profit Queuing"],
								list = unknownProfitList,
								value = TSM.db.profile.unknownProfitMethod.default,
								relativeWidth = 0.49,
								callback = function(self,_,value)
										TSM.db.profile.unknownProfitMethod.default = value
									end,
								tooltip = L["This will determine how items with unknown profit are dealt with in the Craft Management Window. If you have the Auctioning module installed and an item is in an Auctioning group, the fallback for the item can be used as the market value of the crafted item (will show in light blue in the Craft Management Window)."],
							},
							{
								type = "CheckBox",
								value = TSM.db.profile.showPercentProfit,
								label = L["Show Profit Percentages"],
								relativeWidth = 0.5,
								callback = function(_,_,value) TSM.db.profile.showPercentProfit = value end,
								tooltip = L["If checked, the profit percent (profit/sell price) will be shown next to the profit in the craft management window."],
							},
							{	-- slider to set the stock number
								type = "Slider",
								value = TSM.db.profile.craftManagementWindowScale,
								label = L["Frame Scale"],
								isPercent = true,
								min = 0.5,
								max = 2,
								step = 0.01,
								relativeWidth = 0.49,
								callback = function(_,_,value)
										TSM.db.profile.craftManagementWindowScale = value
										if TSM.Crafting.frame and TSM.Crafting.openCloseButton then
											TSM.Crafting.openCloseButton:SetScale(value)
											TSM.Crafting.frame:SetScale(value)
										end
									end,
								tooltip = L["This will set the scale of the craft management window. Everything inside the window will be scaled by this percentage."],
							},
							{	-- slider to set the stock number
								type = "Slider",
								value = TSM.db.profile.doubleClick,
								label = L["Double Click Queue"],
								min = 2,
								max = 10,
								step = 1,
								relativeWidth = 0.49,
								callback = function(self,_,value)
										value = floor(value + 0.5)
										if value < 2 then value = 2 end
										if value > 10 then value = 10 end
										self:SetValue(value)
										TSM.db.profile.doubleClick = value
									end,
								tooltip = L["When you double click on a craft in the top-left portion (queuing portion) of the craft management window, it will increment/decrement this many times."],
							},
						},
					},
				},
			},
		}

		page[2] = {
			{	-- scroll frame to contain everything
				type = "ScrollFrame",
				layout = "List",
				children = {
					{
						type = "InlineGroup",
						layout = "flow",
						title = L["Price Settings"],
						children = {
							{	-- dropdown to select how to calculate material costs
								type = "Dropdown",
								label = L["Get Mat Prices From:"],
								list = ddList1,
								value = TSM.db.profile.matCostSource,
								relativeWidth = 0.49,
								callback = function(_,_,value)
										TSM.db.profile.matCostSource = value
									end,
								tooltip = L["This is where TradeSkillMaster_Crafting will get material prices. AuctionDB is TradeSkillMaster's auction house data module. Alternatively, prices can be entered manually in the \"Materials\" pages."],
							},
							{	-- dropdown to select how to calculate material costs
								type = "Dropdown",
								label = L["Get Craft Prices From:"],
								list = ddList2,
								value = TSM.db.profile.craftCostSource,
								relativeWidth = 0.49,
								callback = function(_,_,value)
										TSM.db.profile.craftCostSource = value
									end,
								tooltip = L["This is where TradeSkillMaster_Crafting will get prices for crafted items. AuctionDB is TradeSkillMaster's auction house data module."],
							},
							{	-- slider to set the % to deduct from profits
								type = "Slider",
								value = TSM.db.profile.profitPercent,
								label = L["Profit Deduction"],
								isPercent = true,
								min = 0,
								max = 0.25,
								step = 0.01,
								relativeWidth = 0.49,
								callback = function(_,_,value) TSM.db.profile.profitPercent = value end,
								tooltip = L["Percent to subtract from buyout when calculating profits (5% will compensate for AH cut)."],
							},
						},
					},
					{
						type = "Spacer"
					},
					{ 	-- holds the second group of options (profit deduction label + slider)
						type = "InlineGroup",
						layout = "flow",
						title = L["Inventory Settings"],
						children = {
							{
								type = "Label",
								text = L["TradeSkillMaster_Crafting can use TradeSkillMaster_Gathering or DataStore_Containers " ..
									"to provide data for a number of different places inside TradeSkillMaster_Crafting. Use the " ..
									"settings below to set this up."],
								fullWidth = true,
							},
							{
								type = "HeadingLine",
							},
							{
								type = "Dropdown",
								label = L["Addon to use for alt data:"],
								value = fullAddonList[TSM.db.profile.altAddon],
								list = addonList,
								relativeWidth = 0.49,
								callback = function(self,_,value)
										TSM.db.profile.altAddon = value
										tg:SelectTab(2)
									end,
							},
							{
								type = "CheckBox",
								value = TSM.db.profile.restockAH,
								label = L["Include Items on AH"],
								relativeWidth = 0.49,
								callback = function(_,_,value) TSM.db.profile.restockAH = value end,
								tooltip = L["If checked, Crafting will account for items you have on the AH."],
							},
							{
								type = "HeadingLine"
							},
							{
								type = "Dropdown",
								label = L["Characters to include:"],
								value = altCharactersValue,
								list = altCharacters,
								relativeWidth = 0.49,
								multiselect = true,
								disabled = not TSM.db.profile.altAddon,
								callback = function(self,_,key,value)
										TSM.db.profile.altCharacters[altCharacters[key]] = value
									end,
							},
							{
								type = "Dropdown",
								label = L["Guilds to include:"],
								value = altGuildsValue,
								list = altGuilds,
								relativeWidth = 0.49,
								multiselect = true,
								disabled = not TSM.db.profile.altAddon,
								callback = function(_,_,key, value)
										TSM.db.profile.altGuilds[altGuilds[key]] = value
									end,
							},
						},
					},
				},
			},
		}

		page[3] = {
			{	-- scroll frame to contain everything
				type = "ScrollFrame",
				layout = "List",
				children = {
					{
						type = "InlineGroup",
						layout = "flow",
						title = L["Restock Queue Settings"],
						children = {
							{
								type = "Label",
								text = L["These options control the \"Restock Queue\" button in the craft management window. These settings can be overriden by profession or by item in the profession pages of the main TSM window."],
								fullWidth = true,
							},
							{
								type = "HeadingLine",
							},
							{	-- dropdown to select the method for setting the Minimum profit for the main crafts page
								type = "Dropdown",
								label = L["Minimum Profit Method"],
								list = {["gold"]=L["Gold Amount"], ["percent"]=L["Percent of Cost"],
									["none"]=L["No Minimum"], ["both"]=L["Percent and Gold Amount"]},
								value = TSM.db.profile.queueProfitMethod.default,
								relativeWidth = 0.49,
								callback = function(self,_,value)
										TSM.db.profile.queueProfitMethod.default = value
										tg:SelectTab(3)
									end,
								tooltip = L["You can choose to specify a minimum profit amount (in gold or by " ..
									"percent of cost) for what crafts should be added to the craft queue."],
							},
							{
								type = "Label",
								text = "",
								relativeWidth = 0.5,
							},
							{	-- slider to set the stock number
								type = "Slider",
								value = TSM.db.profile.minRestockQuantity.default,
								label = L["Min Restock Quantity"],
								isPercent = false,
								min = 1,
								max = 20,
								step = 1,
								relativeWidth = 0.49,
								callback = function(self,_,value)
										if value > TSM.db.profile.maxRestockQuantity.default then
											TSMAPI:SetStatusText("|cffffff00"..L["Warning: The min restock quantity must be lower than the max restock quantity."].."|r")
										else
											TSMAPI:SetStatusText("")
										end
										TSM.db.profile.minRestockQuantity.default = value
									end,
								tooltip = L["Items will only be added to the queue if the number being added " ..
										"is greater than this number. This is useful if you don't want to bother with " ..
										"crafting singles for example."],
							},
							{	-- slider to set the stock number
								type = "Slider",
								value = TSM.db.profile.maxRestockQuantity.default,
								label = L["Max Restock Quantity"],
								isPercent = false,
								min = 1,
								max = 20,
								step = 1,
								relativeWidth = 0.49,
								callback = function(self,_,value)
										if value < TSM.db.profile.minRestockQuantity.default then
											TSMAPI:SetStatusText(CYAN ..L["Warning: The min restock quantity must be lower than the max restock quantity."])
										else
											TSMAPI:SetStatusText("")
										end
										TSM.db.profile.maxRestockQuantity.default = value
									end,
								tooltip = L["When you click on the \"Restock Queue\" button enough of each " ..
									"craft will be queued so that you have this maximum number on hand. For " ..
									"example, if you have 2 of item X on hand and you set this to 4, 2 more " ..
									"will be added to the craft queue."],
							},
							{
								type = "Slider",
								value = TSM.db.profile.queueMinProfitPercent.default,
								label = L["Minimum Profit (in %)"],
								tooltip = L["If enabled, any craft with a profit over this percent of the cost will be added to " ..
									"the craft queue when you use the \"Restock Queue\" button."],
								min = 0,
								max = 2,
								step = 0.01,
								relativeWidth = 0.49,
								isPercent = true,
								disabled = TSM.db.profile.queueProfitMethod.default == "none" or TSM.db.profile.queueProfitMethod.default == "gold",
								callback = function(_,_,value)
										TSM.db.profile.queueMinProfitPercent.default = floor(value*100)/100
									end,
							},
							{
								type = "Slider",
								value = TSM.db.profile.queueMinProfitGold.default,
								label = L["Minimum Profit (in gold)"],
								tooltip = L["If enabled, any craft with a profit over this value will be added to the craft queue " ..
									"when you use the \"Restock Queue\" button."],
								min = 0,
								max = 300,
								step = 1,
								relativeWidth = 0.49,
								disabled = TSM.db.profile.queueProfitMethod.default == "none" or TSM.db.profile.queueProfitMethod.default == "percent",
								callback = function(_,_,value)
										TSM.db.profile.queueMinProfitGold.default = floor(value)
									end,
							},
							{
								type = "HeadingLine",
							},
							{
								type = "CheckBox",
								value = TSM.db.profile.seenCountFilterSource ~= "",
								label = L["Filter out items with low seen count."],
								relativeWidth = 1,
								callback = function(self, _, value)
										TSM.db.profile.seenCountFilterSource = (value and "AuctionDB") or ""
										local siblings = self.parent.children --aw how cute...siblings ;)
										local i = getIndex(siblings, self)
										siblings[i+1]:SetDisabled(not value)
										siblings[i+3]:SetDisabled(not value)
										siblings[i+4]:SetDisabled(not value)
										siblings[i+5]:SetDisabled(not value)
										siblings[i+1]:SetValue(TSM.db.profile.seenCountFilterSource)
									end,
								tooltip = L["When you use the \"Restock Queue\" button, it will ignore any items "
									.. "with a seen count below the seen count filter below. The seen count data "
									.. "can be retreived from either Auctioneer or TradeSkillMaster's AuctionDB module."],
							},
							{	-- dropdown to select the method for setting the Minimum profit for the main crafts page
								type = "Dropdown",
								label = L["Seen Count Source"],
								disabled = TSM.db.profile.seenCountFilterSource == "",
								list = {["AuctionDB"]=L["TradeSkillMaster_AuctionDB"], ["Auctioneer"]=L["Auctioneer"]},
								value = TSM.db.profile.seenCountFilterSource,
								relativeWidth = 0.49,
								callback = function(_, _, value)
										TSM.db.profile.seenCountFilterSource = value
										tg:SelectTab(3)
									end,
								tooltip = L["This setting determines where seen count data is retreived from. The seen count data "
									.. "can be retreived from either Auctioneer or TradeSkillMaster's AuctionDB module."],
							},
							{
								type = "Label",
								text = "",
								relativeWidth = 0.1,
							},
							{
								type = "EditBox",
								label = L["Seen Count Filter"],
								value = TSM.db.profile.seenCountFilter,
								disabled = TSM.db.profile.seenCountFilterSource == "",
								relativeWidth = 0.2,
								callback = function(self, _, value)
										value = tonumber(value)
										if value and value >= 0 then
											TSM.db.profile.seenCountFilter = value
										end
									end,
								tooltip = L["If enabled, any item with a seen count below this seen count filter value will not "
									.. "be added to the craft queue when using the \"Restock Queue\" button. You can overrride "
									.. "this filter for individual items in the \"Additional Item Settings\"."],
							},
							{	-- plus sign for incrementing the number
								type = "Icon",
								image = "Interface\\Buttons\\UI-PlusButton-Up",
								width = 24,
								imageWidth = 24,
								imageHeight = 24,
								disabled = TSM.db.profile.seenCountFilterSource == "",
								callback = function(self)
										local value = TSM.db.profile.seenCountFilter + 1
										TSM.db.profile.seenCountFilter = value

										local i = getIndex(self.parent.children, self)
										self.parent.children[i-1]:SetText(value)
									end,
							},
							{	-- minus sign for decrementing the number
								type = "Icon",
								image = "Interface\\Buttons\\UI-MinusButton-Up",
								disabled = true,
								width = 24,
								imageWidth = 24,
								imageHeight = 24,
								disabled = TSM.db.profile.seenCountFilterSource == "",
								callback = function(self)
										local value = TSM.db.profile.seenCountFilter - 1
										if value < 0 then value = 0 end
										TSM.db.profile.seenCountFilter = value

										local i = getIndex(self.parent.children, self)
										self.parent.children[i-2]:SetText(value)
									end,
							},
						},
					},
					{
						type = "Spacer",
					},
					{
 						type =  "InlineGroup",
 						layout = "flow",
 						title = L["On-Hand Queue"],
 						children = {
 							{
 								type = "CheckBox",
 								value = TSM.db.profile.assumeVendorInBags,
 								label = L["Ignore Vendor Items"],
 								relativeWidth = 0.5,
 								callback = function(self,_,value) 
 										TSM.db.profile.assumeVendorInBags = value 
 										local siblings = self.parent.children --aw how cute...siblings ;)
 										local i = getIndex(siblings, self)
 										siblings[i+1]:SetDisabled(not value)
 										siblings[i+2]:SetDisabled(not value or not TSM.db.profile.limitVendorItemPrice)									
 									end,
 								tooltip = L["If checked, the on-hand queue will assume you have all vendor items when queuing crafts."],
 							},
 							{
 								type = "CheckBox",
 								value = TSM.db.profile.limitVendorItemPrice,
 								disabled = not TSM.db.profile.assumeVendorInBags,
 								label = L["Limit Vendor Item Price"],
 								relativeWidth = 0.5,
 								callback = function(self,_,value) 
 										TSM.db.profile.limitVendorItemPrice = value 
 										local siblings = self.parent.children --aw how cute...siblings ;)
 										local i = getIndex(self.parent.children, self)
 										self.parent.children[i+1]:SetDisabled(not value)
 									end,
 								tooltip = L["If checked, only vendor items below a maximum price will be ignored by the on-hand queue."],
 							},
 							{
 								type = "EditBox",
								label = L["Maximum Price Per Vendor Item"],
 								relativeWidth = 0.5,
 								value = TSM:FormatTextMoney(TSM.db.profile.maxVendorPrice),
 								disabled = not TSM.db.profile.limitVendorItemPrice or not TSM.db.profile.assumeVendorInBags,
 								callback = function(self,_,value)
 										local copper = TSM:GetMoneyValue(value)
 										if not copper then
 											TSMAPI:SetStatusText(L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."])
 											self:SetFocus()
 										else
 											self:ClearFocus()
 											TSM.db.profile.maxVendorPrice = copper
 										end
 									end,
								tooltip = L["All vendor items that cost more than this price will not be ignored by the on-hand queue."]
 							},
 						},
					},
				},
			},
		}

		-- profiles page
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
			current = L["Current Profile:"] .. " " .. CYAN .. TSM.db:GetCurrentProfile() .. "|r",
		}

		-- Returns a list of all the current profiles with common and nocurrent modifiers.
		-- This code taken from AceDBOptions-3.0.lua
		local function GetProfileList(db, common, nocurrent)
			local profiles = {}
			local tmpprofiles = {}
			local defaultProfiles = {["Default"] = "Default"}

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

		page[4] = {
			{	-- scroll frame to contain everything
				type = "ScrollFrame",
				layout = "List",
				children = {
					{
						type = "Label",
						text = "TradeSkillMaster_Crafting" .. "\n",
						fontObject = GameFontNormalLarge,
						fullWidth = true,
						colorRed = 255,
						colorGreen = 0,
						colorBlue = 0,
					},
					{
						type = "Label",
						text = text["intro"] .. "\n" .. "\n",
						fullWidth = true,
					},
					{
						type = "Label",
						text = text["reset_desc"],
						fullWidth = true,
					},
					{	--simplegroup1 for the reset button / current profile text
						type = "SimpleGroup",
						layout = "flow",
						children = {
							{
								type = "Button",
								text = text["reset"],
								callback = function() TSM.db:ResetProfile() end,
							},
							{
								type = "Label",
								text = text["current"],
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
						fullWidth = true,
					},
					{	--simplegroup2 for the new editbox / existing profiles dropdown
						type = "SimpleGroup",
						layout = "flow",
						children = {
							{
								type = "EditBox",
								label = text["new"],
								value = "",
								callback = function(_,_,value)
										TSM.db:SetProfile(value)
										tg:SelectTab(4)
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
											tg:SelectTab(4)
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
									tg:SelectTab(4)
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
						fullWidth = true,
					},
					{
						type = "Dropdown",
						label = text["delete"],
						list = GetProfileList(TSM.db, true, nil),
						value = "",
						disabled = not GetProfileList(TSM.db, true, nil) and true,
						callback = function(_,_,value)
								if TSM.db:GetCurrentProfile() == value then
									TSMAPI:SetStatusText("Cannot delete currently active profile!")
									return
								end
								TSMAPI:SetStatusText("")
								StaticPopupDialogs["TSMCrafting.DeleteConfirm"].OnAccept = function()
										TSM.db:DeleteProfile(value)
										tg:SelectTab(4)
									end
								StaticPopup_Show("TSMCrafting.DeleteConfirm")
								for i=1, 10 do
									if _G["StaticPopup" .. i] and _G["StaticPopup" .. i].which == "TSMCrafting.DeleteConfirm" then
										_G["StaticPopup" .. i]:SetFrameStrata("TOOLTIP")
										break
									end
								end
							end,
					},
				},
			},
		}
		return page[num]
	end

	local offsets = {}
	local previousTab = 1

	tg:SetCallback("OnGroupSelected", function(self,_,value)
			if tg.children and tg.children[1] and tg.children[1].localstatus then
				offsets[previousTab] = tg.children[1].localstatus.offset
			end
			tg:ReleaseChildren()
			TSMAPI:BuildPage(tg, GetTab(value))
			if tg.children and tg.children[1] and tg.children[1].localstatus then
				tg.children[1].localstatus.offset = (offsets[value] or 0)
			end
			previousTab = value
		end)
	tg:SelectTab(1)
end
	
local lastProfession

-- updates the craft queue
function GUI:UpdateQueue(forced, mode)
	mode = mode or TSM:GetMode()
	if not forced and mode == lastProfession then
		return TSMAPI:CreateTimeDelay("craftingUpdateQueue", 2, function() GUI:UpdateQueue(true, mode) end)
	else
		GUI.queueInTotal = 0 -- integer representing the number of different items in the craft queue
		lastProfession = mode

		wipe(GUI.queueList) -- clear the craft queue so we start fresh
		for itemID, data in pairs(TSM.Data[mode].crafts) do
			if data.intermediateQueued then
				data.queued = data.queued - data.intermediateQueued
				data.intermediateQueued = nil
			end
		end

		local function FillSubCrafts(craft, cQuantity, level)
			local result = {}
			if level > 5 then return result end
			local foundIntermediate = false
			for matID, quantity in pairs(craft.mats) do
				local subCraft = TSM.Data[mode].crafts[matID]
				local matPriceSource = TSM.Data[mode].mats[matID].source
				if subCraft and not subCraft.hasCD and subCraft.enabled and (matPriceSource == "craft") then
					local name = subCraft.name or GetSpellInfo(subCraft.spellID)
					local numHave = TSM.Data:GetTotalQuantity(matID)
					local subCraftQuantity = cQuantity*quantity - numHave
					if subCraftQuantity < 0 then subCraftQuantity = 0 end
					if subCraftQuantity > 0 then
						subCraft.intermediateQueued = (subCraft.intermediateQueued or 0) + subCraftQuantity
						local temp = {name=name, quantity=subCraftQuantity, spellID=subCraft.spellID, itemID=matID}
						temp.subCrafts = FillSubCrafts(subCraft, subCraftQuantity, level + 1)
						tinsert(result, temp)
					end
				end
			end

			return result
		end

		local orderCache = {}
		for itemID, data in pairs(TSM.Data[mode].crafts) do
			if (data.queued - (data.intermediateQueued or 0)) > 0 then -- find crafts that are queued
				-- get some information and add the craft to the craft queue (GUI.queueList)
				local iName = data.name or GetSpellInfo(data.spellID)
				local tempData = {name=iName, quantity=data.queued, spellID=data.spellID, itemID=itemID, subCrafts={}}
				tempData.subCrafts = FillSubCrafts(data, data.queued, 0)

				tinsert(GUI.queueList, tempData)
				local order, _, _, partial = TSM.Crafting:GetOrderIndex(tempData)
				if partial and order ~= 3 then
					orderCache[data.spellID] = 2.5
				else
					orderCache[data.spellID] = order
				end

				-- update our totals
				GUI.queueInTotal = GUI.queueInTotal + 1
			end
		end

		for itemID, craft in pairs(TSM.Data[mode].crafts) do
			craft.queued = craft.queued + (craft.intermediateQueued or 0)
		end

		sort(GUI.queueList, function(a, b)
				local orderA = orderCache[a.spellID] or 0
				local orderB = orderCache[b.spellID] or 0
				if TSM.Crafting.lastCraft == a.spellID then
					return true
				elseif TSM.Crafting.lastCraft == b.spellID then
					return false
				else
					if orderA == orderB then
						if a.quantity == b.quantity then
							return a.spellID > b.spellID
						else
							return a.quantity > b.quantity
						end
					else
						return orderA > orderB
					end
				end
			end)
	end
end

function GUI:ClearQueue()
	local mode = TSM:GetMode()
	for _, data in pairs(TSM.Data[mode].crafts) do
		data.queued = 0
		data.intermediateQueued = nil
	end

	wipe(GUI.queueList) -- clear the craft queue so we start fresh
	GUI.queueInTotal = 0 -- integer representing the number of different items in the craft queueend
end