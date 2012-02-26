-- -------------------------------------------------------------------------- --
--                            DrainSouler by kunda                            --
-- -------------------------------------------------------------------------- --
--                                                                            --
-- DrainSouler shows a frame with all data you need to know for Drain Soul.   --
--                                                                            --
-- Features:                                                                  --
-- # Display:                                                                 --
--   - Frame: Default size: 90x22px                                           --
--   - Frame: Movable & scalable (via Configuration)                          --
--   - Frame: Click through ('Lock' via Configuration)                        --
--   - HP (in percent)                                                        --
--   - Icon (visible if target HP is below 25%)                               --
--   - TickTimer (a progress bar that indicates when the next Drain Soul Tick --
--     is expected)                                                           --
--   - Tick (the number of damage ticks since caststart)                      --
--   - DMG (Drain Soul damage from last tick)                                 --
-- # Sound: (DISABLED by DEFAULT)                                             --
--   - TickSound (plays a sound when Drain Soul dealt damage)                 --
--   - 25% Sound (plays a sound when target HP is below 25%)                  --
-- # Resource friendly:                                                       --
--   - CPU/Memory resources are only used when you login with a WARLOCK       --
--   - CombatLog events are only used when needed (register/unregister)       --
--                                                                            --
-- Configuration:                                                             --
-- # If you log in the first time the 'Configuration' is enabled!             --
--   Click 'Close Configuration' to finish.                                   --
-- # 'ESC -> Interface -> AddOns -> DrainSouler' to change options!           --
--                                                                            --
-- -------------------------------------------------------------------------- --
--                                                                            --
-- Some Technical Notes:                                                      --
--                                                                            --
-- The base channel time for Drain Soul is 15000ms. A tick (without break) is --
-- expected every 3000ms. The duration between ticks depends on spell         --
-- duration, which is mainly 'Haste' dependent.                               --
--                                                                            --
-- This TickTimer data is saved in an internal table that looks like:         --
--                                                                            --
--   dsDif  = difference between endTime and startTime = spell duration       --
--   dsTick = number of ticks (dmg) since cast start (0 to n)                 --
--                                                                            --
--   dsTimeTable[ dsDif ][ dsTick ]                                           --
--     .brk  = break (true = bcnt/bavg is used | false = ncnt/navg is used)   --
--     .bcnt = break count (total number of breaks)                           --
--     .bavg = average time of this break fragment                            --
--     .ncnt = normal count (total number of all normal rounds)               --
--     .navg = average time of this normal fragment                           --
--                                                                            --
-- To avoid a massive SavedVariables file these values are calculated newly   --
-- in every WoW session! The more often you cast Drain Soul the better is the --
-- predict for the next tick.                                                 --
-- BUT REMEMBER: The TickTimer data is an average, based on YOUR combatlog    --
--               data.                                                        --
--                                                                            --
-- TickTimer Color:                                                           --
-- grey       = first time this dsDif/dsTick is detected (default: 3000ms)    --
-- light blue = this dsDif/dsTick has at least 2 records                      --
--                                                                            --
-- -------------------------------------------------------------------------- --

-- -------------------------------------------------------------------------- --
--                                    STOP                                    --
--                 You must be a Warlock to enter this code.                  --
--                  If you are not a Warlock please leave.                    --
        if select(2, UnitClass("player")) ~= "WARLOCK" then return end          
-- -------------------------------------------------------------------------- --

-- ---------------------------------------------------------------------------------------------------------------------
DrainSouler_Options = {
	["posX"] = 610,
	["posY"] = 680,
}                 -- SavedVariable options table

local DrainSouler = CreateFrame("Frame") -- event container
local L = DrainSouler_Locales            -- localization table

local GVAR = {}                          -- UI Widgets
local TEMPLATE = {}                      -- Templates

local _G              = _G
local GetTime         = _G.GetTime
local UnitExists      = _G.UnitExists
local UnitGUID        = _G.UnitGUID
local UnitHealth      = _G.UnitHealth
local UnitHealthMax   = _G.UnitHealthMax
local UnitChannelInfo = _G.UnitChannelInfo
local math_floor      = _G.math.floor

local mult2 = 10^(2 or 0)
local inCombat
local PlayerGUID
local DrainSoulName, _, DrainSoulIcon = GetSpellInfo(1120)

local loginCheck
local configMode
local isAffliction
local talentNames = {}
local talentNamesEN = {
	[1] = "Affliction",
	[2] = "Demonology",
	[3] = "Destruction",
}

local mobTable = {}
local dsTimeTable = {}
local dsTick = 0
local dsDif = 0
local dsDuration
local dsStart
local dsIsActive

local sizeTimerWidth = 68
local sizeOffset     = 5
local sizeBarHeight  = 12

local function rt(H,E,M,P) return E,P,E,M,H,P,H,M end -- magical 180 degree texture cut center rotation

local Textures = {
	DrainSoulerIcons = {path       = "Interface\\Addons\\DrainSouler\\DrainSouler-texture-icons.tga"}, -- Textures.DrainSoulerIcons.path
	SliderKnob       = {coords     =    { 19/64, 36/64,  8/32, 25/32}},
	SliderBG         = {coordsL    =    { 19/64, 24/64,  1/32,  7/32},
	                    coordsM    =    { 27/64, 28/64,  1/32,  7/32},
	                    coordsR    =    { 31/64, 36/64,  1/32,  7/32},
	                    coordsLdis =    {  1/64,  6/64,  1/32,  7/32},
	                    coordsMdis =    {  9/64, 10/64,  1/32,  7/32},
	                    coordsRdis =    { 13/64, 18/64,  1/32,  7/32}},
	Expand           = {coords     =    {  1/64, 18/64,  8/32, 25/32}},
	Collapse         = {coords     = {rt(  1/64, 18/64,  8/32, 25/32)}}, -- 180 degree rota
}

