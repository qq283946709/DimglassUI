﻿-----------------------------------------------------------------------
-- Config
-----------------------------------------------------------------------
local Config = {
	["ScanOurself"] = nil, --Scan ourself. // 是否扫描自己的聊天信息
	["ScanFriend"] = nil, --Scan friends. // 是否扫描好友的聊天信息
	["ScanTeam"] = nil, --Scan raid/party members. // 是否扫描队友的聊天信息
	["ScanGuild"] = nil, --Scan guildies. // 是否扫描公会成员的聊天信息
	
	["noprofanityFilter"] = true, --Disable the profanityFilter. // 关闭语言过滤器
	["nojoinleaveChannel"] = true, --Disable the alert joinleaveChannel. // 关闭进出频道提示
	
	["MergeTalentSpec"] = true, --Merge the messages:"You have learned/unlearned..." // 当切换天赋后合并显示“你学会了/忘却了法术…”
	["FilterPetTalentSpec"] = nil, --Filter the messages:"Your pet has learned/unlearned..." // 不显示“你的宠物学会了/忘却了…”
	
	["MergeAchievement"] = true, --Merge the messages:"...has earned the achievement..." // 合并显示获得成就
	["MergeManufacturing"] = true, --Merge the messages:"You has created..." // 合并显示“你制造了…”
	
	["FilterAuctionMSG"] = nil, --Filter the messages:"Auction created/cancelled."// 过滤“已开始拍卖/拍卖取消.”
	["FilterDuelMSG"] = nil, --Filter the messages:"... has defeated/fled from ... in a duel." // 过滤“...在决斗中战胜了...”
	
	["FilterAdvertising"] = true, --Filter the advertising messages. // 过滤广告信息
	["AllowMatchs"] = 2, --How many words can be allowd to use. // 允许的关键字配对个数
	
	["FilterMultiLine"] = true, --Filter the multiple messages. // 过滤多行信息
	["AllowLines"] = 3, --How many lines can be allowd. // 允许的最大行数
	
	["FilterRepeat"] = true, --Filter the repeat messages. // 过滤重复聊天信息
	["RepeatAlike"] = 60, --Set the similarity between the messages. // 设定重复信息相似度
	["RepeatInterval"] = 20, --Set the interval between the messages. // 设定重复信息间隔时间
	["RepeatMaxCache"] = 200, --Set the max cache from the messages. // 设定最多缓存多少条消息
	
	["SafeWords"] = {
		"recruit",
		"dkp",
		"looking",
		"lf[gm]",
		"|cff",
		"raid",
		"recount",
	},
	["DangerWords"] = {
		"平.?.?[台臺]",
		"工.?.?作.?.?室",
		"点.?.?[卡心]",
		"[担擔].?.?保",
		"承.?.?接",
		"手.?.?[工打]",
		"代.?.?[打练刷]",
		"带.?.?[打练刷]",
		"dai.?.?[打练刷]",
		"[打卖售].?.?金",
		"[打卖售].?.?g",
		"[刷扰].?.?屏.?.?见.?.?谅",
		"信.?.?誉",
		"绑定.*上马",
		"上马.*绑定",
		"价.?.?格.?.?公.?.?道",
		"价.?.?格.?.?公.?.?道",
		"货.?.?到.?.?付.?.?款",
		"先.*后.?.?款",
		"游.?.?戏.?.?币",
		"最.?.?低.?.?价",
		"无.?.?黑.?.?金",
		"[金g元].?.?=",
		"支付.?.?[宝寶]",
		"淘.?.?[宝寶]",
		"[加q].?.?q",
		"联.?.?系",
		"电.?.?话",
		"旺.?.?旺",
		"口.?.?口",
		"扣.?.?扣",
		"叩.?.?叩",
		"歪.?.?歪",
		"y.?.?y",
		"[萬万].?.?g",
		"[萬万w].?.?金",
		"tao.?.?bao",
		"buy",
		"cheap",
		"code",
		"express",
		"gold",
		"lowest",
		"powerle?ve?l",
		"price",
		"promoti[on][gn]",
		"sa[fl]e",
		"serv[ei][rc]e?",
	},
	["WhiteList"] = {
		"%d?%..*%d+%.?%d?%(%d+%.?%d?%,?%d+%.?%d?%%%)",
		"%d?%..*%d+%.?%d?.*%d+%.?%d?%%.*%(%d+%.?%d?%)",
	},
	["BlackList"] = {
		"春花秋月何时了.*买金知多少.*小楼昨夜又东风.*金价不堪回首月明中.*雕栏玉砌金犹在.*只是价格改.*问君能有几多愁.*恰似我家金价在跳楼",
		"so?rr?y.*%d+[kg].*buy",
		"so?rr?y.*need.*cheap.*gold.*%d+",
	},
}
-----------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------
local L = {
	["Achievement"] = "%shave earned the achievement%s!",
	["LearnSpell"] = "You have learned: %s",
	["UnlearnSpell"] = "You have unlearned: %s",
}
if (GetLocale() == "zhCN") then
	L = {
		["Achievement"] = "%s获得了成就%s!",
		["LearnSpell"] = "你学会了技能: %s",
		["UnlearnSpell"] = "你遗忘了技能: %s",
	}
