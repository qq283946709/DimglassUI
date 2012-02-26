local addon, ns = ...
local cfg = ns.cfg
local lib = ns.lib
-- change some colors
--oUF.colors.power["MANA"] = {0.36, 0.45, 0.88}
--oUF.colors.power["MANA"] = {0.40, 0.80, 1}
oUF.colors.power["MANA"] = {0.16, 0.41, 0.80}
oUF.colors.power["RAGE"] = {0.8, 0.21, 0.31}

local function CreatePlayerStyle(self, unit, isSingle)
	self.mystyle = "player"
	lib.init(self)
	self:SetScale(cfg.scale)
	self.width = 220
	self.height = 24
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_tagcontainer(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_RaidMark(self)
	if cfg.showPlayerAuras then
		BuffFrame:Hide()
		lib.createBuffs(self)
		lib.createDebuffs(self)
	end
	self.Health.frequentUpdates = true
	self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
	end
	if cfg.Powercolor then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
	self.Power.frequentUpdates = true
	self.Power.Smooth = true
	--lib.raidDebuffs(self)
	--self.freebIndicators = true
	lib.gen_castbar(self)
	lib.gen_InfoIcons(self)
	lib.TotemBars(self)
	lib.Experience(self)
	lib.Reputation(self)
	lib.AltPowerBar(self)
	
	lib.ThreatBar(self)
	if cfg.showPortrait then lib.gen_portrait(self) end
	if cfg.showRunebar then lib.genRunes(self) end
	if cfg.showHolybar then lib.genHolyPower(self) end
	if cfg.showShardbar then lib.genShards(self) end
	if cfg.showEclipsebar then lib.addEclipseBar(self) end
end
local function CreateTargetStyle(self, unit, isSingle)
	self.mystyle = "target"
	lib.init(self)
	self:SetScale(cfg.scale)
	self.width = 220
	self.height = 24
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_tagcontainer(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	lib.gen_RaidMark(self)
	self.Health.frequentUpdates = false
	self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
		self.Health.colorHealth = true
	end
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	if cfg.Powercolor then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
	self.Power.colorReaction = true
	self.Power.Smooth = true
	lib.gen_castbar(self)
	lib.addQuestIcon(self)
	lib.createAuras(self)
	lib.genCPoints(self)
	if cfg.showPortrait then lib.gen_portrait(self) end	
end
local function CreateFocusStyle(self, unit, isSingle)
	self.mystyle = "focus"
	lib.init(self)
	self:SetScale(cfg.scale)
	if cfg.HealMode then
		self.width = 150
		self.height = 18
	else
		self.width = 220
		self.height = 18
	end
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_tagcontainer(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_ppbar(self)
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	if cfg.Powercolor then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
	self.Power.Smooth = true
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	lib.gen_RaidMark(self)
	self.Health.frequentUpdates = false
	self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
		self.Health.colorHealth = true
	end
	lib.gen_castbar(self)
	lib.createAuras(self)
end
local function CreateToTStyle(self, unit, isSingle)
	self.mystyle = "tot"
	lib.init(self)
	self:SetScale(cfg.scale)
	self.width = 105
	self.height = 12
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	lib.createAuras(self)
	self.Health.frequentUpdates = false
	self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
		self.Health.colorHealth = true
	end
end	
local function CreateFocusTargetStyle(self, unit, isSingle)
	self.mystyle = "focustarget"
	lib.init(self)
	self:SetScale(cfg.scale)
	self.height = 12
	if cfg.HealMode then
		self.width = 150
	else
		self.width = 105
	end
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	self.Health.frequentUpdates = false
	self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
		self.Health.colorHealth = true
	end
end
local function CreatePetStyle(self, unit, isSingle)
	local _, playerClass = UnitClass("player")
	self.mystyle = "pet"
	lib.init(self)
	self:SetScale(cfg.scale)
	self.width = 105
	self.height = 12
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	self.Health.frequentUpdates = false
	self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
		self.Health.colorHealth = true
	end
	if PlayerClass == "HUNTER" then
		self.Power.colorReaction = false
		self.Power.colorClass = false
	end
end
local function CreatePetTargetStyle(self, unit, isSingle)
	self.mystyle = "pettarget"
	lib.init(self)
	self:SetScale(cfg.scale)
	self.width = 105
	self.height = 12
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	self.Health.frequentUpdates = false
	self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
		self.Health.colorHealth = true
	end
end
local function CreateBossStyle(self, unit, isSingle)
	self.mystyle = "boss"
	lib.init(self)
	self.width = 150
	self.height = 20
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	lib.gen_ppbar(self)
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
		self.Health.colorHealth = true
	end
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	if cfg.Powercolor then
		self.Power.colorClass = true
		self.Power.colorHealth = true
	else
		self.Power.colorPower = true
	end
	self.Power.Smooth = true
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	lib.gen_castbar(self)
	lib.AltPowerBar(self)
	lib.createBuffs(self)
	self.Health.frequentUpdates = false
	self.Health.Smooth = true
end
local function CreateArenaStyle(self, unit, isSingle)
	self.mystyle = "arena"
	lib.init(self)
	self.width = 150
	self.height = 20
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	lib.CreateTrinkets(self)
	lib.gen_ppbar(self)
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
		self.Health.colorHealth = true
	end
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	if cfg.Powercolor then
		self.Power.colorClass = true
		self.Power.colorHealth = true
	else
		self.Power.colorPower = true
	end
	self.Power.Smooth = true
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	lib.gen_castbar(self)
	lib.AltPowerBar(self)
	lib.createBuffs(self)
	self.Health.frequentUpdates = false
	self.Health.Smooth = true
end
local function CreateMTStyle(self, unit, isSingle)
	self.mystyle = "oUF_MT"
	lib.init(self)
	self.width = 100
	self.height = 20
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	self.Health.frequentUpdates = false
	self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
	end
end
local function CreateRaidfordpsStyle(self)
	self.mystyle = "raidfordps"
	lib.init(self)
	self.width = 70
	self.height = 20
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	lib.gen_ppbar(self)
	self.Health.frequentUpdates = true
	self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
	end
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	self.Power.colorReaction = true
	if cfg.Powercolor then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
	self.Power.colorReaction = true
	self.freebAfk = true
	self.freebIndicators = true
	
	lib.CreateTargetBorder(self)
	lib.CreateThreatBorder(self)
	lib.raidDebuffs(self)
	lib.gen_InfoIcons(self)
	lib.ReadyCheck(self)
	lib.debuffHighlight(self)
	-- Range
    range = {
        insideAlpha = 1,
        outsideAlpha = 0.4,
    }

	self.freebRange = range
    self.Range = range

	self.Health.PostUpdate = lib.PostUpdateRaidFrame
	self:RegisterEvent('PLAYER_TARGET_CHANGED', lib.ChangedTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', lib.ChangedTarget)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", lib.UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.UpdateThreat)
end
local function CreatePartyforhealerStyle(self)
	self.mystyle = "partyforhealer"
	lib.init(self)
	self.width = 106
	self.height = 35
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	lib.gen_ppbar(self)
	self.Health.frequentUpdates = true
	self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
	end
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	self.Power.colorReaction = true
	if cfg.Powercolor then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
	self.Power.colorReaction = true
	self.freebAfk = true
	self.freebIndicators = true
	
	lib.CreateTargetBorder(self)
	lib.CreateThreatBorder(self)
	lib.raidDebuffs(self)
	lib.gen_InfoIcons(self)
	lib.ReadyCheck(self)
	lib.debuffHighlight(self)
	lib.healcomm(self, unit)
	-- Range
    range = {
        insideAlpha = 1,
        outsideAlpha = 0.4,
    }
	
	self.freebRange = range
    self.Range = range
	
	self.Health.PostUpdate = lib.PostUpdateRaidFrame
	self:RegisterEvent('PLAYER_TARGET_CHANGED', lib.ChangedTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', lib.ChangedTarget)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", lib.UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.UpdateThreat)
end
local function CreateRaid25Style(self)
	self.mystyle = "raid25"
	lib.init(self)
	self.width = 106
	self.height = 20
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	lib.gen_ppbar(self)
	self.Health.frequentUpdates = true
	self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
	end
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	self.Power.colorReaction = true
	if cfg.Powercolor then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
	self.Power.colorReaction = true
	self.freebAfk = true
	self.freebIndicators = true
	
	lib.CreateTargetBorder(self)
	lib.CreateThreatBorder(self)
	lib.raidDebuffs(self)
	lib.gen_InfoIcons(self)
	lib.ReadyCheck(self)
	lib.debuffHighlight(self)
	lib.healcomm(self, unit)
	-- Range
    range = {
        insideAlpha = 1,
        outsideAlpha = 0.4,
    }
	
	self.freebRange = range
    self.Range = range
	
	self.Health.PostUpdate = lib.PostUpdateRaidFrame
	self:RegisterEvent('PLAYER_TARGET_CHANGED', lib.ChangedTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', lib.ChangedTarget)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", lib.UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.UpdateThreat)
end
local function CreateRaid40Style(self)
	self.mystyle = "raid40"
	lib.init(self)
	self.width = 106
	self.height = 18
	self:SetSize(self.width,self.height)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
	self.Health.frequentUpdates = true
	--self.Health.Smooth = true
	if cfg.HealthcolorClass then
		self.Health.colorClass = true
	end
	self.freebAfk = true
	self.freebIndicators = true
	
	lib.CreateTargetBorder(self)
	lib.CreateThreatBorder(self)
	lib.raidDebuffs(self)
	lib.gen_InfoIcons(self)
	lib.ReadyCheck(self)
	lib.debuffHighlight(self)
	lib.healcomm(self, unit)
	-- Range
    range = {
        insideAlpha = 1,
        outsideAlpha = 0.4,
    }

	self.freebRange = range
    self.Range = range

	self.Health.PostUpdate = lib.PostUpdateRaidFrame
	self:RegisterEvent('PLAYER_TARGET_CHANGED', lib.ChangedTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', lib.ChangedTarget)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", lib.UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.UpdateThreat)
end

oUF:RegisterStyle("Player", CreatePlayerStyle)
oUF:RegisterStyle("Target", CreateTargetStyle)
oUF:RegisterStyle("ToT", CreateToTStyle)
oUF:RegisterStyle("Focus", CreateFocusStyle)
oUF:RegisterStyle("FocusTarget", CreateFocusTargetStyle)
oUF:RegisterStyle("Pet", CreatePetStyle)
oUF:RegisterStyle("PetTarget", CreatePetTargetStyle)
oUF:RegisterStyle("Boss", CreateBossStyle)
oUF:RegisterStyle("Arena", CreateArenaStyle)
oUF:RegisterStyle("oUF_MT", CreateMTStyle)
oUF:RegisterStyle("Raidfordps", CreateRaidfordpsStyle)
oUF:RegisterStyle("Raid25", CreateRaid25Style)
oUF:RegisterStyle("Raid40", CreateRaid40Style)
oUF:RegisterStyle("Partyfordps", CreateRaidfordpsStyle)
oUF:RegisterStyle("Partyforhealer", CreatePartyforhealerStyle)

oUF:Factory(function(self)
	if cfg.HealMode then
		self:SetActiveStyle("Player")
		local player = self:Spawn("player", "oUF_Player")
		player:SetPoint(unpack(cfg.PlayerHpoint))
		self:SetActiveStyle("Target")
		local target = self:Spawn("Target", "oUF_Target")
		target:SetPoint(unpack(cfg.TargetHpoint))
		if cfg.showtot then
			self:SetActiveStyle("ToT")
			local targettarget = self:Spawn("targettarget", "oUF_tot")
			targettarget:SetPoint("BOTTOMRIGHT", oUF_Target, "TOPRIGHT", 0, 30) 
		end
		if cfg.showpet then
			self:SetActiveStyle("Pet")
			local pet = self:Spawn("pet", "oUF_pet")
			pet:SetPoint("BOTTOMLEFT", oUF_Player, "TOPLEFT", 0, 30) 
		end
		if cfg.showpettarget then
			self:SetActiveStyle("PetTarget")
			local pettarget = self:Spawn("pettarget", "oUF_pettarget")
			pettarget:SetPoint("BOTTOMRIGHT", oUF_Player, "TOPRIGHT", 0, 30) 
		end
		if cfg.showfocus then 
			self:SetActiveStyle("Focus")
			local focus = self:Spawn("focus", "oUF_focus")
			focus:SetPoint(unpack(cfg.FocusHpoint))
		end
		if cfg.showfocustarget then 
			self:SetActiveStyle("FocusTarget")
			local focustarget = self:Spawn("focustarget", "oUF_focustarget")
			focustarget:SetPoint(unpack(cfg.FocustargetHpoint))
		end
		
		oUF:SetActiveStyle("Partyforhealer")
		local partyforhealer = oUF:SpawnHeader(
			"oUF_Partyforhealer", nil,
			"custom [@raid6,exists] hide;show",
			"showPlayer",			true,
			"showSolo",				false,
			"showParty",			true,
			"showRaid",				true,
			'xOffset',				5,
			"point",				"LEFT",
			"columnSpacing",		15,
			"columnAnchorPoint",	"TOP",
			"groupFilter",			"1,2,3,4,5,6,7,8",
			"groupBy",				"GROUP",
			"groupingOrder",		"1,2,3,4,5,6,7,8",
			"maxColumns",			5,
			"unitsPerColumn",		5,
			'oUF-initialConfigFunction', [[
					self:SetWidth(106)
					self:SetHeight(20)
			]])
		partyforhealer:SetPoint(unpack(cfg.PartyHpoint))
		if cfg.showraid then
			if cfg.show40raid then
				oUF:SetActiveStyle("Raid25")
				local raid25 = oUF:SpawnHeader(
					"oUF_Raid25", nil,
					"custom [@raid6,noexists][@raid26,exists] hide;show",
					"showPlayer",			true,
					"showSolo",				false,
					"showParty",			true,
					"showRaid",				true,
					'xOffset',				5,
					"point",				"LEFT",
					"columnSpacing",		15,
					"columnAnchorPoint",	"TOP",
					"groupFilter",			"1,2,3,4,5,6,7,8",
					"groupBy",				"GROUP",
					"groupingOrder",		"1,2,3,4,5,6,7,8",
					"maxColumns",			5,
					"unitsPerColumn",		5,
					'oUF-initialConfigFunction', [[
							self:SetWidth(106)
							self:SetHeight(20)
					]])
				raid25:SetPoint(unpack(cfg.RaidHpoint))
				
				oUF:SetActiveStyle("Raid40")
				local raid40 = oUF:SpawnHeader(
					"oUF_Raid40", nil,
					"custom [@raid26,exists] show;hide",
					"showPlayer",			true,
					"showSolo",				false,
					"showParty",			false,
					"showRaid",				true,
					'xOffset',				5,
					"point",				"LEFT",
					"columnSpacing",		5,
					"columnAnchorPoint",	"TOP",
					"groupFilter",			"1,2,3,4,5,6,7,8",
					"groupBy",				"GROUP",
					"groupingOrder",		"1,2,3,4,5,6,7,8",
					"maxColumns",			8,
					"unitsPerColumn",		5,
					'oUF-initialConfigFunction', [[
							self:SetWidth(106)
							self:SetHeight(18)
					]])
				raid40:SetPoint(unpack(cfg.Raid40Hpoint))
			else
				oUF:SetActiveStyle("Raid25")
				local raid25 = oUF:SpawnHeader(
					"oUF_Raid25", nil,
					"custom [@raid1,exists] show;hide",
					"showPlayer",			true,
					"showSolo",				false,
					"showParty",			true,
					"showRaid",				true,
					'xOffset',				5,
					"point",				"LEFT",
					"columnSpacing",		15,
					"columnAnchorPoint",	"BOTTOM",
					"groupFilter",			"1,2,3,4,5,6,7,8",
					"groupBy",				"GROUP",
					"groupingOrder",		"1,2,3,4,5,6,7,8",
					"maxColumns",			5,
					"unitsPerColumn",		5,
					'oUF-initialConfigFunction', [[
							self:SetWidth(106)
							self:SetHeight(20)
					]])
				raid25:SetPoint("BOTTOM",UIParent,cfg.RaidHx,cfg.RaidHy)
			end
		end
	else
		self:SetActiveStyle("Player")
		local player = self:Spawn("player", "oUF_Player")
		player:SetPoint(unpack(cfg.Playerpoint))
		self:SetActiveStyle("Target")
		local target = self:Spawn("Target", "oUF_Target")
		target:SetPoint(unpack(cfg.Targetpoint))
		if cfg.showtot then
			self:SetActiveStyle("ToT")
			local targettarget = self:Spawn("targettarget", "oUF_tot")
			targettarget:SetPoint("BOTTOMRIGHT", oUF_Target, "TOPRIGHT", 0, 30) 
		end
		if cfg.showpet then
			self:SetActiveStyle("Pet")
			local pet = self:Spawn("pet", "oUF_pet")
			pet:SetPoint("BOTTOMLEFT", oUF_Player, "TOPLEFT", 0, 30) 
		end
		if cfg.showpettarget then
			self:SetActiveStyle("PetTarget")
			local pettarget = self:Spawn("pettarget", "oUF_pettarget")
			pettarget:SetPoint("BOTTOMRIGHT", oUF_Player, "TOPRIGHT", 0, 30) 
		end
		if cfg.showfocus then 
			self:SetActiveStyle("Focus")
			local focus = self:Spawn("focus", "oUF_focus")
			focus:SetPoint("BOTTOM", oUF_Target, "TOP", 0, 70)
		end
		if cfg.showfocustarget then 
			self:SetActiveStyle("FocusTarget")
			local focustarget = self:Spawn("focustarget", "oUF_focustarget")
			focustarget:SetPoint("BOTTOMLEFT", oUF_Target, "TOPLEFT", 0, 30)
		end
		oUF:SetActiveStyle("Partyfordps")
		
		if cfg.showraid then
			local partyfordps = oUF:SpawnHeader(
				"oUF_Partyfordps", nil,
				"custom [@raid6,exists] hide;show",
				"showPlayer",			true,
				"showSolo",				false,
				"showParty",			true,
				"showRaid",				true,
				'yOffset',				-15,
				"point",				"TOP",
				"columnSpacing",		5,
				"columnAnchorPoint",	"LEFT",
				"groupFilter",			"1,2,3,4,5,6,7,8",
				"groupBy",				"GROUP",
				"groupingOrder",		"1,2,3,4,5,6,7,8",
				"maxColumns",			8,
				"unitsPerColumn",		5,
				'oUF-initialConfigFunction', [[
						self:SetWidth(70)
						self:SetHeight(20)
				]])
			partyfordps:SetPoint(unpack(cfg.Partypoint))
			
			local raidfordps = oUF:SpawnHeader(
				"oUF_Raidfordps", nil,
				"custom [@raid1,exists] show; hide",
				"showPlayer",			true,
				"showSolo",				false,
				"showParty",			true,
				"showRaid",				true,
				'yOffset',				-15,
				"point",				"TOP",
				"columnSpacing",		5,
				"columnAnchorPoint",	"LEFT",
				"groupFilter",			"1,2,3,4,5,6,7,8",
				"groupBy",				"GROUP",
				"groupingOrder",		"1,2,3,4,5,6,7,8",
				"maxColumns",			8,
				"unitsPerColumn",		5,
				'oUF-initialConfigFunction', [[
						self:SetWidth(70)
						self:SetHeight(20)
				]])
			raidfordps:SetPoint(unpack(cfg.Raidpoint))
		else
			local partyfordps = oUF:SpawnHeader(
				"oUF_Partyfordps", nil,
				"custom [@party1,exists] show",
				"showPlayer",			true,
				"showSolo",				false,
				"showParty",			true,
				"showRaid",				false,
				'yOffset',				-15,
				"point",				"TOP",
				"columnSpacing",		5,
				"columnAnchorPoint",	"LEFT",
				"groupFilter",			"1,2,3,4,5,6,7,8",
				"groupBy",				"GROUP",
				"groupingOrder",		"1,2,3,4,5,6,7,8",
				"maxColumns",			1,
				"unitsPerColumn",		5,
				'oUF-initialConfigFunction', [[
						self:SetWidth(70)
						self:SetHeight(20)
				]])
			partyfordps:SetPoint(cfg.Partypoint)
		end
	end

	if cfg.showBossFrames then
		self:SetActiveStyle("Boss")
		local boss = {}
			for i = 1, MAX_BOSS_FRAMES do
				boss[i] = self:Spawn("boss"..i, "oUF_Boss"..i)
				if i == 1 then
					boss[i]:SetPoint(unpack(cfg.Bosspoint))
				else
					boss[i]:SetPoint("BOTTOMRIGHT", boss[i-1], "BOTTOMRIGHT", 0, cfg.BossSpacing)
			end
		end
	end
	
	if cfg.showArenaFrames then
		self:SetActiveStyle("Arena")
		local arena = {}
			for i = 1, 5 do
				arena[i] = self:Spawn("arena"..i, "oUF_Arena"..i)
				if i == 1 then
					arena[i]:SetPoint(unpack(cfg.Arenapoint))
				else
					arena[i]:SetPoint("BOTTOMRIGHT", arena[i-1], "BOTTOMRIGHT", 0, cfg.ArenaSpacing)
			end
		end
	end
	if cfg.MTFrames then
		oUF:SetActiveStyle("oUF_MT")
		local tank = oUF:SpawnHeader('oUF_MT', nil, 'raid',
			'oUF-initialConfigFunction', ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
			]]):format(80, 18),
			'showRaid', true,
			'groupFilter', 'MAINTANK',
			'yOffset', 5,
			'point' , 'BOTTOM',
			'template', 'oUF_MainTank')

		tank:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -180)
    end
end)

----------------------------------------------------------------------------------------
--	Testmode(by Fernir)
----------------------------------------------------------------------------------------
SlashCmdList.TESTUF = function()
	if(oUF) then
		for i, v in pairs(oUF.units) do
			if not v.fff then
				v.fff = CreateFrame("Frame")
				CreateBorder(v.fff,1)
				CreateShadow(v.fff,6)
				v.fff:SetParent(UIParent)
				v.fff:SetFrameStrata("MEDIUM")
				v.fff:SetFrameLevel(0)
				v.fff:SetPoint("TOPLEFT", v, 0, 0)
				v.fff:SetPoint("BOTTOMRIGHT", v, 0, 0)
			
				v.fffs = SetFontString(v.fff, cfg.font, cfg.fontsize, cfg.fontstyle)
				v.fffs:SetShadowOffset(0, 0)
				v.fffs:SetAllPoints(v.fff)
				v.fffs:SetText(v:GetName())
			else
				if v.fff:IsShown() then 
					v.fff:Hide()
				else
					v.fff:Show()
				end
			end
		end
	end
end
SLASH_TESTUF1 = "/testuf"

do	
	local PET_DISMISS = "PET_DISMISS"
	local myclass = UnitClass("player")
	if myclass == "HUNTER" then
		PET_DISMISS = nil;
		local x = CreateFrame('Frame')
		x:RegisterEvent('UPDATE_BONUS_ACTIONBAR')
		--We need to re-add the PET_DISMISS option to rightclick if the bonus actionbar is visible and you have a pet out
		--Bugfix for karazhan chess event
		x:SetScript('OnEvent', function()
			if UnitExists('pet') and ActionButton1:GetAttribute("actionpage") == 11 then
				UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
			else
				UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "CANCEL" };
			end	
		end)
	end

	UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "SELECT_ROLE", "CONVERT_TO_PARTY", "CONVERT_TO_RAID", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
	UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "PROMOTE_GUIDE", "LOOT_PROMOTE", "VOTE_TO_KICK", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["RAID_PLAYER"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "VOTE_TO_KICK", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" };
	UnitPopupMenus["RAID"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "RAID_TARGET_ICON", "SELECT_ROLE", "LOOT_PROMOTE", "RAID_DEMOTE", "VOTE_TO_KICK", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL" };
	UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
	UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["ARENAENEMY"] = { "CANCEL" }
	UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["BOSS"] = { "RAID_TARGET_ICON", "CANCEL" }
end