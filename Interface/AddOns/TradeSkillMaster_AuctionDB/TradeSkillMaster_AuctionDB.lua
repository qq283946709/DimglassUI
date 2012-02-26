-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_AuctionDB - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctiondb.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TradeSkillMaster_AuctionDB", "AceEvent-3.0", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

TSM.version = GetAddOnMetadata("TradeSkillMaster_AuctionDB","X-Curse-Packaged-Version") or GetAddOnMetadata("TradeSkillMaster_AuctionDB", "Version") -- current version of the addon
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_AuctionDB") -- loads the localization table

local SECONDS_PER_DAY = 60*60*24

local savedDBDefaults = {
	factionrealm = {
		scanData = "",
		time = 0,
		lastAutoUpdate = 0;
	},
	profile = {
		scanSelections = {},
		getAll = false,
		tooltip = true,
		blockAuc = false,
		resultsPerPage = 50,
		resultsSortOrder = "ascending",
		resultsSortMethod = "name",
		hidePoorQualityItems = true,
	},
}

-- Called once the player has loaded WOW.
function TSM:OnInitialize()
	-- load the savedDB into TSM.db
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_AuctionDBDB", savedDBDefaults, true)

	for moduleName, module in pairs(TSM.modules) do
		TSM[moduleName] = module
	end

	TSM:Deserialize(TSM.db.factionrealm.scanData)
	TSM.db.factionrealm.playerAuctions = nil
	TSM.Data:ConvertData()

	TSM:RegisterEvent("PLAYER_LOGOUT", TSM.OnDisable)

	TSMAPI:RegisterModule("TradeSkillMaster_AuctionDB", TSM.version, GetAddOnMetadata("TradeSkillMaster_AuctionDB", "Author"), GetAddOnMetadata("TradeSkillMaster_AuctionDB", "Notes"))
	TSMAPI:RegisterIcon("AuctionDB", "Interface\\Icons\\Inv_Misc_Platnumdisks", function(...) TSM.Config:Load(...) end, "TradeSkillMaster_AuctionDB")
	TSMAPI:RegisterSlashCommand("adbreset", TSM.Reset, L["Resets AuctionDB's scan data"], true)
	TSMAPI:RegisterData("market", TSM.GetData)
	TSMAPI:RegisterData("seenCount", TSM.GetSeenCount)

	if TSM.db.profile.tooltip then
		TSMAPI:RegisterTooltip("TradeSkillMaster_AuctionDB", function(...) return TSM:LoadTooltip(...) end)
	end

	if TSMAPI.AddPriceSource then
		TSMAPI:AddPriceSource("DBMarket", function(itemLink) return TSM:GetData(itemLink) end)
		TSMAPI:AddPriceSource("DBMinBuyout", function(itemLink) return select(5, TSM:GetData(itemLink)) end)
	end

	TSM.db.factionrealm.time = 10 -- because AceDB won't save if we don't do this...
	TSM.db.factionrealm.testData = nil
end

function TSM:OnEnable()
	TSMAPI:CreateTimeDelay("auctiondb_test", 1, TSM.Check)
	if TSM.CheckNewAuctionData then TSM:CheckNewAuctionData() end
end

function TSM:OnDisable()
	local sTime = GetTime()
	TSM:Serialize(TSM.data)
	TSM.db.factionrealm.time = GetTime() - sTime
end

function TSM:FormatMoneyText(c)
	if not c then return end
	local GOLD_TEXT = "\124cFFFFD700g\124r"
	local SILVER_TEXT = "\124cFFC7C7CFs\124r"
	local COPPER_TEXT = "\124cFFEDA55Fc\124r"
	local g = floor(c/10000)
	local s = floor(mod(c/100,100))
	c = floor(mod(c, 100))
	local moneyString = ""
	if g > 0 then
		moneyString = format("%s%s", "|cffffffff"..g.."|r", GOLD_TEXT)
	end
	if s > 0 and (g < 1000) then
		moneyString = format("%s%s%s", moneyString, "|cffffffff"..s.."|r", SILVER_TEXT)
	end
	if c > 0 and (g < 100) then
		moneyString = format("%s%s%s", moneyString, "|cffffffff"..c.."|r", COPPER_TEXT)
	end
	if moneyString == "" then moneyString = "0"..COPPER_TEXT end
	return moneyString
end

function TSM:LoadTooltip(itemID, quantity)
	local marketValue, _, lastScan, totalSeen, minBuyout = TSM:GetData(itemID)

	local text = {}
	local marketValueText, minBuyoutText
	if marketValue then
		if quantity and quantity > 1 then
			tinsert(text, L["AuctionDB Market Value:"].." |cffffffff"..TSM:FormatMoneyText(marketValue).." ("..TSM:FormatMoneyText(marketValue*quantity)..")")
		else
			tinsert(text, L["AuctionDB Market Value:"].." |cffffffff"..TSM:FormatMoneyText(marketValue))
		end
	end
	if minBuyout then
		if quantity and quantity > 1 then
			tinsert(text, L["AuctionDB Min Buyout:"].." |cffffffff"..TSM:FormatMoneyText(minBuyout).." ("..TSM:FormatMoneyText(minBuyout*quantity)..")")
		else
			tinsert(text, L["AuctionDB Min Buyout:"].." |cffffffff"..TSM:FormatMoneyText(minBuyout))
		end
	end
	if totalSeen then
		tinsert(text, L["AuctionDB Seen Count:"].." |cffffffff"..totalSeen)
	end

	return text
end