local soundsTick = {
	[1] = {name = L["No Sound"]},
	[2] = {name = "Beep1 (0.076)",  path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound-beep1.ogg"},
	[3] = {name = "Beep2 (0.043)",  path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound-beep2.ogg"},
	[4] = {name = "Beep3 (0.104)",  path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound-beep3.ogg"},
	[5] = {name = "Deek (0.069)",   path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound-deek.ogg"},
	[6] = {name = "Bump (0.134)",   path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound-bump.ogg"},
	[7] = {name = "Phaser (0.162)", path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound-phaser.ogg"},
	[8] = {name = "Space (0.471)",  path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound-space.ogg"}
}
local soundsTwentyFive = {
	[1]  = {name = L["No Sound"]},
	[2]  = {name = "Alarm1 (0.923)",    path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound25p-alarm1.ogg"},
	[3]  = {name = "Alarm2 (0.365)",    path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound25p-alarm2.ogg"},
	[4]  = {name = "Alarm3 (0.940)",    path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound25p-alarm3.ogg"},
	[5]  = {name = "Bmmmmmm (0.616)",   path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound25p-bmmmmmm.ogg"},
	[6]  = {name = "Dingding (0.885)",  path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound25p-dingding.ogg"},
	[7]  = {name = "Electro (0.473)",   path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound25p-electro.ogg"},
	[8]  = {name = "Horn (0.583)",      path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound25p-horn.ogg"},
	[9]  = {name = "Radarping (0.819)", path = "Interface\\Addons\\DrainSouler\\DrainSouler-sound25p-radarping.ogg"}
}
local soundChannel = {
	[1] = {channel = "Master",   name = MASTER_VOLUME},  -- Master
	[2] = {channel = "SFX",      name = SOUND_VOLUME},   -- SFX
	[3] = {channel = "Music",    name = MUSIC_VOLUME},   -- Music
	[4] = {channel = "Ambience", name = AMBIENCE_VOLUME} -- Ambience
}
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local function NOOP() end

local function SizeSliderFunc(self, value)
	DrainSouler_Options.Size = value/100
	GVAR.OptionsFrame.Size:SetValue(DrainSouler_Options.Size*100)
	GVAR.OptionsFrame.SizeTitle:SetText(L["Size"]..": |cffffff99"..(DrainSouler_Options.Size*100).."%|r")
	DrainSouler:SetupSize()
end

local function minHPSliderFunc(self, value)
	DrainSouler_Options.minHP = value
	GVAR.OptionsFrame.minHP:SetValue(DrainSouler_Options.minHP)
	GVAR.OptionsFrame.minHPTitle:SetText(L["Target HP"]..": |cffffff99"..(DrainSouler_Options.minHP/1000).."K|r")
	GVAR.OptionsFrame.minHPDescription:SetText( string.format(L["Shows DrainSouler if maximum target HP is greater than %s."], "|cffffff99"..(DrainSouler_Options.minHP/1000).."K|r") )
end

local function minHPPSliderFunc(self, value)
	DrainSouler_Options.minHPP = value
	GVAR.OptionsFrame.minHPP:SetValue(DrainSouler_Options.minHPP)
	GVAR.OptionsFrame.minHPPTitle:SetText(L["Target HP (in percent)"]..": |cffffff99"..DrainSouler_Options.minHPP.."%|r")
	GVAR.OptionsFrame.minHPPDescription:SetText( string.format(L["Shows DrainSouler if target HP (in percent) is less or equal %s."], "|cffffff99"..DrainSouler_Options.minHPP.."%|r") )
end

local function TickSoundPullDownFunc(value)
	DrainSouler_Options.TickSound = value
	GVAR.OptionsFrame.TickSoundTitle:SetText(L["TickSound"]..": |cffffff99"..soundsTick[DrainSouler_Options.TickSound].name.."|r")
	if DrainSouler_Options.TickSound > 1 then
		TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TickSoundChannelPullDown)
		GVAR.OptionsFrame.TickSoundChannelTitle:SetTextColor(1, 1, 1, 1)
		PlaySoundFile(soundsTick[value].path, soundChannel[DrainSouler_Options.TickSoundChannel].channel)
	else
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.TickSoundChannelPullDown)
		GVAR.OptionsFrame.TickSoundChannelTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	end
end

local function TickSoundChannelPullDownFunc(value)
	DrainSouler_Options.TickSoundChannel = value
	if DrainSouler_Options.TickSound > 1 then
		PlaySoundFile(soundsTick[DrainSouler_Options.TickSound].path, soundChannel[DrainSouler_Options.TickSoundChannel].channel)
	end
end

local function TwentyFiveSoundPullDownFunc(value)
	DrainSouler_Options.TwentyFiveSound = value
	GVAR.OptionsFrame.TwentyFiveSoundTitle:SetText(L["25% HP Sound"]..": |cffffff99"..soundsTwentyFive[DrainSouler_Options.TwentyFiveSound].name.."|r")
	if DrainSouler_Options.TwentyFiveSound > 1 then
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.TwentyFiveSoundHP)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.TwentyFiveSoundHPP)
		GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetTextColor(1, 1, 1, 1)
		GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetTextColor(1, 1, 1, 1)
		GVAR.OptionsFrame.TwentyFiveSoundDescription:SetTextColor(0.6, 0.6, 0.6, 1)
		GVAR.OptionsFrame.TwentyFiveSoundDescription:SetText( string.format(L["Plays a sound when your target is below %s HP and maximum HP is greater than %s."], "|cffffff99"..DrainSouler_Options.TwentyFiveSoundHPP.."%|r", "|cffffff99"..(DrainSouler_Options.TwentyFiveSoundHP/1000).."K|r") )
		GVAR.OptionsFrame.TwentyFiveSoundWarning:SetTextColor(0.73, 0.26, 0.21, 1)
		TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown)
		GVAR.OptionsFrame.TwentyFiveSoundChannelTitle:SetTextColor(1, 1, 1, 1)
		PlaySoundFile(soundsTwentyFive[value].path, soundChannel[DrainSouler_Options.TwentyFiveSoundChannel].channel)
	else
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.TwentyFiveSoundHP)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.TwentyFiveSoundHPP)
		GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.OptionsFrame.TwentyFiveSoundDescription:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.OptionsFrame.TwentyFiveSoundDescription:SetText( string.format(L["Plays a sound when your target is below %s HP and maximum HP is greater than %s."], "|cffffff99"..DrainSouler_Options.TwentyFiveSoundHPP.."%|r", "|cffffff99"..(DrainSouler_Options.TwentyFiveSoundHP/1000).."K|r") )
		GVAR.OptionsFrame.TwentyFiveSoundWarning:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown)
		GVAR.OptionsFrame.TwentyFiveSoundChannelTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	end
end

local function TwentyFiveSoundChannelPullDownFunc(value)
	DrainSouler_Options.TwentyFiveSoundChannel = value
	if DrainSouler_Options.TwentyFiveSound > 1 then
		PlaySoundFile(soundsTwentyFive[DrainSouler_Options.TwentyFiveSound].path, soundChannel[DrainSouler_Options.TwentyFiveSoundChannel].channel)
	end
end

local function TwentyFiveSoundHPSliderFunc(self, value)
	DrainSouler_Options.TwentyFiveSoundHP = value
	GVAR.OptionsFrame.TwentyFiveSoundHP:SetValue(DrainSouler_Options.TwentyFiveSoundHP)
	GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetText("25% "..L["Target HP"]..": |cffffff99"..(DrainSouler_Options.TwentyFiveSoundHP/1000).."K|r")
	GVAR.OptionsFrame.TwentyFiveSoundDescription:SetText( string.format(L["Plays a sound when your target is below %s HP and maximum HP is greater than %s."], "|cffffff99"..DrainSouler_Options.TwentyFiveSoundHPP.."%|r", "|cffffff99"..(DrainSouler_Options.TwentyFiveSoundHP/1000).."K|r") )
end

local function TwentyFiveSoundHPPSliderFunc(self, value)
	DrainSouler_Options.TwentyFiveSoundHPP = value
	GVAR.OptionsFrame.TwentyFiveSoundHPP:SetValue(DrainSouler_Options.TwentyFiveSoundHPP)
	GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetText("25% "..L["Target HP (in percent)"]..": |cffffff99"..DrainSouler_Options.TwentyFiveSoundHPP.."%|r")
	GVAR.OptionsFrame.TwentyFiveSoundDescription:SetText( string.format(L["Plays a sound when your target is below %s HP and maximum HP is greater than %s."], "|cffffff99"..DrainSouler_Options.TwentyFiveSoundHPP.."%|r", "|cffffff99"..(DrainSouler_Options.TwentyFiveSoundHP/1000).."K|r") )
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
-- Template BorderTRBL START ----------------------------------------
TEMPLATE.BorderTRBL = function(frame, color) -- TRBL = Top-Right-Bottom-Left
	frame.FrameBorder = frame:CreateTexture(nil, "BORDER")
	frame.FrameBorder:SetPoint("TOPLEFT", 1, -1)
	frame.FrameBorder:SetPoint("BOTTOMRIGHT", -1, 1)
	frame.FrameBorder:SetTexture(0, 0, 0, 1)
	frame.FrameBackground = frame:CreateTexture(nil, "BACKGROUND")
	frame.FrameBackground:SetPoint("TOPLEFT", 0, 0)
	frame.FrameBackground:SetPoint("BOTTOMRIGHT", 0, 0)
	frame.FrameBackground:SetTexture(0.8, 0.2, 0.2, 1)
end
-- Template BorderTRBL END ----------------------------------------

-- Template TextButton START ----------------------------------------
TEMPLATE.DisableTextButton = function(button)
	button.Border:SetTexture(0.4, 0.4, 0.4, 1)
	button:Disable()
end

TEMPLATE.EnableTextButton = function(button, action)
	local buttoncolor
	if action == 1 then
		bordercolor = {0.73, 0.26, 0.21, 1}
	elseif action == 2 then
		bordercolor = {0.43, 0.32, 0.68, 1}
	elseif action == 3 then
		bordercolor = {0.24, 0.46, 0.21, 1}
	else
		bordercolor = {1, 1, 1, 1}
	end
	button.Border:SetTexture(bordercolor[1], bordercolor[2], bordercolor[3], bordercolor[4])
	button:Enable()
end

TEMPLATE.TextButton = function(button, text, action)
	local buttoncolor
	local bordercolor
	if action == 1 then
		button:SetNormalFontObject("GameFontNormal")
		button:SetDisabledFontObject("GameFontDisable") 
		buttoncolor = {0.38, 0, 0, 1}
		bordercolor = {0.73, 0.26, 0.21, 1}
	elseif action == 2 then
		button:SetNormalFontObject("GameFontWhiteSmall")
		button:SetDisabledFontObject("GameFontDisableSmall")
		buttoncolor = {0, 0, 0.5, 1}
		bordercolor = {0.43, 0.32, 0.68, 1}
	elseif action == 3 then
		button:SetNormalFontObject("GameFontWhiteSmall")
		button:SetDisabledFontObject("GameFontDisableSmall")
		buttoncolor = {0, 0.2, 0, 1}
		bordercolor = {0.24, 0.46, 0.21, 1}
	else
		button:SetNormalFontObject("GameFontNormal")
		button:SetDisabledFontObject("GameFontDisable")
		buttoncolor = {0, 0, 0, 1}
		bordercolor = {1, 1, 1, 1}
	end

	button.Background = button:CreateTexture(nil, "BORDER")
	button.Background:SetPoint("TOPLEFT", 1, -1)
	button.Background:SetPoint("BOTTOMRIGHT", -1, 1)
	button.Background:SetTexture(0, 0, 0, 1)

	button.Border = button:CreateTexture(nil, "BACKGROUND")
	button.Border:SetPoint("TOPLEFT", 0, 0)
	button.Border:SetPoint("BOTTOMRIGHT", 0, 0)
	button.Border:SetTexture(bordercolor[1], bordercolor[2], bordercolor[3], bordercolor[4])

	button.Normal = button:CreateTexture(nil, "ARTWORK")
	button.Normal:SetPoint("TOPLEFT", 2, -2)
	button.Normal:SetPoint("BOTTOMRIGHT", -2, 2)
	button.Normal:SetTexture(buttoncolor[1], buttoncolor[2], buttoncolor[3], buttoncolor[4])
	button:SetNormalTexture(button.Normal)

	button.Disabled = button:CreateTexture(nil, "OVERLAY")
	button.Disabled:SetPoint("TOPLEFT", 3, -3)
	button.Disabled:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Disabled:SetTexture(0.6, 0.6, 0.6, 0.2)
	button:SetDisabledTexture(button.Disabled)

	button.Highlight = button:CreateTexture(nil, "OVERLAY")
	button.Highlight:SetPoint("TOPLEFT", 3, -3)
	button.Highlight:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Highlight:SetTexture(0.6, 0.6, 0.6, 0.2)
	button:SetHighlightTexture(button.Highlight)

	button:SetPushedTextOffset(1, -1)	
	button:SetText(text)
end
-- Template TextButton END ----------------------------------------

-- Template CheckButton START ----------------------------------------
TEMPLATE.DisableCheckButton = function(button)
	button.Text:SetTextColor(0.5, 0.5, 0.5)
	button.Border:SetTexture(0.4, 0.4, 0.4, 1)
	button:Disable()
end

TEMPLATE.EnableCheckButton = function(button)
	button.Text:SetTextColor(1, 1, 1)
	button.Border:SetTexture(0.8, 0.2, 0.2, 1)
	button:Enable()
end

TEMPLATE.CheckButton = function(button, size, space, text)
	button.Border = button:CreateTexture(nil, "BACKGROUND")
	button.Border:SetWidth( size )
	button.Border:SetHeight( size )
	button.Border:SetPoint("LEFT", 0, 0)
	button.Border:SetTexture(0.4, 0.4, 0.4, 1)

	button.Background = button:CreateTexture(nil, "BORDER")
	button.Background:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 1, -1)
	button.Background:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -1, 1)
	button.Background:SetTexture(0, 0, 0, 1)

	button.Normal = button:CreateTexture(nil, "ARTWORK")
	button.Normal:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 1, -1)
	button.Normal:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -1, 1)
	button.Normal:SetTexture(0, 0, 0, 1)
	button:SetNormalTexture(button.Normal)

	button.Push = button:CreateTexture(nil, "ARTWORK")
	button.Push:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 4, -4)
	button.Push:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -4, 4)
	button.Push:SetTexture(0.4, 0.4, 0.4, 0.5)
	button:SetPushedTexture(button.Push)

	button.Disabled = button:CreateTexture(nil, "ARTWORK")
	button.Disabled:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 3, -3)
	button.Disabled:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -3, 3)
	button.Disabled:SetTexture(0.4, 0.4, 0.4, 0.5)
	button:SetDisabledTexture(button.Disabled)

	button.Checked = button:CreateTexture(nil, "ARTWORK")
	button.Checked:SetWidth( size )
	button.Checked:SetHeight( size )
	button.Checked:SetPoint("LEFT", 0, 0)
	button.Checked:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	button:SetCheckedTexture(button.Checked)

	button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	button.Text:SetHeight( size )
	button.Text:SetPoint("LEFT", button.Normal, "RIGHT", space, 0)
	button.Text:SetJustifyH("LEFT")
	button.Text:SetText(text)
	button.Text:SetTextColor(1, 1, 1, 1)

	button:SetWidth(size + space + button.Text:GetStringWidth() + space)
	button:SetHeight(size)

	button.Highlight = button:CreateTexture(nil, "OVERLAY")
	button.Highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.Highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	button.Highlight:SetTexture(1, 1, 1, 0.1)
	button.Highlight:Hide()

	button:SetScript("OnEnter", function() button.Highlight:Show() end)
	button:SetScript("OnLeave", function() button.Highlight:Hide() end)
end
-- Template CheckButton END ----------------------------------------

-- Template PullDownMenu START ----------------------------------------
TEMPLATE.DisablePullDownMenu = function(button)
	button.PullDownButtonBorder:SetTexture(0.4, 0.4, 0.4, 1)
	button:Disable()
end

TEMPLATE.EnablePullDownMenu = function(button)
	button.PullDownButtonBorder:SetTexture(0.8, 0.2, 0.2, 1)
	button:Enable()
end

