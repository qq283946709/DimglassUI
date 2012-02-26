if GetLocale() ~= "zhTW" then return end
local L

-------------
-- Morchok --
-------------
L= DBM:GetModLocalization(311)

L:SetWarningLocalization({
	SpecwarnVortexAfter	= "躲到石柱後!",
	specWarn3s 			= "3秒後踐踏",
	KohcromWarning		= "%s: %s"
})

L:SetTimerLocalization({
	KohcromCD		= "寇魔的%s",
	timerStompMK	= "魔寇：踐踏",
	timerStompKM	= "寇魔：踐踏",
	timerCrystalMKNext	= "魔寇：下一顆水晶",
	timerCrystalKMNext	= "寇魔：下一顆水晶",
	timerCrystalMK	= "魔寇：水晶爆炸",
	timerCrystalKM	= "寇魔：水晶爆炸"
})

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	MorchokHero			= "英雄模式，二階段提示魔寇[本體]技能        (此處選項優先於計時器選",
	KohcromHero			= "英雄模式，二階段提示寇魔[分身]技能        項,沒選擇的王都不會顯示)",
	SpecwarnVortexAfter	= "特殊警告：$spell:110047結束時",
	KohcromWarning		= "為寇魔的技能顯示警告。",
	specWarn3s 			= "特殊警告：3秒後踐踏",
	timerStompMK		= "計時器：魔寇的$spell:108571",
	timerStompKM		= "計時器：寇魔的$spell:108571",
	timerCrystalMKNext	= "計時器：魔寇的下一顆水晶",
	timerCrystalKMNext	= "計時器：寇魔的下一顆水晶",
	timerCrystalMK		= "計時器：魔寇的水晶爆炸",
	RangeFrame			= "距離監視(5碼)：成就[別站得離我這麼近]",
	timerCrystalKM		= "計時器：寇魔的水晶爆炸"
})

L:SetMiscLocalization({
})

---------------------
-- Warlord Zon'ozz --
---------------------
L= DBM:GetModLocalization(324)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	SoundBJ				= "語音警告：$spell:103434的驅散",
	SoundXX				= "倒計時：$spell:104322",
	ShadowYell			= "自動喊話：當你中了$spell:104601時（英雄模式）",
	CustomRangeFrame	= "距離監視模式設置（10碼）：崩解之影",
	Never				= "關閉",
	Normal				= "普通模式",
	DynamicPhase2		= "智能模式(僅二階段)",
	DynamicAlways		= "智能模式"
})

L:SetMiscLocalization({
	voidYell			= "Gul'kafh an'qov N'Zoth."
})

-----------------------------
-- Yor'sahj the Unsleeping --
-----------------------------
L= DBM:GetModLocalization(325)

L:SetWarningLocalization({
	warnOozesHit	= "%s融合：%s",
	specWarnOozesZ		= "|cFF9932CD快打<紫>軟泥!|r",
	specWarnOozesL		= "|cFF088A08快打<綠>軟泥!|r",
	specWarnOozesB		= "|cFF424242快打<黑>軟泥!|r",
	specWarnOozesY		= "|cFFFFA901快打<黃>軟泥!|r",
	specWarnOozesR		= "|cFF0080FF快打<藍>軟泥!|r",
	specWarnOozesH		= "|cFFFF0404快打<紅>軟泥!|r",
	specWarnOozesLL		= "|cFF088A08綠:4碼分散|r  |cFF0080FF藍:潰法力場|r",
	specWarnOozesHHe	= "|cFFFF0404紅:靠近王|r  |cFF424242黑:召喚小怪|r",
	specWarnOozesHH		= "|cFFFF0404紅:靠近王|r  |cFFFFA901黃:群體暗影箭|r",
	specWarnOozesLH		= "|cFF0080FF藍:潰法力場|r  |cFFFFA901黃:群體暗影箭|r",
	specWarnOozesHuH	= "|cFFFFA901黃:群體暗影箭|r  |cFF424242黑:召喚小怪|r",
	specWarnOozesLHe	= "|cFF0080FF藍:潰法力場|r  |cFF424242黑:召喚小怪|r",
	specWarnOozesZHL	= "<|cFF9932CD紫|r / |cFF424242黑|r / |cFF0080FF藍|r>",
	specWarnOozesHHL	= "<|cFFFF0404紅|r / |cFF424242黑|r / |cFF0080FF藍|r>",
	specWarnOozesHHH	= "<|cFFFF0404紅|r / |cFF424242黑|r / |cFFFFA901黃|r>",
	specWarnOozesZLH	= "<|cFF9932CD紫|r / |cFFFFA901黃|r / |cFF0080FF藍|r>",
	specWarnOozesLLH	= "<|cFF088A08綠|r / |cFF424242黑|r / |cFF0080FF藍|r>",
	specWarnOozesZLL	= "<|cFF9932CD紫|r / |cFF088A08綠|r / |cFF0080FF藍|r>",
	specWarnOozesLZH	= "<|cFF088A08綠|r / |cFF9932CD紫|r / |cFF424242黑|r>",
	specWarnOozesLHL	= "<|cFF088A08綠|r / |cFFFF0404紅|r / |cFF0080FF藍|r>",
	specWarnOozesLHH	= "<|cFF088A08綠|r / |cFFFF0404紅|r / |cFF424242黑|r>",
	specWarnOozesLHuH	= "<|cFF088A08綠|r / |cFFFFA901黃|r / |cFF424242黑|r>",
	specWarnOozesLHHu	= "<|cFF088A08綠|r / |cFFFF0404紅|r / |cFFFFA901黃|r>",
	specWarnOozesLHuL	= "<|cFF088A08綠|r / |cFFFFA901黃|r / |cFF0080FF藍|r>",
	specWarnOozesLZHu	= "<|cFF088A08綠|r / |cFF9932CD紫|r / |cFFFFA901黃|r>",
	specWarnOozesHuHL	= "<|cFFFFA901黃|r / |cFF424242黑|r / |cFF0080FF藍|r>",
	specWarnOozesZHuH	= "<|cFF9932CD紫|r / |cFFFFA901黃|r / |cFF424242黑|r>",
	specWarnOozesHZH	= "<|cFF9932CD紫|r / |cFFFFA901黃|r / |cFFFF0404紅|r>",
	specWarnOozesZHH	= "<|cFF9932CD紫|r / |cFF424242黑|r / |cFFFF0404紅|r>"
})