elseif (GetLocale() == "zhTW") then
	L = {
		["Achievement"] = "%s獲得了成就%s!",
		["LearnSpell"] = "你學會了技能: %s",
		["UnlearnSpell"] = "你遺忘了技能: %s",
	}
end
-----------------------------------------------------------------------
-- ChatFilter
-----------------------------------------------------------------------
local ChatFilter, ChatFrames = CreateFrame("Frame")

local CacheTable, prevLineId = {}
local alreadySent, spellList, changingspec = {}, {}
local totalCreated, resetTimer, craftList, craftQuantity, craftItemID, prevCraft = {}, {}, {}
local achievements, spamCategories, specialFilters = {}, {[95] = true, [155] = true, [168] = true, [14807] = true}, {456, 1400, 1402, 3117, 3259, 4078, 4576}

local function deformat(text)
	text = gsub(text, "%.", "%%.")
	text = gsub(text, "%%%d$s", "(.+)")
	text = gsub(text, "%%s", "(.+)")
	text = gsub(text, "%%d", "(%%d+)")
	text = "^" .. text .. "$"
	return text
end

local createmsg = deformat(LOOT_ITEM_CREATED_SELF)
local createmultimsg = deformat(LOOT_ITEM_CREATED_SELF_MULTIPLE)
local learnspellmsg = deformat(ERR_LEARN_SPELL_S)
local learnabilitymsg = deformat(ERR_LEARN_ABILITY_S)
local unlearnspellmsg = deformat(ERR_SPELL_UNLEARNED_S)
local petlearnspellmsg = deformat(ERR_PET_LEARN_SPELL_S)
local petlearnabilitymsg = deformat(ERR_PET_LEARN_ABILITY_S)
local petunlearnspellmsg = deformat(ERR_PET_SPELL_UNLEARNED_S)
local auctionstartedmsg = deformat(ERR_AUCTION_STARTED)
local auctionremovedmsg = deformat(ERR_AUCTION_REMOVED)
local duelwinmsg = deformat(DUEL_WINNER_KNOCKOUT )
local duellosemsg = deformat(DUEL_WINNER_RETREAT  )
local spellcastprimaryspec = GetSpellInfo(63645)
local spellcastsecondaryspec = GetSpellInfo(63644)

local function SendMessage(event, msg, r, g, b)
	local info = ChatTypeInfo[strsub(event, 10)]
	for i = 1, NUM_CHAT_WINDOWS do
		ChatFrames = _G["ChatFrame"..i]
		if (ChatFrames and ChatFrames:IsEventRegistered(event)) then
			ChatFrames:AddMessage(msg, info.r, info.g, info.b)
		end
	end
end

