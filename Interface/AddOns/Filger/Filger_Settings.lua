local _, ns = ...

ns.Filger_Settings = {
	configmode = false,
}

--[[ CD-Example
		{
			Name = "COOLDOWN",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER", UIParent, "CENTER", 0, -100 },

			-- Wild Growth / Wildwuchs
			{ spellID = 48438, size = 32, filter = "CD" },
		},
]]

ns.Filger_Spells = {
	["DRUID"] = {

	},
	["HUNTER"] = {

	},
	["MAGE"] = {

	},
	["WARRIOR"] = {

	},
	["SHAMAN"] = {

	},
	["PALADIN"] = {

	},
	["PRIEST"] = {

	},
	["WARLOCK"] = {

	},
	["ROGUE"] = {

	},
	["DEATHKNIGHT"] = {

	},
	["ALL"] = {
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = {"center", nil, "center", -205, 40},
			
			--時間扭曲
			{ spellID = 80353, size = 35, unitId = "player", caster = "all", filter = "BUFF" },
			--嗜血
			{ spellID = 2825, size = 35, unitId = "player", caster = "all", filter = "BUFF" },
			--英勇氣概
			{ spellID = 32182, size = 35, unitId = "player", caster = "all", filter = "BUFF" },
		},

		{		
			Name = "PVP_P_DEBUFF_ICON",
			Direction = "UP",
			Interval = 4,
			Mode = "ICON",
			setPoint = {"center", nil, "center", -100, 20},
 
         --變羊
            { spellID = 118, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" },
         --制裁之錘
            { spellID = 853, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" },
         --腎擊
            { spellID = 408, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" },
         --啃食
            { spellID = 47481, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" },
         --沉默
            { spellID = 55021, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" },
         --傷殘術
            { spellID = 22570, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" },
         --斷筋
           { spellID = 1715, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" },
         --致殘毒藥
           { spellID = 3775, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{		
			Name = "PVP_T_BUFF_ICON",
			Direction = "UP",
			Interval = 4,
			Mode = "ICON",
			setPoint = {"center", nil, "center", 100, 20},
			
         --激活
            { spellID = 29166, size = 72, unitId = "target", caster = "all", filter = "BUFF"},
         --法術反射/盾反
            { spellID = 23920, size = 72, unitId = "target", caster = "all", filter = "BUFF" },
         --精通光環
            { spellID = 31821, size = 72, unitId = "target", caster = "all", filter = "BUFF" },
         --寒冰屏障/冰箱
            { spellID = 45438, size = 72, unitId = "target", caster = "all", filter = "BUFF" },
         --暗影披風/斗篷
            { spellID = 31224, size = 72, unitId = "target", caster = "all", filter = "BUFF" },
         --聖盾術/無敵
            { spellID = 642, size = 72, unitId = "target", caster = "all", filter = "BUFF" },
         --威懾
            { spellID = 19263, size = 72, unitId = "target", caster = "all", filter = "BUFF" },
         --反魔法護罩/綠罩子
            { spellID = 48707, size = 72, unitId = "target", caster = "all", filter = "BUFF" },
         --巫妖之軀
            { spellID = 49039, size = 72, unitId = "target", caster = "all", filter = "BUFF" },
         --自由聖禦
            { spellID = 1044, size = 72, unitId = "target", caster = "all", filter = "BUFF" },
         --犧牲聖禦
            { spellID = 6940, size = 72, unitId = "target", caster = "all", filter = "BUFF" },
         --根基圖騰效果
            { spellID = 8178, size = 72, unitId = "target", caster = "all", filter = "BUFF" },
         --保護聖禦
            { spellID = 1022, size = 72, unitId= "target", caster = "all", filter = "BUFF" },		
		},
	},
}