local addon, ns = ...
local cfg = ns.cfg
local cast = ns.cast
local lib = CreateFrame("Frame")  
local _, playerClass = UnitClass("player")
---------------------------------------------------------------------------------
do
	SetFontString = function(parent, fontName, fontSize, fontStyle)
		local fs = parent:CreateFontString(nil, "OVERLAY")
		fs:SetFont(cfg.font, fontSize, fontStyle)
		fs:SetJustifyH("LEFT")
		return fs
	end
end	
local borders = {
	bgFile =  "Interface\\Buttons\\WHITE8x8",
	edgeFile = "Interface\\Buttons\\WHITE8x8", 
	edgeSize = 1,
	tile = false,
	insets = { left = 0, right = 0, top = 0, bottom = 0 }
}
local shadows = {
	edgeFile = "Interface\\AddOns\\oUF_Dimglass\\media\\glowTex", 
	edgeSize = 5,
	tile = false,
	insets = { left = 0, right = 0, top = 0, bottom = 0 }
}
CreateBorder = function(f,x)
	h = CreateFrame("Frame", nil, f)
	h:SetFrameLevel(1)
	h:SetFrameStrata(f:GetFrameStrata())
	h:SetPoint("TOPLEFT", -x, x)
	h:SetPoint("BOTTOMRIGHT", x, -x)
	h:SetBackdrop(borders)
	h:SetBackdropColor(0.1,0.1,0.1,0.6)
	h:SetBackdropBorderColor(65/255, 74/255, 79/255)
end
local CreateHealthBorder = function(f,x)
	h = CreateFrame("Frame", nil, f)
	h:SetFrameLevel(1)
	h:SetFrameStrata(f:GetFrameStrata())
	h:SetPoint("TOPLEFT", -x, x)
	h:SetPoint("BOTTOMRIGHT", x, -x)
	h:SetBackdrop(borders)

	h:SetBackdropColor(1,0,0,0)

	h:SetBackdropBorderColor(65/255, 74/255, 79/255)
end
CreateShadow = function(f,x)
	if f.shadow then return end
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", -x, x)
	shadow:SetPoint("BOTTOMRIGHT", x, -x)
	shadow:SetBackdrop(shadows)
	shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.shadow = shadow
	return shadow
end
lib.menu = function(self)
	local unit = self.unit:gsub("(.)", string.upper, 1)
	if self.unit == "targettarget" then return end
	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif (self.unit:match("party")) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
	end
end
lib.init = function(f)
    f.menu = lib.menu
    f:RegisterForClicks("AnyDown")
	f:SetAttribute("*type1", "target")
    f:SetAttribute("*type2", "menu")
    f:SetScript("OnEnter", UnitFrame_OnEnter)
    f:SetScript("OnLeave", UnitFrame_OnLeave)
end
lib.gen_fontstring = function(f, name, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, outline)
    return fs
end
HidePortrait = function(self, unit)
	if self.unit == "target" then
		if not UnitExists(self.unit) or not UnitIsConnected(self.unit) or not UnitIsVisible(self.unit) then
			self.Portrait:SetAlpha(0)
		else
			self.Portrait:SetAlpha(1)
		end
	end
end
lib.gen_portrait = function(f)
	local portrait = CreateFrame("PlayerModel", nil, f)
	portrait.PostUpdate = function(f) f:SetAlpha(0) f:SetAlpha(0.3) end -- edit the 0.15 to the alpha you want
	portrait:SetSize(220,10)
	portrait:SetAllPoints(f.Power)
	table.insert(f.__elements, HidePortrait)
	f.Portrait = portrait
end
lib.PortraitPostUpdate = function(element, unit)
	if not UnitExists(unit) or not UnitIsConnected(unit) or not UnitIsVisible(unit) then
		element:Hide()
	else
		element:Show()
		element:SetCamera(0)
	end
end
do
	UpdateShards = function(self, event, unit, powerType)
		if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end
		local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
		for i = 1, SHARD_BAR_NUM_SHARDS do
			if(i <= num) then
				self.SoulShards[i]:SetAlpha(1)
			else
				self.SoulShards[i]:SetAlpha(.2)
			end
		end
	end

	UpdateHoly = function(self, event, unit, powerType)
		if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end
		local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
		for i = 1, MAX_HOLY_POWER do
			if(i <= num) then
				self.HolyPower[i]:SetAlpha(1)
			else
				self.HolyPower[i]:SetAlpha(.2)
			end
		end
	end	
			
	ComboDisplay = function(self, event, unit)
		if(unit == 'pet') then return end
		
		local cpoints = self.CPoints
		local cp
		if (UnitHasVehicleUI("player") or UnitHasVehicleUI("vehicle")) then
			cp = GetComboPoints('vehicle', 'target')
		else
			cp = GetComboPoints('player', 'target')
		end

		for i=1, MAX_COMBO_POINTS do
			if(i <= cp) then
				cpoints[i]:SetAlpha(1)
			else
				cpoints[i]:SetAlpha(0.15)
			end
		end
		
		if cpoints[1]:GetAlpha() == 1 then
			for i=1, MAX_COMBO_POINTS do
				cpoints[i]:Show()
			end
			
		else
			for i=1, MAX_COMBO_POINTS do
				cpoints[i]:Hide()
			end
			
		end
	end
end
AltPowerBarOnToggle = function(self)
	local unit = self:GetParent().unit or self:GetParent():GetParent().unit					
end
AltPowerBarPostUpdate = function(self, min, cur, max)
	local perc = math.floor((cur/max)*100)
	
	if perc < 35 then
		self:SetStatusBarColor(0, 1, 0)
	elseif perc < 70 then
		self:SetStatusBarColor(1, 1, 0)
	else
		self:SetStatusBarColor(1, 0, 0)
	end

	local unit = self:GetParent().unit or self:GetParent():GetParent().unit
			
	local type = select(10, UnitAlternatePowerInfo(unit))
end
lib.updateHealth = function(bar, unit, min, max)
	local color, t = {1, 0, 0} 
	if(UnitIsPlayer(unit)) then
	   local _, class = UnitClass(unit)
	   t = bar:GetParent().colors.class[class]
	end
	if(t) then
	   r, g, b = t[1], t[2], t[3]
	else	
        r, g, b = 1, 0, 0
	end
	if not cfg.HealthcolorClass then
		bar.bg:SetVertexColor(r, g, b, 0.35)
	else
		bar.bg:SetVertexColor(1, 0.2, 0.2, 0.15)
	end
end
lib.gen_hpbar = function(f)
	--statusbar
	local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(cfg.statusbar_texture)
	s:SetPoint("TOPLEFT")
	s:SetPoint("BOTTOMRIGHT")

	if not cfg.HealthcolorClass then
		s:SetStatusBarColor(.1,.1,.1,0.7)
		s.reminder = s:CreateTexture(nil, "OVERLAY")
		s.reminder:SetTexture("Interface\\Buttons\\WHITE8x8")
		s.reminder:SetSize(1,f.height)
		s.reminder:SetPoint("RIGHT", s:GetStatusBarTexture())
		--s.reminder:SetVertexColor(65/255, 74/255, 79/255)
		s.reminder:SetVertexColor(0,0,0)
	end
	
	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture("Interface\\Buttons\\WHITE8x8")
	b:SetAllPoints(s)
	
	--border,shadow
	CreateHealthBorder(s,1)
	CreateShadow(s,6)
	
	f.Health = s
	f.Health.bg = b

	f.Health.PostUpdate = lib.updateHealth