local function SendAchievement(event, achievementID, players)
	if (not players) then return end
	for k in pairs(alreadySent) do alreadySent[k] = nil end
	for i = getn(players), 1, -1 do
		if (alreadySent[players[i].name]) then
			tremove(players, i)
		else
			alreadySent[players[i].name] = true
		end
	end
	if (getn(players) > 1) then
		sort(players, function(a, b) return a.name < b.name end)
	end
	for i = 1, getn(players) do
		local class, color, r, g, b
		if (players[i].guid and tonumber(players[i].guid)) then
			class = select(2, GetPlayerInfoByGUID(players[i].guid))
			color = RAID_CLASS_COLORS[class]
		end
		if (not color) then
			local info = ChatTypeInfo[strsub(event, 10)]
			r, g, b = info.r, info.g, info.b
		else
			r, g, b = color.r, color.g, color.b
		end
		players[i] = format("|cff%02x%02x%02x|Hplayer:%s|h[%s]|h|r", r*255, g*255, b*255, players[i].name, players[i].name)
	end
	SendMessage(event, format(L["Achievement"], table.concat(players, ", "), GetAchievementLink(achievementID)))
end

local function achievementReady(id, achievement)
	if (achievement.area and achievement.guild) then
		local playerGuild = GetGuildInfo("player")
		for i = getn(achievement.area), 1, -1 do
			local player = achievement.area[i].name
			if (UnitExists(player) and playerGuild and playerGuild == GetGuildInfo(player)) then
				tinsert(achievement.guild, tremove(achievement.area, i))
			end
		end
	end
	if (achievement.area and getn(achievement.area) > 0) then
		SendAchievement("CHAT_MSG_ACHIEVEMENT", id, achievement.area)
	end
	if (achievement.guild and getn(achievement.guild) > 0) then
		SendAchievement("CHAT_MSG_GUILD_ACHIEVEMENT", id, achievement.guild)
	end
end

local function talentspecReady(attribute, spells)
	if (not spells) then return end
	for k in pairs(alreadySent) do alreadySent[k] = nil end
	for i = getn(spells), 1, -1 do
		if (alreadySent[spells[i]]) then
			tremove(spells, i)
		else
			alreadySent[spells[i]] = true
		end
	end
	if (getn(spells) > 1) then
		sort(spells, function(a, b) return a < b end)
	end
	for i = 1, getn(spells) do
		spells[i] = GetSpellLink(spells[i])
	end
	if (attribute == "Learn") then
		SendMessage("CHAT_MSG_SYSTEM", format(L["LearnSpell"], table.concat(spells, "")))
	end
	if (attribute == "Unlearn") then
		SendMessage("CHAT_MSG_SYSTEM", format(L["UnlearnSpell"], table.concat(spells, "")))
	end
end

local function ChatFrames_OnUpdata(self, elapsed)
	local found
	for id, resetAt in pairs(resetTimer) do
		if (resetAt <= GetTime()) then
			SendMessage("CHAT_MSG_LOOT", format(LOOT_ITEM_CREATED_SELF_MULTIPLE, (select(2, GetItemInfo(id))), totalCreated[id]))
			totalCreated[id] = nil
			resetTimer[id] = nil
		end
		found = true
	end
	for id, spell in pairs(spellList) do
		if (spell.timeout <= GetTime()) then
			talentspecReady(id, spell)
			spellList[id] = nil
		end
		found = true
	end
	for id, achievement in pairs(achievements) do
		if (achievement.timeout <= GetTime()) then
			achievementReady(id, achievement)
			achievements[id] = nil
		end
		found = true
	end
	if (not found) then
		self:SetScript("OnUpdate", nil)
	end
end

local function queueCraftMessage(craft, itemID, itemQuantity)
	if (prevCraft and prevCraft ~= craft) then return end
	prevCraft = craft
	local Delay = select(4, GetNetStats()) / 250 + 0.5
	if (Delay > 2) then Delay = 2 end
	totalCreated[itemID] = (totalCreated[itemID] or 0) + (itemQuantity or 1)
	resetTimer[itemID] = GetTime() + craftList[itemID] + Delay
	ChatFilter:SetScript("OnUpdate", ChatFrames_OnUpdata)
end

local function queueTalentSpecSpam(attribute, spellID)
	spellList[attribute] = spellList[attribute] or {timeout = GetTime() + 0.5}
	tinsert(spellList[attribute], spellID)
	ChatFilter:SetScript("OnUpdate", ChatFrames_OnUpdata)
end

local function queueAchievementSpam(event, achievementID, playerdata)
	achievements[achievementID] = achievements[achievementID] or {timeout = GetTime() + 0.5}
	achievements[achievementID][event] = achievements[achievementID][event] or {}
	tinsert(achievements[achievementID][event], playerdata)
	ChatFilter:SetScript("OnUpdate", ChatFrames_OnUpdata)