L:SetTimerLocalization({
	timerOozesActive	= "可以攻擊軟泥"
})

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	warnOozesHit		= "為何種顏色的軟泥注入至首領發佈提示",
	optspecWarnOoze		= "----------------啟用語音普通戰術---------------",
	optspecWarnOozes	= "               按紫＞綠＞藍提示     (默認)",
	optspecWarnOozes2	= "               按紫＞綠＞黃提示",
	optspecWarnOozesH	= "----------------啟用語音英雄戰術---------------",
	optOozesHA	= "                   <綠/紫/黑/藍>",
	optspecWarnOozesHA1	= "                        殺  綠     (默認)",
	optspecWarnOozesHA2	= "                        殺  紫",
	optspecWarnOozesHA3	= "                        殺  黑",
	optspecWarnOozesHA4	= "                        殺  藍",
	optOozesHB	= "                   <綠/紅/黑/藍>",
	optspecWarnOozesHB1	= "                        殺  綠     (默認)",
	optspecWarnOozesHB2	= "                        殺  紅",
	optspecWarnOozesHB3	= "                        殺  黑",
	optspecWarnOozesHB4	= "                        殺  藍",
	optOozesHC	= "                   <綠/紅/黃/黑>",
	optspecWarnOozesHC1	= "                        殺  綠     (默認)",
	optspecWarnOozesHC2	= "                        殺  紅",
	optspecWarnOozesHC3	= "                        殺  黃",
	optspecWarnOozesHC4	= "                        殺  黑",
	optOozesHD	= "                   <綠/紫/黃/藍>",
	optspecWarnOozesHD1	= "                        殺  綠     (默認)",
	optspecWarnOozesHD2	= "                        殺  紫",
	optspecWarnOozesHD3	= "                        殺  黃",
	optspecWarnOozesHD4	= "                        殺  藍",
	optOozesHE	= "                   <黃/紫/黑/藍>",
	optspecWarnOozesHE1	= "                        殺  黃",
	optspecWarnOozesHE2	= "                        殺  紫",
	optspecWarnOozesHE3	= "                        殺  黑     (默認)",
	optspecWarnOozesHE4	= "                        殺  藍",
	optOozesHF	= "                   <黃/紫/黑/紅>",
	optspecWarnOozesHF1	= "                        殺  黃     (默認)",
	optspecWarnOozesHF2	= "                        殺  紫",
	optspecWarnOozesHF3	= "                        殺  黑",
	optspecWarnOozesHF4	= "                        殺  紅",
	RangeFrame			= "距離監視(4碼)：$spell:104898",
	timerOozesActive	= "計時器：可以攻擊軟泥"
})

L:SetMiscLocalization({
	Black			= "|cFF424242黑|r",
	Purple			= "|cFF9932CD紫|r",
	Red				= "|cFFFF0404紅|r",
	Green			= "|cFF088A08綠|r",
	Blue			= "|cFF0080FF藍|r",
	Yellow			= "|cFFFFA901黃|r"
})

-----------------------
-- Hagara the Binder --
-----------------------
L= DBM:GetModLocalization(317)