TEMPLATE.PullDownMenu = function(button, contentName, buttonText, pulldownWidth, contentNum, func)
	button.PullDownButtonBG = button:CreateTexture(nil, "BORDER")
	button.PullDownButtonBG:SetPoint("TOPLEFT", 1, -1)
	button.PullDownButtonBG:SetPoint("BOTTOMRIGHT", -1, 1)
	button.PullDownButtonBG:SetTexture(0, 0, 0, 1)

	button.PullDownButtonBorder = button:CreateTexture(nil, "BACKGROUND")
	button.PullDownButtonBorder:SetPoint("TOPLEFT", 0, 0)
	button.PullDownButtonBorder:SetPoint("BOTTOMRIGHT", 0, 0)
	button.PullDownButtonBorder:SetTexture(0.4, 0.4, 0.4, 1)

	button.PullDownButtonNormal = button:CreateTexture(nil, "ARTWORK")
	button.PullDownButtonNormal:SetPoint("TOPLEFT", 2, -2)
	button.PullDownButtonNormal:SetPoint("BOTTOMRIGHT", -2, 2)
	button.PullDownButtonNormal:SetTexture(0, 0, 0, 1)

	button.PullDownButtonExpand = button:CreateTexture(nil, "ARTWORK")
	button.PullDownButtonExpand:SetHeight(16)
	button.PullDownButtonExpand:SetWidth(16)
	button.PullDownButtonExpand:SetPoint("RIGHT", button, "RIGHT", -2, 0)
	button.PullDownButtonExpand:SetTexture(Textures.DrainSoulerIcons.path)
	button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand.coords))
	button:SetNormalTexture(button.PullDownButtonExpand)

	button.PullDownButtonDisabled = button:CreateTexture(nil, "OVERLAY")
	button.PullDownButtonDisabled:SetPoint("TOPLEFT", 3, -3)
	button.PullDownButtonDisabled:SetPoint("BOTTOMRIGHT", -3, 3)
	button.PullDownButtonDisabled:SetTexture(0.6, 0.6, 0.6, 0.2)
	button:SetDisabledTexture(button.PullDownButtonDisabled)

	button.PullDownButtonHighlight = button:CreateTexture(nil, "OVERLAY")
	button.PullDownButtonHighlight:SetPoint("TOPLEFT", 1, -1)
	button.PullDownButtonHighlight:SetPoint("BOTTOMRIGHT", -1, 1)
	button.PullDownButtonHighlight:SetTexture(0.6, 0.6, 0.6, 0.2)
	button:SetHighlightTexture(button.PullDownButtonHighlight)

	button.PullDownButtonText = button:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	button.PullDownButtonText:SetWidth(pulldownWidth-sizeOffset-sizeOffset)
	button.PullDownButtonText:SetHeight(sizeBarHeight)
	button.PullDownButtonText:SetPoint("LEFT", sizeOffset+2, 0)
	button.PullDownButtonText:SetJustifyH("LEFT")
	button.PullDownButtonText:SetText(buttonText)
	--button.PullDownButtonText:SetTextColor(1, 1, 0.5, 1)

	button.PullDownMenu = CreateFrame("Frame", nil, button)
	TEMPLATE.BorderTRBL(button.PullDownMenu)
	button.PullDownMenu:EnableMouse(true)
	button.PullDownMenu:SetToplevel(true)
	button.PullDownMenu:SetWidth(pulldownWidth)
	button.PullDownMenu:SetHeight(sizeOffset+(contentNum*sizeBarHeight)+sizeOffset)
	button.PullDownMenu:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, 1)
	button.PullDownMenu:Hide()

	local function OnLeave()
		if not button:IsMouseOver() and not button.PullDownMenu:IsMouseOver() then
			button.PullDownMenu:Hide()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand.coords))
		end
	end

	for i = 1, contentNum do
		if not button.PullDownMenu.Button then button.PullDownMenu.Button = {} end
		button.PullDownMenu.Button[i] = CreateFrame("Button", nil, button.PullDownMenu)
		button.PullDownMenu.Button[i]:SetWidth(pulldownWidth-sizeOffset-sizeOffset)
		button.PullDownMenu.Button[i]:SetHeight(sizeBarHeight)
		button.PullDownMenu.Button[i]:SetFrameLevel( button.PullDownMenu:GetFrameLevel() + 5 )
		if i == 1 then
			button.PullDownMenu.Button[i]:SetPoint("TOPLEFT", button.PullDownMenu, "TOPLEFT", sizeOffset, -sizeOffset)
		else
			button.PullDownMenu.Button[i]:SetPoint("TOPLEFT", button.PullDownMenu.Button[(i-1)], "BOTTOMLEFT", 0, 0)
		end

		button.PullDownMenu.Button[i].Text = button.PullDownMenu.Button[i]:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
		button.PullDownMenu.Button[i].Text:SetWidth(pulldownWidth-sizeOffset-sizeOffset)
		button.PullDownMenu.Button[i].Text:SetHeight(sizeBarHeight)
		button.PullDownMenu.Button[i].Text:SetPoint("LEFT", 2, 0)
		button.PullDownMenu.Button[i].Text:SetJustifyH("LEFT")

		button.PullDownMenu.Button[i]:SetScript("OnLeave", OnLeave)
		button.PullDownMenu.Button[i]:SetScript("OnClick", function()
			button.value1 = button.PullDownMenu.Button[i].value1
			button.PullDownButtonText:SetText( button.PullDownMenu.Button[i].Text:GetText() )
			button.PullDownMenu:Hide()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand.coords))
			if func then
				func(button.value1)
			end
		end)

		button.PullDownMenu.Button[i].Highlight = button.PullDownMenu.Button[i]:CreateTexture(nil, "ARTWORK")
		button.PullDownMenu.Button[i].Highlight:SetPoint("TOPLEFT", 0, 0)
		button.PullDownMenu.Button[i].Highlight:SetPoint("BOTTOMRIGHT", 0, 0)
		button.PullDownMenu.Button[i].Highlight:SetTexture(1, 1, 1, 0.2)
		button.PullDownMenu.Button[i]:SetHighlightTexture(button.PullDownMenu.Button[i].Highlight)

		if contentName == "TickSound" then
			button.PullDownMenu.Button[i].Text:SetText(soundsTick[i].name)
			button.PullDownMenu.Button[i].value1 = i
		elseif contentName == "TickSoundChannel" then
			button.PullDownMenu.Button[i].Text:SetText(soundChannel[i].name)
			button.PullDownMenu.Button[i].value1 = i
		elseif contentName == "TwentyFiveSound" then
			button.PullDownMenu.Button[i].Text:SetText(soundsTwentyFive[i].name)
			button.PullDownMenu.Button[i].value1 = i
		elseif contentName == "TwentyFiveSoundChannel" then
			button.PullDownMenu.Button[i].Text:SetText(soundChannel[i].name)
			button.PullDownMenu.Button[i].value1 = i
		end
		button.PullDownMenu.Button[i]:Show()	
	end

	button.PullDownMenu:SetScript("OnLeave", OnLeave)
	button.PullDownMenu:SetScript("OnHide", function(self) self:Hide() end) -- for esc close

	button:SetScript("OnLeave", OnLeave)
	button:SetScript("OnClick", function()
		if button.PullDownMenu:IsShown() then
			button.PullDownMenu:Hide()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand.coords))
		else
			button.PullDownMenu:Show()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Collapse.coords))
		end
	end)
end
-- Template PullDownMenu END ----------------------------------------

-- Template Slider START ----------------------------------------
TEMPLATE.DisableSlider = function(slider)
	slider.textMin:SetTextColor(0.5, 0.5, 0.5, 1)
	slider.textMax:SetTextColor(0.5, 0.5, 0.5, 1)
	slider.sliderBGL:SetTexCoord(unpack(Textures.SliderBG.coordsLdis))
	slider.sliderBGM:SetTexCoord(unpack(Textures.SliderBG.coordsMdis))
	slider.sliderBGR:SetTexCoord(unpack(Textures.SliderBG.coordsRdis))
	slider.thumb:SetTexCoord(0, 0, 0, 0)
	slider:Disable()
end

TEMPLATE.EnableSlider = function(slider)
	slider.textMin:SetTextColor(0.8, 0.8, 0.8, 1)
	slider.textMax:SetTextColor(0.8, 0.8, 0.8, 1)
	slider.sliderBGL:SetTexCoord(unpack(Textures.SliderBG.coordsL))
	slider.sliderBGM:SetTexCoord(unpack(Textures.SliderBG.coordsM))
	slider.sliderBGR:SetTexCoord(unpack(Textures.SliderBG.coordsR))
	slider.thumb:SetTexCoord(unpack(Textures.SliderKnob.coords))
	slider:Enable()
end

TEMPLATE.Slider = function(slider, width, step, minVal, maxVal, curVal, func, measure)
	slider:SetWidth(width)
	slider:SetHeight(17)
	slider:SetValueStep(step) 
	slider:SetMinMaxValues(minVal, maxVal)
	slider:SetValue(curVal)
	slider:SetOrientation("HORIZONTAL")

	slider.textMin = slider:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	slider.textMin:SetPoint("TOP", slider, "BOTTOM", 0, -1)
	slider.textMin:SetPoint("LEFT", slider, "LEFT", 0, 0)
	slider.textMin:SetJustifyH("CENTER")
	slider.textMin:SetTextColor(0.8, 0.8, 0.8, 1)
	if measure == "%" then
		slider.textMin:SetText(minVal.."%")
	elseif measure == "K" then
		slider.textMin:SetText((minVal/1000).."k")
	else
		slider.textMin:SetText(minVal)
	end
	slider.textMax = slider:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	slider.textMax:SetPoint("TOP", slider, "BOTTOM", 0, -1)
	slider.textMax:SetPoint("RIGHT", slider, "RIGHT", 0, 0)
	slider.textMax:SetJustifyH("CENTER")
	slider.textMax:SetTextColor(0.8, 0.8, 0.8, 1)
	if measure == "%" then
		slider.textMax:SetText(maxVal.."%")
	elseif measure == "K" then
		slider.textMax:SetText((maxVal/1000).."k")
	else
		slider.textMax:SetText(maxVal)
	end

	slider.sliderBGL = slider:CreateTexture(nil, "BACKGROUND")
	slider.sliderBGL:SetWidth(5)
	slider.sliderBGL:SetHeight(6)
	slider.sliderBGL:SetPoint("LEFT", slider, "LEFT", 0, 0)
	slider.sliderBGL:SetTexture(Textures.DrainSoulerIcons.path)
	slider.sliderBGL:SetTexCoord(unpack(Textures.SliderBG.coordsL))
	slider.sliderBGM = slider:CreateTexture(nil, "BACKGROUND")
	slider.sliderBGM:SetWidth(width-5-5)
	slider.sliderBGM:SetHeight(6)
	slider.sliderBGM:SetPoint("LEFT", slider.sliderBGL, "RIGHT", 0, 0)
	slider.sliderBGM:SetTexture(Textures.DrainSoulerIcons.path)
	slider.sliderBGM:SetTexCoord(unpack(Textures.SliderBG.coordsM))
	slider.sliderBGR = slider:CreateTexture(nil, "BACKGROUND")
	slider.sliderBGR:SetWidth(5)
	slider.sliderBGR:SetHeight(6)
	slider.sliderBGR:SetPoint("LEFT", slider.sliderBGM, "RIGHT", 0, 0)
	slider.sliderBGR:SetTexture(Textures.DrainSoulerIcons.path)
	slider.sliderBGR:SetTexCoord(unpack(Textures.SliderBG.coordsR))

	slider.thumb = slider:CreateTexture(nil, "BORDER")
	slider.thumb:SetWidth(17)
	slider.thumb:SetHeight(17)
	slider.thumb:SetTexture(Textures.DrainSoulerIcons.path)
	slider.thumb:SetTexCoord(unpack(Textures.SliderKnob.coords))
	slider:SetThumbTexture(slider.thumb)

	slider:SetScript("OnValueChanged", function(self, value)
		if func then
			func(self, value)
		end
	end)
end
-- Template Slider END ----------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local function CheckHealth()
	local maxHealth = UnitHealthMax("target")
	if maxHealth < DrainSouler_Options.minHP then
		GVAR.MainFrame:Hide()
		return
	end
	local health = UnitHealth("target") / maxHealth * 100
	if health > 0 and health <= DrainSouler_Options.minHPP then
		GVAR.MainFrame:Show()
		GVAR.MainFrame.HPText:SetText( math_floor(health * mult2 + 0.5) / mult2.."%" )

		if DrainSouler_Options.TwentyFiveSound > 1 then
			if health < DrainSouler_Options.TwentyFiveSoundHPP and maxHealth > DrainSouler_Options.TwentyFiveSoundHP then
				local mobGUID = UnitGUID("target")
				if not mobTable[mobGUID] then
					PlaySoundFile(soundsTwentyFive[DrainSouler_Options.TwentyFiveSound].path, soundChannel[DrainSouler_Options.TwentyFiveSoundChannel].channel)
					mobTable[mobGUID] = GetTime()
				end
			end
		end

		if health < 25 then
			GVAR.MainFrame.Icon:Show()
		else
			GVAR.MainFrame.Icon:Hide()
		end
	else
		GVAR.MainFrame:Hide()
		GVAR.MainFrame.HPText:SetText("")
		GVAR.MainFrame.DMGText:SetText("")
		GVAR.MainFrame.TickText:SetText("")
	end
	if not dsIsActive then
		GVAR.MainFrame.TickTimer:Hide()
	end
end