end

if (Config.noprofanityFilter or Config.nojoinleaveChannel) then
	ChatFilter:RegisterEvent("ADDON_LOADED")
end

if (Config.MergeTalentSpec) then
	ChatFilter:RegisterEvent("UNIT_SPELLCAST_START")
	ChatFilter:RegisterEvent("UNIT_SPELLCAST_STOP")
end

if (Config.MergeManufacturing) then
	hooksecurefunc("DoTradeSkill", function(index, quantity)
			local itemID = strmatch(GetTradeSkillItemLink(index), "item:(%d+)")
			if (itemID) then
				craftQuantity = quantity
				craftItemID = tonumber(itemID)
				prevCraft = nil
			end
	end)
	ChatFilter:RegisterEvent("TRADE_SKILL_UPDATE")
end

ChatFilter:SetScript("OnEvent", function(self, event, ...)
	local arg1, arg2 = ...
	if (event == "ADDON_LOADED") then
		if (Config.noprofanityFilter) then
			SetCVar("profanityFilter", 0)
		end
		if (Config.nojoinleaveChannel) then
			for i = 1, NUM_CHAT_WINDOWS do
				ChatFrames = _G["ChatFrame"..i]
				ChatFrame_RemoveMessageGroup(ChatFrames, "CHANNEL")
			end
		end
	elseif (event == "TRADE_SKILL_UPDATE") then
		if (GetTradeSkillLine() and not IsTradeSkillLinked()) then
			for i = 1, GetNumTradeSkills() do
				if (GetTradeSkillItemLink(i) and GetTradeSkillRecipeLink(i)) then
					local itemID = strmatch(GetTradeSkillItemLink(i), "item:(%d+)")
					local enchantID = strmatch(GetTradeSkillRecipeLink(i), "enchant:(%d+)")
					if (itemID and enchantID) then
						craftList[tonumber(itemID)] = select(7, GetSpellInfo(enchantID)) / 1000
					end
				end
			end
		end
	elseif (event == "UNIT_SPELLCAST_START" and arg1 == "player" and (arg2 == spellcastprimaryspec or arg2 == spellcastsecondaryspec)) then
		changingspec = true
	elseif (event == "UNIT_SPELLCAST_STOP" and arg1 == "player" and (arg2 == spellcastprimaryspec or arg2 == spellcastsecondaryspec)) then
		changingspec = nil
	end
end)

