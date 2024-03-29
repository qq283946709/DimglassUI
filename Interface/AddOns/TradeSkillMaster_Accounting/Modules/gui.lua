-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Accounting - AddOn by Sapu94							 	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_accounting.aspx  --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- create a local reference to the TradeSkillMaster_Crafting table and register a new module
local TSM = select(2, ...)
local GUI = TSM:NewModule("GUI", "AceEvent-3.0", "AceHook-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Accounting") -- loads the localization table

local ROW_HEIGHT = 16
local saleST, buyST, itemSummaryST, resaleSummaryST, itemDetailST

function GUI:Load(parent)
	local simpleGroup = AceGUI:Create("SimpleGroup")
	simpleGroup:SetLayout("Fill")
	parent:AddChild(simpleGroup)

	local tabGroup =  AceGUI:Create("TSMTabGroup")
	tabGroup:SetLayout("Fill")
	tabGroup:SetTabs({{text=L["Sales"], value=1}, {text=L["Purchases"], value=2}, {text=L["Items"], value=3}, {text=L["Resale"], value=4}, {text=L["Summary"], value=5}, {text=L["Options"], value=6}})
	tabGroup:SetCallback("OnGroupSelected", function(self, _, value)
			tabGroup:ReleaseChildren()
			GUI:HideScrollingTables()
			if value == 1 then
				GUI:DrawSales(self)
			elseif value == 2 then
				GUI:DrawPurchases(self)
			elseif value == 3 then
				GUI:DrawItemSummary(self)
			elseif value == 4 then
				GUI:DrawResaleSummary(self)
			elseif value == 5 then
				GUI:DrawGoldSummary(self)
			elseif value == 6 then
				GUI:DrawOptions(self)
			end
		end)
	simpleGroup:AddChild(tabGroup)
	tabGroup:SelectTab(1)
	
	GUI:HookScript(simpleGroup.frame, "OnHide", function() GUI:UnhookAll() GUI:HideScrollingTables() end)
end

function GUI:DrawSales(container)
	local colInfo = GUI:GetColInfo("sales", container.frame:GetWidth())

	if not saleST then
		saleST = TSMAPI:CreateScrollingTable(colInfo)
	end
	saleST.frame:SetParent(container.frame)
	saleST.frame:SetPoint("BOTTOMLEFT", container.frame, 10, 10)
	saleST.frame:SetPoint("TOPRIGHT", container.frame, -10, -105)
	saleST.frame:SetScript("OnSizeChanged", function(_,width, height)
			saleST:SetDisplayCols(GUI:GetColInfo("sales", width))
			saleST:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
		end)
	saleST:Show()
	saleST:SetData(TSM.Data:GetSalesData())
	
	local font, size = GameFontNormal:GetFont()
	for i, row in ipairs(saleST.rows) do
		for j, col in ipairs(row.cols) do
			col.text:SetFont(font, size-1)
		end
	end
	
	saleST:RegisterEvents({
		["OnClick"] = function(_, _, data, _, _, rowNum, _, self)
			if not rowNum then return end
			self:Hide()
			GUI:DrawItemLookup(container, data[rowNum].itemString, 1)
		end,
		["OnEnter"] = function(_, self, _, _, _, rowNum)
			if not rowNum then return end
			
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText(L["Click for a detailed report on this item."], 1, .82, 0, 1)
			GameTooltip:Show()
		end,
		["OnLeave"] = function()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end})
		
	GUI:CreateTopWidgets(container, saleST, function(...) return TSM.Data:GetSalesData(...) end)
end

