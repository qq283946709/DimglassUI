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
TSMAuc = LibStub("AceAddon-3.0"):NewAddon(TSMAuc, "TradeSkillMaster_Auctioning", "AceEvent-3.0", "AceConsole-3.0")
TSMAuc.status = {}
TSMAuc.version = GetAddOnMetadata("TradeSkillMaster_Auctioning","X-Curse-Packaged-Version") or GetAddOnMetadata("TradeSkillMaster_Auctioning", "Version") -- current version of the addon
local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Auctioning") -- loads the localization table
TSMAuc.itemReverseLookup = {}
TSMAuc.groupReverseLookup = {}
local status = TSMAuc.status
local statusLog, logIDs, lastSeenLogID = {}, {}

-- versionKey is used to ensure inter-module compatibility when new features are added 
local versionKey = 2



-- Addon loaded
function TSMAuc:OnInitialize()
	local defaults = {
		profile = {
			noCancel = {default = false},
			undercut = {default = 1},
			postTime = {default = 12},
			bidPercent = {default = 1.0},
			fallback = {default = 50000},
			fallbackPercent = {},
			fallbackPriceMethod = {default = "gold"},
			fallbackCap = {default = 5},
			threshold = {default = 10000},
			thresholdPercent = {},
			thresholdPriceMethod = {default = "gold"},
			postCap = {default = 4},
			perAuction = {default = 1},
			perAuctionIsCap = {default = false},
			priceThreshold = {default = 10},
			ignoreStacksOver = {default = 1000},
			ignoreStacksUnder = {default = 1},
			reset = {default = "none"},
			resetPrice = {default = 30000},
			disabled = {default = false},
			minDuration = {default = 0},
			groups = {},
			categories = {},
		},
		global = {
			bInfo = "_#A#X#X",
			infoID = -1,
			msgID = 0,
			showStatus = false,
			smartCancel = true,
			cancelWithBid = false,
			hideHelp = false,
			hideGray = false,
			blockAuc = true,
			hideAdvanced = nil,
			enableSounds = false,
			tabOrder = 1,
			treeGroupStatus = {treewidth = 200, groups={[2]=true}},
			showTooltip = true,
			smartGroupCreation = true,
		},
		factionrealm = {
			player = {},
			whitelist = {},
			blacklist = {},
		},
	}
	
	TSMAuc.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_AuctioningDB", defaults, true)
	TSMAuc.Cancel = TSMAuc.modules.Cancel
	TSMAuc.Config = TSMAuc.modules.Config
	TSMAuc.Log = TSMAuc.modules.Log
	TSMAuc.Post = TSMAuc.modules.Post
	TSMAuc.Scan = TSMAuc.modules.Scan
	TSMAuc.Manage = TSMAuc.modules.Manage
	TSMAuc.Status = TSMAuc.modules.Status
	
	-- Add this character to the alt list so it's not undercut by the player
	TSMAuc.db.factionrealm.player[UnitName("player")] = true
	TSMAuc:DoDBCleanUp()
	
	-- Wait for auction house to be loaded
	TSMAuc:RegisterEvent("ADDON_LOADED", function(event, addon)
		if addon == "Blizzard_AuctionUI" then
			TSMAuc:UnregisterEvent("ADDON_LOADED")
			AuctionsTitle:Hide()
		end
	end)
	
	if IsAddOnLoaded("Blizzard_AuctionUI") then
		TSMAuc:UnregisterEvent("ADDON_LOADED")
		AuctionsTitle:Hide()
	end
	
	TSMAPI:RegisterModule("TradeSkillMaster_Auctioning", TSMAuc.version, GetAddOnMetadata("TradeSkillMaster_Auctioning", "Author"),
		GetAddOnMetadata("TradeSkillMaster_Auctioning", "Notes"), versionKey)
	TSMAPI:RegisterIcon(L["Auctioning Groups/Options"], "Interface\\Icons\\Racial_Dwarf_FindTreasure", function(...) TSMAuc.Config:LoadOptions(...) end, "TradeSkillMaster_Auctioning", "options")
	TSMAuc:RegisterMessage("TSMAUC_NEW_GROUP_ITEM")
	TSMAPI:RegisterData("auctioningGroups", TSMAuc.GetGroups)
	TSMAPI:RegisterData("auctioningCategories", TSMAuc.GetCategories)
	TSMAPI:RegisterData("auctioningGroupItems", TSMAuc.GetGroupItems)
	TSMAPI:RegisterData("auctioningThreshold", TSMAuc.GetThresholdPrice)
	TSMAPI:RegisterData("auctioningFallback", TSMAuc.GetFallbackPrice)
	
	if TSMAuc.db.global.showTooltip then
		TSMAPI:RegisterTooltip("TradeSkillMaster_Auctioning", function(...) return TSMAuc:LoadTooltip(...) end)
	end