local function TargetUnitCheck()
	if not inCombat and DrainSouler_Options.onlyInCombat then
		GVAR.MainFrame:Hide()
		DrainSouler:UnregisterEvent("UNIT_HEALTH")
		return
	end

	if UnitExists("target") then
		CheckHealth()
		DrainSouler:RegisterEvent("UNIT_HEALTH")
	else
		GVAR.MainFrame:Hide()
		DrainSouler:UnregisterEvent("UNIT_HEALTH")
	end
end

local function TickTimer()
	local width = 0
	if dsTimeTable[dsDif] and dsTimeTable[dsDif][dsTick] then
		if dsTimeTable[dsDif][dsTick].brk then
			if dsTimeTable[dsDif][dsTick].bavg then
				width = sizeTimerWidth - (( (GetTime()*1000) - dsStart)*sizeTimerWidth) / dsTimeTable[dsDif][dsTick].bavg
				GVAR.MainFrame.TickTimerTexture:SetTexture(0.12, 0.34, 0.45, 1)
			else
				width = sizeTimerWidth - (( (GetTime()*1000) - dsStart)*sizeTimerWidth) / 3000
				GVAR.MainFrame.TickTimerTexture:SetTexture(0.4, 0.4, 0.4, 1)
			end
		else
			if dsTimeTable[dsDif][dsTick].navg then
				width = sizeTimerWidth - (( (GetTime()*1000) - dsStart)*sizeTimerWidth) / dsTimeTable[dsDif][dsTick].navg
				GVAR.MainFrame.TickTimerTexture:SetTexture(0.12, 0.34, 0.45, 1)
			else
				width = sizeTimerWidth - (( (GetTime()*1000) - dsStart)*sizeTimerWidth) / 3000
				GVAR.MainFrame.TickTimerTexture:SetTexture(0.4, 0.4, 0.4, 1)
			end
		end
	else
		width = sizeTimerWidth - (( (GetTime()*1000) - dsStart)*sizeTimerWidth) / 3000
		GVAR.MainFrame.TickTimerTexture:SetTexture(0.4, 0.4, 0.4, 1)
	end
	if width < 0.01 then
		width = 0.01
	elseif width > sizeTimerWidth then
		width = sizeTimerWidth
	end
	GVAR.MainFrame.TickTimerTexture:SetWidth(width)
end

local function OnMouseDown()
	GVAR.MainFrame:StartMoving()
end

local function OnMouseUp()
	GVAR.MainFrame:StopMovingOrSizing()
	DrainSouler_Options.posX = GVAR.MainFrame:GetLeft()
	DrainSouler_Options.posY = GVAR.MainFrame:GetTop()
end

local function ConfigOnMouseDown()
	GVAR.OptionsFrame:StartMoving()
end