function GUI:DrawPurchases(container)
	local colInfo = GUI:GetColInfo("buys", container.frame:GetWidth())

	if not buyST then
		buyST = TSMAPI:CreateScrollingTable(colInfo)
	end
	buyST.frame:SetParent(container.frame)
	buyST.frame:SetPoint("BOTTOMLEFT", container.frame, 10, 10)
	buyST.frame:SetPoint("TOPRIGHT", container.frame, -10, -105)
	buyST.frame:SetScript("OnSizeChanged", function(_,width, height)
			buyST:SetDisplayCols(GUI:GetColInfo("buys", width))
			buyST:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
		end)
	buyST:Show()
	buyST:SetData(TSM.Data:GetBuyData())
	
	local font, size = GameFontNormal:GetFont()
	for i, row in ipairs(buyST.rows) do
		for j, col in ipairs(row.cols) do
			col.text:SetFont(font, size-1)
		end
	end
	
	buyST:RegisterEvents({
		["OnClick"] = function(_, _, data, _, _, rowNum, _, self)
			if not rowNum then return end
			self:Hide()
			GUI:DrawItemLookup(container, data[rowNum].itemString, 2)
		end,
		["OnEnter"] = function(_, self, _, _, _, rowNum)
			if not rowNum then return end
			
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText(L["Click for a detailed report on this item."], 1, .82, 0, 1)
			GameTooltip:Show()
		end,
		["OnLeave"] = function()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end})
		
	GUI:CreateTopWidgets(container, buyST, function(...) return TSM.Data:GetBuyData(...) end)
end

function GUI:DrawItemSummary(container)
	local colInfo = GUI:GetColInfo("itemSummary", container.frame:GetWidth())

	if not itemSummaryST then
		itemSummaryST = TSMAPI:CreateScrollingTable(colInfo)
	end
	itemSummaryST.frame:SetParent(container.frame)
	itemSummaryST.frame:SetPoint("BOTTOMLEFT", container.frame, 10, 10)
	itemSummaryST.frame:SetPoint("TOPRIGHT", container.frame, -10, -105)
	itemSummaryST.frame:SetScript("OnSizeChanged", function(_,width, height)
			itemSummaryST:SetDisplayCols(GUI:GetColInfo("itemSummary", width))
			itemSummaryST:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
		end)
	itemSummaryST:Show()
	itemSummaryST:SetData(TSM.Data:GetItemSummaryData())
	itemSummaryST.frame:GetScript("OnSizeChanged")(itemSummaryST.frame, itemSummaryST.frame:GetWidth(), itemSummaryST.frame:GetHeight())
	
	local font, size = GameFontNormal:GetFont()
	for i, row in ipairs(itemSummaryST.rows) do
		for j, col in ipairs(row.cols) do
			col.text:SetFont(font, size-1)
		end
	end
	
	itemSummaryST:RegisterEvents({
		["OnClick"] = function(_, _, data, _, _, rowNum, _, self)
			if not rowNum then return end
			self:Hide()
			GUI:DrawItemLookup(container, data[rowNum].itemString, 3)
		end,
		["OnEnter"] = function(_, self, _, _, _, rowNum)
			if not rowNum then return end
			
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText(L["Click for a detailed report on this item."], 1, .82, 0, 1)
			GameTooltip:Show()
		end,
		["OnLeave"] = function()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end})
		
	GUI:CreateTopWidgets(container, itemSummaryST, function(...) return TSM.Data:GetItemSummaryData(...) end)
end

function GUI:DrawResaleSummary(container)
	local colInfo = GUI:GetColInfo("resaleSummary", container.frame:GetWidth())

	if not resaleSummaryST then
		resaleSummaryST = TSMAPI:CreateScrollingTable(colInfo)
	end
	resaleSummaryST.frame:SetParent(container.frame)
	resaleSummaryST.frame:SetPoint("BOTTOMLEFT", container.frame, 10, 10)
	resaleSummaryST.frame:SetPoint("TOPRIGHT", container.frame, -10, -105)
	resaleSummaryST.frame:SetScript("OnSizeChanged", function(_,width, height)
			resaleSummaryST:SetDisplayCols(GUI:GetColInfo("resaleSummary", width))
			resaleSummaryST:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
		end)
	resaleSummaryST:Show()
	resaleSummaryST:SetData(TSM.Data:GetResaleSummaryData())
	resaleSummaryST.frame:GetScript("OnSizeChanged")(resaleSummaryST.frame, resaleSummaryST.frame:GetWidth(), resaleSummaryST.frame:GetHeight())
	
	local font, size = GameFontNormal:GetFont()
	for i, row in ipairs(resaleSummaryST.rows) do
		for j, col in ipairs(row.cols) do
			col.text:SetFont(font, size-1)
		end
	end
	
	resaleSummaryST:RegisterEvents({
		["OnClick"] = function(_, _, data, _, _, rowNum, _, self)
			if not rowNum then return end
			self:Hide()
			GUI:DrawItemLookup(container, data[rowNum].itemString, 4)
		end,
		["OnEnter"] = function(_, self, _, _, _, rowNum)
			if not rowNum then return end
			
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText(L["Click for a detailed report on this item."], 1, .82, 0, 1)
			GameTooltip:Show()
		end,
		["OnLeave"] = function()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end})
		
	GUI:CreateTopWidgets(container, resaleSummaryST, function(...) return TSM.Data:GetResaleSummaryData(...) end)
