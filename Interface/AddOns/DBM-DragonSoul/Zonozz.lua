local mod	= DBM:NewMod(324, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndBJ		= mod:NewSound(nil, "SoundBJ", mod:IsHealer())
local sndXX		= mod:NewSound(nil, "SoundXX", false)

mod:SetRevision(("$Revision: 7105 $"):sub(12, -3))
mod:SetCreatureID(55308)
mod:SetModelID(39138)
mod:SetZone()
mod:SetUsedIcons()
mod:SetModelSound("Sound\\CREATURE\\WarlordZonozz\\VO_DS_ZONOZZ_INTRO_01.wav", "Sound\\CREATURE\\WarlordZonozz\\VO_DS_ZONOZZ_AGGRO_01.wav")

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"UNIT_SPELLCAST_SUCCEEDED",
	"CHAT_MSG_MONSTER_YELL"
)

local warnVoidofUnmaking		= mod:NewSpellAnnounce(103571, 4, 103527) --壞滅虛無
local warnVoidDiffusion			= mod:NewStackAnnounce(106836, 2) --虛無擴散
local warnFocusedAnger			= mod:NewStackAnnounce(104543, 3, nil, false) --匯聚之怒
local warnPsychicDrain			= mod:NewSpellAnnounce(104322, 4) --心靈吸取
local warnShadows				= mod:NewSpellAnnounce(103434, 3) --崩解之影

local specWarnVoidofUnmaking	= mod:NewSpecialWarningSpell(103571)
local specWarnBlackBlood		= mod:NewSpecialWarningSpell(104378)
local specWarnPsychicDrain		= mod:NewSpecialWarningSpell(104322, false)
local specWarnShadows			= mod:NewSpecialWarningYou(103434)
local yellShadows				= mod:NewYell(103434, nil, false, L.ShadowYell)--Requested by 10 man guilds, but a spammy mess in 25s, so off by default. With the option to enable when desired.

local timerVoidofUnmakingCD		= mod:NewCDTimer(90.3, 103571, nil, nil, nil, 103527)
local timerVoidDiffusionCD		= mod:NewCDTimer(5, 106836)--Can not be triggered more then once per 5 seconds.
local timerFocusedAngerCD		= mod:NewCDTimer(6, 104543, nil, false)--Off by default as it may not be entirely useful information to know, but an option just for heck of it. You know SOMEONE is gonna request it
local timerPsychicDrainCD		= mod:NewCDTimer(20, 104322)--Every 20-25 seconds, variates.
local timerShadowsCD			= mod:NewCDTimer(25, 103434)--Every 25-30, variates
local timerBlackBlood			= mod:NewBuffActiveTimer(30, 104378)

local berserkTimer				= mod:NewBerserkTimer(360)
local spamBJ = 0

mod:AddDropdownOption("CustomRangeFrame", {"Never", "Normal", "DynamicPhase2", "DynamicAlways"}, "DynamicAlways", "misc")

local shadowsTargets = {}
local phase2Started = false
local voidWarned = false
local voidStacks = 0

local function warnShadowsTargets()
	warnShadows:Show(table.concat(shadowsTargets, "<, >"))
	timerShadowsCD:Start()
	table.wipe(shadowsTargets)
end

local shadowsDebuffFilter
do
	shadowsDebuffFilter = function(uId)
		return UnitDebuff(uId, (GetSpellInfo(103434)))
	end
end

--"Never", "Normal", "DynamicPhase2", "DynamicAlways"
function mod:updateRangeFrame()
	if self:IsDifficulty("normal10", "normal25", "lfr25") or self.Options.CustomRangeFrame == "Never" then return end
	if self.Options.CustomRangeFrame == "Normal" or UnitDebuff("player", GetSpellInfo(103434)) or self.Options.CustomRangeFrame == "DynamicPhase2" and not phase2started then--You have debuff or only want normal range frame or it's phase 1 and you only want dymanic in phase 2
		DBM.RangeCheck:Show(10, nil)--Show everyone.
	else
		DBM.RangeCheck:Show(10, shadowsDebuffFilter)--Show only people who have debuff.
	end
end