end
lib.gen_ppbar = function(f)
	--statusbar
	local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(cfg.statusbar_texture)

	if f.mystyle == "partyforhealer" or f.mystyle == "raidfordps" or f.mystyle == "raid25" or f.mystyle == "raid40" then
		s:SetHeight(2)
	else
		s:SetHeight(10)
	end
	s:SetPoint("LEFT")
	s:SetPoint("RIGHT")
	s:SetPoint("TOP",f,"BOTTOM",0,-6)
	CreateBorder(s,1)
	CreateShadow(s,6)
	
	if not cfg.showplayertag then
		if f.mystyle == "player" then
			s:RegisterEvent("PLAYER_REGEN_DISABLED")
			s:RegisterEvent("PLAYER_REGEN_ENABLED")
			s:SetScript("OnEnter",function(self)
				UIFrameFadeIn(f.Tagcontainer, 0.5, f.Tagcontainer:GetAlpha(), 1)
			end)
			s:SetScript("OnLeave",function(self)
				UIFrameFadeIn(f.Tagcontainer, 0.5, f.Tagcontainer:GetAlpha(), 0)
			end)
			s:SetScript("OnEvent",function(self,event)
				if event == "PLAYER_REGEN_DISABLED" then
					f.Tagcontainer:SetAlpha(1)
				elseif event == "PLAYER_REGEN_ENABLED" then
					UIFrameFadeIn(f.Tagcontainer, 0.5, f.Tagcontainer:GetAlpha(), 0)
				end
			end)
		end
	end

	f.Power = s
end
lib.gen_tagcontainer = function(f)
	local hr = CreateFrame("Frame", nil, f)
	
	if f.mystyle == "player" then
		hr:SetPoint("LEFT")
		hr:SetPoint("RIGHT")
		hr:SetPoint("BOTTOM",f,"TOP",0,6)
		hr:SetHeight(1)
		CreateBorder(hr,1)
		CreateShadow(hr,6)
		
		if not cfg.showplayertag then
			hr:SetAlpha(0)
		end

	elseif f.mystyle == "target" then
		hr:SetPoint("LEFT")
		hr:SetPoint("RIGHT")
		hr:SetPoint("BOTTOM",f,"TOP",0,6)
		hr:SetHeight(1)
		CreateBorder(hr,1)
		CreateShadow(hr,6)
	else
		hr:SetAllPoints(f.Health)
	end
	f.Tagcontainer = hr
end
lib.gen_hpstrings = function(f)
	local perhpval = lib.gen_fontstring(f.Health, cfg.font, cfg.fontsize - 2, cfg.fontstyle)
	perhpval.frequentUpdates = 0.1
	if f.mystyle == "player" or f.mystyle == "target" then
		local perhpval = lib.gen_fontstring(f.Tagcontainer, cfg.font, cfg.fontsize - 2, cfg.fontstyle)
		perhpval:SetPoint("RIGHT", f.Health:GetStatusBarTexture())
		f:Tag(perhpval, "[perhp]")
	elseif f.mystyle == "partyforhealer" or f.mystyle == "raidfordps" or f.mystyle == "raid25" or f.mystyle == "raid40" then
	else
		perhpval:SetPoint("RIGHT",f)
		f:Tag(perhpval, "[perhp]")
	end
	
	local hapval = lib.gen_fontstring(f.Health, cfg.font, cfg.fontsize - 2, cfg.fontstyle)
	hapval.frequentUpdates = 0.1
	if f.mystyle == "player" then
		local hapval = lib.gen_fontstring(f.Tagcontainer, cfg.font, cfg.fontsize - 2, cfg.fontstyle)
		hapval:SetPoint("BOTTOMRIGHT", f.Tagcontainer)
		f:Tag(hapval, "[hp]   [color][power]")
	elseif f.mystyle == "target" then
		hapval:SetPoint("BOTTOMRIGHT", f.Tagcontainer)
		f:Tag(hapval, "[hp]   [color][power]")
	elseif f.mystyle == "focus" then
		local hapval = lib.gen_fontstring(f.Health, cfg.font, 9, cfg.fontstyle)
		hapval:SetPoint("CENTER", f.Tagcontainer, 0, -19)
		f:Tag(hapval, "[color][perpp]")
	end
	
	local name = lib.gen_fontstring(f.Health, cfg.font, cfg.fontsize, cfg.fontstyle)
	name:SetJustifyH("LEFT")
	if f.mystyle == "player" then
		local name = lib.gen_fontstring(f.Tagcontainer, cfg.font, cfg.fontsize, cfg.fontstyle)
		name:SetPoint("BOTTOMLEFT", f.Tagcontainer)
		f:Tag(name, "[color][name][afk]")
	elseif f.mystyle == "target" then
		name:SetPoint("BOTTOMLEFT", f.Tagcontainer)
		f:Tag(name, "[level] [color][name][afk]")
	elseif f.mystyle == "focus" then
		name:SetPoint("LEFT", f.Health)
		f:Tag(name, "[color][name]")
	elseif f.mystyle == "raidfordps" then
		name:SetAllPoints(f)
		f:Tag(name, "[color][name][afk]")
		name:SetJustifyH("CENTER")
	elseif f.mystyle == "partyforhealer" or f.mystyle == "raid25" or f.mystyle == "raid40" then
		name:SetPoint("CENTER")
		f:Tag(name, "[color][name][afk]")
		name:SetJustifyH("CENTER")
	else
		name:SetPoint("LEFT")
		f:Tag(name, "[color][name]")
	end
end
lib.gen_InfoIcons = function(f)
    local h = CreateFrame("Frame",nil,f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
    if f.mystyle == "player" then
      f.Combat = h:CreateTexture(nil, 'OVERLAY')
      f.Combat:SetSize(12,12)
      f.Combat:SetPoint('BOTTOMLEFT', -8, -8)
      f.Combat:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
      f.Combat:SetTexCoord(0.58, 0.90, 0.08, 0.41)
    end
    if f.mystyle == "raidfordps" or f.mystyle == "partyforhealer" or f.mystyle == "raid25" or f.mystyle == "raid40" and cfg.showLFDIcons then 
		f.LFDRole = f.Health:CreateTexture(nil, 'OVERLAY')
		f.LFDRole:SetSize(12, 12)
		f.LFDRole:SetPoint('RIGHT', f, 'LEFT', 6, 0)
    end
    li = h:CreateTexture(nil, "OVERLAY")
    li:SetPoint("TOPLEFT", f, -2, 8)
    li:SetSize(12,12)
    f.Leader = li
    ai = h:CreateTexture(nil, "OVERLAY")
    ai:SetPoint("TOPLEFT", f, -2, 8)
    ai:SetSize(12,12)
    f.Assistant = ai
    local ml = h:CreateTexture(nil, 'OVERLAY')
    ml:SetSize(10,10)
    ml:SetPoint('LEFT', f.Leader, 'RIGHT')
    f.MasterLooter = ml
end
lib.addPhaseIcon = function(self)
	local picon = self.Health:CreateTexture(nil, 'OVERLAY')
	picon:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 40, 8)
	picon:SetSize(12, 12)
	self.PhaseIcon = picon
end
lib.addQuestIcon = function(self)
	local qicon = self.Health:CreateTexture(nil, 'OVERLAY')
	qicon:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 8)
	qicon:SetSize(12, 12)
	self.QuestIcon = qicon
