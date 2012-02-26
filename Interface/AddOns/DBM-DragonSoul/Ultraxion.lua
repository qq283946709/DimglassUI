local mod	= DBM:NewMod(331, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 6991 $"):sub(12, -3))
mod:SetCreatureID(55294)
mod:SetModelID(39099)
mod:SetZone()
mod:SetUsedIcons()
mod:SetModelSound("Sound\\CREATURE\\ULTRAXION\\VO_DS_ULTRAXION_INTRO_02.wav", "Sound\\CREATURE\\ULTRAXION\\VO_DS_ULTRAXION_AGGRO_01.wav")

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"SPELL_DAMAGE",
	"SPELL_AURA_REMOVED"
)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_SAY"
)

local warnHourofTwilightSoon		= mod:NewPreWarnAnnounce(109416, 15, 4) --15秒預警
local warnHourofTwilight			= mod:NewCountAnnounce(109416, 4) --暮光之時
local warnFadingLight				= mod:NewTargetCountAnnounce(110080, 3) --凋零之光

local specWarnHourofTwilight		= mod:NewSpecialWarningSpell(109416)
--specWarnHT
local COUNT_HT = 0
local specWarnHT1		= mod:NewSpecialWarning("SpecWarnHT1",true,"optSpecWarnHT")
local specWarnHT2 		= mod:NewSpecialWarning("SpecWarnHT2",true,"optSpecWarnHT")
local specWarnHT3		= mod:NewSpecialWarning("SpecWarnHT3",true,"optSpecWarnHT")
local specWarnHT4		= mod:NewSpecialWarning("SpecWarnHT4",true,"optSpecWarnHT")
local specWarnHT5 		= mod:NewSpecialWarning("SpecWarnHT5",true,"optSpecWarnHT")
local specWarnHT6		= mod:NewSpecialWarning("SpecWarnHT6",true,"optSpecWarnHT")
local specWarnHT7		= mod:NewSpecialWarning("SpecWarnHT7",true,"optSpecWarnHT")

local specWarnFadingLight			= mod:NewSpecialWarningYou(110080)
local specWarnFadingLightOther		= mod:NewSpecialWarningTarget(110080, mod:IsTank())
local specWarnTwilightEruption		= mod:NewSpecialWarningSpell(106388)
local specWarnFadingLightTime		= mod:NewSpecialWarning("SpecwarnFadingLightTime") --超過8秒

local specWarnHQ					= mod:NewSpecialWarningSpell(105896, mod:IsHealer())
local specWarnLQ					= mod:NewSpecialWarningSpell(105903, mod:IsHealer())
local specWarnLvQ					= mod:NewSpecialWarningSpell(105900, mod:IsHealer())

local timerCombatStart				= mod:NewTimer(35, "TimerCombatStart", 2457)
local timerUnstableMonstrosity		= mod:NewNextTimer(60, 106372, nil, mod:IsHealer())
local timerAE						= mod:NewNextTimer(6, 106375, nil, mod:IsHealer())
local timerHourofTwilight			= mod:NewCastTimer(5, 109416)
local timerHourofTwilightCD			= mod:NewNextCountTimer(45.5, 109416)
local timerTwilightEruption			= mod:NewCastTimer(5, 106388)
local timerFadingLight				= mod:NewBuffFadesTimer(10, 110080)
local timerFadingLightCD			= mod:NewNextTimer(10, 110080)--10 second on heroic, 15 on normal
local timerLoomingDarkness			= mod:NewBuffFadesTimer(120, 106498)--Heroic ability, personal only timer.
local timerRaidCDs					= mod:NewTimer(60, "timerRaidCDs", 2565, nil, false)

local berserkTimer					= mod:NewBerserkTimer(360)

local timerHQ		= mod:NewTimer(78, "timerHQ", 105896, mod:IsHealer())
local timerLQ		= mod:NewTimer(58, "timerLQ", 105903, mod:IsHealer())
local timerLvQ		= mod:NewTimer(74, "timerLvQ", 105900, mod:IsHealer())

