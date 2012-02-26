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
local Dealfinding = TSM:NewModule("Dealfinding", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Shopping") -- loads the localization table

local ROW_HEIGHT = 16
local MAX_ROWS = 13

local function debug(...)
	TSM:Debug(...)
end

function Dealfinding:OnEnable()
	TSMAPI:RegisterSidebarFunction("TradeSkillMaster_Shopping", "shoppingDealfinding", "Interface\\Icons\\Spell_Shaman_SpectralTransformation", 
		L["Shopping - Dealfinding"], function(...) Dealfinding:LoadSidebar(...) end, Dealfinding.HideSidebar)
	Dealfinding.shoppingList = {}
	Dealfinding.totalSpent = 0
end

local function BuildScanPage(parent)
	local maxWidth = parent:GetWidth() - 16
	
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetPoint("TOPLEFT", 0, -130)
	frame:SetPoint("BOTTOMRIGHT")
	frame:Raise()
	frame:Hide()
	frame.EnableButtons = function(self)
		self.buyButton:Enable()
		self.skipButton:Enable()
	end
	frame.DisableButtons = function(self)
		self.buyButton:Disable()
		self.skipButton:Disable()
	end
	
	local label = TSM.GUI:CreateLabel(frame, "*", GameFontHighlight, 0, nil, maxWidth+4, {"TOP", 0, 20}, "CENTER")
	frame.buyLabel = label
	
	local btn = TSM.GUI:CreateButton(L["BUY"], frame, "TSMShoppingDealfindingBuyButton", "UIPanelButtonTemplate", 8, nil, 40, {"TOPLEFT", 250, -20}, {"TOPRIGHT", -10, -20}, L["Buy the next cheapest auction."])
	btn:SetScript("OnClick", Dealfinding.BuyItem)
	frame.buyButton = btn
	
	local btn = TSM.GUI:CreateButton(L["SKIP"], frame, "TSMShoppingDealfindingSkipButton", "UIPanelButtonTemplate", -1, nil, 25, {"TOPLEFT", 250, -65}, {"TOPRIGHT", -10, -65}, L["Skip this auction."])
	btn:SetScript("OnClick", Dealfinding.SkipAuction)
	frame.skipButton = btn
	
	local label = TSM.GUI:CreateLabel(frame, "*", GameFontHighlight, 2, nil, maxWidth+4, {"TOPLEFT", 10, -20}, "LEFT")
	frame.currentLabel = label
	
	TSM.GUI:AddHorizontalBar(frame, -100)
	
	local label = TSM.GUI:CreateLabel(frame, "", GameFontHighlight, 0, nil, maxWidth+4, {"TOP", 0, -120}, "LEFT")
	frame.infoLabel = label
	
	local btn = TSM.GUI:CreateButton(L["Skip Current Item"], frame, nil, "UIPanelButtonTemplate", -1, nil, 25, {"BOTTOMLEFT", 8, 30}, {"BOTTOMRIGHT", -8, 30}, L["Skips the item currently being shopped for."])
	btn:SetScript("OnClick", Dealfinding.SkipItem)
	frame.skipButton = btn
	
	parent.buyFrame = frame
	
	local label = TSM.GUI:CreateLabel(parent, "*", GameFontHighlight, 0, nil, maxWidth+4, {"CENTER"}, "CENTER")
	label:Hide()
	parent.noAuctionsLabel = label
end

function Dealfinding:LoadSidebar(parentFrame)
	if not Dealfinding.frame then
		local maxWidth = parentFrame:GetWidth() - 16
	
		local container = CreateFrame("Frame", nil, parentFrame)
		container:SetAllPoints(parentFrame)
		container:Raise()
		
		container.title = TSM.GUI:CreateLabel(container, L["Shopping - Dealfinding"], GameFontHighlight, 2, "OUTLINE", maxWidth, {"TOP", 0, -10})
		TSM.GUI:AddHorizontalBar(container, -28)
		
		local btn = TSM.GUI:CreateButton(L["Config"], container, nil, "UIPanelButtonTemplate", -1, nil, 25, {"TOPLEFT", 280, -6},
			{"TOPRIGHT", -5, -6}, L["Opens the config window for TradeSkillMaster_Shopping."])
		btn:SetScript("OnClick", function()
				TSMAPI:OpenFrame()
				TSMAPI:SelectIcon("TradeSkillMaster_Shopping", L["Shopping Options"])
			end)
		container.configButton = btn
		
		local btn = TSM.GUI:CreateButton(L["Stop Scanning"], container, nil, "UIPanelButtonTemplate", 2, 150, 40,
			{"CENTER"}, L["Stops the scan."])
		btn:SetScript("OnClick", function(self)
				self:Hide()
				TSM.Scan:StopScanning("dealfinding")
				Dealfinding.frame.noAuctionsLabel:Show()
				Dealfinding.frame.noAuctionsLabel:SetText(L["Scan Canceled"])
			end)
		container.stopScanButton = btn
		
		BuildScanPage(container)
		Dealfinding.frame = container
	end
	
	Dealfinding.frame.noAuctionsLabel:Hide()
	Dealfinding.frame.buyFrame:Hide()
	Dealfinding.frame:Show()
	Dealfinding:RunDealfindingScan()
end

function Dealfinding:HideSidebar()
	Dealfinding.selectedItem = nil
	Dealfinding.frame:Hide()
end

function Dealfinding:RunDealfindingScan()
	local queue = {}
	for itemID, data in pairs(TSM.db.profile.dealfinding) do
		data.name = GetItemInfo(itemID) or data.name or itemID
		if data.name then
			tinsert(queue, {itemID=itemID, name=data.name})
		end
	end
	
	if #queue > 0 then
		Dealfinding.frame.stopScanButton:Show()
		TSM.Scan:StartScan(queue, "Dealfinding")
	else
		Dealfinding.frame.stopScanButton:Hide()
		Dealfinding.frame.noAuctionsLabel:Show()
		Dealfinding.frame.noAuctionsLabel:SetText(L["Nothing to scan."])
	end
end

function Dealfinding:Process(scanData)
	local prices = {}
	local evenStacks = {}
	for itemID, data in pairs(TSM.db.profile.dealfinding) do
		prices[itemID] = data.maxPrice
		evenStacks[itemID] = data.evenStacks
		
		local cheapest = math.huge
		if scanData[itemID] then
			for _, record in pairs(scanData[itemID].records) do
				if record.buyout < cheapest then
					cheapest = record.buyout
				end
			end
		end
		
		debug(itemID, evenStacks[itemID], prices[itemID], cheapest)
	end
	
	local auctions, totals = {}, {}
	for itemID, data in pairs(scanData) do
		for _, record in pairs(data.records) do
			if prices[itemID] and record.buyout <= prices[itemID] then
				if not evenStacks[itemID] then
					totals[itemID] = (totals[itemID] or 0) + record.quantity
					tinsert(auctions, {itemID=itemID, buyout=record.buyout, maxPrice=prices[itemID], quantity=record.quantity, page=record.page, stackSizeFlag=false, numItems=record.quantity})
				else
					if (record.quantity%5) < 1 then
						totals[itemID] = (totals[itemID] or 0) + record.quantity
						tinsert(auctions, {itemID=itemID, buyout=record.buyout, maxPrice=prices[itemID], quantity=record.quantity, page=record.page, stackSizeFlag=false, numItems=record.quantity})
					end
				end
			end
		end
	end
	
	foreach(totals, debug)
	foreach(auctions, debug)
	
	TSM:SortAuctions(auctions, {"itemID", "page", "buyout", "quanity"})
	auctions.totals = totals
	
	Dealfinding.frame.stopScanButton:Hide()
	Dealfinding.frame.buyFrame:DisableButtons()
	Dealfinding.auctions = auctions
	if Dealfinding.auctions[1] then
		local nextAuction = CopyTable(Dealfinding.auctions[1])
		local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
		TSM.Scan:FindAuction(Dealfinding.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page)
	else
		Dealfinding.frame.buyFrame:Hide()
		Dealfinding.frame.noAuctionsLabel:Show()
		Dealfinding.frame.noAuctionsLabel:SetText(L["No auctions are under your Dealfinding prices."])
	end
end

function Dealfinding:ProcessCheapest(index)
	local cheapest = tremove(Dealfinding.auctions, 1)
	
	if not index or not cheapest then
		if Dealfinding.auctions[1] then
			local nextAuction = CopyTable(Dealfinding.auctions[1])
			local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
			TSM.Scan:FindAuction(Dealfinding.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page)
		else
			Dealfinding.frame.buyFrame:Hide()
			Dealfinding.frame.noAuctionsLabel:Show()
			Dealfinding.frame.noAuctionsLabel:SetText(L["No more auctions"])
		end
		return
	end
	
	local cQuantity = Dealfinding.auctions.totals[cheapest.itemID]
	local link = GetAuctionItemLink("list", index) or GetItemInfo(cheapest.itemID) or ""
	local _, _, quantity, _, _, _, _, _, buyout, newBuyout = GetAuctionItemInfo("list", index)
	if select(4, GetBuildInfo()) >= 40300 then -- fix for added parameter in 4.3
		buyout = newBuyout
	end
	local cCost = floor(TSMAPI:SafeDivide(buyout, quantity)+0.5)
	if not buyout then
		return Dealfinding:ProcessCheapest()
	end
	local extraText = ""
	local percent = floor(((cheapest.maxPrice - cCost)/cheapest.maxPrice)*10000 + 0.5)/100
	if percent < 0 then
		extraText = format("|cffff0000"..L["%s%% above maximum price."].."|r", abs(percent))
	else
		extraText = format("|cff00ff00"..L["%s%% below maximum price."].."|r", percent)
	end
	
	Dealfinding.frame.buyFrame:Show()
	Dealfinding.frame.buyFrame:EnableButtons()
	Dealfinding.frame.buyFrame.buyLabel:SetText(format(L["%s below your Dealfinding price."], cQuantity.."x"..link))
	Dealfinding.frame.buyFrame.currentLabel:SetText(link.."x"..quantity.." @ "..TSM:FormatTextMoney(buyout).."\n\n(~"..TSM:FormatTextMoney(cCost).." "..L["per item"]..")\n\n"..extraText)
	Dealfinding.currentItem = {itemID=cheapest.itemID, index=index, buyout=buyout, quantity=quantity, numItems=cheapest.numItems}
end

function Dealfinding:BuyItem()
	debug("BUY11")
	debug(Dealfinding.currentItem.index)
	Dealfinding.totalSpent = Dealfinding.totalSpent + Dealfinding.currentItem.buyout
	Dealfinding.frame.buyFrame.infoLabel:SetText(L["Total Spent this Session:"].." "..TSM:FormatTextMoney(Dealfinding.totalSpent))
	Dealfinding.auctions.totals[Dealfinding.currentItem.itemID] = Dealfinding.auctions.totals[Dealfinding.currentItem.itemID] - Dealfinding.currentItem.quantity
	PlaceAuctionBid("list", Dealfinding.currentItem.index, Dealfinding.currentItem.buyout)
	
	if Dealfinding.auctions[1] then
		Dealfinding:WaitForEvent()
	else
		Dealfinding.frame.buyFrame:Hide()
		Dealfinding.frame.noAuctionsLabel:Show()
		Dealfinding.frame.noAuctionsLabel:SetText(L["No more auctions."])
	end
end

function Dealfinding:WaitForEvent()
	debug("START WAIT")
	Dealfinding.frame.buyFrame:DisableButtons()
	Dealfinding.waitingFor = {chatMsg = true, listUpdate = true}
	Dealfinding:RegisterEvent("CHAT_MSG_SYSTEM", function(_, msg)
			local targetMsg = gsub(ERR_AUCTION_BID_PLACED, "%%s", "")
			if msg:match(targetMsg) then
				Dealfinding:UnregisterEvent("CHAT_MSG_SYSTEM")
				Dealfinding.waitingFor.chatMsg = false
				if not Dealfinding.waitingFor.listUpdate then
					debug("chat msg enable")
					local nextAuction = CopyTable(Dealfinding.auctions[1])
					local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
					TSMAPI:CreateTimeDelay("shoppingFindNext", 0.1, function() TSM.Scan:FindAuction(Dealfinding.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page) end)
				else
					debug("waiting on list update")
				end
			end
		end)
		
	local nextAuction = Dealfinding.auctions[1]
	local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
	Dealfinding:RegisterEvent("AUCTION_ITEM_LIST_UPDATE", function()
			Dealfinding:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
			Dealfinding.waitingFor.listUpdate = false
			if not Dealfinding.waitingFor.chatMsg then
				debug("list update enable")
				local nextAuction = Dealfinding.auctions[1]
				local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
				TSMAPI:CreateTimeDelay("shoppingFindNext", 0.3, function() TSM.Scan:FindAuction(Dealfinding.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page) end)
			else
				debug("waiting on chat msg")
			end
		end)
end

function Dealfinding:SkipAuction()
	debug("SKIP auction")
	Dealfinding.auctions.totals[Dealfinding.currentItem.itemID] = Dealfinding.auctions.totals[Dealfinding.currentItem.itemID] - Dealfinding.currentItem.quantity
	Dealfinding.frame.buyFrame:DisableButtons()
	if Dealfinding.auctions[1] then
		local nextAuction = CopyTable(Dealfinding.auctions[1])
		local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
		TSM.Scan:FindAuction(Dealfinding.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page)
	else
		Dealfinding.frame.buyFrame:Hide()
		Dealfinding.frame.noAuctionsLabel:Show()
		Dealfinding.frame.noAuctionsLabel:SetText(L["No more auctions."])
	end
end

function Dealfinding:SkipItem()
	debug("SKIP item")
	local itemID = Dealfinding.currentItem.itemID
	Dealfinding.auctions.totals[itemID] = 0
	Dealfinding.frame.buyFrame:DisableButtons()
	
	local toRemove = {}
	for i=1, #Dealfinding.auctions do
		if Dealfinding.auctions[i].itemID == itemID then
			tinsert(toRemove, i)
		end
	end
	
	for i=#toRemove, 1, -1 do
		tremove(Dealfinding.auctions, i)
	end
	
	if Dealfinding.auctions[1] then
		local nextAuction = CopyTable(Dealfinding.auctions[1])
		local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
		TSM.Scan:FindAuction(Dealfinding.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page)
	else
		Dealfinding.frame.buyFrame:Hide()
		Dealfinding.frame.noAuctionsLabel:Show()
		Dealfinding.frame.noAuctionsLabel:SetText(L["No more auctions."])
	end
end