end

function GUI:DrawItemLookup(container, itemString, returnTab)
	container:ReleaseChildren()
	local itemID = TSM:ItemStringToID(itemString)
	local itemData = TSM.Data:GetItemData(itemString)
	
	local buyers, sellers = {}, {}
	for name, quantity in pairs(itemData.buyers) do
		tinsert(buyers, {name=name, quantity=quantity})
	end
	for name, quantity in pairs(itemData.sellers) do
		tinsert(sellers, {name=name, quantity=quantity})
	end
	sort(buyers, function(a, b) return a.quantity > b.quantity end)
	sort(sellers, function(a, b) return a.quantity > b.quantity end)
	
	local buyersText, sellersText = "", ""
	for i=1, min(#buyers, 5) do
		buyersText = buyersText..buyers[i].name.."|cff99ffff("..buyers[i].quantity..")|r, "
	end
	for i=1, min(#sellers, 5) do
		sellersText = sellersText..sellers[i].name.."|cff99ffff("..sellers[i].quantity..")|r, "
	end

	local page = {
		{
			type = "SimpleGroup",
			layout = "Flow",
			children = {
				{
					type = "Label",
					relativeWidth = 0.1,
				},
				{
					type = "InteractiveLabel",
					text = itemData.link,
					fontObject = GameFontNormalLarge,
					relativeWidth = 0.5,
					callback = function() SetItemRef("item:".. itemID, itemID) end,
					tooltip = itemID,
				},
				{
					type = "Label",
					relativeWidth = 0.1,
				},
				{
					type = "Button",
					text = L["Back to Previous Page"],
					relativeWidth = 0.29,
					callback = function() container:SelectTab(returnTab) end,
				},
				{
					type = "HeadingLine",
				},
				{
					type = "InlineGroup",
					title = L["Sale Data"],
					layout = "Flow",
					children = {},
				},
				{
					type = "InlineGroup",
					title = L["Purchase Data"],
					layout = "Flow",
					children = {},
				},
				{
					type = "InlineGroup",
					title = L["Activity Log"],
					layout = "Flow",
					fullHeight = true,
					children = {},
				},
			},
		},
	}
	
	local sellWidgets, buyWidgets
	if itemData.avgTotalSell then
		sellWidgets = {
			{
				type = "MultiLabel",
				labelInfo = {{text="|cffcc8000"..L["Average Prices:"], relativeWidth = 0.19},
					{text="|cff99ffff"..L["Total:"].." |r"..(TSM:FormatTextMoney(itemData.avgTotalSell) or "---"), relativeWidth=0.22},
					{text="|cff99ffff"..L["Last 30 Days:"].." |r"..(TSM:FormatTextMoney(itemData.avgMonthSell) or "---"), relativeWidth=0.29},
					{text="|cff99ffff"..L["Last 7 Days:"].." |r"..(TSM:FormatTextMoney(itemData.avgWeekSell) or "---"), relativeWidth=0.29}},
				relativeWidth = 1,
			},
			{
				type = "MultiLabel",
				labelInfo = {{text="|cffcc8000"..L["Quantity Sold:"], relativeWidth = 0.19},
					{text="|cff99ffff"..L["Total:"].." |r"..itemData.totalSellNum, relativeWidth=0.22},
					{text="|cff99ffff"..L["Last 30 Days:"].." |r"..itemData.monthSellNum, relativeWidth=0.29},
					{text="|cff99ffff"..L["Last 7 Days:"].." |r"..itemData.weekSellNum, relativeWidth=0.29}},
				relativeWidth = 1,
			},
			{
				type = "MultiLabel",
				labelInfo = {{text="|cffcc8000"..L["Gold Earned:"], relativeWidth = 0.19},
					{text="|cff99ffff"..L["Total:"].." |r"..(TSM:FormatTextMoney(itemData.avgTotalSell*itemData.totalSellNum) or "---"), relativeWidth=0.22},
					{text="|cff99ffff"..L["Last 30 Days:"].." |r"..(TSM:FormatTextMoney(itemData.avgMonthSell*itemData.monthSellNum) or "---"), relativeWidth=0.29},
					{text="|cff99ffff"..L["Last 7 Days:"].." |r"..(TSM:FormatTextMoney(itemData.avgWeekSell*itemData.weekSellNum) or "---"), relativeWidth=0.29}},
				relativeWidth = 1,
			},
			{
				type = "Label",
				relativeWidth = 1,
				text = "|cffcc8000"..L["Top Buyers:"].." |r"..buyersText,
			},
		}
	else
		sellWidgets = {
			{
				type = "Label",
				relativeWidth = 1,
				text = L["There is no sale data for this item."],
			},
		}
	end
	
	if itemData.avgTotalBuy then
		buyWidgets = {
			{
				type = "MultiLabel",
				labelInfo = {{text="|cffcc8000"..L["Average Prices:"], relativeWidth = 0.19},
					{text="|cff99ffff"..L["Total:"].." |r"..(TSM:FormatTextMoney(itemData.avgTotalBuy) or "---"), relativeWidth=0.22},
					{text="|cff99ffff"..L["Last 30 Days:"].." |r"..(TSM:FormatTextMoney(itemData.avgMonthBuy) or "---"), relativeWidth=0.29},
					{text="|cff99ffff"..L["Last 7 Days:"].." |r"..(TSM:FormatTextMoney(itemData.avgWeekBuy) or "---"), relativeWidth=0.29}},
				relativeWidth = 1,
			},
			{
				type = "MultiLabel",
				labelInfo = {{text="|cffcc8000"..L["Quantity Bought:"], relativeWidth = 0.19},
					{text="|cff99ffff"..L["Total:"].." |r"..itemData.totalBuyNum, relativeWidth=0.22},
					{text="|cff99ffff"..L["Last 30 Days:"].." |r"..itemData.monthBuyNum, relativeWidth=0.29},
					{text="|cff99ffff"..L["Last 7 Days:"].." |r"..itemData.weekBuyNum, relativeWidth=0.29}},
				relativeWidth = 1,
			},
			{
				type = "MultiLabel",
				labelInfo = {{text="|cffcc8000"..L["Total Spent:"], relativeWidth = 0.19},
					{text="|cff99ffff"..L["Total:"].." |r"..(TSM:FormatTextMoney(itemData.avgTotalBuy*itemData.totalBuyNum) or "---"), relativeWidth=0.22},
					{text="|cff99ffff"..L["Last 30 Days:"].." |r"..(TSM:FormatTextMoney(itemData.avgMonthBuy*itemData.monthBuyNum) or "---"), relativeWidth=0.29},
					{text="|cff99ffff"..L["Last 7 Days:"].." |r"..(TSM:FormatTextMoney(itemData.avgWeekBuy*itemData.weekBuyNum) or "---"), relativeWidth=0.29}},
				relativeWidth = 1,
			},
			{
				type = "Label",
				relativeWidth = 1,
				text = "|cffcc8000"..L["Top Sellers:"].." |r"..sellersText,
			},
		}
	else
		buyWidgets = {
			{
				type = "Label",
				relativeWidth = 1,
				text = L["There is no purchase data for this item."],
			},
		}
	end
	
	local index
	for i=1, #page[1].children do
		if page[1].children[i].type == "InlineGroup" then
			index = i
			break
		end
	end
	
	for i=1, #sellWidgets do
		tinsert(page[1].children[index].children, sellWidgets[i])
	end
	for i=1, #buyWidgets do
		tinsert(page[1].children[index+1].children, buyWidgets[i])
	end
	
	TSMAPI:BuildPage(container, page)
	
	local stParent = container.children[1].children[#container.children[1].children].content
	local colInfo = GUI:GetColInfo("itemDetail", container.frame:GetWidth())
	if not itemDetailST then
		itemDetailST = TSMAPI:CreateScrollingTable(colInfo)
	end
	itemDetailST.frame:SetParent(stParent)
	itemDetailST.frame:SetPoint("TOPLEFT", 0, -10)
	itemDetailST.frame:SetPoint("BOTTOMRIGHT", 0, 0)
	itemDetailST.frame:SetScript("OnSizeChanged", function(_,width, height)
			itemDetailST:SetDisplayCols(GUI:GetColInfo("itemDetail", width))
			itemDetailST:SetDisplayRows(floor(height/ROW_HEIGHT), ROW_HEIGHT)
		end)
	itemDetailST:Show()
	itemDetailST:SetData(itemData.stData)
	
	local font, size = GameFontNormal:GetFont()
	for i, row in ipairs(itemDetailST.rows) do
		for j, col in ipairs(row.cols) do
			col.text:SetFont(font, size-1)
		end
	end
end

function GUI:DrawGoldSummary(container)
	local data = TSM.Data:GetGoldData()

	local page = {
		{
			type = "ScrollFrame",
			layout = "Flow",
			children = {
				{
					type = "InlineGroup",
					layout = "Flow",
					title = L["Sales"],
					children = {
						{
							type = "MultiLabel",
							labelInfo = {{text="|cffcc8000"..L["Gold Earned:"], relativeWidth = 0.19},
								{text="|cff99ffff"..L["Total:"].." |r"..(TSM:FormatTextMoney(data.totalSale) or "---"), relativeWidth=0.22},
								{text="|cff99ffff"..L["Last 30 Days:"].." |r"..(TSM:FormatTextMoney(data.monthSale) or "---"), relativeWidth=0.29},
								{text="|cff99ffff"..L["Last 7 Days:"].." |r"..(TSM:FormatTextMoney(data.weekSale) or "---"), relativeWidth=0.29}},
							relativeWidth = 1,
						},
						{
							type = "MultiLabel",
							labelInfo = {{text="|cffcc8000"..L["Earned Per Day:"], relativeWidth = 0.19},
								{text="|cff99ffff"..L["Total:"].." |r"..(TSM:FormatTextMoney(floor(TSMAPI:SafeDivide(data.totalSale, data.totalTime)+0.5)) or "---"), relativeWidth=0.22},
								{text="|cff99ffff"..L["Last 30 Days:"].." |r"..(TSM:FormatTextMoney(floor(TSMAPI:SafeDivide(data.monthSale, data.monthTime)+0.5)) or "---"), relativeWidth=0.29},
								{text="|cff99ffff"..L["Last 7 Days:"].." |r"..(TSM:FormatTextMoney(floor(TSMAPI:SafeDivide(data.weekSale, data.weekTime)+0.5)) or "---"), relativeWidth=0.29}},
							relativeWidth = 1,
						},
						{
							type = "Label",
							relativeWidth = 0.3,
							text = "|cffcc8000"..L["Top Item by Gold:"].."|r",
						},
						{
							type = "InteractiveLabel",
							text = (data.topSellGold.link or data.topSellGold.itemID or "none").." ("..(TSM:FormatTextMoney(data.topSellGold.price) or "---")..")",
							fontObject = GameFontNormal,
							relativeWidth = 0.69,
							callback = function() SetItemRef("item:".. data.topSellGold.itemID, data.topSellGold.itemID) end,
							tooltip = data.topSellGold.itemID,
						},
						{
							type = "Label",
							relativeWidth = 0.3,
							text = "|cffcc8000"..L["Top Item by Quantity:"].."|r",
						},
						{
							type = "InteractiveLabel",
							text = (data.topSellQuantity.link or "none").." ("..(data.topSellQuantity.num or "---")..")",
							fontObject = GameFontNormal,
							relativeWidth = 0.69,
							callback = function() SetItemRef("item:".. data.topSellQuantity.itemID, data.topSellQuantity.itemID) end,
							tooltip = data.topSellQuantity.itemID,
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "Flow",
					title = L["Purchases"],
					children = {
						{
							type = "MultiLabel",
							labelInfo = {{text="|cffcc8000"..L["Gold Spent:"], relativeWidth = 0.19},
								{text="|cff99ffff"..L["Total:"].." |r"..(TSM:FormatTextMoney(data.totalBuy) or "---"), relativeWidth=0.22},
								{text="|cff99ffff"..L["Last 30 Days:"].." |r"..(TSM:FormatTextMoney(data.monthBuy) or "---"), relativeWidth=0.29},
								{text="|cff99ffff"..L["Last 7 Days:"].." |r"..(TSM:FormatTextMoney(data.weekBuy) or "---"), relativeWidth=0.29}},
							relativeWidth = 1,
						},
						{
							type = "MultiLabel",
							labelInfo = {{text="|cffcc8000"..L["Spent Per Day:"], relativeWidth = 0.19},
								{text="|cff99ffff"..L["Total:"].." |r"..(TSM:FormatTextMoney(floor(TSMAPI:SafeDivide(data.totalBuy, data.totalTime)+0.5)) or "---"), relativeWidth=0.22},
								{text="|cff99ffff"..L["Last 30 Days:"].." |r"..(TSM:FormatTextMoney(floor(TSMAPI:SafeDivide(data.monthBuy, data.monthTime)+0.5)) or "---"), relativeWidth=0.29},
								{text="|cff99ffff"..L["Last 7 Days:"].." |r"..(TSM:FormatTextMoney(floor(TSMAPI:SafeDivide(data.weekBuy, data.weekTime)+0.5)) or "---"), relativeWidth=0.29}},
							relativeWidth = 1,
						},
						{
							type = "Label",
							relativeWidth = 0.3,
							text = "|cffcc8000"..L["Top Item by Gold:"].."|r",
						},
						{
							type = "InteractiveLabel",
							text = (data.topBuyGold.link or "none").." ("..(TSM:FormatTextMoney(data.topBuyGold.price) or "---")..")",
							fontObject = GameFontNormal,
							relativeWidth = 0.69,
							callback = function() SetItemRef("item:".. data.topBuyGold.itemID, data.topBuyGold.itemID) end,
							tooltip = data.topBuyGold.itemID,
						},
						{
							type = "Label",
							relativeWidth = 0.3,
							text = "|cffcc8000"..L["Top Item by Quantity:"].."|r",
						},
						{
							type = "InteractiveLabel",
							text = (data.topBuyQuantity.link or "none").." ("..(data.topBuyQuantity.num or "---")..")",
							fontObject = GameFontNormal,
							relativeWidth = 0.69,
							callback = function() SetItemRef("item:".. data.topBuyQuantity.itemID, data.topBuyQuantity.itemID) end,
							tooltip = data.topBuyQuantity.itemID,
						},
					},
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

function GUI:DrawOptions(container)
	local mvSources = {}
	if select(4, GetAddOnInfo("TradeSkillMaster_AuctionDB")) then
		mvSources["adbmarket"] = L["AuctionDB - Market Value"]
		mvSources["adbminbuyout"] = L["AuctionDB - Min Buyout"]
	end
	if AucAdvanced and select(4, GetAddOnInfo("Auc-Advanced")) == 1 then
		mvSources["aucappraiser"] = L["Auctioneer - Appraiser"]
		mvSources["aucminbuyout"] = L["Auctioneer - Min Buyout"]
		mvSources["aucmarket"] = L["Auctioneer - Market Value"]
	end
	if Atr_GetAuctionBuyout and select(4, GetAddOnInfo("Auctionator")) == 1 then
		mvSources["atrvalue"] = L["Auctionator - Auction Value"]
	end
	if TUJMarketInfo and select(4, GetAddOnInfo("TheUndermineJournal")) == 1 then
		mvSources["tujmarket"] = L["TheUndermineJournal - Market Price"]
		mvSources["tujmean"] = L["TheUndermineJournal - Mean"]
	end

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
							type = "Dropdown",
							label = L["Time Format"],
							relativeWidth = 0.5,
							list = {["ago"]=L["_ Hr _ Min ago"], ["usdate"]=L["MM/DD/YY HH:MM"], ["aidate"]=L["YY/MM/DD HH:MM"], ["eudate"]=L["DD/MM/YY HH:MM"]},
							value = TSM.db.factionrealm.timeFormat,
							callback = function(_,_,value) TSM.db.factionrealm.timeFormat = value end,
							tooltip = L["Select what format Accounting should use to display times in applicable screens."],
						},
						{
							type = "Dropdown",
							label = L["Market Value Source"],
							relativeWidth = 0.49,
							list = mvSources,
							value = TSM.db.factionrealm.mvSource,
							callback = function(_,_,value) TSM.db.factionrealm.mvSource = value end,
							tooltip = L["Select where you want Accounting to get market value info from to show in applicable screens."],
						},
						{
							type = "Dropdown",
							label = L["Items/Resale Price Format"],
							relativeWidth = 0.49,
							list = {["avg"]=L["Price Per Item"], ["total"]=L["Total Value"]},
							value = TSM.db.factionrealm.priceFormat,
							callback = function(_,_,value) TSM.db.factionrealm.priceFormat = value end,
							tooltip = L["Select how you would like prices to be shown in the \"Items\" and \"Resale\" tabs; either average price per item or total value."],
						},
					},
				},
				{
					type = "InlineGroup",
					title = L["Tooltip Options"],
					layout = "Flow",
					children = {
						{
							type = "CheckBox",
							label = L["Show sale info in item tooltips"],
							relativeWidth = 0.5,
							value = TSM.db.factionrealm.tooltip.sale,
							callback = function(_,_,value)
									if value and not TSM.db.factionrealm.tooltip.purchase then
										TSMAPI:RegisterTooltip("TradeSkillMaster_Accounting", function(...) return TSM:LoadTooltip(...) end)
									elseif not TSM.db.factionrealm.tooltip.purchase then
										TSMAPI:UnregisterTooltip("TradeSkillMaster_Accounting")
									end
									TSM.db.factionrealm.tooltip.sale = value
								end,
							tooltip = L["If checked, the number you have sold and the average sale price will show up in an item's tooltip."],
						},
						{
							type = "CheckBox",
							label = L["Show purchase info in item tooltips"],
							relativeWidth = 0.49,
							value = TSM.db.factionrealm.tooltip.purchase,
							callback = function(_,_,value)
									if value and not TSM.db.factionrealm.tooltip.sale then
										TSMAPI:RegisterTooltip("TradeSkillMaster_Accounting", function(...) return TSM:LoadTooltip(...) end)
									elseif not TSM.db.factionrealm.tooltip.sale then
										TSMAPI:UnregisterTooltip("TradeSkillMaster_Accounting")
									end
									TSM.db.factionrealm.tooltip.purchase = value
								end,
							tooltip = L["If checked, the number you have purchased and the average purchase price will show up in an item's tooltip."],
						},
					},
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end

function GUI:HideScrollingTables()
	if saleST then
		saleST:Hide()
	end
	if buyST then
		buyST:Hide()
	end
	if itemSummaryST then
		itemSummaryST:Hide()
	end
	if resaleSummaryST then
		resaleSummaryST:Hide()
	end
	if itemDetailST then
		itemDetailST:Hide()
	end
end


local function ColSortMethod(st, aRow, bRow, col)
	local a, b = st:GetCell(aRow, col), st:GetCell(bRow, col)
	local column = st.cols[col]
	local direction = column.sort or column.defaultsort or "dsc"
	local aValue, bValue = ((a.args or {})[1] or a.value), ((b.args or {})[1] or b.value)
	if direction == "asc" then
		return aValue < bValue
	else
		return aValue > bValue
	end
end

local colInfo = {
	sales = {
		{
			name = L["Item Name"],
			width = 0.37,
			defaultsort = "asc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Stack Size"],
			width = 0.08,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Auctions"],
			width = 0.08,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Price Per Item"],
			width = 0.13,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Total Sale Price"],
			width = 0.13,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{ 
			name = L["Last Sold"],
			width = 0.2,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
	},
	buys = {
		{
			name = L["Item Name"],
			width = 0.37,
			defaultsort = "asc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Stack Size"],
			width = 0.08,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Auctions"],
			width = 0.08,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Price Per Item"],
			width = 0.13,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Total Buy Price"],
			width = 0.13,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{ 
			name = L["Last Purchase"],
			width = 0.2,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
	},
	itemSummary = {
		{
			name = L["Item Name"],
			width = 0.38,
			defaultsort = "asc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Market Value"],
			width = 0.15,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Sold"],
			width = 0.06,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = function() return TSM.db.factionrealm.priceFormat == "avg" and L["Avg Sell Price"] or L["Total Sale Price"] end,
			width = 0.15,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Bought"],
			width = 0.07,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = function() return TSM.db.factionrealm.priceFormat == "avg" and L["Avg Buy Price"] or L["Total Buy Price"] end,
			width = 0.15,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
	},
	resaleSummary = {
		{
			name = L["Item Name"],
			width = 0.37,
			defaultsort = "asc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Sold"],
			width = 0.06,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = function() return TSM.db.factionrealm.priceFormat == "avg" and L["Avg Sell Price"] or L["Total Sale Price"] end,
			width = 0.14,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Bought"],
			width = 0.07,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = function() return TSM.db.factionrealm.priceFormat == "avg" and L["Avg Buy Price"] or L["Total Buy Price"] end,
			width = 0.14,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Avg Resale Profit"],
			width = 0.21,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
	},
	itemDetail = {
		{
			name = L["Activity Type"],
			width = 0.15,
			defaultsort = "asc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Buyer/Seller"],
			width = 0.15,
			defaultsort = "asc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Quantity"],
			width = 0.1,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Price Per Item"],
			width = 0.15,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Total Price"],
			width = 0.15,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
		{
			name = L["Time"],
			width = 0.29,
			defaultsort = "dsc",
			comparesort = ColSortMethod,
		},
	},
}
	
function GUI:GetColInfo(cType, width)
	local colInfo = CopyTable(colInfo[cType])
	
	for i=1, #colInfo do
		if type(colInfo[i].name) == "function" then
			colInfo[i].name = colInfo[i].name()
		end
		colInfo[i].width = floor(colInfo[i].width*width)
	end
	
	return colInfo
end

function GUI:CreateTopWidgets(container, st, dataFunc)
	local ddList = {["aucgroups"]=L["Items in an Auctioning Group"], ["notaucgroups"]=L["Items NOT in an Auctioning Group"], ["common"]=L["Common Quality Items"], ["uncommon"]=L["Uncommon Quality Items"], ["rare"]=L["Rare Quality Items"], ["epic"]=L["Epic Quality Items"], ["none"]=L["<none>"]}
	local filter, ddSelection
	
	local function UpdateFilter()
		local dropdownFilterFunction = function() return true end
		if ddSelection == "aucgroups" then
			local auctioningItems = {}
			for _, items in pairs(TSMAPI:GetData("auctioningGroups")) do
				for itemID in pairs(items) do
					local name = GetItemInfo(itemID)
					if name then
						auctioningItems[name] = true
					end
				end
			end
			dropdownFilterFunction = function(name) return auctioningItems[name] end
		elseif ddSelection == "notaucgroups" then
			local auctioningItems = {}
			for _, items in pairs(TSMAPI:GetData("auctioningGroups")) do
				for itemID in pairs(items) do
					local name = GetItemInfo(itemID)
					if name then
						auctioningItems[name] = true
					end
				end
			end
			dropdownFilterFunction = function(name) return not auctioningItems[name] end
		end
		
		local rarityFilterFunction = function() return true end
		if ddSelection == "common" then
			rarityFilterFunction = function(link) return (select(3, GetItemInfo(link)) or 0) == 1 end
		elseif ddSelection == "uncommon" then
			rarityFilterFunction = function(link) return (select(3, GetItemInfo(link)) or 0) == 2 end
		elseif ddSelection == "rare" then
			rarityFilterFunction = function(link) return (select(3, GetItemInfo(link)) or 0) == 3 end
		elseif ddSelection == "epic" then
			rarityFilterFunction = function(link) return (select(3, GetItemInfo(link)) or 0) == 4 end
		end
		
		local searchFilterFunction = function() return true end
		if filter and filter ~= "" then
			searchFilterFunction = function(name) return strfind(strlower(name), filter) end
		end
		
		st:SetData(dataFunc(function(name, link) return dropdownFilterFunction(name) and searchFilterFunction(name) and rarityFilterFunction(link) end))
	end

	local page = {
		{
			type = "SimpleGroup",
			layout = "Flow",
			children = {
				{
					type = "EditBox",
					label = L["Search"],
					relativeWidth = 0.7,
					onTextChanged = true,
					callback = function(_,_,value)
							filter = strlower(value:trim())
							UpdateFilter()
						end,
				},
				{
					type = "Dropdown",
					label = L["Special Filters"],
					relativeWidth = 0.29,
					list = ddList,
					value = "none",
					callback = function(_,_,value)
							ddSelection = value
							UpdateFilter()
						end,
				},
			},
		},
	}
	
	TSMAPI:BuildPage(container, page)
end