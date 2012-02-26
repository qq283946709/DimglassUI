local mod	= DBM:NewMod(317, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndPS		= mod:NewSound(nil, "SoundPS", false)
local sndBM		= mod:NewSound(nil, "SoundBM", false)

mod:SetRevision(("$Revision: 7157 $"):sub(12, -3))
mod:SetCreatureID(55689)
mod:SetModelID(39318)
mod:SetZone()
mod:SetUsedIcons(3, 4, 5, 6, 7, 8)
mod:SetModelSound("Sound\\CREATURE\\HAGARA\\VO_DS_HAGARA_AGGRO_01.wav", "Sound\\CREATURE\\HAGARA\\VO_DS_HAGARA_LIGHTNING_02.wav")

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON"
)

local warnTempest			= mod:NewCastAnnounce(109552, 4)--冰凍風暴
local warnLightningStorm	= mod:NewSpellAnnounce(105465, 4)--閃電風暴
local warnPillars			= mod:NewAnnounce("WarnPillars", 2, 105311)
local warnAssault			= mod:NewSpellAnnounce(107851, 4, nil, mod:IsHealer() or mod:IsTank())--集中攻擊
local warnShatteringIce		= mod:NewTargetAnnounce(105289, 3, nil, mod:IsHealer())--3 second cast, give a healer a heads up of who's about to be kicked in the face. --破碎之冰
local warnFrostTombCast		= mod:NewAnnounce("warnFrostTombCast", 4, 104448)--Can't use a generic, cause it's an 8 second cast even though it says 1second in tooltip. --寒冰之墓釋放
local warnFrostTomb			= mod:NewTargetAnnounce(104451, 4)--寒冰之墓出現
local warnIceLance			= mod:NewTargetAnnounce(105269, 3, nil, false)--冰霜長矛
local warnFrostflake		= mod:NewTargetAnnounce(109325, 3)	-- 冰霜
local warnStormPillars		= mod:NewSpellAnnounce(109557, 3)	-- 風暴之柱

local specWarnIceLance		= mod:NewSpecialWarningStack(107061, true, 4)
local specWarnFrostTombCast	= mod:NewSpecialWarningSpell(104448)
local specWarnTempest		= mod:NewSpecialWarningSpell(109552)
local specWarnLightingStorm	= mod:NewSpecialWarningSpell(105465)
local specWarnAssault		= mod:NewSpecialWarningSpell(107851, mod:IsTank())
local specWarnFrostTomb		= mod:NewSpecialWarningYou(104451)
local specWarnWatery		= mod:NewSpecialWarningMove(110317)
local specWarnFrostflake	= mod:NewSpecialWarningYou(109325)
local specWarnShattering	= mod:NewSpecialWarningYou(105289)
local yellFrostflake		= mod:NewYell(109325)

local timerFrostTomb		= mod:NewCastTimer(8, 104448)
local timerFrostTombCD		= mod:NewNextTimer(20, 104451)
local timerIceLance			= mod:NewBuffActiveTimer(15, 105269)
local timerShatteringCD		= mod:NewCDTimer(10.5, 105289, nil, mod:IsHealer())--every 10.5-15 seconds
local timerIceLanceCD		= mod:NewNextTimer(30, 105269)
local timerSpecialCD		= mod:NewTimer(62, "TimerSpecial", "Interface\\Icons\\Spell_Nature_WispSplode")
local timerTempestCD		= mod:NewNextTimer(62, 105256)
local timerLightningStormCD	= mod:NewNextTimer(62, 105465)
local timerIceWave			= mod:NewNextTimer(10, 105314)
local timerFeedback			= mod:NewBuffActiveTimer(15, 108934)
local timerAssault			= mod:NewBuffActiveTimer(5, 107851, nil, mod:IsHealer() or mod:IsTank())
local timerAssaultCD		= mod:NewCDTimer(15.5, 107851, nil, mod:IsHealer() or mod:IsTank())
local timerStormPillarCD	= mod:NewNextTimer(5, 109557)--Both of these are just spammed every 5 seconds on new targets.
local timerFrostFlakeCD		= mod:NewNextTimer(5, 109325)

local AssaultCount = 1
local Icetime = 0

local berserkTimer				= mod:NewBerserkTimer(480)	-- according to Icy-Veins

mod:AddBoolOption("RangeFrame")--Ice lance spreading. May make it more dynamic later but for now i need to see the fight in realtime before i can do any more guessing off mailed in combat logs.
mod:AddBoolOption("SetIconOnFrostflake", false)
mod:AddBoolOption("SetIconOnFrostTomb", true)
mod:AddBoolOption("AnnounceFrostTombIcons", false)

local lanceTargets = {}
local tombTargets = {}
local tombIconTargets = {}
local igotlance = false
local pillarsRemaining = 4
local frostPillar = EJ_GetSectionInfo(4069)
local lightningPillar = EJ_GetSectionInfo(3919)

function mod:ShatteredIceTarget()
	local targetname = self:GetBossTarget(55689)
	if not targetname then return end
	warnShatteringIce:Show(targetname)
	sndPS:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_pszb.mp3")--破碎之冰
	timerShatteringCD:Start()
	if UnitName("player") == targetname then
		specWarnShattering:Show()
	end	