local function ChatFilter_Rubbish(self, event, msg, player, _, _, _, flag, _, _, _, _, lineId)
	if (lineId ~= prevLineId) then
		if (not Config.ScanOurself and UnitIsUnit(player,"player")) then return end
		if (not Config.ScanFriend and not CanComplainChat(lineId)) then return end
		if (not Config.ScanTeam and (UnitInRaid(player) or UnitInParty(player))) then return end
		if (not Config.ScanGuild and UnitIsInMyGuild(player)) then return end
		if (event == "CHAT_MSG_WHISPER") then
			if (flag == "GM") then return end
			for i = 1, select(2, BNGetNumFriends()) do
				local toon = BNGetNumFriendToons(i)
				for j = 1, toon do
					local _, rName, rGame = BNGetFriendToonInfo(i, j)
					if (not Config.ScanFriend and rName == player and rGame == "WoW") then return end
				end
			end
		end
		if (Config.FilterRepeat or Config.FilterAdvertising) then
			msg = (msg):lower()
			local Symbols = {" ","`","~","@","#","^","*","/","，","。","、","？","！","：","；","’","‘","“","”","【","】","《","》","（","）","<",">"}
			for i = 1, getn(Symbols) do
				msg = gsub(msg, Symbols[i], "")
			end
		end
		for i = 1, getn(Config.WhiteList) do
			if (strfind(msg, Config.WhiteList[i])) then
				return
			end
		end
		for i = 1, getn(Config.BlackList) do
			if (strfind(msg, Config.BlackList[i])) then
				return true
			end
		end
		if (Config.FilterAdvertising) then
			local matchs = 0
			for i = 1, getn(Config.SafeWords) do
				if (strfind(msg, Config.SafeWords[i])) then
					matchs = matchs - 2
				end
			end
			for i = 1, getn(Config.DangerWords) do
				if (strfind(msg, Config.DangerWords[i])) then
					matchs = matchs + 1
				end
			end
			if (Config.ScanFriend and not CanComplainChat(lineId)) then matchs = matchs - 2 end
			if (Config.ScanTeam and (UnitInRaid(player) or UnitInParty(player))) then matchs = matchs - 1 end
			if (Config.ScanGuild and UnitIsInMyGuild(player)) then matchs = matchs - 1 end
			if (strlen(msg) > 120) then matchs = matchs + 1 end
			if (matchs > Config.AllowMatchs) then return true end
		end
		if (Config.FilterRepeat or Config.FilterMultiLine) then
			local lines, Data  = 1, {Name = player, Msg = msg, Time = GetTime()}
			for i = getn(CacheTable), 1, -1 do
				value = CacheTable[i]
				if (GetTime() - value.Time  > Config.RepeatInterval) then
					tremove(CacheTable, i)
					break
				elseif (value.Name == player) then
					if (Config.FilterMultiLine) then
						if (GetTime() - value.Time < 0.400) then
							lines = lines +1
							if (lines > Config.AllowLines) then
								return true
							end
						end
					end
					if (Config.FilterRepeat) then
						if  (value.Msg == msg) then
							return true
						end
						if (Config.RepeatAlike and Config.RepeatAlike < 100) then
							local count = 0
							if (strlen(msg) > strlen(value.Msg)) then
								bigs = msg
								smalls = value.Msg
							else
								bigs = value.Msg
								smalls = msg
							end
							for i = 1, strlen(smalls) do
								if (strfind(bigs, strsub(smalls, i, i + 1), 1, true)) then
									count = count + 1
								end
							end
							if (count / strlen(bigs) * 100 > Config.RepeatAlike) then
								return true
							end
						end
					end
				end
			end
			if (getn(CacheTable) > Config.RepeatMaxCache) then
				tremove(CacheTable, 1)
			end
			tinsert(CacheTable, Data)
		end
		prevLineId = lineId
	end
end

local function ChatFilter_Achievement(self, event, msg, player, _, _, _, _, _, _, _, _, _, guid)
	if (Config.MergeAchievement) then
		local achievementID = strmatch(msg, "achievement:(%d+)")
		if (not achievementID) then return end
		achievementID = tonumber(achievementID)
		local playerdata = {name = player, guid = guid}
		local categoryID = GetAchievementCategory(achievementID)
		if (spamCategories[categoryID] or spamCategories[select(2, GetCategoryInfo(categoryID))] or specialFilters[achievementID]) then
			queueAchievementSpam((event == "CHAT_MSG_GUILD_ACHIEVEMENT" and "guild" or "area"), achievementID, playerdata)
			return true
		end
	end
end

local function ChatFilter_TalentSpec(self, event, msg)
	if (Config.MergeTalentSpec) then
		local learnID = strmatch(msg, learnspellmsg) or strmatch(msg, learnabilitymsg)
		local unlearnID = strmatch(msg, unlearnspellmsg)
		if (learnID and changingspec) then
			learnID = tonumber(strmatch(learnID, "spell:(%d+)"))
			queueTalentSpecSpam("Learn", learnID)
			return true
		elseif (unlearnID and changingspec) then
			unlearnID = tonumber(strmatch(unlearnID, "spell:(%d+)"))
			queueTalentSpecSpam("Unlearn", unlearnID)
			return true
		end
		if (Config.FilterPetTalentSpec and (strfind(msg, petlearnspellmsg) or strfind(msg, petlearnabilitymsg) or strfind(msg, petunlearnspellmsg))) then
			return true
		end
	end
	if (Config.FilterDuelMSG and (not strfind(msg, GetUnitName("player"))) and (strfind(msg, duelwinmsg) or strfind(msg, duellosemsg))) then return true end
	if (Config.FilterAuctionMSG and (strfind(msg, auctionstartedmsg) or strfind(msg, auctionremovedmsg))) then return true end
end

