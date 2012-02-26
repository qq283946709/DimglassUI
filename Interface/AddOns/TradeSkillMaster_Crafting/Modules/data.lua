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
local Data = TSM:NewModule("Data", "AceEvent-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Crafting") -- loads the localization table
local debug = function(...) TSM:Debug(...) end -- for debugging

local BIG_NUMBER = 100000000000 -- 10 million gold

local matCache = {}

-- initialize all the data tables
function Data:Initialize()
	Data:RegisterEvent("CHAT_MSG_SYSTEM")

	for _, data in pairs(TSM.tradeSkills) do
		-- load all the crafts into Data.crafts
		TSM.db.profile[data.name] = TSM.db.profile[data.name] or {}
		Data[data.name] = TSM.db.profile[data.name]
		Data[data.name].mats = Data[data.name].mats or {}
		Data[data.name].crafts = Data[data.name].crafts or {}
		Data.onAH = {}
		
		for _, v in ipairs(Data[data.name].crafts) do
			if v.itemID then
				local temp = CopyTable(v)
				temp.itemID = nil
				Data[data.name].crafts[v.itemID] = temp
			end
			v = nil
		end
		
		local toRemove = {}
		for itemID, craft in pairs(Data[data.name].crafts) do
			craft.sell = nil
			craft.posted = nil
			craft.hasCD = craft.hasCD and true or nil
		end
		for _, id in pairs(toRemove) do
			Data[data.name].crafts[id] = nil
		end
		
		-- add any materials that aren't in the default table to the data table
		for id, mat in pairs(Data[data.name].mats) do
			id = tonumber(id)
			-- the id is going to be the key (and the value is the cost of that material which we don't care about)
			local toRemove = true
			for itemID, craft in pairs(Data[data.name].crafts) do
				if craft.mats[id] then
					toRemove = false
				end
			end
			
			-- remove the mat from the savedDB if it is unused
			if toRemove then
				Data[data.name].mats[id] = nil
			else
				if TSM.db.profile.matLock and TSM.db.profile.matLock[id] then
					mat.override = true
					mat.source = "custom"
				end
				if mat.cost then
					if TSM.db.profile.matLock then
						mat.cost = floor((mat.cost or 0) * COPPER_PER_GOLD + 0.5)
					end
					if mat.source == "custom" and not mat.customValue then
						mat.customValue = mat.cost
					elseif strfind(mat.source or "", "#") and not (mat.customID and mat.customMultiplier) then
						local customID, customMultiplier = ("#"):split(mat.source)
						mat.customID = tonumber(customID)
						mat.customMultiplier = tonumber(customMultiplier)
						mat.source = "customitem"
					end
					mat.cost = nil
				end
				if (mat.source ~= "custom" and mat.source ~= "customitem") or not mat.override then
					mat.customID = nil
					mat.customMultiplier = nil
					mat.customValue = nil
				end
				mat.cachedCost = nil
				mat.cacheTime = nil
				if mat.override == false then
					mat.override = nil
				end
			end
		end
	end
	
	TSM.db.profile.matLock = nil
end

local idCache = {}
-- calulates the cost, buyout, and profit for a crafted item
function Data:CalcPrices(craft, mode, extraArg)
	local sTime = GetTime()
	if not craft then return end
	local itemID
	mode = mode or TSM.mode

	if type(craft) == "number" then
		itemID = craft
		craft = Data[mode].crafts[craft]
		idCache[craft.spellID] = itemID
	end
	
	itemID = itemID or idCache[craft.spellID]
	
	if not itemID then
		for sID, data in pairs(Data[mode].crafts) do
			if data.spellID == craft.spellID then
				idCache[craft.spellID] = sID
				itemID = idCache[craft.spellID]
				break
			end
		end
		if not itemID then return end
	end

	-- first, we calculate the cost of crafting that crafted item based off the cost of the individual materials
	local cost, validCost = 0, true
	for id, matQuantity in pairs(craft.mats) do
		id = tonumber(id)
		local matCost = Data:GetMatCost(mode, id, extraArg)
		if not matCost or matCost == 0 then
			validCost = false
			break
		end
		cost = cost + matQuantity*matCost
	end
	cost = floor(cost/(craft.numMade or 1) + 0.5) --rounds to nearest gold
	
	-- next, we get the buyout from the auction scan data table and calculate the profit
	local buyout, profit
	local sell = Data:GetMarketPrice(itemID)
	if validCost and sell then
		-- grab the buyout price and calculate the profit if the buyout price exists and is a valid number
		buyout = sell
		profit = buyout - buyout*TSM.db.profile.profitPercent - cost
		profit = floor(profit + 0.5) -- rounds to the nearest gold
	end
	
	-- return the results
	return (validCost and cost or nil), buyout, profit
end

function Data:GetMatSourcePrice(mode, itemID, source, visitedList)
	local cost
	local mat = Data[mode].mats[itemID]

	if source == "auction" then -- value based on auction data
		cost = Data:GetItemMarketPrice(itemID, "mat")
	elseif source == "vendor" then -- value based on how much a vendor sells it for
		cost = TSM:GetVendorPrice(itemID)
	elseif source == "vendortrade" then -- value based on the value of an item that can be traded for this mat
		local tradeItemID, tradeQuantity = TSM:GetItemVendorTrade(itemID)
		if tradeItemID then
			cost = (Data[mode].mats[tradeItemID] and Data:GetMatCost(mode, tradeItemID, visitedList) or Data:GetItemMarketPrice(tradeItemID, "mat") or 0)*tradeQuantity
		end
	elseif source == "craft" then -- value based on crafting this mat
		cost = Data:CalcPrices(Data[mode].crafts[itemID], mode, visitedList)
	elseif source == "mill" then -- value based on milling for this mat (pigments)
		local pigmentID, pigmentData = TSM.Inscription:GetInkFromPigment(itemID)
		if pigmentID then
			local prices = {}
			local pigmentPrice = Data:GetItemMarketPrice(pigmentID, "mat")
			if pigmentPrice and pigmentPrice ~= 0 then
				tinsert(prices, pigmentPrice)
			end
			for i=1, #pigmentData.herbs do
				local herbID = pigmentData.herbs[i].itemID
				local pigmentPerMill = pigmentData.herbs[i].pigmentPerMill
				local marketPrice = Data:GetItemMarketPrice(herbID, "mat")
				if marketPrice and marketPrice ~= 0 then
					tinsert(prices, floor(marketPrice*5/pigmentPerMill + 0.5))
				end
			end
			-- set the cost to the 2nd lowest price if there are atleast 2
			sort(prices, function(a, b) return a < b end)
			cost = prices[min(#prices, 2)]
		end
	elseif source == "customitem" then -- value based on another item
		local mat = Data[mode].mats[itemID]
		if mat.customID and mat.customMultiplier then
			if Data[mode].crafts[mat.customID] then
				-- this item is based on an item that is a craft
				cost = (Data:CalcPrices(Data[mode].crafts[mat.customID], mode, visitedList) or 0)*mat.customMultiplier
			elseif Data[mode].mats[mat.customID] then
				-- this item is based on an item that is a mat
				cost = (Data:GetMatCost(mode, mat.customID, visitedList) or 0)*mat.customMultiplier
			else
				cost = (Data:GetItemMarketPrice(mat.customID, "mat") or 0)*mat.customMultiplier
			end
		end
	elseif source == "custom" then
		cost = Data[mode].mats[itemID].customValue or 0
	end
	
	if cost == 0 then
		cost = nil
	end
	
	return cost
end

function Data:GetMatCost(mode, itemID, visitedList)
	visitedList = CopyTable(visitedList or {})
	if visitedList[itemID] then
		return
		-- ERROR! circular dependency!
		-- local _, link = GetItemInfo(itemID)
		-- return TSM:Print("ERROR! Circular Dependency!", link)
	end
	visitedList[itemID] = true
	
	local mat = Data[mode].mats[itemID]
	if not mat then return end
	
	if matCache[itemID] and matCache[itemID].cost and (time() - matCache[itemID].cTime) < 1 then
		return matCache[itemID].cost
	end
	
	local cost
	if mat.override then
		cost = Data:GetMatSourcePrice(mode, itemID, mat.source, visitedList)
	else
		mat.customValue = nil
		mat.customID = nil
		mat.customMultiplier = nil
		local matSources = {"auction", "vendor", "vendortrade", "craft", "mill"}
		local cheapestCost, cheapestSource
		for i=1, #matSources do
			local sourcePrice = Data:GetMatSourcePrice(mode, itemID, matSources[i], visitedList)
			if sourcePrice and (not cheapestCost or sourcePrice < cheapestCost) then
				cheapestCost = sourcePrice
				cheapestSource = matSources[i]
			end
		end
		
		mat.source = cheapestSource or mat.source
		cost = cheapestCost
	end
	
	if cost then
		matCache[itemID] = matCache[itemID] or {}
		matCache[itemID].cTime = time()
		matCache[itemID].cost = cost
	end
	return cost
end

function Data:GetItemMarketPrice(itemID, itemType)
	local itemLink = select(2, GetItemInfo(itemID)) or itemID
	local source = (itemType == "mat" and TSM.db.profile.matCostSource) or (itemType == "craft" and TSM.db.profile.craftCostSource)
	local cost
	
	if source == "DBMarket" then
		cost = TSMAPI:GetData("market", itemID)
	elseif source == "DBMinBuyout" then
		cost = select(5, TSMAPI:GetData("market", itemID))
	elseif source == "AucAppraiser" and AucAdvanced and select(4, GetAddOnInfo("Auc-Advanced")) == 1 then
		cost = AucAdvanced.Modules.Util.Appraiser.GetPrice(itemLink)
		if cost < 1 then
			cost = AucAdvanced.API.GetMarketValue(itemLink)
		end
	elseif source == "AucMinBuyout" and AucAdvanced and select(4, GetAddOnInfo("Auc-Advanced")) == 1 then
		cost = select(6, AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems(itemLink))
	elseif source == "AucMarket" and AucAdvanced and select(4, GetAddOnInfo("Auc-Advanced")) == 1 then
		cost = AucAdvanced.API.GetMarketValue(itemLink)
	elseif source == "AtrValue" and Atr_GetAuctionBuyout and select(4, GetAddOnInfo("Auctionator")) == 1 then
		cost = Atr_GetAuctionBuyout(itemLink or itemID)
	elseif source == "TUJMarket" and TUJMarketInfo and select(4, GetAddOnInfo("TheUndermineJournal")) == 1 then
		if itemID ~= 0 then
			cost = (TUJMarketInfo(itemID) or {}).market
		end
	elseif source == "TUJMean" and TUJMarketInfo and select(4, GetAddOnInfo("TheUndermineJournal")) == 1 then
		if itemID ~= 0 then
			cost = (TUJMarketInfo(itemID) or {}).marketaverage
		end
	end
	
	return cost
end
	
-- Gets the market price of an item based on the set source
function Data:GetMarketPrice(itemID)
	if type(itemID) ~= "number" then itemID = tonumber(itemID) end
	if not itemID then return end
	cost = Data:GetItemMarketPrice(itemID, "craft")
	if cost then
		return cost
	end
end

-- returns a table containing a list of all itemIDs of mats for this profession
function Data:GetMats(mode)
	local matTemp = {} -- stores boolean values corresponding to whether or not each material is valid (being used)
	local returnTbl = {} -- properly formatted table to be returned
	mode = mode or TSM:GetMode()
	
	-- check each craft and make sure it is shown in the 'manage crafts' section of the options
	-- if it is, set all of its materials to valid because they are being used by the addon
	for _, chant in pairs(Data[mode].crafts) do
		for matID in pairs(chant.mats) do
			matTemp[matID] = true 
		end
	end
	
	-- the matTemp table is indexed by itemID of the materials
	-- this must be changed to remain consistent with the Data.matList table so that the itemID is the value
	-- this loop does that
	for matID in pairs(matTemp) do
		tinsert(returnTbl, tonumber(matID))
	end
	
	-- sort the table so that the mats are displayed in a somewhat logical order (by itemID)
	sort(returnTbl)
	
	return returnTbl
end

-- resets all of the data when the "Reset Craft Queue" button is pressed
function Data:ResetData()
	-- reset the number queued of every craft back to 0
	for _, data in pairs(TSM.Data[TSM:GetMode()].crafts) do
		data.queued = 0
	end
	
	CloseTradeSkill() -- close the enchanting trade skill window
	TSM.Crafting:TRADE_SKILL_CLOSE() -- cleans up the Enchanting module
	wipe(TSM.GUI.queueList) -- clears the craft queue data table
	TSM:Print(L["Craft Queue Reset"]) -- prints out a nice message
end

-- returns the Data.crafts table as a 2D array with a slot index (chants[slot][chant] instead of chants[chant])
function Data:GetDataByGroups(mode)
	local craftsByGroup = {}
	for itemID, data in pairs(Data[mode or TSM.mode].crafts) do
		if data.group then
			craftsByGroup[data.group] = craftsByGroup[data.group] or {}
			craftsByGroup[data.group][itemID] = CopyTable(data)
		end
	end
	
	return craftsByGroup
end

function Data:GetSortedData(oTable, sortFunc)
	local temp = {}
	for index, data in pairs(oTable) do
		local tTemp = {}
		for i, v in pairs(data) do tTemp[i] = v end
		tTemp.originalIndex = index
		tinsert(temp, tTemp)
	end
	
	sort(temp, sortFunc)
	
	return temp
end

function Data:GetShoppingData(forModule)
	local matTotals = {}
	local results = {}
	local total = {}
	local mode = {}
	local queued = {}
	
	if forModule == "crafting" then
		tinsert(mode, TSM.Crafting.mode or TSM.mode)
	elseif forModule == "shopping" then
		for _, data in pairs(TSM.tradeSkills) do
			tinsert(mode, data.name)
		end
	elseif type(forModule) == "table" then
		for _, m in ipairs(forModule) do
			tinsert(mode, m)
			forModule = "shopping"
		end
	elseif forModule then
		tinsert(mode, forModule)
	else
		tinsert(mode, TSM.mode)
	end

	for _, profession in pairs(mode) do
		-- Goes through every material and every craft and adds up the matTotals.
		for itemID, data in pairs(Data[profession].crafts) do
			if data.queued and data.queued > 0 then -- if the craft is queued...
				for matItemID, matQuantity in pairs(data.mats) do
					-- add the correct number of that material to the totals table
					matTotals[matItemID] = (matTotals[matItemID] or 0) + matQuantity*data.queued
				end
				queued[itemID] = data.queued
			end
		end
	end

	local extra = {}
	for itemID, quantity in pairs(matTotals) do
		if queued[itemID] then
			quantity = quantity - queued[itemID]
		end
		local bags, bank, auctions = Data:GetPlayerNum(itemID)
		local numHave = Data:GetAltNum(itemID) + bags + bank + auctions
		local numNeed = quantity
		
		local equivItemID, ratio = TSM:GetEquivItem(itemID)
		if equivItemID and numHave > numNeed then -- there is an equiv item (eternal / essence)
			extra[equivItemID] = floor((numHave - numNeed) * ratio)
		end
		
		if quantity > 0 then
			tinsert(total, {itemID, quantity})
			local need = quantity - numHave - (extra[itemID] or 0)
			
			if need > 0 or forModule == "crafting" then
				local inkID, pigPerInk = TSM.Inscription:GetInk(itemID)
				if forModule == "shopping" and inkID then
					tinsert(results, {inkID, ceil(need/pigPerInk), TSM:GetVendorPrice(itemID) and true})
				else
					tinsert(results, {itemID, need, TSM:GetVendorPrice(itemID) and true})
				end
			end
		end
	end
	
	if forModule == "crafting" then
		return results, total
	elseif forModule == "shopping" then
		return results, total
	elseif forModule then
		return total, results
	else
		return results
	end
end

function Data:BuildCraftQueue(queueType)
	local mode = TSM:GetMode()
	local sTime = GetTime()
	if queueType == "restock" then
		for itemID, data in pairs(Data[mode].crafts) do
			if data.enabled and not data.hasCD then
				local minRestock = TSM:GetDBValue("minRestockQuantity", mode, itemID)
				local maxRestock = TSM:GetDBValue("maxRestockQuantity", mode, itemID)
				local bags, bank, auctions = Data:GetPlayerNum(itemID)
				local numHave = Data:GetAltNum(itemID) + bags + bank + auctions
				local numCanQueue = maxRestock - numHave
				local link, _, ilvl = select(2, GetItemInfo(itemID))
				local seenCount = Data:GetSeenCount(itemID)
				
				if TSM.db.profile.dontQueue[itemID] or (seenCount and not TSM.db.profile.ignoreSeenCountFilter[itemID] and seenCount < TSM.db.profile.seenCountFilter) then
					numCanQueue = 0
				end
				
				if TSM.db.profile.limitIlvl[mode] then 
					if TSM.db.profile.minilvlToCraft[mode] and (tonumber(ilvl) < TSM.db.profile.minilvlToCraft[mode])  then
					numCanQueue = 0
					end
 				end
				
				local pMethod = TSM:GetDBValue("queueProfitMethod", mode, itemID)
				if pMethod == "none" or TSM.db.profile.alwaysQueue[itemID] then
					data.queued = numCanQueue
				elseif pMethod == "percent" then
					local cost, buyout, profit = Data:CalcPrices(data, mode)
					local minProfit = TSM:GetDBValue("queueMinProfitPercent", mode, itemID)
					if cost and profit and profit >= cost*minProfit then
						data.queued = numCanQueue
					elseif cost and not buyout and TSM:GetDBValue("unknownProfitMethod") == "fallback" and TSMAPI:GetData("auctioningFallback", itemID) then
						profit = TSMAPI:GetData("auctioningFallback", itemID) - cost
						if profit and profit >= cost*minProfit then
							data.queued = numCanQueue
						else
							data.queued = 0
						end
					else
						data.queued = 0
					end
				elseif pMethod == "gold" then
					local cost, buyout, profit = Data:CalcPrices(data, mode)
					local minProfit = (TSM:GetDBValue("queueMinProfitGold", mode, itemID) or 0)*COPPER_PER_GOLD
					if profit and profit >= minProfit then
						data.queued = numCanQueue
					elseif cost and not buyout and TSM:GetDBValue("unknownProfitMethod") == "fallback" and TSMAPI:GetData("auctioningFallback", itemID) then
						profit = TSMAPI:GetData("auctioningFallback", itemID) - cost
						if profit and profit >= minProfit then
							data.queued = numCanQueue
						else
							data.queued = 0
						end
					else
						data.queued = 0
					end
				elseif pMethod == "both" then
					local cost, buyout, profit = Data:CalcPrices(data, mode)
					local minProfit = (TSM:GetDBValue("queueMinProfitGold", mode, itemID) or 0)*COPPER_PER_GOLD
					local percent = TSM:GetDBValue("queueMinProfitPercent", mode, itemID)
					if cost then
						minProfit = minProfit + cost*percent
						if profit and profit >= minProfit then
							data.queued = numCanQueue
						elseif cost and not buyout and TSM:GetDBValue("unknownProfitMethod") == "fallback" and TSMAPI:GetData("auctioningFallback", itemID) then
							profit = TSMAPI:GetData("auctioningFallback", itemID) - cost
							if profit and profit >= minProfit then
								data.queued = numCanQueue
							else
								data.queued = 0
							end
						else
							data.queued = 0
						end
					else
						data.queued = 0
					end
				end
				
				if minRestock > maxRestock then
					local link = select(2, GetItemInfo(itemID)) or data.name
					TSM:Print(format(L["%s not queued! Min restock of %s is higher than max restock of %s"], link, minRestock, maxRestock))
				end
				
				if data.queued < 0 or data.queued < minRestock then
					data.queued = 0
				end
			end
		end
	else
		local sortedData = Data:GetSortedData(Data[mode].crafts, function(a, b)
				local defaultValue = math.huge
				local _, _, aprofit = Data:CalcPrices(a, mode)
				local _, _, bprofit = Data:CalcPrices(b, mode)
				aprofit = aprofit or defaultValue
				bprofit = bprofit or defaultValue
				return aprofit > bprofit
			end)
		
		local usedMats = {}
		for _, sData in pairs(sortedData) do
			local itemID = sData.originalIndex
			local data = Data[mode].crafts[itemID]
			local quantity = 0
			local profit = 0
			local ilvl = select(4, GetItemInfo(itemID))
			if data then
				profit = select(3, Data:CalcPrices(itemID, mode)) or profit
			end
			
			if data and data.enabled and not data.hasCD and profit >= 0 then
				local maxRestock = TSM:GetDBValue("maxRestockQuantity", mode, itemID)
				local bags, bank, auctions = Data:GetPlayerNum(itemID)
				local numHave = Data:GetAltNum(itemID) + bags + bank + auctions
				local numCanQueue = maxRestock - numHave
				local seenCount = Data:GetSeenCount(itemID)
				
				if TSM.db.profile.dontQueue[itemID] or (seenCount and not TSM.db.profile.ignoreSeenCountFilter[itemID] and seenCount < TSM.db.profile.seenCountFilter) then
					numCanQueue = 0
				end
				
				if TSM.db.profile.limitIlvl[mode] then 
 					if TSM.db.profile.minilvlToCraft[mode] and (tonumber(ilvl) < TSM.db.profile.minilvlToCraft[mode])  then
 						numCanQueue = 0
 					end
 				end
				
				-- make sure somehow they didn't queue 0.76 of a craft or a negative number of crafts
				data.queued = floor(data.queued + 0.5) 
				if data.queued < 0 then data.queued = 0 end
				
				for matID, mQuantity in pairs(data.mats) do
 					if Data[mode].mats[matID].source == "vendor" and TSM.db.profile.assumeVendorInBags then
 						if not TSM.db.profile.limitVendorItemPrice or Data:GetMatCost(mode, matID) <= TSM.db.profile.maxVendorPrice then
 							usedMats[matID] = -1
 						end
 					end
 				end
			
				while(true) do
					local t = TSM.Crafting:GetOrderIndex({spellID=data.spellID, quantity=quantity+1}, usedMats)
					if t ~= 3 or quantity >= numCanQueue then
						break
					else
						quantity = quantity + 1
					end
				end
				
				for matID, mQuantity in pairs(data.mats) do
					usedMats[matID] = (usedMats[matID] or 0) + quantity*mQuantity
				end
				
				data.queued = quantity
			end
		end
	end
	local time1 = GetTime()
	TSM.GUI:UpdateQueue(true)
	debug(GetTime()-time1, time1-sTime)
end

function Data:GetSeenCount(itemID)
	if AucAdvanced and TSM.db.profile.seenCountFilterSource == "Auctioneer" then
		local link = select(2, GetItemInfo(itemID)) or itemID
		return select(2, AucAdvanced.API.GetMarketValue(link))
	elseif TSM.db.profile.seenCountFilterSource == "AuctionDB" then
		return TSMAPI:GetData("seenCount", itemID)
	end
end

function Data:GetAltNum(itemID)
	local count = 0
	if TSM.db.profile.altAddon == "DataStore" and select(4, GetAddOnInfo("DataStore_Containers")) == 1 and DataStore then
		for account in pairs(DataStore:GetAccounts()) do
			for characterName, character in pairs(DataStore:GetCharacters(nil, account)) do
				if characterName ~= UnitName("Player") and TSM.db.profile.altCharacters[characterName] then
					local bagCount, bankCount = DataStore:GetContainerItemCount(character, itemID)
					count = count + (bagCount or 0)
					count = count + (bankCount or 0)
				end
			end
			for guildName, guild in pairs(DataStore:GetGuilds(nil, account)) do
				if TSM.db.profile.altGuilds[guildName] then
					local itemCount = DataStore:GetGuildBankItemCount(guild, itemID)
					count = count + (itemCount or 0)
				end
			end
		end
	elseif TSM.db.profile.altAddon == "Gathering" and select(4, GetAddOnInfo("TradeSkillMaster_Gathering")) == 1 then
		for _, player in pairs(TSMAPI:GetData("playerlist") or {}) do
			if player ~= UnitName("player") and TSM.db.profile.altCharacters[player] then
				local bags = TSMAPI:GetData("playerbags", player)
				local bank = TSMAPI:GetData("playerbank", player)
				count = count + (bags[itemID] or 0)
				count = count + (bank[itemID] or 0)
			end
		end
		for _, guild in pairs(TSMAPI:GetData("guildlist") or {}) do
			if TSM.db.profile.altGuilds[guild] then
				local bank = TSMAPI:GetData("guildbank", guild)
				count = count + (bank[itemID] or 0)
			end
		end
	end
	
	if TSM.db.profile.altAddon == "DataStore" and select(4, GetAddOnInfo("DataStore_Auctions")) == 1 and DataStore then
		for account in pairs(DataStore:GetAccounts()) do
			for characterName, character in pairs(DataStore:GetCharacters(nil, account)) do
				if TSM.db.profile.altCharacters[characterName] and characterName ~= UnitName("player") then
					local lastVisit = (DataStore:GetAuctionHouseLastVisit(character) or math.huge) - time()
					if lastVisit < 48*60*60 then
						count = count + (DataStore:GetAuctionHouseItemCount(character, itemID) or 0)
					end
				end
			end
		end
	elseif TSM.db.profile.altAddon == "Gathering" and select(4, GetAddOnInfo("TradeSkillMaster_Gathering")) == 1 and TSMAPI:GetVersionKey("TradeSkillMaster_Gathering") >= 2 then
		for _, player in pairs(TSMAPI:GetData("playerlist") or {}) do
			if player ~= UnitName("player") and TSM.db.profile.altCharacters[player] then
				local auctions = TSMAPI:GetData("playerauctions", player) or {}
				count = count + (auctions[itemID] or 0)
			end
		end
	end
	
	return count
end

local cache = {}
function Data:GetPlayerNum(itemID)
	if cache[itemID] and (GetTime() - cache[itemID].lastTime) < 1 then
		return unpack(cache[itemID].data)
	end
	cache[itemID] = {}
	local auctions = 0
	
	if TSM.db.profile.restockAH then
		if select(4, GetAddOnInfo("DataStore_Auctions")) == 1 and DataStore then
			auctions = DataStore:GetAuctionHouseItemCount(DataStore:GetCharacter(), itemID) or 0
		else
			auctions = (TSMAPI:GetData("playerauctions", UnitName("player")) or {})[itemID] or 0
		end
	end
	
	if TSM.db.profile.altAddon == "DataStore" and select(4, GetAddOnInfo("DataStore_Containers")) == 1 and DataStore then
		for account in pairs(DataStore:GetAccounts()) do
			for characterName, character in pairs(DataStore:GetCharacters(nil, account)) do
				if characterName == UnitName("player") then
					local bags, bank = DataStore:GetContainerItemCount(character, itemID)
					cache[itemID].lastTime = GetTime()
					cache[itemID].data = {(bags or 0), (bank or 0), auctions}
					return bags or 0, bank or 0, auctions
				end
			end
		end
	elseif TSM.db.profile.altAddon == "Gathering" and select(4, GetAddOnInfo("TradeSkillMaster_Gathering")) == 1 then
		bags = (TSMAPI:GetData("playerbags", UnitName("player")) or {})[itemID] or 0
		bank = (TSMAPI:GetData("playerbank", UnitName("player")) or {})[itemID] or 0
		local iType = select(6, GetItemInfo(itemID))
		if iType and iType ~= "Container" and bags == 0 then bags = bags + GetItemCount(itemID) end
		if iType and iType ~= "Container" and bank == 0 then bank = bank + (GetItemCount(itemID, true) - GetItemCount(itemID)) end
		cache[itemID].lastTime = GetTime()
		cache[itemID].data = {bags, bank, auctions}
		return bags, bank, auctions
	else
		-- if they don't have datastore or gathering...they get the very inaccurate GetItemCount result for bags/bank
		local bags = GetItemCount(itemID)
		local bank = GetItemCount(itemID, true) - bags
		cache[itemID].lastTime = GetTime()
		cache[itemID].data = {bags, bank, auctions}
		return bags, bank, auctions
	end
end

function Data:GetTotalQuantity(itemID)
	local bags, bank, auctions = Data:GetPlayerNum(itemID)
	local alts = Data:GetAltNum(itemID)
	
	return bags + bank + auctions + alts
end

function Data:ShowScanningFrame()
	if not TradeSkillFrame then return end
	if not Data.scanningFrame then
		local frame = CreateFrame("Frame", nil, TradeSkillFrame)
		frame:SetAllPoints(TradeSkillFrame)
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			tile = false,
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 24,
			insets = {left = 4, right = 4, top = 4, bottom = 4},
		})
		frame:SetBackdropColor(0, 0, 0.05, 1)
		frame:SetBackdropBorderColor(0,0,1,1)
		frame:SetFrameLevel(TradeSkillFrame:GetFrameLevel() + 10)
		frame:EnableMouse(true)
		
		local tFile, tSize = GameFontNormalLarge:GetFont()
		local titleText = frame:CreateFontString(nil, "Overlay", "GameFontNormalLarge")
		titleText:SetFont(tFile, tSize-2, "OUTLINE")
		titleText:SetTextColor(1, 1, 1, 1)
		titleText:SetPoint("CENTER", frame, "CENTER", 0, 0)
		titleText:SetText(L["TradeSkillMaster_Crafting - Scanning..."])
		Data.scanningFrame = frame
	end
	Data.scanningFrame:Show()
end

function Data:ScanProfession(mode)
	local openProfession = TSM.Crafting:GetCurrentTradeskill()
	if openProfession then
		Data.wasOpen = openProfession
	else
		Data.wasOpen = nil
	end
	CloseTradeSkill()
	for _, data in pairs(TSM.tradeSkills) do
		if data.name == TSM.mode then
			local spellName = GetSpellInfo(data.spellID)
			local delay = CreateFrame("Frame")
			delay:RegisterEvent("TRADE_SKILL_UPDATE")
			delay:RegisterEvent("TRADE_SKILL_SHOW")
			delay:SetScript("OnEvent", function(self, event)
					self:UnregisterEvent(event)
					if event == "TRADE_SKILL_UPDATE" then
						if self.ready then
							self:Hide()
							TSMAPI:CreateTimeDelay("professionscan", 0.2, Data.StartProfessionScan)
						else
							self.ready = true
						end
					elseif event == "TRADE_SKILL_SHOW" then
						Data:ShowScanningFrame()
						if TradeSkillFilterBarExitButton and TradeSkillFilterBarExitButton:IsVisible() then
							TradeSkillFilterBarExitButton:Click()
						end
						for i=GetNumTradeSkills(), 1, -1 do
							local _, lineType, _, isExpanded = GetTradeSkillInfo(i)
							if lineType == "header" and not isExpanded then
								ExpandTradeSkillSubClass(i)
							end
						end
						if self.ready then
							self:Hide()
							TSMAPI:CreateTimeDelay("professionscan", 0.2, Data.StartProfessionScan)
						else
							self.ready = true
						end
					end
				end)
			CastSpellByName(spellName) -- opens the profession
			break
		end
	end
end

function Data:StartProfessionScan()
	scanCoroutine = coroutine.create(Data.ScanCrafts)
	local driver = CreateFrame("Frame")
	driver.timeout = 10
	driver:SetScript("OnUpdate", function(self, elapsed)
			self.timeLeft = (self.timeLeft or 0.05) - elapsed
			self.timeout = self.timeout - elapsed
			if self.timeLeft <= 0 then
				self.timeLeft = nil
				local status = coroutine.status(scanCoroutine)
				if status == "suspended" then
					coroutine.resume(scanCoroutine)
				elseif status == "dead" then
					Data.scanningFrame:Hide()
					self:Hide()
					if Data.wasOpen ~= TSM.mode then
						CloseTradeSkill()
					end
				end
			elseif self.timeout <= 0 then
				Data.scanningFrame:Hide()
				scanCoroutine = nil
				self:Hide()
				if Data.wasOpen ~= TSM.mode then
					CloseTradeSkill()
				end
			end
		end)
end

function Data:ScanCrafts()
	local matsTemp = {}
	local enchantsTemp = {}
	local validMatItemIDs, validCraftItemIDs = {}, {}
	
	for index=2, GetNumTradeSkills() do
		local dataTemp = {mats={}, itemID=nil, spellID=nil, queued=0, group=nil, name=nil}
		local tsLink = GetTradeSkillItemLink(index)
		if TSM:IsEnchant(tsLink) and TSM.mode == "Enchanting" then
			dataTemp.spellID = TSMAPI:GetItemID(GetTradeSkillItemLink(index))
			dataTemp.itemID = TSM.Enchanting.itemID[tonumber(dataTemp.spellID)]
			if dataTemp.spellID and dataTemp.itemID and TSM.Enchanting:GetSlot(dataTemp.itemID) then
				while true do
					dataTemp.name = GetSpellInfo(dataTemp.spellID)
					if dataTemp.name then
						break
					else
						coroutine.yield()
					end
				end
			end
		else
			dataTemp.spellID = TSMAPI:GetItemID(GetTradeSkillRecipeLink(index))
			if tsLink and not TSM:IsEnchant(tsLink) and dataTemp.spellID then 
				dataTemp.itemID = TSMAPI:GetItemID(tsLink)
				if dataTemp.itemID then
					while true do
						dataTemp.name = GetItemInfo(dataTemp.itemID)
						if dataTemp.name then
							break
						else
							coroutine.yield()
						end
					end
				end
			end
		end
		if dataTemp.name then
			-- figure out how many of this item is made per craft (almost always 1)
			local lNum, hNum = GetTradeSkillNumMade(index)
			dataTemp.numMade = floor(((lNum or 1) + (hNum or 1))/2)
			dataTemp.hasCD = select(2, GetTradeSkillCooldown(index)) and true or nil
			
			if TSM.mode == "Enchanting" and TSM:IsEnchant(tsLink) then
				dataTemp.mats[TSM.Enchanting.vellumID] = 1
				matsTemp[TSM.Enchanting.vellumID] = {name = TSM:GetNameFromID(TSM.Enchanting.vellumID), cost = 5}
			end
			
			local valid = false
			
			while true do
				valid = true
				-- loop over every material for the selected craft and gather itemIDs and quantities for the mats
				for i=1, GetTradeSkillNumReagents(index) do
					local link = GetTradeSkillReagentItemLink(index, i)
					local matID = TSMAPI:GetItemID(link)
					if not matID then
						valid = false
						break
					end
					local name, _, quantity = GetTradeSkillReagentInfo(index, i)
					if not name then
						valid = false
						break
					end
					dataTemp.mats[matID] = quantity
					matsTemp[matID] = {name = name, cost = 5}
				end
				
				if not valid then
					coroutine.yield()
				else
					break
				end
			end
			if valid then
				local itemID = dataTemp.itemID
				dataTemp.itemID = nil
				dataTemp.group = TSM[TSM.mode]:GetSlot(itemID, dataTemp.mats)
				
				validCraftItemIDs[itemID] = true
				for itemID in pairs(dataTemp.mats) do
					validMatItemIDs[itemID] = true
				end
				
				if not TSM.Data[TSM.mode].crafts[itemID] then
					TSM.Data[TSM.mode].crafts[itemID] = CopyTable(dataTemp)
					TSM.Data[TSM.mode].crafts[itemID].enabled = not TSM.db.profile.lastScan[TSM.mode] or (TSM.db.profile.enableNewTradeskills and true or nil)
				else
					-- mats change every so often so make sure they are up to date
					TSM.Data[TSM.mode].crafts[itemID].mats = CopyTable(dataTemp.mats)
					-- make sure the number each cast makes is correct
					TSM.Data[TSM.mode].crafts[itemID].numMade = dataTemp.numMade
					-- make sure the cd info is correct
					TSM.Data[TSM.mode].crafts[itemID].hasCD = dataTemp.hasCD
				end
			end
		end
		if index%100 == 0 then coroutine.yield() end
	end
	local matList = TSM.Data:GetMats()
	for ID, matData in pairs(matsTemp) do
		TSM.Data[TSM.mode].mats[ID] = TSM.Data[TSM.mode].mats[ID] or matData
	end
	TSM.db.profile.lastScan[TSM.mode] = time()
	
	local matsToRemove, craftsToRemove = {}, {}
	for itemID, craft in pairs(TSM.Data[TSM.mode].crafts) do
		if not validCraftItemIDs[itemID] then
			tinsert(craftsToRemove, itemID)
		else
			for matID in pairs(craft.mats) do
				if not validMatItemIDs[matID] then
					tinsert(matsToRemove, matID)
				end
			end
		end
	end
	
	local isValidTradeSkill = false
	local currentTradeSkillName = GetTradeSkillLine()
	for _, data in ipairs(TSM.tradeSkills) do
		if data.name == TSM.mode then
			if currentTradeSkillName == GetSpellInfo(data.spellID) then
				isValidTradeSkill = true
			end
			break
		end
	end
	
	local playerName = UnitName("player")
	TSM.db.profile.playerProfessionInfo[TSM.mode] = TSM.db.profile.playerProfessionInfo[TSM.mode] or {}
	
	if isValidTradeSkill then
		TSM.db.profile.playerProfessionInfo[TSM.mode][playerName] = GetNumTradeSkills()
	end
	debug("Validity:", isValidTradeSkill, TSM.mode, currentTradeSkillName)
	
	local isHighest = true
	for player, num in pairs(TSM.db.profile.playerProfessionInfo[TSM.mode]) do
		if player ~= playerName and num > GetNumTradeSkills() then
			isHighest = false
		end
	end
	
	debug(isHighest, #craftsToRemove, #matsToRemove)
	
	if isHighest then
		for i=1, #craftsToRemove do
			TSM.Data[TSM.mode].crafts[craftsToRemove[i]] = nil
		end
		
		for i=1, #matsToRemove do
			TSM.Data[TSM.mode].mats[matsToRemove[i]] = nil
		end
	end
end

local newCraftMsg = gsub(ERR_LEARN_RECIPE_S, "%%s", "")
function Data:CHAT_MSG_SYSTEM(_, msg)
	if msg:match(newCraftMsg) then
		for name, data in pairs(TSM.db.profile.lastScan) do
			TSM.db.profile.lastScan[name] = -math.huge
		end
	end
end

function Data:GetCraftingCost(itemID, isMat)
	if not isMat then
		for _, skill in pairs(TSM.tradeSkills) do
			local mode = skill.name
			local craft = Data[mode].crafts[itemID]
			if craft then
				local cost = Data:CalcPrices(craft, mode)
				return cost
			end
		end
	end
	for _, skill in pairs(TSM.tradeSkills) do
		local mode = skill.name
		if Data[mode].mats[itemID] then
			return Data:GetMatCost(mode, itemID)
		end
	end
end
