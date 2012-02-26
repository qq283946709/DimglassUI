local mod	= DBM:NewMod(325, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 7215 $"):sub(12, -3))
mod:SetCreatureID(55312)
mod:SetModelID(39101)
mod:SetZone()
mod:SetUsedIcons()
mod:SetModelSound("Sound\\Creature\\YORSAHJ\\VO_DS_YORSAHJ_INTRO_01.wav", "Sound\\Creature\\YORSAHJ\\VO_DS_YORSAHJ_AGGRO_01.wav")

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_DIED"
)

local warnOozes			= mod:NewTargetAnnounce("ej3978", 4) --召喚軟泥
--local warnOozesHit		= mod:NewAnnounce("warnOozesHit", 3, 16372)
local warnOozesHit		= mod:NewSpecialWarning("warnOozesHit")
local warnVoidBolt		= mod:NewStackAnnounce(108383, 3, nil, mod:IsTank() or mod:IsHealer())--虛空箭
local warnManaVoid		= mod:NewSpellAnnounce(105530, 3)

local specWarnOozes		= mod:NewSpecialWarningSpell("ej3978")

local specWarnOozesZ	= mod:NewSpecialWarning("specWarnOozesZ", true, "SoundWOP")
local specWarnOozesL	= mod:NewSpecialWarning("specWarnOozesL", true, "SoundWOP")
local specWarnOozesR	= mod:NewSpecialWarning("specWarnOozesR", true, "SoundWOP")
local specWarnOozesB	= mod:NewSpecialWarning("specWarnOozesB", true, "SoundWOP")
local specWarnOozesY	= mod:NewSpecialWarning("specWarnOozesY", true, "SoundWOP")
local specWarnOozesH	= mod:NewSpecialWarning("specWarnOozesH", true, "SoundWOP")

local specWarnOozesLL	= mod:NewSpecialWarning("specWarnOozesLL", true, "SoundWOP")
local specWarnOozesHHe	= mod:NewSpecialWarning("specWarnOozesHHe", true, "SoundWOP")
local specWarnOozesHH	= mod:NewSpecialWarning("specWarnOozesHH", true, "SoundWOP")
local specWarnOozesLH	= mod:NewSpecialWarning("specWarnOozesLH", true, "SoundWOP")
local specWarnOozesHuH	= mod:NewSpecialWarning("specWarnOozesHuH", true, "SoundWOP")
local specWarnOozesLHe	= mod:NewSpecialWarning("specWarnOozesLHe", true, "SoundWOP")

local specWarnOozesZHL	= mod:NewSpecialWarning("specWarnOozesZHL", true, "SoundWOP")
local specWarnOozesHHL	= mod:NewSpecialWarning("specWarnOozesHHL", true, "SoundWOP")
local specWarnOozesHHH	= mod:NewSpecialWarning("specWarnOozesHHH", true, "SoundWOP")
local specWarnOozesZLH	= mod:NewSpecialWarning("specWarnOozesZLH", true, "SoundWOP")
local specWarnOozesZHH	= mod:NewSpecialWarning("specWarnOozesZHH", true, "SoundWOP")
local specWarnOozesLLH	= mod:NewSpecialWarning("specWarnOozesLLH", true, "SoundWOP")
local specWarnOozesZLL	= mod:NewSpecialWarning("specWarnOozesZLL", true, "SoundWOP")
local specWarnOozesLZH	= mod:NewSpecialWarning("specWarnOozesLZH", true, "SoundWOP")
local specWarnOozesLHL	= mod:NewSpecialWarning("specWarnOozesLHL", true, "SoundWOP")
local specWarnOozesLHH	= mod:NewSpecialWarning("specWarnOozesLHH", true, "SoundWOP")
local specWarnOozesHZH	= mod:NewSpecialWarning("specWarnOozesHZH", true, "SoundWOP")
local specWarnOozesLHuH = mod:NewSpecialWarning("specWarnOozesLHuH", true, "SoundWOP")
local specWarnOozesLHHu = mod:NewSpecialWarning("specWarnOozesLHHu", true, "SoundWOP")
local specWarnOozesLHuL = mod:NewSpecialWarning("specWarnOozesLHuL", true, "SoundWOP")
local specWarnOozesLZHu = mod:NewSpecialWarning("specWarnOozesLZHu", true, "SoundWOP")
local specWarnOozesHuHL = mod:NewSpecialWarning("specWarnOozesHuHL", true, "SoundWOP")
local specWarnOozesZHuH = mod:NewSpecialWarning("specWarnOozesZHuH", true, "SoundWOP")