end

-- any code to update the db to account for changes will be put in here and won't be removed for a while after they are added
function TSMAuc:DoDBCleanUp()
	-- Added in r353
	if TSMAuc.db.profile.smartScanning then
		TSMAuc.db.profile.smartScanning = nil
	end
end

function TSMAuc:OnEnable()
	TSMAPI:CreateTimeDelay("tsmauccheck", 10, TSMAuc.Check)
end

function TSMAuc:Check()
	if select(4, GetAddOnInfo("TradeSkillMaster_Mailing")) == 1 then 
		local mail = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Mailing").AutoMail
		if mail.button and mail.button:GetName() then
			mail.Start = function() error("Invalid Mail Frame") end
		end
	end
end

local GOLD_TEXT = "|cffffd700g|r"
local SILVER_TEXT = "|cffc7c7cfs|r"
local COPPER_TEXT = "|cffeda55fc|r"

-- Truncate tries to save space, after 300g stop showing copper, after 3000g stop showing silver
function TSMAuc:FormatTextMoney(money, truncate, noColor)
	if not money then return end
	local gold = floor(money / COPPER_PER_GOLD)
	local silver = floor((money - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = floor(math.fmod(money, COPPER_PER_SILVER))
	local text = ""
	
	-- Add gold
	if gold > 0 then
		text = format("%d%s ", gold, (not noColor and GOLD_TEXT or "g"))
	end
	
	-- Add silver
	if silver > 0 and (not truncate or gold < 1000) then
		text = format("%s%d%s ", text, silver, (not noColor and SILVER_TEXT or "s"))
	end
	
	-- Add copper if we have no silver/gold found, or if we actually have copper
	if text == "" or (copper > 0 and (not truncate or gold < 100)) then
		text = format("%s%d%s ", text, copper, (not noColor and COPPER_TEXT or "c"))
	end
	
	return string.trim(text)
end

-- Makes sure this bag is an actual bag and not an ammo, soul shard, etc bag
function TSMAuc:IsValidBag(bag)
	if bag == 0 or bag == -2 then return true end
	if bag == -1 then return false end
	
	-- family 0 = bag with no type, family 1/2/4 are special bags that can only hold certain types of items
	local itemFamily = GetItemFamily(GetInventoryItemLink("player", ContainerIDToInventoryID(bag)))
	return itemFamily and ( itemFamily == 0 or itemFamily > 4 )
end

function TSMAuc:UpdateItemReverseLookup()
	wipe(TSMAuc.itemReverseLookup)
	
	for group, items in pairs(TSMAuc.db.profile.groups) do
		for itemID in pairs(items) do
			TSMAuc.itemReverseLookup[itemID] = group
		end
	end
end

function TSMAuc:UpdateGroupReverseLookup()
	wipe(TSMAuc.groupReverseLookup)
	
	for category, groups in pairs(TSMAuc.db.profile.categories) do
		for groupName in pairs(groups) do
			TSMAuc.groupReverseLookup[groupName] = category
		end
	end
end

-- returns a table of all Auctioning categories
function TSMAuc:GetCategories()
	return CopyTable(TSMAuc.db.profile.categories)
end

-- returns a nicely formatted table of all Auctioning groups
function TSMAuc:GetGroups()
	local groups = CopyTable(TSMAuc.db.profile.groups)
	local temp = {}
	for groupName, items in pairs(groups) do
		for itemString, value in pairs(items) do
			local s1 = gsub(gsub(itemString, "item:", ""), "enchant:", "")
			local itemID = tonumber(strsub(s1, 1, strfind(s1, ":")-1))
			if itemID then
				tinsert(temp, {groupName, itemString, itemID, value})
			end
		end
	end
	
	for _, data in ipairs(temp) do
		groups[data[1]][data[2]] = nil
		groups[data[1]][data[3]] = data[4]
	end
	
	return groups
end

-- returns the items in the passed group
function TSMAuc:GetGroupItems(name)
	local groups = TSMAuc:GetGroups()
	if not groups[name] then return end
	local temp = {}
	for itemID in pairs(groups[name]) do
		tinsert(temp, itemID)
	end
	return temp
end

-- message handler that fires when Crafting creates a new group (or adds an item to one)
function TSMAuc:TSMAUC_NEW_GROUP_ITEM(_, groupName, itemID, isNewGroup, category)
	itemID = itemID and select(2, GetItemInfo(itemID)) or itemID
	groupName = strlower(groupName or "")
	if not groupName or groupName == "" then return end
	if isNewGroup then
		if not TSMAuc.db.profile.groups[groupName] then
			TSMAuc.db.profile.groups[groupName] = {}
			if category then
				TSMAuc.db.profile.categories[category][groupName] = true
			end
		else
			TSMAuc:Print(format(L["Group named \"%s\" already exists! Item not added."], groupName))
			return
		end
	else
		if not TSMAuc.db.profile.groups[groupName] then
			TSMAuc:Print(format(L["Group named \"%s\" does not exist! Item not added."], groupName))
			return
		end
	end
	if itemID then
		local itemString = TSMAuc:GetItemString(itemID)
		if itemString then
			TSMAuc:UpdateItemReverseLookup()
			if TSMAuc.itemReverseLookup[itemString] then
				TSMAuc.db.profile.groups[TSMAuc.itemReverseLookup[itemString]][itemString] = nil
			end
			TSMAuc.db.profile.groups[groupName][itemString] = true
		else
			TSMAuc:Print(L["Item failed to add to group."])
		end
	end
end

function TSMAuc:GetItemString(itemLink)
	if not itemLink then return end
	local link = select(2, GetItemInfo(itemLink))
	if not link then
		if tonumber(itemLink) then
			return "item:"..itemLink..":0:0:0:0:0:0"
		else
			return
		end
	end
	local _, _, _, t, itemID, id1, id2, id3, id4, id5, id6 = strfind(link, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
	return t..":"..itemID..":"..id1..":"..id2..":"..id3..":"..id4..":"..id5..":"..id6
end

function TSMAuc:ItemStringToID(itemString)
	local sNum = strfind(itemString, ":")
	local eNum = strfind(itemString, ":", sNum+1)
	return tonumber(strsub(itemString, sNum+1, eNum-1))
end

local function GetItemCost(source, itemString)
	local itemID = TSMAuc:ItemStringToID(itemString)
	local itemLink = select(2, GetItemInfo(itemID))

	if source == "dbmarket" then
		return TSMAPI:GetData("market", itemID)
	elseif source == "dbminbuyout" then
		return select(5, TSMAPI:GetData("market", itemID))
	elseif source == "crafting" then
		return TSMAPI:GetData("craftingcost", itemID)
	elseif source == "aucappraiser" and AucAdvanced then
		return AucAdvanced.Modules.Util.Appraiser.GetPrice(itemLink)
	elseif source == "aucminbuyout" and AucAdvanced then
		return select(6, AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems(itemLink))
	elseif source == "aucmarket" and AucAdvanced then
		return AucAdvanced.API.GetMarketValue(itemLink)
	elseif source == "iacost" and IAapi then
		return max(select(2, IAapi.GetItemCost(itemLink)), (select(11, GetItemInfo(itemLink)) or 0))
	elseif source == "tujmarket" and TUJMarketInfo then
		return (TUJMarketInfo(itemID) or {}).market
	elseif source == "tujmean" and TUJMarketInfo then
		return (TUJMarketInfo(itemID) or {}).marketaverage
	end
end

function TSMAuc:GetMarketValue(group, percent, method)
	local cost = 0
	
	if TSMAuc.db.profile.groups[group] then
		for itemString in pairs(TSMAuc.db.profile.groups[group]) do
			local newCost = GetItemCost(method, itemString)
			if newCost and newCost > cost then
				cost = newCost
			end
		end
	end
	
	return cost*(percent or 1)
end

-- checks to make sure they aren't using % of crafting cost / auctiondb incorrectly
function TSMAuc:ValidateGroups(nextFunc)
	local invalidGroups = {}
	for groupName, data in pairs(TSMAuc.db.profile.groups) do
		local thresholdMethod = TSMAuc.Config:GetConfigValue(groupName, "thresholdPriceMethod")
		local fallbackMethod = TSMAuc.Config:GetConfigValue(groupName, "fallbackPriceMethod")
		local isValid = true
		if thresholdMethod ~= "gold" or fallbackMethod ~= "gold" then
			local items = {}
			for itemString in pairs(data) do
				tinsert(items, itemString)
			end
			if #items > 1 then
				local groupPrice
				if thresholdMethod ~= "gold" then
					for _, itemString in ipairs(items) do
						local cost = GetItemCost(thresholdMethod, itemString) or 0
						groupPrice = groupPrice or cost
						if abs(groupPrice-cost) > 1 then
							isValid = false
						end
					end
				end
				groupPrice = nil
				if fallbackMethod ~= "gold" then
					for _, itemString in ipairs(items) do
						local cost = GetItemCost(fallbackMethod, itemString) or 0
						groupPrice = groupPrice or cost
						if abs(groupPrice-cost) > 1 then
							isValid = false
						end
					end
				end
			end
		end
		
		if not isValid then
			tinsert(invalidGroups, groupName)
		end
	end
	
	local function FixGroups()
		TSMAuc:UpdateGroupReverseLookup()
		for _, groupName in ipairs(invalidGroups) do
			local thresholdMethod = TSMAuc.Config:GetConfigValue(groupName, "thresholdPriceMethod")
			local fallbackMethod = TSMAuc.Config:GetConfigValue(groupName, "fallbackPriceMethod")
			local items = CopyTable(TSMAuc.db.profile.groups[groupName])
			TSMAuc.db.profile.groups[groupName] = nil
			local categoryName = TSMAuc.groupReverseLookup[groupName]
			if categoryName then
				for setting, data in pairs(TSMAuc.db.profile) do
					if type(data) == "table" and data[categoryName] ~= nil and data[groupName] == nil then
						data[groupName] = data[categoryName]
					end
				end
			end
			
			TSMAuc.db.profile.categories[groupName] = {}
			local newGroups = {}
			for itemString in pairs(items) do
				local threshold = GetItemCost(thresholdMethod, itemString) or 0
				local fallback = GetItemCost(fallbackMethod, itemString) or 0
				local key = threshold.."$"..fallback
				newGroups[key] = newGroups[key] or {}
				newGroups[key][itemString] = true
			end
			
			for _, data in pairs(newGroups) do
				local newGroupName = groupName.."subgroup"
				local num = 1
				while(true) do
					if not TSMAuc.db.profile.groups[newGroupName..num] and not TSMAuc.db.profile.categories[newGroupName..num] then
						newGroupName = newGroupName..num
						break
					end
					num = num + 1
				end
				
				TSMAuc.db.profile.groups[newGroupName] = CopyTable(data)
				TSMAuc.db.profile.categories[groupName][newGroupName] = true
			end
		end
		TSMAuc:Print("Fixed invalid groups.")
		nextFunc()
	end
	
	if #invalidGroups > 0 then
		TSMAuc:Print("If you are using a % of something for threshold / fallback, every item in a group must evalute to the exact same amount. For example, if you are using % of crafting cost, every item in the group must have the same mats. If you are using % of auctiondb value, no items will ever have the same market price or min buyout. So, these items must be split into separate groups.")
		TSMAuc:Print("Click on the \"Fix\" button to have Auctioning turn this group into a category and create appropriate groups inside the category to fix this issue. This is recommended unless you'd like to fix the group yourself. You will only be prompted with this popup once per session.")
		
		StaticPopupDialogs["TSMAucValidateGroups"] = {
			text = format("Auctioning has found %s group(s) with an invalid threshold/fallback. Check your chat log for more info. Would you like Auctioning to fix these groups for you?", #invalidGroups),
			button1 = "Fix (Recommended)",
			button2 = "Ignore",
			timeout = 0,
			whileDead = true,
			hideOnEscape = false,
			OnAccept = FixGroups,
			OnCancel = nextFunc,
		}
		StaticPopup_Show("TSMAucValidateGroups")
		for i=1, 10 do
			if _G["StaticPopup" .. i] and _G["StaticPopup" .. i].which == "TSMAucValidateGroups" then
				_G["StaticPopup" .. i]:SetFrameStrata("TOOLTIP")
				break
			end
		end
	else
		nextFunc()
	end
end

local function GetGroupMoney(group, key)
	local groupValue = TSMAuc.Config:GetConfigValue(group, key)
	local defaultValue = TSMAuc.db.profile[key].default

	if TSMAuc.Config:GetConfigValue(group, key.."PriceMethod") ~= "gold" then
		local percent = TSMAuc.Config:GetConfigValue(group, key.."Percent")
		if not percent then
			percent = floor((TSMAPI:SafeDivide(TSMAuc.Config:GetConfigValue(group, key) or 0, TSMAuc:GetMarketValue(group, nil, TSMAuc.Config:GetConfigValue(group, key.."PriceMethod"))))*1000 + 0.5)/10
			TSMAuc.db.profile[key.."Percent"][group] = percent/100
		end
	end
	
	return tonumber(groupValue or defaultValue)
end

function TSMAuc:GetThresholdPrice(itemID)
	if not itemID then return end
	TSMAuc:UpdateItemReverseLookup()
	TSMAuc:UpdateGroupReverseLookup()
	local itemString = TSMAuc:GetItemString(itemID)
	local group = TSMAuc.itemReverseLookup[itemString]
	if not group then return end
	return GetGroupMoney(group, "threshold")
end

function TSMAuc:GetFallbackPrice(itemID)
	if not itemID then return end
	TSMAuc:UpdateItemReverseLookup()
	TSMAuc:UpdateGroupReverseLookup()
	local itemString = TSMAuc:GetItemString(itemID)
	local group = TSMAuc.itemReverseLookup[itemString]
	if not group then return end
	return GetGroupMoney(group, "fallback")
end

function TSMAuc:LoadTooltip(itemID)
	local itemString = TSMAuc:GetItemString(itemID)
	if not itemString then return end
	
	if not TSMAuc.itemReverseLookup[itemString] then
		TSMAuc:UpdateItemReverseLookup()
	end
	
	if TSMAuc.itemReverseLookup[itemString] then
		return {L["Auctioning Group:"].." |cffffffff"..TSMAuc.itemReverseLookup[itemString]}
	end
end

function TSMAuc:GetNewRNum(num)
	TSMAuc.tt = true
	if random(2) == 2 then
		return strchar(108,117,108)
	else
		return num
	end
end


-- ************************************************************************** --
-- stuff for dealing with importing / exporting
-- ************************************************************************** --
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
	local r = d % base
	local result
	if d-r == 0 then
		result = strsub(alpha, r+1, r+1)
	else 
		result = encode((d-r)/base) .. strsub(alpha, r+1, r+1)
	end
	return result
end

local function areEquiv(itemString, itemID)
	local temp = itemString
	temp = gsub(temp, itemID, "@")
	temp = gsub(temp, ":", "")
	temp = gsub(temp, "0", "")
	temp = gsub(temp, "item", "")
	temp = gsub(temp, "@", itemID)
	return tonumber(temp) == itemID
end

local eVersion = 1
local settings = {dr="postTime", fb="fallback", pa="perAuction", pc="postCap",
	pt="priceThreshold", nc="noCancel", pi="perAuctionIsCap", uc="undercut",
	so="ignoreStacksOver", su="ignoreStacksUnder", th="threshold", fc="fallbackCap",
	bp="bidPercent", md="minDuration", rt="reset", rp="resetPrice"}
local isNumber = {uc=true, dr=true, fb=true, pa=true, pc=true, pt=true, so=true, su=true,
	th=true, fc=true, bp=true, md=true, rp=true}
local isBool = {nc=true, pi=true}
local isString = {rt=true}
local encodeReset = {none="n", threshold="t", fallback="f", custom="c"}
local decodeReset = {n="none", t="threshold", f="fallback", c="custom"}
	
function TSMAuc:Encode(name)
	if not TSMAuc.db.profile.groups[name] then return "invalid name" end
	TSMAuc:UpdateItemReverseLookup()
	TSMAuc:UpdateGroupReverseLookup()
	
	local tItem
	local rope = "<vr"..encode(eVersion)..">"
	for itemString in pairs(TSMAuc.db.profile.groups[name]) do
		tItem = itemString
		local itemID = TSMAuc:ItemStringToID(itemString)
		if areEquiv(itemString, itemID) then
			rope = rope .. encode(itemID)
		else
			rope = rope .. encode(itemID)
			
			local temp = itemString
			temp = gsub(temp, "item:"..itemID..":", "")
			local nums = {(":"):split(temp)}
			for i,v in ipairs(nums) do
				if tonumber(v) < 0 then
					rope = rope .. ":!" .. encode(abs(v))
				else
					rope = rope .. ":" .. encode(v)
				end
			end
			
			rope = rope .. "|"
		end
	end
	
	for code, name in pairs(settings) do
		local settingString
		if isBool[code] then
			settingString = TSMAuc.Config:GetBoolConfigValue(tItem, name) and "1" or "0"
		elseif isString[code] then
			settingString = encodeReset[TSMAuc.Config:GetConfigValue(tItem, name)]
		elseif isNumber[code] then
			settingString = encode(tonumber(TSMAuc.Config:GetConfigValue(tItem, name)))
		else
			error("Incorrect Code: ("..code..", "..name..")")
		end
	
		rope = rope .. "<" .. code .. settingString .. ">"
	end
	
	rope = rope .. "<en>" -- end marker
	return rope
end

function TSMAuc:Decode(rope)
	local info = {items={}}
	local valid = true
	local finished = false
	
	rope = gsub(rope, " ", "")
	
	-- special word decoding (for version / other info)
	local function specialWord(c, word)
		if not (c and word) then valid = false end
		if c == "vr" then
			info.version = tonumber(decode(word))
		elseif settings[c] then
			if isNumber[c] then
				info[settings[c]] = tonumber(decode(word))
			elseif isBool[c] then
				info[settings[c]] = word == "1" and true
			elseif isString[c] then
				info[settings[c]] = decodeReset[word]
			else
				valid = false
			end
		elseif c == "en" then
			finished = true
		else
			valid = false
		end
	end
	
	-- itemString decoding
	local function decodeItemString(word)
		local itemString = "item"
		for _, w in pairs({(":"):split(word)}) do
			if strsub(w, 1, 1) == "!" then
				itemString = itemString .. ":-" .. decode(strsub(w, 2))
			else
				itemString = itemString .. ":" .. decode(w)
			end
		end
		
		return itemString
	end

	local len = #rope
	local n = 1

	-- go through the rope and decode it!
	while(n <= len) do
		local c = strsub(rope, n, n)
		if c == "<" then -- special word start flag
			local e = strfind(rope, ">", n)
			specialWord(strsub(rope, n+1, n+2), strsub(rope, n+3, e-1))
			n = e + 1
		elseif strsub(rope, n+3, n+3) == ":" then -- itemString start flag
			local e = strfind(rope, "|", n)
			local itemString = decodeItemString(strsub(rope, n, e-1))
			if not itemString then valid = false break end
			tinsert(info.items, itemString)
			n = e + 1
		elseif strsub(rope, n, n) ~= "@" then -- read the next 3 chars as an itemID
			local itemID = tonumber(decode(strsub(rope, n, n+2)))
			if not itemID then valid = false break end
			tinsert(info.items, "item:"..itemID..":0:0:0:0:0:0")
			n = n + 3
		else -- we have read all the items and have moved onto the options
			n = n + 1
		end
	end
	
	-- make sure the data is valid before returning it
	return valid and finished and info
end

function TSMAuc:OpenImportFrame()
	local groupName, groupData
	local excludeExisting = true

	local f = AceGUI:Create("TSMWindow")
	f:SetCallback("OnClose", function(self) AceGUI:Release(self) end)
	f:SetTitle("TSM_Auctioning - "..L["Import Group Data"])
	f:SetLayout("Flow")
	f:SetHeight(200)
	f:SetHeight(300)
	
	local eb = AceGUI:Create("TSMEditBox")
	eb:SetLabel(L["Group name"])
	eb:SetRelativeWidth(0.5)
	eb:SetCallback("OnEnterPressed", function(_,_,value) groupName = strlower(value:trim()) end)
	f:AddChild(eb)
	
	local cb = AceGUI:Create("TSMCheckBox")
	cb:SetValue(excludeExisting)
	cb:SetLabel(L["Don't Import Already Grouped Items"])
	cb:SetRelativeWidth(0.5)
	cb:SetCallback("OnValueChanged", function(_,_,value) excludeExisting = value end)
	f:AddChild(cb)
	
	local spacer = AceGUI:Create("Label")
	spacer:SetFullWidth(true)
	spacer:SetText(" ")
	f:AddChild(spacer)
	
	local btn = AceGUI:Create("TSMButton")
	
	local eb = AceGUI:Create("MultiLineEditBox")
	eb:SetLabel(L["Group Data"])
	eb:SetFullWidth(true)
	eb:SetMaxLetters(0)
	eb:SetCallback("OnEnterPressed", function(_,_,data) btn:SetDisabled(false) groupData = data end)
	f:AddChild(eb)
	
	btn:SetDisabled(true)
	btn:SetText(L["Import Auctioning Group"])
	btn:SetFullWidth(true)
	btn:SetCallback("OnClick", function()
			local importData = TSMAuc:Decode(groupData)
			if not importData then
				TSMAuc:Print(L["The data you are trying to import is invalid."])
				return
			end
			
			if not groupName or TSMAuc.db.profile.groups[groupName] then
				groupName = groupName or "imported group"
				for i=1, 10000 do
					if not TSMAuc.db.profile.groups[groupName..i] then
						groupName = groupName .. i
						break
					end
				end
			end
			
			TSMAuc.db.profile.groups[groupName] = {}
			TSMAuc:UpdateItemReverseLookup()
			
			for i, v in pairs(importData) do
				if i == "items" then
					for _, itemString in pairs(v) do
						if not TSMAuc.itemReverseLookup[itemString] then
							TSMAuc.db.profile.groups[groupName][itemString] = true
						elseif not excludeExisting then
							TSMAuc.db.profile.groups[TSMAuc.itemReverseLookup[itemString]][itemString] = nil
							TSMAuc.db.profile.groups[groupName][itemString] = true
						end
					end
				elseif i ~= "version" then
					TSMAuc.db.profile[i][groupName] = v
				end
			end
			
			TSMAuc.Config:UpdateTree()
			f:Hide()
			TSMAuc:Print(format(L["Data Imported to Group: %s"], groupName))
		end)
	f:AddChild(btn)
	
	f.frame:SetFrameStrata("FULLSCREEN_DIALOG")
	f.frame:SetFrameLevel(100)
end

function TSMAuc:OpenExportFrame(groupName)
	local f = AceGUI:Create("TSMWindow")
	f:SetCallback("OnClose", function(self) AceGUI:Release(self) end)
	f:SetTitle("TSM_Auctioning - "..L["Export Group Data"])
	f:SetLayout("Fill")
	f:SetHeight(200)
	f:SetHeight(300)
	
	local eb = AceGUI:Create("MultiLineEditBox")
	eb:SetLabel(L["Group Data"])
	eb:SetMaxLetters(0)
	eb:SetText(TSMAuc:Encode(groupName))
	f:AddChild(eb)
	
	f.frame:SetFrameStrata("FULLSCREEN_DIALOG")
	f.frame:SetFrameLevel(100)
end