end
lib.gen_RaidMark = function(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
    h:SetAlpha(0.8)
    local ri = h:CreateTexture(nil,'OVERLAY',h)
    ri:SetPoint("CENTER", f, "TOP", 0, 2)
	if f.mystyle == "player" or f.mystyle == "target" then
		ri:SetSize(15, 15)
		ri:SetPoint("CENTER", f, "BOTTOM", 0, -2)
	else
		ri:SetSize(12, 12)
	end
	ri:SetTexture("Interface\\AddOns\\oUF_Dimglass\\media\\raidicons")
    f.RaidIcon = ri
end
lib.gen_highlight = function(self,unit)
    local OnEnter = function(self)
		UnitFrame_OnEnter(self)
		self.Highlight:Show()
		
		ns:arrow(self, self.unit)
    end
    local OnLeave = function(self)
		UnitFrame_OnLeave(self)
		self.Highlight:Hide()
		
		if(self.freebarrow and self.freebarrow:IsShown()) then
			self.freebarrow:Hide()
		end
	end
    self:SetScript("OnEnter", OnEnter)
    self:SetScript("OnLeave", OnLeave)
    local hl = self.Health:CreateTexture(nil, "OVERLAY")
    hl:SetAllPoints(self.Health)
    hl:SetTexture("Interface\\Buttons\\WHITE8x8")
    hl:SetVertexColor(.5,.5,.5,.1)
    hl:SetBlendMode("ADD")
    hl:Hide()
    self.Highlight = hl
end
function lib.CreateTargetBorder(self)
	local glowBorder = {edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1}
	self.TargetBorder = CreateFrame("Frame", nil, self)
	self.TargetBorder:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
	self.TargetBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)
	self.TargetBorder:SetBackdrop(glowBorder)
	self.TargetBorder:SetFrameLevel(2)
	self.TargetBorder:SetBackdropBorderColor(.7,.7,.7,1)
	self.TargetBorder:Hide()
end
function lib.ChangedTarget(self, event, unit)
	if UnitIsUnit('target', self.unit) then
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end
function lib.CreateThreatBorder(self)
	local glowBorder = {edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 2}
	self.Thtborder = CreateFrame("Frame", nil, self)
	self.Thtborder:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
	self.Thtborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
	self.Thtborder:SetBackdrop(glowBorder)
	self.Thtborder:SetFrameLevel(1)
	self.Thtborder:Hide()	
end
function lib.UpdateThreat(self, event, unit)
	if (self.unit ~= unit) then return end
		local status = UnitThreatSituation(unit)
		unit = unit or self.unit
	if status and status > 1 then
		local r, g, b = GetThreatStatusColor(status)
		self.Thtborder:Show()
		self.Thtborder:SetBackdropBorderColor(r, g, b, 1)
	else
		self.Thtborder:SetBackdropBorderColor(r, g, b, 0)
		self.Thtborder:Hide()
	end
end
lib.gen_castbar = function(f)
	if not cfg.Castbars then return end
	local cbColor = {95/255, 182/255, 255/255}
    local s = CreateFrame("StatusBar", "oUF_Castbar"..f.mystyle, f)

	if f.mystyle == "player" then
		if cfg.MiniCastbar then
			s:SetHeight(15)
			s:SetWidth(f.width - 23)
			s:SetPoint("TOPRIGHT", oUF_Player,"BOTTOMRIGHT",0,-23)
		else
			s:SetHeight(18)
			s:SetWidth(250)
			s:SetPoint("CENTER",UIParent,"CENTER",16,-180)
		end
    elseif f.mystyle == "target" then
		if cfg.MiniCastbar then
			s:SetHeight(15)
			s:SetWidth(f.width - 23)
			s:SetPoint("TOPRIGHT", oUF_Target,"BOTTOMRIGHT",0,-23)
		else
			s:SetHeight(15)
			s:SetWidth(220)
			s:SetPoint("CENTER",UIParent,"CENTER",16,-140)
		end
	elseif f.mystyle == "focus" then
		--s:SetHeight(13)
		--s:SetWidth(f:GetWidth()-22)
		s:SetHeight(13)
		s:SetWidth(158)
        s:SetPoint("CENTER",UIParent,"CENTER",10,100)
	elseif f.mystyle == "boss" or f.mystyle == "arena" then
	    s:SetHeight(10)
        s:SetWidth(131)
	    s:SetPoint("TOPRIGHT",f,"BOTTOMRIGHT",0,-23)
	end

    s:SetStatusBarTexture(cfg.statusbar_texture)
    s:SetStatusBarColor(95/255, 182/255, 255/255,1)
    s:SetFrameLevel(1)
    s.CastingColor = cbColor
    s.CompleteColor = {20/255, 208/255, 0/255}
    s.FailColor = {255/255, 12/255, 0/255}
    s.ChannelingColor = cbColor
	CreateBorder(s,1)
	CreateShadow(s,6)
    sp = s:CreateTexture(nil, "OVERLAY")
    sp:SetBlendMode("ADD")
    sp:SetAlpha(0.5)
    sp:SetHeight(s:GetHeight()*2.5)
    local txt = lib.gen_fontstring(s, cfg.font, 10, cfg.fontstyle)
    txt:SetPoint("LEFT", 2, 0)
    txt:SetJustifyH("LEFT")
    local t = lib.gen_fontstring(s, cfg.font, 10, cfg.fontstyle)
    t:SetPoint("RIGHT", -2, 0)
    txt:SetPoint("RIGHT", t, "LEFT", -5, 0)
    local i = s:CreateTexture(nil, "ARTWORK")
    i:SetSize(s:GetHeight(),s:GetHeight())
	if f.mystyle == "target" then
		i:SetSize(s:GetHeight(),s:GetHeight())
	end
	
    i:SetPoint("RIGHT", s, "LEFT", -8, 0)
    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    local ih = CreateFrame("Frame", nil, s)
    ih:SetFrameLevel(0)
    ih:SetPoint("TOPLEFT",i,"TOPLEFT")
    ih:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT")
	CreateBorder(ih,1)
	CreateShadow(ih,6)
    if f.mystyle == "player" then
        local z = s:CreateTexture(nil,"OVERLAY")
        z:SetTexture(cfg.statusbar_texture)
        z:SetVertexColor(1,0.1,0,.6)
        z:SetPoint("TOPRIGHT")
        z:SetPoint("BOTTOMRIGHT")
	    s:SetFrameLevel(10)
        s.SafeZone = z
        local l = lib.gen_fontstring(s, cfg.font, 10, cfg.fontstyle)
        l:SetPoint("CENTER", -2, 17)
        l:SetJustifyH("RIGHT")
	    l:Hide()
        s.Lag = l
        f:RegisterEvent("UNIT_SPELLCAST_SENT", cast.OnCastSent)
    end
    s.OnUpdate = cast.OnCastbarUpdate
    s.PostCastStart = cast.PostCastStart
    s.PostChannelStart = cast.PostCastStart
    s.PostCastStop = cast.PostCastStop
    s.PostChannelStop = cast.PostChannelStop
    s.PostCastFailed = cast.PostCastFailed
    s.PostCastInterrupted = cast.PostCastFailed
	
    f.Castbar = s
    f.Castbar.Text = txt
    f.Castbar.Time = t
    f.Castbar.Icon = i
    f.Castbar.Spark = sp