local specWarnVoidBolt	= mod:NewSpecialWarningStack(108383, mod:IsTank(), 3)
local specWarnManaVoid	= mod:NewSpecialWarningSpell(105530, mod:IsManaUser())
local specWarnPurple	= mod:NewSpecialWarningSpell(70426, mod:IsTank() or mod:IsHealer())

local timerOozesCD		= mod:NewNextTimer(90, "ej3978")
local timerOozesActive	= mod:NewTimer(7, "timerOozesActive", 16372) -- variables (7.0~8.5)
local timerAcidCD		= mod:NewNextTimer(8.3, 108352)--Green ooze aoe
local timerSearingCD	= mod:NewNextTimer(6, 108358)--Red ooze aoe
local timerVoidBoltCD	= mod:NewNextTimer(6, 108383, nil, mod:IsTank())
local timerVoidBolt		= mod:NewTargetTimer(21, 108383, nil, mod:IsTank() or mod:IsHealer())--Tooltip says 30 but combat logs clearly show it fading at 20-22 (varies)

local berserkTimer		= mod:NewBerserkTimer(600)

local oozesHitTable = {}
local expectedOozes = 0
local yellowActive = false
--local bossName = EJ_GetEncounterInfo(325)
local bossName = "未眠者"

mod:AddBoolOption("SoundWOP", true, "sound")
mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption("optspecWarnOoze", true, "sound")
mod:AddBoolOption("optspecWarnOozes", true, "sound")
mod:AddBoolOption("optspecWarnOozes2", false, "sound")
mod:AddBoolOption("optspecWarnOozesH", true, "sound")

mod:AddDropdownOption("optOozesHA", {"optspecWarnOozesHA1", "optspecWarnOozesHA2", "optspecWarnOozesHA3", "optspecWarnOozesHA4"}, "optspecWarnOozesHA1", "sound")
mod:AddDropdownOption("optOozesHB", {"optspecWarnOozesHB1", "optspecWarnOozesHB2", "optspecWarnOozesHB3", "optspecWarnOozesHB4"}, "optspecWarnOozesHB1", "sound")
mod:AddDropdownOption("optOozesHC", {"optspecWarnOozesHC1", "optspecWarnOozesHC2", "optspecWarnOozesHC3", "optspecWarnOozesHC4"}, "optspecWarnOozesHC1", "sound")
mod:AddDropdownOption("optOozesHD", {"optspecWarnOozesHD1", "optspecWarnOozesHD2", "optspecWarnOozesHD3", "optspecWarnOozesHD4"}, "optspecWarnOozesHD1", "sound")
mod:AddDropdownOption("optOozesHE", {"optspecWarnOozesHE1", "optspecWarnOozesHE2", "optspecWarnOozesHE3", "optspecWarnOozesHE4"}, "optspecWarnOozesHE3", "sound")
mod:AddDropdownOption("optOozesHF", {"optspecWarnOozesHF1", "optspecWarnOozesHF2", "optspecWarnOozesHF3", "optspecWarnOozesHF4"}, "optspecWarnOozesHF1", "sound")

local oozeColorsHeroic = {
	[105420] = { L.Purple, L.Green, L.Black, L.Blue },
	[105435] = { L.Green, L.Red, L.Blue, L.Black },
	[105436] = { L.Green, L.Yellow, L.Black, L.Red },
	[105437] = { L.Blue, L.Purple, L.Green, L.Yellow },
	[105439] = { L.Blue, L.Black, L.Purple, L.Yellow },
	[105440] = { L.Purple, L.Red, L.Yellow, L.Black },
}

