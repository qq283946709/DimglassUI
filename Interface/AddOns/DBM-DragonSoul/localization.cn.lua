-- Simplified Chinese by Diablohu(diablohudream@gmail.com)
-- Last update: 11/28/2011

if GetLocale() ~= "zhCN" then return end

local L

-------------
-- Morchok --
-------------
L= DBM:GetModLocalization(311)

L:SetWarningLocalization({
	SpecwarnVortexAfter	= "躲到石柱后!",
	specWarn3s 			= "3秒后践踏",
	KohcromWarning		= "%s: %s"
})

L:SetTimerLocalization({
	KohcromCD		= "寇魔的%s",
	timerStompMK	= "魔寇：践踏",
	timerStompKM	= "寇魔：践踏",
	timerCrystalMKNext	= "魔寇：下一颗水晶",
	timerCrystalKMNext	= "寇魔：下一颗水晶",
	timerCrystalMK	= "魔寇：水晶爆炸",
	timerCrystalKM	= "寇魔：水晶爆炸"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	MorchokHero			= "英雄模式，二阶段提示魔寇[本体]技能        (此处选项优先於计时器选",
	KohcromHero			= "英雄模式，二阶段提示寇魔[分身]技能        项,没选择的王都不会显示)",
	SpecwarnVortexAfter	= "特殊警告：$spell:110047结束时",
	KohcromWarning		= "為寇魔的技能显示警告。",
	specWarn3s 			= "特殊警告：3秒后践踏",
	timerStompMK		= "计时器：魔寇的$spell:108571",
	timerStompKM		= "计时器：寇魔的$spell:108571",
	timerCrystalMKNext	= "计时器：魔寇的下一颗水晶",
	timerCrystalKMNext	= "计时器：寇魔的下一颗水晶",
	timerCrystalMK		= "计时器：魔寇的水晶爆炸",
	RangeFrame			= "距离监视(5码)：成就[别站得离我这麼近]",
	timerCrystalKM		= "计时器：寇魔的水晶爆炸"
})

L:SetMiscLocalization({
})

---------------------
-- Warlord Zon1ozz --
---------------------
L= DBM:GetModLocalization(324)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	SoundBJ				= "语音警告：$spell:103434的驱散",
	SoundXX				= "倒计时：$spell:104322",
	RangeFrame			= "距离监视(10码)：$spell:104601（英雄模式）",
	ShadowYell			= "自動喊話：當你中了$spell:104601時",
	Never				= "关闭",
	Normal				= "普通模式",
	DynamicPhase2		= "智能模式(仅二阶段)",
	DynamicAlways		= "智能模式"
})

L:SetMiscLocalization({
	voidYell			= "Gul1kafh an1qov N1Zoth."
})

-----------------------------
-- Yor1sahj the Unsleeping --
-----------------------------
L= DBM:GetModLocalization(325)

L:SetWarningLocalization({
	warnOozesHit	= "%s融合：%s",
	specWarnOozesZ		= "|cFF9932CD快打<紫>软泥!|r",
	specWarnOozesL		= "|cFF088A08快打<绿>软泥!|r",
	specWarnOozesB		= "|cFF424242快打<黑>软泥!|r",
	specWarnOozesY		= "|cFFFFA901快打<黄>软泥!|r",
	specWarnOozesR		= "|cFF0080FF快打<蓝>软泥!|r",
	specWarnOozesH		= "|cFFFF0404快打<红>软泥!|r",
	specWarnOozesLL		= "|cFF088A08绿:4码分散|r  |cFF0080FF蓝:溃法力场|r",
	specWarnOozesHHe	= "|cFFFF0404红:靠近王|r  |cFF424242黑:召唤小怪|r",
	specWarnOozesHH		= "|cFFFF0404红:靠近王|r  |cFFFFA901黄:群体暗影箭|r",
	specWarnOozesLH		= "|cFF0080FF蓝:溃法力场|r  |cFFFFA901黄:群体暗影箭|r",
	specWarnOozesHuH	= "|cFFFFA901黄:群体暗影箭|r  |cFF424242黑:召唤小怪|r",
	specWarnOozesLHe	= "|cFF0080FF蓝:溃法力场|r  |cFF424242黑:召唤小怪|r",
	specWarnOozesZHL	= "<|cFF9932CD紫|r / |cFF424242黑|r / |cFF0080FF蓝|r>",
	specWarnOozesHHL	= "<|cFFFF0404红|r / |cFF424242黑|r / |cFF0080FF蓝|r>",
	specWarnOozesHHH	= "<|cFFFF0404红|r / |cFF424242黑|r / |cFFFFA901黄|r>",
	specWarnOozesZLH	= "<|cFF9932CD紫|r / |cFFFFA901黄|r / |cFF0080FF蓝|r>",
	specWarnOozesLLH	= "<|cFF088A08绿|r / |cFF424242黑|r / |cFF0080FF蓝|r>",
	specWarnOozesZLL	= "<|cFF9932CD紫|r / |cFF088A08绿|r / |cFF0080FF蓝|r>",
	specWarnOozesLZH	= "<|cFF088A08绿|r / |cFF9932CD紫|r / |cFF424242黑|r>",
	specWarnOozesLHL	= "<|cFF088A08绿|r / |cFFFF0404红|r / |cFF0080FF蓝|r>",
	specWarnOozesLHH	= "<|cFF088A08绿|r / |cFFFF0404红|r / |cFF424242黑|r>",
	specWarnOozesLHuH	= "<|cFF088A08绿|r / |cFFFFA901黄|r / |cFF424242黑|r>",
	specWarnOozesLHHu	= "<|cFF088A08绿|r / |cFFFF0404红|r / |cFFFFA901黄|r>",
	specWarnOozesLHuL	= "<|cFF088A08绿|r / |cFFFFA901黄|r / |cFF0080FF蓝|r>",
	specWarnOozesLZHu	= "<|cFF088A08绿|r / |cFF9932CD紫|r / |cFFFFA901黄|r>",
	specWarnOozesHuHL	= "<|cFFFFA901黄|r / |cFF424242黑|r / |cFF0080FF蓝|r>",
	specWarnOozesZHuH	= "<|cFF9932CD紫|r / |cFFFFA901黄|r / |cFF424242黑|r>",
	specWarnOozesHZH	= "<|cFF9932CD紫|r / |cFFFFA901黄|r / |cFFFF0404红|r>",
	specWarnOozesZHH	= "<|cFF9932CD紫|r / |cFF424242黑|r / |cFFFF0404红|r>"
})