local specWarnNG1		= mod:NewSpecialWarning("SpecWarnNG1",false,"optSpecWarnNG1")
local specWarnNG2		= mod:NewSpecialWarning("SpecWarnNG2",false,"optSpecWarnNG2")
local specWarnNG3		= mod:NewSpecialWarning("SpecWarnNG3",false,"optSpecWarnNG3")
local specWarnYoursoon	= mod:NewSpecialWarning("SpecWarnYoursoon",true,"optSpecWarnYoursoon")

local specWarnZW		= mod:NewSpecialWarningSpell(86669,true,"CustomWarning") --遠古諸王
local specWarnDQ		= mod:NewSpecialWarningSpell(871,true,"CustomWarning") --盾牆
local specWarnXS		= mod:NewSpecialWarningSpell(70940,true,"CustomWarning") --神性守護
local specWarnB			= mod:NewSpecialWarningSpell(62618,true,"CustomWarning") --壁
local specWarnLJ		= mod:NewSpecialWarningSpell(98008,true,"CustomWarning") --連結
local specWarnCG		= mod:NewSpecialWarningSpell(64844,true,"CustomWarning") --唱歌
local specWarnX			= mod:NewSpecialWarningSpell(42594,true,"CustomWarning") --熊
local specWarnPX		= mod:NewSpecialWarningSpell(97462,true,"CustomWarning") --振奮咆哮
local specWarnHF		= mod:NewSpecialWarningSpell(22842,true,"CustomWarning") --狂暴恢復
local specWarnYY		= mod:NewSpecialWarningSpell(40724,true,"CustomWarning") --英勇
local specWarnFL		= mod:NewSpecialWarningSpell(16191,true,"CustomWarning") --法潮
local specWarnSP		= mod:NewSpecialWarningSpell(33373,true,"CustomWarning") --飾品
local specWarnLX		= mod:NewSpecialWarningSpell(79206,true,"CustomWarning") --靈行者之賜


mod:AddBoolOption("optSpecWarnNG1", false, "sound")
mod:AddBoolOption("optSpecWarnNG2", false, "sound")
mod:AddBoolOption("optSpecWarnNG3", false, "sound")
mod:AddBoolOption("optShowtimes", true, "sound")
mod:AddBoolOption("ShowRaidCDs", false, "timer")
mod:AddBoolOption("ShowRaidCDsSelf", false, "timer")
mod:AddBoolOption("CustomWarning", true, "announce")
mod:AddBoolOption("Myhei", mod:IsDps())

mod:AddDropdownOption("optjs", {"non", "qishi", "mushi1", "mushi2", "shengqi1", "shengqi2", "saman"}, "non", "sound")

mod:AddDropdownOption("ResetHoTCounter", {"Never", "Reset3", "Reset3Always"}, "Never", "announce")


--local FadingLightCountdown			= mod:NewCountdown(10, 110080)--5-10 second variation that's random according to EJ

local fadingLightCount = 0
local fadingLightTargets = {}
local AEspeed = 0
local AECount = 0
local spamAE = 0
local Myhei = 0

local function WarnYoursoon()
	specWarnYoursoon:Show()
	sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\didi.mp3")
	sndWOP:Schedule(5, "Interface\\AddOns\\DBM-Core\\extrasounds\\didi.mp3")
end

local function warnFadingLightTargets()
	warnFadingLight:Show(fadingLightCount, table.concat(fadingLightTargets, "<, >"))
	table.wipe(fadingLightTargets)
end

function mod:OnCombatStart(delay)
	table.wipe(fadingLightTargets)
	fadingLightCount = 0
	berserkTimer:Start(-delay)
	warnHourofTwilightSoon:Schedule(30.5)
	timerHourofTwilightCD:Start(45.5-delay, 1)
	timerHQ:Start(-delay)
	timerAE:Start(-delay)
	COUNT_HT = 0
	AEspeed = 0
	AECount = 0
	spamAE = 0
	Myhei = 0