local function ConfigOnMouseUp()
	GVAR.OptionsFrame:StopMovingOrSizing()
	DrainSouler_Options.config_posX = GVAR.OptionsFrame:GetLeft()
	DrainSouler_Options.config_posY = GVAR.OptionsFrame:GetTop()
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function DrainSouler:CheckTalent()
	if not GVAR.MainFrame then return end
	if not GVAR.OptionsFrame then return end

	if not talentNames[1] then
		for i = 1, 3 do
			talentNames[i] = select(2, GetTalentTabInfo(i)) or talentNamesEN[i]
		end
	end

	local primaryTalent = GetPrimaryTalentTree(false, nil)
	isAffliction = nil
	if primaryTalent then
		if primaryTalent == 1 then
			isAffliction = true
		end
		GVAR.OptionsFrame.TalentDependentDescription:SetText(L["Your current Spec:"].." |cffffff99"..talentNames[primaryTalent].."|r")
	else
		GVAR.OptionsFrame.TalentDependentDescription:SetText(L["Your current Spec:"].." |cffffff99"..UNKNOWN.."|r")
	end

	if ((DrainSouler_Options.TalentDependent and isAffliction) or (not DrainSouler_Options.TalentDependent)) then
		GVAR.MainFrame:Show()
		GVAR.MainFrame.Icon:Show()
		-- MoveNote
		GVAR.OptionsFrame.MoveNote:SetTextColor(1, 1, 0.5, 1)
		-- Lock
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.Lock)
		-- onlyInCombat
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.onlyInCombat)
		-- Size
		GVAR.OptionsFrame.SizeTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.Size)
		-- minHP
		GVAR.OptionsFrame.minHPTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.minHP)
		GVAR.OptionsFrame.minHPDescription:SetTextColor(0.6, 0.6, 0.6, 1)
		-- minHPP
		GVAR.OptionsFrame.minHPPTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.minHPP)
		GVAR.OptionsFrame.minHPPDescription:SetTextColor(0.6, 0.6, 0.6, 1)
		-- TickSound
		GVAR.OptionsFrame.TickSoundTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TickSoundPullDown)
		GVAR.OptionsFrame.TickSoundDescription:SetTextColor(0.6, 0.6, 0.6, 1)

		if DrainSouler_Options.TickSound > 1 then
			TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TickSoundChannelPullDown)
			GVAR.OptionsFrame.TickSoundChannelTitle:SetTextColor(1, 1, 1, 1)
		else
			TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.TickSoundChannelPullDown)
			GVAR.OptionsFrame.TickSoundChannelTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		end

		-- TwentyFiveSound
		GVAR.OptionsFrame.TwentyFiveSoundTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundPullDown)

		if DrainSouler_Options.TwentyFiveSound > 1 then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.TwentyFiveSoundHP)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.TwentyFiveSoundHPP)
			GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetTextColor(1, 1, 1, 1)
			GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetTextColor(1, 1, 1, 1)
			GVAR.OptionsFrame.TwentyFiveSoundDescription:SetTextColor(0.6, 0.6, 0.6, 1)
			GVAR.OptionsFrame.TwentyFiveSoundWarning:SetTextColor(0.73, 0.26, 0.21, 1)
			TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown)
			GVAR.OptionsFrame.TwentyFiveSoundChannelTitle:SetTextColor(1, 1, 1, 1)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.TwentyFiveSoundHP)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.TwentyFiveSoundHPP)
			GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetTextColor(0.5, 0.5, 0.5, 1)
			GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetTextColor(0.5, 0.5, 0.5, 1)
			GVAR.OptionsFrame.TwentyFiveSoundDescription:SetTextColor(0.5, 0.5, 0.5, 1)
			GVAR.OptionsFrame.TwentyFiveSoundWarning:SetTextColor(0.5, 0.5, 0.5, 1)
			TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown)
			GVAR.OptionsFrame.TwentyFiveSoundChannelTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		end

		if not DrainSouler_Options.Lock then
			GVAR.OptionsFrame.MoveNote:SetTextColor(1, 1, 0.5, 1)
		else
			GVAR.OptionsFrame.MoveNote:SetTextColor(0, 0, 0, 1)
		end

		if not configMode then
			if InCombatLockdown() then
				inCombat = true
			else
				inCombat = false
			end
			DrainSouler:RegisterEvent("PLAYER_TARGET_CHANGED")
			DrainSouler:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
			DrainSouler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
			DrainSouler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
			DrainSouler:RegisterEvent("PLAYER_REGEN_DISABLED")
			DrainSouler:RegisterEvent("PLAYER_REGEN_ENABLED")
			TargetUnitCheck()
		end
	else
		GVAR.MainFrame:Hide()
		-- MoveNote
		GVAR.OptionsFrame.MoveNote:SetTextColor(0.5, 0.5, 0.5, 1)
		-- Lock
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.Lock)
		-- onlyInCombat
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.onlyInCombat)
		-- Size
		GVAR.OptionsFrame.SizeTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.Size)
		-- minHP
		GVAR.OptionsFrame.minHPTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.minHP)
		GVAR.OptionsFrame.minHPDescription:SetTextColor(0.5, 0.5, 0.5, 1)
		-- minHPP
		GVAR.OptionsFrame.minHPPTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.minHPP)
		GVAR.OptionsFrame.minHPPDescription:SetTextColor(0.5, 0.5, 0.5, 1)
		-- TickSound
		GVAR.OptionsFrame.TickSoundTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.TickSoundPullDown)
		GVAR.OptionsFrame.TickSoundDescription:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.TickSoundChannelPullDown)
		GVAR.OptionsFrame.TickSoundChannelTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		-- TwentyFiveSound
		GVAR.OptionsFrame.TwentyFiveSoundTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundPullDown)
		GVAR.OptionsFrame.TwentyFiveSoundDescription:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.TwentyFiveSoundHP)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.TwentyFiveSoundHPP)
		GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.OptionsFrame.TwentyFiveSoundWarning:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown)
		GVAR.OptionsFrame.TwentyFiveSoundChannelTitle:SetTextColor(0.5, 0.5, 0.5, 1)

		GVAR.OptionsFrame.MoveNote:SetTextColor(0, 0, 0, 1)

		if not configMode then
			DrainSouler:UnregisterEvent("PLAYER_TARGET_CHANGED")
			DrainSouler:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
			DrainSouler:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
			DrainSouler:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
			DrainSouler:UnregisterEvent("PLAYER_REGEN_DISABLED")
			DrainSouler:UnregisterEvent("PLAYER_REGEN_ENABLED")
			DrainSouler:UnregisterEvent("UNIT_HEALTH")
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function DrainSouler:InitOptions()
	if DrainSouler_Options.version                == nil then DrainSouler_Options.version                = 1 end
	if DrainSouler_Options.configMode             == nil then DrainSouler_Options.configMode             = true end
	if DrainSouler_Options.Lock                   == nil then DrainSouler_Options.Lock                   = false end
	if DrainSouler_Options.TalentDependent        == nil then DrainSouler_Options.TalentDependent        = false end
	if DrainSouler_Options.Size                   == nil then DrainSouler_Options.Size                   = 1.5 end
	if DrainSouler_Options.onlyInCombat           == nil then DrainSouler_Options.onlyInCombat           = true end
	if DrainSouler_Options.minHP                  == nil then DrainSouler_Options.minHP                  = 0 end
	if DrainSouler_Options.minHPP                 == nil then DrainSouler_Options.minHPP                 = 30 end
	if DrainSouler_Options.TickSound              == nil then DrainSouler_Options.TickSound              = 7 end
	if DrainSouler_Options.TickSoundChannel       == nil then DrainSouler_Options.TickSoundChannel       = 2 end
	if DrainSouler_Options.TwentyFiveSound        == nil then DrainSouler_Options.TwentyFiveSound        = 1 end
	if DrainSouler_Options.TwentyFiveSoundChannel == nil then DrainSouler_Options.TwentyFiveSoundChannel = 2 end
	if DrainSouler_Options.TwentyFiveSoundHP      == nil then DrainSouler_Options.TwentyFiveSoundHP      = 0 end
	if DrainSouler_Options.TwentyFiveSoundHPP     == nil then DrainSouler_Options.TwentyFiveSoundHPP     = 25 end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function DrainSouler:CreateInterfaceOptions()
	GVAR.InterfaceOptions = CreateFrame("Frame", "DrainSouler_InterfaceOptions")
	GVAR.InterfaceOptions.name = "DrainSouler"

	GVAR.InterfaceOptions.Title = GVAR.InterfaceOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	GVAR.InterfaceOptions.Title:SetPoint("TOPLEFT", 16, -16)
	GVAR.InterfaceOptions.Title:SetText("DrainSouler")
	GVAR.InterfaceOptions.Title:SetJustifyH("LEFT")
	GVAR.InterfaceOptions.Title:SetJustifyV("TOP")

	GVAR.InterfaceOptions.OPTIONS = CreateFrame("Button", nil, DrainSouler_InterfaceOptions)
	TEMPLATE.TextButton(GVAR.InterfaceOptions.OPTIONS, L["Open Configuration"], 1)
	GVAR.InterfaceOptions.OPTIONS:SetPoint("TOPLEFT", GVAR.InterfaceOptions.Title, "BOTTOMLEFT", 0, -10)
	GVAR.InterfaceOptions.OPTIONS:SetWidth(200)
	GVAR.InterfaceOptions.OPTIONS:SetHeight(22)
	GVAR.InterfaceOptions.OPTIONS:SetScript("OnClick", function()
		InterfaceOptionsFrame_Show()
		HideUIPanel(GameMenuFrame)
		DrainSouler_Options.configMode = true
		DrainSouler:EnableConfigMode()
	end)

	InterfaceOptions_AddCategory(GVAR.InterfaceOptions)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function DrainSouler:CreateOptionsFrame()
	local frameWidth  = 480
	local frameHeight = 600

	GVAR.OptionsFrame = CreateFrame("Frame", nil, UIParent)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame)
	GVAR.OptionsFrame:EnableMouse(true)
	GVAR.OptionsFrame:SetMovable(true)
	GVAR.OptionsFrame:SetToplevel(true)
	GVAR.OptionsFrame:SetClampedToScreen(true)
	GVAR.OptionsFrame:SetClampRectInsets((frameWidth-50)/2, -((frameWidth-50)/2), -(frameHeight-35), frameHeight-35)
	GVAR.OptionsFrame:SetWidth(frameWidth)
	GVAR.OptionsFrame:SetHeight(frameHeight)
	GVAR.OptionsFrame:SetPoint("CENTER")--", GVAR.MainFrame, "TOPLEFT", 0, -(22+10+50))
	GVAR.OptionsFrame:Hide()
	GVAR.OptionsFrame:SetScript("OnMouseWheel", NOOP)

	GVAR.OptionsFrame.Title = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	GVAR.OptionsFrame.Title:SetPoint("TOPLEFT", GVAR.OptionsFrame, "TOPLEFT", 10, -10)
	GVAR.OptionsFrame.Title:SetJustifyH("LEFT")
	GVAR.OptionsFrame.Title:SetText("DrainSouler "..L["Configuration"])

	-- MoveNote
	GVAR.OptionsFrame.MoveNote = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.MoveNote:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.MoveNote:SetPoint("TOP", GVAR.OptionsFrame.Title, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.MoveNote:SetJustifyH("LEFT")
	GVAR.OptionsFrame.MoveNote:SetText(L["Click and Drag on DrainSouler Frame to move it."])

	-- Lock
	GVAR.OptionsFrame.Lock = CreateFrame("CheckButton", nil, GVAR.OptionsFrame)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.Lock, 16, 4, L["Lock DrainSouler"].." |cffaaaaaa("..L["enables click through frame"]..")|r")
	GVAR.OptionsFrame.Lock:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.Lock:SetPoint("TOP", GVAR.OptionsFrame.MoveNote, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.Lock:SetChecked(DrainSouler_Options.Lock)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.Lock)
	GVAR.OptionsFrame.Lock:SetScript("OnClick", function(self)
		DrainSouler_Options.Lock = not DrainSouler_Options.Lock
		if DrainSouler_Options.Lock then
			GVAR.OptionsFrame.MoveNote:SetTextColor(0, 0, 0, 1)
			DrainSouler:DisableMovement()
		else
			GVAR.OptionsFrame.MoveNote:SetTextColor(1, 1, 0.5, 1)
			DrainSouler:EnableMovement()
		end
	end)

	-- onlyInCombat
	GVAR.OptionsFrame.onlyInCombat = CreateFrame("CheckButton", nil, GVAR.OptionsFrame)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.onlyInCombat, 16, 4, L["Shows DrainSouler in combat only."])
	GVAR.OptionsFrame.onlyInCombat:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.onlyInCombat:SetPoint("TOP", GVAR.OptionsFrame.Lock, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.onlyInCombat:SetChecked(DrainSouler_Options.onlyInCombat)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.onlyInCombat)
	GVAR.OptionsFrame.onlyInCombat:SetScript("OnClick", function(self)
		DrainSouler_Options.onlyInCombat = not DrainSouler_Options.onlyInCombat
	end)

	-- TalentDependent
	GVAR.OptionsFrame.TalentDependent = CreateFrame("CheckButton", nil, GVAR.OptionsFrame)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.TalentDependent, 16, 4, L["Deactivate DrainSouler if you use Demonology or Destruction."])
	GVAR.OptionsFrame.TalentDependent:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.TalentDependent:SetPoint("TOP", GVAR.OptionsFrame.onlyInCombat, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.TalentDependent:SetChecked(DrainSouler_Options.TalentDependent)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.TalentDependent)
	GVAR.OptionsFrame.TalentDependent:SetScript("OnClick", function(self)
		DrainSouler_Options.TalentDependent = not DrainSouler_Options.TalentDependent
		DrainSouler:CheckTalent()
	end)

	GVAR.OptionsFrame.TalentDependentDescription = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.TalentDependentDescription:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 30, 0)
	GVAR.OptionsFrame.TalentDependentDescription:SetPoint("TOP", GVAR.OptionsFrame.TalentDependent, "BOTTOM", 0, -5)
	GVAR.OptionsFrame.TalentDependentDescription:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TalentDependentDescription:SetText( L["Your current Spec:"] )
	GVAR.OptionsFrame.TalentDependentDescription:SetTextColor(0.6, 0.6, 0.6, 1)

	-- Size
	GVAR.OptionsFrame.SizeTitle = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.SizeTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.SizeTitle:SetPoint("TOP", GVAR.OptionsFrame.TalentDependentDescription, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.SizeTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SizeTitle:SetText(L["Size"]..": |cffffff99"..(DrainSouler_Options.Size*100).."%|r")

	GVAR.OptionsFrame.Size = CreateFrame("Slider", nil, GVAR.OptionsFrame)
	TEMPLATE.Slider(GVAR.OptionsFrame.Size, 150, 5, 50, 150, DrainSouler_Options.Size*100, SizeSliderFunc, "%")
	GVAR.OptionsFrame.Size:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 20, 0)
	GVAR.OptionsFrame.Size:SetPoint("TOP", GVAR.OptionsFrame.SizeTitle, "BOTTOM", 0, -5)

	-- minHP
	GVAR.OptionsFrame.minHPTitle = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.minHPTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.minHPTitle:SetPoint("TOP", GVAR.OptionsFrame.Size, "BOTTOM", 0, -25)
	GVAR.OptionsFrame.minHPTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.minHPTitle:SetText(L["Target HP"]..": |cffffff99"..(DrainSouler_Options.minHP/1000).."K|r")

	GVAR.OptionsFrame.minHP = CreateFrame("Slider", nil, GVAR.OptionsFrame)
	TEMPLATE.Slider(GVAR.OptionsFrame.minHP, 250, 10000, 0, 1000000, DrainSouler_Options.minHP, minHPSliderFunc, "K")
	GVAR.OptionsFrame.minHP:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 20, 0)
	GVAR.OptionsFrame.minHP:SetPoint("TOP", GVAR.OptionsFrame.minHPTitle, "BOTTOM", 0, -5)

	GVAR.OptionsFrame.minHPDescription = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.minHPDescription:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 20, 0)
	GVAR.OptionsFrame.minHPDescription:SetPoint("TOP", GVAR.OptionsFrame.minHP, "BOTTOM", 0, -15)
	GVAR.OptionsFrame.minHPDescription:SetJustifyH("LEFT")
	GVAR.OptionsFrame.minHPDescription:SetText( string.format(L["Shows DrainSouler if maximum target HP is greater than %s."], "|cffffff99"..(DrainSouler_Options.minHP/1000).."K|r") )
	GVAR.OptionsFrame.minHPDescription:SetTextColor(0.6, 0.6, 0.6, 1)

	-- minHPP
	GVAR.OptionsFrame.minHPPTitle = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.minHPPTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.minHPPTitle:SetPoint("TOP", GVAR.OptionsFrame.minHPDescription, "BOTTOM", 0, -15)
	GVAR.OptionsFrame.minHPPTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.minHPPTitle:SetText(L["Target HP (in percent)"]..": |cffffff99"..DrainSouler_Options.minHPP.."%|r")

	GVAR.OptionsFrame.minHPP = CreateFrame("Slider", nil, GVAR.OptionsFrame)
	TEMPLATE.Slider(GVAR.OptionsFrame.minHPP, 250, 1, 25, 100, DrainSouler_Options.minHPP, minHPPSliderFunc, "%")
	GVAR.OptionsFrame.minHPP:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 20, 0)
	GVAR.OptionsFrame.minHPP:SetPoint("TOP", GVAR.OptionsFrame.minHPPTitle, "BOTTOM", 0, -5)

	GVAR.OptionsFrame.minHPPDescription = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.minHPPDescription:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 20, 0)
	GVAR.OptionsFrame.minHPPDescription:SetPoint("TOP", GVAR.OptionsFrame.minHPP, "BOTTOM", 0, -15)
	GVAR.OptionsFrame.minHPPDescription:SetJustifyH("LEFT")
	GVAR.OptionsFrame.minHPPDescription:SetText( string.format(L["Shows DrainSouler if target HP (in percent) is less or equal %s."], "|cffffff99"..DrainSouler_Options.minHPP.."%|r") )
	GVAR.OptionsFrame.minHPPDescription:SetTextColor(0.6, 0.6, 0.6, 1)

	-- TickSound
	GVAR.OptionsFrame.TickSoundTitle = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.TickSoundTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.TickSoundTitle:SetPoint("TOP", GVAR.OptionsFrame.minHPPDescription, "BOTTOM", 0, -15)
	GVAR.OptionsFrame.TickSoundTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TickSoundTitle:SetText(L["TickSound"]..": |cffffff99"..soundsTick[DrainSouler_Options.TickSound].name.."|r")

	GVAR.OptionsFrame.TickSoundPullDown = CreateFrame("Button", nil, GVAR.OptionsFrame)
	TEMPLATE.PullDownMenu(GVAR.OptionsFrame.TickSoundPullDown, "TickSound", soundsTick[DrainSouler_Options.TickSound].name, 130, #soundsTick, TickSoundPullDownFunc)
	GVAR.OptionsFrame.TickSoundPullDown:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 20, 0)
	GVAR.OptionsFrame.TickSoundPullDown:SetPoint("TOP", GVAR.OptionsFrame.TickSoundTitle, "BOTTOM", 0, -5)
	GVAR.OptionsFrame.TickSoundPullDown:SetWidth(130)
	GVAR.OptionsFrame.TickSoundPullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TickSoundPullDown)

	GVAR.OptionsFrame.TickSoundChannelTitle = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.TickSoundChannelTitle:SetPoint("LEFT", GVAR.OptionsFrame.TickSoundPullDown, "RIGHT", 10, 0)
	GVAR.OptionsFrame.TickSoundChannelTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TickSoundChannelTitle:SetText(CHANNEL..": ")

	GVAR.OptionsFrame.TickSoundChannelPullDown = CreateFrame("Button", nil, GVAR.OptionsFrame)
	TEMPLATE.PullDownMenu(GVAR.OptionsFrame.TickSoundChannelPullDown, "TickSoundChannel", soundChannel[DrainSouler_Options.TickSoundChannel].name, 130, #soundChannel, TickSoundChannelPullDownFunc)
	GVAR.OptionsFrame.TickSoundChannelPullDown:SetPoint("LEFT", GVAR.OptionsFrame.TickSoundChannelTitle, "RIGHT", 5, 0)
	GVAR.OptionsFrame.TickSoundChannelPullDown:SetWidth(130)
	GVAR.OptionsFrame.TickSoundChannelPullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TickSoundChannelPullDown)

	GVAR.OptionsFrame.TickSoundDescription = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.TickSoundDescription:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 20, 0)
	GVAR.OptionsFrame.TickSoundDescription:SetPoint("TOP", GVAR.OptionsFrame.TickSoundPullDown, "BOTTOM", 0, -5)
	GVAR.OptionsFrame.TickSoundDescription:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TickSoundDescription:SetText(L["Plays a sound when Drain Soul dealt damage."])
	GVAR.OptionsFrame.TickSoundDescription:SetTextColor(0.6, 0.6, 0.6, 1)

	if DrainSouler_Options.TickSound > 1 then
		TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TickSoundChannelPullDown)
		GVAR.OptionsFrame.TickSoundChannelTitle:SetTextColor(1, 1, 1, 1)
	else
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.TickSoundChannelPullDown)
		GVAR.OptionsFrame.TickSoundChannelTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	end

	-- TwentyFiveSound
	GVAR.OptionsFrame.TwentyFiveSoundTitle = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.TwentyFiveSoundTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.TwentyFiveSoundTitle:SetPoint("TOP", GVAR.OptionsFrame.TickSoundDescription, "BOTTOM", 0, -15)
	GVAR.OptionsFrame.TwentyFiveSoundTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TwentyFiveSoundTitle:SetText(L["25% HP Sound"]..": |cffffff99"..soundsTwentyFive[DrainSouler_Options.TwentyFiveSound].name.."|r")

	GVAR.OptionsFrame.TwentyFiveSoundPullDown = CreateFrame("Button", nil, GVAR.OptionsFrame)
	TEMPLATE.PullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundPullDown, "TwentyFiveSound", soundsTwentyFive[DrainSouler_Options.TwentyFiveSound].name, 130, #soundsTwentyFive, TwentyFiveSoundPullDownFunc)
	GVAR.OptionsFrame.TwentyFiveSoundPullDown:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 20, 0)
	GVAR.OptionsFrame.TwentyFiveSoundPullDown:SetPoint("TOP", GVAR.OptionsFrame.TwentyFiveSoundTitle, "BOTTOM", 0, -5)
	GVAR.OptionsFrame.TwentyFiveSoundPullDown:SetWidth(130)
	GVAR.OptionsFrame.TwentyFiveSoundPullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundPullDown)

	GVAR.OptionsFrame.TwentyFiveSoundChannelTitle = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.TwentyFiveSoundChannelTitle:SetPoint("LEFT", GVAR.OptionsFrame.TwentyFiveSoundPullDown, "RIGHT", 10, 0)
	GVAR.OptionsFrame.TwentyFiveSoundChannelTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TwentyFiveSoundChannelTitle:SetText(CHANNEL..": ")

	GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown = CreateFrame("Button", nil, GVAR.OptionsFrame)
	TEMPLATE.PullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown, "TwentyFiveSoundChannel", soundChannel[DrainSouler_Options.TwentyFiveSoundChannel].name, 130, #soundChannel, TwentyFiveSoundChannelPullDownFunc)
	GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown:SetPoint("LEFT", GVAR.OptionsFrame.TwentyFiveSoundChannelTitle, "RIGHT", 5, 0)
	GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown:SetWidth(130)
	GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown)

	-- - TwentyFiveSoundHP
	GVAR.OptionsFrame.TwentyFiveSoundHPTitle = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 20, 0)
	GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetPoint("TOP", GVAR.OptionsFrame.TwentyFiveSoundPullDown, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetText("25% "..L["Target HP"]..": |cffffff99"..(DrainSouler_Options.TwentyFiveSoundHP/1000).."K|r")

	GVAR.OptionsFrame.TwentyFiveSoundHP = CreateFrame("Slider", nil, GVAR.OptionsFrame)
	TEMPLATE.Slider(GVAR.OptionsFrame.TwentyFiveSoundHP, 250, 10000, 0, 1000000, DrainSouler_Options.TwentyFiveSoundHP, TwentyFiveSoundHPSliderFunc, "K")
	GVAR.OptionsFrame.TwentyFiveSoundHP:SetPoint("TOPLEFT", GVAR.OptionsFrame.TwentyFiveSoundHPTitle, "BOTTOMLEFT", 0, 0)

	GVAR.OptionsFrame.TwentyFiveSoundHPPTitle = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetPoint("LEFT", GVAR.OptionsFrame.TwentyFiveSoundHP, "RIGHT", 20, 0)
	GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetPoint("TOP", GVAR.OptionsFrame.TwentyFiveSoundHPTitle, "TOP", 0, 0)
	GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetText("25% "..L["Target HP (in percent)"]..": |cffffff99"..DrainSouler_Options.TwentyFiveSoundHPP.."%|r")

	GVAR.OptionsFrame.TwentyFiveSoundHPP = CreateFrame("Slider", nil, GVAR.OptionsFrame)
	TEMPLATE.Slider(GVAR.OptionsFrame.TwentyFiveSoundHPP, 150, 1, 25, 30, DrainSouler_Options.TwentyFiveSoundHPP, TwentyFiveSoundHPPSliderFunc, "%")
	GVAR.OptionsFrame.TwentyFiveSoundHPP:SetPoint("TOPLEFT", GVAR.OptionsFrame.TwentyFiveSoundHPPTitle, "BOTTOMLEFT", 0, 0)

	GVAR.OptionsFrame.TwentyFiveSoundDescription = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.TwentyFiveSoundDescription:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 20, 0)
	GVAR.OptionsFrame.TwentyFiveSoundDescription:SetPoint("TOP", GVAR.OptionsFrame.TwentyFiveSoundHPP, "BOTTOM", 0, -15)
	GVAR.OptionsFrame.TwentyFiveSoundDescription:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TwentyFiveSoundDescription:SetTextColor(0.6, 0.6, 0.6, 1)
	GVAR.OptionsFrame.TwentyFiveSoundDescription:SetText( string.format(L["Plays a sound when your target is below %s HP and maximum HP is greater than %s."], "|cffffff99"..DrainSouler_Options.TwentyFiveSoundHPP.."%|r", "|cffffff99"..(DrainSouler_Options.TwentyFiveSoundHP/1000).."K|r") )

	GVAR.OptionsFrame.TwentyFiveSoundWarning = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.TwentyFiveSoundWarning:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 20, 0)
	GVAR.OptionsFrame.TwentyFiveSoundWarning:SetPoint("TOP", GVAR.OptionsFrame.TwentyFiveSoundDescription, "BOTTOM", 0, -5)
	GVAR.OptionsFrame.TwentyFiveSoundWarning:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TwentyFiveSoundWarning:SetTextColor(0.73, 0.26, 0.21, 1)
	GVAR.OptionsFrame.TwentyFiveSoundWarning:SetText("("..L["The general 'Target HP' and 'Target HP (in percent)' values are used first!"]..")")

	if DrainSouler_Options.TwentyFiveSound > 1 then
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.TwentyFiveSoundHP)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.TwentyFiveSoundHPP)
		GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetTextColor(1, 1, 1, 1)
		GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetTextColor(1, 1, 1, 1)
		GVAR.OptionsFrame.TwentyFiveSoundDescription:SetTextColor(0.6, 0.6, 0.6, 1)
		TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown)
		GVAR.OptionsFrame.TwentyFiveSoundChannelTitle:SetTextColor(1, 1, 1, 1)
	else
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.TwentyFiveSoundHP)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.TwentyFiveSoundHPP)
		GVAR.OptionsFrame.TwentyFiveSoundHPTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.OptionsFrame.TwentyFiveSoundHPPTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.OptionsFrame.TwentyFiveSoundDescription:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.TwentyFiveSoundChannelPullDown)
		GVAR.OptionsFrame.TwentyFiveSoundChannelTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	end

	-- Close
	GVAR.OptionsFrame.CloseConfigText = GVAR.OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.CloseConfigText:SetPoint("BOTTOM", GVAR.OptionsFrame, "BOTTOM", 0, 10)
	GVAR.OptionsFrame.CloseConfigText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.CloseConfigText:SetText(L["'ESC -> Interface -> AddOns -> DrainSouler' to change Options!"])
	GVAR.OptionsFrame.CloseConfigText:SetTextColor(1, 1, 0.5, 1)

	GVAR.OptionsFrame.CloseConfig = CreateFrame("Button", nil, GVAR.OptionsFrame)
	TEMPLATE.TextButton(GVAR.OptionsFrame.CloseConfig, L["Close Configuration"], 1)
	GVAR.OptionsFrame.CloseConfig:SetPoint("BOTTOM", GVAR.OptionsFrame.CloseConfigText, "TOP", 0, 10)
	GVAR.OptionsFrame.CloseConfig:SetWidth(frameWidth-20)
	GVAR.OptionsFrame.CloseConfig:SetHeight(30)
	GVAR.OptionsFrame.CloseConfig:SetScript("OnClick", function()
		DrainSouler_Options.configMode = false
		DrainSouler:DisableConfigMode()
	end)

	-- Mover
	GVAR.OptionsFrame.MoverTop = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.MoverTop)
	GVAR.OptionsFrame.MoverTop:SetWidth(frameWidth)
	GVAR.OptionsFrame.MoverTop:SetHeight(20)
	GVAR.OptionsFrame.MoverTop:SetPoint("BOTTOM", GVAR.OptionsFrame, "TOP", 0, -1)
	GVAR.OptionsFrame.MoverTop:EnableMouse(true)
	GVAR.OptionsFrame.MoverTop:EnableMouseWheel(true)
	GVAR.OptionsFrame.MoverTop:SetScript("OnMouseWheel", NOOP)
	GVAR.OptionsFrame.MoverTopText = GVAR.OptionsFrame.MoverTop:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.MoverTopText:SetPoint("CENTER", GVAR.OptionsFrame.MoverTop, "CENTER", 0, 0)
	GVAR.OptionsFrame.MoverTopText:SetJustifyH("CENTER")
	GVAR.OptionsFrame.MoverTopText:SetTextColor(0.3, 0.3, 0.3, 1)
	GVAR.OptionsFrame.MoverTopText:SetText(L["click & move"])

	GVAR.OptionsFrame.MoverBottom = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.MoverBottom)
	GVAR.OptionsFrame.MoverBottom:SetWidth(frameWidth)
	GVAR.OptionsFrame.MoverBottom:SetHeight(20)
	GVAR.OptionsFrame.MoverBottom:SetPoint("TOP", GVAR.OptionsFrame, "BOTTOM", 0, 1)
	GVAR.OptionsFrame.MoverBottom:EnableMouse(true)
	GVAR.OptionsFrame.MoverBottom:EnableMouseWheel(true)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnMouseWheel", NOOP)
	GVAR.OptionsFrame.MoverBottomText = GVAR.OptionsFrame.MoverBottom:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.OptionsFrame.MoverBottomText:SetPoint("CENTER", GVAR.OptionsFrame.MoverBottom, "CENTER", 0, 0)
	GVAR.OptionsFrame.MoverBottomText:SetJustifyH("CENTER")
	GVAR.OptionsFrame.MoverBottomText:SetTextColor(0.3, 0.3, 0.3, 1)
	GVAR.OptionsFrame.MoverBottomText:SetText(L["click & move"])

	GVAR.OptionsFrame.MoverTop:SetScript("OnEnter", function() GVAR.OptionsFrame.MoverTopText:SetTextColor(1, 1, 1, 1) end)
	GVAR.OptionsFrame.MoverTop:SetScript("OnLeave", function() GVAR.OptionsFrame.MoverTopText:SetTextColor(0.3, 0.3, 0.3, 1) end)
	GVAR.OptionsFrame.MoverTop:SetScript("OnMouseDown", ConfigOnMouseDown)
	GVAR.OptionsFrame.MoverTop:SetScript("OnMouseUp", ConfigOnMouseUp)

	GVAR.OptionsFrame.MoverBottom:SetScript("OnEnter", function() GVAR.OptionsFrame.MoverBottomText:SetTextColor(1, 1, 1, 1) end)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnLeave", function() GVAR.OptionsFrame.MoverBottomText:SetTextColor(0.3, 0.3, 0.3, 1) end)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnMouseDown", ConfigOnMouseDown)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnMouseUp", ConfigOnMouseUp)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function DrainSouler:CreateMainFrame()
	GVAR.MainFrame = CreateFrame("Frame", nil)
	GVAR.MainFrame:SetClampedToScreen(true)
	GVAR.MainFrame:SetClampRectInsets(0, 90, 0, -22)
	GVAR.MainFrame:SetMovable(true)
	GVAR.MainFrame:SetPoint("BOTTOM", GVAR.OptionsFrame, "TOP", -sizeTimerWidth+22, 50)
	GVAR.MainFrame:SetWidth(1)
	GVAR.MainFrame:SetHeight(1)
	GVAR.MainFrame:SetScale(1)
	GVAR.MainFrame:Hide()

	GVAR.MainFrame.Icon = CreateFrame("Button", nil, GVAR.MainFrame)
	GVAR.MainFrame.Icon:SetFrameLevel(GVAR.MainFrame:GetFrameLevel()+1)
	GVAR.MainFrame.Icon:SetWidth(22)
	GVAR.MainFrame.Icon:SetHeight(22)
	GVAR.MainFrame.Icon:ClearAllPoints()
	GVAR.MainFrame.Icon:SetPoint("TOPLEFT", GVAR.MainFrame, "TOPLEFT", 0, 0)
	GVAR.MainFrame.IconBG = GVAR.MainFrame.Icon:CreateTexture(nil, "BACKGROUND")
	GVAR.MainFrame.IconBG:SetAllPoints(GVAR.MainFrame.Icon)
	GVAR.MainFrame.IconBG:SetTexture(0, 0, 0, 1)
	GVAR.MainFrame.IconTexture = GVAR.MainFrame.Icon:CreateTexture(nil, "ARTWORK")
	GVAR.MainFrame.IconTexture:SetWidth(20)
	GVAR.MainFrame.IconTexture:SetHeight(20)
	GVAR.MainFrame.IconTexture:SetPoint("TOPLEFT", GVAR.MainFrame.Icon, "TOPLEFT", 1, -1)
	GVAR.MainFrame.IconTexture:SetTexture(DrainSoulIcon)

	GVAR.MainFrame.HP = CreateFrame("Button", nil, GVAR.MainFrame)
	GVAR.MainFrame.HP:SetFrameLevel(GVAR.MainFrame:GetFrameLevel()+1)
	GVAR.MainFrame.HP:SetWidth(sizeTimerWidth)
	GVAR.MainFrame.HP:SetHeight(11)
	GVAR.MainFrame.HP:ClearAllPoints()
	GVAR.MainFrame.HP:SetPoint("TOPLEFT", GVAR.MainFrame, "TOPLEFT", 22, 0)
	GVAR.MainFrame.HPBG = GVAR.MainFrame.HP:CreateTexture(nil, "BACKGROUND")
	GVAR.MainFrame.HPBG:SetAllPoints(GVAR.MainFrame.HP)
	GVAR.MainFrame.HPBG:SetTexture(0, 0, 0, 1)
	GVAR.MainFrame.HPText = GVAR.MainFrame.HP:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.MainFrame.HPText:SetAllPoints(GVAR.MainFrame.HP)
	GVAR.MainFrame.HPText:SetJustifyH("CENTER")
	GVAR.MainFrame.HPText:SetJustifyV("MIDDLE")

	GVAR.MainFrame.DMG = CreateFrame("Button", nil, GVAR.MainFrame)
	GVAR.MainFrame.DMG:SetFrameLevel(GVAR.MainFrame:GetFrameLevel()+1)
	GVAR.MainFrame.DMG:SetWidth(sizeTimerWidth)
	GVAR.MainFrame.DMG:SetHeight(11)
	GVAR.MainFrame.DMG:ClearAllPoints()
	GVAR.MainFrame.DMG:SetPoint("TOPLEFT", GVAR.MainFrame, "TOPLEFT", 22, -11)
	GVAR.MainFrame.DMGBG = GVAR.MainFrame.DMG:CreateTexture(nil, "BACKGROUND")
	GVAR.MainFrame.DMGBG:SetAllPoints(GVAR.MainFrame.DMG)
	GVAR.MainFrame.DMGBG:SetTexture(0, 0, 0, 1)
	GVAR.MainFrame.DMGText = GVAR.MainFrame.DMG:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	GVAR.MainFrame.DMGText:SetAllPoints(GVAR.MainFrame.DMG)
	GVAR.MainFrame.DMGText:SetJustifyH("CENTER")
	GVAR.MainFrame.DMGText:SetJustifyV("MIDDLE")

	GVAR.MainFrame.TickTimer = CreateFrame("Button", nil, GVAR.MainFrame)
	GVAR.MainFrame.TickTimer:SetFrameLevel(GVAR.MainFrame:GetFrameLevel()+1)
	GVAR.MainFrame.TickTimer:SetWidth(sizeTimerWidth)
	GVAR.MainFrame.TickTimer:SetHeight(11)
	GVAR.MainFrame.TickTimer:ClearAllPoints()
	GVAR.MainFrame.TickTimer:SetPoint("TOPLEFT", GVAR.MainFrame, "TOPLEFT", 22, -11)
	GVAR.MainFrame.TickTimerTexture = GVAR.MainFrame.TickTimer:CreateTexture(nil, "ARTWORK")
	GVAR.MainFrame.TickTimerTexture:SetWidth(0.01)
	GVAR.MainFrame.TickTimerTexture:SetHeight(6)
	GVAR.MainFrame.TickTimerTexture:SetPoint("TOPLEFT", GVAR.MainFrame, "TOPLEFT", 22, -13.5)
	GVAR.MainFrame.TickTimerTexture:SetTexture(0.12, 0.34, 0.45, 1)

	GVAR.MainFrame.Tick = CreateFrame("Button", nil, GVAR.MainFrame)
	GVAR.MainFrame.Tick:SetFrameLevel(GVAR.MainFrame:GetFrameLevel()+2)
	GVAR.MainFrame.Tick:SetWidth(24)
	GVAR.MainFrame.Tick:SetHeight(24)
	GVAR.MainFrame.Tick:ClearAllPoints()
	GVAR.MainFrame.Tick:SetPoint("TOPLEFT", GVAR.MainFrame, "TOPLEFT", 22, 0)
	GVAR.MainFrame.TickBG = GVAR.MainFrame.Tick:CreateTexture(nil, "BACKGROUND")
	GVAR.MainFrame.TickBG:SetAllPoints(GVAR.MainFrame.Tick)
	GVAR.MainFrame.TickBG:SetTexture(1, 1, 1, 0)
	GVAR.MainFrame.TickText = GVAR.MainFrame.Tick:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
	GVAR.MainFrame.TickText:SetTextColor(1, 1, 1, 1)
	GVAR.MainFrame.TickText:SetAllPoints(GVAR.MainFrame.Tick)
	GVAR.MainFrame.TickText:SetJustifyH("LEFT")
	GVAR.MainFrame.TickText:SetJustifyV("MIDDLE")

	--GVAR.MainFrame.Duration = CreateFrame("Button", nil, GVAR.MainFrame)
	--GVAR.MainFrame.Duration:SetFrameLevel(GVAR.MainFrame:GetFrameLevel()+1)
	--GVAR.MainFrame.Duration:SetWidth(sizeTimerWidth)
	--GVAR.MainFrame.Duration:SetHeight(10)
	--GVAR.MainFrame.Duration:ClearAllPoints()
	--GVAR.MainFrame.Duration:SetPoint("TOPLEFT", GVAR.MainFrame, "TOPLEFT", 22, -22)
	--GVAR.MainFrame.DurationBG = GVAR.MainFrame.Duration:CreateTexture(nil, "BACKGROUND")
	--GVAR.MainFrame.DurationBG:SetAllPoints(GVAR.MainFrame.Duration)
	--GVAR.MainFrame.DurationBG:SetTexture(0, 0, 0, 1)
	--GVAR.MainFrame.DurationText = GVAR.MainFrame.Duration:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	--GVAR.MainFrame.DurationText:SetAllPoints(GVAR.MainFrame.Duration)
	--GVAR.MainFrame.DurationText:SetJustifyH("CENTER")
	--GVAR.MainFrame.DurationText:SetJustifyV("MIDDLE")
	--GVAR.MainFrame.DurationText:SetTextColor(1, 1, 0.82, 1)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function DrainSouler:DisableMovement()
	GVAR.MainFrame.Icon:SetScript("OnMouseDown", nil)
	GVAR.MainFrame.Icon:SetScript("OnMouseUp", nil)
	GVAR.MainFrame.Icon:SetScript("OnHide", nil)
	GVAR.MainFrame.Icon:EnableMouse(false)
	GVAR.MainFrame.HP:SetScript("OnMouseDown", nil)
	GVAR.MainFrame.HP:SetScript("OnMouseUp", nil)
	GVAR.MainFrame.HP:SetScript("OnHide", nil)
	GVAR.MainFrame.HP:EnableMouse(false)
	GVAR.MainFrame.DMG:SetScript("OnMouseDown", nil)
	GVAR.MainFrame.DMG:SetScript("OnMouseUp", nil)
	GVAR.MainFrame.DMG:SetScript("OnHide", nil)
	GVAR.MainFrame.DMG:EnableMouse(false)
	GVAR.MainFrame.TickTimer:SetScript("OnMouseDown", nil)
	GVAR.MainFrame.TickTimer:SetScript("OnMouseUp", nil)
	GVAR.MainFrame.TickTimer:SetScript("OnHide", nil)
	GVAR.MainFrame.TickTimer:EnableMouse(false)
	GVAR.MainFrame.Tick:SetScript("OnMouseDown", nil)
	GVAR.MainFrame.Tick:SetScript("OnMouseUp", nil)
	GVAR.MainFrame.Tick:SetScript("OnHide", nil)
	GVAR.MainFrame.Tick:EnableMouse(false)
	--GVAR.MainFrame.Duration:SetScript("OnMouseDown", nil)
	--GVAR.MainFrame.Duration:SetScript("OnMouseUp", nil)
	--GVAR.MainFrame.Duration:SetScript("OnHide", nil)
	--GVAR.MainFrame.Duration:EnableMouse(false)
