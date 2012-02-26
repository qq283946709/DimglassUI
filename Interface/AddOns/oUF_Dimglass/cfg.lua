local addon, ns = ...
local cfg = CreateFrame("Frame")

--media
cfg.statusbar_texture = "Interface\\Buttons\\WHITE8x8"
cfg.powerbar_texture = "Interface\\Buttons\\WHITE8x8"
cfg.highlight_texture = "Interface\\AddOns\\oUF_Dimglass\\media\\raidbg"
cfg.debuffBorder = "Interface\\AddOns\\oUF_Dimglass\\media\\iconborder"

--font
cfg.font = "Fonts\\ARIALN.ttf"
cfg.fontsize = 14
cfg.fontstyle = "OUTLINE"

--scale
cfg.scale = 1.0

--mode
cfg.HealMode = true						-- use Heal mode, false to use DPS/Tank mode

--frames
cfg.showtot = true 						-- show target of target frame
cfg.showpet = true						-- show pet frame
cfg.showpettarget = true				-- show target of pet frame
cfg.showfocus = true 					-- show focus frame
cfg.showfocustarget = true 				-- show focus target frame
cfg.showBossFrames = true 				-- show boss frame
cfg.showArenaFrames = true				-- show arena frame
cfg.MTFrames = false 					-- show main tank frames

--color
cfg.HealthcolorClass = false			-- health color class, false to color health the default color
cfg.Powercolor = true					-- power color class, false to color power type

--raid
cfg.showraid = true						-- show raid frames
cfg.show40raid = true					-- show 40 raid, you should enable raid frames first to let the option work.
cfg.showIndicators = true 				-- buffs indicators on healframes only
cfg.showAuraWatch = true 				-- buffs timer on raid frames(hots, shields etc)
cfg.enableDebuffHighlight = true 		-- enable *dispelable* debuff highlight for raid frames
cfg.showRaidDebuffs = true 				-- enable important debuff icons to show on raid units
cfg.showLFDIcons = true 				-- Show dungeon role icons in raid/party
cfg.RCheckIcon = true 					-- show raid check icon

--Classpowerbar/Reputationbar/Experiencebar/ThreatBar
cfg.Reputationbar = true 				-- show Reputation bar
cfg.Experiencebar = true 				-- show Experience bar
cfg.ThreatBar = true  					-- show Threat Bar
cfg.showRunebar = true 					-- show DK rune bar
cfg.showHolybar = true 					-- show Paladin HolyPower bar
cfg.showEclipsebar = true 				-- show druid Eclipse bar
cfg.showShardbar = true 				-- show Warlock SoulShard bar
cfg.TotemBars = true

--general
cfg.showPlayerAuras = false	 			-- use a custom player buffs/debuffs frame instead of Blizzard's default.
cfg.Castbars = true 					-- use built-in castbars
cfg.MiniCastbar = false					-- use minicastbar, you should enable build-in castbars first to let the option work.
cfg.showPortrait = true					-- show portrait for player and target
cfg.debuffsOnlyShowPlayer = false		-- only show player casted debuff
cfg.showplayertag = false               -- always show player's tag 
cfg.arrowmouseover = true				-- show arrow when mouseover at raid/party frames

--boss/arena frames' position
cfg.Bosspoint = {"RIGHT", UIParent, "RIGHT", -100, 0}
cfg.BossSpacing = 59

cfg.Arenapoint = {"RIGHT", UIParent, "RIGHT", -100, 0}
cfg.ArenaSpacing = 59

--positions for HealMode
cfg.ThreatBarHpoint = {"CENTER", UIParent, 183, -58}
cfg.PlayerHpoint = {"RIGHT", UIParent, "CENTER", -190, -50}
cfg.TargetHpoint = {"LEFT", UIParent, "CENTER", 190, -50}
cfg.FocusHpoint = {"RIGHT", UIParent, -100, -130}
cfg.FocustargetHpoint = {"RIGHT", UIParent, -100, -105}
cfg.PartyHpoint = {"TOP", UIParent, "CENTER", 0, -268}
cfg.RaidHpoint = {"TOP", UIParent, "CENTER", 0, -268}
cfg.Raid40Hpoint = {"TOP", UIParent, "CENTER", 0, -268}

--positions for Dps/Tank Mode
cfg.ThreatBarpoint = {"BOTTOM", UIParent, 153, 172}
cfg.Playerpoint = {"RIGHT", UIParent, "BOTTOM", -160, 200}
cfg.Targetpoint = {"LEFT", UIParent, "BOTTOM", 160, 200}
cfg.Partypoint = {"TOPLEFT", UIParent, 5, -5}
cfg.Raidpoint = {"TOPLEFT", UIParent, 5, -5}

ns.cfg = cfg