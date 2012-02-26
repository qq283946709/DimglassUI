local addon, ns = ...
local cfg = ns.cfg

local OVERLAY = "Interface\\TargetingFrame\\UI-TargetingFrame-Flash"
local blankTex = "Interface\\Buttons\\WHITE8x8"	

local backdrop = {
	edgeFile = cfg.backdrop_edge_texture, edgeSize = 3,
	insets = {left = 0, right = 0, top = 0, bottom = 0}}

local numChildren = -1
local frames = {}

local f = CreateFrame"Frame"
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", function(self, event)
	if(event=="PLAYER_LOGIN") then
		SetCVar("bloatthreat",0)
		SetCVar("bloattest",0)
		SetCVar("bloatnameplates",0.0)
		SetCVar("ShowClassColorInNameplate",1)
	end
end)

-- format numbers
function round(val, idp)
  if idp and idp > 0 then
    local mult = 10^idp
    return math.floor(val * mult + 0.5) / mult
  end
  return math.floor(val + 0.5)
end

function SVal(val)
	if(val >= 1e6) then
		return round(val/1e6,1).."m"
	elseif(val >= 1e3) then
		return round(val/1e3,1).."k"
	else
		return val
	end
end

local function QueueObject(parent, object)
	parent.queue = parent.queue or {}
	parent.queue[object] = true
end

local function HideObjects(parent)
	for object in pairs(parent.queue) do
		if(object:GetObjectType() == 'Texture') then
			object:SetTexture(nil)
		else
			object:Hide()
		end
	end
end

local function UpdateThreat(frame,elapsed)
	if(frame.region:IsShown()) then
		local _, val = frame.region:GetVertexColor()
		if(val > 0.7) then
			frame.name:SetTextColor(1, 1, 0)
		else
			frame.name:SetTextColor(1, 0, 0)
		end
	else
		frame.name:SetTextColor(1, 1, 1)
	end
	frame.hp:SetStatusBarColor(frame.r, frame.g, frame.b)
	
	if not frame.oldglow:IsShown() then
		frame.hp.hpGlow:SetBackdropBorderColor(0, 0, 0)
	else
		frame.hp.hpGlow:SetBackdropBorderColor(frame.oldglow:GetVertexColor())
	end
	
	-- show current health value
    local minHealth, maxHealth = frame.healthOriginal:GetMinMaxValues()
    local valueHealth = frame.healthOriginal:GetValue()
	local d =(valueHealth/maxHealth)*100

		if(d < 100) and valueHealth > 1 then
			frame.hp.value:SetText(SVal(valueHealth))
			frame.hp.pct:SetText(format("%.1f %s",d,"%"))
		else
			frame.hp.value:SetText("")
			frame.hp.pct:SetText("")
		end

		if(d <= 35 and d >= 25) then
			frame.hp.value:SetTextColor(253/255, 238/255, 80/255)
			frame.hp.pct:SetTextColor(253/255, 238/255, 80/255)
		elseif(d < 25 and d >= 20) then
			frame.hp.value:SetTextColor(250/255, 130/255, 0/255)
			frame.hp.pct:SetTextColor(250/255, 130/255, 0/255)
		elseif(d < 20) then
			frame.hp.value:SetTextColor(200/255, 20/255, 40/255)
			frame.hp.pct:SetTextColor(200/255, 20/255, 40/255)
		else
			frame.hp.value:SetTextColor(1,1,1)
			frame.hp.pct:SetTextColor(1,1,1)
		end	
end

