-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Crafting - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_crafting.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TradeSkillMaster_Crafting", "AceEvent-3.0", "AceConsole-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Crafting") -- loads the localization table
TSM.version = GetAddOnMetadata("TradeSkillMaster_Crafting","X-Curse-Packaged-Version") or GetAddOnMetadata("TradeSkillMaster_Crafting", "Version") -- current version of the addon

local GOLD_TEXT = "|cffffd70fg|r"
local SILVER_TEXT = "|cffb7b7bfs|r"
local COPPER_TEXT = "|cffeda55fc|r"

-- stuff for debugging TSM
function TSM:Debug(...)
	if TSMCRAFTINGDEBUG then
		print(...)
	end
end
local debug = function(...) TSM:Debug(...) end

-- default values for the savedDB
local savedDBDefaults = {
	global = {
		treeStatus = {[2] = true, [5] = true},
		queueSort = "profit",
		queueSortDescending = true,
	},
	-- data that is stored per user profile
	profile = {
		profitPercent = 0, -- percentage to subtract from buyout when calculating profit (5% = AH cut)
		matCostSource = "DBMarket", -- how to calculate the cost of materials
		craftCostSource = "DBMarket",
		craftHistory = {}, -- stores a history of what crafts were crafted
		queueMinProfitGold = {default = 50},
		queueMinProfitPercent = {default = 0.5},
		restockAH = true,
		altAddon = "Gathering",
		altGuilds = {},
		altCharacters = {},
		queueProfitMethod = {default = "gold"},
		doubleClick = 2,
		maxRestockQuantity = {default = 3},
		seenCountFilterSource = "",
		seenCountFilter = 0,
		ignoreSeenCountFilter = {},
		minRestockQuantity = {default = 1},
		limitIlvl = {default = false},
 		minilvlToCraft = {default = 1},
		dontQueue = {},
		craftManagementWindowScale = 1,
		inscriptionGrouping = 2,
		lastScan = {},
		alwaysQueue = {},
		craftSortMethod = {default = "name"},
		craftSortOrder = {default = "ascending"},
		unknownProfitMethod = {default = "unknown"},
		enableNewTradeskills = false,
		showPercentProfit = true,
		tooltip = true,
		playerProfessionInfo = {},
		playerProfessionInfo = {},
 		assumeVendorInBags = false,
 		limitVendorItemPrice = false,
 		maxVendorPrice = 1000,
	},
}

-- Called once the player has loaded WOW.
function TSM:OnEnable()
	TSM.tradeSkills = {{name="Enchanting", spellID=7411}, {name="Inscription", spellID=45357},
		{name="Jewelcrafting", spellID=25229}, {name="Alchemy", spellID=2259},
		{name="Blacksmithing", spellID=2018}, {name="Leatherworking", spellID=2108},
		{name="Tailoring", spellID=3908}, {name="Engineering", spellID=4036},
		{name="Cooking", spellID=2550}}--, {name="Smelting", spellID=2656}}
	
	-- load TradeSkillMaster_Crafting's modules
	TSM.Data = TSM.modules.Data
	TSM.Scan = TSM.modules.Scan
	TSM.GUI = TSM.modules.GUI
	TSM.Crafting = TSM.modules.Crafting
	
	-- load all the profession modules
	for _, data in ipairs(TSM.tradeSkills) do
		TSM[data.name] = TSM.modules[data.name]
	end
	
	-- load the savedDB into TSM.db
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_CraftingDB", savedDBDefaults, true)
	TSM.Data:Initialize() -- setup TradeSkillMaster_Crafting's internal data table using some savedDB data
	
	TSMAPI:RegisterModule("TradeSkillMaster_Crafting", TSM.version, GetAddOnMetadata("TradeSkillMaster_Crafting", "Author"),
		GetAddOnMetadata("TradeSkillMaster_Crafting", "Notes"))
	TSMAPI:RegisterData("shopping", function(_, mode) return TSM.Data:GetShoppingData(mode or "shopping") end)
	TSMAPI:RegisterData("craftingcost", function(_, itemID, isMat) return TSM.Data:GetCraftingCost(itemID, isMat) end)
	
	if TSM.db.profile.tooltip then
		TSMAPI:RegisterTooltip("TradeSkillMaster_Crafting", function(...) return TSM:LoadTooltip(...) end)
	end
	
	TSMAPI:CreateTimeDelay("crafting_test", 1, TSM.Check)
end

