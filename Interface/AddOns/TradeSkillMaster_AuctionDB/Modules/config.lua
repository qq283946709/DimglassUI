-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_AuctionDB - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctiondb.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local Config = TSM:NewModule("Config", "AceHook-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_AuctionDB") -- loads the localization table

local searchPage = 0
local filter = {text=nil, class=nil, subClass=nil}
local items = {}
local searchST
local ROW_HEIGHT = 16

-- options page
function Config:Load(parent)
	local vk = TSMAPI:GetVersionKey("TradeSkillMaster")
	if not vk or vk < 1 then
		local page = {
			{
				type = "ScrollFrame",
				layout = "flow",
				children = {
					{
						type = "Label",
						text = L["Your version of the main TradeSkillMaster addon is out of date. Please update it in order to be able to view this page."],
						fontObject = GameFontNormalLarge,
						relativeWidth = 1,
					},
				},
			},
		}
		
		TSMAPI:BuildPage(parent, page)
		return
	end
	filter = {}
	
	local tg = AceGUI:Create("TSMTabGroup")
	tg:SetLayout("Fill")
	tg:SetFullHeight(true)
	tg:SetFullWidth(true)
	tg:SetTabs({{value=1, text=L["Search"]}, {value=2, text=L["Options"]}})
	tg:SetCallback("OnGroupSelected", function(self,_,value)
		tg:ReleaseChildren()
		parent:DoLayout()
		
		if value == 1 then
			Config:LoadSearch(tg)
		elseif value == 2 then
			Config:LoadOptions(tg)
		end
	end)
	parent:AddChild(tg)
	tg:SelectTab(1)
end

local function getIndex(t, value)
	for i, v in pairs(t) do
		if v == value then
			return i
		end
	end
end

function Config:UpdateItems()
	wipe(items)
	local cache = {}
	local sortMethod = TSM.db.profile.resultsSortMethod
	local fClass = filter.class and select(filter.class, GetAuctionItemClasses())
	local fSubClass = filter.subClass and select(filter.subClass, GetAuctionItemSubClasses(filter.class))
	if filter.text or fClass then
		for itemID, data in pairs(TSM.data) do
			local name, _, rarity, ilvl, minlvl, class, subClass = GetItemInfo(itemID)
			if (name and filter.text and strfind(strlower(name), strlower(filter.text))) and (not fClass or (class == fClass and (not fSubClass or subClass == fSubClass))) and (not TSM.db.profile.hidePoorQualityItems or rarity > 0) then
				tinsert(items, itemID)
				if sortMethod == "name" then
					cache[itemID] = name
				elseif sortMethod == "ilvl" then
					cache[itemID] = ilvl
				elseif sortMethod == "minlvl" then
					cache[itemID] = minlvl
				elseif sortMethod == "marketvalue" then
					cache[itemID] = data.marketValue
				elseif sortMethod == "minbuyout" then
					cache[itemID] = data.minBuyout
				end
			end
		end
	end
	
	if TSM.db.profile.resultsSortOrder == "ascending" then
		sort(items, function(a, b) return (cache[a] or math.huge) < (cache[b] or math.huge) end)
	else
		sort(items, function(a, b) return (cache[a] or 0) > (cache[b] or 0) end)
	end
end