end
lib.gen_mirrorcb = function(f)
    for _, bar in pairs({'MirrorTimer1','MirrorTimer2','MirrorTimer3',}) do   
      for i, region in pairs({_G[bar]:GetRegions()}) do
        if (region.GetTexture and region:GetTexture() == cfg.statusbar_texture) then
          region:Hide()
        end
      end
      _G[bar..'Border']:Hide()
      _G[bar]:SetParent(UIParent)
      _G[bar]:SetScale(1)
      _G[bar]:SetHeight(15)
      _G[bar]:SetWidth(280)
      _G[bar]:SetBackdropColor(.1,.1,.1)
      _G[bar..'Background'] = _G[bar]:CreateTexture(bar..'Background', 'BACKGROUND', _G[bar])
      _G[bar..'Background']:SetTexture(cfg.statusbar_texture)
      _G[bar..'Background']:SetAllPoints(bar)
      _G[bar..'Background']:SetVertexColor(.15,.15,.15,.75)
      _G[bar..'Text']:SetFont(cfg.font, 13)
      _G[bar..'Text']:ClearAllPoints()
      _G[bar..'Text']:SetPoint('CENTER', MirrorTimer1StatusBar, 0, 1)
      _G[bar..'StatusBar']:SetAllPoints(_G[bar])
      --glowing borders
      CreateBorder(_G[bar],1)
	  CreateShadow(_G[bar],6)
    end
end
local formatTime = function(t)
	local day, hour, minute = 86400, 3600, 60
	if t >= day then
		return format("%dd", floor(t/day + 0.5)), t % day
	elseif t >= hour then
		return format("%dh", floor(t/hour + 0.5)), t % hour
	elseif t >= minute then
		return format("%dm", floor(t/minute + 0.5)), t % minute
	elseif t >= minute / 12 then
		return floor(t + 0.5), (t * 100 - floor(t * 100))/100
	end
	return format("%.1f", t), (t * 100 - floor(t * 100))/100
end
local setTimer = function(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = formatTime(self.timeLeft)
					self.time:SetText(time)
				if self.timeLeft < 5 then
					self.time:SetTextColor(1, 0.5, 0.5)
				else
					self.time:SetTextColor(.7, .7, .7)
				end
			else
				self.time:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end
local postCreateIcon = function(element, button)
	local diffPos = 0
	local self = element:GetParent()
	if self.mystyle == "target" then diffPos = 1 end
	
	element.disableCooldown = true
	button.cd.noOCC = true
	button.cd.noCooldownCount = true
	
	CreateBorder(button,1)
	CreateShadow(button,6)
	
	if self.mystyle == "player" then
		local time = lib.gen_fontstring(button, cfg.font, 13, cfg.fontstyle)
		time:SetPoint("CENTER", button, "CENTER", 2, 0)
		time:SetJustifyH("CENTER")
		time:SetVertexColor(1,1,1)
		button.time = time
	else
		local time = lib.gen_fontstring(button, cfg.font, 10, cfg.fontstyle)
		time:SetPoint("CENTER", button, "CENTER", 2, 0)
		time:SetJustifyH("CENTER")
		time:SetVertexColor(1,1,1)
		button.time = time
	end
	
	
	local count = lib.gen_fontstring(button, cfg.font, 10, cfg.fontstyle)
	count:SetPoint("CENTER", button, "BOTTOMRIGHT", 0, 3)
	count:SetJustifyH("RIGHT")
	button.count = count
		
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer("ARTWORK")
end
local postUpdateIcon = function(element, unit, button, index)
	local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, button.filter)
	
	if duration and duration > 0 then
		button.time:Show()
		button.timeLeft = expirationTime	
		button:SetScript("OnUpdate", setTimer)			
	else
		button.time:Hide()
		button.timeLeft = math.huge
		button:SetScript("OnUpdate", nil)
	end

	if(button.debuff) then
		if(unit == "target") then	
			if (unitCaster == "player" or unitCaster == "vehicle") then
				button.icon:SetDesaturated(false)                 
			elseif(not UnitPlayerControlled(unit)) then -- If Unit is Player Controlled don"t desaturate debuffs
				button:SetBackdropColor(0, 0, 0)
				button.overlay:SetVertexColor(0.3, 0.3, 0.3)      
				button.icon:SetDesaturated(true)  
			end
		end
	end
	button:SetScript('OnMouseUp', function(self, mouseButton)
		if mouseButton == 'RightButton' then
			CancelUnitBuff('player', index)
	end end)
	button.first = true
end
lib.createAuras = function(f)
	Auras = CreateFrame("Frame", nil, f)
	Auras.size = 18		
	Auras:SetHeight(42)
	Auras:SetWidth(f:GetWidth())
	Auras.spacing = 7
	Auras.gap = true
	Auras.initialAnchor = "BOTTOMLEFT"
	Auras["growth-x"] = "RIGHT"		
	Auras["growth-y"] = "DOWN"
	
	if f.mystyle == "target" then
		Auras:SetPoint("LEFT", f, "RIGHT", 10, 15)
		Auras.numBuffs = 10
		Auras.numDebuffs = 10
		Auras.size = 18	
		--Auras.onlyShowPlayer = true
		Auras.spacing = 6
	end
	if f.mystyle == "tot" then
		Auras:SetPoint("LEFT", f, "RIGHT", 10, 10)
		Auras.numBuffs = 0
		Auras.numDebuffs = 5
		Auras.spacing = 6
		Auras.size = 18			
	end
	if f.mystyle == "focus" then
		if cfg.HealMode then
			Auras:SetPoint("TOP", f, "BOTTOM", 0, 0)
		else
			Auras:SetPoint("LEFT", f, "RIGHT", 10, 12)
		end
		Auras.numBuffs = 0
		Auras.numDebuffs = 10
		Auras.spacing = 6
	end
	if f.mystyle == "arena" then
		Auras:SetPoint("TOPRIGHT", f, "TOPLEFT", -8, 0)
		Auras.numBuffs = 20
		Auras.numDebuffs = 0
		Auras.spacing = 8
		Auras.size = 21
		Auras.initialAnchor = "TOPRIGHT"
		Auras["growth-x"] = "LEFT"
	end
	Auras.PostCreateIcon = postCreateIcon
	Auras.PostUpdateIcon = postUpdateIcon
	f.Auras = Auras
end
lib.createBuffs = function(f)
    b = CreateFrame("Frame", nil, f)
	b.size = 20
    b.num = 40
    b.spacing = 8
    b.onlyShowPlayer = cfg.buffsOnlyShowPlayer
    b:SetHeight((b.size+b.spacing)*4)
    b:SetWidth(f:GetWidth())
    if f.mystyle == "target" then
	    b.num = 10
		b:SetPoint("TOP", f, "TOP", 0, 50)
		b.initialAnchor = "TOPLEFT"
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "UP"
    elseif f.mystyle == "player" then
		b:SetWidth(440)
	    b.size = 24
		b:SetPoint("TOPRIGHT", UIParent,  -160, -10)
		b.initialAnchor = "TOPRIGHT"
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
	elseif f.mystyle == "boss" then
	    b.size = 21
		b:SetPoint("TOPRIGHT", f, "TOPLEFT", -8, 0)
		b.initialAnchor = "TOPRIGHT"
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
		b.num = 5
	else
		b.num = 0
    end
    b.PostCreateIcon = postCreateIcon
    b.PostUpdateIcon = postUpdateIcon

    f.Buffs = b
