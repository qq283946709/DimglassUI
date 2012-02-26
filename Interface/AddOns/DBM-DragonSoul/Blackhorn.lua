local mod	= DBM:NewMod(332, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local LibRange = LibStub("LibRangeCheck-2.0")

mod:SetRevision(("$Revision: 7233 $"):sub(12, -3))
mod:SetCreatureID(56598)--56427 is Boss, but engage trigger needs the ship which is 56598
mod:SetMainBossID(56427)
mod:SetModelID(39399)
mod:SetZone()
mod:SetUsedIcons()
mod:SetModelSound("Sound\\CREATURE\\WarmasterBlackhorn\\VO_DS_BLACKHORN_INTRO_01.wav", "Sound\\CREATURE\\WarmasterBlackhorn\\VO_DS_BLACKHORN_SPELL_01.wav")

mod:RegisterCombat("combat")
mod:SetMinCombatTime(20)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_SUMMON",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"RAID_BOSS_EMOTE",
	"SPELL_AURA_REMOVED",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local warnDrakesLeft				= mod:NewAddsLeftAnnounce("ej4192", 2, 61248)
local warnHarpoon 					= mod:NewTargetAnnounce(108038, 2) --魚叉
local warnReloading					= mod:NewCastAnnounce(108039, 2)
local warnTwilightOnslaught			= mod:NewCountAnnounce(108862, 4) --暮光突襲
local warnPhase2					= mod:NewPhaseAnnounce(2, 3) --2階段
local warnRoar						= mod:NewSpellAnnounce(109228, 2)
local warnTwilightFlames 			= mod:NewSpellAnnounce(108051, 3) --暮光之焰
local warnShockwave 				= mod:NewTargetAnnounce(108046, 4) --震懾波
local warnSunder					= mod:NewStackAnnounce(108043, 3, nil, mod:IsTank() or mod:IsHealer()) --破甲攻擊
local warnConsumingShroud			= mod:NewTargetAnnounce(110598)

local specWarnHarpoon				= mod:NewSpecialWarningTarget(108038, false)
local specWarnTwilightOnslaught		= mod:NewSpecialWarning("SpecwarnTwilightOnslaught")
local specWarnDeckFireCast				= mod:NewSpecialWarningSpell(110095, false, nil, nil, true)
local specWarnDeckFire				= mod:NewSpecialWarningMove(110095)
local specWarnElites				= mod:NewSpecialWarning("SpecWarnElites", mod:IsTank())
local specWarnShockwave				= mod:NewSpecialWarningMove(108046)
local specWarnShockwaveOther		= mod:NewSpecialWarningTarget(108046, false)
local yellShockwave					= mod:NewYell(108046)
local specWarnTwilightFlames		= mod:NewSpecialWarningMove(108076)
local specWarnSunder				= mod:NewSpecialWarningStack(108043, mod:IsTank(), 3)
local specWarnSunderOther			= mod:NewSpecialWarning("specWarnSunderOther", mod:IsTank() or mod:IsHealer())
local specConsumingShroud			= mod:NewSpecialWarningYou(110214)
local specConsumingShroudOther		= mod:NewSpecialWarningTarget(110214, mod:IsHealer())

local timerCombatStart				= mod:NewTimer(20.5, "TimerCombatStart", 2457)
local timerHarpoonCD				= mod:NewNextTimer(6.5, 108038, nil, mod:IsDps())--CD when you don't fail at drakes
local timerHarpoonActive			= mod:NewBuffActiveTimer(20, 108038, nil, mod:IsDps())--Seems to always hold at least 20 seconds, beyond that, RNG, but you always get at least 20 seconds before they "snap" free.
local timerReloadingCast			= mod:NewCastTimer(10, 108039, nil, mod:IsDps())--You screwed up and let a drake get away, this makes a harpoon gun reload and regrab failed drakes after 10 seconds.
local timerTwilightOnslaught		= mod:NewCastTimer(7, 107588)
local timerTwilightOnslaughtCD		= mod:NewNextCountTimer(35, 107588)
local timerSapperCD					= mod:NewNextTimer(40, "ej4200", nil, nil, nil, 107752)
local timerDegenerationCD			= mod:NewCDTimer(8.5, 109208, nil, mod:IsTank())--8.5-9.5 variation.
local timerBladeRushCD				= mod:NewCDTimer(15.5, 107595)--Experiment, 15.5-20 seemed common for heroic, LFR was a variatable 20-25sec. Just need more data, a lot more.
local timerBroadsideCD				= mod:NewNextTimer(90, 110153)
local timerRoarCD					= mod:NewCDTimer(19, 109228)--19~22 variables (i haven't seen any logs where this wasn't always 21.5, are 19s on WoL somewhere?)
local timerTwilightFlamesCD			= mod:NewNextTimer(8, 108051)
local timerShockwaveCD				= mod:NewCDTimer(23, 108046)
local timerDevastateCD				= mod:NewCDTimer(8.5, 108042, nil, mod:IsTank())
local timerSunder					= mod:NewTargetTimer(30, 108043, nil, mod:IsTank() or mod:IsHealer())
local timerConsumingShroud			= mod:NewCDTimer(30, 110598)
local timerTwilightBreath			= mod:NewCDTimer(20.5, 110213, nil, mod:IsTank() or mod:IsHealer())
local timerADD						= mod:NewTimer(25, "timerADD", 61131)
local timerADD2						= mod:NewTimer(61, "timerADD2", 61131)
local timerADD3						= mod:NewTimer(61, "timerADD3", 61131)

local berserkTimer					= mod:NewBerserkTimer(240)
mod:AddBoolOption("SetTextures", false)
mod:AddDropdownOption("InfoFrameRangeX", {"Range13", "Range10", "Never"}, "Range13", "sound")
mod:AddBoolOption("InfoFrameSunder", mod:IsTank())

local phase2Started = false
local lastFlames = 0
local addsCount = 0
local drakesCount = 6
local ignoredHarpoons = 0
local TOCount = 0
local CVAR = false
local HarpoonsSpam = 0

local function Phase2Delay()
	mod:UnscheduleMethod("AddsRepeat")
	timerTwilightOnslaughtCD:Cancel()
	timerBroadsideCD:Cancel()
	timerSapperCD:Cancel()
	timerRoarCD:Start(10)
	sndWOP:Schedule(7, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
	sndWOP:Schedule(8, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
	sndWOP:Schedule(9, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	timerTwilightFlamesCD:Start(12)
	timerShockwaveCD:Start(13)--13-16 second variation
	if mod:IsDifficulty("heroic10", "heroic25") then
		timerConsumingShroud:Start(45)	-- 45seconds once P2 starts?
	end
	if not mod:IsDifficulty("lfr25") then--Assumed, but i find it unlikely a 4 min berserk timer will be active on LFR
		berserkTimer:Start()
	end
	if mod.Options.SetTextures and not GetCVarBool("projectedTextures") and CVAR then--Confirm we turned them off in phase 1 before messing with anything.
		SetCVar("projectedTextures", 1)--Turn them back on for phase 2 if we're the ones that turned em off on pull.
	end
end

function mod:ShockwaveTarget()
	local targetname = self:GetBossTarget(56427)
	if not targetname then return end
	warnShockwave:Show(targetname)
	if targetname == UnitName("player") then
		specWarnShockwave:Show()
		yellShockwave:Yell()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3")--快躲開
	else
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zsb.mp3")--震懾波	
		specWarnShockwaveOther:Show(targetname)
	end
end

function mod:AddsRepeat() -- it seems to be adds summon only 3 times. needs more review
	if addsCount < 3 then -- fix logical error
		addsCount = addsCount + 1
		specWarnElites:Show()
		--Confirmed behavior for harpoons, only problem is, sometimes the add timer itself is off. :\ For example in this log it's 22.9, 60.8, 62.6
		--We can't safetly use 60603 to fix it either cause we can't tell the trades apart in DBM. I only know mine are right because I personally targeted the drake that drops first add all 3 times.
--		"<1.0> [INSTANCE_ENCOUNTER_ENGAGE_UNIT] Fake Args:#1#1#The Skyfire#0xF130DD1600021854#elite#4000000#nil#nil#nil#nil#normal#0#nil#nil#nil#nil#normal#0#nil#nil#nil#nil#normal#0#Real Args:", -- [24]
--		"<23.9> [UNIT_SPELLCAST_SUCCEEDED] Twilight Assault Drake [[target:Eject Passenger 1::0:60603]]", -- [142]
--		"<43.8> [CLEU] SPELL_AURA_APPLIED#false#0xF150DD6900021857#Skyfire Harpoon Gun#2584#0#0xF150DE1700021DDF#Twilight Assault Drake#133704#0#108038#Harpoon#1#BUFF", -- [1309]
--		"<84.7> [UNIT_SPELLCAST_SUCCEEDED] Twilight Assault Drake [[target:Eject Passenger 1::0:60603]]", -- [3524]
--		"<91.8> [CLEU] SPELL_AURA_APPLIED#false#0xF150DD6900021857#Skyfire Harpoon Gun#2584#0#0xF150DE1700022081#Twilight Assault Drake#2632#0#108038#Harpoon#1#BUFF", -- [3857]
--		"<147.3> [UNIT_SPELLCAST_SUCCEEDED] Twilight Assault Drake [[target:Eject Passenger 1::0:60603]]", -- [7445]
--		"<154.2> [CLEU] SPELL_AURA_APPLIED#false#0xF150DD6900021857#Skyfire Harpoon Gun#2584#0#0xF150DE17000222C0#Twilight Assault Drake#2632#0#108038#Harpoon#1#BUFF", -- [7868]
		if addsCount == 1 then
			timerADD2:Start(61)
			self:ScheduleMethod(61, "AddsRepeat")
			timerHarpoonCD:Start(20)--20 seconds after first elites (Confirmed)
		elseif addsCount == 2 then
			timerADD3:Start(62)
			self:ScheduleMethod(62, "AddsRepeat")
			timerHarpoonCD:Start()--6-7 second variation.
		else
			timerHarpoonCD:Start()
		end
	end
end

function mod:OnCombatStart(delay)
	phase2Started = false
	lastFlames = 0
	addsCount = 0
	drakesCount = 6
	ignoredHarpoons = 0
	HarpoonsSpam = 0
	TOCount = 0
	CVAR = false
	timerCombatStart:Start(-delay)
	timerADD:Start(25-delay)
	self:ScheduleMethod(25-delay, "AddsRepeat")
	sndWOP:Schedule(78, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_xfl.mp3")
	sndWOP:Schedule(140, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_xfl.mp3")
	timerTwilightOnslaughtCD:Start(48-delay, 1)
	if self:IsDifficulty("heroic10", "heroic25") then
		timerBroadsideCD:Start(57-delay)
	end
	if not self:IsDifficulty("lfr25") then--No sappers in LFR
		timerSapperCD:Start(69-delay)
	end
	if DBM.BossHealth:IsShown() then
		local shipname = EJ_GetSectionInfo(4202)
		DBM.BossHealth:Clear()
		DBM.BossHealth:AddBoss(56598, shipname)
	end
	if self.Options.SetTextures and GetCVarBool("projectedTextures") then--This is only true if projected textures were on when we pulled and option to control setting is also on.
		CVAR = true--so set this variable to true, which means we are allowed to mess with users graphics settings
		SetCVar("projectedTextures", 0)
	end
end

function mod:OnCombatEnd()
	if self.Options.SetTextures and not GetCVarBool("projectedTextures") and CVAR then--Only turn them back on if they are off now, but were on when we pulled, and the setting is enabled.
		SetCVar("projectedTextures", 1)
	end
	if mod.Options.InfoFrameSunder or mod.Options.InfoFramerange then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(107588) then
		TOCount = TOCount + 1
		warnTwilightOnslaught:Show(TOCount)
		specWarnTwilightOnslaught:Show(TOCount)
		timerTwilightOnslaught:Start()
		timerTwilightOnslaughtCD:Start(35, TOCount + 1)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_mgtx.mp3")--暮光突襲
		if self:IsDifficulty("heroic10", "heroic25") then
			if TOCount == 1 then
				sndWOP:Schedule(0.75, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			elseif TOCount == 2 then
				sndWOP:Schedule(0.75, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			elseif TOCount == 3 then
				sndWOP:Schedule(0.75, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			elseif TOCount == 4 then
				sndWOP:Schedule(0.75, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
			elseif TOCount == 5 then
				sndWOP:Schedule(0.75, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
			elseif TOCount == 6 then
				sndWOP:Schedule(0.75, "Interface\\AddOns\\DBM-Core\\extrasounds\\countsix.mp3")
			elseif TOCount == 7 then
				sndWOP:Schedule(0.75, "Interface\\AddOns\\DBM-Core\\extrasounds\\countseven.mp3")
			elseif TOCount == 8 then
				sndWOP:Schedule(0.75, "Interface\\AddOns\\DBM-Core\\extrasounds\\counteight.mp3")
			end
		end
		sndWOP:Schedule(3, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Schedule(4, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(6, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	elseif args:IsSpellID(108046) then
		self:ScheduleMethod(0.2, "ShockwaveTarget")
		timerShockwaveCD:Start()
	elseif args:IsSpellID(110210, 110213) then
		timerTwilightBreath:Start()
	elseif args:IsSpellID(108039) then
		warnReloading:Show()
		timerReloadingCast:Start(args.sourceGUID)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(108044, 109228, 109229, 109230) then
		warnRoar:Show()
		timerRoarCD:Start()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		sndWOP:Schedule(16.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(17.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(18.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_px.mp3")
	elseif args:IsSpellID(108042) then
		timerDevastateCD:Start()
	elseif args:IsSpellID(107558, 108861, 109207, 109208) then
		timerDegenerationCD:Start(args.sourceGUID)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(108043) then
		if mod.Options.InfoFrameSunder then
			DBM.InfoFrame:SetHeader(GetSpellInfo(108043))
			DBM.InfoFrame:Show(2, "playerdebuffstacks", 108043)
		end
		warnSunder:Show(args.destName, args.amount or 1)
		timerSunder:Start(args.destName)
		if args:IsPlayer() then
			if (args.amount or 1) >= 3 then
				specWarnSunder:Show(args.amount)
			end
		else
			if (args.amount or 1) >= 2 and not UnitDebuff("player", GetSpellInfo(108043)) then--Other tank has 2 or more sunders and you have none.
				specWarnSunderOther:Show(args.destName, args.amount)--So nudge you to taunt it off other tank already.
			end
		end
	elseif args:IsSpellID(108038) then
		if ignoredHarpoons < 3 then--First two harpoons of fight are bugged, they fire early, apply to drake, even though they missed, then refire. we simply ignore first 2 bad casts to avoid spam and confusion.			
			ignoredHarpoons = ignoredHarpoons + 1
		else
			warnHarpoon:Show(args.destName)
			specWarnHarpoon:Show(args.destName)
			if self:IsDifficulty("heroic10", "heroic25") then
				timerHarpoonActive:Start(nil, args.destGUID)
			elseif self:IsDifficulty("normal10", "normal25") then
				timerHarpoonActive:Start(25, args.destGUID)
			end
		end
		if mod:IsRanged() and mod:IsDps() then
			if GetTime() - HarpoonsSpam > 10 then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_flkd.mp3")--飛龍快打
				HarpoonsSpam = GetTime()
			end
		end
	elseif args:IsSpellID(108040) and not phase2Started then--Goriona is being shot by the ships Artillery Barrage (phase 2 trigger)
		self:Schedule(10, Phase2Delay)--It seems you can still get phase 1 crap until blackhorn is on the deck itself(ie his yell 10 seconds after this trigger) so we delay canceling timers.
		phase2Started = true
		warnPhase2:Show()--We still warn phase 2 here though to get into position, especially since he can land on deck up to 5 seconds before his yell.
		timerCombatStart:Start(5)--5-8 seems variation, we use shortest.
		if DBM.BossHealth:IsShown() then
			DBM.BossHealth:AddBoss(56427, L.name)
		end
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3")--2階段準備
	elseif args:IsSpellID(110598, 110214) then
		warnConsumingShroud:Show(args.destName)
		timerConsumingShroud:Start()
		if args:IsPlayer() then
			specConsumingShroud:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_ts.mp3")--吞噬
		elseif mod:IsHealer() then
			specConsumingShroudOther:Show(args.destName)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_tszb.mp3")--吞噬障壁
		end
	end
end		
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(108051, 109216, 109217, 109218) then
		warnTwilightFlames:Show()--Target scanning? will need to put drake on focus and see
		timerTwilightFlamesCD:Start()
	end
end

function mod:SPELL_DAMAGE(sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId)
	if (spellId == 108076 or spellId == 109222 or spellId == 109223 or spellId == 109224) and destGUID == UnitGUID("player") and GetTime() - lastFlames > 3 then
		specWarnTwilightFlames:Show()
		lastFlames = GetTime()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3")--快躲開
	elseif spellId == 110095 and destGUID == UnitGUID("player") and GetTime() - lastFlames > 3  then
		specWarnDeckFire:Show()
		lastFlames = GetTime()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3")--快躲開
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.SapperEmote or msg:find(L.SapperEmote) then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_gbkd.mp3")--工兵快打
		timerSapperCD:Start()
	elseif msg == L.Broadside or msg:find(L.Broadside) then
		timerBroadsideCD:Start()
	elseif msg == L.DeckFire or msg:find(L.DeckFire) then
		specWarnDeckFireCast:Show()
	elseif msg == L.GorionaRetreat or msg:find(L.GorionaRetreat) then
		self:Schedule(1.5, function()
			timerTwilightBreath:Cancel()
			timerConsumingShroud:Cancel()
			timerTwilightFlamesCD:Cancel()
		end)
	end
end


--[[Useful reg expressions for WoL
spellid = 108038 or fulltype = UNIT_DIED and (targetMobId = 56855 or targetMobId = 56587) or spellid = 108039
spellid = 108038 and fulltype = SPELL_CAST_START or fulltype = UNIT_DIED and (targetMobId = 56855 or targetMobId = 56587) or spellid = 108039
--]]

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 56427 then--Boss
		DBM:EndCombat(self)
	elseif cid == 56848 or cid == 56854 then--Humanoids
		timerBladeRushCD:Cancel(args.sourceGUID)
		timerDegenerationCD:Cancel(args.sourceGUID)
	elseif cid == 56855 or cid == 56587 then--Small Drakes (maybe each side has a unique ID? this could be useful in further filtering which harpoon is which side.
		drakesCount = drakesCount - 1
		warnDrakesLeft:Show(drakesCount)
		timerHarpoonActive:Cancel(args.sourceGUID)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, spellName)
	if spellName == GetSpellInfo(107594) then--Blade Rush, cast start is not detectable, only cast finish, can't use target scanning, or pre warn (ie when the lines go out), only able to detect when they actually finish rush
		self:SendSync("BladeRush", UnitGUID(uId))
	end
	if UnitExists("boss2") then
		if not mod:IsRanged() then return end
		local Bossname = UnitName("boss2")
		local min, max = LibRange:getRange("boss2")
		local apmin, apmax = 0, 0
		if min and max then
			if apmin ~= min or apmax ~= max then
				if mod.Options.InfoFrameRangeX == "Range13" then
					if min >= 8 then					
						DBM.InfoFrame:SetHeader(Bossname)
						DBM.InfoFrame:Show(1, "other", "|cFF00FF00> 13 碼|r", "|cFF00FF00安全距離|r")
					else
						DBM.InfoFrame:SetHeader(Bossname)
						DBM.InfoFrame:Show(1, "other", "|cFFFF0000< 13 碼|r", "|cFFFF0000危險距離|r")
					end					
				elseif mod.Options.InfoFrameRangeX == "Range10" then
					if min >= 5 then					
						DBM.InfoFrame:SetHeader(Bossname)
						DBM.InfoFrame:Show(1, "other", "|cFF00FF00> 10 碼|r", "|cFF00FF00安全距離|r")
					else
						DBM.InfoFrame:SetHeader(Bossname)
						DBM.InfoFrame:Show(1, "other", "|cFFFF0000< 10 碼|r", "|cFFFF0000危險距離|r")
					end
				end
				apmin = min
				apmax = max
			end
		end
	end
end

function mod:OnSync(msg, sourceGUID)
	if msg == "BladeRush" then
		if self:IsDifficulty("heroic10", "heroic25") then
			timerBladeRushCD:Start(sourceGUID)
		else
			timerBladeRushCD:Start(20, sourceGUID)--assumed based on LFR, which seemed to have a 20-25 variation, not 15-20
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(108043) then
		if mod:IsTank() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\changemt.mp3")--換坦嘲諷(破甲消失)
		end
	end
end