local function blackBloodEnds()
	voidWarned = false
	phase2Started = false
	timerFocusedAngerCD:Start(6)
	timerShadowsCD:Start(6)
end

function mod:OnCombatStart(delay)
	voidWarned = false
	phase2Started = false
	voidStacks = 0
	table.wipe(shadowsTargets)
	timerVoidofUnmakingCD:Start(5.5-delay)
	timerFocusedAngerCD:Start(10.5-delay)
	timerPsychicDrainCD:Start(16.5-delay)
	sndXX:Schedule(12, "Interface\\AddOns\\DBM-Core\\extrasounds\\threetwone.mp3")
	timerShadowsCD:Start(-delay)
	self:updateRangeFrame()
	if not self:IsDifficulty("lfr25") then--Can confirm what others saw, LFR definitely doesn't have a 6 min berserk. It's either much longer or not there.
		berserkTimer:Start(-delay)
	end
end

function mod:OnCombatEnd()
	if self.Options.CustomRangeFrame ~= "Never" then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(104322, 104606, 104607, 104608) then
		warnPsychicDrain:Show()
		specWarnPsychicDrain:Show()
		timerPsychicDrainCD:Start()
		sndXX:Schedule(17.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\threetwone.mp3")
		if mod:IsHealer() or mod:IsTank() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_xlxs.mp3")--心靈吸取
		end
	end
end	

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(104377, 104378, 110322, 110306) and not phase2Started then
		phase2Started = true
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ptwo.mp3")--2階段準備
		sndWOP:Schedule(25, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
		sndWOP:Schedule(26, "Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		sndWOP:Schedule(27, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Schedule(28, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Schedule(29, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		sndWOP:Schedule(30, "Interface\\AddOns\\DBM-Core\\extrasounds\\phasechange.mp3")--階段轉換
		timerFocusedAngerCD:Cancel()
		timerPsychicDrainCD:Cancel()
		sndXX:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\threetwone.mp3")
		timerShadowsCD:Cancel()
		specWarnBlackBlood:Show()
		timerBlackBlood:Start()
		self:Schedule(30, blackBloodEnds)--More accurate way then tracking spell aura removed of black blood. Players dying in the phase were falsely triggering the phase ending early.
		--GetTime() Method returns elapsed values. so this will be working intended?
		if self:IsDifficulty("heroic10", "heroic25") then
			if timerVoidofUnmakingCD:GetTime() > 45.3 then--Heroic has a failsafe in place, if CD exausts before 15 seconds after black phase ending, it's extended, probably to allow raid more time to repositoin vs normal
				timerVoidofUnmakingCD:Update(45.3, 90.3)
			end
		else
			if timerVoidofUnmakingCD:GetTime() > 54.3 then--Normal also has a failsafe but much smaller, if it comes off CD before 6 seconds has passed after dark, it gets delayed until 6 seconds have passed
				timerVoidofUnmakingCD:Update(54.3, 90.3)
			end
		end
	elseif args:IsSpellID(104543, 109409, 109410, 109411) then
		warnFocusedAnger:Show(args.destName, args.amount or 1)
		timerFocusedAngerCD:Start()
	elseif args:IsSpellID(106836) then--106836 confirmed 10/25 man normal, do NOT add 103527 to this, that's a seperate spellid for when BOSS is affected by diffusion, this warning is counting the ball stacks.
		warnVoidDiffusion:Show(args.destName, args.amount or 1)
		timerVoidDiffusionCD:Start()
		if voidStacks < 11 then
			voidStacks = voidStacks + 1
		end
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_zq.mp3")--撞球
		if voidStacks==1 then
			sndWOP:Schedule(0.4, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		elseif voidStacks==2 then
			sndWOP:Schedule(0.4,"Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		elseif voidStacks==3 then
			sndWOP:Schedule(0.4,"Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		elseif voidStacks==4 then
			sndWOP:Schedule(0.4,"Interface\\AddOns\\DBM-Core\\extrasounds\\countfour.mp3")
		elseif voidStacks==5 then
			sndWOP:Schedule(0.4,"Interface\\AddOns\\DBM-Core\\extrasounds\\countfive.mp3")
		elseif voidStacks==6 then
			sndWOP:Schedule(0.4,"Interface\\AddOns\\DBM-Core\\extrasounds\\countsix.mp3")
		elseif voidStacks==7 then
			sndWOP:Schedule(0.4,"Interface\\AddOns\\DBM-Core\\extrasounds\\countseven.mp3")
		elseif voidStacks==8 then
			sndWOP:Schedule(0.4,"Interface\\AddOns\\DBM-Core\\extrasounds\\counteight.mp3")
		elseif voidStacks==9 then
			sndWOP:Schedule(0.4,"Interface\\AddOns\\DBM-Core\\extrasounds\\countnine.mp3")
		elseif voidStacks==10 then
			sndWOP:Schedule(0.4,"Interface\\AddOns\\DBM-Core\\extrasounds\\countten.mp3")
		end
	elseif args:IsSpellID(103434, 104599, 104600, 104601) and GetTime() - spamBJ > 2 then
		shadowsTargets[#shadowsTargets + 1] = args.destName
		spamBJ = GetTime()
		if mod:IsDifficulty("heroic10", "heroic25") then
			if args:IsPlayer() then
				specWarnShadows:Show()
				self:updateRangeFrame()
				yellShadows:Yell()
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_bjzy.mp3")--崩解之影
			else
				sndBJ:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_bjzy.mp3")--崩解之影
			end
		else
			sndBJ:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_kqs.mp3")--快驅散
		end
		self:Unschedule(warnShadowsTargets)
		if (self:IsDifficulty("normal10") and #shadowsTargets >= 3) then--Don't know the rest yet, will tweak as they are discovered
			warnShadowsTargets()
		else
			self:Schedule(0.3, warnShadowsTargets)
		end
	end
end		
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(104600, 104601) and args:IsPlayer() then--Only heroic spellids here, no reason to call functions that aren't needed on normal or LFR
		self:updateRangeFrame()
	end
end

--It looks this event doesn't fire in raid finder. It seems to still fire in normal and heroic modes.
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, spellName, _, _, spellID)
	if uId ~= "boss1" then return end--Anti spam to ignore all other args (like target/focus/mouseover)
	--Void of the unmaking cast, do not use spellname because we want to ignore events using spellid 103627 which fires when the sphere dispurses on the boss.
	if spellID == 103571 and not voidWarned then--This spellid is same in 10/25 and raid finder, and assuming also same in heroic. No reason to use spellname, or other IDs.
		if timerPsychicDrainCD:GetTime() == 0 then--Just a hack to prevent this from overriding first timer on pull, which is only drain that doesn't follow this rule
			timerPsychicDrainCD:Start(8.5)
			sndXX:Schedule(5.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\threetwone.mp3")
		end
		timerVoidofUnmakingCD:Start()
		voidWarned = true
		warnVoidofUnmaking:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_gqcx.mp3")--光球出現
		specWarnVoidofUnmaking:Show()
		voidStacks = 0
	end
end

--"<10.8> [UNIT_SPELLCAST_SUCCEEDED] Warlord Zon'ozz:Possible Target<Erej>:boss1:Void of the Unmaking::0:103571", -- [371]
--"<11.0> [CHAT_MSG_MONSTER_YELL] CHAT_MSG_MONSTER_YELL#Gul'kafh an'qov N'Zoth.#Warlord Zon'ozz###Warlord Zon'ozz##0#0##0#3201##0#false", -- [413]
--Backup trigger for LFR where UNIT_SPELLCAST_SUCCEEDED doesn't fire for void cast
function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L.voidYell or msg:find(L.voidYell)) and not voidWarned then
		if timerPsychicDrainCD:GetTime() == 0 then
			timerPsychicDrainCD:Start(8.3)--Yell comes .2 after unit event, so we adjust the timers.
			sndXX:Schedule(5.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\threetwone.mp3")
		end
		timerVoidofUnmakingCD:Start(90.1)
		voidWarned = true
		warnVoidofUnmaking:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_ds_gqcx.mp3")--光球出現
		specWarnVoidofUnmaking:Show()
		voidStacks = 0
	end
end