end
lib.createDebuffs = function(f)
    b = CreateFrame("Frame", nil, f)
    b.size = 20
	b.num = 12
	b.onlyShowPlayer = cfg.debuffsOnlyShowPlayer
    b.spacing = 5
    b:SetHeight((b.size+b.spacing)*4)
    b:SetWidth(f:GetWidth())
	if f.mystyle == "target" then
		b:SetPoint("TOP", f, "TOP", 0, 25)
		b.initialAnchor = "TOPLEFT"
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "DOWN"
	elseif f.mystyle == "player" then
		b:SetWidth(440)
	    b.size = 24
		b:SetPoint("TOPRIGHT", UIParent, -160, -130)
		b.initialAnchor = "TOPRIGHT"
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
		b.spacing = 8
	else
		b.num = 0
	end
    b.PostCreateIcon = postCreateIcon
    b.PostUpdateIcon = postUpdateIcon

    f.Debuffs = b
end
function lib.CreateTrinkets(self,unit)
	if (unit and unit:find('arena%d')) then

		local trinket = CreateFrame("Frame", nil, self)
		
		trinket:SetHeight(self.height)
		trinket:SetWidth(self.height)

		trinket:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 0)

		trinket.trinketUseAnnounce = true
		trinket.trinketUpAnnounce = true
		
		CreateBorder(trinket,1)
		CreateShadow(trinket,6)
		self.Trinket = trinket
	end
end
lib.PostUpdateRaidFrame = function(Health, unit, min, max)
	local disconnnected = not UnitIsConnected(unit)
	local dead = UnitIsDead(unit)
	local ghost = UnitIsGhost(unit)
	if disconnnected or dead or ghost then
		Health:SetValue(max)	
		if(disconnnected) then
			Health:SetStatusBarColor(0,0,0,0.6)
		elseif(ghost) then
			Health:SetStatusBarColor(1,1,1,0.6)
		elseif(dead) then
			Health:SetStatusBarColor(1,0,0,0.7)
		end
	else
		if not cfg.HealthcolorClass then
			Health:SetStatusBarColor(.1,.1,.1,0.7)
		end
		Health:SetValue(min)
		if(unit == 'vehicle') then
			Health:SetStatusBarColor(22/255, 106/255, 44/255)
		end
	end
	
	lib.updateHealth(Health, unit, min, max)
end
lib.addEclipseBar = function(self)
	if playerClass ~= "DRUID" then return end
	
	local eclipseBar = CreateFrame('Frame', nil, UIParent)

	if cfg.HealMode then
		eclipseBar:SetFrameStrata("MEDIUM")
		eclipseBar:SetFrameLevel(12)
		eclipseBar:SetPoint("BOTTOM", self, "TOP", 2,-4)
		eclipseBar:SetSize(self:GetWidth(), 3)
	else
		eclipseBar:SetFrameStrata("LOW")
		eclipseBar:SetSize(90, 6)
		eclipseBar:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 200)
		CreateBorder(eclipseBar,1)
		CreateShadow(eclipseBar,6)
	end
	
	local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
	lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
	if cfg.HealMode then
		lunarBar:SetSize(self:GetWidth()-4, eclipseBar:GetHeight())
	else
		lunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
	end
	lunarBar:SetStatusBarTexture(cfg.statusbar_texture)
	lunarBar:SetStatusBarColor(0, 0, 1)
	eclipseBar.LunarBar = lunarBar
	
	local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
	solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
	if cfg.HealMode then
		solarBar:SetSize(self:GetWidth()-4, eclipseBar:GetHeight())
	else
		solarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
	end
	solarBar:SetStatusBarTexture(cfg.statusbar_texture)
	solarBar:SetStatusBarColor(1, 3/5, 0)
	eclipseBar.SolarBar = solarBar
	
	local eclipseBarText = solarBar:CreateFontString(nil, 'OVERLAY')
	eclipseBarText:SetPoint("CENTER", eclipseBar, "CENTER", 0, 0)	
	eclipseBarText:SetFont(cfg.font, 9, "OUTLINE")
	self:Tag(eclipseBarText, '[pereclipse]%')
	self.EclipseBar = eclipseBar
end
lib.genShards = function(self)
	if playerClass ~= "WARLOCK" then return end
	local bars = CreateFrame("Frame", nil, UIParent)

	if cfg.HealMode then
		bars:SetFrameStrata("MEDIUM")
		bars:SetFrameLevel(12)
		bars:SetPoint("BOTTOM", self, "TOP", -85,-5)
		bars:SetSize(45, 3)
		CreateBorder(bars,1)
	else
		bars:SetFrameStrata("LOW")
		bars:SetPoint("BOTTOM", UIParent, "BOTTOM", 0,200)
		bars:SetSize(90, 6)
		CreateBorder(bars,1)
		CreateShadow(bars,6)
	end

	for i = 1, 3 do					
		bars[i]=CreateFrame("StatusBar", nil, bars)
		bars[i]:SetHeight(bars:GetHeight())				
		bars[i]:SetStatusBarTexture(cfg.statusbar_texture)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)

		bars[i].bg = bars[i]:CreateTexture(nil, 'BORDER')
		--bars[i]:SetStatusBarColor(148/255, 130/255, 201/255)
		bars[i]:SetStatusBarColor(160/255, 32/255, 240/255)
					
		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
		end
		bars[i].bg:SetAllPoints(bars[i])
		bars[i]:SetWidth((bars:GetWidth() - 2)/3)
		bars[i].bg:SetTexture(cfg.statusbar_texture)					
		bars[i].bg:SetAlpha(.15)
	end

	bars.Override = UpdateShards
	self.SoulShards = bars		
end
lib.genHolyPower = function(self)
	if playerClass ~= "PALADIN" then return end
	local bars = CreateFrame("Frame", nil, UIParent)

	if cfg.HealMode then
		bars:SetFrameStrata("MEDIUM")
		bars:SetFrameLevel(12)
		bars:SetPoint("BOTTOM", self, "TOP", -85,-5)
		bars:SetSize(45, 3)
		CreateBorder(bars,1)
	else
		bars:SetFrameStrata("LOW")
		bars:SetPoint("BOTTOM", UIParent, "BOTTOM", 0,200)
		bars:SetSize(90, 6)
		CreateBorder(bars,1)
		CreateShadow(bars,6)
	end

	for i = 1, 3 do					
		bars[i]=CreateFrame("StatusBar", nil, bars)
		bars[i]:SetHeight(bars:GetHeight())					
		bars[i]:SetStatusBarTexture(cfg.statusbar_texture)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)

		bars[i].bg = bars[i]:CreateTexture(nil, 'BORDER')
		bars[i]:SetStatusBarColor(228/255,225/255,16/255)
		bars[i].bg:SetTexture(228/255,225/255,16/255)
					
		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
		end
		
		bars[i].bg:SetAllPoints(bars[i])
		bars[i]:SetWidth((bars:GetWidth() - 2)/3)
		bars[i].bg:SetTexture(cfg.statusbar_texture)					
		bars[i].bg:SetAlpha(.15)
	end

	bars.Override = UpdateHoly
	self.HolyPower = bars	
