  
  -- // rActionBarStyler
  -- // zork - 2010
  
  -----------------------------
  -- INIT
  -----------------------------
  
  --get the addon namespace
  local addon, ns = ...
  
  --generate a holder for the config data
  local cfg = CreateFrame("Frame")
  
  -----------------------------
  -- CONFIG
  -----------------------------
  
  --notice on locking
  --keep bars locked, you now have a slash command to lock/unlock your bars ingame
  --use "/rabs" to see the command list
  
  cfg.bars = {
    bar1 = {
      buttonsize      = 26,
      buttonspacing   = 2,
      barscale        = 1.1,
      uselayout2x6    = false,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "TOP", a2 = "CENTER", af = "UIParent", x = 0, y = -184 }, 
      testmode        = false,
    },
    bar2 = {
      buttonsize      = 26,
      buttonspacing   = 2,
      barscale        = 1.1,
      uselayout2x6    = false,
      showonmouseover = false,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "TOP", a2 = "CENTER", af = "UIParent", x = 0, y = -212 }, 
      testmode        = false,
    },
    bar3 = {
      buttonsize      = 26,
      buttonspacing   = 2,
      barscale        = 1.1,
      uselayout2x6    = false,
      showonmouseover = false,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "TOP", a2 = "CENTER", af = "UIParent", x = 0, y = -186 }, 
      testmode        = false,
    },
    bar4 = {
      buttonsize      = 26,
      buttonspacing   = 3,
      barscale        = 1.0,
      showonmouseover = false,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -34, y = 0 }, 
      testmode        = false,
    },
    bar5 = {
      buttonsize      = 26,
      buttonspacing   = 3,
      barscale        = 1.0,
      showonmouseover = false,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -5, y = 0 }, 
      testmode        = false,
    },
    stancebar = {
      buttonsize      = 26,
      buttonspacing   = 2,
      barscale        = 1.1,
      showonmouseover = false,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "TOPLEFT", a2 = "TOPLEFT", af = "UIParent", x = 0, y = 0 }, 
      testmode        = false,
      disable         = false,
    },
    petbar = {
      buttonsize      = 26,
      buttonspacing   = 2,
      barscale        = 1.0,
      showonmouseover = false,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOMRIGHT", a2 = "BOTTOMRIGHT", af = "UIParent", x = -5, y = 140 }, 
      testmode        = false,
      disable         = false,
    },
    extrabar = {
      buttonsize      = 36,
      buttonspacing   = 5,
      barscale        = 0.82,
      userplaced      = true,
      locked          = true,
      pos             = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -400, y = 0 },
      testmode        = false,
      disable         = true,
    },
    micromenu = {
      barscale        = 0.8,
      showonmouseover = true,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "TOP", a2 = "TOP", af = "UIParent", x = 0, y = -5 }, 
      testmode        = false,
      disable         = true,
    },
    bags = {
      barscale        = 0.8,
      showonmouseover = true,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOMRIGHT", a2 = "BOTTOMRIGHT", af = "UIParent", x = -10, y = 10 }, 
      testmode     = false,
      disable         = true,
    },
    totembar = {
      barscale        = 0.8,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOMRIGHT", a2 = "BOTTOMRIGHT", af = "UIParent", x = -5, y = 180 }, 
      testmode        = false,
      disable         = false,
    },
    vehicleexit = {
      buttonsize      = 50,
      barscale        = 0.8,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOMRIGHT", a2 = "BOTTOMRIGHT", af = "UIParent", x = -380, y = 170 }, 
      testmode        = false,
    },
  }

  -----------------------------
  -- CONFIG END
  -----------------------------

  local playername, _ = UnitName("player")
  local _, playerclass = UnitClass("player")
  
  cfg.playername = playername
  cfg.playerclass = playerclass
  
  
  -----------------------------------
  -- SPECIAL CHARACTER CONDITIONS
  -----------------------------------
  if playername == "Rothar" then
    cfg.bars.bar1.uselayout2x6    = true
    cfg.bars.bar2.uselayout2x6    = true
    cfg.bars.stancebar.disable    = true
  end  

  --font
  cfg.font = "FONTS\\FRIZQT__.ttf"
  
  --how many pixels around a bar reserved for dragging?
  cfg.barinset = 10

  --backdrop settings
  cfg.backdrop = { 
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
    edgeFile = "",
    tile = false,
    tileSize = 0, 
    edgeSize = 0, 
    insets = { 
      left = -cfg.barinset, 
      right = -cfg.barinset, 
      top = -cfg.barinset, 
      bottom = -cfg.barinset,
    },
  }
  
  --allows frames to become movable but frames can be locked or set to default positions
  cfg.applyDragFunctionality = function(f,userplaced,locked)
    f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    
    local t = f:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(f)
    t:SetTexture(0,1,0)
    t:SetAlpha(0)
    f.dragtexture = t    
    f:SetHitRectInsets(-15,-15,-15,-15)
    f:SetClampedToScreen(true)
    
    if not userplaced then
      f:SetMovable(false)
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not locked then
        f.dragtexture:SetAlpha(0.2)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnEnter", function(s) 
          GameTooltip:SetOwner(s, "ANCHOR_TOP")
          GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
          GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
          GameTooltip:Show()
        end)
        f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      else
        f.dragtexture:SetAlpha(0)
        f:EnableMouse(nil)
        f:RegisterForDrag(nil)
        f:SetScript("OnEnter", nil)
        f:SetScript("OnLeave", nil)
      end
    end  

    --print(f:GetName())
    --print(f:IsUserPlaced())

  end
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg
