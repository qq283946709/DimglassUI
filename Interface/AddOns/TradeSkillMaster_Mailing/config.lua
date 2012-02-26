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
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Mailing") -- loads the localization table

local FRAME_WIDTH = 700
local FRAME_HEIGHT = 600
local TREE_WIDTH = 150
Config.itemsInGroup = {}

function Config:Load(parent)
	local treeGroupStatus = {treewidth = 150, groups={[1]=true}}

	local treeGroup = AceGUI:Create("TSMTreeGroup")
	treeGroup:SetLayout("Fill")
	treeGroup:SetCallback("OnGroupSelected", function(...) Config:SelectTree(...) end)
	treeGroup:SetStatusTable(treeGroupStatus)
	parent:AddChild(treeGroup)
	
	Config.treeGroup = treeGroup
	Config:UpdateTree()
end

-- controls what is drawn on the right side of the Config window
function Config:SelectTree(parent, _, selection)
	local selectedParent, selectedChild = ("\001"):split(selection)
	parent:ReleaseChildren()

	local container = AceGUI:Create("TSMSimpleGroup")
	container:SetFullWidth(true)
	container:SetFullHeight(true)
	container:SetLayout("fill")
	parent:AddChild(container)

	-- figures out which tree element is selected
	-- then calls the correct function to build that part of the Config window
	if not selectedChild then
		Config:DrawMain(container)
	else
		Config:DrawGroup(container, tonumber(selectedChild))
	end
end

function Config:UpdateTree()
	local treeGroups = {{value=1, text=L["Options"], children={}}}
	for i, name in ipairs(TSM.db.factionrealm.mailTargets) do
		tinsert(treeGroups[1].children, {value=i, text=name})
	end
	Config.treeGroup:SetTree(treeGroups)
	Config.treeGroup:SelectByPath(1)
end

function Config:DrawMain(container)
	local page = {
		{	-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "list",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Options"],
					fullWidth = true,
					children = {
						{	-- first line of text
							type = "CheckBox",
							label = L["Auto Recheck Mail"],
							relativeWidht = .5,
							value = TSM.db.profile.autoCheck,
							tooltip = L["Automatically rechecks mail every 60 seconds when you have too much mail.\n\nIf you loot all mail with this enabled, it will wait and recheck then keep auto looting."],
							callback = function(_,_,value)
									TSM.db.profile.autoCheck = value
								end,
						},
						{
							type = "CheckBox",
							label = L["Don't Display Money Received"],
							relativeWidth = .5,
							value = TSM.db.profile.dontDisplayMoneyCollected,
							tooltip = L["Checking this will stop TradesSkillMaster_Mailing from displaying money collected from your mailbox after auto looting"],
							callback = function(_,_,value)
									TSM.db.profile.dontDisplayMoneyCollected = value
								end,
						},
						{
							type = "CheckBox",
							label = "Send items individually",
							relativeWidth = .5,
							value = TSM.db.profile.sendItemsIndividually,
							tooltip = "Sends each item in a seperate mail.",
							callback = function(_,_,value)
									TSM.db.profile.sendItemsIndividually = value
								end,
						},
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "list",
					title = L["Add Mail Target"],
					fullWidth = true,
					children = {
						{	-- first line of text
							type = "Label",
							text = L["Auto mailing will let you setup groups and specific items that should be mailed to another characters."],
							fontObject = GameFontNormal,
							fullWidth = true,
						},
						{
							type = "Spacer",
						},
						{	-- second line of text
							type = "Label",
							text = L["Check your spelling! If you typo a name, it will send to the wrong person."],
							fontObject = GameFontNormal,
							fullWidth = true,
						},
						{
							type = "HeadingLine",
						},
						{	-- editbox for the player to input how many they'd like to make
							type = "EditBox",
							label = L["Player Name"],
							tooltip = L["The name of the player to send items to.\n\nCheck your spelling!"],
							callback = function(self,_,value)
									value = string.trim(string.lower(value or ""))
									if( value == "" ) then return TSMAPI:SetStatusText(L["No player name entered."]) end
									
									for _, name in pairs(TSM.db.factionrealm.mailTargets) do
										if( string.lower(name) == value ) then
											return TSMAPI:SetStatusText(string.format(L["Player \"%s\" is already a mail target."], name))
										end
									end
									
									TSMAPI:SetStatusText("")
									tinsert(TSM.db.factionrealm.mailTargets, value)
									Config:UpdateTree()
								end,
						},
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "list",
					title = L["Remove Mail Target"],
					fullWidth = true,
					children = {
					},
				},
			},
		},
	}
	
	local function RemovePlayer(index, name)
		tremove(TSM.db.factionrealm.mailTargets, index)
		for itemID, pName in pairs(TSM.db.factionrealm.mailItems) do
			if pName == name then
				TSM.db.factionrealm.mailItems[itemID] = nil
			end
		end
		Config:UpdateTree()
	end
	
	for i, name in ipairs(TSM.db.factionrealm.mailTargets) do
		tinsert(page[1].children[5].children, {
				type = "Button",
				text = strupper(name),
				callback = function()
						StaticPopupDialogs["TSMMailingDeleteConfirmation"] = {
							text = format(L["Are you sure you want to remove %s as a mail target?"], strupper(name)),
							button1 = YES,
							button2 = CANCEL,
							timeout = 0,
							whileDead = true,
							hideOnEscape = false,
							OnAccept = function() RemovePlayer(i, name) end,
						}
						StaticPopup_Show("TSMMailingDeleteConfirmation")
						for i=1, 10 do
							if _G["StaticPopup" .. i] and _G["StaticPopup" .. i].which == "TSMMailingDeleteConfirmation" then
								_G["StaticPopup" .. i]:SetFrameStrata("TOOLTIP")
								break
							end
						end
					end,
			})
	end
	
	TSMAPI:BuildPage(container, page, true)