end
lib.genRunes = function(self)
	if playerClass ~= "DEATHKNIGHT" then return end
	local runes = CreateFrame("Frame", nil, UIParent)

	if cfg.HealMode then
		runes:SetFrameStrata("MEDIUM")
		runes:SetFrameLevel(12)
		runes:SetPoint("BOTTOM", self, "TOP", -85,-5)
		runes:SetSize(45, 3)
		CreateBorder(runes,1)
	else
		runes:SetFrameStrata("LOW")
		runes:SetPoint("BOTTOM", UIParent, "BOTTOM",0,200)
		runes:SetWidth(90, 6)
		CreateBorder(runes,1)
		CreateShadow(runes,6)
	end

	for i = 1, 6 do
		runes[i] = CreateFrame("StatusBar", nil, runes)
		runes[i]:SetHeight(runes:GetHeight())
		runes[i]:SetWidth((runes:GetWidth() - 5) / 6)

		if (i == 1) then
			runes[i]:SetPoint("LEFT", runes)
		else
			runes[i]:SetPoint("LEFT", runes[i-1], "RIGHT", 1, 0)
		end
		runes[i]:SetStatusBarTexture(cfg.statusbar_texture)
		runes[i]:GetStatusBarTexture():SetHorizTile(false)
	end

	self.Runes = runes
end
lib.genCPoints = function(self)
	if playerClass ~= "ROGUE" and playerClass ~= "DRUID" then return end
	local bars = CreateFrame("Frame", nil, self)

	if cfg.HealMode then
		bars:SetFrameStrata("MEDIUM")
		bars:SetFrameLevel(12)
		bars:SetPoint("BOTTOM", self, "TOP", -84,-5)
		bars:SetSize(49, 3)
	else
		bars:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 200)
		bars:SetSize(154, 6)
	end
		
	for i = 1, 5 do					
		bars[i] = CreateFrame("StatusBar", self:GetName().."_Combo"..i, bars)
		bars[i]:SetHeight(bars:GetHeight())					
		bars[i]:SetStatusBarTexture(cfg.statusbar_texture)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
							
		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
		end
		bars[i]:SetAlpha(0.15)
		if cfg.HealMode then
			bars[i]:SetWidth(9)
			CreateBorder(bars[i],1)
		else
			bars[i]:SetWidth(30)
			CreateBorder(bars[i],1)
			CreateShadow(bars[i],6)
		end
	end
		
	bars[1]:SetStatusBarColor(0.69, 0.31, 0.31)		
	bars[2]:SetStatusBarColor(0.69, 0.31, 0.31)
	bars[3]:SetStatusBarColor(0.65, 0.63, 0.35)
	bars[4]:SetStatusBarColor(0.65, 0.63, 0.35)
	bars[5]:SetStatusBarColor(0.33, 0.59, 0.33)
		
	self.CPoints = bars
	self.CPoints.Override = ComboDisplay

end
lib.TotemBars = function(self)
if cfg.TotemBars then
	if playerClass ~= "SHAMAN" then return end
	local totems = CreateFrame("Frame", nil, UIParent)
	totems.Destroy = true
	totems.colors = {{233/255, 46/255, 16/255};{173/255, 217/255, 25/255};{35/255, 127/255, 255/255};{178/255, 53/255, 240/255};}
	
	if cfg.HealMode then
		totems:SetFrameStrata("MEDIUM")
		totems:SetFrameLevel(12)
		totems:SetPoint("BOTTOM", self, "TOP", -68,-5)
		totems:SetSize(81, 3)
		CreateBorder(totems,1)
	else
		totems:SetFrameStrata("LOW")
		totems:SetPoint("BOTTOM", UIParent, "BOTTOM",0,200)
		totems:SetSize(163, 6)
		CreateBorder(totems,1)
		CreateShadow(totems,6)
	end
			
	for i = 1, 4 do
		totems[i] = CreateFrame("StatusBar", nil, totems)
		totems[i]:SetHeight(totems:GetHeight())
		totems[i]:SetFrameStrata(self:GetFrameStrata())
		totems[i]:SetFrameLevel(self:GetFrameLevel())
		totems[i]:SetWidth(40)
		if cfg.HealMode then
			totems[i]:SetWidth(20)
		end

		if (i == 1) then
			totems[i]:SetPoint("LEFT", totems)
		else
			totems[i]:SetPoint("LEFT", totems[i-1], "RIGHT", 1, 0)
		end
		totems[i]:SetStatusBarTexture(cfg.statusbar_texture)
		totems[i]:GetStatusBarTexture():SetHorizTile(false)
		totems[i]:SetMinMaxValues(0, 1)

		totems[i].bg = totems[i]:CreateTexture(nil, "BORDER")
		totems[i].bg:SetAllPoints()
		totems[i].bg:SetTexture(cfg.statusbar_texture)
		totems[i].bg.multiplier = 0.3
	end

	self.TotemBar = totems			
	end
end
lib.ThreatBar = function(self)
	if cfg.ThreatBar then
		local ThreatBar = CreateFrame("StatusBar", self:GetName()..'_ThreatBar', UIParent)
		ThreatBar:SetFrameLevel(5)
		if cfg.HealMode then
			ThreatBar:SetPoint(unpack(cfg.ThreatBarHpoint))
		else
			ThreatBar:SetPoint(unpack(cfg.ThreatBarpoint))
		end
		ThreatBar:SetWidth(5)
		ThreatBar:SetHeight(40)
		ThreatBar:SetStatusBarTexture(cfg.statusbar_texture)
		ThreatBar:SetOrientation("VERTICAL")
		ThreatBar:GetStatusBarTexture():SetHorizTile(true)
		ThreatBar.Text = SetFontString(ThreatBar, cfg.font, 9, cfg.fontstyle)
		ThreatBar.Text:SetPoint("CENTER", ThreatBar, "CENTER", 0, 0)	
		ThreatBar.bg = ThreatBar:CreateTexture(nil, 'BORDER')
		ThreatBar.bg:SetAllPoints(ThreatBar)
		ThreatBar.bg:SetTexture(0.1,0.1,0.1)
		ThreatBar.useRawThreat = false
		
		CreateBorder(ThreatBar,1)
		CreateShadow(ThreatBar,6)
		self.ThreatBar = ThreatBar
	end	
end
lib.Experience = function(self)
	if cfg.Experiencebar then 
	local Experience = CreateFrame('StatusBar', nil, self)
	Experience:SetStatusBarTexture(cfg.statusbar_texture)
	Experience:SetStatusBarColor(0, 0.7, 1)
	Experience:SetPoint('TOPRIGHT', oUF_Player,'TOPRIGHT', 10, 0)
	Experience:SetHeight(40)
	Experience:SetWidth(5)
	Experience:SetFrameLevel(2)
	Experience.Tooltip = true
	Experience:SetOrientation("VERTICAL")
	
	CreateBorder(Experience,1)
	CreateShadow(Experience,6)

	local Rested = CreateFrame('StatusBar', nil, Experience)
	Rested:SetStatusBarTexture(cfg.statusbar_texture)
	Rested:SetStatusBarColor(0, 0.4, 1, 0.6)
	Rested:SetFrameLevel(2)
	Rested:SetOrientation("VERTICAL")
	Rested:SetAllPoints(Experience)
				
	self.Experience = Experience
	self.Experience.Rested = Rested
	self.Experience.PostUpdate = ExperiencePostUpdate
	end
end
lib.AltPowerBar = function(self)
	local AltPowerBar = CreateFrame("StatusBar", nil, self.Health)
	AltPowerBar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
	
	AltPowerBar:SetHeight(10)
	AltPowerBar:SetStatusBarTexture(cfg.statusbar_texture)
	AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
	AltPowerBar:EnableMouse(true)
	AltPowerBar:SetFrameStrata("HIGH")
	AltPowerBar:SetFrameLevel(5)

	AltPowerBar:SetPoint("TOP", UIParent, 0, -15)
	AltPowerBar:SetWidth(280)
				
	AltPowerBar.text = SetFontString(AltPowerBar, cfg.font, 12, cfg.fontstyle)
	AltPowerBar.text:SetPoint("CENTER")

	self:Tag(AltPowerBar.text, '[altpower]')
		
	AltPowerBar:HookScript("OnShow", AltPowerBarOnToggle)
	AltPowerBar:HookScript("OnHide", AltPowerBarOnToggle)

	self.AltPowerBar = AltPowerBar		
	self.AltPowerBar.PostUpdate = AltPowerBarPostUpdate
	CreateBorder(AltPowerBar,1)
	CreateShadow(AltPowerBar,6)
