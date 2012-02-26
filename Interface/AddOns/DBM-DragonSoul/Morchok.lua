local mod	= DBM:NewMod(311, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 6938 $"):sub(12, -3))
mod:SetCreatureID(55265)
mod:SetModelID(39094)
mod:SetZone()
mod:SetUsedIcons()
mod:SetModelSound("Sound\\CREATURE\\MORCHOK\\VO_DS_MORCHOK_AGGRO_01.wav", "Sound\\CREATURE\\MORCHOK\\VO_DS_MORCHOK_SLAY_03.wav")

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_SUMMON",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_DAMAGE"
)

local warnCrushArmor	= mod:NewStackAnnounce(103687, 3, nil, mod:IsTank() or mod:IsHealer())	--擊碎護甲
local warnCrystal		= mod:NewSpellAnnounce(103639, 3)	--暮光寶珠
local warnStomp			= mod:NewSpellAnnounce(108571, 3)	--踐踏
local warnVortex		= mod:NewSpellAnnounce(110047, 3)	--大地漩渦
local warnBlood			= mod:NewSpellAnnounce(103851, 4)	--大地黑血
local warnFurious		= mod:NewSpellAnnounce(103846, 3)	--狂怒
local warnKohcrom		= mod:NewSpellAnnounce(109017, 4)	--召喚寇魔

local specwarnCrushArmor	= mod:NewSpecialWarningStack(103687, mod:IsTank(), 3)
local specwarnVortexAfter	= mod:NewSpecialWarning("SpecwarnVortexAfter")
local specwarnBlood			= mod:NewSpecialWarningMove(108570)
local specwarnCrystal		= mod:NewSpecialWarningSpell(103639, false)

local specWarn3s		= mod:NewSpecialWarning("specWarn3s", true)

local timerCrushArmor	= mod:NewTargetTimer(20, 103687, nil, mod:IsTank())
local timerCrystalMKNext		= mod:NewTimer(12, "timerCrystalMKNext", 103640)
local timerCrystalKMNext		= mod:NewTimer(12, "timerCrystalKMNext", 103640)
local timerCrystalMK	= mod:NewTimer(12, "timerCrystalMK", 103640)
local timerCrystalKM	= mod:NewTimer(12, "timerCrystalKM", 103640)
local timerStompMK 		= mod:NewTimer(12, "timerStompMK", 108571)
local timerStompKM 		= mod:NewTimer(12, "timerStompKM", 108571)
local timerVortexNext	= mod:NewNextTimer(71, 110047)
local timerBlood		= mod:NewBuffActiveTimer(17, 103851)


local berserkTimer		= mod:NewBerserkTimer(420)

mod:AddBoolOption("RangeFrame", false)--For achievement

local spamBlood = 0
local crystalCount = 0--3 crystals between each vortex cast by Morchok, we ignore his twins.

local Ptwo = false
mod:AddBoolOption("MorchokHero", false, "sound")
mod:AddBoolOption("KohcromHero", false, "sound")

local function showspecWarn3s() --3秒後踐踏
	specWarn3s:Show()
end