local GREEN = "|cff00ff00"
local RED = "|cffff0000"
function TSM:LoadTooltip(itemID)
	for _, profession in pairs(TSM.tradeSkills) do
		if TSM.Data[profession.name].crafts[itemID] then
			local cost,_,profit = TSM.Data:CalcPrices(TSM.Data[profession.name].crafts[itemID], profession.name)
			
			local preProfitText = ""
			if profit and profit <= 0 then
				preProfitText = "-"
				profit = abs(profit)
			end
			local costText = TSM:FormatTextMoney(cost, nil, true, true) or "|cffffffff---|r"
			local profitText = preProfitText..(TSM:FormatTextMoney(profit, nil, true, true) or "|cffffffff---|r")
			local text1 = format(L["Crafting Cost: %s (%s profit)"], costText, profitText)
			
			return {text1}
		end
	end
end

-- converts an itemID into the name of the item.
function TSM:GetNameFromID(itemID)
    if not itemID then return end
	
    if not tonumber(itemID) then return itemID end
	
    local cachedName = TSM:GetNameFromGlobalNameCache(itemID)
    if cachedName then return cachedName end

    local queriedName = GetItemInfo(itemID)
	
    if not queriedName then
        queriedName = TSM:GetNameFromMatsForCurrentMode(itemID)
        queriedName = TSM:GetNameFromCraftsForCurrentMode(itemID)
        if not queriedName and itemID == 38682 and GetLocale() == "enUS" then
            queriedName = "Enchanting Vellum"
        end
    end
    
    if queriedName then
        TSM:StoreNameInGlobalNameCache(itemID, queriedName)
        
        if TSM:GetMatForCurrentMode(itemID) and not TSM:GetMatForCurrentMode(itemID).name then
            TSM:GetMatForCurrentMode(itemID).name = queriedName
        end
        return queriedName
    else
        -- sad face :(
        TSM:Print(format("TradeSkillMaster imploded on itemID %s. This means you have not seen this " ..
            "item since the last patch and TradeSkillMaster_Crafting doesn't have a record of it. Try to find this " ..
            "item in game and then TradeSkillMaster_Crafting again. If you continue to get this error message please " ..
            "report this to the author (include the itemID in your message).", itemID))
    end
end

function TSM:IsEnchant(link)
	if not link then return end
	return strfind(link, "enchant:") and true
end

function TSM:GetMode()
	local mode
	if TSM.Crafting.frame and TSM.Crafting.frame:IsVisible() then
		mode = TSM.Crafting.mode or TSM.mode
	else
		mode = TSM.mode
	end
	
	return mode
end

function TSM:GetNameFromGlobalNameCache(sID)
	if TSM.db.global[sID] then -- check to see if we have the name stored already in the saved DB
		if TSM.db.global[sID] == "Armor Vellum" then
			TSM.db.global[sID] = "Enchanting Vellum"
		end
		return TSM.db.global[sID]
	end
end
   
function TSM:StoreNameInGlobalNameCache(itemID, queriedName)
	TSM.db.global[itemID] = queriedName
end

function TSM:GetNameFromMatsForCurrentMode(itemID)
	local mode = TSM:GetMode()
	if TSM.Data[mode].mats[itemID] then
		return TSM.Data[mode].mats[itemID].name
	end
end

function TSM:GetNameFromCraftsForCurrentMode(itemID)
	local mode = TSM:GetMode()
	if TSM.Data[mode].crafts[itemID] then
		return TSM.Data[mode].crafts[itemID].name
	end
end

function TSM:GetMatForCurrentMode(itemID)
	local mode = TSM:GetMode()
	return TSM.Data[mode].mats[itemID]
end

local vendorMats = {[2324]=0.0025, [2325]=0.1, [6260]=0.005, [2320]=0.001, [38426]=3, [2321]=0.001, [4340]=0.035, [2605]=0.001,
		[8343]=0.2, [6261]=0.01, [10290]=0.25, [4342]=0.25, [2604]=0.005, [14341]=0.5, [4291]=0.05, [4341]=0.05, [38682] = 0.1,
		[39354]=0.0015, [10648]=0.01, [39501]=0.12, [39502]=0.5, [3371]=0.01, [3466]=0.2, [2880]=0.01, [44835]=0.001, [62786]=0.1,
		[62788]=0.1, [58274]=1.1, [17194]=0.001, [17196]=0.005, [44853]=0.0025, [2678]=0.001, [62787]=0.1, [30817]=0.0025,
		[34412]=0.1, [58278]=1.6, [35949]=0.85, [17020]=0.1, [10647]=0.2, [39684]=0.9, [4400]=0.2, [4470]=0.0038, [11291]=0.45,
		[40533]=5, [4399]=0.02, [52188]=1.5, [4289]=0.005, [67348]=34.5804}

function TSM:GetVendorPrice(itemID)
	return vendorMats[itemID] and floor(vendorMats[itemID]*COPPER_PER_GOLD)
end

function TSM:GetDBValue(key, profession, itemID)
	return (itemID and TSM.db.profile[key][itemID]) or (profession and TSM.db.profile[key][profession]) or TSM.db.profile[key].default
end

local equivItems = {
	{lower=10938, upper=10939, ratio=3}, -- Lesser/Greater Magic Essence
	{lower=10998, upper=11082, ratio=3}, -- Lesser/Greater Astral Essence
	{lower=11134, upper=11135, ratio=3}, -- Lesser/Greater Mystic Essence
	{lower=11174, upper=11175, ratio=3}, -- Lesser/Greater Nether Essence
	{lower=16202, upper=16203, ratio=3}, -- Lesser/Greater Eternal Essence
	{lower=22447, upper=22446, ratio=3}, -- Lesser/Greater Planar Essence
	{lower=34056, upper=34055, ratio=3}, -- Lesser/Greater Cosmic Essence
	{lower=52718, upper=52719, ratio=3}, -- Lesser/Greater Celestial Essence
	{lower=37700, upper=36523, ratio=10}, -- Crystallized/Eternal Air
	{lower=37701, upper=35624, ratio=10}, -- Crystallized/Eternal Earth
	{lower=37702, upper=36860, ratio=10}, -- Crystallized/Eternal Fire
	{lower=37703, upper=35627, ratio=10}, -- Crystallized/Eternal Shadow
	{lower=37704, upper=35625, ratio=10}, -- Crystallized/Eternal Life
	{lower=37705, upper=35622, ratio=10}, -- Crystallized/Eternal Water
}
function TSM:GetEquivItem(itemID)
	for _, itemPair in ipairs(equivItems) do
		if itemID == itemPair.lower then
			return itemPair.upper, TSMAPI:SafeDivide(1, itemPair.ratio)
		elseif itemID == itemPair.upper then
			return itemPair.lower, itemPair.ratio
		end
	end
end

local vendorTrades = {
	[37101] = {itemID=61978, quantity=1}, -- Ivory Ink
	[39469] = {itemID=61978, quantity=1}, -- Moonglow Ink
	[39774] = {itemID=61978, quantity=1}, -- Midnight Ink
	[43116] = {itemID=61978, quantity=1}, -- Lion's Ink
	[43118] = {itemID=61978, quantity=1}, -- Jadefire Ink
	[43120] = {itemID=61978, quantity=1}, -- Celestial Ink
	[43122] = {itemID=61978, quantity=1}, -- Shimmering Ink
	[43124] = {itemID=61978, quantity=1}, -- Ethereal Ink
	[43126] = {itemID=61978, quantity=1}, -- Ink of the Sea
	[61981] = {itemID=61978, quantity=10}, -- Inferno Ink
	[43127] = {itemID=61978, quantity=10}, -- snowfall ink
}

function TSM:GetItemVendorTrade(matID)
	if vendorTrades[matID] then
		return vendorTrades[matID].itemID, vendorTrades[matID].quantity
	end
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

local BIG_NUMBER = 100000000000 -- 10 million gold
function TSM:FormatTextMoney(copper, textColor, noCopper, noSilver, noColor)
	if not copper then return end
	if copper == 0 or copper > BIG_NUMBER then return end
	
	local gold = floor(copper / COPPER_PER_GOLD)
	local silver = floor((copper - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = floor(math.fmod(copper, COPPER_PER_SILVER))
	local text = ""
	
	-- Add gold
	if gold > 0 then
		if noColor then
			text = format("%s", gold.."g")
		elseif textColor then
			text = format("%s%s", textColor..gold.."|r", (noColor and "g" or GOLD_TEXT).." ")
		else
			text = format("%s%s", gold, (noColor and "g" or GOLD_TEXT).." ")
		end
	end
	
	-- Add silver
	if (not noSilver or gold == 0) and (silver > 0 or copper > 0) then
		if noColor then
			text = format("%s%s", text, silver.."s")
		elseif textColor then
			text = format("%s%s%s", text, textColor..silver.."|r", (noColor and "s" or SILVER_TEXT).." ")
		else
			text = format("%s%s%s", text, silver, (noColor and "s" or SILVER_TEXT).." ")
		end
	end
	
	-- Add copper if we have no silver/gold found, or if we actually have copper
	if (not noCopper or (silver == 0 and gold==0)) and (text == "" or copper > 0) then
		if noColor then
			text = format("%s%s", text, copper.."c")
		elseif textColor then
			text = format("%s%s%s", text, textColor..copper.."|r", (noColor and "c" or COPPER_TEXT))
		else
			text = format("%s%s%s", text, copper, (noColor and "c" or COPPER_TEXT))
		end
	end
	
	return text:trim()
end

function TSM:GetMoneyValue(value)
	local gold = tonumber(string.match(value, "([0-9]+)|c([0-9a-fA-F]+)g|r") or string.match(value, "([0-9]+)g")) or 0
	local silver = tonumber(string.match(value, "([0-9]+)|c([0-9a-fA-F]+)s|r") or string.match(value, "([0-9]+)s")) or 0
	local copper = tonumber(string.match(value, "([0-9]+)|c([0-9a-fA-F]+)c|r") or string.match(value, "([0-9]+)c")) or 0
	
	return (gold or silver or copper) and (gold*COPPER_PER_GOLD + silver*SILVER_PER_GOLD + copper)
end



-- CRAFTING SPECIFIC API FUNCTIONS --

-- Clears the queue for the passed tradeskill (not case sensitive)
-- Will refresh the craft management window if it's open
-- Returns true if successful
-- Returns nil followed by an error message if not successful (two return values)
function TSMAPI:ClearQueue(tradeskill)
	if type(tradeskill) ~= "string" then
		return nil, "Invalid Tradeskill Type"
	end
	
	local valid = false
	
	for _, skill in ipairs(TSM.tradeSkills) do
		if strlower(skill.name) == strlower(tradeskill) or strlower(tradeskill) == "all" then
			for _, data in pairs(TSM.Data[skill.name].crafts) do
				data.queued = 0
				data.intermediateQueued = nil
			end
			valid = true
		end
	end
	
	if not valid then return nil, "Invalid Tradeskill: "..tradeskill end
	
	if TSM.Crafting.frame:IsVisible() then
		TSM.Crafting:UpdateAllScrollFrames()
	end
	
	return true
end

-- Sets the queued quantity of the specified item to the specified quantity
-- Will refresh the craft management window if it's open unless noUpdate is true - if you are going to call this multiple times in succession, set noUpdate on all but the last call to avoid lagging the user.
-- Accepts either itemIDs or itemLinks
-- Returns true if successful
function TSMAPI:AddItemToQueue(itemID, quantity, noUpdate)
	itemID = TSMAPI:GetItemID(itemID) or itemID
	if type(itemID) ~= "number" then return nil, "invalid itemID/itemLink" end
	if type(quantity) ~= "number" then return nil, "invalid quantity" end
	
	for _, skill in ipairs(TSM.tradeSkills) do
		if TSM.Data[skill.name].crafts[itemID] then
			TSM.Data[skill.name].crafts[itemID].queued = quantity
			break
		end
	end
	
	if TSM.Crafting.frame:IsVisible() and not noUpdate then
		TSM.Crafting:UpdateAllScrollFrames()
	end
	
	return true
end

-- Gets data for the specified tradeskill
-- Returns nil if not successful followed by an error message (two return values)
-- Returns a list of all crafts added to Crafting for the tradeskill. Each craft is a list with the following properties:

--[[
{
	itemID=#####, --itemID of Crafted Item
	spellID=#####, --spellID of spell to craft this item
	mats={matItemID1=matQuantity1, matItemID2=matQuantity2, ...}, -- mats for this craft
	queued=#, -- how many are queued
	enabled=true/false, -- if it is enabled (will show up in the craft management window)
	intermediateQueued=#, -- how many are queued as an intermediate craft
	group=#, -- number of the group this item is in
	name="name" -- name of the crafted item
}
--]]
function TSMAPI:GetTradeSkillData(tradeskill)
	if not tradeskill then return end
	
	if not TSM.data[tradeskill] then
		for _, skill in ipairs(TSM.tradeSkills) do
			if strlower(skill.name) == strlower(tradeskill) then
				tradeskill = skill.name
				break
			end
		end
	end
	
	if not (TSM.data[tradeskill] and TSM.data[tradeskill].crafts) then return end
	
	local results = {}
	for itemID, data in pairs(TSM.Data[tradeskill].crafts) do
		local temp = CopyTable(data)
		temp.itemID = itemID
		tinsert(results, temp)
	end
	
	return results
end