end
UpdateReputationColor = function(self, event, unit, bar)
	local name, id = GetWatchedFactionInfo()
	bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b)
end
lib.Reputation = function(self)
	if cfg.Reputationbar then
	local Reputation = CreateFrame('StatusBar', nil, self)
	Reputation:SetStatusBarTexture(cfg.statusbar_texture)
	Reputation:SetWidth(280)
	Reputation:SetHeight(5)
	
	Reputation:SetPoint('TOP', UIParent,'TOP', 0, -5)
	Reputation:SetFrameLevel(2)
	--Reputation:SetOrientation("VERTICAL")

	CreateBorder(Reputation,1)
	CreateShadow(Reputation,6)

	Reputation.PostUpdate = UpdateReputationColor
	Reputation.Tooltip = true
	self.Reputation = Reputation
	end
end
lib.healcomm = function(self, unit)
if cfg.HealMode then
		local mhpb = CreateFrame('StatusBar', nil, self.Health)
		mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		mhpb:SetWidth(65)
		mhpb:SetStatusBarTexture(cfg.statusbar_texture)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		local ohpb = CreateFrame('StatusBar', nil, self.Health)
		ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		ohpb:SetWidth(65)
		ohpb:SetStatusBarTexture(cfg.statusbar_texture)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end
end
lib.ReadyCheck = function(self)
	if cfg.RCheckIcon then
		rCheck = self.Health:CreateTexture(nil, "OVERLAY")
		rCheck:SetSize(14, 14)
		rCheck:SetPoint("TOP", self.Health)
		rCheck.finishedTimer = 10
		rCheck.fadeTimer = 3
		self.ReadyCheck = rCheck
	end
end
lib.debuffHighlight = function(self)
	if cfg.enableDebuffHighlight then
		local dbh = self.Health:CreateTexture(nil, "OVERLAY")
		dbh:SetAllPoints(self.Health)
		dbh:SetTexture("Interface\\Buttons\\WHITE8x8")
		dbh:SetBlendMode("ADD")
		dbh:SetVertexColor(0,0,0,1) -- set alpha to 0 to hide the texture
		self.DebuffHighlight = dbh
		self.DebuffHighlightAlpha = 0.5
		self.DebuffHighlightFilter = true
	end
