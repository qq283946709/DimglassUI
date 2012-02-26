  local addon, ns = ...
  local cfg = CreateFrame("Frame")

  -----------------------------
  -- MEDIA
  -----------------------------
  local MediaPath = "Interface\\AddOns\\m_Nameplates\\media\\"
  cfg.statusbar_texture = "Interface\\Buttons\\WHITE8x8"
  cfg.backdrop_edge_texture = MediaPath.."glowTex"
  cfg.font = "Fonts\\FRIZQT__.ttf"
  
  -----------------------------
  -- CONFIG
  -----------------------------
  cfg.fontsize = 12					-- Font size for Name and HP text
  cfg.fontflag = "OUTLINE"		-- Text outline
  cfg.hpHeight = 9					-- Health bar height
  cfg.hpWidth = 120					-- Health bar width
  cfg.raidIconSize = 18				-- Raid icon size
  cfg.cbIconSize = 20				-- Cast bar icon size
  cfg.cbHeight = 5					-- Cast bar height
  cfg.cbWidth = 120					-- Cast bar width
  cfg.combat_toggle = false 			-- If set to true nameplates will be automatically toggled on when you enter the combat
  
  -- HANDOVER
  ns.cfg = cfg