end

function DrainSouler:EnableMovement()
	GVAR.MainFrame.Icon:SetScript("OnMouseDown", OnMouseDown)
	GVAR.MainFrame.Icon:SetScript("OnMouseUp", OnMouseUp)
	GVAR.MainFrame.Icon:SetScript("OnHide", OnMouseUp)
	GVAR.MainFrame.Icon:EnableMouse(true)
	GVAR.MainFrame.HP:SetScript("OnMouseDown", OnMouseDown)
	GVAR.MainFrame.HP:SetScript("OnMouseUp", OnMouseUp)
	GVAR.MainFrame.HP:SetScript("OnHide", OnMouseUp)
	GVAR.MainFrame.HP:EnableMouse(true)
	GVAR.MainFrame.DMG:SetScript("OnMouseDown", OnMouseDown)
	GVAR.MainFrame.DMG:SetScript("OnMouseUp", OnMouseUp)
	GVAR.MainFrame.DMG:SetScript("OnHide", OnMouseUp)
	GVAR.MainFrame.DMG:EnableMouse(true)
	GVAR.MainFrame.TickTimer:SetScript("OnMouseDown", OnMouseDown)
	GVAR.MainFrame.TickTimer:SetScript("OnMouseUp", OnMouseUp)
	GVAR.MainFrame.TickTimer:SetScript("OnHide", OnMouseUp)
	GVAR.MainFrame.TickTimer:EnableMouse(true)
	GVAR.MainFrame.Tick:SetScript("OnMouseDown", OnMouseDown)
	GVAR.MainFrame.Tick:SetScript("OnMouseUp", OnMouseUp)
	GVAR.MainFrame.Tick:SetScript("OnHide", OnMouseUp)
	GVAR.MainFrame.Tick:EnableMouse(true)
	--GVAR.MainFrame.Duration:SetScript("OnMouseDown", OnMouseDown)
	--GVAR.MainFrame.Duration:SetScript("OnMouseUp", OnMouseUp)
	--GVAR.MainFrame.Duration:SetScript("OnHide", OnMouseUp)
	--GVAR.MainFrame.Duration:EnableMouse(true)