local oozeColors = {
	[105420] = { L.Purple, L.Green, L.Blue },
	[105435] = { L.Green, L.Red, L.Black },
	[105436] = { L.Green, L.Yellow, L.Red },
	[105437] = { L.Purple, L.Blue, L.Yellow },
	[105439] = { L.Blue, L.Black, L.Yellow },
	[105440] = { L.Purple, L.Red, L.Black },
}

local oozePos = {
  ["BLUE"] = 	{ 71, 34 },
  ["PURPLE"] = 	{ 57, 13 },
  ["RED"] = 	{ 37, 12 },
  ["GREEN"] = 	{ 22, 34 },
  ["YELLOW"] = 	{ 37, 85 },
  ["BLACK"] = 	{ 71, 65 },
}


local function showOozesWarningLL2()	--殺紫/綠藍
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00戰術分析：|cff33ff99優先擊殺|cffee82ee紫色(治療爆炸)  |cff33ff99其他: |cff00ff00綠色(噴吐粘液濺射4碼內玩家) |cff33ff99+ |cff1e90ff藍色(快速擊殺藍球 有藍職業靠近藍球)|r")
end
local function showOozesWarningHHe2()	--殺綠/紅黑
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00戰術分析：|cff33ff99優先擊殺|cff00ff00綠色(噴吐粘液)  |cff33ff99其他: |cffff3399紅色(全圖靠近王 越遠傷害越高) |cff33ff99+ |cff999999黑色(召喚小怪 集中A掉)|r")
end
local function showOozesWarningHH2()	--殺綠/紅黃
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00戰術分析：|cff33ff99優先擊殺|cff00ff00綠色(噴吐粘液)  |cff33ff99其他: |cffff3399紅色(全圖靠近王 越遠傷害越高) |cff33ff99+ |cffffa500黃色(群體暗影箭 雙倍技能)|r")
end
local function showOozesWarningLH2()	--殺紫/藍黃
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00戰術分析：|cff33ff99優先擊殺|cffee82ee紫色(治療爆炸)  |cff33ff99其他: |cff1e90ff藍色(快速擊殺藍球 有藍職業靠近藍球) |cff33ff99+ |cffffa500黃色(群體暗影箭 雙倍技能)|r")
end
local function showOozesWarningHHe3()	--殺紫/紅黑
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00戰術分析：|cff33ff99優先擊殺|cffee82ee紫色(治療爆炸)  |cff33ff99其他: |cffff3399紅色(全圖靠近王 越遠傷害越高) |cff33ff99+ |cff999999黑色(召喚小怪 集中A掉)|r")
end
local function showOozesWarningR2()		--殺藍/黃黑
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00戰術分析：|cff33ff99優先擊殺|cff1e90ff藍色(全圖吸藍)  |cff33ff99其他: |cffffa500黃色(群體暗影箭 雙倍技能) |cff33ff99+ |cff999999黑色(召喚小怪 集中A掉)|r")
end
local function showOozesWarningR3()		--殺黃/藍黑
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00戰術分析：|cff33ff99優先擊殺|cffffa500黃色(群體暗箭)  |cff33ff99其他: |cff1e90ff藍色(快速擊殺藍球 有藍職業靠近藍球) |cff33ff99+ |cff999999黑色(召喚小怪 集中A掉)|r")
end