local function UpdateObjects(frame)
	frame = frame:GetParent()
	local r, g, b = frame.hp:GetStatusBarColor()
		local newr, newg, newb
		if g + b == 0 then
			newr, newg, newb = 0.69, 0.31, 0.31
			frame.hp:SetStatusBarColor(0.69, 0.31, 0.31)
		elseif r + b == 0 then
			newr, newg, newb = 0.33, 0.59, 0.33
			frame.hp:SetStatusBarColor(0.33, 0.59, 0.33)
		elseif r + g == 0 then
			newr, newg, newb = 0.31, 0.45, 0.63
			frame.hp:SetStatusBarColor(0.31, 0.45, 0.63)
		elseif 2 - (r + g) < 0.05 and b == 0 then
			newr, newg, newb = 0.71, 0.71, 0.35
			frame.hp:SetStatusBarColor(0.71, 0.71, 0.35)
		else
			newr, newg, newb = r, g, b
		end
	frame.r, frame.g, frame.b = newr, newg, newb
	
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(cfg.hpWidth, cfg.hpHeight)	
	frame.hp:SetPoint('CENTER', frame, 0, 10)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)
	
	frame.name:SetText(frame.oldname:GetText())
	
	frame.highlight:ClearAllPoints()
	frame.highlight:SetAllPoints(frame.hp)

	-- color hp bg dependend on hp color
    local BGr, BGg, BGb = frame.hp:GetStatusBarColor()
	frame.hp.hpbg2:SetVertexColor(BGr*0.18, BGg*0.18, BGb*0.18)
	
	local level, elite, mylevel = tonumber(frame.level:GetText()), frame.elite:IsShown(), UnitLevel("player")
	local lvlr, lvlg, lvlb = frame.level:GetTextColor()
	frame.level:ClearAllPoints()
	frame.level:SetPoint("RIGHT", frame.hp, "LEFT", -2, 0)
	--frame.level:Hide()
	if frame.boss:IsShown() then
		frame.level:SetText("B")
		frame.name:SetText('|cffDC3C2D'..frame.level:GetText()..'|r '..frame.oldname:GetText())
	elseif not elite and level == mylevel then
		frame.name:SetText(frame.oldname:GetText())
	--else
		--frame.level:SetText(level..(elite and "+" or ""))
		--frame.name:SetText(format('|cff%02x%02x%02x', lvlr*255, lvlg*255, lvlb*255)..frame.level:GetText()..'|r '..frame.oldname:GetText())
	end
	
	HideObjects(frame)
end

local function UpdateCastbar(frame)
	--frame:ClearAllPoints()
	--frame:SetSize(cfg.cbWidth, cfg.cbHeight)
	--frame:SetPoint('TOP', frame:GetParent(), 'BOTTOM', 0, -5)
	--frame:GetStatusBarTexture():SetHorizTile(true)

    frame.border:ClearAllPoints()
    frame.border:SetPoint("TOP",frame:GetParent().hp,"BOTTOM", 0,-5)
	frame.border:SetSize(cfg.cbWidth, cfg.cbHeight)
    frame:SetPoint("RIGHT",frame.border,0,0)
    frame:SetPoint("TOP",frame.border,0,0)
    frame:SetPoint("BOTTOM",frame.border,0,0)
    frame:SetPoint("LEFT",frame.border,0,0)

	if not frame.shield:IsShown() then
		frame:SetStatusBarColor(1, 0, 0)
	else
		frame:SetStatusBarColor(0.4,0.4,0.4)
	end
end	

local OnValueChanged = function(self)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
	-- have to define not protected casts colors again due to some weird bug reseting colors when you start channeling a spell 
 	if not self.shield:IsShown() then
		self:SetStatusBarColor(1, 0, 0)
	else
		self:SetStatusBarColor(0.4,0.4,0.4)
	end 
end

local OnSizeChanged = function(self)
	self.needFix = true
end