end

function DrainSouler:SetupSize()
	GVAR.MainFrame.Icon:SetScale(DrainSouler_Options.Size)
	GVAR.MainFrame.HP:SetScale(DrainSouler_Options.Size)
	GVAR.MainFrame.DMG:SetScale(DrainSouler_Options.Size)
	GVAR.MainFrame.TickTimer:SetScale(DrainSouler_Options.Size)
	GVAR.MainFrame.Tick:SetScale(DrainSouler_Options.Size)
	--GVAR.MainFrame.Duration:SetScale(DrainSouler_Options.Size)
end

function DrainSouler:EnableConfigMode()
	configMode = true
	if ((DrainSouler_Options.TalentDependent and isAffliction) or (not DrainSouler_Options.TalentDependent)) then
		GVAR.MainFrame:Show()
		GVAR.MainFrame.Icon:Show()
	else
		GVAR.MainFrame:Hide()
	end
	GVAR.OptionsFrame:Show()
	
	GVAR.MainFrame.HPText:SetText(L["HP%"])
	GVAR.MainFrame.DMGText:SetText(L["DMG"])
	GVAR.MainFrame.TickText:SetText(L["X"])
	--GVAR.MainFrame.DurationText:SetText("15000ms")

	DrainSouler:UnregisterEvent("PLAYER_TARGET_CHANGED")
	DrainSouler:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	DrainSouler:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	DrainSouler:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	DrainSouler:UnregisterEvent("PLAYER_REGEN_DISABLED")
	DrainSouler:UnregisterEvent("PLAYER_REGEN_ENABLED")
	DrainSouler:UnregisterEvent("UNIT_HEALTH")