function mod:OnCombatStart(delay)
	Ptwo = false
	spamBlood = 0
	crystalCount = 1--only 2 before first aoe so we fake set it to 1 on pull.
	if self:IsDifficulty("heroic10", "heroic25") then
		berserkTimer:Start(-delay)--7 min berserk based on a video, so may not be 100%
	end
	timerStompMK:Start(-delay)
	self:Schedule(9, showspecWarn3s)
	timerCrystalMKNext:Start(19-delay)
	timerVortexNext:Start(54-delay)
	sndWOP:Schedule(54, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zblr.mp3")--準備拉人
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(103687) then
		warnCrushArmor:Show(args.destName, args.amount or 1)
		timerCrushArmor:Start(args.destName)
		if (args.amount or 1) > 3 then
			specwarnCrushArmor:Show(args.amount or 1)
		end
	elseif args:IsSpellID(103846) then
		warnFurious:Show()
		if Ptwo then
			if args:GetSrcCreatureID() == 55265 and mod.Options.MorchokHero then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_kn.mp3")--魔寇狂怒
			elseif args:GetSrcCreatureID() == 57773 and mod.Options.KohcromHero then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_kn.mp3")--寇魔狂怒
			end
		else
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_kn.mp3")--狂怒
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(103851) then
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if Ptwo then
			if args:GetSrcCreatureID() == 55265 and mod.Options.MorchokHero then
				timerStompMK:Start(19)
				self:Schedule(16, showspecWarn3s)
				timerCrystalMKNext:Start(26)
				timerVortexNext:Start()
				sndWOP:Schedule(71, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zblr.mp3")--準備拉人
			elseif args:GetSrcCreatureID() == 57773 and mod.Options.KohcromHero then
				timerStompKM:Start(24)
				self:Schedule(21, showspecWarn3s)
				timerCrystalKMNext:Start(43)
				timerVortexNext:Start()
				sndWOP:Schedule(71, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zblr.mp3")--準備拉人
			end
		else
			timerStompMK:Start(19)
			self:Schedule(16, showspecWarn3s)
			timerCrystalMKNext:Start(26)
			timerVortexNext:Start()
			sndWOP:Schedule(71, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zblr.mp3")--準備拉人
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(103414, 108571, 109033, 109034) then
		if Ptwo then
			if args:GetSrcCreatureID() == 55265 and mod.Options.MorchokHero then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\aesoon.mp3")--魔寇AE
				warnStomp:Show()
				if crystalCount < 3 then
					timerStompMK:Start()
					self:Schedule(9, showspecWarn3s)
				end
			elseif args:GetSrcCreatureID() == 57773 and mod.Options.KohcromHero then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\aesoon.mp3")--寇魔AE
				warnStomp:Show()
				if crystalCount < 3 then
					timerStompKM:Start()
					self:Schedule(9, showspecWarn3s)
				end
			end
		else
			warnStomp:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\aesoon.mp3")--AE
			if crystalCount < 3 then
				timerStompMK:Start()
				self:Schedule(9, showspecWarn3s)
			end
		end
	elseif args:IsSpellID(103851) then
		if args:GetSrcCreatureID() == 55265 then
			warnBlood:Show()
			timerBlood:Start()
			specwarnVortexAfter:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\justrun.mp3")--快跑
			sndWOP:Schedule(12.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
			sndWOP:Schedule(13.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
			sndWOP:Schedule(14.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(15.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(16.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(103639) then
		if Ptwo then
			if args:GetSrcCreatureID() == 55265 and mod.Options.MorchokHero then
				specwarnCrystal:Show()
				crystalCount = crystalCount + 1
				warnCrystal:Show()
				timerCrystalMKNext:Cancel()
				timerCrystalMK:Start()
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_sjcx.mp3")--魔寇水晶出現
				sndWOP:Schedule(9.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_sjbz.mp3")--水晶爆炸
				sndWOP:Schedule(10.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
				sndWOP:Schedule(11.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			elseif args:GetSrcCreatureID() == 57773 and mod.Options.KohcromHero then
				specwarnCrystal:Show()
				crystalCount = crystalCount + 2
				warnCrystal:Show()
				timerCrystalKMNext:Cancel()
				timerCrystalKM:Start()
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_sjcx.mp3")--寇魔水晶出現
				sndWOP:Schedule(9.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_sjbz.mp3")--水晶爆炸
				sndWOP:Schedule(10.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
				sndWOP:Schedule(11.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
			end
		else
			specwarnCrystal:Show()
			crystalCount = crystalCount + 1
			warnCrystal:Show()
			timerCrystalMK:Start()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_sjcx.mp3")--水晶出現
			sndWOP:Schedule(9.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_sjbz.mp3")--水晶爆炸
			sndWOP:Schedule(10.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(11.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
	elseif args:IsSpellID(109017) then
		Ptwo = true
		warnKohcrom:Show()
		timerCrystalMKNext:Cancel()
		self:Unschedule(showspecWarn3s)
		timerCrystalMKNext:Start(5.5) -- 5.5~6.8 sec
		timerStompMK:Cancel()
		if mod.Options.MorchokHero then
			timerStompMK:Start()
			self:Schedule(9, showspecWarn3s)
		elseif mod.Options.KohcromHero then
			timerStompKM:Start(17)
			self:Schedule(14, showspecWarn3s)
			timerCrystalKMNext:Start(27)
		end
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3")--2階段準備
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(103821, 110045, 110046, 110047) then
--		specwarnVortex:Show()--No reason to split the special warning into 2, it's just an attention getter and doesn't stay on screen like normal messages.
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(5)
		end
		if args:GetSrcCreatureID() == 55265 then--Morchok casting it. Seems they cast this at same time, so no reason to announce twin doing it.
			crystalCount = 0
			warnVortex:Show()
		end
	end
end

function mod:SPELL_DAMAGE(sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId)
	if (spellId == 103785 or spellId == 108570 or spellId == 110287 or spellId == 110288) and destGUID == UnitGUID("player") and GetTime() - spamBlood > 3 then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3")--快躲開(大地黑血)
		specwarnBlood:Show()
		spamBlood = GetTime()
	end
end