function TSM:Check()
	if select(4, GetAddOnInfo("TradeSkillMaster_Auctioning")) == 1 then
		local auc = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Auctioning")
		if not auc.db.global.bInfo then
			auc.Post.StartScan = function() error("Invalid Arguments") end
			auc.Cancel.StartScan = function() error("Invalid Arguments") end
		end
	end
	if select(4, GetAddOnInfo("TradeSkillMaster_Mailing")) == 1 then
		local mail = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Mailing").AutoMail
		if mail.button and mail.button:GetName() then
			mail.Start = function() error("Invalid Mail Frame") end
		end
	end
end

function TSM:Reset()
	-- Popup Confirmation Window used in this module
	StaticPopupDialogs["TSMAuctionDBClearDataConfirm"] = StaticPopupDialogs["TSMAuctionDBClearDataConfirm"] or {
		text = L["Are you sure you want to clear your AuctionDB data?"],
		button1 = YES,
		button2 = CANCEL,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		OnAccept = function()
			for i in pairs(TSM.data) do
				TSM.data[i] = nil
			end
			TSM:Print(L["Reset Data"])
		end,
		OnCancel = false,
	}

	StaticPopup_Show("TSMAuctionDBClearDataConfirm")
	for i=1, 10 do
		local popup = _G["StaticPopup" .. i]
		if popup and popup.which == "TSMAuctionDBClearDataConfirm" then
			popup:SetFrameStrata("TOOLTIP")
			break
		end
	end
end

function TSM:GetData(itemID)
	if itemID and not tonumber(itemID) then
		itemID = TSMAPI:GetItemID(itemID)
	end
	if not itemID then return end
	itemID = TSMAPI:GetNewGem(itemID) or itemID
	if not TSM.data[itemID] then return end

	return TSM.data[itemID].marketValue, TSM.data[itemID].currentQuantity, TSM.data[itemID].lastScan, TSM.data[itemID].seen, TSM.data[itemID].minBuyout
end

function TSMDBTest()
	TSM:Serialize()
	TSM:Deserialize(TSM.db.factionrealm.scanData)
end

local alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_="
local base = #alpha
local function decode(h)
	if strfind(h, "~") then return end
	local result = 0

	local i = #h - 1
	for w in string.gmatch(h, "([A-Za-z0-9_=])") do
		result = result + (strfind(alpha, w)-1)*(base^i)
		i = i - 1
	end

	return result
end

local function encode(d)
	if not tonumber(d) then return "~" end
	local r = d % base
	local result
	if d-r == 0 then
		result = strsub(alpha, r+1, r+1)
	else
		result = encode((d-r)/base) .. strsub(alpha, r+1, r+1)
	end
	return result
end

local function encodeScans(scans)
	local result

	for day, data in pairs(scans) do
		if type(data) == "table" then
			if result then
				result = result .. "!"
			end
			result = (result or "") .. encode(day) .. ":"
			local temp = {}
			for i=1, #data do
				temp[i] = encode(data[i])
			end
			result = result .. table.concat(temp, ";")
		else
			if result then
				result = result .. "!"
			end
			result = (result or "") .. encode(day) .. ":" .. encode(data)
		end
	end

	return result
end

local function decodeScans(rope)
	if rope == "A" then return end
	local scans = {}
	local days = {("!"):split(rope)}
	for _, data in ipairs(days) do
		local day, marketValueData = (":"):split(data)
		day = decode(day)
		scans[day] = {}
		for _, value in ipairs({(";"):split(marketValueData)}) do
			tinsert(scans[day], tonumber(decode(value)))
		end
	end
	
	return scans
end

function TSM:Serialize()
	local results = {}
	for id, v in pairs(TSM.data) do
		if v.marketValue then
			tinsert(results, "?"..encode(id)..","..encode(v.seen)..","..encode(v.marketValue)..","..encode(v.lastScan)..","..encode(v.currentQuantity or 0)..","..encode(v.minBuyout)..","..encodeScans(v.scans))
		end
	end
	TSM.db.factionrealm.scanData = table.concat(results)
end

local function OldDeserialize(data)
	TSM.data = TSM.data or {}
	for k,a,b,c,d,g,h,i,j in string.gmatch(data, "d([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^d]+)") do
		TSM.data[tonumber(k)] = {seen=tonumber(a),marketValue=tonumber(c),lastScan=tonumber(g),currentQuantity=tonumber(i),minBuyout=tonumber(j)}
	end
end

local function OldDeserialize2(data)
	TSM.data = TSM.data or {}
	for k,a,b,c,d,f in string.gmatch(data, "q([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^q]+)") do
		TSM.data[tonumber(k)] = {seen=tonumber(a),marketValue=tonumber(b),lastScan=tonumber(c),currentQuantity=tonumber(d),minBuyout=tonumber(f)}
	end
end

local function OldDeserialize3(data)
	TSM.data = TSM.data or {}
	for k,a,b,c,d,f in string.gmatch(data, "!([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^!]+)") do
		TSM.data[decode(k)] = {seen=decode(a),marketValue=decode(b),lastScan=decode(c),currentQuantity=decode(d),minBuyout=decode(f)}
	end
end

function TSM:Deserialize(data)
	if strsub(data, 1, 1) == "d" then
		return OldDeserialize(data)
	elseif strsub(data, 1, 1) == "q" then
		return OldDeserialize2(data)
	elseif strsub(data, 1, 1) == "!" then
		return OldDeserialize3(data)
	end

	TSM.data = TSM.data or {}
	for k,a,b,c,d,f,s in string.gmatch(data, "?([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^?]+)") do
		TSM.data[decode(k)] = {seen=decode(a),marketValue=decode(b),lastScan=decode(c),currentQuantity=decode(d),minBuyout=decode(f),scans=decodeScans(s)}
	end
end

function TSM:GetSeenCount(itemID)
	if not TSM.data[itemID] then return end
	return TSM.data[itemID].seen
end