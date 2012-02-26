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
local Scan = TSM:NewModule("Scan", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_AuctionDB") -- loads the localization table
local LAS = TSM.AuctionScanning
LAS:Embed(Scan)
local origQueryAuctionItems = QueryAuctionItems
local QueryAuctionItems = QueryAuctionItems

local BASE_DELAY = 0.10 -- time to delay for before trying to scan a page again when it isn't fully loaded
local CATEGORIES = {}
CATEGORIES[L["Enchanting"]] = {"4$6", "6$1", "6$4", "6$7", "6$14"}
CATEGORIES[L["Inscription"]] = {"5", "6$6", "6$9"}
CATEGORIES[L["Jewelcrafting"]] = {"6$8", "8"}
CATEGORIES[L["Alchemy"]] = {"4$2", "4$3", "4$4", "6$6"}
CATEGORIES[L["Blacksmithing"]] = {"1$1", "1$2", "1$5", "1$6", "1$7", "1$8", "1$9", "1$13", "1$14", "2$4", 
	"2$5", "2$6", "4$6", "6$1", "6$4", "6$7", "6$12", "6$13", "6$14"}
CATEGORIES[L["Leatherworking"]] = {"2$1", "2$3", "2$4", "6$1", "6$3", "6$12", "6$13"}
CATEGORIES[L["Tailoring"]] = {"2$1", "2$2", "3$1", "6$1", "6$2", "6$12", "6$13"}
CATEGORIES[L["Engineering"]] = {"1$4", "2$1", "2$1", "6$9", "6$10"}
CATEGORIES[L["Cooking"]] = {"4$1", "6$5", "6$10", "6$13"}
CATEGORIES[L["Complete AH Scan"]] = {"0"} -- scans the entire AH

local status = {page=0, retries=0, timeDelay=0, AH=false, filterlist = {}, aucAdv=nil}

-- initialize a bunch of variables and frames used throughout the module and register some events
function Scan:OnEnable()
	Scan.AucData = {}
		
	Scan:RegisterEvent("AUCTION_HOUSE_CLOSED")
	Scan:RegisterEvent("AUCTION_HOUSE_SHOW", function() status.AH = true end)
	Scan:RegisterCallback("results", function() Scan:Lock() LAS:ResolveAuctions("items") end)
	Scan:RegisterCallback("resolved")
	Scan:RegisterCallback("unlocked", function() Scan:SendQuery() end)
end

-- Scan delay for hard reset
local frame = CreateFrame("Frame")
frame.timeElapsed = 0
frame:Hide()
frame:SetScript("OnUpdate", function(self, elapsed)
	self.timeElapsed = self.timeElapsed + elapsed
	if self.timeElapsed >= 0.05 then
		self.timeElapsed = self.timeElapsed - 0.05
		Scan:SendQuery()
	end
end)

-- Scan delay for soft reset
local frame2 = CreateFrame("Frame")
frame2:Hide()
frame2:SetScript("OnUpdate", function(self, elapsed)
	self.timeLeft = self.timeLeft - elapsed
	if self.timeLeft < 0 then
		self.timeLeft = 0
		self:Hide()

		if status.isScanning ~= "GetAll" then
			Scan:ScanAuctions()
		end
	end
end)

-- gets called when the AH is closed
function Scan:AUCTION_HOUSE_CLOSED()
	Scan:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
	status.AH = false
	if status.isScanning then -- stop scanning if we were scanning (pass true to specify it was interupted)
		Scan:StopScanning(true)
	end
end

-- prepares everything to start running a scan
function Scan:RunScan()
	local alreadyAdded = {}
	local scanQueue = {}
	local num = 1
	
	if not status.AH then
		TSM:Print(L["Auction house must be open in order to scan."])
		return
	end
	
	if TSM.db.profile.getAll and select(2, CanSendAuctionQuery()) then
		status.isScanning = "GetAll"
		wipe(Scan.AucData)
		status.page = 0
		status.retries = 3
		status.hardRetry = nil
		TSMAPI:LockSidebar()
		TSMAPI:ShowSidebarStatusBar()
		TSMAPI:SetSidebarStatusBarText(L["AuctionDB - Scanning"])
		TSMAPI:UpdateSidebarStatusBar(0)
		TSMAPI:UpdateSidebarStatusBar(0, true)
		Scan:StartGetAllScan()
		return
	end
	
	if AucSearchUI and TSM.db.profile.blockAuc then
		local get, set = AucSearchUI.GetSearchLocals()
		if get and set then
			status.aucAdv = get("realtime.always")
			set("realtime.always", false)
		end
	end
	
	-- builds the scanQueue
	for name, selected in pairs(TSM.db.profile.scanSelections) do
		-- if we are doing a complete AH scan then no need to figure out what else we want to scan
		if selected and name == L["Complete AH Scan"] then
			scanQueue = {{id=1, class=0, subClass=0}}
			break
		end
		if selected and CATEGORIES[name] then
			for i=1, #(CATEGORIES[name]) do
				local class, subClass = strsplit("$", CATEGORIES[name][i])
				local valid = false
				
				if subClass then
					if not (alreadyAdded[class] or alreadyAdded[class.."$"..subClass]) then
						valid = true
						alreadyAdded[class.."$"..subClass] = true
					end
				else
					if not alreadyAdded[class] then
						valid = true
						alreadyAdded[class] = true
					end
				end
				
				if valid then
					tinsert(scanQueue, {id=#scanQueue, class=class, subClass=(subClass or 0)})
				end
			end
		end
	end

	if #(scanQueue) == 0 then
		return TSM:Print(L["Nothing to scan."])
	end
	
	if not CanSendAuctionQuery() then
		TSM:Print(L["Error: AuctionHouse window busy."])
		return
	end
	
	-- sets up the non-function-local variables
	-- filter = current category being scanned for {class, subClass}
	-- filterList = queue of categories to scan for
	wipe(Scan.AucData)
	status.page = 0
	status.retries = 0
	status.hardRetry = nil
	status.filterList = scanQueue
	status.class = scanQueue[1].class
	status.subClass = scanQueue[1].subClass
	status.id = scanQueue[1].id
	status.isScanning = "Category"
	status.numItems = #(scanQueue)
	status.originalQueue = CopyTable(scanQueue)
	TSMAPI:LockSidebar()
	TSMAPI:ShowSidebarStatusBar()
	TSMAPI:SetSidebarStatusBarText(L["AuctionDB - Scanning"])
	TSMAPI:UpdateSidebarStatusBar(0)
	TSMAPI:UpdateSidebarStatusBar(0, true)
	
	--starts scanning
	Scan:SendQuery()
end

function Scan:resolved()
	if not status.isScanning then Scan:Unlock() return end
	Scan:ScanAuctions()
end

-- sends a query to the AH frame once it is ready to be queried (uses frame as a delay)
function Scan:SendQuery(forceQueue)
	if not status.isScanning or status.isScanning == "GetAll" then return end
	status.queued = not LAS:CanSendAuctionQuery()
	if (not status.queued and not forceQueue) then
		-- stop delay timer
		frame:Hide()
		
		-- Query the auction house (then waits for AUCTION_ITEM_LIST_UPDATE to fire)
		LAS:QueryAuctionItems("", nil, nil, 0, status.class, status.subClass, status.page, 0, 0)
	else
		-- run delay timer then try again to scan
		frame:Show()
	end
end

-- scans the currently shown page of auctions and collects all the data
function Scan:ScanAuctions()
	-- collects data on the query:
		-- # of auctions on current page
		-- # of pages total
	local shown, total = GetNumAuctionItems("list")
	local totalPages = math.ceil(total / 50)
	
	-- status.hardRetry = nil
	-- status.retries = 0
	TSMAPI:UpdateSidebarStatusBar(floor(status.page/totalPages*100 + 0.5), true)
	TSMAPI:UpdateSidebarStatusBar(floor((1-(#(status.filterList)-status.page/totalPages)/status.numItems)*100 + 0.5)*.95)
	
	-- now that we know our query is good, time to verify and then store our data
	-- ex. "Eternal Earthsiege Diamond" will not get stored when we search for "Eternal Earth"
	for i=1, shown do
		local itemID = TSMAPI:GetItemID(GetAuctionItemLink("list", i))
		local name, _, quantity, _, _, _, _, _, buyout, newBuyout = GetAuctionItemInfo("list", i)
		if select(4, GetBuildInfo()) >= 40300 then -- fix for added paramter in 4.3
			buyout = newBuyout
		end
		Scan:AddAuctionRecord(itemID, quantity, buyout)
	end

	-- This query has more pages to scan
	-- increment the page # and send the new query
	if totalPages > (status.page + 1) then
		status.page = status.page + 1
		Scan:Unlock()
		return
	end
	
	-- Removes the current filter from the filterList as we are done scanning for that item
	for i=#(status.filterList), 1, -1 do
		if status.filterList[i].id == status.id then
			tremove(status.filterList, i)
			break
		end
	end
	
	-- Query the next filter if we have one
	if status.filterList[1] then
		status.class = status.filterList[1].class
		status.subClass = status.filterList[1].subClass
		status.id = status.filterList[1].id
		TSMAPI:UpdateSidebarStatusBar(floor((1-#(status.filterList)/status.numItems)*100 + 0.5)*.95)
		status.page = 0
		Scan:Unlock()
		return
	end
	
	-- we are done scanning!
	Scan:StopScanning()
end

-- Add a new record to the Scan.AucData table
function Scan:AddAuctionRecord(itemID, quantity, buyout)
	-- Don't add this data if it has no buyout
	if (not buyout) or (buyout <= 0) then return true end

	Scan.AucData[itemID] = Scan.AucData[itemID] or {quantity = 0, records = {}, minBuyout=0}
	Scan.AucData[itemID].quantity = Scan.AucData[itemID].quantity + quantity
	
	-- Calculate the buyout per 1 item
	buyout = buyout / quantity
	
	if (buyout < Scan.AucData[itemID].minBuyout or Scan.AucData[itemID].minBuyout == 0) then
		Scan.AucData[itemID].minBuyout = buyout
	end
	
	-- No sense in using a record for each entry if they are all the exact same data
	for _, record in pairs(Scan.AucData[itemID].records) do
		if record.buyout == buyout then
			record.quantity = record.quantity + quantity
			-- yes this sort is inefficient but it will never be nearly bad enough to slow down a scan
			sort(Scan.AucData[itemID].records, function(a, b) return a.buyout < b.buyout end)
			return
		end
	end
	
	-- Create a new entry in the table
	tinsert(Scan.AucData[itemID].records, {buyout = buyout, quantity = quantity})
end

-- stops the scan because it was either interupted or it was completed successfully
function Scan:StopScanning(interupted)
	if interupted then
		-- fires if the scan was interupted (auction house was closed while scanning)
		TSM:Print(L["Scan interupted due to auction house being closed."])
	else
		-- fires if the scan completed sucessfully
		TSM:Print(L["Scan complete!"])
		TSM.Data:ProcessData(Scan.AucData, status.originalQueue)
	end
	
	Scan:Unlock()
	TSMAPI:UnlockSidebar()
	TSMAPI:HideSidebarStatusBar()
	
	status.isScanning = nil
	status.queued = nil
	status.originalQueue = nil
	
	frame:Hide()
	frame2:Hide()
	
	if AucSearchUI and TSM.db.profile.blockAuc and status.aucAdv ~= nil then
		local _, set = AucSearchUI and AucSearchUI.GetSearchLocals()
		if set then
			set("realtime.always", status.aucAdv)
		end
	end
end

function Scan:ProcessImportedData(auctionData)
	Scan.AucData = {}
	for itemID, auctions in pairs(auctionData) do
		for _, auction in ipairs(auctions) do
			local buyout, quantity = unpack(auction)
			Scan:AddAuctionRecord(itemID, quantity, buyout*quantity)
		end
	end
	TSM.Data:ProcessData(Scan.AucData)
end

function Scan:IsScanning()
	return status.isScanning
end
	
function Scan:StartGetAllScan()
	TSM.db.profile.lastGetAll = time()
	if TSM.db.profile.blockAuc then
		local ok, func = pcall(function() return AucAdvanced.Scan.Private.Hook.QueryAuctionItems end)
		QueryAuctionItems = (ok and func) or origQueryAuctionItems
	else
		QueryAuctionItems = origQueryAuctionItems
	end
	QueryAuctionItems("", "", "", nil, nil, nil, nil, nil, nil, true)
	
	local scanFrame = CreateFrame("Frame")
	scanFrame:Hide()
	scanFrame.num = 0
	scanFrame.tries = 3
	scanFrame:SetScript("OnUpdate", function(self, elapsed)
			if not AuctionFrame:IsVisible() then self:Hide() end
			for i=1, 200 do
				local itemID = TSMAPI:GetItemID(GetAuctionItemLink("list", self.num))
				local name, _, quantity, _, _, _, _, _, buyout, newBuyout = GetAuctionItemInfo("list", self.num)
				if select(4, GetBuildInfo()) >= 40300 then -- fix for added paramter in 4.3
					buyout = newBuyout
				end
				if self.tries == 0 or (itemID and quantity and buyout) then
					self.num = self.num + 1
					self.tries = 3
					if itemID then
						Scan:AddAuctionRecord(itemID, quantity, buyout)
					end
					TSMAPI:UpdateSidebarStatusBar(100-floor(i/2), true)
					TSMAPI:UpdateSidebarStatusBar(floor((1+(self.num-self.numShown)/self.numShown)*100 + 0.5))
					
					if self.num == self.numShown then
						if self.num == 42554 then TSM:Print(L["|cffff0000WARNING:|r As of 4.0.1 there is a bug with GetAll scans only scanning a maximum of 42554 auctions from the AH which is less than your auction house currently contains. As a result, thousands of items may have been missed. Please use regular scans until blizzard fixes this bug."]) end
						self:Hide()
						Scan:StopScanning()
						break
					elseif not AuctionFrame:IsVisible() then
						self:Hide()
						break
					end
				else
					self.tries = self.tries - 1
					break
				end
			end
		end)
	
	local	frame1 = CreateFrame("Frame")
	frame1:Hide()
	frame1.totalDelay = 20
	frame1.delay = 1
	frame1:SetScript("OnUpdate", function(self, elapsed)
			if not AuctionFrame:IsVisible() then self:Hide() end
			self.delay = self.delay - elapsed
			self.totalDelay = self.totalDelay - elapsed
			TSMAPI:UpdateSidebarStatusBar(100-floor((self.totalDelay/20)*100), true)
			if self.delay <= 0 then
				if GetNumAuctionItems("list") > 50 then
					scanFrame.numShown = GetNumAuctionItems("list")
					self:Hide()
					scanFrame:Show()
				else
					self.delay = 1
				end
			end
		end)
	frame1:Show()
end