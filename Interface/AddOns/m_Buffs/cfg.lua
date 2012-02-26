  local addon, ns = ...
  local cfg = CreateFrame("Frame")

  -----------------------------
  -- MEDIA
  -----------------------------
  local MediaPath = "Interface\\Addons\\m_Buffs\\media\\"
  cfg.auratex = MediaPath.."iconborder" 
  cfg.font = GameTooltipText:GetFont()
  cfg.backdrop_texture = MediaPath.."backdrop"
  cfg.backdrop_edge_texture = MediaPath.."backdrop_edge"
  
  -----------------------------
  -- CONFIG
  -----------------------------
  cfg.iconsize = 30 									-- Buffs and debuffs size
  cfg.disable_timers = false							-- Disable buffs/debuffs timers
  cfg.timefontsize = 13									-- Time font size
  cfg.countfontsize = 13								-- Count font size
  cfg.spacing = 4										-- Spacing between icons
  cfg.timeYoffset = -4									-- Verticall offset value for time text field
  cfg.BUFFpos = {"TOPRIGHT","UIParent", -160, -5} 		-- Buffs position
  cfg.DEBUFFpos = {"TOPRIGHT", "UIParent", -160, -100}	-- Debuffs position

  -- HANDOVER
  ns.cfg = cfg