end
lib.raidDebuffs = function(f)
	if cfg.showRaidDebuffs then
		local raid_debuffs = {
			debuffs = {
			[GetSpellInfo(47476)] = 3, --strangulate
		-- Druid
			[GetSpellInfo(33786)] = 3, --Cyclone
			[GetSpellInfo(2637)] = 3, --Hibernate
			[GetSpellInfo(339)] = 3, --Entangling Roots
			[GetSpellInfo(80964)] = 3, --Skull Bash
			[GetSpellInfo(78675)] = 3, --Solar Beam
		-- Hunter
			[GetSpellInfo(3355)] = 3, --Freezing Trap Effect
			--[GetSpellInfo(60210)] = 3, --Freezing Arrow Effect
			[GetSpellInfo(1513)] = 3, --scare beast
			[GetSpellInfo(19503)] = 3, --scatter shot
			[GetSpellInfo(34490)] = 3, --silence shot
		-- Mage
			[GetSpellInfo(31661)] = 3, --Dragon's Breath
			[GetSpellInfo(61305)] = 3, --Polymorph
			[GetSpellInfo(18469)] = 3, --Silenced - Improved Counterspell
			[GetSpellInfo(122)] = 3, --Frost Nova
			[GetSpellInfo(55080)] = 3, --Shattered Barrier
		-- Paladin
			[GetSpellInfo(20066)] = 3, --Repentance
			[GetSpellInfo(10326)] = 3, --Turn Evil
			[GetSpellInfo(853)] = 3, --Hammer of Justice
		-- Priest
			[GetSpellInfo(605)] = 3, --Mind Control
			[GetSpellInfo(64044)] = 3, --Psychic Horror
			[GetSpellInfo(8122)] = 3, --Psychic Scream
			[GetSpellInfo(9484)] = 3, --Shackle Undead
			[GetSpellInfo(15487)] = 3, --Silence
		-- Rogue
			[GetSpellInfo(2094)] = 3, --Blind
			[GetSpellInfo(1776)] = 3, --Gouge
			[GetSpellInfo(6770)] = 3, --Sap
			[GetSpellInfo(18425)] = 3, --Silenced - Improved Kick
		-- Shaman
			[GetSpellInfo(51514)] = 3, --Hex
			[GetSpellInfo(3600)] = 3, --Earthbind
			[GetSpellInfo(8056)] = 3, --Frost Shock
			[GetSpellInfo(63685)] = 3, --Freeze
			[GetSpellInfo(39796)] = 3, --Stoneclaw Stun
		-- Warlock
			[GetSpellInfo(710)] = 3, --Banish
			[GetSpellInfo(6789)] = 3, --Death Coil
			[GetSpellInfo(5782)] = 3, --Fear
			[GetSpellInfo(5484)] = 3, --Howl of Terror
			[GetSpellInfo(6358)] = 3, --Seduction
			[GetSpellInfo(30283)] = 3, --Shadowfury
			[GetSpellInfo(89605)] = 3, --Aura of Foreboding
		-- Warrior
			[GetSpellInfo(20511)] = 3, --Intimidating Shout
		-- Racial
			[GetSpellInfo(25046)] = 3, --Arcane Torrent
			[GetSpellInfo(20549)] = 3, --War Stomp
		
		--Magmaw
			[GetSpellInfo(78941)] = 6, -- Parasitic Infection
			[GetSpellInfo(89773)] = 7, -- Mangle
		--Omnitron Defense System
			[GetSpellInfo(79888)] = 6, -- Lightning Conductor
            [GetSpellInfo(79505)] = 8, -- Flamethrower
            [GetSpellInfo(80161)] = 7, -- Chemical Cloud
            [GetSpellInfo(79501)] = 8, -- Acquiring Target
            [GetSpellInfo(80011)] = 7, -- Soaked in Poison
            [GetSpellInfo(80094)] = 7, -- Fixate
            [GetSpellInfo(92023)] = 9, -- Encasing Shadows
            [GetSpellInfo(92048)] = 9, -- Shadow Infusion
            [GetSpellInfo(92053)] = 9, -- Shadow Conductor
            --Maloriak
            [GetSpellInfo(92973)] = 8, -- Consuming Flames
            [GetSpellInfo(92978)] = 8, -- Flash Freeze
            [GetSpellInfo(92976)] = 7, -- Biting Chill
            [GetSpellInfo(91829)] = 7, -- Fixate
            [GetSpellInfo(92787)] = 9, -- Engulfing Darkness
            --Atramedes
            [GetSpellInfo(78092)] = 7, -- Tracking
            [GetSpellInfo(78897)] = 8, -- Noisy
            [GetSpellInfo(78023)] = 7, -- Roaring Flame
            --Chimaeron
            [GetSpellInfo(89084)] = 8, -- Low Health
            [GetSpellInfo(82881)] = 7, -- Break
            [GetSpellInfo(82890)] = 9, -- Mortality
            --Nefarian
            [GetSpellInfo(94128)] = 7, -- Tail Lash
            --[GetSpellInfo(94075)] = 8, -- Magma
            [GetSpellInfo(79339)] = 9, -- Explosive Cinders
            [GetSpellInfo(79318)] = 9, -- Dominion
			
			 --Halfus
            [GetSpellInfo(39171)] = 7, -- Malevolent Strikes
            [GetSpellInfo(86169)] = 8, -- Furious Roar
            --Valiona & Theralion
            [GetSpellInfo(86788)] = 6, -- Blackout
            [GetSpellInfo(86622)] = 7, -- Engulfing Magic
            --[GetSpellInfo(86202)] = 7, -- Twilight Shift
            --Council
            [GetSpellInfo(82665)] = 7, -- Heart of Ice
            [GetSpellInfo(82660)] = 7, -- Burning Blood
            [GetSpellInfo(82762)] = 7, -- Waterlogged
            [GetSpellInfo(83099)] = 7, -- Lightning Rod
            [GetSpellInfo(82285)] = 7, -- Elemental Stasis
            [GetSpellInfo(92488)] = 8, -- Gravity Well
            --Cho'gall
            [GetSpellInfo(86028)] = 6, -- Cho's Blast
            [GetSpellInfo(86029)] = 6, -- Gall's Blast
            [GetSpellInfo(93189)] = 7, -- Corrupted Blood
            [GetSpellInfo(93133)] = 7, -- Debilitating Beam
            [GetSpellInfo(81836)] = 8, -- Corruption: Accelerated
            [GetSpellInfo(81831)] = 8, -- Corruption: Sickness
            [GetSpellInfo(82125)] = 8, -- Corruption: Malformation
            [GetSpellInfo(82170)] = 8, -- Corruption: Absolute 
			
			--Conclave
            [GetSpellInfo(85576)] = 9, -- Withering Winds
            [GetSpellInfo(85573)] = 9, -- Deafening Winds
            [GetSpellInfo(93057)] = 7, -- Slicing Gale
            [GetSpellInfo(86481)] = 8, -- Hurricane
            [GetSpellInfo(93123)] = 7, -- Wind Chill
            [GetSpellInfo(93121)] = 8, -- Toxic Spores
            --Al'Akir
            --[GetSpellInfo(93281)] = 7, -- Acid Rain
            [GetSpellInfo(87873)] = 7, -- Static Shock
            [GetSpellInfo(88427)] = 7, -- Electrocute
            [GetSpellInfo(93294)] = 8, -- Lightning Rod
            [GetSpellInfo(93284)] = 9, -- Squall Line
			
			
			--Beth'tilac(蜘蛛)
			[GetSpellInfo(97202)] = 7, -- Fiery Web Spin(熾炎蛛網眩暈)
            [GetSpellInfo(49026)] = 8, -- Fixate(凝視)
			[GetSpellInfo(99506)] = 9, -- The Widow's Kiss(寡婦之吻)
			
			--Lord Rhyolith(左右腳)
			[GetSpellInfo(98492)] = 7, -- Eruption(爆發)
			
			--Alysrazor(火鳥)
			[GetSpellInfo(101729)] = 7, -- Blazing Claw(熾炎爪擊)
			[GetSpellInfo(100094)] = 7, -- Fieroblast(猛火衝擊)
			[GetSpellInfo(99389)] = 8, -- Imprinted(印刻)
			
			--Shannox(獵人)
			[GetSpellInfo(100415)] = 8, -- Rage(怒火)
			[GetSpellInfo(99947)] = 7, -- Face Rage(怒氣爆發)
			
			--Baleroc, the Gatekeeper(守門人)
			[GetSpellInfo(99403)] = 8, -- Tormented(受到折磨)
			[GetSpellInfo(99256)] = 7, -- Torment(折磨)
			
			--Majordomo Staghelm(鹿盔)
			[GetSpellInfo(98450)] = 7, -- Searing Seeds(灼熱種子)
			[GetSpellInfo(98443)] = 8, -- Fiery Cyclone(熾炎颶風)
			
			--Ragnaros(大螺絲)
			[GetSpellInfo(100460)] = 7, --Blazing Heat(熾熱高溫)
			[GetSpellInfo(99399)] = 8, -- Burning Wound(燃燒傷口)
			

			---- Dragon Soul
			-- Morchok
			[GetSpellInfo(103687)] = 7,  -- Crush Armor(擊碎護甲)
			
			-- Zon'ozz
			[GetSpellInfo(103434)] = 7, -- Disrupting Shadows(崩解之影)
			
			-- Yor'sahj
			[GetSpellInfo(105171)] = 7, -- Deep Corruption(深度腐化)
			--[GetSpellInfo(103628)] = 7, -- Deep Corruption(深度腐化)
			[GetSpellInfo(104849)] = 8,  -- Void Bolt(虛無箭)
			
			-- Hagara
			[GetSpellInfo(104451)] = 7,  -- Ice Tomb(寒冰之墓)
			
			-- Ultraxion
			[GetSpellInfo(110073)] = 7, -- Fading Light(凋零之光)
			
			-- Blackhorn
			[GetSpellInfo(109209)] = 7,  -- Brutal Strike(蠻橫打擊)
			[GetSpellInfo(108043)] = 8,  -- Sunder Armor(破甲攻擊)
			[GetSpellInfo(108861)] = 9,  -- Degeneration(衰亡)
			
			-- Spine
			[GetSpellInfo(105479)] = 7, -- 燃燒血漿
			--[GetSpellInfo(109379)] = 7, -- Searing Plasma(燃燒血漿)
			--[GetSpellInfo(109457)] = 8,  -- Fiery Grip(熾熱之握)
			[GetSpellInfo(105490)] = 8,  -- Fiery Grip(熾熱之握)
			
			-- Madness 
			[GetSpellInfo(105841)] = 7,  -- Degenerative Bite(退化咬擊)
			[GetSpellInfo(105445)] = 8,  -- Blistering Heat(極熾高熱)
			[GetSpellInfo(106444)] = 9,  -- Impale(刺穿)
			
			--测试
			--[GetSpellInfo(95223)] = 8, -- 群体复活
			--[GetSpellInfo(6788)] = 8, -- 虛弱靈魂
			},
		}

		local instDebuffs = {}
		local instances = raid_debuffs.instances
		local getzone = function()
			local zone = GetInstanceInfo()
			if instances[zone] then
				instDebuffs = instances[zone]
			else
				instDebuffs = {}
			end
		end

		local debuffs = raid_debuffs.debuffs
		local CustomFilter = function(icons, ...)
			local _, icon, name, _, _, _, dtype = ...
			if instDebuffs[name] then
				icon.priority = instDebuffs[name]
				return true
			elseif debuffs[name] then
				icon.priority = debuffs[name]
				return true
			else
				icon.priority = 0
			end
		end

		local dbsize = 18
		local debuffs = CreateFrame("Frame", nil, f)
		debuffs:SetWidth(dbsize) debuffs:SetHeight(dbsize)
		debuffs:SetPoint("CENTER", 0, 0)
		debuffs.size = dbsize
		
		debuffs.CustomFilter = CustomFilter
		f.raidDebuffs = debuffs
	end
end
ns.lib = lib