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
local Sniping = TSM:NewModule("Sniping", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Shopping") -- loads the localization table

local function debug(...)
	TSM:Debug(...)
end

function Sniping:OnEnable()
	if TSM.db.global.test ~= "Sapu" then return end
	TSMAPI:RegisterSidebarFunction("TradeSkillMaster_Shopping", "shoppingSniping", "Interface\\Icons\\Ability_Hunter_SniperShot", 
		"Shopping - Sniping", function(...) Sniping:LoadSidebar(...) end, Sniping.HideSidebar)
	Sniping.currentItem = {}
	Sniping.auctions = {}
end

function TSMSnipingIgnore(itemID, value)
	TSM.db.global.snipeIgnore[itemID] = value
end

function Sniping:LoadSidebar(parentFrame)
	if not Sniping.frame then
		local maxWidth = parentFrame:GetWidth() - 16
		
		local container = CreateFrame("Frame", nil, parentFrame)
		container:SetAllPoints(parentFrame)
		container:Raise()
		container.DisableAll = function()
			container.goButton:Disable()
			-- container.searchBox:SetDisabled(true)
			-- container.maxPrice:SetDisabled(true)
			-- container.maxQuantity:SetDisabled(true)
		end
		container.EnableAll = function()
			container.goButton:Enable()
			-- container.searchBox:SetDisabled(false)
			-- container.maxPrice:SetDisabled(false)
			-- container.maxQuantity:SetDisabled(false)
		end
		
		container.title = TSM.GUI:CreateLabel(container, "Shopping - Sniping", GameFontHighlight, 0, "OUTLINE", maxWidth, {"TOP", 0, -12})
		TSM.GUI:AddHorizontalBar(container, -30)
		
		local btn = TSM.GUI:CreateButton(L["GO"], container, "TSMShoppingSnipingStartButton", "UIPanelButtonTemplate", -1, nil, 25, {"TOPLEFT", 271, -58}, {"TOPRIGHT", -8, -58}, "Start sniping!")
		btn:SetScript("OnClick", function()
				Sniping:RunScan()
			end)
		container.goButton = btn
		
		TSM.GUI:AddHorizontalBar(container, -130)
		
		local frame = CreateFrame("Frame", nil, container)
		frame:SetPoint("TOPLEFT", 0, -150)
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
		
		local label = TSM.GUI:CreateLabel(frame, "*", GameFontHighlight, 0, nil, maxWidth+4, {"TOP", 0, 3}, "CENTER")
		frame.buyLabel = label
		
		local btn = TSM.GUI:CreateButton(L["BUY"], frame, "TSMShoppingSnipingBuyButton", "UIPanelButtonTemplate", 8, nil, 40, {"TOPLEFT", 250, -20}, {"TOPRIGHT", -10, -20}, L["Buy the next cheapest auction."])
		btn:SetScript("OnClick", Sniping.BuyItem)
		frame.buyButton = btn
		
		local btn = TSM.GUI:CreateButton(L["SKIP"], frame, "TSMShoppingSnipingSkipButton", "UIPanelButtonTemplate", -1, nil, 25, {"TOPLEFT", 250, -65}, {"TOPRIGHT", -10, -65}, L["Skip this auction."])
		btn:SetScript("OnClick", Sniping.SkipItem)
		frame.skipButton = btn
		
		local label = TSM.GUI:CreateLabel(frame, "*", GameFontHighlight, 2, nil, maxWidth+4, {"TOPLEFT", 10, -20}, "LEFT")
		frame.currentLabel = label
		
		TSM.GUI:AddHorizontalBar(frame, -100)
		
		local label = TSM.GUI:CreateLabel(frame, "", GameFontHighlight, 0, nil, maxWidth+4, {"TOP", 0, -120}, "LEFT")
		frame.infoLabel = label
		
		container.buyFrame = frame
		
		Sniping.frame = container
	end
	
	Sniping.frame:Show()
end

function Sniping:HideSidebar()
	Sniping.frame:Hide()
	wipe(Sniping.auctions)
	wipe(Sniping.currentItem)
	Sniping.frame.EnableAll()
end

function Sniping:RunScan()
	local queue = {""}
	Sniping.frame.DisableAll()
	Sniping.totalSpent = 0
	Sniping.numItems = 0
	TSM.Scan:StartScan(queue, "Sniping")
end

local MIN_MAKRET_PERCENT = 0.1
local MIN_VENDOR_PERCENT = 1
local MIN_RESALE_PROFIT = 10000
function Sniping:Process(scanData)
	local auctions = {}
	for sID, sData in pairs(scanData) do
		local minMarketValue = (TSMAPI:GetData("market", sID) or 0)*MIN_MAKRET_PERCENT
		local minVendorPrice = (select(11, GetItemInfo(sID)) or 0)*MIN_VENDOR_PERCENT
		local highestPrice = max(minVendorPrice, minMarketValue)
		for _, record in pairs(sData.records) do
			if record.buyout < highestPrice and (not highestPrice == minVendorPrice or highestPrice - record.buyout > MIN_RESALE_PROFIT) and (not TSM.db.global.snipeIgnore[sID]) then
				tinsert(auctions, {itemID=sID, buyout=record.buyout, quantity=record.quantity, page=record.page, stackSizeFlag=false, numItems=record.quantity})
			end
		end
	end
	
	if #auctions == 0 then
		return Sniping:RunScan()
	end
	
	debug("NUM AUCTIONS:", #auctions)
	TSM:SortAuctions(auctions, {"buyout", "numItems", "page", "quantity"})
	
	local currentCost = 0
	auctions.totalQuantity = {}
	for _, data in ipairs(auctions) do
		if data.buyout > currentCost then
			currentCost = data.buyout
			auctions.totalQuantity[currentCost] = data.quantity
		else
			auctions.totalQuantity[currentCost] = auctions.totalQuantity[currentCost] + data.quantity
		end
	end
	
	Sniping.frame.buyFrame:DisableButtons()
	Sniping.auctions = auctions
	if Sniping.auctions[1] then
		local nextAuction = CopyTable(Sniping.auctions[1])
		local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
		TSM.Scan:FindAuction(Sniping.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page)
	else
		debug("NO FIRST AUCTION")
		return Sniping:RunScan()
	end
end

function Sniping:ProcessCheapest(index)
	debug("Process", index)
	local cheapest = tremove(Sniping.auctions, 1)
	
	if not index or not cheapest then
		local nextAuction = Sniping.auctions[1]
		if not nextAuction then
			local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
			TSM.Scan:FindAuction(Sniping.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page)
		else
			Sniping.frame.buyFrame:Hide()
		end
		return
	end
	
	Sniping.frame:EnableAll()
	
	local link = GetAuctionItemLink("list", index)
	local _, _, quantity, _, _, _, _, _, buyout, newBuyout = GetAuctionItemInfo("list", index)
	if select(4, GetBuildInfo()) >= 40300 then -- fix for added parameter in 4.3
		buyout = newBuyout
	end
	local cBuyout = buyout/quantity
	local extraText = ""
	
	local minMarketValue = (TSMAPI:GetData("market", cheapest.itemID) or 0)*MIN_MAKRET_PERCENT
	local minVendorPrice = (select(11, GetItemInfo(cheapest.itemID)) or 0)*MIN_VENDOR_PERCENT
	local maxPrice = max(minMarketValue, minVendorPrice)
	local percent = floor(((maxPrice - cBuyout)/maxPrice)*10000 + 0.5)/100
	if percent < 0 then
		if maxprice == minVendorPrice then
			extraText = "\n\n"..format("|cff00ff00".."%s%% above vendor.".."|r", abs(percent))
		else
			extraText = "\n\n"..format("|cff00ff00".."%s%% above market value.".."|r", abs(percent))
		end
	else
		if maxprice == minVendorPrice then
			extraText = "\n\n"..format("|cff00ff00".."%s%% below vendor.".."|r", percent)
		else
			extraText = "\n\n"..format("|cff00ff00".."%s%% below market value.".."|r", percent)
		end
	end
	
	Sniping.frame.buyFrame:Show()
	Sniping.frame.buyFrame:EnableButtons()
	Sniping.frame.buyFrame.buyLabel:SetText(format(L["Buying: %s(%s at this price)"], link, Sniping.auctions.totalQuantity[cBuyout]))
	Sniping.frame.buyFrame.currentLabel:SetText(format(L["%s @ %s(%s per)"], link.."x"..quantity.."\n\n", TSM:FormatTextMoney(buyout) or "???", TSM:FormatTextMoney(cBuyout) or "???")..extraText)
	Sniping.currentItem = {itemID=cheapest.itemID, index=index, buyout=buyout, cost=cBuyout, quantity=quantity, numItems=cheapest.numItems, original=CopyTable(cheapest)}
end

function Sniping:BuyItem()
	debug("BUY")
	local _, _, quantity, _, _, _, _, _, buyout, newBuyout = GetAuctionItemInfo("list", Sniping.currentItem.index)
	if select(4, GetBuildInfo()) >= 40300 then -- fix for added parameter in 4.3
		buyout = newBuyout
	end
	debug(Sniping.currentItem.index, Sniping.currentItem.itemID, buyout, Sniping.currentItem.buyout, quantity, Sniping.currentItem.quantity)
	if abs(buyout - Sniping.currentItem.buyout) > 1 or abs(quantity - Sniping.currentItem.quantity) > 0.5 then
		Sniping.frame.buyFrame:DisableButtons()
		TSM:Print("The auction house has changed in the time between the last scan and you clicking this button. The item failed to be purchased. Try again.")
		TSM.Scan:FindAuction(function(_,index) Sniping.currentItem.index = index Sniping.frame.buyFrame:EnableButtons() end, Sniping.currentItem.itemID, Sniping.currentItem.quantity, Sniping.currentItem.buyout)
		return
	end
	Sniping.totalSpent = Sniping.totalSpent + Sniping.currentItem.buyout
	Sniping.numItems = Sniping.numItems + Sniping.currentItem.numItems
	Sniping.frame.buyFrame.infoLabel:SetText(format(L["Total Spent this Session: %sItems Bought This Session: %sAverage Cost Per Item this Session: %s"], TSM:FormatTextMoney(Sniping.totalSpent).."\n\n", Sniping.numItems.."\n\n", TSM:FormatTextMoney(Sniping.totalSpent/Sniping.numItems)))
	PlaceAuctionBid("list", Sniping.currentItem.index, Sniping.currentItem.buyout)
	Sniping.auctions.totalQuantity[Sniping.currentItem.cost] = Sniping.auctions.totalQuantity[Sniping.currentItem.cost] - Sniping.currentItem.quantity
	if Sniping.auctions[1] then
		Sniping:WaitForEvent()
	else
		Sniping.frame.buyFrame:Hide()
		return Sniping:RunScan()
	end
end

function Sniping:WaitForEvent()
	debug("START WAIT")
	Sniping.frame.buyFrame:DisableButtons()
	Sniping.waitingFor = {chatMsg = true, listUpdate = true}
	Sniping:RegisterEvent("CHAT_MSG_SYSTEM", function(_, msg)
			local targetMsg = gsub(ERR_AUCTION_BID_PLACED, "%%s", "")
			if msg:match(targetMsg) then
				Sniping:UnregisterEvent("CHAT_MSG_SYSTEM")
				Sniping.waitingFor.chatMsg = false
				if not Sniping.waitingFor.listUpdate then
					debug("chat msg enable")
					local nextAuction = Sniping.auctions[1]
					local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
					TSMAPI:CreateTimeDelay("shoppingFindNextSniping", 0.1, function() TSM.Scan:FindAuction(Sniping.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page) end)
				else
					debug("waiting on list update")
				end
			end
		end)
		
	local nextAuction = Sniping.auctions[1]
	local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
	Sniping:RegisterEvent("AUCTION_ITEM_LIST_UPDATE", function()
			Sniping:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
			Sniping.waitingFor.listUpdate = false
			if not Sniping.waitingFor.chatMsg then
				debug("list update enable")
				local nextAuction = Sniping.auctions[1]
				local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
				TSMAPI:CreateTimeDelay("shoppingFindNextSniping", 0.3, function() TSM.Scan:FindAuction(Sniping.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page) end)
			else
				debug("waiting on chat msg")
			end
		end)
end

function Sniping:SkipItem()
	debug("SKIP")
	foreach(Sniping.currentItem, function(i, v) if type(v) == "table" then v = "table:XXXXX" end debug(i, v) end)
	Sniping.frame.buyFrame:DisableButtons()
	Sniping.auctions.totalQuantity[Sniping.currentItem.cost] = Sniping.auctions.totalQuantity[Sniping.currentItem.cost] - Sniping.currentItem.quantity
	if Sniping.auctions[1] then
		local nextAuction = CopyTable(Sniping.auctions[1])
		local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
		TSM.Scan:FindAuction(Sniping.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page)
	else
		Sniping.frame.buyFrame:Hide()
		return Sniping:RunScan()
	end
end