L:SetWarningLocalization({
	WarnPillars				= "%s:剩餘%d",
	warnFrostTombCast		= "8秒後%s"
})

L:SetTimerLocalization({
	TimerSpecial 			= "第一次特殊階段"
})

L:SetOptionLocalization({
	SoundWOP				= "語音警告：重要技能",
	SoundPS					= "語音警告：$spell:105289",
	SoundBM					= "語音警告：加強冰墓警報",
	TimerSpecial 			= "計時器：第一次特殊階段",
	WarnPillars				= "發佈$journal:3919或$journal:4069的剩餘數量",
	RangeFrame				= "距離監視：$spell:105269(3碼)、$journal:4327(10碼)",
	AnnounceFrostTombIcons	= "通告$spell:104451的團隊標記(需要團隊助理)",
	warnFrostTombCast		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.cast:format(104448, GetSpellInfo(104448)),
	SetIconOnFrostTomb		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(104451),
	SetIconOnLance			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(105316),
	SetIconOnFrostflake		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109325)
})

L:SetMiscLocalization({
	YellIceLance  			= "我是目標，幫忙擋線!",
	TombIconSet				= "冰墓 {rt%d} 是 %s"
})

---------------
-- Ultraxion --
---------------
L= DBM:GetModLocalization(331)

L:SetWarningLocalization({
	SpecwarnFadingLightTime	= "凋零之光 (臨近暮光之時)",
	SpecWarnNG1		 = ">>這輪你要留下(1組)<<",
	SpecWarnNG2		 = ">>這輪你要留下(2組)<<",
	SpecWarnNG3		 = ">>這輪你要留下(3組)<<",
	SpecWarnYoursoon	 = ">>5秒後你的減傷<<",
	SpecWarnHT1      = "暮光之時--1",
    SpecWarnHT2      = "暮光之時--2",
    SpecWarnHT3      = "暮光之時--3",
	SpecWarnHT4      = "暮光之時--4",
    SpecWarnHT5      = "暮光之時--5",
    SpecWarnHT6      = "暮光之時--6",
	SpecWarnHT7      = "暮光之時--7"
})

L:SetTimerLocalization({
	TimerCombatStart	= "首領降臨",
	timerHQ				= "紅球 (生命禮賜)",
	timerLvQ			= "綠球 (夢之精華)",
	timerLQ				= "藍球 (魔法之源)",
	timerRaidCDs		= "%s冷卻:%s"
})

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	SpecwarnFadingLightTime	= "特別警告：普通模式下$spell:110068靠近$spell:109416時",
	optSpecWarnHT		= "特別警告：為$spell:106371計數",
	optSpecWarnNG1		= "英雄戰術：第一輪留守暮光之時",
	optSpecWarnNG2		= "英雄戰術：第二輪留守暮光之時",
	optSpecWarnNG3		= "英雄戰術：第三輪留守暮光之時",
	optSpecWarnYoursoon	= "特別警告：提前5秒提示你準備釋放減傷",
	optjs				= "<黑手之鄉>@眾星之子 公會專用減傷提示模塊",
	non					= "老子誰的減傷都不看",
	qishi				= "聖坦大犧牲",
	mushi1				= "牧師A的減傷",
	mushi2				= "牧師B的減傷",
	shengqi1			= "乳騎A的大叔",
	shengqi2			= "乳騎B的大叔",
	saman				= "苦逼薩滿的減傷",
	CustomWarning		= "特殊警告：自定義減傷釋放模塊",
	optShowtimes		= "戰術計時：戰鬥時間正計時",
	Myhei				= "戰鬥結束時告訴我中了多少次$spell:110079",
	TimerCombatStart	= "計時器：戰鬥開始",
	timerHQ				= "計時器：$spell:105896",
	timerLvQ			= "計時器：$spell:105900",
	timerLQ				= "計時器：$spell:105903",
	ResetHoTCounter		= "重置幕光之時計數",--$spell doesn't work in this function apparently so use typed spellname for now.
	Never				= "不重置",
	Reset3				= "每三次(英雄)/兩次(普通)重置",
	Reset3Always		= "總是每三次重置",
	ShowRaidCDs			= "計時器：團隊減傷冷卻",
	ShowRaidCDsSelf		= "計時器：只顯示你的技能冷卻(需開啟團隊減傷冷卻)"
})

L:SetMiscLocalization({
	Pull				= "我感到平衡被一股強大的波動干擾。如此混沌在燃燒我的心靈!",
	HQ					= "spell:105896",
	LQ					= "spell:105903",
	LvQ					= "spell:105900"
})

-------------------------
-- Warmaster Blackhorn --
-------------------------
L= DBM:GetModLocalization(332)