local function ChatFilter_Created(self, event, msg)
	if (Config.MergeManufacturing) then
		local craft = self
		local itemID, itemQuantity = strmatch(msg, createmultimsg)
		if (not itemID and not itemQuantity) then
			itemID = strmatch(msg, createmsg)
		end
		if (not itemID) then return end
		itemID = tonumber(strmatch(itemID, "item:(%d+)"))
		itemQuantity = tonumber(itemQuantity)
		if (itemID and craftList[itemID] and craftItemID == itemID and craftQuantity > 1) then 
			queueCraftMessage(craft, itemID, itemQuantity)
			return true
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", ChatFilter_Created)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", ChatFilter_TalentSpec)
ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", ChatFilter_Achievement)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", ChatFilter_Achievement)
-----------------------------------------------------------------------
-- SlashCommand
-----------------------------------------------------------------------
SLASH_CHATFILTER1 = "/chatfilter"
SLASH_CHATFILTER2 = "/cf"

SlashCmdList["CHATFILTER"] = function(msg)
	local cmd = msg:lower()
	if cmd == "scanourself" then
		if (Config.ScanOurself) then
			Config.ScanOurself = nil
			print("ScanOurself has been disabled.")
		else
			Config.ScanOurself = true
			print("ScanOurself has been enabled.")
		end
	elseif cmd == "scanfriend" then
		if (Config.ScanFriend) then
			Config.ScanFriend = nil
			print("ScanFriend has been disabled.")
		else
			Config.ScanFriend = true
			print("ScanFriend has been enabled.")
		end
	elseif cmd == "scanteam" then
		if (Config.ScanTeam) then
			Config.ScanTeam = nil
			print("ScanTeam has been disabled.")
		else
			Config.ScanTeam = true
			print("ScanTeam has been enabled.")
		end
	elseif cmd == "scanguild" then
		if (Config.ScanGuild) then
			Config.ScanGuild = nil
			print("ScanGuild has been disabled.")
		else
			Config.ScanGuild = true
			print("ScanGuild has been enabled.")
		end
	elseif cmd == "advertising" then
		if (Config.FilterAdvertising) then
			Config.FilterAdvertising = nil
			print("FilterAdvertising has been disabled.")
		else
			Config.FilterAdvertising = true
			print("FilterAdvertising has been enabled.")
		end
	elseif cmd == "multiline" then
		if (Config.FilterMultiLine) then
			Config.FilterMultiLine = nil
			print("FilterMultiLine has been disabled.")
		else
			Config.FilterMultiLine = true
			print("FilterMultiLine has been enabled.")
		end
	elseif cmd == "repeat" then
		if (Config.FilterRepeat) then
			Config.FilterRepeat = nil
			print("FilterRepeat has been disabled.")
		else
			Config.FilterRepeat = true
			print("FilterRepeat has been enabled.")
		end
	elseif cmd == "achievement" then
		if (Config.MergeAchievement) then
			Config.MergeAchievement = nil
			print("MergeAchievement has been disabled.")
		else
			Config.MergeAchievement = true
			print("MergeAchievement has been enabled.")
		end
	elseif cmd == "talent" then
		if (Config.MergeTalentSpec) then
			Config.MergeTalentSpec = nil
			print("MergeTalentSpec has been disabled.")
		else
			Config.MergeTalentSpec = true
			print("MergeTalentSpec has been enabled.")
		end
	elseif cmd == "creat" then
		if (Config.MergeManufacturing) then
			Config.MergeManufacturing = nil
			print("MergeManufacturing has been disabled.")
		else
			Config.MergeManufacturing = true
			print("MergeManufacturing has been enabled.")
		end
	elseif cmd == "auction" then
		if (Config.FilterAuctionMSG) then
			Config.FilterAuctionMSG = nil
			print("FilterAuctionMSG has been disabled.")
		else
			Config.FilterAuctionMSG = true
			print("FilterAuctionMSG has been enabled.")
		end
	elseif cmd == "duel" then
		if (Config.FilterDuelMSG) then
			Config.FilterDuelMSG = nil
			print("FilterDuelMSG has been disabled.")
		else
			Config.FilterDuelMSG = true
			print("FilterDuelMSG has been enabled.")
		end
	else
		print("/chatfilter [ scanourself | scanfriend | scanteam | scanguild ]")
		print("/chatfilter [ advertising | multiline | repeat | auction ]")
		print("/chatfilter [ achievement | talent | creat | duel ]")
	end
end