--自定義減傷列表
--[[
	if mod.Options.optjs == "zhanshi" then --戰坦
		self:Schedule(5, WarnYoursoon)
		specWarnDQ:Schedule(10)   --0:10
		self:Schedule(70, WarnYoursoon)
		specWarnDQ:Schedule(75)   --1:15
		self:Schedule(135, WarnYoursoon)
		specWarnDQ:Schedule(140)  --2:20 
		self:Schedule(200, WarnYoursoon)
		specWarnDQ:Schedule(205)  --3:25
		self:Schedule(265, WarnYoursoon)
		specWarnDQ:Schedule(270)  --4:30
		self:Schedule(331, WarnYoursoon)
		specWarnDQ:Schedule(336)  --5:36
	end	
	]]--
	if mod.Options.optjs == "qishi" then --聖坦
		self:Schedule(40, WarnYoursoon) 
		specWarnXS:Schedule(45) --0:45
		self:Schedule(135, WarnYoursoon)
		specWarnXS:Schedule(140) --2:20
		self:Schedule(200, WarnYoursoon)
		specWarnXS:Schedule(205)  --3:25
		self:Schedule(285, WarnYoursoon)
		specWarnXS:Schedule(290)  --4:50
		self:Schedule(345, WarnYoursoon)
		specWarnXS:Schedule(350)  --5:50
	end
	if mod.Options.optjs == "saman" then --薩滿
		self:Schedule(20, WarnYoursoon)
		specWarnLX:Schedule(25)  --0:25
		specWarnSP:Schedule(26)  --0:25
		self:Schedule(40, WarnYoursoon)
		specWarnLJ:Schedule(45)  --0:45
		self:Schedule(95, WarnYoursoon)
		specWarnFL:Schedule(100)  --1:40
		self:Schedule(115, WarnYoursoon)
		specWarnSP:Schedule(120)  --2:00
		self:Schedule(145, WarnYoursoon)
		specWarnLX:Schedule(150)  --2:30
		self:Schedule(210, WarnYoursoon)
		specWarnSP:Schedule(215)  --3:35
		self:Schedule(305, WarnYoursoon)
		specWarnLJ:Schedule(310)  --5:10
		specWarnYY:Schedule(312)  --5:12
		self:Schedule(335, WarnYoursoon)
		specWarnLX:Schedule(340)  --5:40
	end
	if mod.Options.optjs == "mushi1" then -- 牧师A
		self:Schedule(38, WarnYoursoon)
		specWarnB:Schedule(43)  --0:43
		self:Schedule(295, WarnYoursoon)
		specWarnCG:Schedule(300) --5:00
		self:Schedule(335, WarnYoursoon)
		specWarnB:Schedule(340)  --5:40
	end
	if mod.Options.optjs == "mushi2" then -- 牧师B
		self:Schedule(38, WarnYoursoon)
		specWarnB:Schedule(43)  --0:43
		self:Schedule(295, WarnYoursoon)
		specWarnB:Schedule(300)  --5:00
		self:Schedule(320, WarnYoursoon)
		specWarnCG:Schedule(325) --5:25
	end
	if mod.Options.optjs == "shengqi1" then  --骑士A
		specWarnZW:Schedule(0.5)   --0:00
		self:Schedule(300, WarnYoursoon)
		specWarnZW:Schedule(305)  --5:05
	end
	if mod.Options.optjs == "shengqi2" then  --骑士B
		specWarnZW:Schedule(0.5)   --0:00
		self:Schedule(300, WarnYoursoon)
		specWarnZW:Schedule(305)  --5:05
	end
	--[[
	if mod.Options.optjs == "dazhu" then --大豬
		specWarnX:Schedule(325)
		specWarnX:Schedule(327)
		self:Schedule(340, WarnYoursoon)
		specWarnHF:Schedule(345)
	end
]]--
--自定義減傷列表結束	
	
	if mod.Options.optSpecWarnNG1 then
		specWarnNG1:Schedule(41)
		specWarnNG1:Schedule(43)
		sndWOP:Schedule(42, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_ng.mp3")	
	end
	if mod.Options.optShowtime then
		DBM.InfoFrame:SetHeader("戰鬥時間")
		DBM.InfoFrame:Show(1, "time", "|cFF00FF006sec/AE|r")
		self:Schedule(60, function() DBM.InfoFrame:Show(1, "time", "|cFF00FFFF5sec/AE|r") end)
		self:Schedule(120, function() DBM.InfoFrame:Show(1, "time", "|cFFFFFF004sec/AE|r") end)
		self:Schedule(180, function() DBM.InfoFrame:Show(1, "time", "|cFFFFA5003sec/AE|r") end)
		self:Schedule(240, function() DBM.InfoFrame:Show(1, "time", "|cFFFF00FF2sec/AE|r") end)
		self:Schedule(300, function() DBM.InfoFrame:Show(1, "time", "|cFFFF00001sec/AE|r") end)
	end
end

function mod:OnCombatEnd()
	if mod.Options.Myhei and mod:IsDps() then
		if Myhei == 0 then
			print("真的假的?! 我居然沒有中凋零之光")
		elseif Myhei > 0 and Myhei < 4 then
			print("喔, 太棒了! 我只中了"..Myhei.."次凋零之光")
		elseif Myhei >= 4 then
			print("我是不是忘了洗臉! 居然中了"..Myhei.."次凋零之光")
		end
	end
	if mod.Options.optShowtime then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(106371, 109415, 109416, 109417) then
		fadingLightCount = 0
		COUNT_HT = COUNT_HT + 1
		warnHourofTwilight:Show(COUNT_HT)
		if mod.Options.optSpecWarnHT then		
			if COUNT_HT == 1 then
				specWarnHT1:Show()
			elseif COUNT_HT == 2 then
				specWarnHT2:Show()
			elseif COUNT_HT == 3 then
				specWarnHT3:Show()
			elseif COUNT_HT == 4 then
				specWarnHT4:Show()
			elseif COUNT_HT == 5 then
				specWarnHT5:Show()
			elseif COUNT_HT == 6 then
				specWarnHT6:Show()
			elseif COUNT_HT == 7 then
				specWarnHT7:Show()
			end
		else
			specWarnHourofTwilight:Show()
		end
			if COUNT_HT % 3 == 1 and mod.Options.optSpecWarnNG2 then
				specWarnNG2:Schedule(41)
				specWarnNG2:Schedule(43)
				sndWOP:Schedule(42, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_ng.mp3")	
			elseif COUNT_HT % 3 == 2 and mod.Options.optSpecWarnNG3 then
				specWarnNG3:Schedule(41)
				specWarnNG3:Schedule(43)
				sndWOP:Schedule(42, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_ng.mp3")	
			elseif COUNT_HT % 3 == 0 and mod.Options.optSpecWarnNG1 then
				specWarnNG1:Schedule(41)
				specWarnNG1:Schedule(43)
				sndWOP:Schedule(42, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_ng.mp3")	
			end
		warnHourofTwilightSoon:Schedule(30.5)
		if (self.Options.ResetHoTCounter == "Reset3" and self:IsDifficulty("heroic10", "heroic25") or self.Options.ResetHoTCounter == "Reset3Always") and COUNT_HT == 3
		or self.Options.ResetHoTCounter == "Reset3" and self:IsDifficulty("normal10", "normal25", "lfr25") and COUNT_HT == 2 then
			COUNT_HT = 0
		end
		timerHourofTwilightCD:Start(45.5, COUNT_HT + 1)
		if self:IsDifficulty("heroic10", "heroic25") then
			timerFadingLightCD:Start(13)
			timerHourofTwilight:Start(3)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_mgzs.mp3")--暮光之時
			sndWOP:Schedule(0.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(2.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")			
		else
			timerFadingLightCD:Start(20)--Same in raid finder too? too many difficulties now
			timerHourofTwilight:Start()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_mgzs.mp3")--暮光之時
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
			sndWOP:Schedule(2.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(3.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(4.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end		
	elseif args:IsSpellID(106388) then
		specWarnTwilightEruption:Show()
		timerTwilightEruption:Start()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zbks.mp3")--自爆開始(滅團)
		sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Schedule(2, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(3, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(4, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(106372, 106376, 106377, 106378, 106379) then
		timerUnstableMonstrosity:Start()
		AEspeed = AEspeed + 1
	elseif args:IsSpellID(97462) and self:IsInCombat() and ((self.Options.ShowRaidCDs and not self.Options.ShowRaidCDsSelf) or (self.Options.ShowRaidCDs and self.Options.ShowRaidCDsSelf and UnitName("player") == args.sourceName)) then--Warrior Rallying Cry
		if UnitDebuff(args.sourceName, GetSpellInfo(106218)) then--Last Defender of Azeroth
			timerRaidCDs:Start(90, args.spellName, args.sourceName)
		else
			timerRaidCDs:Start(180, args.spellName, args.sourceName)
		end
	elseif args:IsSpellID(871) and self:IsInCombat() and ((self.Options.ShowRaidCDs and not self.Options.ShowRaidCDsSelf) or (self.Options.ShowRaidCDs and self.Options.ShowRaidCDsSelf and UnitName("player") == args.sourceName)) then--Warrior Shield Wall (4pc Assumed)
		if UnitDebuff(args.sourceName, GetSpellInfo(106218)) then--Last Defender of Azeroth
			timerRaidCDs:Start(60, args.spellName, args.sourceName)
		else
			timerRaidCDs:Start(120, args.spellName, args.sourceName)
		end
	elseif args:IsSpellID(62618) and self:IsInCombat() and ((self.Options.ShowRaidCDs and not self.Options.ShowRaidCDsSelf) or (self.Options.ShowRaidCDs and self.Options.ShowRaidCDsSelf and UnitName("player") == args.sourceName)) then--Paladin Divine Guardian (4pc assumed)
		if UnitDebuff(args.sourceName, GetSpellInfo(106218)) then--Last Defender of Azeroth
			timerRaidCDs:Start(60, args.spellName, args.sourceName)
		else
			timerRaidCDs:Start(120, args.spellName, args.sourceName)
		end
	elseif args:IsSpellID(55233) and self:IsInCombat() and ((self.Options.ShowRaidCDs and not self.Options.ShowRaidCDsSelf) or (self.Options.ShowRaidCDs and self.Options.ShowRaidCDsSelf and UnitName("player") == args.sourceName)) then--DK Vampric Blood (4pc assumed)
		if UnitDebuff(args.sourceName, GetSpellInfo(106218)) then--Last Defender of Azeroth
			timerRaidCDs:Start(30, args.spellName, args.sourceName)
		else
			timerRaidCDs:Start(60, args.spellName, args.sourceName)
		end
	elseif args:IsSpellID(22842) and self:IsInCombat() and ((self.Options.ShowRaidCDs and not self.Options.ShowRaidCDsSelf) or (self.Options.ShowRaidCDs and self.Options.ShowRaidCDsSelf and UnitName("player") == args.sourceName)) then--Druid Frenzied Regen (4pc assumed)
		if UnitDebuff(args.sourceName, GetSpellInfo(106218)) then--Last Defender of Azeroth
			timerRaidCDs:Start(90, args.spellName, args.sourceName)
		else
			timerRaidCDs:Start(180, args.spellName, args.sourceName)
		end
	elseif args:IsSpellID(98008) and self:IsInCombat() and ((self.Options.ShowRaidCDs and not self.Options.ShowRaidCDsSelf) or (self.Options.ShowRaidCDs and self.Options.ShowRaidCDsSelf and UnitName("player") == args.sourceName)) then--Shaman Spirit Link
		timerRaidCDs:Start(180, args.spellName, args.sourceName)
	elseif args:IsSpellID(62618) and self:IsInCombat() and ((self.Options.ShowRaidCDs and not self.Options.ShowRaidCDsSelf) or (self.Options.ShowRaidCDs and self.Options.ShowRaidCDsSelf and UnitName("player") == args.sourceName)) then--Priest Power Word: Barrior
		timerRaidCDs:Start(180, args.spellName, args.sourceName)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(110068, 110069, 105925, 110070) then--Damage taken IDs, tank specific debuffs.
		fadingLightCount = fadingLightCount + 1
		fadingLightTargets[#fadingLightTargets + 1] = args.destName
		if self:IsDifficulty("heroic10", "heroic25") and fadingLightCount < 3 then--It's cast 3 times during hour of twilight buff duration on ultraxion heroic. 20 secomds remaining, 10 seconds remaining, and at 0 seconds remainings.
			timerFadingLightCD:Start()
		elseif self:IsDifficulty("normal10", "normal25", "lfr25") and fadingLightCount < 2 then
			timerFadingLightCD:Start(15)
		end
		if args:IsPlayer() then
			local _, _, _, _, _, duration, expires, _, _ = UnitDebuff("player", args.spellName)
			specWarnFadingLight:Show()
			sndWOP:Schedule(expires - GetTime() - 4.7, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_lkmg.mp3")
			sndWOP:Schedule(expires - GetTime() - 3.7, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(expires - GetTime() - 2.7, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(expires - GetTime() - 1.7, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			timerFadingLight:Start(expires-GetTime()-1)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zydlsj.mp3")--注意凋零時間
		else
			if mod:IsTank() then
				specWarnFadingLightOther:Show(args.destName)		
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zytkdl.mp3")--注意坦克凋零
			end
		end
		self:Unschedule(warnFadingLightTargets)
		if self:IsDifficulty("lfr25") or self:IsDifficulty("heroic25") and #fadingLightTargets >= 7 or self:IsDifficulty("normal25") and #fadingLightTargets >= 4 or self:IsDifficulty("heroic10") and #fadingLightTargets >= 3 or self:IsDifficulty("normal10") and #fadingLightTargets >= 2 then
			warnFadingLightTargets()
		else
			self:Schedule(0.5, warnFadingLightTargets)
		end
	elseif args:IsSpellID(110079, 109075, 110078, 110080) then--Damage done IDs, dps/healer debuffs
		fadingLightTargets[#fadingLightTargets + 1] = args.destName
		if args:IsPlayer() then
			Myhei = Myhei + 1
			local _, _, _, _, _, duration, expires, _, _ = UnitDebuff("player", args.spellName)
			sndWOP:Schedule(expires - GetTime() - 4.7, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_lkmg.mp3")
			sndWOP:Schedule(expires - GetTime() - 3.7, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(expires - GetTime() - 2.7, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(expires - GetTime() - 1.7, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			timerFadingLight:Start(expires-GetTime()-1)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zydlsj.mp3")--注意凋零時間
			if self:IsDifficulty("normal10","normal25") and fadingLightCount == 2 and expires - GetTime() > 8 then
				specWarnFadingLightTime:Show()
			else
				specWarnFadingLight:Show()
			end

		end
		self:Unschedule(warnFadingLightTargets)
		if self:IsDifficulty("heroic25") and #fadingLightTargets >= 7 or self:IsDifficulty("normal25") and #fadingLightTargets >= 4 or self:IsDifficulty("heroic10") and #fadingLightTargets >= 3 or self:IsDifficulty("normal10") and #fadingLightTargets >= 2 then
			warnFadingLightTargets()
		else
			self:Schedule(0.5, warnFadingLightTargets)
		end
	elseif args:IsSpellID(106498) and args:IsPlayer() then
		timerLoomingDarkness:Start()
	end
end

function mod:CHAT_MSG_MONSTER_SAY(msg)
	if msg == L.Pull or msg:find(L.Pull) then
		timerCombatStart:Start()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.HQ or msg:find(L.HQ) then
		if mod:IsHealer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_hqcx.mp3")
		end
		timerHQ:Cancel()
		timerLvQ:Start()	
		specWarnHQ:Show()
	elseif msg == L.LQ or msg:find(L.LQ) then
		if mod:IsHealer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_lqcx.mp3")
		end
		timerLQ:Cancel()	
		specWarnLQ:Show()
	elseif msg == L.LvQ or msg:find(L.LvQ) then
		if mod:IsHealer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_lvqcx.mp3")
		end
		timerLvQ:Cancel()
		timerLQ:Start()		
		specWarnLvQ:Show()
	end
end

function mod:SPELL_DAMAGE(sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId)
	if (spellId == 106375 or spellId == 109182 or spellId == 109183 or spellId == 109184) and GetTime() - spamAE > 0.5 then
		AECount = AECount + 1
		spamAE = GetTime()
		if AEspeed == 1 then
			timerAE:Update(1.1, 7)
		elseif AEspeed == 2 then
			timerAE:Update(2.1, 7)
		elseif AEspeed == 3 then
			timerAE:Update(3.1, 7)
		end
		if AECount == 7 then
			timerAE:Cancel()
			timerAE:Start(12)
		elseif AECount == 15 then
			timerAE:Cancel()
			timerAE:Start(10)
		end
	end
end