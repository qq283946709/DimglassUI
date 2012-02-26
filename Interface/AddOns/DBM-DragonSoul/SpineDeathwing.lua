local mod	= DBM:NewMod(318, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 7306 $"):sub(12, -3))
mod:SetCreatureID(53879)
mod:SetModelID(35268)
mod:SetZone()
mod:SetUsedIcons(6, 5, 4, 3, 2, 1)
mod:SetModelSound("Sound\\CREATURE\\Deathwing\\VO_DS_DEATHWING_BACKSLAY_01.wav", "Sound\\CREATURE\\Deathwing\\VO_DS_DEATHWING_BACKSLAY_03.wav")

mod:RegisterCombat("yell", L.Pull)--INSTANCE_ENCOUNTER_ENGAGE_UNIT comes 30 seconds after encounter starts, because of this, the mod can miss the first round of ability casts such as first grip targets. have to use yell

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_HEAL",
	"SPELL_PERIODIC_HEAL",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"SWING_DAMAGE",
	"SWING_MISSED",
	"RAID_BOSS_EMOTE",
	"UNIT_DIED"
)

local warnAbsorbedBlood		= mod:NewStackAnnounce(105248, 2) --被吸收的血液
local warnResidue			= mod:NewCountAnnounce("ej4057", 3)
local warnGrip				= mod:NewTargetAnnounce(109459, 4) --熾熱之握
local warnNuclearBlast		= mod:NewCastAnnounce(105845, 4) --衝擊新星
local warnSealArmor			= mod:NewCastAnnounce(105847, 4)--Cast by Burning Tendons when they spawn after you break a plate
local warnAmalgamation		= mod:NewSpellAnnounce("ej4054", 3)--Amalgamation spawning

local specWarnRoll			= mod:NewSpecialWarningSpell("ej4050")
local specWarnTendril		= mod:NewSpecialWarning("SpecWarnTendril")
local specWarnGrip			= mod:NewSpecialWarningSpell(109459, mod:IsDps())
local specWarnNuclearBlast	= mod:NewSpecialWarningRun(105845, mod:IsMelee())
local specWarnSealArmor		= mod:NewSpecialWarningSpell(105847, mod:IsDps())
local specWarnAmalgamation	= mod:NewSpecialWarningSpell("ej4054", mod:IsTank())

local timerSealArmor		= mod:NewCastTimer(23, 105847)
local timerBarrelRoll		= mod:NewCastTimer(5, "ej4050")
local timerGripCD			= mod:NewNextTimer(32, 109457)
local timerDeathCD			= mod:NewCDTimer(8.5, 106199)--8.5-10sec variation.

--local soundNuclearBlast		= mod:NewSound(105845, nil, mod:IsMelee())

mod:RemoveOption("HealthFrame")
mod:AddBoolOption("InfoFrameTendrils", false)
mod:AddBoolOption("InfoFrameBlood", true)
mod:AddBoolOption("SetIconOnGrip", true)
mod:AddBoolOption("ShowShieldInfofix", false)

local gripTargets = {}
local gripIcon = 6
local corruptionActive = {}
local residueCount = 0
local diedOozeGUIDS = {}
local AbCount = 0
local resurrectedOozeTime = {}

local function checkTendrils()
	if not UnitDebuff("player", GetSpellInfo(109454)) and not UnitIsDeadOrGhost("player") then
		specWarnTendril:Show()
	end
end

local function clearTendrils()
	if mod.Options.InfoFrameTendrils then
		DBM.InfoFrame:Hide()
	end
end

local function showGripWarning()
	warnGrip:Show(table.concat(gripTargets, "<, >"))
	specWarnGrip:Show()
	table.wipe(gripTargets)
end

local function warningResidue()
	if mod.Options.InfoFrameBlood then
		DBM.InfoFrame:SetHeader("腐化之血")
		DBM.InfoFrame:Show(1, "other", "已吸收:"..AbCount, "地上殘渣:"..residueCount)
	end
end

local function saveDiedOoze(GUID)
--	print(GUID, "saved")
	diedOozeGUIDS[GUID] = true
	resurrectedOozeTime[GUID] = GetTime()
end

local function removeResurrectedOozeTime(GUID)
	if resurrectedOozeTime[GUID] then
		resurrectedOozeTime[GUID] = nil
	end
end

