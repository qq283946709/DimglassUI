-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Auctioning - AddOn by Sapu94							 	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctioning.aspx  --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


local TSMAuc = select(2, ...)
local Config = TSMAuc:NewModule("Config", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Auctioning") -- loads the localization table
local AceGUI = LibStub("AceGUI-3.0")

local debug = function(...)
	if TSMAUCDEBUG then
		print(...)
	end
end

-- Make sure the item isn't soulbound
local scanTooltip
local resultsCache = {}
function Config:IsSoulbound(bag, slot, itemID)
	local slotID = tostring(bag) .. tostring(slot) .. tostring(itemID)
	if resultsCache[slotID] then return resultsCache[slotID] end
	
	if not scanTooltip then
		scanTooltip = CreateFrame("GameTooltip", "TSMAucScanTooltip", UIParent, "GameTooltipTemplate")
		scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end
	scanTooltip:ClearLines()
	
	if bag == -2 then
		scanTooltip:SetHyperlink(itemID)
	else
		scanTooltip:SetBagItem(bag, slot)
	end
	
	for id=1, scanTooltip:NumLines() do
		local text = _G["TSMAucScanTooltipTextLeft" .. id]
		if text and ((text:GetText() == ITEM_BIND_ON_PICKUP and id < 4) or text:GetText() == ITEM_SOULBOUND or text:GetText() == ITEM_BIND_QUEST) then
			resultsCache[slotID] = true
			return true
		end
	end
	
	resultsCache[slotID] = nil
	return false
end

function Config:ValidateName(value)
	for name in pairs(TSMAuc.db.profile.groups) do
		if strlower(name) == strlower(value) then
			return false
		end
	end
	for name in pairs(TSMAuc.db.profile.categories) do
		if strlower(name) == strlower(value) then
			return false
		end
	end
	return true
end

function Config:ShouldScan(itemID, isCancel)
	local isGroupDisabled = Config:GetBoolConfigValue(itemID, "disabled")
	local isGroupNoCancel = isCancel and Config:GetBoolConfigValue(itemID, "noCancel")
	
	return not (isGroupDisabled or isGroupNoCancel)
end

function Config:GetConfigValue(itemID, key, isGroup)
	local groupValue
	if key == "thresholdPriceMethod" or key == "thresholdPercent" then
		if TSMAuc.db.profile.groups[itemID] or TSMAuc.db.profile.categories[itemID] then
			if TSMAuc.db.profile.threshold[itemID] then
				groupValue = itemID
			elseif TSMAuc.db.profile.threshold[TSMAuc.groupReverseLookup[itemID]] then
				groupValue = TSMAuc.groupReverseLookup[itemID]
			else
				groupValue = "default"
			end
		else
			groupValue = "default"
		end
	elseif key == "fallbackPriceMethod" or key == "fallbackPercent" then
		if TSMAuc.db.profile.groups[itemID] or TSMAuc.db.profile.categories[itemID] then
			if TSMAuc.db.profile.fallback[itemID] then
				groupValue = itemID
			elseif TSMAuc.db.profile.fallback[TSMAuc.groupReverseLookup[itemID]] then
				groupValue = TSMAuc.groupReverseLookup[itemID]
			else
				groupValue = "default"
			end
		else
			groupValue = "default"
		end
	elseif key ~= "threshold" and key ~= "fallback" then
		if not isGroup then
			if TSMAuc.itemReverseLookup[itemID] and TSMAuc.db.profile[key][TSMAuc.itemReverseLookup[itemID]] then
				groupValue = TSMAuc.itemReverseLookup[itemID]
			elseif TSMAuc.groupReverseLookup[TSMAuc.itemReverseLookup[itemID] or ""] and TSMAuc.db.profile[key][TSMAuc.groupReverseLookup[TSMAuc.itemReverseLookup[itemID] or ""]] then
				groupValue = TSMAuc.groupReverseLookup[TSMAuc.itemReverseLookup[itemID]]
			else
				groupValue = "default"
			end
		else
			if TSMAuc.db.profile[key][itemID] then
				groupValue = itemID
			elseif TSMAuc.groupReverseLookup[itemID] and TSMAuc.db.profile[key][TSMAuc.groupReverseLookup[itemID]] then
				groupValue = TSMAuc.groupReverseLookup[itemID]
			else
				groupValue = "default"
			end
		end
	else
		if TSMAuc.itemReverseLookup[itemID] and TSMAuc.db.profile[key][TSMAuc.itemReverseLookup[itemID]] and TSMAuc.db.profile[key][TSMAuc.itemReverseLookup[itemID]] then
			groupValue = TSMAuc.itemReverseLookup[itemID]
		elseif TSMAuc.groupReverseLookup[TSMAuc.itemReverseLookup[itemID] or ""] and TSMAuc.db.profile[key][TSMAuc.groupReverseLookup[TSMAuc.itemReverseLookup[itemID] or ""]] then
			groupValue = TSMAuc.groupReverseLookup[TSMAuc.itemReverseLookup[itemID]]
		elseif TSMAuc.db.profile.groups[itemID] or TSMAuc.db.profile.categories[itemID] then
			-- we got passed a group not an itemID (used by GetGroupMoney method in the options)
			if TSMAuc.db.profile[key][itemID] then
				groupValue = itemID
			elseif TSMAuc.groupReverseLookup[itemID] and TSMAuc.db.profile[key][TSMAuc.groupReverseLookup[itemID]] then
				groupValue = TSMAuc.groupReverseLookup[itemID]
			else
				groupValue = "default"
			end
		else
			groupValue = "default"
		end
		if TSMAuc.db.profile[key][groupValue] ~= nil then
			TSMAuc.db.profile[key.."PriceMethod"][groupValue] = TSMAuc.db.profile[key.."PriceMethod"][groupValue] or "gold"
		end
		local method = TSMAuc.db.profile[key.."PriceMethod"][groupValue]
		debug(groupValue, method, key)
		if method ~= "gold" then
			local group = TSMAuc.itemReverseLookup[itemID] or (TSMAuc.db.profile.groups[itemID] and itemID)
			debug(group, method, key)
			if not group then return 0 end
			local percent = TSMAuc.db.profile[key.."Percent"][groupValue]
			local value = TSMAuc:GetMarketValue(group, percent, method)
			debug(value, percent)
			return value
		end
	end
	return TSMAuc.db.profile[key][groupValue]
end

function Config:GetBoolConfigValue(itemID, key)
	local val
	local groupName = TSMAuc.itemReverseLookup[itemID]
	local categoryName = TSMAuc.groupReverseLookup[groupName or ""]
	
	val = TSMAuc.db.profile[key][groupName or ""]
	if val == nil and categoryName then
		val = TSMAuc.db.profile[key][categoryName]
	end
	
	if val ~= nil then
		return val
	end
	return TSMAuc.db.profile[key].default
end

function Config:LoadOptions(parent)
	if TSMAuc.db.global.hideAdvanced == nil then
		StaticPopupDialogs["TSMAucHideAdvancedPopup"] = {
			text = L["Would you like to load these options in beginner or advanced mode? If you have not used APM, QA3, or ZA before, beginner is recommended. Your selection can always be changed using the \"Hide advanced options\" checkbox in the \"Options\" page."],
			button1 = L["Beginner"],
			button2 = L["Advanced"],
			timeout = 0,
			whileDead = true,
			hideOnEscape = false,
			OnAccept = function() TSMAuc.db.global.hideAdvanced = true end,
			OnCancel = function() TSMAuc.db.global.hideAdvanced = false end,
		}
		StaticPopup_Show("TSMAucHideAdvancedPopup")
		for i=1, 10 do
			if _G["StaticPopup" .. i] and _G["StaticPopup" .. i].which == "TSMAucHideAdvancedPopup" then
				_G["StaticPopup" .. i]:SetFrameStrata("TOOLTIP")
				break
			end
		end
	end

	local treeGroup = AceGUI:Create("TSMTreeGroup")
	treeGroup:SetLayout("Fill")
	treeGroup:SetCallback("OnGroupSelected", function(...) Config:SelectTree(...) end)
	treeGroup:SetStatusTable(TSMAuc.db.global.treeGroupStatus)
	parent:AddChild(treeGroup)
	
	Config.treeGroup = treeGroup
	Config:UpdateTree()
	Config.treeGroup:SelectByPath(1)
end

function Config:UpdateTree()
	if not Config.treeGroup then return end
	TSMAuc:UpdateGroupReverseLookup()

	local categoryTreeIndex = {}
	local treeGroups = {{value=1, text=L["Options"]}, {value=2, text=L["Categories / Groups"], children={{value="~", text="|cffaaff11"..L["<Uncategorized Groups>"].."|r", disabled=true, children={}}}}}
	local pageNum
	for categoryName, groups in pairs(TSMAuc.db.profile.categories) do
		for groupName, v in pairs(groups) do
			if not TSMAuc.db.profile.groups[groupName] then
				v = nil
			end
		end
		tinsert(treeGroups[2].children, {value=categoryName, text="|cff99ff99"..categoryName.."|r"})
		categoryTreeIndex[categoryName] = #(treeGroups[2].children)
	end
	for name in pairs(TSMAuc.db.profile.groups) do
		if TSMAuc.groupReverseLookup[name] then
			local index = categoryTreeIndex[TSMAuc.groupReverseLookup[name]]
			treeGroups[2].children[index].children = treeGroups[2].children[index].children or {}
			tinsert(treeGroups[2].children[index].children, {value=name, text=name})
		else
			tinsert(treeGroups[2].children[1].children, {value=name, text=name})
		end
	end
	sort(treeGroups[2].children, function(a, b) return strlower(a.value) < strlower(b.value) end)
	for _, data in pairs(treeGroups[2].children) do
		if data.children then
			sort(data.children, function(a, b) return strlower(a.value) < strlower(b.value) end)
		end
	end
	Config.treeGroup:SetTree(treeGroups)
end

function Config:SelectTree(treeFrame, _, selection)
	TSMAuc:UpdateGroupReverseLookup()
	treeFrame:ReleaseChildren()
	local content = AceGUI:Create("TSMSimpleGroup")
	content:SetLayout("Fill")
	treeFrame:AddChild(content)

	local selectedParent, selectedChild, selectedSubChild = ("\001"):split(selection)
	if not selectedChild or tonumber(selectedChild) == 0 then
		if tonumber(selectedParent) == 1 then
			local offsets, previousTab = {}, 1
			local tg = AceGUI:Create("TSMTabGroup")
			tg:SetLayout("Fill")
			tg:SetFullHeight(true)
			tg:SetFullWidth(true)
			tg:SetTabs({{value=1, text=L["General"]}, {value=2, text=L["Whitelist"]}, {value=3, text=L["Blacklist"]}, {value=4, text=L["Profiles"]}})
			tg:SetCallback("OnGroupSelected", function(self,_,value)
				if tg.children and tg.children[1] and tg.children[1].localstatus then
					offsets[previousTab] = tg.children[1].localstatus.offset
				end
				tg:ReleaseChildren()
				content:DoLayout()
				
				if value == 1 then
					Config:DrawGeneralOptions(tg)
				elseif value == 2 then
					Config:DrawWhitelist(tg)
				elseif value == 3 then
					Config:DrawBlacklist(tg)
				elseif value == 4 then
					Config:DrawProfiles(tg)
				end
				
				if tg.children and tg.children[1] and tg.children[1].localstatus then
					tg.children[1].localstatus.offset = (offsets[value] or 0)
				end
				previousTab = value
			end)
			content:AddChild(tg)
			tg:SelectTab(1)
		else
			local offsets, previousTab = {}, 1
			local tg = AceGUI:Create("TSMTabGroup")
			tg:SetLayout("Fill")
			tg:SetFullHeight(true)
			tg:SetFullWidth(true)
			tg:SetTabs({{value=1, text=L["Auction Defaults"]}, {value=2, text=L["Create Category / Group"]}})
			tg:SetCallback("OnGroupSelected", function(self,_,value)
				if tg.children and tg.children[1] and tg.children[1].localstatus then
					offsets[previousTab] = tg.children[1].localstatus.offset
				end
				tg:ReleaseChildren()
				content:DoLayout()
				
				if value == 1 then
					Config:DrawGroupGeneral(tg, "default")
				elseif value == 2 then
					Config:DrawItemGroups(tg)
				end
				
				if tg.children and tg.children[1] and tg.children[1].localstatus then
					tg.children[1].localstatus.offset = (offsets[value] or 0)
				end
				previousTab = value
			end)
			content:AddChild(tg)
			tg:SelectTab(1)
		end
	else
		selectedChild = strlower(selectedSubChild or selectedChild)
		local offsets, previousTab = {}, 1
		local isCategory = TSMAuc.db.profile.categories[selectedChild]
		
		local addRemoveTabOrder = TSMAuc.db.global.tabOrder
		local overrideTabOrder = addRemoveTabOrder % 2 + 1
		
		local groupTabs = {}
		groupTabs[overrideTabOrder] = {value=1, text=L["Group Overrides"]}
		groupTabs[addRemoveTabOrder] = {value=2, text=L["Add/Remove Items"]}
		groupTabs[3] = {value=3, text=L["Management"]}
		
		local categoryTabs = {}
		categoryTabs[overrideTabOrder] = {value=1, text=L["Category Overrides"]}
		categoryTabs[addRemoveTabOrder] = {value=2, text=L["Add/Remove Groups"]}
		categoryTabs[3] = {value=3, text=L["Management"]}
		
		local tg = AceGUI:Create("TSMTabGroup")
		tg:SetLayout("Fill")
		tg:SetFullHeight(true)
		tg:SetFullWidth(true)
		tg:SetTabs(isCategory and categoryTabs or groupTabs)
		tg:SetCallback("OnGroupSelected", function(self,_,value)
			if tg.children and tg.children[1] and tg.children[1].localstatus then
				offsets[previousTab] = tg.children[1].localstatus.offset
			end
			tg:ReleaseChildren()
			content:DoLayout()
			Config:UnregisterAllEvents()
			
			if value == 1 then
				Config:DrawGroupGeneral(tg, selectedChild)
			elseif value == 2 then
				if isCategory then
					Config:DrawAddRemoveGroup(tg, selectedChild)
				else
					Config:RegisterEvent("BAG_UPDATE", function() tg:SelectTab(2) end)
					Config:DrawAddRemoveItem(tg, selectedChild)
				end
			elseif value == 3 then
				if isCategory then
					Config:DrawCategoryManagement(tg, selectedChild)
				else
					Config:DrawGroupManagement(tg, selectedChild)
				end
			end
			
			if tg.children and tg.children[1] and tg.children[1].localstatus then
				tg.children[1].localstatus.offset = (offsets[value] or 0)
			end
			previousTab = value
		end)
		content:AddChild(tg)
		tg:SelectTab(overrideTabOrder)
	end
end

function Config:DrawGeneralOptions(container)
	local macroOptions = {down=true, up=true, ctrl=true, shift=false, alt=false}

	local page = {
		{
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["General"],
					children = {
						{
							type = "CheckBox",
							value = TSMAuc.db.global.hideHelp,
							label = L["Hide help text"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSMAuc.db.global.hideHelp = value end,
							tooltip = L["Hides auction setting help text throughout the options."],
						},
						{
							type = "CheckBox",
							value = TSMAuc.db.global.hideAdvanced,
							label = L["Hide advanced options"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSMAuc.db.global.hideAdvanced = value end,
							tooltip = L["Hides advanced auction settings. Provides for an easier learning curve for new users."],
						},
						{
							type = "CheckBox",
							value = TSMAuc.db.global.hideGray,
							label = L["Hide poor quality items"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSMAuc.db.global.hideGray = value end,
							tooltip = L["Hides all poor (gray) quality items from the 'Add items' pages."],
						},
						{
							type = "CheckBox",
							value = TSMAuc.db.global.enableSounds,
							label = L["Enable sounds"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSMAuc.db.global.enableSounds = value end,
							tooltip = L["Plays the ready check sound when a post / cancel scan is complete and items are ready to be posting / canceled (the gray bar is all the way across)."],
						},
						{
							type = "CheckBox",
							value = TSMAuc.db.global.blockAuc,
							label = L["Block Auctioneer while scanning"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSMAuc.db.global.blockAuc = value end,
							tooltip = L["Prevents Auctioneer from scanning while Auctioning is doing a scan."],
						},
						{
							type = "CheckBox",
							value = TSMAuc.db.global.showTooltip,
							label = L["Show group name in tooltip"],
							relativeWidth = 0.5,
							callback = function(_,_,value)
									if value then
										TSMAPI:RegisterTooltip("TradeSkillMaster_Auctioning", function(...) return TSMAuc:LoadTooltip(...) end)
									else
										TSMAPI:UnregisterTooltip("TradeSkillMaster_Auctioning")
									end
									TSMAuc.db.global.showTooltip = value
								end,
							tooltip = L["Shows the name of the group an item belongs to in that item's tooltip."],
						},
						{
							type = "CheckBox",
							value = TSMAuc.db.global.smartGroupCreation,
							label = L["Smart group creation"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSMAuc.db.global.smartGroupCreation = value end,
							tooltip = L["If enabled, when you create a new group, your bags will be scanned for items with names that include the name of the new group. If such items are found, they will be automatically added to the new group."],
						},
						{
							type = "Dropdown",
							label = L["First Tab in Group / Category Settings"],
							list = {L["Add/Remove"], L["Overrides"]},
							value = TSMAuc.db.global.tabOrder,
							relativeWidth = 0.5,
							callback = function(_,_,value) TSMAuc.db.global.tabOrder = value end,
							tooltip = L["Determines which order the group / category settings tabs will appear in."],
						},
					}
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Canceling"],
					children = {
						{
							type = "CheckBox",
							value = TSMAuc.db.global.cancelWithBid,
							label = L["Cancel auctions with bids"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSMAuc.db.global.cancelWithBid = value end,
							tooltip = L["Will cancel auctions even if they have a bid on them, you will take an additional gold cost if you cancel an auction with bid."],
						},
						{
							type = "CheckBox",
							value = TSMAuc.db.global.smartCancel,
							label = L["Smart cancelling"],
							relativeWidth = 0.5,
							callback = function(_,_,value) TSMAuc.db.global.smartCancel = value end,
							tooltip = L["Disables cancelling of auctions with a market price below the threshold, also will cancel auctions if you are the only one with that item up and you can relist it for more."],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Macro Help"],
					children = {
						{
							type = "Label",
							text = format(L["There are two ways of making clicking the Post / Cancel Auction button easier. You can put %s and %s in a macro (on separate lines), or use the utility below to have a macro automatically made and bound to scrollwheel for you."], "\"|cffffbb00/click TSMAucPostButton|r\"", "\"|cffffbb00/click TSMAucCancelButton|r\""),
							relativeWidth = 1,
						},
						{
							type = "HeadingLine"
						},
						{
							type = "Label",
							text = L["ScrollWheel Direction (both recommended):"],
							relativeWidth = 0.59,
						},
						{
							type = "CheckBox",
							label = L["Up"],
							relativeWidth = 0.20,
							value = macroOptions.up,
							callback = function(_,_,value) macroOptions.up = value end,
							tooltip = L["Will bind ScrollWheelUp (plus modifiers below) to the macro created."],
						},
						{
							type = "CheckBox",
							label = L["Down"],
							relativeWidth = 0.20,
							value = macroOptions.down,
							callback = function(_,_,value) macroOptions.down = value end,
							tooltip = L["Will bind ScrollWheelDown (plus modifiers below) to the macro created."],
						},
						{
							type = "Label",
							text = L["Modifiers:"],
							relativeWidth = 0.24,
							fontObject = GameFontNormal,
						},
						{
							type = "CheckBox",
							label = L["ALT"],
							relativeWidth = 0.25,
							value = macroOptions.alt,
							callback = function(_,_,value) macroOptions.alt = value end,
						},
						{
							type = "CheckBox",
							label = L["CTRL"],
							relativeWidth = 0.25,
							value = macroOptions.ctrl,
							callback = function(_,_,value) macroOptions.ctrl = value end,
						},
						{
							type = "CheckBox",
							label = L["SHIFT"],
							relativeWidth = 0.25,
							value = macroOptions.shift,
							callback = function(_,_,value) macroOptions.shift = value end,
						},
						{
							type = "Button",
							relativeWidth = 1,
							text = L["Create Macro and Bind ScrollWheel (with selected options)"],
							callback = function()
									DeleteMacro("TSMAucBClick")
									CreateMacro("TSMAucBClick", 1, "/click TSMAucCancelButton\n/click TSMAucPostButton")
									
									local modString = ""
									if macroOptions.ctrl then
										modString = modString .. "CTRL-"
									end
									if macroOptions.alt then
										modString = modString .. "ALT-"
									end
									if macroOptions.shift then
										modString = modString .. "SHIFT-"
									end
									
									local bindingNum = GetCurrentBindingSet()
									bindingNum = (bindingNum == 1) and 2 or 1
									
									if macroOptions.up then
										SetBinding(modString.."MOUSEWHEELUP", nil, bindingNum)
										SetBinding(modString.."MOUSEWHEELUP", "MACRO TSMAucBClick", bindingNum)
									end
									if macroOptions.down then
										SetBinding(modString.."MOUSEWHEELDOWN", nil, bindingNum)
										SetBinding(modString.."MOUSEWHEELDOWN", "MACRO TSMAucBClick", bindingNum)
									end
									SaveBindings(2)
									
									TSMAuc:Print(L["Macro created and keybinding set!"])
								end,
						},
					},
				},
			},
		}
	}
	
	if not AucAdvanced then
		for i, v in ipairs(page[1].children[1].children) do
			if v.label == L["Block Auctioneer while scanning"] then
				tremove(page[1].children[1].children, i)
				break
			end
		end
	end
	
	TSMAPI:BuildPage(container, page)
end

function Config:DrawGroupGeneral(container, group)
	if TSMAuc.db.global.msgID < 1 then
		TSMAuc.db.global.msgID = 1
		TSMAuc:Print("Important Note: If you are using % values for threshold or fallback, there has been a change to how this info will be displayed. The gold value a percent evaluates to will no longer show up in the group threshold / fallback editbox. This info will now show up in the label above the editboxes.")
	end

	local isDefaultPage = (group == "default")
	local overrideTooltip = "|cffff8888"..L["Right click to override this setting."].."|r"
	local unoverrideTooltip = "\n\n|cffff8888"..L["Right click to remove the override of this setting."].."|r"
	if isDefaultPage then
		overrideTooltip = ""
		unoverrideTooltip = ""
	end
	TSMAuc:UpdateGroupReverseLookup()
	
	local priceMethodList = {["gold"]=L["Fixed Gold Amount"]}
	if select(4, GetAddOnInfo("Auc-Advanced")) == 1 then
		priceMethodList["aucmarket"]=L["% of Auctioneer Market Value"]
		priceMethodList["aucappraiser"]=L["% of Auctioneer Appraiser"]
		priceMethodList["aucminbuyout"]=L["% of Auctioneer Minimum Buyout"]
	end
	if select(4, GetAddOnInfo("TradeSkillMaster_AuctionDB")) == 1 then
		priceMethodList["dbmarket"]=L["% of AuctionDB Market Value"]
		priceMethodList["dbminbuyout"]=L["% of AuctionDB Minimum Buyout"]
	end
	if select(4, GetAddOnInfo("TradeSkillMaster_Crafting")) == 1 then
		priceMethodList["crafting"]=L["% of Crafting cost"]
	end
	if select(4, GetAddOnInfo("ItemAuditor")) == 1 then
		priceMethodList["iacost"]=L["% of ItemAuditor cost"]
	end
	if select(4, GetAddOnInfo("TheUndermineJournal")) == 1 then
		priceMethodList["tujmarket"]=L["% of TheUndermineJournal Market Price"]
		priceMethodList["tujmean"]=L["% of TheUndermineJournal Mean"]
	end
	
	local GetGroupMoney
	
	local function GetValue(key)
		local categoryName = TSMAuc.groupReverseLookup[group]
		return TSMAuc.db.profile[key][group] or (categoryName and TSMAuc.db.profile[key][categoryName]) or TSMAuc.db.profile[key].default
	end
	
	local function GetInfo(num)
		local color = "|cfffed000"
		local isGroup = not (TSMAuc.db.profile.categories[group] or isDefaultPage)
	
		if num == 1 then
			local stacksOver = color..GetValue("ignoreStacksOver").."|r"
			local stacksUnder = color..GetValue("ignoreStacksUnder").."|r"
			local maxPriceGap = color..(GetValue("priceThreshold")*100).."%|r"
			local noCancel = GetValue("noCancel")
			local disabled = GetValue("disabled")
			
			if disabled then
				return format(L["Items in this group will not be posted or canceled automatically."])
			elseif noCancel then
				return format(L["When posting, ignore auctions with more than %s items or less than %s items in them. Ignoring the lowest auction if the price difference between the lowest two auctions is more than %s. Items in this group will not be canceled automatically."], stacksOver, stacksUnder, maxPriceGap)
			else
				return format(L["When posting and canceling, ignore auctions with more than %s item(s) or less than %s item(s) in them. Ignoring the lowest auction if the price difference between the lowest two auctions is more than %s."], stacksOver, stacksUnder, maxPriceGap)
			end
		elseif num == 2 then
			local duration = color..GetValue("postTime").."|r"
			local perAuction = color..GetValue("perAuction").."|r"
			local postCap = color..GetValue("postCap").."|r"
			local perAuctionIsCap = GetValue("perAuctionIsCap")
		
			if perAuctionIsCap and not TSMAuc.db.global.hideAdvanced then
				return format(L["Auctions will be posted for %s hours in stacks of up to %s. A maximum of %s auctions will be posted."], duration, perAuction, postCap)
			else
				return format(L["Auctions will be posted for %s hours in stacks of %s. A maximum of %s auctions will be posted."], duration, perAuction, postCap)
			end
		elseif num == 3 then
			local undercut = TSMAuc:FormatTextMoney(GetValue("undercut"))
			local bidPercent = color..(GetValue("bidPercent")*100).."|r"
		
			return format(L["Auctioning will undercut your competition by %s. When posting, the bid of your auctions will be set to %s percent of the buyout."], undercut, bidPercent)
		elseif num == 4 then
			local threshold = GetGroupMoney("threshold", true)
			local thresholdMethod = Config:GetConfigValue(group, "thresholdPriceMethod")
			local percentText
			if thresholdMethod and thresholdMethod ~= "gold" then
				percentText = (Config:GetConfigValue(group, "thresholdPercent")*100)..priceMethodList[thresholdMethod]
			end
			
			if not isGroup and percentText then
				threshold = percentText
			elseif percentText then
				threshold = threshold.." ("..percentText..")"
			end
			
			if TSMAuc.db.global.hideAdvanced then
				return format(L["Auctioning will never post your auctions for below %s."], threshold)
			else
				return format(L["Auctioning will follow the 'Advanced Price Settings' when the market goes below %s."], threshold)
			end
		elseif num == 5 then
			local fallback = GetGroupMoney("fallback", true)
			local fallbackCap = TSMAuc:FormatTextMoney(GetValue("fallbackCap")*GetGroupMoney("fallback", true, true))
			
			local fallbackMethod = Config:GetConfigValue(group, "fallbackPriceMethod")
			local percentText
			local capText
			if fallbackMethod and fallbackMethod ~= "gold" then
				local percent = Config:GetConfigValue(group, "fallbackPercent")
				percentText = (percent*100)..(priceMethodList[fallbackMethod] or "")
				capText = percent*100*GetValue("fallbackCap")..(priceMethodList[fallbackMethod] or "")
			end
			
			if not isGroup and percentText then
				fallback = percentText
				fallbackCap = capText
			elseif percentText then
				fallback = fallback.." ("..percentText..")"
			end
		
			return format(L["Auctioning will post at %s when you are the only one posting below %s."], fallback, fallbackCap)
		elseif num == 6 then
			local reset = GetValue("reset")
			local fallback = TSMAuc:FormatTextMoney(GetValue("fallback"))
			local threshold = TSMAuc:FormatTextMoney(GetValue("threshold"))
			local resetPrice = TSMAuc:FormatTextMoney(GetValue("resetPrice"))
			
			if reset == "none" then
				return L["Auctions will not be posted when the market goes below your threshold."]
			elseif reset == "threshold" then
				return format(L["Auctions will be posted at your threshold price of %s when the market goes below your threshold."], threshold)
			elseif reset == "fallback" then
				return format(L["Auctions will be posted at your fallback price of %s when the market goes below your threshold."], fallback)
			elseif reset == "custom" then
				return format(L["Auctions will be posted at %s when the market goes below your threshold."], resetPrice)
			end
		end
	end
	
	local function SetGroupOverride(key, value, widget)
		debug(key, value)
		if not value then
			TSMAuc.db.profile[key][group] = nil
		else
			TSMAuc.db.profile[key][group] = Config:GetConfigValue(group, key, true)
		end
		
		widget:SetDisabled(not value)
		if widget.type == "TSMOverrideEditBox" then
			widget:SetText(GetGroupMoney(key))
		elseif widget.type == "TSMOverrideSlider" then
			widget:SetValue(Config:GetConfigValue(group, key, true))
			widget.editbox:ClearFocus()
		end
	end

	local function GetGroupOverride(key)
		if isDefaultPage then return false end
		
		return TSMAuc.db.profile[key][group] ~= nil
	end
	
	local function SetGroupMoney(key, value, editBox)
		local gold = tonumber(string.match(value, "([0-9]+)|c([0-9a-fA-F]+)g|r") or string.match(value, "([0-9]+)g"))
		local silver = tonumber(string.match(value, "([0-9]+)|c([0-9a-fA-F]+)s|r") or string.match(value, "([0-9]+)s"))
		local copper = tonumber(string.match(value, "([0-9]+)|c([0-9a-fA-F]+)c|r") or string.match(value, "([0-9]+)c"))
		local percent = tonumber(string.match(value, "([0-9]+)|c([0-9a-fA-F]+)%%|r") or string.match(value, "([0-9]+)%%"))
		local goldMethod = TSMAuc.db.profile[key.."PriceMethod"] and TSMAuc.db.profile[key.."PriceMethod"][group] == "gold" or not TSMAuc.db.profile[key.."PriceMethod"]
		debug(percent, goldMethod)
		
		if not gold and not silver and not copper and goldMethod then
			TSMAPI:SetStatusText(L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."])
			editBox:SetFocus()
			return
		elseif not percent and TSMAuc.db.profile[key.."PriceMethod"] and TSMAuc.db.profile[key.."PriceMethod"][group] ~= "gold" then
			TSMAPI:SetStatusText(L["Invalid percent format entered, should be \"#%\", \"105%\" is 105 percent."])
			editBox:SetFocus()
			return
		elseif gold or silver or copper then
			-- Convert it all into copper
			copper = (copper or 0) + ((gold or 0) * COPPER_PER_GOLD) + ((silver or 0) * COPPER_PER_SILVER)
			TSMAuc.db.profile[key][group] = copper
		elseif percent then
			TSMAuc.db.profile[key.."Percent"][group] = percent/100
		end
		
		editBox:SetText(GetGroupMoney(key))
		TSMAPI:SetStatusText()
		container:SelectTab(1)
	end

	GetGroupMoney = function(key, noExtraText, noFormatting)
		local groupValue = Config:GetConfigValue(group, key)
		local defaultValue = TSMAuc.db.profile[key].default
		local extraText = ""
		
		if key ~= "undercut" and Config:GetConfigValue(group, key.."PriceMethod") ~= "gold" then
			local percent = Config:GetConfigValue(group, key.."Percent")
			if percent then
				if not noExtraText then return (percent*100).."%" end
				extraText = " ("..(percent*100).."%)"
			else
				percent = floor((TSMAPI:SafeDivide(Config:GetConfigValue(group, key) or 0, TSMAuc:GetMarketValue(group, nil, Config:GetConfigValue(group, key.."PriceMethod"))))*1000 + 0.5)/10
				TSMAuc.db.profile[key.."Percent"][group] = percent/100
				if not noExtraText then return percent.."%" end
				extraText = " ("..percent.."%)"
			end
			
			-- if it's not a group then it's either a category or default in which case just return the percent
			if not TSMAuc.db.profile.groups[group] then
				if noFormatting then
					return percent*100
				else
					return percent*100 .. "%"
				end
			end
		end
		
		if noExtraText then extraText = "" end
		
		-- if we aren't overriding, the option will be disabled so strip color codes so it all grays out
		if not isDefaultPage and not TSMAuc.db.profile[key][group] then
			if not noFormatting then
				return TSMAuc:FormatTextMoney(groupValue or defaultValue, nil, not noExtraText) .. extraText
			else
				return tonumber(groupValue)
			end
		end
		if not noFormatting then
			return TSMAuc:FormatTextMoney(groupValue) .. extraText
		else
			return tonumber(groupValue)
		end
	end
	
	local function GetCustomResetSliderValues(func)
		local fallback = Config:GetConfigValue(groupName, "fallback", true)
		local threshold = Config:GetConfigValue(groupName, "threshold", true)
		local fallbackCap = Config:GetConfigValue(groupName, "fallbackCap", true)
		return func(floor(threshold*0.5/COPPER_PER_GOLD+0.5), floor(fallback*fallbackCap/COPPER_PER_GOLD+0.5))
	end

	local page = {
		{	-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Help"],
					hidden = not isDefaultPage,
					children = {
						{
							type = "Label",
							fullWidth = true,
							fontObject = GameFontNormal,
							text = L["The below are fallback settings for groups, if you do not override a setting in a group then it will use the settings below.\n\nWarning! All auction prices are per item, not overall. If you set it to post at a fallback of 1g and you post in stacks of 20 that means the fallback will be 20g."],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "Flow",
					title = L["General Settings"],
					hidden = TSMAuc.db.global.hideAdvanced,
					children = {
						{
							type = "Label",
							fullWidth = true,
							fontObject = GameFontNormal,
							text = GetInfo(1),
							hidden = TSMAuc.db.global.hideHelp,
						},
						{
							type = "HeadingLine",
							hidden = TSMAuc.db.global.hideHelp,
						},
						{
							type = "Slider",
							settingInfo = {"ignoreStacksUnder", 1},
							label = L["Ignore stacks under"],
							isPercent = false,
							min = 1,
							max = 1000,
							step = 1,
							tooltip = L["Items that are stacked beyond the set amount are ignored when calculating the lowest market price."]..unoverrideTooltip,
						},
						{
							type = "Slider",
							settingInfo = {"ignoreStacksOver", 1},
							label = L["Ignore stacks over"],
							isPercent = false,
							min = 1,
							max = 1000,
							step = 1,
							tooltip = L["Items that are stacked beyond the set amount are ignored when calculating the lowest market price."]..unoverrideTooltip,
						},
						{
							type = "Slider",
							settingInfo = {"priceThreshold", 1, true},
							label = L["Maximum price gap"],
							isPercent = true,
							min = 0.1,
							max = 10,
							step = 0.05,
							tooltip = L["How much of a difference between auction prices should be allowed before posting at the second highest value.\n\nFor example. If Apple is posting Runed Scarlet Ruby at 50g, Orange posts one at 30g and you post one at 29g, then Oranges expires. If you set price threshold to 30% then it will cancel yours at 29g and post it at 49g next time because the difference in price is 42% and above the allowed threshold."]..unoverrideTooltip,
						},
						{
							type = "Dropdown",
							settingInfo = {"minDuration", 1},
							label = L["Ignore low duration auctions"],
							list = {[0]=L["<none>"], [1]=L["short (less than 30 minutes)"], [2]=L["medium (30 minutes - 2 hours)"], [3]=L["long (2 - 12 hours)"]},
							tooltip = L["Any auctions at or below the selected duration will be ignored. Selecting \"<none>\" will cause no auctions to be ignored based on duration."]..unoverrideTooltip,
						},
						{
							type = "CheckBox",
							settingInfo = {"noCancel", 1},
							label = L["Disable auto cancelling"],
							tooltip = L["Disable automatically cancelling of items in this group if undercut."]..unoverrideTooltip,
							hidden = isDefaultPage,
						},
						{
							type = "CheckBox",
							settingInfo = {"disabled", 1},
							label = L["Disable posting and canceling"],
							tooltip = L["Completely disables this group. This group will not be scanned for and will be effectively invisible to Auctioning."]..unoverrideTooltip,
							hidden = isDefaultPage,
						},
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "Flow",
					title = L["Post Settings (Quantity / Duration)"],
					children = {
						{
							type = "Label",
							fullWidth = true,
							fontObject = GameFontNormal,
							text = GetInfo(2),
							hidden = TSMAuc.db.global.hideHelp,
						},
						{
							type = "HeadingLine",
							hidden = TSMAuc.db.global.hideHelp,
						},
						{
							type = "Dropdown",
							settingInfo = {"postTime", 2},
							label = L["Post time"],
							list = {[12] = L["12 hours"], [24] = L["24 hours"], [48] = L["48 hours"]},
							tooltip = L["How long auctions should be up for."]..unoverrideTooltip,
						},
						{
							type = "Slider",
							settingInfo = {"postCap", 2},
							label = L["Post cap"],
							isPercent = false,
							min = 1,
							max = 500,
							step = 1,
							tooltip = L["How many auctions at the lowest price tier can be up at any one time."]..unoverrideTooltip,
						},
						{
							type = "Slider",
							settingInfo = {"perAuction", 2},
							label = L["Per auction"],
							isPercent = false,
							min = 1,
							max = 1000,
							step = 1,
							tooltip = L["How many items should be in a single auction, 20 will mean they are posted in stacks of 20."]..unoverrideTooltip,
						},
						{
							type = "CheckBox",
							settingInfo = {"perAuctionIsCap", 2},
							label = L["Use per auction as cap"],
							tooltip = L["If you don't have enough items for a full post, it will post with what you have."]..unoverrideTooltip,
							hidden = TSMAuc.db.global.hideAdvanced,
						},
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["General Price Settings (Undercut / Bid)"],
					children = {
						{
							type = "Label",
							fullWidth = true,
							fontObject = GameFontNormal,
							text = GetInfo(3),
							hidden = TSMAuc.db.global.hideHelp,
						},
						{
							type = "HeadingLine",
							hidden = TSMAuc.db.global.hideHelp,
						},
						{
							type = "EditBox",
							value = TSMAuc:FormatTextMoney(Config:GetConfigValue(group, "undercut", true), nil, TSMAuc.db.profile.undercut[group] == nil),
							label = L["Undercut by"],
							relativeWidth = 0.48,
							disabled = TSMAuc.db.profile.undercut[group] == nil,
							disabledTooltip = overrideTooltip,
							callback = function(self, _, value) SetGroupMoney("undercut", value, self) end,
							onRightClick = function(self, value) SetGroupOverride("undercut", value, self) end,
							tooltip = L["How much to undercut other auctions by, format is in \"#g#s#c\" but can be in any order, \"50g30s\" means 50 gold, 30 silver and so on."]..unoverrideTooltip,
						},
						{
							type = "Slider",
							settingInfo = {"bidPercent", 3, true},
							label = L["Bid percent"],
							isPercent = true,
							min = 0,
							max = 1,
							step = 0.05,
							tooltip = L["Percentage of the buyout as bid, if you set this to 90% then a 100g buyout will have a 90g bid."]..unoverrideTooltip,
						},
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Minimum Price Settings (Threshold)"],
					children = {
						{
							type = "Label",
							fullWidth = true,
							fontObject = GameFontNormal,
							text = GetInfo(4),
							hidden = TSMAuc.db.global.hideHelp
						},
						{
							type = "HeadingLine",
							hidden = TSMAuc.db.global.hideHelp
						},
						{
							type = "EditBox",
							value = GetGroupMoney("threshold"),
							label = L["Price threshold"],
							relativeWidth = 0.48,
							disabled = TSMAuc.db.profile.threshold[group] == nil,
							disabledTooltip = overrideTooltip,
							callback = function(self, _, value) SetGroupMoney("threshold", value, self) end,
							onRightClick = function(self, value)
									if not value then
										TSMAuc.db.profile.thresholdPriceMethod[group] = nil
									else
										TSMAuc.db.profile.thresholdPriceMethod[group] = Config:GetConfigValue(group, "thresholdPriceMethod", true)
									end
									if not value or Config:GetConfigValue(group, "thresholdPriceMethod", true) == "gold" then
										TSMAuc.db.profile.thresholdPercent[group] = nil
									else
										TSMAuc.db.profile.thresholdPercent[group] = Config:GetConfigValue(group, "thresholdPercent", true)
									end
									SetGroupOverride("threshold", value, self)
									container:SelectTab(1)
								end,
							tooltip = L["How low the market can go before an item should no longer be posted. The minimum price you want to post an item for."]..unoverrideTooltip,
						},
						{
							type = "Dropdown",
							label = L["Set threshold as a"],
							relativeWidth = 0.48,
							list = priceMethodList,
							value = Config:GetConfigValue(group, "thresholdPriceMethod"),
							disabled = TSMAuc.db.profile.threshold[group] == nil,
							callback = function(self,_,value)
									if value == "gold" then
										TSMAuc.db.profile.thresholdPercent[group] = nil
									elseif TSMAuc.db.profile.thresholdPriceMethod[group] ~= "gold" then
										TSMAuc.db.profile.thresholdPriceMethod[group] = value
										TSMAuc.db.profile.threshold[group] = Config:GetConfigValue(group, "threshold")
									end
									TSMAuc.db.profile.thresholdPriceMethod[group] = value
									local siblings = self.parent.children
									for i, v in pairs(siblings) do
										if v == self then
											siblings[i-1]:SetText(GetGroupMoney("threshold"))
											break
										end
									end
									container:SelectTab(1)
								end,
							tooltip = L["You can set a fixed threshold price for this group, or have the threshold price be automatically calculated to a percentage of a value. If you have multiple different items in this group and use a percentage, the highest value will be used for the entire group."],
							hidden = TSMAuc.db.global.hideAdvanced,
						},
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Maximum Price Settings (Fallback)"],
					children = {
						{
							type = "Label",
							fullWidth = true,
							fontObject = GameFontNormal,
							text = GetInfo(5),
							hidden = TSMAuc.db.global.hideHelp
						},
						{
							type = "HeadingLine",
							hidden = TSMAuc.db.global.hideHelp
						},
						{
							type = "EditBox",
							value = GetGroupMoney("fallback"),
							label = L["Fallback price"],
							relativeWidth = 0.48,
							disabled = TSMAuc.db.profile.fallback[group] == nil,
							disabledTooltip = overrideTooltip,
							callback = function(self, _, value) SetGroupMoney("fallback", value, self) end,
							onRightClick = function(self, value)
									if not value then
										TSMAuc.db.profile.fallbackPriceMethod[group] = nil
									else
										TSMAuc.db.profile.fallbackPriceMethod[group] = Config:GetConfigValue(group, "fallbackPriceMethod", true)
									end
									if Config:GetConfigValue(group, "fallbackPriceMethod", true) == "gold" then
										TSMAuc.db.profile.fallbackPercent[group] = nil
									else
										TSMAuc.db.profile.fallbackPercent[group] = Config:GetConfigValue(group, "fallbackPercent", true)
									end
									SetGroupOverride("fallback", value, self)
									container:SelectTab(1)
								end,
							tooltip = L["Price to fallback too if there are no other auctions up, the lowest market price is too high."]..unoverrideTooltip,
						},
						{
							type = "Dropdown",
							label = L["Set fallback as a"],
							relativeWidth = 0.48,
							list = priceMethodList,
							value = Config:GetConfigValue(group, "fallbackPriceMethod"),
							disabled = TSMAuc.db.profile.fallback[group] == nil,
							callback = function(self,_,value)
									if value == "gold" then
										TSMAuc.db.profile.fallbackPercent[group] = nil
									elseif TSMAuc.db.profile.fallbackPriceMethod[group] ~= "gold" then
										TSMAuc.db.profile.fallbackPriceMethod[group] = value
										TSMAuc.db.profile.fallback[group] = Config:GetConfigValue(group, "fallback")
									end
									TSMAuc.db.profile.fallbackPriceMethod[group] = value
									local siblings = self.parent.children
									for i, v in pairs(siblings) do
										if v == self then
											siblings[i-1]:SetText(GetGroupMoney("fallback"))
											break
										end
									end
									container:SelectTab(1)
								end,
							tooltip = L["You can set a fixed fallback price for this group, or have the fallback price be automatically calculated to a percentage of a value. If you have multiple different items in this group and use a percentage, the highest value will be used for the entire group."],
							hidden = TSMAuc.db.global.hideAdvanced,
						},
						{
							type = "Slider",
							settingInfo = {"fallbackCap", 5, true},
							label = L["Maximum price"],
							isPercent = true,
							min = 1,
							max = 10,
							step = 0.1,
							tooltip = L["If the market price is above fallback price * maximum price, items will be posted at the fallback * maximum price instead.\n\nEffective for posting prices in a sane price range when someone is posting an item at 5000g when it only goes for 100g."]..unoverrideTooltip,
							hidden = TSMAuc.db.global.hideAdvanced,
						},
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Advanced Price Settings (Market Reset)"],
					hidden = TSMAuc.db.global.hideAdvanced,
					children = {
						{
							type = "Label",
							fullWidth = true,
							fontObject = GameFontNormal,
							text = GetInfo(6),
							hidden = TSMAuc.db.global.hideHelp
						},
						{
							type = "HeadingLine",
							hidden = TSMAuc.db.global.hideHelp
						},
						{
							type = "Dropdown",
							label = "Reset Method",
							relativeWidth = 0.48,
							list = {["none"]=L["Don't Post Items"], ["threshold"]=L["Post at Threshold"], ["fallback"]=L["Post at Fallback"], ["custom"]=L["Custom Value"]},
							value = Config:GetConfigValue(group, "reset", true),
							disabled = TSMAuc.db.profile.reset[group] == nil,
							disabledTooltip = overrideTooltip,
							callback = function(self,_,value)
									local oldValue = TSMAuc.db.profile.reset[group]
									TSMAuc.db.profile.reset[group] = value
									if value == "custom" or oldValue == "custom" then
										TSMAuc.db.profile.resetPrice[group] = (TSMAuc.db.profile.threshold[group] or TSMAuc.db.profile.threshold.default)
										container:SelectTab(1)
									end
									if value ~= "custom" then
										TSMAuc.db.profile.resetPrice[group] = nil
									end
									container:SelectTab(1)
								end,
							onRightClick = function(self, value) SetGroupOverride("reset", value, self) container:SelectTab(1) end,
							tooltip = L["This dropdown determines what Auctioning will do when the market for an item goes below your threshold value. You can either not post the items or post at your fallback/threshold/a custom value."]
						},
						{
							type = "Slider",
							value = (Config:GetConfigValue(group, "resetPrice", true) or 50000)/COPPER_PER_GOLD,
							label = L["Custom Reset Price (gold)"],
							relativeWidth = 0.48,
							min = GetCustomResetSliderValues(min),
							max = GetCustomResetSliderValues(max),
							step = 1,
							callback = function(self,_,value)
									TSMAuc.db.profile.resetPrice[group] = value*COPPER_PER_GOLD
									if not TSMAuc.db.global.hideHelp then self.parent.children[1]:SetText(GetInfo(6)) end
								end,
							tooltip = L["Custom market reset price. If the market goes below your threshold, items will be posted at this price."],
							hidden = TSMAuc.db.profile.reset[group] ~= "custom",
						},
					},
				},
			},
		},
	}
	
	local function PreparePage(data)
		for i=#data, 1, -1 do
			if data[i].hidden then
				tremove(data, i)
			elseif data[i].onRightClick and isDefaultPage then
				data[i].onRightClick = nil
				data[i].disabledTooltip = nil
			elseif data[i].children then
				PreparePage(data[i].children)
			end
		end
		
		for i=1, #data do
			if data[i].settingInfo then
				local key, num, rounding
				if type(data[i].settingInfo) == "table" then
					key, num, rounding = unpack(data[i].settingInfo)
				else
					key = data[i].settingInfo
				end
				
				data[i].value = Config:GetConfigValue(group, key, true)
				data[i].relativeWidth = data[i].relativeWidth or 0.48
				data[i].disabled = TSMAuc.db.profile[key][group] == nil
				data[i].disabledTooltip = overrideTooltip
				
				data[i].onRightClick = function(self, value)
					SetGroupOverride(key, value, self)
				end
				if num then
					data[i].callback = function(self, _, value)
						if rounding then
							value = floor(value*100 + 0.5)/100
						end
						TSMAuc.db.profile[key][group] = value
						if not TSMAuc.db.global.hideHelp then
							self.parent.children[1]:SetText(GetInfo(num))
						end
					end
				end
				data[i].settingInfo = nil
			end
		end
	end
	
	PreparePage(page[1].children)
	TSMAPI:BuildPage(container, page)
end

function Config:DrawProfiles(container)
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
		current = L["Current Profile:"] .. " |cff99ffff" .. TSMAuc.db:GetCurrentProfile() .. "|r",
	}
	
	-- Popup Confirmation Window used in this module
	StaticPopupDialogs["TSMAucProfiles.DeleteConfirm"] = StaticPopupDialogs["TSMAucProfiles.DeleteConfirm"] or {
		text = L["Are you sure you want to delete the selected profile?"],
		button1 = YES,
		button2 = CANCEL,
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
					text = "TradeSkillMaster_Auctioning" .. "\n",
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
							callback = function() TSMAuc.db:ResetProfile() end,
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
									TSMAuc.db:SetProfile(value)
									container:SelectTab(4)
								end,
						},
						{
							type = "Dropdown",
							label = text["choose"],
							list = GetProfileList(TSMAuc.db, true, nil),
							value = TSMAuc.db:GetCurrentProfile(),
							callback = function(_,_,value)
									if value ~= TSMAuc.db:GetCurrentProfile() then
										TSMAuc.db:SetProfile(value)
										container:SelectTab(4)
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
					list = GetProfileList(TSMAuc.db, true, nil),
					value = "",
					disabled = not GetProfileList(TSMAuc.db, true, nil) and true,
					callback = function(_,_,value)
							if value ~= TSMAuc.db:GetCurrentProfile() then
								TSMAuc.db:CopyProfile(value)
								container:SelectTab(4)
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
					list = GetProfileList(TSMAuc.db, true, nil),
					value = "",
					disabled = not GetProfileList(TSMAuc.db, true, nil) and true,
					callback = function(_,_,value)
							StaticPopupDialogs["TSMAucProfiles.DeleteConfirm"].OnAccept = function()
									TSMAuc.db:DeleteProfile(value)
									container:SelectTab(4)
								end
							StaticPopup_Show("TSMAucProfiles.DeleteConfirm")
						end,
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

function Config:DrawItemGroups(container)
	local function AddGroup(editBox, _, value)
		local ok, name = pcall(function() return GetItemInfo(value) end)
		value = ok and name or value
		value = (strlower(value) or ""):trim()
		if not Config:ValidateName(value) then
			TSMAPI:SetStatusText(format(L["Group/Category named \"%s\" already exists!"], value))
			editBox:SetFocus()
			return
		elseif value == "" then
			TSMAPI:SetStatusText(L["Invalid group name."])
			editBox:SetFocus()
			return
		end
		
		TSMAuc.db.profile.groups[value] = {}
		if TSMAuc.db.global.smartGroupCreation then
			TSMAuc:UpdateItemReverseLookup()
			local addedItems = {}
			
			for bag=4, -2, -1 do
				if TSMAuc:IsValidBag(bag) then
					for slot=1, GetContainerNumSlots(bag) do
						local itemID = TSMAuc:GetItemString(GetContainerItemLink(bag, slot))
						if itemID then
							local name, link = GetItemInfo(itemID)
							if name and not TSMAuc.itemReverseLookup[itemID] and not Config:IsSoulbound(bag, slot, itemID) then
								local name = gsub(strlower(name), "-", " ")
								local tempValue = gsub(value, "-", " ")
								if strfind(name, tempValue) then
									TSMAuc.db.profile.groups[value][itemID] = true
									tinsert(addedItems, link)
								end
							end
						end
					end
				end
			end
			
			if #addedItems > 5 then
				TSMAuc:Print(format(L["Added %s items to %s automatically because they contained the group name in their name. You can turn this off in the options."], #addedItems, "\""..value.."\""))
			elseif #addedItems > 0 then
				TSMAuc:Print(format(L["Added the following items to %s automatically because they contained the group name in their name. You can turn this off in the options."], "\""..value.."\""))
				for i=1, #addedItems do
					print(addedItems[i])
				end
			end
		end
		
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(2, value)
	end
	
	local function AddCategory(editBox, _, value)
		local ok, name = pcall(function() return GetItemInfo(value) end)
		value = ok and name or value
		value = string.trim(strlower(value) or "")
		if not Config:ValidateName(value) then
			TSMAPI:SetStatusText(format(L["Group/Category named \"%s\" already exists!"], value))
			editBox:SetFocus()
			return
		elseif value == "" then
			TSMAPI:SetStatusText(L["Invalid category name."])
			editBox:SetFocus()
			return
		end
		
		TSMAuc.db.profile.categories[value] = {}
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(2, value)
	end

	local page = {
		{	-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Add group"],
					children = {
						{
							type = "Label",
							relativeWidth = 1,
							fontObject = GameFontNormal,
							text = L["A group contains items that you wish to sell with similar conditions (stack size, fallback price, etc).  Default settings may be overridden by a group's individual settings."],
						},
						{
							type = "EditBox",
							label = L["Group name"],
							relativeWidth = 0.8,
							callback = AddGroup,
							tooltip = L["Name of the new group, this can be whatever you want and has no relation to how the group itself functions."],
						},
						{
							type = "Spacer",
						},
						{
							type = "Button",
							text = L["Import Auctioning Group"],
							relativeWidth = 0.5,
							callback = TSMAuc.OpenImportFrame,
							tooltip = L["This feature can be used to import groups from outside of the game. For example, if somebody exported their group onto a blog, you could use this feature to import that group and Auctioning would create a group with the same settings / items."],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Add category"],
					children = {
						{
							type = "Label",
							relativeWidth = 1,
							fontObject = GameFontNormal,
							text = L["A category contains groups with similar settings and acts like an organizational folder. You may override default settings by category (and then override category settings by group)."],
						},
						{
							type = "EditBox",
							label = L["Category name"],
							relativeWidth = 0.8,
							callback = AddCategory,
							tooltip = L["Name of the new category, this can be whatever you want and has no relation to how the category itself functions."],
						},
					},
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

function Config:DrawWhitelist(container)
	local function AddPlayer(self, _, value)
		value = string.trim(strlower(value or ""))
		if value == "" then return TSMAPI:SetStatusText(L["No name entered."]) end
		
		if TSMAuc.db.factionrealm.whitelist[value] then
			TSMAPI:SetStatusText(format(L["The player \"%s\" is already on your whitelist."], TSMAuc.db.factionrealm.whitelist[value]))
			return
		end
		
		if TSMAuc.db.factionrealm.blacklist[value] then
			TSMAPI:SetStatusText(L["You can not whitelist characters whom are on your blacklist."])
			return
		end
		
		for player in pairs(TSMAuc.db.factionrealm.player) do
			if strlower(player) == value then
				TSMAPI:SetStatusText(format(L["You do not need to add \"%s\", alts are whitelisted automatically."], player))
				return
			end
		end
		
		TSMAPI:SetStatusText()
		TSMAuc.db.factionrealm.whitelist[strlower(value)] = value
		self.parent.parent.parent:SelectTab(2)
	end

	local page = {
		{	-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Help"],
					children = {
						{
							type = "Label",
							fullWidth = true,
							fontObject = GameFontNormal,
							text = L["Whitelists allow you to set other players besides you and your alts that you do not want to undercut; however, if somebody on your whitelist matches your buyout but lists a lower bid it will still consider them undercutting."],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Add player"],
					children = {
						{
							type = "EditBox",
							label = L["Player name"],
							relativeWidth = 0.5,
							callback = AddPlayer,
							tooltip = L["Add a new player to your whitelist."],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Whitelist"],
					children = {},
				},
			},
		},
	}
	
	for name in pairs(TSMAuc.db.factionrealm.whitelist) do
		tinsert(page[1].children[3].children,
			{
				type = "Label",
				text = TSMAuc.db.factionrealm.whitelist[name],
				fontObject = GameFontNormal,
			})
		tinsert(page[1].children[3].children,
			{
				type = "Button",
				text = L["Delete"],
				relativeWidth = 0.3,
				callback = function(self)
						TSMAuc.db.factionrealm.whitelist[name] = nil
						container:SelectTab(2)
					end,
			})
	end
	
	if #(page[1].children[3].children) == 0 then
		tinsert(page[1].children[3].children,
			{
				type = "Label",
				text = L["You do not have any players on your whitelist yet."],
				fontObject = GameFontNormal,
				fullWidth = true,
			})
	end
	
	TSMAPI:BuildPage(container, page)
end

function Config:DrawBlacklist(container)
	local function AddPlayer(self, _, value)
		value = string.trim(strlower(value or ""))
		if value == "" then return TSMAPI:SetStatusText(L["No name entered."]) end
		
		if TSMAuc.db.factionrealm.blacklist[value] then
			TSMAPI:SetStatusText(format(L["The player \"%s\" is already on your blacklist."], TSMAuc.db.factionrealm.blacklist[value]))
			return
		end
		
		if TSMAuc.db.factionrealm.whitelist[value] then
			TSMAPI:SetStatusText(L["You can not blacklist characters whom are on your whitelist."])
			return
		end
		
		for player in pairs(TSMAuc.db.factionrealm.player) do
			if strlower(player) == value then
				TSMAPI:SetStatusText(L["You can not blacklist yourself."])
				return
			end
		end
		
		TSMAPI:SetStatusText()
		TSMAuc.db.factionrealm.blacklist[strlower(value)] = value
		self.parent.parent.parent:SelectTab(3)
	end

	local page = {
		{	-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Help"],
					children = {
						{
							type = "Label",
							fullWidth = true,
							fontObject = GameFontNormal,
							text = L["Blacklists allows you to undercut a competitor no matter how low their threshold may be. If the lowest auction of an item is owned by somebody on your blacklist, your threshold will be ignored for that item and you will undercut them regardless of whether they are above or below your threshold."],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Add player"],
					children = {
						{
							type = "EditBox",
							label = L["Player name"],
							relativeWidth = 0.5,
							callback = AddPlayer,
							tooltip = L["Add a new player to your blacklist."],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Blacklist"],
					children = {},
				},
			},
		},
	}
	
	for name in pairs(TSMAuc.db.factionrealm.blacklist) do
		tinsert(page[1].children[3].children,
			{
				type = "Label",
				text = TSMAuc.db.factionrealm.blacklist[name],
				fontObject = GameFontNormal,
			})
		tinsert(page[1].children[3].children,
			{
				type = "Button",
				text = L["Delete"],
				relativeWidth = 0.3,
				callback = function(self)
						TSMAuc.db.factionrealm.blacklist[name] = nil
						container:SelectTab(3)
					end,
			})
	end
	
	if #(page[1].children[3].children) == 0 then
		tinsert(page[1].children[3].children,
			{
				type = "Label",
				text = L["You do not have any players on your blacklist yet."],
				fontObject = GameFontNormal,
				fullWidth = true,
			})
	end
	
	TSMAPI:BuildPage(container, page)
end

function Config:DrawGroupManagement(container, group)
	TSMAuc:UpdateGroupReverseLookup()
	local function RenameGroup(self, _, value)
		local ok, name = pcall(function() return GetItemInfo(value) end)
		value = ok and name or value
		TSMAuc:UpdateGroupReverseLookup()
		value = string.trim(strlower(value or ""))
		if not Config:ValidateName(value) then
			TSMAPI:SetStatusText(format(L["Group/Category named \"%s\" already exists!"], value))
			self:SetFocus()
			return
		elseif value == "" then
			TSMAPI:SetStatusText(L["Invalid group name."])
			return
		end
		
		TSMAPI:SetStatusText()
		TSMAuc.db.profile.groups[value] = CopyTable(TSMAuc.db.profile.groups[group])
		TSMAuc.db.profile.groups[group] = nil
		for key, data in pairs(TSMAuc.db.profile) do
			if type(data) == "table" and data[group] ~= nil then
				data[value] = data[group]
				data[group] = nil
			end
		end
		if TSMAuc.groupReverseLookup[group] then
			TSMAuc.db.profile.categories[TSMAuc.groupReverseLookup[group]][value] = true
			TSMAuc.db.profile.categories[TSMAuc.groupReverseLookup[group]][group] = nil
		end
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(2, value)
		group = value
	end
	
	local function DeleteGroup(confirmed)
		if confirmed then
			-- Popup Confirmation Window used in this module
			StaticPopupDialogs["TSMAucGroups.DeleteConfirm"] = StaticPopupDialogs["TSMAucGroups.DeleteConfirm"] or {
				text = L["Are you SURE you want to delete this group?"],
				button1 = YES,
				button2 = CANCEL,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				OnCancel = false,
			}
			StaticPopupDialogs["TSMAucGroups.DeleteConfirm"].OnAccept = function() DeleteGroup() end,
			StaticPopup_Show("TSMAucGroups.DeleteConfirm")
			-- need to make sure the popup doesn't open behind the TSM frame
			-- if the player has more than 10 popups open it's their fault!
			for i=1, 10 do
				if _G["StaticPopup" .. i].which == "TSMAucGroups.DeleteConfirm" then
					_G["StaticPopup" .. i]:SetFrameStrata("TOOLTIP")
					break
				end
			end
			
			return
		end
		TSMAuc:UpdateGroupReverseLookup()
		TSMAuc.db.profile.groups[group] = nil
		for key, data in pairs(TSMAuc.db.profile) do
			if type(data) == "table" and data[group] ~= nil then
				data[group] = nil
			end
		end
		if TSMAuc.groupReverseLookup[group] then
			TSMAuc.db.profile.categories[TSMAuc.groupReverseLookup[group]][group] = nil
		end
		
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(2)
	end

	local page = {
		{	-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Rename"],
					children = {
						{
							type = "EditBox",
							label = L["New group name"],
							callback = RenameGroup,
							tooltip = L["Rename this group to something else!"],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Delete"],
					children = {
						{
							type = "Button",
							text = L["Delete group"],
							relativeWidth = 0.3,
							callback = DeleteGroup,
							tooltip = L["Delete this group, this cannot be undone!"],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Export"],
					children = {
						{
							type = "Button",
							text = L["Export Group Data"],
							relativeWidth = 0.5,
							callback = function() TSMAuc:OpenExportFrame(group) end,
							tooltip = L["Exports the data for this group. This allows you to share your group data with other TradeSkillMaster_Auctioning users."],
						},
					},
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

function Config:DrawAddRemoveItem(container, group)
	if not TSMAuc.db.profile.groups[group] then return end
	TSMAuc:UpdateItemReverseLookup()
	
	local function SelectItemsMatching(selectionList, _, value)
		value = strlower(value:trim())
		selectionList:UnselectAllItems()
		if not value or value == "" then return end
		
		local itemList = {}
		for bag=4, -2, -1 do
			if TSMAuc:IsValidBag(bag) then
				for slot=1, GetContainerNumSlots(bag) do
					local itemID = TSMAuc:GetItemString(GetContainerItemLink(bag, slot))
					if itemID then
						local name = GetItemInfo(itemID)
						if name and strmatch(strlower(name), value) and not TSMAuc.itemReverseLookup[itemID] and not Config:IsSoulbound(bag, slot, itemID) then
							tinsert(itemList, itemID)
						end
					end
				end
			end
		end
		
		for itemID in pairs(TSMAuc.db.profile.groups[group]) do
			local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(itemID)
			if name and strmatch(strlower(name), value) then
				tinsert(itemList, itemID)
			end
		end
		
		selectionList:SelectItems(itemList)
	end
	
	local itemsInGroup = {}
	for itemID in pairs(TSMAuc.db.profile.groups[group]) do
		local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(itemID)
		if name then
			tinsert(itemsInGroup, {value=itemID, text=link, icon=texture, name=name})
		end
	end
	sort(itemsInGroup, function(a,b) return a.name<b.name end)
	
	local ungroupedItems, usedLinks = {}, {}
	for bag=4, -2, -1 do
		if TSMAuc:IsValidBag(bag) then
			for slot=1, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				local itemID = TSMAuc:GetItemString(link)
				if itemID and not usedLinks[itemID] and not TSMAuc.itemReverseLookup[itemID] and not Config:IsSoulbound(bag, slot, itemID) then
					local name, _, quality, _, _, _, _, _, _, texture = GetItemInfo(itemID)
					if not (TSMAuc.db.global.hideGray and quality == 0) then
						tinsert(ungroupedItems, {value=itemID, text=link, icon=texture, name=name})
						usedLinks[itemID] = true
					end
				end
			end
		end
	end
	sort(ungroupedItems, function(a,b) return a.name<b.name end)
	
	local page = {
		{	-- scroll frame to contain everything
			type = "SimpleGroup",
			layout = "Fill",
			children = {
				{
					type = "SelectionList",
					leftTitle = L["Items not in any group:"],
					rightTitle = L["Items in this group:"],
					filterTitle = L["Select Matches:"],
					filterTooltip = L["Selects all items in either list matching the entered filter. Entering \"Glyph of\" will select any item with \"Glyph of\" in the name."],
					leftList = ungroupedItems,
					rightList = itemsInGroup,
					onAdd = function(_,_,selected)
							for i=#selected, 1, -1 do
								TSMAuc.db.profile.groups[group][selected[i]] = true
							end
							container:SelectTab(2)
						end,
					onRemove = function(_,_,selected)
							for i=#selected, 1, -1 do
								TSMAuc.db.profile.groups[group][selected[i]] = nil
							end
							container:SelectTab(2)
						end,
					onFilter = SelectItemsMatching,
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

function Config:DrawCategoryManagement(container, category)
	local function RenameCategory(self, _, value)
		local ok, name = pcall(function() return GetItemInfo(value) end)
		value = ok and name or value
		value = string.trim(strlower(value or ""))
		if not Config:ValidateName(value) then
			TSMAPI:SetStatusText(format(L["Group/Category named \"%s\" already exists!"], value))
			return
		elseif value == "" then
			TSMAPI:SetStatusText(L["Invalid category name."])
			return
		end
		
		TSMAPI:SetStatusText()
		TSMAuc.db.profile.categories[value] = CopyTable(TSMAuc.db.profile.categories[category])
		TSMAuc.db.profile.categories[category] = nil
		for key, data in pairs(TSMAuc.db.profile) do
			if type(data) == "table" and data[category] ~= nil then
				data[value] = data[category]
				data[category] = nil
			end
		end
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(2, value)
		category = value
	end
	
	local function DeleteCategory(notConfirmed)
		if notConfirmed then
			-- Popup Confirmation Window used in this module
			StaticPopupDialogs["TSMAuc.Category.DeleteConfirm"] = StaticPopupDialogs["TSMAuc.Category.DeleteConfirm"] or {
				text = L["Are you SURE you want to delete this category?"],
				button1 = YES,
				button2 = CANCEL,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				OnCancel = false,
			}
			StaticPopupDialogs["TSMAuc.Category.DeleteConfirm"].OnAccept = function() DeleteCategory() end,
			StaticPopup_Show("TSMAuc.Category.DeleteConfirm")
			-- need to make sure the popup doesn't open behind the TSM frame
			-- if the player has more than 10 popups open it's their fault!
			for i=1, 10 do
				if _G["StaticPopup" .. i].which == "TSMAuc.Category.DeleteConfirm" then
					_G["StaticPopup" .. i]:SetFrameStrata("TOOLTIP")
					break
				end
			end
			
			return
		end
		
		TSMAuc.db.profile.categories[category] = nil
		for key, data in pairs(TSMAuc.db.profile) do
			if type(data) == "table" and data[category] ~= nil then
				data[category] = nil
			end
		end
		
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(2)
	end
	
	local function DeleteGroupsInCategory(notConfirmed)
		if notConfirmed then
			-- Popup Confirmation Window used in this module
			StaticPopupDialogs["TSMAuc.GroupsInCategory.DeleteConfirm"] = StaticPopupDialogs["TSMAuc.GroupsInCategory.DeleteConfirm"] or {
				text = L["Are you SURE you want to delete all the groups in this category?"],
				button1 = YES,
				button2 = CANCEL,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				OnCancel = false,
			}
			StaticPopupDialogs["TSMAuc.GroupsInCategory.DeleteConfirm"].OnAccept = function() DeleteGroupsInCategory() end,
			StaticPopup_Show("TSMAuc.GroupsInCategory.DeleteConfirm")
			-- need to make sure the popup doesn't open behind the TSM frame
			-- if the player has more than 10 popups open it's their fault!
			for i=1, 10 do
				if _G["StaticPopup" .. i].which == "TSMAuc.GroupsInCategory.DeleteConfirm" then
					_G["StaticPopup" .. i]:SetFrameStrata("TOOLTIP")
					break
				end
			end
			
			return
		end
		
		for groupName in pairs(TSMAuc.db.profile.categories[category]) do
			for key, data in pairs(TSMAuc.db.profile) do
				if type(data) == "table" and key ~= "groups" and key ~= "categories" then
					data[groupName] = nil
				end
			end
			TSMAuc.db.profile.groups[groupName] = nil
		end
		TSMAuc.db.profile.categories[category] = {}
		
		Config:UpdateTree()
		Config.treeGroup:SelectByPath(2, category)
	end

	local page = {
		{	-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Rename"],
					children = {
						{
							type = "EditBox",
							label = L["New category name"],
							callback = RenameCategory,
							tooltip = L["Rename this category to something else!"],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Delete"],
					children = {
						{
							type = "Button",
							text = L["Delete category"],
							relativeWidth = 0.3,
							callback = DeleteCategory,
							tooltip = L["Delete this category, this cannot be undone!"],
						},
						{
							type = "Label",
							relativeWidth = 0.19,
						},
						{
							type = "Button",
							text = L["Delete All Groups In Category"],
							relativeWidth = 0.5,
							callback = DeleteGroupsInCategory,
							tooltip = L["Delete all groups inside this category. This cannot be undone!"],
						},
					},
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

function Config:DrawAddRemoveGroup(container, category)
	TSMAuc:UpdateGroupReverseLookup()
	
	local groupsInCategory = {}
	for groupName in pairs(TSMAuc.db.profile.categories[category]) do
		tinsert(groupsInCategory, {value=groupName, name=groupName, text=groupName})
	end
	sort(groupsInCategory, function(a,b) return a.name<b.name end)
	
	local uncategorizedGroups = {}
	for groupName in pairs(TSMAuc.db.profile.groups) do
		if not TSMAuc.groupReverseLookup[groupName] then
			tinsert(uncategorizedGroups, {value=groupName, name=groupName, text=groupName})
		end
	end
	sort(uncategorizedGroups, function(a,b) return a.name<b.name end)
	
	local page = {
		{	-- scroll frame to contain everything
			type = "SimpleGroup",
			layout = "Fill",
			children = {
				{
					type = "SelectionList",
					leftTitle = L["Uncategorized Groups:"],
					rightTitle = L["Groups in this Category:"],
					leftList = uncategorizedGroups,
					rightList = groupsInCategory,
					onAdd = function(_,_,selected)
							for i=#selected, 1, -1 do
								TSMAuc.db.profile.categories[category][selected[i]] = true
							end
							Config:UpdateTree()
							container:SelectTab(2)
						end,
					onRemove = function(_,_,selected)
							for i=#selected, 1, -1 do
								TSMAuc.db.profile.categories[category][selected[i]] = nil
							end
							Config:UpdateTree()
							container:SelectTab(2)
						end,
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end