function Config:LoadSearch(container)
	local searchDataTmp = Config:GetSearchData()
	local results = {}
	local totalResults = #items
	local minIndex = searchPage * TSM.db.profile.resultsPerPage + 1
	local maxIndex = min(TSM.db.profile.resultsPerPage*(searchPage+1), totalResults)
	if totalResults == 0 then
		if filter.text then
			results = {
				{
					type = "Spacer",
					quantity = 2,
				},
				{
					type = "Label",
					relativeWidth = 0.4
				},
				{
					type = "Label",
					relativeWidth = 0.6,
					text = L["No items found"],
					fontObject = GameFontNormalLarge,
				},
			}
		else
			results = {
				{
					type = "Spacer",
					quantity = 2,
				},
				{
					type = "Label",
					relativeWidth = 0.05
				},
				{
					type = "Label",
					relativeWidth = 0.949,
					text = L["Use the search box and category filters above to search the AuctionDB data."],
					fontObject = GameFontNormalLarge,
				},
			}
		end
	end
	
	local classes, subClasses = {}, {}
	for i, className in ipairs({GetAuctionItemClasses()}) do
		classes[i] = className
		subClasses[i] = {}
		for j, subClassName in ipairs({GetAuctionItemSubClasses(i)}) do
			subClasses[i][j] = subClassName
		end
		tinsert(subClasses[i], L["<No Item SubType Filter>"])
	end
	tinsert(classes, L["<No Item Type Filter>"])

	local page = {
		{
			type = "SimpleGroup",
			layout = "Flow",
			fullHeight = true,
			children = {
				{
					type = "Label",
					text = L["You can use this page to lookup an item or group of items in the AuctionDB database. Note that this does not perform a live search of the AH."],
					relativeWidth = 1,
				},
				{
					type = "HeadingLine",
				},
				{
					type = "EditBox",
					label = L["Search"],
					value = filter.text,
					relativeWidth = 0.49,
					callback = function(_,_,value)
							filter.text = (value or ""):trim()
							searchPage = 0
							container:SelectTab(1)
						end,
					tooltip = L["Any items in the AuctionDB database that contain the search phrase in their names will be displayed."],
				},
				{
					type = "Dropdown",
					label = L["Item Type Filter"],
					list = classes,
					value = filter.class or #classes,
					relativeWidth = 0.25,
					callback = function(self,_,value)
							filter.text = filter.text or ""
							if value ~= filter.class then
								filter.subClass = nil
							end
							if value == #classes then
								filter.class = nil
							else
								filter.class = value
							end
							searchPage = 0
							container:SelectTab(1)
						end,
					tooltip = L["You can filter the results by item type by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in this dropdown and \"Herbs\" as the subtype filter."],
				},
				{
					type = "Dropdown",
					label = L["Item SubType Filter"],
					disabled = filter.class == nil or (subClasses[filter.class] and #subClasses[filter.class] == 0),
					list = subClasses[filter.class or 0],
					value = filter.subClass or #(subClasses[filter.class or 0] or {}),
					relativeWidth = 0.25,
					callback = function(_,_,value)
							if value == #subClasses[filter.class] then
								filter.subClass = nil
							else
								filter.subClass = value
							end
							searchPage = 0
							container:SelectTab(1)
						end,
					tooltip = L["You can filter the results by item subtype by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in the item type dropdown and \"Herbs\" in this dropdown."],
				},
				{
					type = "Label",
					relativeWidth = 0.15
				},
				{
					type = "Button",
					text = L["Refresh"],
					relativeWidth = 0.2,
					callback = function()
							searchPage = 0
							Config:UpdateItems()
							container:SelectTab(1)
							container:DoLayout()
						end,
					tooltip = L["Refreshes the current search results."],
				},
				{
					type = "Label",
					relativeWidth = 0.15
				},
				{
					type = "Icon",
					image = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up",
					width = 24,
					imageWidth = 24,
					imageHeight = 24,
					disabled = minIndex == 1,
					callback = function(self)
							searchPage = searchPage - 1
							container:SelectTab(1)
						end,
					tooltip = L["Previous Page"],
				},
				{
					type = "Label",
					relativeWidth = 0.03
				},
				{
					type = "Label",
					text = format(L["Items %s - %s (%s total)"], minIndex, maxIndex, totalResults),
					relativeWidth = 0.35,
				},
				{
					type = "Icon",
					image = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up",
					width = 24,
					imageWidth = 24,
					imageHeight = 24,
					disabled = maxIndex == totalResults,
					callback = function(self)
							searchPage = searchPage + 1
							container:SelectTab(1)
						end,
					tooltip = L["Next Page"],
				},
				{
					type = "HeadingLine"
				},
				{
					type = "SimpleGroup",
					fullHeight = true,
					layout = "Flow",
					children = results,
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
	
	local stParent = container.children[1].children[#container.children[1].children].frame
	local colInfo = Config:GetSTColInfo(container.frame:GetWidth())

	if not searchST then
		searchST = TSMAPI:CreateScrollingTable(colInfo)
	end
	Config:UnhookAll()
	Config:HookScript(stParent, "OnHide", function() Config:UnhookAll() searchST:Hide() end)
	searchST.frame:SetParent(stParent)
	searchST.frame:SetPoint("BOTTOMLEFT", stParent, 2, 2)
	searchST.frame:SetPoint("TOPRIGHT", stParent, -2, -8)
	searchST.frame:SetScript("OnSizeChanged", function(_,width, height)
			searchST:SetDisplayCols(Config:GetSTColInfo(width))
			searchST:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
		end)
	searchST:Show()
	searchST:SetData(searchDataTmp)
	searchST.frame:GetScript("OnSizeChanged")(searchST.frame, searchST.frame:GetWidth(), searchST.frame:GetHeight())
	
	local font, size = GameFontNormal:GetFont()
	for i, row in ipairs(searchST.rows) do
		for j, col in ipairs(row.cols) do
			col.text:SetFont(font, size-1)
		end
	end
	
	searchST:RegisterEvents({
		["OnEnter"] = function(_, self, data, _, _, rowNum)
			if not rowNum then return end
			
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetHyperlink("item:"..data[rowNum].itemID)
			GameTooltip:Show()
		end,
		["OnLeave"] = function()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end})
end

local stCols = {
	{
		name = L["Item Link"],
		width = 0.38,
		defaultsort = "asc",
		comparesort = ColSortMethod,
	},
	{
		name = L["Num(Yours)"],
		width = 0.1,
		defaultsort = "dsc",
		comparesort = ColSortMethod,
	},
	{
		name = L["Minimum Buyout"],
		width = 0.15,
		defaultsort = "dsc",
		comparesort = ColSortMethod,
	},
	{
		name = L["Market Value"],
		width = 0.15,
		defaultsort = "dsc",
		comparesort = ColSortMethod,
	},
	{
		name = L["Last Scanned"],
		width = 0.21,
		defaultsort = "dsc",
		comparesort = ColSortMethod,
	},
}

function Config:GetSTColInfo(width)
	local colInfo = CopyTable(stCols)
	
	for i=1, #colInfo do
		colInfo[i].width = floor(colInfo[i].width*width)
	end
	
	return colInfo
end

function Config:GetSearchData()
	Config:UpdateItems()
	local stData = {}
	
	local totalResults = #items
	local minIndex = searchPage * TSM.db.profile.resultsPerPage + 1
	local maxIndex = min(TSM.db.profile.resultsPerPage*(searchPage+1), totalResults)
	if totalResults > 0 then
		for i=minIndex, maxIndex do
			local itemID = items[i]
			local data = TSM.data[items[i]]
			local playerQuantity = TSMAPI:GetData("totalplayerauctions", itemID)
			local timeDiff = data.lastScan and SecondsToTime(time()-data.lastScan)
			local name, link = GetItemInfo(itemID)
			tinsert(stData, {
					cols = {
						{
							value = link or "???",
							args = {name},
						},
						{
							value = data.currentQuantity..(playerQuantity and " |cffffbb00("..playerQuantity..")|r" or ""),
							args = {data.currentQuantity},
						},
						{
							value = TSM:FormatMoneyText(data.minBuyout) or "---",
							args = {data.minBuyout or 0},
						},
						{
							value = TSM:FormatMoneyText(data.marketValue) or "---",
							args = {data.marketValue or 0},
						},
						{
							value = (timeDiff and "|cff99ffff"..format(L["%s ago"], timeDiff).."|r" or "|cff99ffff---|r"),
							args = {timeDiff or 0},
						},
					},
					itemID = itemID,
				})
		end
	end
	
	return stData
end

function Config:LoadOptions(container)
	local page = {
		{
			type = "ScrollFrame",
			layout = "Flow",
			children = {
				{
					type = "InlineGroup",
					title = L["General Options"],
					layout = "Flow",
					children = {
						{
							type = "CheckBox",
							label = L["Enable display of AuctionDB data in tooltip."],
							value = TSM.db.profile.tooltip,
							relativeWidth = 0.5,
							callback = function(_,_,value)
									TSM.db.profile.tooltip = value
									if value then
										TSMAPI:RegisterTooltip("TradeSkillMaster_AuctionDB", function(...) return TSM:LoadTooltip(...) end)
									else
										TSMAPI:UnregisterTooltip("TradeSkillMaster_AuctionDB")
									end
								end,
						},
					},
				},
				{
					type = "InlineGroup",
					title = L["Search Options"],
					layout = "Flow",
					children = {
						{
							type = "EditBox",
							label = L["Items per page"],
							value = TSM.db.profile.resultsPerPage,
							relativeWidth = 0.2,
							callback = function(_,_,value)
									value = tonumber(value)
									if value and value <= 500 and value >= 5 then
										TSM.db.profile.resultsPerPage = value
									else
										TSM:Print(L["Invalid value entered. You must enter a number between 5 and 500 inclusive."])
									end
								end,
							tooltip = L["This determines how many items are shown per page in results area of the \"Search\" tab of the AuctionDB page in the main TSM window. You may enter a number between 5 and 500 inclusive. If the page lags, you may want to decrease this number."],
						},
						{
							type = "Label",
							relativeWidth = 0.1
						},
						{
							type = "Dropdown",
							label = L["Sort items by"],
							list = {["name"]=NAME, ["rarity"]=RARITY, ["ilvl"]=STAT_AVERAGE_ITEM_LEVEL, ["minlvl"]=L["Item MinLevel"], ["marketvalue"]=L["Market Value"], ["minbuyout"]=L["Minimum Buyout"]},
							value = TSM.db.profile.resultsSortMethod,
							relativeWidth = 0.34,
							callback = function(_,_,value) TSM.db.profile.resultsSortMethod = value end,
							tooltip = L["Select how you would like the search results to be sorted. After changing this option, you may need to refresh your search results by hitting the \"Refresh\" button."],
						},
						{
							type = "Label",
							relativeWidth = 0.02
						},
						{
							type = "CheckBox",
							label = L["Ascending"],
							cbType = "radio",
							relativeWidth = 0.16,
							value = TSM.db.profile.resultsSortOrder == "ascending",
							disabled = TSM.db.profile.resultsSortOrder == nil,
							callback = function(self,_,value)
									if value then
										TSM.db.profile.resultsSortOrder = "ascending"
										local i = getIndex(self.parent.children, self)
										self.parent.children[i+1]:SetValue(false)
									end
								end,
							tooltip = L["Sort search results in ascending order."],
						},
						{
							type = "CheckBox",
							label = L["Descending"],
							cbType = "radio",
							relativeWidth = 0.16,
							value = TSM.db.profile.resultsSortOrder == "descending",
							disabled = TSM.db.profile.resultsSortOrder == nil,
							callback = function(self,_,value)
									if value then
										TSM.db.profile.resultsSortOrder = "descending"
										local i = getIndex(self.parent.children, self)
										self.parent.children[i-1]:SetValue(false)
									end
								end,
							tooltip = L["Sort search results in descending order."],
						},
						{
							type = "CheckBox",
							label = L["Hide poor quality items"],
							relativeWidth = 0.5,
							value = TSM.db.profile.hidePoorQualityItems,
							callback = function(self,_,value) TSM.db.profile.hidePoorQualityItems = value end,
							tooltip = L["If checked, poor quality items won't be shown in the search results."],
						},
					},
				},
			},
		},
	}
	
	if AucAdvanced then
		tinsert(page[1].children[1].children, {
				type = "CheckBox",
				label = L["Block Auctioneer while Scanning."],
				value = TSM.db.profile.blockAuc,
				relativeWidth = 0.5,
				callback = function(_,_,value) TSM.db.profile.blockAuc = value end,
				tooltip = L["If checked, Auctioneer will be prevented from scanning / processing AuctionDB's scans."],
			})
	end
	
	TSMAPI:BuildPage(container, page)
end