local function SkinObjects(frame)
	local hp, cb = frame:GetChildren()

	local threat, hpborder, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()
	local _, cbborder, cbshield, cbicon = cb:GetRegions()
	
	frame.healthOriginal = hp
	
	overlay:SetTexture(cfg.statusbar_texture)
	overlay:SetVertexColor(0.25, 0.25, 0.25)
	frame.highlight = overlay
	
	local offset = UIParent:GetScale() / hp:GetEffectiveScale()
	local hpbg = hp:CreateTexture(nil, 'BACKGROUND')
	hpbg:SetPoint('BOTTOMRIGHT', offset, -offset)
	hpbg:SetPoint('TOPLEFT', -offset, offset)
	hpbg:SetTexture(0, 0, 0)

	hp.hpbg2 = hp:CreateTexture(nil, 'BORDER')
	hp.hpbg2:SetAllPoints(hp)
	hp.hpbg2:SetTexture(blankTex)	
	
	hp:HookScript('OnShow', UpdateObjects)
	hp:SetStatusBarTexture(cfg.statusbar_texture)
	frame.hp = hp
	
	hp.hpBorder = CreateFrame("Frame", nil, hp)
	hp.hpBorder:SetPoint("TOPLEFT", hp, "TOPLEFT", -1, 1)
	hp.hpBorder:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", 1, -1)
	hp.hpBorder:SetBackdrop({edgeFile = blankTex, edgeSize = 1,
	insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	hp.hpBorder:SetBackdropBorderColor(65/255, 74/255, 79/255)

	
	hp.hpGlow = CreateFrame("Frame", nil, hp)
	hp.hpGlow:SetPoint("TOPLEFT", hp, "TOPLEFT", -4, 4)
	hp.hpGlow:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", 4, -4)
	hp.hpGlow:SetBackdrop(backdrop)
	hp.hpGlow:SetBackdropColor(0, 0, 0)
	hp.hpGlow:SetBackdropBorderColor(0, 0, 0)
	
	hp.value = hp:CreateFontString(nil, "OVERLAY")	
	hp.value:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
	hp.value:SetPoint("LEFT", hp, "RIGHT", 5, 0)
	
	hp.pct = hp:CreateFontString(nil, "OVERLAY")	
	hp.pct:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
	hp.pct:SetPoint("CENTER", hp, "CENTER", 0, 0)

	local offset = UIParent:GetScale() / cb:GetEffectiveScale()
	local cbbg = cb:CreateTexture(nil, 'BACKGROUND')
	cbbg:SetPoint('BOTTOMRIGHT', offset, -offset)
	cbbg:SetPoint('TOPLEFT', -offset, offset)
	cbbg:SetTexture(0, 0, 0)

	local cbbd = cb:CreateTexture(nil, 'BORDER')
	cbbd:SetAllPoints(cb)
	cbbd:SetTexture(.1, .1, .1)
	cb.border = cbbd

	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPLEFT", hp, "TOPRIGHT", 4, 1)		
	cbicon:SetSize(cfg.cbIconSize, cfg.cbIconSize)
	cbicon:SetTexCoord(.07, .93, .07, .93)
	
	local cbiconbg = cb:CreateTexture(nil, 'BACKGROUND')
	cbiconbg:SetPoint('BOTTOMRIGHT', cbicon, offset, -offset)
	cbiconbg:SetPoint('TOPLEFT', cbicon, -offset, offset)
	cbiconbg:SetTexture(0, 0, 0)
	
	cb.icon = cbicon
	cb.shield = cbshield
	cb:HookScript('OnShow', UpdateCastbar)
	cb:HookScript('OnSizeChanged', OnSizeChanged)
	cb:HookScript('OnValueChanged', OnValueChanged)	
	cb:SetStatusBarTexture(cfg.statusbar_texture)
	frame.cb = cb

	local name = hp:CreateFontString(nil, 'OVERLAY')
	name:SetPoint('BOTTOMLEFT', hp, 'TOPLEFT', -10, 3)
	name:SetPoint('BOTTOMRIGHT', hp, 'TOPRIGHT', 10, 3)
	name:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
	frame.oldname = oldname
	frame.name = name
	
	frame.level = level
	level:SetFont(cfg.font, cfg.fontsize, "OUTLINE")

	frame.elite = elite
	frame.boss = bossicon
	elite:SetTexture(nil)
	bossicon:SetTexture(nil)
	
	raidicon:ClearAllPoints()
	raidicon:SetPoint("BOTTOM", name, "TOP", 0, 0)
	raidicon:SetSize(cfg.raidIconSize, cfg.raidIconSize)	

	frame.oldglow = threat
	threat:SetTexture(nil)
	
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, oldname)

	UpdateObjects(hp)
	UpdateCastbar(cb)

	frames[frame] = true
end

local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local region = frame:GetRegions()

		if(not frames[frame] and (frame:GetName() and frame:GetName():find("NamePlate%d")) and region and region:GetObjectType() == 'Texture' and region:GetTexture() == OVERLAY) then
			SkinObjects(frame)
			frame.region = region
		end
	end
end

CreateFrame('Frame'):SetScript('OnUpdate', function(self, elapsed)
	if(WorldFrame:GetNumChildren() ~= numChildren) then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())
	end

	if(self.elapsed and self.elapsed > 0.1) then
		for frame in pairs(frames) do
			UpdateThreat(frame)
		end

		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end)

if cfg.combat_toggle then
	local h = CreateFrame("Frame", nil, UIParent)
	h:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
	h:RegisterEvent("PLAYER_REGEN_ENABLED")
	function h:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end
	h:RegisterEvent("PLAYER_REGEN_DISABLED")
	function h.PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end