L:SetTimerLocalization({
	timerOozesActive	= "可以攻击软泥"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	warnOozesHit		= "为注入首领的软泥色彩发布提示",
	optspecWarnOoze		= "----------------啟用语音普通战术---------------",
	optspecWarnOozes	= "               按紫＞绿＞蓝提示     (默认)",
	optspecWarnOozes2	= "               按紫＞绿＞黄提示",
	optspecWarnOozesH	= "----------------啟用语音英雄战术---------------",
	optOozesHA	= "                   <绿/紫/黑/蓝>",
	optspecWarnOozesHA1	= "                        杀  绿     (默认)",
	optspecWarnOozesHA2	= "                        杀  紫",
	optspecWarnOozesHA3	= "                        杀  黑",
	optspecWarnOozesHA4	= "                        杀  蓝",
	optOozesHB	= "                   <绿/红/黑/蓝>",
	optspecWarnOozesHB1	= "                        杀  绿     (默认)",
	optspecWarnOozesHB2	= "                        杀  红",
	optspecWarnOozesHB3	= "                        杀  黑",
	optspecWarnOozesHB4	= "                        杀  蓝",
	optOozesHC	= "                   <绿/红/黄/黑>",
	optspecWarnOozesHC1	= "                        杀  绿     (默认)",
	optspecWarnOozesHC2	= "                        杀  红",
	optspecWarnOozesHC3	= "                        杀  黄",
	optspecWarnOozesHC4	= "                        杀  黑",
	optOozesHD	= "                   <绿/紫/黄/蓝>",
	optspecWarnOozesHD1	= "                        杀  绿     (默认)",
	optspecWarnOozesHD2	= "                        杀  紫",
	optspecWarnOozesHD3	= "                        杀  黄",
	optspecWarnOozesHD4	= "                        杀  蓝",
	optOozesHE	= "                   <黄/紫/黑/蓝>",
	optspecWarnOozesHE1	= "                        杀  黄",
	optspecWarnOozesHE2	= "                        杀  紫",
	optspecWarnOozesHE3	= "                        杀  黑     (默认)",
	optspecWarnOozesHE4	= "                        杀  蓝",
	optOozesHF	= "                   <黄/紫/黑/红>",
	optspecWarnOozesHF1	= "                        杀  黄     (默认)",
	optspecWarnOozesHF2	= "                        杀  紫",
	optspecWarnOozesHF3	= "                        杀  黑",
	optspecWarnOozesHF4	= "                        杀  红",
	RangeFrame			= "距离监视(4码)：$spell:104898",
	timerOozesActive	= "计时器：可以攻击软泥"
})

L:SetMiscLocalization({
	Black			= "|cFF424242黑|r",
	Purple			= "|cFF9932CD紫|r",
	Red				= "|cFFFF0404红|r",
	Green			= "|cFF088A08绿|r",
	Blue			= "|cFF0080FF蓝|r",
	Yellow			= "|cFFFFA901黄|r"
})