local function checkOozeResurrect(GUID)
	-- GUID contains creature id, not needed CID check.
	if diedOozeGUIDS[GUID] then
		 -- sometimes residue Count reduces 2 or more from 1 GUID. To prevent this, we use time check.
		if GetTime() - (resurrectedOozeTime[GUID] or 0) > 2 then--It is an ooze that died earlier. We check destination damage to detect oozes faster if they take damage before they do damage.
			resurrectedOozeTime[GUID] = GetTime()
			diedOozeGUIDS[GUID] = nil --Remove it
			residueCount = residueCount - 1 --Reduce count
			warningResidue()
			mod:Schedule(2, removeResurrectedOozeTime, GUID) -- Remove time save table after 2 sec.
--			print ("ooze_revived", GUID, residueCount)
		end
	end
end

local clearPlasmaTarget, setPlasmaTarget, clearPlasmaVariables
do
	local plasmaTargets = {}
	local healed = {}
	
	function mod:SPELL_HEAL(sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, overheal, absorbed)
		if plasmaTargets[destGUID] then
			healed[destGUID] = healed[destGUID] + (absorbed or 0)
		end
	end
	mod.SPELL_PERIODIC_HEAL = mod.SPELL_HEAL

	local function updatePlasmaTargets()
		local maxAbsorb =	mod:IsDifficulty("heroic25") and 420000 or
							mod:IsDifficulty("heroic10") and 280000 or
							mod:IsDifficulty("normal25") and 300000 or
							mod:IsDifficulty("normal10") and 200000 or 1
		DBM.BossHealth:Clear()
		if not DBM.BossHealth:IsShown() then
			DBM.BossHealth:Show(L.name)
		end
		for i,v in pairs(plasmaTargets) do
			DBM.BossHealth:AddBoss(function() return math.max(1, math.floor((healed[i] or 0) / maxAbsorb * 100))	end, L.PlasmaTarget:format(v))
		end
	end

	function setPlasmaTarget(guid, name)
		plasmaTargets[guid] = name
		healed[guid] = 0
		updatePlasmaTargets()
	end

	function clearPlasmaTarget(guid, name)
		plasmaTargets[guid] = nil
		healed[guid] = nil
		updatePlasmaTargets()
	end

	function clearPlasmaVariables()
		table.wipe(plasmaTargets)
		table.wipe(healed)
		updatePlasmaTargets()
	end
end

function mod:OnCombatStart(delay)
	if self:IsDifficulty("lfr25") then
		warnSealArmor = mod:NewCastAnnounce(105847, 4, 34.5)
	else
		warnSealArmor = mod:NewCastAnnounce(105847, 4)
	end
	table.wipe(gripTargets)
	table.wipe(corruptionActive)
	table.wipe(diedOozeGUIDS)
	table.wipe(resurrectedOozeTime)
	if self.Options.ShowShieldInfofix then
		clearPlasmaVariables()
	end
	gripIcon = 6
	residueCount = 0
	AbCount = 0
	warningResidue()
end

function mod:OnCombatEnd()
	if self.Options.InfoFrameTendrils or self.Options.InfoFrameBlood then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(105845) then
		warnNuclearBlast:Show()
		specWarnNuclearBlast:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_bzkd.mp3")--爆炸快躲