function mod:OnCombatStart(delay)
	table.wipe(oozesHitTable)
	timerVoidBoltCD:Start(-delay)
	timerOozesCD:Start(22-delay)
	berserkTimer:Start(-delay)
	sndWOP:Schedule(19, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zbrn.mp3")--準備軟泥
	yellowActive = false
	if self:IsDifficulty("heroic10", "heroic25") then
		expectedOozes = 4
	else
		expectedOozes = 3
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	DBM.Arrow:Hide()
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(104849, 108383, 108384, 108385) then--104849, 108383 confirmed 10 and 25 man normal, other 2 drycoded from wowhead.
		timerVoidBoltCD:Start()--Start CD off this not applied, that way we still get CD if a tank AMS's the debuff application.
	elseif args:IsSpellID(105530) then--105530 confirmed 10 man normal.
		warnManaVoid:Show()
		specWarnManaVoid:Show()
		if self:IsDifficulty("heroic10", "heroic25") then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_kflch.mp3") --潰法力場
			sndWOP:Schedule(1, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(2, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(3, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		else
			sndWOP:Schedule(5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_kflc.mp3")--快打潰法力場
		end
	elseif args:IsSpellID(105573, 108350, 108351, 108352) and self:IsInCombat() then
		if yellowActive then
			timerAcidCD:Start(3.5)--Strangely, ths is 3.5 even though base CD is 8.3-8.5
		else
			timerAcidCD:Start()
		end
	elseif args:IsSpellID(105033, 108356, 108357, 108358) and args:GetSrcCreatureID() == 55312 then
		if yellowActive then
			timerSearingCD:Start(3.5)
		else
			timerSearingCD:Start()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(104849, 108383, 108384, 108385) then--104849, 108383 confirmed 10 and 25 man normal, other 2 drycoded from wowhead.
		warnVoidBolt:Show(args.destName, args.amount or 1)
		local _, _, _, _, _, duration, expires, _, _ = UnitDebuff(args.destName, args.spellName)--Try to fix some stupidness in this timer having a 20-22second variation.
		timerVoidBolt:Start(duration, args.destName)
		if (args.amount or 1) >= 3 and args:IsPlayer() then
			specWarnVoidBolt:Show(args.amount)
		end
	elseif args:IsSpellID(104901) and args:GetDestCreatureID() == 55312 then--Yellow
		table.insert(oozesHitTable, L.Yellow)
		if #oozesHitTable == expectedOozes then--All of em absorbed
			warnOozesHit:Show(bossName, table.concat(oozesHitTable, " + "))
		end
		yellowActive = true
	elseif args:IsSpellID(104896) and args:GetDestCreatureID() == 55312 then--Purple
		table.insert(oozesHitTable, L.Purple)
		if #oozesHitTable == expectedOozes then--All of em absorbed
			warnOozesHit:Show(bossName, table.concat(oozesHitTable, " + "))
		end
		specWarnPurple:Schedule(1)
	elseif args:IsSpellID(105027) and args:GetDestCreatureID() == 55312 then--Blue
		table.insert(oozesHitTable, L.Blue)
		if #oozesHitTable == expectedOozes then--All of em absorbed
			warnOozesHit:Show(bossName, table.concat(oozesHitTable, " + "))
		end
	elseif args:IsSpellID(104897) and args:GetDestCreatureID() == 55312 then--Red
		table.insert(oozesHitTable, L.Red)
		if #oozesHitTable == expectedOozes then--All of em absorbed
			warnOozesHit:Show(bossName, table.concat(oozesHitTable, " + "))
		end
	elseif args:IsSpellID(104894) and args:GetDestCreatureID() == 55312 then--Black
		table.insert(oozesHitTable, L.Black)
		if #oozesHitTable == expectedOozes then--All of em absorbed
			warnOozesHit:Show(bossName, table.concat(oozesHitTable, " + "))
		end
	elseif args:IsSpellID(104898) then--Green
		if args:GetSrcCreatureID() == 55312 then--Only trigger the actual acid spits off the boss getting buff, not the oozes spawning.
			table.insert(oozesHitTable, L.Green)
			if #oozesHitTable == expectedOozes then--All of em absorbed
				warnOozesHit:Show(bossName, table.concat(oozesHitTable, " + "))
			end
		end
		if self.Options.RangeFrame and not self:IsDifficulty("lfr25") then--Range finder outside boss check so we can open and close when green ooze spawns to pre spread.
			DBM.RangeCheck:Show(4)
		end
	end
end		
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(104849, 108383, 108384, 108385) then--104849, 108383 confirmed 10 and 25 man normal, other 2 drycoded from wowhead.
		timerVoidBolt:Cancel(args.destName)
	elseif args:IsSpellID(104901) and args:GetDestCreatureID() == 55312 then--Yellow Removed
		yellowActive = false
	elseif args:IsSpellID(104897) and args:GetDestCreatureID() == 55312 then--Red Removed
		timerSearingCD:Cancel()
	elseif args:IsSpellID(104898) then--Green Removed
		if args:GetDestCreatureID() == 55312 then
			timerAcidCD:Cancel()
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end		

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, spellName, _, _, spellID)
	if not uId:find("boss") then return end
	if self:IsDifficulty("heroic10", "heroic25") then
		if oozeColorsHeroic[spellID] then
			warnOozes:Show(table.concat(oozeColorsHeroic[spellID], ", "))
			timerOozesActive:Start()
			table.wipe(oozesHitTable)
			timerVoidBoltCD:Start(42)
			timerOozesCD:Start(75)
			expectedOozes = 4
			sndWOP:Schedule(72, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zbrn.mp3")--準備軟泥
			sndWOP:Schedule(31.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zbrh.mp3")--準備融合
			sndWOP:Schedule(33, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(34, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(35, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
-- 英雄模式戰術:
			if self.Options.optspecWarnOozesH then
				if spellID==105420 then
					if self.Options.optOozesHA == "optspecWarnOozesHA1" then
						specWarnOozesL:Show()
						DBM.Arrow:ShowRunTo(oozePos["GREEN"][1]/100,oozePos["GREEN"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_lv.mp3")
						specWarnOozesZHL:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：黑   吸藍!|r") end)
					elseif self.Options.optOozesHA == "optspecWarnOozesHA2" then
						specWarnOozesZ:Show()
						DBM.Arrow:ShowRunTo(oozePos["PURPLE"][1]/100,oozePos["PURPLE"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_zi.mp3")
						specWarnOozesLLH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)   傷害：綠+黑   吸藍!|r") end)
					elseif self.Options.optOozesHA == "optspecWarnOozesHA3" then
						specWarnOozesB:Show()
						DBM.Arrow:ShowRunTo(oozePos["BLACK"][1]/100,oozePos["BLACK"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_hei.mp3")
						specWarnOozesZLL:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：綠   吸藍!|r") end)
					elseif self.Options.optOozesHA == "optspecWarnOozesHA4" then
						specWarnOozesR:Show()
						DBM.Arrow:ShowRunTo(oozePos["BLUE"][1]/100,oozePos["BLUE"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_lan.mp3")
						specWarnOozesLZH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：綠+黑   |r") end)
					end
					
				elseif spellID==105435 then
					if self.Options.optOozesHB == "optspecWarnOozesHB1" then
						specWarnOozesL:Show()
						DBM.Arrow:ShowRunTo(oozePos["GREEN"][1]/100,oozePos["GREEN"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_lv.mp3")
						specWarnOozesHHL:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)   傷害：紅+黑   吸藍!|r") end)
					elseif self.Options.optOozesHB == "optspecWarnOozesHB2" then
						specWarnOozesH:Show()
						DBM.Arrow:ShowRunTo(oozePos["RED"][1]/100,oozePos["RED"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_hong.mp3")
						specWarnOozesLLH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)   傷害：綠+黑   吸藍!|r") end)
					elseif self.Options.optOozesHB == "optspecWarnOozesHB3" then
						specWarnOozesB:Show()
						DBM.Arrow:ShowRunTo(oozePos["BLACK"][1]/100,oozePos["BLACK"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_hei.mp3")
						specWarnOozesLHL:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)	傷害：綠+紅   吸藍!|r") end)
					elseif self.Options.optOozesHB == "optspecWarnOozesHB4" then
						specWarnOozesR:Show()
						DBM.Arrow:ShowRunTo(oozePos["BLUE"][1]/100,oozePos["BLUE"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_lan.mp3")
						specWarnOozesLHH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)	傷害：綠+紅+黑|r") end)
					end
				elseif spellID==105436 then
					if self.Options.optOozesHC == "optspecWarnOozesHC1"  then
						specWarnOozesL:Show()
						DBM.Arrow:ShowRunTo(oozePos["GREEN"][1]/100,oozePos["GREEN"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_lv.mp3")
						specWarnOozesHHH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)   傷害：紅+黃+黑|r") end)
					elseif self.Options.optOozesHC == "optspecWarnOozesHC2" then
						specWarnOozesH:Show()
						DBM.Arrow:ShowRunTo(oozePos["RED"][1]/100,oozePos["RED"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_hong.mp3")
						specWarnOozesLHuH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)   傷害：綠+黃+黑|r") end)
					elseif self.Options.optOozesHC == "optspecWarnOozesHC3" then
						specWarnOozesY:Show()
						DBM.Arrow:ShowRunTo(oozePos["YELLOW"][1]/100,oozePos["YELLOW"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_huang.mp3")
						specWarnOozesLHH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)   傷害：綠+紅+黑|r") end)
					elseif self.Options.optOozesHC == "optspecWarnOozesHC4" then
						specWarnOozesB:Show()
						DBM.Arrow:ShowRunTo(oozePos["BLACK"][1]/100,oozePos["BLACK"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_hei.mp3")
						specWarnOozesLHHu:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)   傷害：綠+紅+黃|r") end)
					end
				elseif spellID==105437 then				
					if self.Options.optOozesHD == "optspecWarnOozesHD1" then
						specWarnOozesL:Show()
						DBM.Arrow:ShowRunTo(oozePos["GREEN"][1]/100,oozePos["GREEN"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_lv.mp3")
						specWarnOozesZLH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：黃   吸藍!|r") end)
					elseif self.Options.optOozesHD == "optspecWarnOozesHD2" then
						specWarnOozesZ:Show()
						DBM.Arrow:ShowRunTo(oozePos["PURPLE"][1]/100,oozePos["PURPLE"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_zi.mp3")
						specWarnOozesLHuL:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)   傷害：綠+黃   吸藍!|r") end)
					elseif self.Options.optOozesHD == "optspecWarnOozesHD3" then
						specWarnOozesY:Show()
						DBM.Arrow:ShowRunTo(oozePos["YELLOW"][1]/100,oozePos["YELLOW"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_huang.mp3")
						specWarnOozesZLL:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：綠   吸藍!|r") end)
					elseif self.Options.optOozesHD == "optspecWarnOozesHD4" then
						specWarnOozesR:Show()
						DBM.Arrow:ShowRunTo(oozePos["BLUE"][1]/100,oozePos["BLUE"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_lan.mp3")
						specWarnOozesLZHu:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：綠+黃|r") end)
					end
				elseif spellID==105439 then
					if self.Options.optOozesHE == "optspecWarnOozesHE1" then
						specWarnOozesY:Show()
						DBM.Arrow:ShowRunTo(oozePos["YELLOW"][1]/100,oozePos["YELLOW"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_huang.mp3")
						specWarnOozesZHL:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：黑   吸藍!|r") end)
					elseif self.Options.optOozesHE == "optspecWarnOozesHE2" then
						specWarnOozesZ:Show()
						DBM.Arrow:ShowRunTo(oozePos["PURPLE"][1]/100,oozePos["PURPLE"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_zi.mp3")
						specWarnOozesHuHL:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)   傷害：黃+黑   吸藍!|r") end)
					elseif self.Options.optOozesHE == "optspecWarnOozesHE3" then
						specWarnOozesB:Show()
						DBM.Arrow:ShowRunTo(oozePos["BLACK"][1]/100,oozePos["BLACK"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_hei.mp3")
						specWarnOozesZLH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：黃   吸藍!|r") end)
					elseif self.Options.optOozesHE == "optspecWarnOozesHE4" then
						specWarnOozesR:Show()
						DBM.Arrow:ShowRunTo(oozePos["BLUE"][1]/100,oozePos["BLUE"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_lan.mp3")
						specWarnOozesZHuH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：黃+黑|r") end)
					end
				elseif spellID==105440 then
					if self.Options.optOozesHF == "optspecWarnOozesHF1" then
						specWarnOozesY:Show()
						DBM.Arrow:ShowRunTo(oozePos["YELLOW"][1]/100,oozePos["YELLOW"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_huang.mp3")
						specWarnOozesZHH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：紅+黑|r") end)
					elseif self.Options.optOozesHF == "optspecWarnOozesHF2" then
						specWarnOozesZ:Show()
						DBM.Arrow:ShowRunTo(oozePos["PURPLE"][1]/100,oozePos["PURPLE"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_zi.mp3")
						specWarnOozesHHH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(正常)   傷害：紅+黃+黑|r") end)
					elseif self.Options.optOozesHF == "optspecWarnOozesHF3" then
						specWarnOozesB:Show()
						DBM.Arrow:ShowRunTo(oozePos["BLACK"][1]/100,oozePos["BLACK"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_hei.mp3")
						specWarnOozesHZH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：紅+黃|r") end)
					elseif self.Options.optOozesHF == "optspecWarnOozesHF4" then
						specWarnOozesH:Show()
						DBM.Arrow:ShowRunTo(oozePos["RED"][1]/100,oozePos["RED"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_hong.mp3")
						specWarnOozesZHuH:Schedule(2)
						self:Schedule(2, function() DEFAULT_CHAT_FRAME:AddMessage("|cffffff00預估戰術：治療(腐化)   傷害：黃+黑|r") end)
					end
				end
			else
				specWarnOozes:Show()
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\killslime.mp3")--軟泥快打
			end
		end
	else
		if oozeColors[spellID] then
			warnOozes:Show(table.concat(oozeColors[spellID], ", "))
			timerOozesActive:Start()
			timerOozesCD:Start()
			table.wipe(oozesHitTable)
			timerVoidBoltCD:Start(42)
			expectedOozes = 3
			sndWOP:Schedule(87, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zbrn.mp3")--準備軟泥
			sndWOP:Schedule(31.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zbrh.mp3")--準備融合
			sndWOP:Schedule(33, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(34, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(35, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
-- 普通模式戰術:
			if self.Options.optspecWarnOoze then
				if spellID==105420 then
					specWarnOozesZ:Show()
					DBM.Arrow:ShowRunTo(oozePos["PURPLE"][1]/100,oozePos["PURPLE"][2]/100,nil,20)
					sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_zi.mp3")
					specWarnOozesLL:Schedule(5)
					self:Schedule(5, showOozesWarningLL2)
				elseif spellID==105435 then
					specWarnOozesL:Show()
					DBM.Arrow:ShowRunTo(oozePos["GREEN"][1]/100,oozePos["GREEN"][2]/100,nil,20)
					sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_lv.mp3")
					specWarnOozesHHe:Schedule(5)
					self:Schedule(5, showOozesWarningHHe2)
				elseif spellID==105436 then
					specWarnOozesL:Show()
					DBM.Arrow:ShowRunTo(oozePos["GREEN"][1]/100,oozePos["GREEN"][2]/100,nil,20)
					sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_lv.mp3")
					specWarnOozesHH:Schedule(5)
					self:Schedule(5, showOozesWarningHH2)
				elseif spellID==105437 then
					specWarnOozesZ:Show()
					DBM.Arrow:ShowRunTo(oozePos["PURPLE"][1]/100,oozePos["PURPLE"][2]/100,nil,20)
					sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_zi.mp3")
					specWarnOozesLH:Schedule(5)
					self:Schedule(5, showOozesWarningLH2)
				elseif spellID==105439 then
					if self.Options.optspecWarnOozes then
						specWarnOozesR:Show()
						DBM.Arrow:ShowRunTo(oozePos["BLUE"][1]/100,oozePos["BLUE"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_lan.mp3")
						specWarnOozesHuH:Schedule(5)
						self:Schedule(5, showOozesWarningR2)
					elseif self.Options.optspecWarnOozes2 then
						specWarnOozesY:Show()
						DBM.Arrow:ShowRunTo(oozePos["YELLOW"][1]/100,oozePos["YELLOW"][2]/100,nil,20)
						sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_huang.mp3")
						specWarnOozesLHe:Schedule(5)
						self:Schedule(5, showOozesWarningR3)
					end
				elseif spellID==105440 then
					specWarnOozesZ:Show()
					DBM.Arrow:ShowRunTo(oozePos["PURPLE"][1]/100,oozePos["PURPLE"][2]/100,nil,20)
					sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_zi.mp3")
					specWarnOozesHHe:Schedule(5)
					self:Schedule(5, showOozesWarningHHe3)
				end
			else
				specWarnOozes:Show()
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\killslime.mp3")--軟泥快打
			end
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 55862 or cid == 55866 or cid == 55865 or cid == 55867 or cid == 55864 or cid == 55863 then--Oozes
		expectedOozes = expectedOozes - 1
	end
end