end

function DrainSouler:DisableConfigMode()
	configMode = nil
	GVAR.OptionsFrame:Hide()

	GVAR.MainFrame.HPText:SetText("")
	GVAR.MainFrame.DMGText:SetText("")
	GVAR.MainFrame.TickText:SetText("")
	--GVAR.MainFrame.DurationText:SetText("")

	if InCombatLockdown() then
		inCombat = true
	else
		inCombat = false
	end

	if ((DrainSouler_Options.TalentDependent and isAffliction) or (not DrainSouler_Options.TalentDependent)) then
		DrainSouler:RegisterEvent("PLAYER_TARGET_CHANGED")
		DrainSouler:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		DrainSouler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
		DrainSouler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
		DrainSouler:RegisterEvent("PLAYER_REGEN_DISABLED")
		DrainSouler:RegisterEvent("PLAYER_REGEN_ENABLED")
		TargetUnitCheck()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function DrainSouler:Initialize()
	-- NOTE: GetPrimaryTalentTree returns a correct value at PLAYER LOGIN, GetTalentTabInfo does not
	local primaryTalent = GetPrimaryTalentTree(false, nil)
	isAffliction = nil
	if primaryTalent and primaryTalent == 1 then
		isAffliction = true
	end

	if DrainSouler_Options.Lock then
		DrainSouler:DisableMovement()
		GVAR.OptionsFrame.MoveNote:SetTextColor(0, 0, 0, 1)
	else
		DrainSouler:EnableMovement()
		GVAR.OptionsFrame.MoveNote:SetTextColor(1, 1, 0.5, 1)
	end

	DrainSouler:SetupSize()

	if DrainSouler_Options.posX then
		GVAR.MainFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", DrainSouler_Options.posX, DrainSouler_Options.posY)
	end

	if DrainSouler_Options.config_posX then
		GVAR.OptionsFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", DrainSouler_Options.config_posX, DrainSouler_Options.config_posY)
	end

	if DrainSouler_Options.configMode then
		DrainSouler:EnableConfigMode()
	else
		DrainSouler:DisableConfigMode()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local function OnEvent(self, event, ...)
	if event == "UNIT_HEALTH" then
		local arg1 = ...
		if arg1 ~= "target" then return end
		CheckHealth()
	elseif event == "PLAYER_TARGET_CHANGED" then
		TargetUnitCheck()
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		local arg1, arg2 = ...
		if arg1 ~= "player" then return end
		if arg2 ~= DrainSoulName then return end

		local _, _, _, _, startTime, endTime = UnitChannelInfo("player")
		if not startTime then return end
		if not endTime then return end

		dsTick = 0
		GVAR.MainFrame.TickText:SetText("")
		dsDif = endTime-startTime
		--GVAR.MainFrame.DurationText:SetText(dsDif.."ms")

		if not dsTimeTable[dsDif] then
			dsTimeTable[dsDif] = {}
		end

		if not dsTimeTable[dsDif][0] then
			dsTimeTable[dsDif][0] = {}
			dsTimeTable[dsDif][0].ncnt = 0
			dsTimeTable[dsDif][0].brk = false
			dsTimeTable[dsDif][0].bcnt = 0
		end

		dsIsActive = true
		DrainSouler:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		dsDuration = endTime-startTime
		dsStart = startTime
		GVAR.MainFrame.TickTimer:Show()
		GVAR.MainFrame.TickTimer:SetScript("OnUpdate", TickTimer)
	elseif event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		local arg1, arg2 = ...
		if arg1 ~= "player" then return end
		if arg2 ~= DrainSoulName then return end

		local _, _, _, _, startTime, endTime = UnitChannelInfo("player")
		if not startTime then return end
		if not endTime then return end

		local brkDif = endTime-startTime

		if brkDif ~= dsDif then
			dsTick = 0
			dsDif = brkDif
			--GVAR.MainFrame.DurationText:SetText(dsDif.."ms")

			if not dsTimeTable[dsDif] then
				dsTimeTable[dsDif] = {}
			end

			if not dsTimeTable[dsDif][0] then
				dsTimeTable[dsDif][0] = {}
				dsTimeTable[dsDif][0].ncnt = 0
				dsTimeTable[dsDif][0].brk = false
				dsTimeTable[dsDif][0].bcnt = 0
			end
			dsDuration = endTime-startTime
			dsStart = startTime
		else
			dsDuration = endTime-dsStart
			--GVAR.MainFrame.DurationText:SetText(dsDif.."ms")--TEST

			if not dsTimeTable[dsDif][dsTick] then
				dsTimeTable[dsDif][dsTick] = {}
				dsTimeTable[dsDif][dsTick].ncnt = 0
				dsTimeTable[dsDif][dsTick].brk = true
				dsTimeTable[dsDif][dsTick].bcnt = 0
			else
				dsTimeTable[dsDif][dsTick].brk = true
			end
		end
	elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		local arg1, arg2 = ...
		if arg1 ~= "player" then return end
		if arg2 ~= DrainSoulName then return end

		GVAR.MainFrame.TickTimer:SetScript("OnUpdate", nil)
		DrainSouler:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		dsDuration = nil
		dsIsActive = nil
		GVAR.MainFrame.TickText:SetText("")
		GVAR.MainFrame.DMGText:SetText("")
		GVAR.MainFrame.TickTimer:Hide()
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, arg2, _, arg4, _, _, _, _, _, _, _, _, arg13, _, arg15 = ...
		if arg4 ~= PlayerGUID then return end
		if arg13 ~= DrainSoulName then return end
		if arg2 ~= "SPELL_PERIODIC_DAMAGE" then return end

		local _, _, _, _, startTime, endTime = UnitChannelInfo("player")
		if not endTime then return end

		dsStart = GetTime()*1000
		dsDuration = endTime-dsStart

		if dsTick == 0 then
			local value = math_floor(dsDif - dsDuration + 0.5)
			if dsTimeTable[dsDif][0].brk then
				if dsTimeTable[dsDif][0].bcnt > 0 then
					dsTimeTable[dsDif][0].bavg = math_floor( (  ( (dsTimeTable[dsDif][0].bavg * dsTimeTable[dsDif][0].bcnt) + value ) / (dsTimeTable[dsDif][0].bcnt+1)  ) + 0.5 )
					dsTimeTable[dsDif][0].bcnt = dsTimeTable[dsDif][0].bcnt + 1
				else
					dsTimeTable[dsDif][0].bavg = value
					dsTimeTable[dsDif][0].bcnt = 1
				end
			else
				if dsTimeTable[dsDif][0].ncnt > 0 then
					dsTimeTable[dsDif][0].navg = math_floor( (  ( (dsTimeTable[dsDif][0].navg * dsTimeTable[dsDif][0].ncnt) + value ) / (dsTimeTable[dsDif][0].ncnt+1)  ) + 0.5 )
				else
					dsTimeTable[dsDif][0].navg = value
				end
				dsTimeTable[dsDif][0].ncnt = dsTimeTable[dsDif][0].ncnt + 1
			end
		else
			if not dsTimeTable[dsDif][dsTick] then
				dsTimeTable[dsDif][dsTick] = {}
				dsTimeTable[dsDif][dsTick].ncnt = 0
				dsTimeTable[dsDif][dsTick].brk = false
			end
			local value = math_floor(dsTimeTable[dsDif][dsTick-1].pre - dsDuration + 0.5)
			if value <= 0 then
				value = math_floor(dsTimeTable[dsDif][dsTick-1].pre + 0.5)
			end
			if dsTimeTable[dsDif][dsTick].brk then
				if dsTimeTable[dsDif][dsTick].bavg and dsTimeTable[dsDif][dsTick].bcnt > 0 then
					dsTimeTable[dsDif][dsTick].bavg = math_floor( (  ( (dsTimeTable[dsDif][dsTick].bavg * dsTimeTable[dsDif][dsTick].bcnt) + value ) / (dsTimeTable[dsDif][dsTick].bcnt+1)  ) + 0.5 )
					dsTimeTable[dsDif][dsTick].bcnt = dsTimeTable[dsDif][dsTick].bcnt + 1
				else
					dsTimeTable[dsDif][dsTick].bavg = value
					dsTimeTable[dsDif][dsTick].bcnt = 1
				end
			else
				if dsTimeTable[dsDif][dsTick].navg and dsTimeTable[dsDif][dsTick].ncnt > 0 then
					dsTimeTable[dsDif][dsTick].navg = math_floor( (  ( (dsTimeTable[dsDif][dsTick].navg * dsTimeTable[dsDif][dsTick].ncnt) + value ) / (dsTimeTable[dsDif][dsTick].ncnt+1)  ) + 0.5 )
				else
					dsTimeTable[dsDif][dsTick].navg = value
				end
				dsTimeTable[dsDif][dsTick].ncnt = dsTimeTable[dsDif][dsTick].ncnt + 1
			end
		end
		dsTimeTable[dsDif][dsTick].pre = dsDuration
		dsTimeTable[dsDif][dsTick].brk = false

		dsTick = dsTick + 1

		if DrainSouler_Options.TickSound > 1 then
			PlaySoundFile(soundsTick[DrainSouler_Options.TickSound].path, soundChannel[DrainSouler_Options.TickSoundChannel].channel)
		end
		GVAR.MainFrame.TickText:SetText(dsTick)
		GVAR.MainFrame.DMGText:SetText(arg15)
	elseif event == "PLAYER_REGEN_DISABLED" then
		inCombat = true
		TargetUnitCheck()
	elseif event == "PLAYER_REGEN_ENABLED" then
		inCombat = false
		TargetUnitCheck()
		-- remove old (15min/900sec) mob data from mobTable
		local time = GetTime()-900 -- GetTime()-(15*60)
		for guid, timestamp in pairs(mobTable) do
			if timestamp < time then
				mobTable[guid] = nil
			end
		end
	elseif event == "PLAYER_TALENT_UPDATE" then
		if not loginCheck then return end
		DrainSouler:CheckTalent()
	elseif event == "PLAYER_ENTERING_WORLD" then
		loginCheck = true
		DrainSouler:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "PLAYER_LOGIN" then
		DrainSouler:InitOptions()
		DrainSouler:CreateInterfaceOptions()
		DrainSouler:CreateOptionsFrame()
		DrainSouler:CreateMainFrame()
		DrainSouler:Initialize()
		PlayerGUID = UnitGUID("player")
		DrainSouler:UnregisterEvent("PLAYER_LOGIN")
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

DrainSouler:RegisterEvent("PLAYER_TALENT_UPDATE")
DrainSouler:RegisterEvent("PLAYER_ENTERING_WORLD")
DrainSouler:RegisterEvent("PLAYER_LOGIN")
DrainSouler:SetScript("OnEvent", OnEvent)