--		soundNuclearBlast:Play()
		if AbCount == 9 then AbCount = 0 end
	elseif args:IsSpellID(105847, 105848) then -- sometimes spellid 105848, maybe related to positions?
		warnSealArmor:Show()
		specWarnSealArmor:Show()
		if self:IsDifficulty("lfr25") then
			timerSealArmor:Start(34.5)
		else
			timerSealArmor:Start()
		end
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_jjkd.mp3")--肌腱快打
	elseif args:IsSpellID(109379) then
		if not corruptionActive[args.sourceGUID] then
			corruptionActive[args.sourceGUID] = 0
			if self:IsDifficulty("normal25", "heroic25") then
				timerGripCD:Start(16, args.sourceGUID)
			else
				timerGripCD:Start(nil, args.sourceGUID)
			end
		end
		corruptionActive[args.sourceGUID] = corruptionActive[args.sourceGUID] + 1
		if corruptionActive[args.sourceGUID] == 2 and self:IsDifficulty("normal25", "heroic25") then
			timerGripCD:Update(8, 16, args.sourceGUID)
			sndWOP:Schedule(5.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(6.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(7.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		elseif corruptionActive[args.sourceGUID] == 4 and self:IsDifficulty("normal10", "heroic10") then
			timerGripCD:Update(24, 32, args.sourceGUID)
			sndWOP:Schedule(5.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(6.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(7.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
	end
end

-- not needed guid check. This is residue creation step.
function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(105219, 109371, 109372, 109373) then 
		residueCount = residueCount + 1
		warningResidue()
--		print ("ooze_dies", args.sourceGUID, residueCount)
		self:Schedule(5, saveDiedOoze, args.sourceGUID)-- save died ooze guid. sometimes SPELL_DAMAGE, SWING_DAMAGE event appears after ooze died. so we delays build died ooze table.
	end
end

--Damage event that indicates an ooze is taking damage
--we check its GUID to see if it's a resurrected ooze and if so remove it from table.
--oozes do not fires SPELL_DAMAGE event from source. so track SPELL_DAMAGE event only from dest.
function mod:SPELL_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 105219 or spellId == 109371 or spellId == 109372 or spellId == 109373 then return end
	checkOozeResurrect(destGUID)
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SWING_DAMAGE(sourceGUID, _, _, _, destGUID)	
	checkOozeResurrect(destGUID)
	checkOozeResurrect(sourceGUID)
end
mod.SWING_MISSED = mod.SWING_DAMAGE

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(105248) then
		--Need to check raw logs later to see if these have sourceGUIDs.
		--if so remove em from table to reduce table size
		--although it own't break anything not removing em.
		residueCount = residueCount - 1
		if AbCount == 0 then AbCount = 1 end
		warningResidue()
--		print ("ooze_absorbed", residueCount)
		warnAbsorbedBlood:Cancel()--Just a little anti spam
		warnAbsorbedBlood:Schedule(1.25, args.destName, args.amount or 1)
	elseif args:IsSpellID(105490, 109457, 109458, 109459) then
		gripTargets[#gripTargets + 1] = args.destName
		timerGripCD:Cancel(args.sourceGUID)
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		if corruptionActive[args.sourceGUID] then
			corruptionActive[args.sourceGUID] = nil
		end
		if self.Options.SetIconOnGrip then
			if gripIcon == 0 then
				gripIcon = 6
			end
			self:SetIcon(args.destName, gripIcon)
			gripIcon = gripIcon - 1
		end
		self:Unschedule(showGripWarning)
		self:Schedule(0.3, showGripWarning)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_cxkd.mp3")--觸鬚纏人
	elseif args:IsSpellID(105479, 109362, 109363, 109364) then
		if self.Options.ShowShieldInfofix then
			setPlasmaTarget(args.destGUID, args.destName)
		end
	end
end		

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(105248) then
		residueCount = residueCount - 1
		AbCount = args.amount
		warningResidue()
		warnAbsorbedBlood:Cancel()--Just a little anti spam
		if args.amount == 9 then
			warnAbsorbedBlood:Show(args.destName, 9)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_rhtkd.mp3")--融合體快打
		else
			warnAbsorbedBlood:Schedule(2, args.destName, args.amount)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(105490, 109457, 109458, 109459) then
		if self.Options.SetIconOnGrip then
			self:SetIcon(args.destName, 0)
		end
	elseif args:IsSpellID(105479, 109362, 109363, 109364) then
		if self.Options.ShowShieldInfofix then
			clearPlasmaTarget(args.destGUID, args.destName)
		end
	end
end	

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.DRoll or msg:find(L.DRoll) then
		self:Unschedule(checkTendrils)--In case you manage to spam spin him, we don't want to get a bunch of extra stuff scheduled.
		self:Unschedule(clearTendrils)--^
		specWarnRoll:Show()--Warn you right away.
		self:Schedule(3, checkTendrils)--After 3 seconds of roll starting, check tendrals, you should have leveled him out by now if this wasn't on purpose.
		self:Schedule(8, clearTendrils)--Clearing 3 seconds after the roll should be sufficent
		timerBarrelRoll:Start()
		if self.Options.InfoFrameTendrils then
			DBM.InfoFrame:SetHeader(L.NoDebuff:format(GetSpellInfo(109454)))
			DBM.InfoFrame:Show(5, "playergooddebuff", 109454)
		end
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_ksfg.mp3")--開始翻滾
	elseif msg == L.DLevels or msg:find(L.DLevels) then
		self:Unschedule(checkTendrils)
		self:Unschedule(clearTendrils)
		clearTendrils()
		timerBarrelRoll:Cancel()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_hfph.mp3")--恢復平衡
	elseif msg == L.LeftDroll or msg:find(L.LeftDroll) then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_left.mp3")--準備向左翻滾
	elseif msg == L.RightDroll or msg:find(L.RightDroll) then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_right.mp3")--準備向右翻滾
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 53891 or cid == 56162 or cid == 56161 then
		timerGripCD:Cancel(args.sourceGUID)
		warnAmalgamation:Schedule(4.5)--4.5-5 seconds after corruption dies.
		specWarnAmalgamation:Schedule(4.5)
		if self:IsDifficulty("heroic10", "heroic25") then
			timerDeathCD:Start(args.destGUID)
		end
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	elseif cid == 56341 or cid == 56575 then
		timerSealArmor:Cancel()
	end
end