end

function mod:OnCombatStart(delay)
	igotlance = false
	Icetime = 0
	table.wipe(lanceTargets)
	table.wipe(tombIconTargets)
	table.wipe(tombTargets)
	timerAssaultCD:Start(4-delay)
	if self:IsTank() or self:IsHealer() then
		if self:IsDifficulty("heroic10", "heroic25") then
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(2, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(3, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
	end
	timerIceLanceCD:Start(10-delay)
--	timerFrostTombCD:Start(16-delay)--No longer cast on engage? most recent log she only casts it after specials now and not after pull
	timerSpecialCD:Start(30-delay)
	sndWOP:Schedule(26.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3")--2階段準備
	sndWOP:Schedule(27.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
	sndWOP:Schedule(28.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
	sndWOP:Schedule(29.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	berserkTimer:Start(-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(3)
	end
	AssaultCount=1
end

function mod:OnCombatEnd()
	sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
	sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
	sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_hdjs.mp3")
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

local function warnLanceTargets()
	warnIceLance:Show(table.concat(lanceTargets, "<, >"))
	timerIceLance:Start()
	timerIceLanceCD:Start()
	table.wipe(lanceTargets)
end

local function ClearTombTargets()
	table.wipe(tombIconTargets)
end

do
	local function sort_by_group(v1, v2)
		return DBM:GetRaidSubgroup(UnitName(v1)) < DBM:GetRaidSubgroup(UnitName(v2))
	end
	function mod:SetTombIcons()
		if DBM:GetRaidRank() > 0 then
			table.sort(tombIconTargets, sort_by_group)
			local tombIcons = 8
			for i, v in ipairs(tombIconTargets) do
				if self.Options.AnnounceFrostTombIcons and IsRaidLeader() then
					SendChatMessage(L.TombIconSet:format(tombIcons, UnitName(v)), "RAID")
				end
				self:SetIcon(UnitName(v), tombIcons)
				tombIcons = tombIcons - 1
			end
			self:Schedule(8, ClearTombTargets)
		end
	end
end

local function warnTombTargets()
	warnFrostTomb:Show(table.concat(tombTargets, "<, >"))
	table.wipe(tombTargets)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(104451) then
		tombTargets[#tombTargets + 1] = args.destName
		if mod:IsDps() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_bmkd.mp3.mp3")--冰墓快打
		end
		if self.Options.SetIconOnFrostTomb then
			table.insert(tombIconTargets, DBM:GetRaidUnitId(args.destName))
			self:UnscheduleMethod("SetTombIcons")
			if (self:IsDifficulty("normal25") and #tombIconTargets >= 5) or (self:IsDifficulty("heroic25") and #tombIconTargets >= 6) or (self:IsDifficulty("normal10", "heroic10") and #tombIconTargets >= 2) then
				self:SetTombIcons()--Sort and fire as early as possible once we have all targets.
			else
				if self:LatencyCheck() then--Icon sorting is still sensitive and should not be done by laggy members that don't have all targets.
					self:ScheduleMethod(0.3, "SetTombIcons")
				end
			end
		end
		self:Unschedule(warnTombTargets)
		if (self:IsDifficulty("normal25") and #tombTargets >= 5) or (self:IsDifficulty("heroic25") and #tombTargets >= 6) or (self:IsDifficulty("normal10", "heroic10") and #tombTargets >= 2) then
			warnTombTargets()
		else
			self:Schedule(0.3, warnTombTargets)
		end
	elseif args:IsSpellID(107851, 110898, 110899, 110900) then--107851 10/25 man normal confirmed. 110900 is lfr25 difficulty.
		warnAssault:Show()
		if mod:IsHealer() or mod:IsTank() then
			if AssaultCount < 4 then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_jzgj.mp3")--集中攻擊
			end
			if AssaultCount < 3 then
				if self:IsDifficulty("heroic10", "heroic25") then
					sndWOP:Schedule(12.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
					sndWOP:Schedule(13.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
					sndWOP:Schedule(14.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
				end
			end
		end
		timerAssault:Start()
		timerAssaultCD:Start()
		AssaultCount = AssaultCount + 1
	elseif args:IsSpellID(110317) and args:IsPlayer() then
		specWarnWatery:Show()
	elseif args:IsSpellID(109325) then
		warnFrostflake:Show(args.destName)
		timerFrostFlakeCD:Start()
		if args:IsPlayer() then
			specWarnFrostflake:Show()
			yellFrostflake:Yell()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_bs.mp3")--冰霜
		end
		if self.Options.SetIconOnFrostflake then
			self:SetIcon(args.destName, 3)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(104451) and self.Options.SetIconOnFrostTomb then--104451 10/25 man normal confirmed.
		self:SetIcon(args.destName, 0)
	elseif args:IsSpellID(105256, 109552, 109553, 109554) then--Tempest
		AssaultCount = 1
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_hdjs.mp3")--快打 護盾結束
		timerFrostFlakeCD:Cancel()
		timerIceLanceCD:Start(12)
		timerFeedback:Start()
		if not self:IsDifficulty("lfr25") then
			timerFrostTombCD:Start()
		end
		timerAssaultCD:Start()
		if self:IsTank() or self:IsHealer() then
			if self:IsDifficulty("heroic10", "heroic25") then
				sndWOP:Schedule(12.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
				sndWOP:Schedule(13.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
				sndWOP:Schedule(14.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			end
		end
		timerLightningStormCD:Start()
		sndWOP:Schedule(58.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_djdzb.mp3")--電階段準備
		sndWOP:Schedule(59.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(60.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(61.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(3)
		end
	elseif args:IsSpellID(105409, 109560, 109561, 109562) then--Water Shield
		AssaultCount = 1
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_hdjs.mp3")--快打 護盾結束
		timerStormPillarCD:Cancel()
		timerIceLanceCD:Start(12)
		timerFeedback:Start()
		if not self:IsDifficulty("lfr25") then
			timerFrostTombCD:Start()
		end
		timerAssaultCD:Start()
		if self:IsTank() or self:IsHealer() then
			if self:IsDifficulty("heroic10", "heroic25") then
				sndWOP:Schedule(12.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
				sndWOP:Schedule(13.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
				sndWOP:Schedule(14.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			end
		end
		timerTempestCD:Start()
		sndWOP:Schedule(58.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_bjdzb.mp3")--冰階段準備
		sndWOP:Schedule(59.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(60.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(61.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(3)
		end
	elseif args:IsSpellID(109325) then
		if args:IsPlayer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runin.mp3")--快回人群
		end
		if self.Options.SetIconOnFrostflake then
			self:SetIcon(args.destName, 0)
		end
	elseif args:IsSpellID(105311) then--Frost defeated.
		pillarsRemaining = pillarsRemaining - 1
		warnPillars:Show(frostPillar, pillarsRemaining)
		if self:IsDifficulty("heroic10", "heroic25") then
			if pillarsRemaining == 3 then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			elseif pillarsRemaining == 2 then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			elseif pillarsRemaining == 1 then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			end
		end
	elseif args:IsSpellID(105482) then--Lighting defeated.
		pillarsRemaining = pillarsRemaining - 1
		warnPillars:Show(lightningPillar, pillarsRemaining)
		if self:IsDifficulty("heroic10", "heroic25") then
			if pillarsRemaining == 3 then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			elseif pillarsRemaining == 2 then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			elseif pillarsRemaining == 1 then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			end
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(104448) then
		warnFrostTombCast:Show(args.spellName)
		specWarnFrostTombCast:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zybm.mp3")--注意冰墓~8秒		
		sndBM:Schedule(0.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zybm.mp3")
		sndBM:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zybm.mp3")
		sndBM:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zybm.mp3")
		timerFrostTomb:Start()
	elseif args:IsSpellID(105256, 109552, 109553, 109554) then--Tempest
		pillarsRemaining = 4
		timerAssaultCD:Cancel()
		timerIceLanceCD:Cancel()
		warnTempest:Show()
		timerShatteringCD:Cancel()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_bdfb.mp3")--冰凍風暴
		specWarnTempest:Show()
		timerIceWave:Start()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	elseif args:IsSpellID(105409, 109560, 109561, 109562) then--Water Shield
		if self:IsDifficulty("heroic10") then
			pillarsRemaining = 8
		else
			pillarsRemaining = 4
		end
		timerAssaultCD:Cancel()
		timerIceLanceCD:Cancel()
		warnLightningStorm:Show()
		timerShatteringCD:Cancel()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_sdfb.mp3")--閃電風暴
		specWarnLightingStorm:Show()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(10)
		end
	elseif args:IsSpellID(105289, 108567, 110887, 110888) then
		self:ScheduleMethod(0.2, "ShatteredIceTarget")
	end
end

local function ClearLanceOnMe()
	igotlance = false
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(105297) then
		lanceTargets[#lanceTargets + 1] = args.sourceName
		if args.sourceName == UnitName("player") then
			if igotlance == false then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_mb.mp3")
			end
			igotlance = true
			self:Schedule(20, ClearLanceOnMe)
		end	
		self:Unschedule(warnLanceTargets)
		if (self:IsDifficulty("normal10", "heroic10", "lfr25") and #lanceTargets >= 3) then
			warnLanceTargets()
		else
			self:Schedule(0.5, warnLanceTargets)
		end
	elseif args:IsSpellID(109557, 109541) then
		warnStormPillars:Show()
		timerStormPillarCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(105316, 107061, 107062, 107063) and args:IsPlayer() then
		if (args.amount or 0) > 2 then
			specWarnIceLance:Show(args.amount or 1)
			if self:IsDifficulty("heroic10", "heroic25") and GetTime() - Icetime > 3 then
				Icetime = GetTime()
				if not igotlance then
					sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\awayline.mp3")
				else
					sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\awayline.mp3")
					SendChatMessage(L.YellIceLance, "SAY")
				end
			end
		end
	end
end