end

function Config:DrawGroup(container, groupNum)
	local currentTarget = TSM.db.factionrealm.mailTargets[groupNum]
	Config:UpdateItemsInGroup()
	
	local unGrouped, grouped = {}, {}
	local groups = {}
	for name in pairs(TSMAPI:GetData("auctioningGroups") or {}) do
		groups[name] = true
	end
	for index, target in pairs(TSM.db.factionrealm.mailItems) do
		if target == currentTarget then
			if type(index) == "string" then --it's a group name
				-- check if this group is still a group or not
				if groups[index] then
					tinsert(grouped, {value=index, text=index, name=index})
				else
					target = nil
				end
			elseif not Config.itemsInGroup[itemID] then
				local name,link,_,_,_,_,_,_,_,texture = GetItemInfo(index)
				tinsert(grouped, {value=index, text=link, icon=texture, name=name})
			end
		end
	end
	
	for groupName in pairs(groups) do
		if not TSM.db.factionrealm.mailItems[groupName] then
			tinsert(unGrouped, {value=groupName, text=groupName, name=groupName})
		end
	end
	
	local usedLinks = {}
	for bag=4, 0, -1 do
		for slot=1, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			local itemID = TSMAPI:GetItemID(link)
			if itemID and not usedLinks[itemID] and not Config:IsSoulbound(bag, slot, itemID) then
				usedLinks[itemID] = true
				local name,_,_,_,_,_,_,_,_,texture = GetItemInfo(link)
				if not TSM.db.factionrealm.mailItems[itemID] and not Config.itemsInGroup[itemID] then
					tinsert(unGrouped, {value=itemID, text=link, name=name, icon=texture})
				end
			end
		end
	end
	sort(unGrouped, function(a,b)
			if a.icon and not b.icon then
				return false
			elseif not a.icon and b.icon then
				return true
			else
				return a.name < b.name
			end
		end)
		
	local page = {
		{
			type = "SimpleGroup",
			layout = "Fill",
			children = {
				{
					type = "SelectionList",
					leftTitle = L["Items/Groups to Add:"],
					rightTitle = L["Items/Groups to remove:"],
					leftList = unGrouped,
					rightList = grouped,
					onAdd = function(_,_,selected)
							for i=#selected, 1, -1 do
								TSM.db.factionrealm.mailItems[selected[i]] = currentTarget
							end
							Config.treeGroup:SelectByPath(1, groupNum)
						end,
					onRemove = function(_,_,selected)
							for i=#selected, 1, -1 do
								TSM.db.factionrealm.mailItems[selected[i]] = nil
							end
							Config.treeGroup:SelectByPath(1, groupNum)
						end,
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

-- Make sure the item isn't soulbound
local scanTooltip
local resultsCache = {}
function Config:IsSoulbound(bag, slot, itemID)
	local slotID = tostring(bag) .. tostring(slot) .. tostring(itemID)
	if resultsCache[slotID] then return resultsCache[slotID] end
	
	if TSM.AutoMail.ClickStart then error("Invalid execution path.", 2) end
	
	if not scanTooltip then
		scanTooltip = CreateFrame("GameTooltip", "TSMMailingScanTooltip", UIParent, "GameTooltipTemplate")
		scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end
	scanTooltip:ClearLines()
	
	if bag == -2 then
		scanTooltip:SetHyperlink(itemID)
	else
		scanTooltip:SetBagItem(bag, slot)
	end
	
	for id=1, scanTooltip:NumLines() do
		local text = _G["TSMMailingScanTooltipTextLeft" .. id]
		if text and ((text:GetText() == ITEM_BIND_ON_PICKUP and id < 4) or text:GetText() == ITEM_SOULBOUND or text:GetText() == ITEM_BIND_QUEST) then
			resultsCache[slotID] = true
			return true
		end
	end
	
	resultsCache[slotID] = nil
	return false
end

-- Config.itemsInGroup links itemIDs from groups directly to their target
-- serves as a way to tell if an item is in a mailing group as a result to being in a auctioning group or not
function Config:UpdateItemsInGroup()
	wipe(Config.itemsInGroup)

	for index, target in pairs(TSM.db.factionrealm.mailItems) do
		if type(index) == "string" then
			local items = TSMAPI:GetData("auctioningGroupItems", index) or {}
			for _, itemID in pairs(items) do
				Config.itemsInGroup[itemID] = target
			end
		end
	end
end