-----------------------
-- Hagara the Binder --
-----------------------
L= DBM:GetModLocalization(317)

L:SetWarningLocalization({
	WarnPillars				= "%s:剩余%d",
	warnFrostTombCast		= "8秒后%s"
})

L:SetTimerLocalization({
	TimerSpecial 			= "第一次特殊阶段"
})

L:SetOptionLocalization({
	SoundWOP				= "语音警告：重要技能",
	SoundPS					= "语音警告：$spell:105289",
	SoundBM					= "语音警告：加强冰墓警报",
	TimerSpecial 			= "计时器：第一次特殊阶段",
	WarnPillars				= "发布$journal:3919或$journal:4069的剩余数量",
	RangeFrame				= "距离监视：$spell:105269(3码)、$journal:4327(10码)",
	AnnounceFrostTombIcons	= "通告$spell:104451的团队标记(需要团队助理)",
	warnFrostTombCast		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.cast:format(104448, GetSpellInfo(104448)),
	SetIconOnFrostTomb		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(104451),
	SetIconOnLance			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(105316),
	SetIconOnFrostflake		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109325)
})

L:SetMiscLocalization({
	YellIceLance  			= "我是目标，帮忙挡线!",
	TombIconSet				= "冰墓 {rt%d} 是 %s"
})

---------------
-- Ultraxion --
---------------
L= DBM:GetModLocalization(331)

L:SetWarningLocalization({
	SpecwarnFadingLightTime	= "凋零之光 (临近暮光之时)",
	SpecWarnNG1		 = ">>这轮你要留下(1组)<<",
	SpecWarnNG2		 = ">>这轮你要留下(2组)<<",
	SpecWarnNG3		 = ">>这轮你要留下(3组)<<",
	SpecWarnHT1      = "暮光之时--1",
    SpecWarnHT2      = "暮光之时--2",
    SpecWarnHT3      = "暮光之时--3",
	SpecWarnHT4      = "暮光之时--4",
    SpecWarnHT5      = "暮光之时--5",
    SpecWarnHT6      = "暮光之时--6",
	SpecWarnHT7      = "暮光之时--7"
})

L:SetTimerLocalization({
	TimerCombatStart	= "首领降临",
	timerHQ				= "红球 (生命礼赐)",
	timerLvQ			= "绿球 (梦之精华)",
	timerLQ				= "蓝球 (魔法之源)",
	timerRaidCDs		= "%s冷却:%s"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	SpecwarnFadingLightTime	= "特别警告：普通模式下$spell:110068靠近$spell:109416时",
	optSpecWarnHT		= "特别警告：為$spell:106371计数",
	optSpecWarnNG1		= "英雄战术：第一轮留守暮光之时",
	optSpecWarnNG2		= "英雄战术：第二轮留守暮光之时",
	optSpecWarnNG3		= "英雄战术：第三轮留守暮光之时",
	optSpecWarnYoursoon	= "特别警告：提前5秒提示你準备释放减伤",
	optjs				= "<黑手之乡>@眾星之子 公会专用减伤提示模块",
	non					= "老子谁的减伤都不看",
	qishi				= "圣坦大牺牲",
	mushi1				= "牧师A的减伤",
	mushi2				= "牧师B的减伤",
	shengqi1			= "乳骑A的大叔",
	shengqi2			= "乳骑B的大叔",
	saman				= "苦逼萨满的减伤",
	CustomWarning		= "特殊警告：自定义减伤释放模块",
	optShowtime			= "战术计时：战斗时间正计时",
	Myhei				= "战斗结束时告诉我中了多少次$spell:110079",
	TimerCombatStart	= "计时器：战斗开始",
	timerHQ				= "计时器：$spell:105896",
	timerLvQ			= "计时器：$spell:105900",
	timerLQ				= "计时器：$spell:105903",
	ResetHoTCounter		= "重置幕光之时计数",--$spell doesn't work in this function apparently so use typed spellname for now.
	Never				= "不重置",
	Reset3				= "每三次(英雄)/两次(普通)重置",
	Reset3Always		= "总是每三次重置",
	ShowRaidCDs			= "计时器：团队减伤冷却",
	ShowRaidCDsSelf		= "计时器：只显示你的技能冷却(需开啟团队减伤冷却)"
})

L:SetMiscLocalization({
	Pull				= "一股破坏平衡的力量正在接近。它的混乱灼烧着我的心智！",
	HQ					= "spell:105896",
	LQ					= "spell:105903",
	LvQ					= "spell:105900"
})

-------------------------
-- Warmaster Blackhorn --
-------------------------
L= DBM:GetModLocalization(332)

L:SetWarningLocalization({
	SpecwarnTwilightOnslaught	= "快进大漩涡 <第%d次>!",
	specWarnSunderOther 		= "%s被破甲(%d)",
	SpecWarnElites				= "暮光精英!"
})