L:SetWarningLocalization({
	SpecwarnTwilightOnslaught	= "快進大漩渦 <第%d次>!",
	specWarnSunderOther 		= "%s被破甲(%d)",
	SpecWarnElites				= "新暮光精英抵達!"
})

L:SetTimerLocalization({
	TimerCombatStart	= "戰鬥開始",
	timerADD 			= "第一波飛龍騎兵",
	timerADD2 			= "第二波飛龍騎兵",
	timerADD3 			= "第三波飛龍騎兵",
	TimerSapper			= "下一次暮光工兵"
})

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	TimerCombatStart 	= "計時器：戰鬥開始",
	TimerSapper 		= "計時器：下一次暮光工兵",--npc=56923
	timerADD 			= "計時器：第一波$spell:ej4192",
	timerADD2 			= "計時器：第二波$spell:ej4192",
	timerADD3 			= "計時器：第三波$spell:ej4192",
	SpecwarnTwilightOnslaught	= "特別警告：$spell:108862",
	specWarnSunderOther			= "特別警告：當別人中了至少2層$spell:108043時",
	SpecWarnElites		= "特別警告：新一波的暮光精英",
	InfoFrameRangeX		= "第二階段顯示與黑角的距離",
	Range13				= "以13碼為安全",
	Range10				= "以10碼為安全[在\"10碼\"這個點上會被斷法]",
	Never				= "不顯示",
	InfoFrameSunder		= "資訊框：$spell:108043的層數",
	SetTextures			= "智能投影材質"
})

L:SetMiscLocalization({
	SapperEmote 		= "工兵",
	Broadside 			= "spell:110153",
	DeckFire 			= "spell:110095",
	GorionaRetreat		= "躲入旋繞的雲裡"
})

-------------------------
-- Spine of Deathwing  --
-------------------------
L= DBM:GetModLocalization(318)

L:SetWarningLocalization({
	SpecWarnTendril		= "快抓好!翻車啦!!!"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	SpecWarnTendril		= "特別警告：當你沒有被$spell:109454時",
	InfoFrameTendrils	= "資訊框：沒有$spell:109454的團員",
	InfoFrameBlood		= "資訊框：背上的殘渣數量",
	SetIconOnGrip		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(109459),
	ShowShieldInfofix	= "為$spell:105479顯示一個生命條"
})

L:SetMiscLocalization({
	Pull		= "別擔心我!阻止毀滅者!再會了，朋友。",
	NoDebuff	= "沒有 %s",
	PlasmaTarget	= "燃燒血漿: %s",
	DRoll		= "翻滾!",--Not a single transcriptor log for this fight from anyone, just bad chat logs that have more looting then actual boss encounters. This emote needs to be confirmed/fixed if it's wrong.
	LeftDroll	= "準備往左翻滾",
	RightDroll	= "準備往右翻滾",
	DLevels		= "平衡"
})

---------------------------
-- Madness of Deathwing  -- 
---------------------------
L= DBM:GetModLocalization(333)

L:SetWarningLocalization({
	SpecWarnTentacle	= "快打極熾觸手!",
	SpecWarnCongealing	= "快打凝結之血!"
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	SoundJS				= "语音警告：腐化寄生體爆炸時間(測試)",
	SpecWarnTentacle	= "特別警告：極熾觸手(當沒有紅龍女王時)",
	SpecWarnCongealing	= DBM_CORE_AUTO_SPEC_WARN_OPTIONS.spell:format(109089),
	RangeFrame			= "距離監視：$spell:108649（英雄模式）",
	SetIconOnParasite	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(108649)
})

L:SetMiscLocalization({
	Pull				= "你們都徒勞無功。我會撕裂你們的世界。",
	Bug					= "腐化寄生體",
	Red					= "雅立史卓莎",
	Yellow				= "諾茲多姆",
	Blue				= "卡雷苟斯",
	Green				= "伊瑟拉"
})

-------------
--  Trash  --
-------------
L = DBM:GetModLocalization("DSTrash")

L:SetGeneralLocalization({
	name =	"雜兵"
})

L:SetWarningLocalization({
	DrakesLeft			= "暮光猛擊者剩餘: %d"
})

L:SetTimerLocalization({
	TimerDrakes			= "%s"
})

L:SetOptionLocalization({
	SoundWOP			= "語音警告：重要技能",
	DrakesLeft			= "警告：暮光猛擊者剩餘數量",
	TimerDrakes			= "計時器：暮光猛擊者$spell:109904"
})

L:SetMiscLocalization({
	EoEEvent			= "沒有用，巨龍之魂的力量太強了。",
	UltraxionTrash		= "很高興又見到你，雅立史卓莎。我離開這段時間忙得很。",
	UltraxionTrashEnded = "這些幼龍、實驗品，只不過是實現更偉大目標的手段罷了。你會看到研究的龍蛋有什麼成果。"
})