L:SetTimerLocalization({
	TimerCombatStart	= "战斗开始",
	timerADD 			= "第一波飞龙骑兵",
	timerADD2 			= "第二波飞龙骑兵",
	timerADD3 			= "第三波飞龙骑兵",
	TimerSapper			= "下一次暮光工兵"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	TimerCombatStart 	= "计时器: 战斗开始",
	TimerSapper 		= "计时器: 下一次暮光工兵",--npc=56923
	timerADD 			= "计时器: 第一波$spell:ej4192",
	timerADD2 			= "计时器: 第二波$spell:ej4192",
	timerADD3 			= "计时器: 第三波$spell:ej4192",
	SpecwarnTwilightOnslaught	= "特别警告：$spell:108862",
	specWarnSunderOther			= "特别警告：当别人中了$spell:108043时",
	SpecWarnElites		= "特別警告：新一波的暮光精英",
	InfoFrameRangeX		= "第二阶段显示与黑角的距离",
	Range13				= "超过13码",
	Range10				= "超过10码[在\"10码\"这个点上会被断法]",
	Never				= "不显示",
	InfoFrameSunder		= "信息框：$spell:108043的层数",
	SetTextures			= "智能投影材质"
})

L:SetMiscLocalization({
	SapperEmote 		= "一条幼龙俯冲下来，往甲板上投放了一个暮光工兵！",
	Broadside 			= "spell:110153",
	DeckFire 			= "spell:110095",
	GorionaRetreat		= "痛苦地尖叫并退入了云海的漩涡中"
})

-------------------------
-- Spine of Deathwing  --
-------------------------
L= DBM:GetModLocalization(318)

L:SetWarningLocalization({
	SpecWarnTendril		= "快抓好!翻车啦!!!"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	SpecWarnTendril		= "特别警告：当你没有被$spell:109454时",
	InfoFrameTendrils	= "资讯框：没有$spell:109454的团员",
	InfoFrameBlood		= "资讯框：残渣数量",
	SetIconOnGrip		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109459),
	ShowShieldInfofix	= "為$spell:105479显示一个生命条"
})

L:SetMiscLocalization({
	Pull		= "看那些装甲！他正在解体！摧毁那些装甲，我们就能给他最后一击！",
	NoDebuff	= "没有 %s",
	PlasmaTarget	= "灼热血浆: %s",
	DRoll		= "翻滚!",--Not a single transcriptor log for this fight from anyone, just bad chat logs that have more looting then actual boss encounters. This emote needs to be confirmed/fixed if it1s wrong.
	LeftDroll	= "开始向左侧翻滚",
	RightDroll	= "开始向右侧翻滚",
	DLevels		= "保持平衡"
})

---------------------------
-- Madness of Deathwing  -- 
---------------------------
L= DBM:GetModLocalization(333)

L:SetWarningLocalization({
	SpecWarnTentacle	= "快打极炽触手",
	SpecWarnCongealing	= "快打凝結之血!"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	SoundJS				= "语音警告：腐蚀寄生虫爆炸时间(测试)",
	SpecWarnTentacle	= "特别警告：极炽触手(当没有红龙女王时)",--http://ptr.wowhead.com/npc=56188
	SpecWarnCongealing	= DBM_CORE_AUTO_SPEC_WARN_OPTIONS.spell:format(109089),
	RangeFrame			= "距離監視：$spell:108649（英雄模式）",
	SetIconOnParasite	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(108649)
})

L:SetMiscLocalization({
	Pull				= "你们什么都没做到。我要撕碎你们的世界。",
	Bug					= "腐蚀寄生虫",
	Red					= "阿莱克斯塔萨",
	Yellow				= "诺兹多姆",
	Blue				= "卡雷苟斯",
	Green				= "伊瑟拉"
})

-------------
--  Trash  --
-------------
L = DBM:GetModLocalization("DSTrash")

L:SetGeneralLocalization({
	name =	"巨龙之魂小怪"
})

L:SetWarningLocalization({
	DrakesLeft			= "暮光突袭者剩余: %d"
})

L:SetTimerLocalization({
	TimerDrakes			= "%s"
})

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	DrakesLeft			= "警告：暮光突袭者剩余数量",
	TimerDrakes			= "计时条：暮光突袭者何时$spell:109904"
})

L:SetMiscLocalization({
	EoEEvent			= "不行，巨龙之魂的力量太强大了",
	UltraxionTrash		= "重逢真令我高兴，阿莱克斯塔萨。分开之后，我可是一直很忙。",
	UltraxionTrashEnded = "这些龙崽子，这些实验，只为一个崇高的目标。你很快就会看到我最伟大的研究成果。"
})