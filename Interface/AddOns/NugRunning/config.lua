local _, helpers = ...
local AddSpell = helpers.AddSpell
local AddCooldown = helpers.AddCooldown
local AddActivation = helpers.AddActivation
local Talent = helpers.Talent
local Glyph = helpers.Glyph
local GetCP = helpers.GetCP
local _,class = UnitClass("player")

--[[
GUIDE:
        Settings:
            duration - kinda neccesary, but if possible accurate duration will be scanned from target, mouseover, player for buffs and arena 1-5, focus for debuffs.
                       only if spell is applied to something out of these unit ids then this value is used.
        
            [optional]
            name     - text on the progress bar
            color    - RGB of bar color for spell
            short    - short name for spell. works if short text is enabled
            pvpduration - same as duration, but for enemy players 
            recast_mark - creates a mark that will shine when spell should be recasted. For example 3.5 for haunt is roughly travel time at 30yds + cast 
            multiTarget - for aoe spells
            timeless - progress bar is empty and won't disappear until game event occured and duration serves for bar sorting
            shine    - shine animation when applied
            shinerefresh - when refreshed
            glowtime
            fixedlen
            charged & maxcharge
            
]]

local colors = {
    RED = { 0.8, 0, 0},
    LRED = { 1,0.4,0.4},
    CURSE = { 0.6, 0, 1 },
    PINK = { 1, 0.3, 0.6 },
    TEAL = { 0.32, 0.52, 0.82 },
    ORANGE = { 1, 124/255, 33/255 },
    FIRE = {1,80/255,0},
    LBLUE = {149/255, 121/255, 214/255},
    LGREEN = { 0.63, 0.8, 0.35 },
    PURPLE = { 187/255, 75/255, 128/255 },
    FROZEN = { 65/255, 110/255, 1 },
    CHILL = { 0.6, 0.6, 1},
    BLACK = {0.4,0.4,0.4},
    WOO = {151/255, 86/255, 168/255},
    WOO2 = {80/255, 83/255, 150/255},
    BROWN = { 192/255, 77/255, 48/255},
}
NugRunningConfig.colors = colors


local useTrinkets = true
local procTrinkets = true
local stackingTrinkets = false
if useTrinkets then
    AddSpell({ 33702,33697,20572 },{ name = "Blood Fury", duration = 15 }) --Orc Racial
    AddSpell( 26297 ,{ name = "Berserking", duration = 10 }) --Troll Racial
	AddSpell( 100403 ,{ name = "月井祝福",duration = 8})  --月井之瓶
	AddSpell( 105786 ,{ name = "時光崩裂",duration = 10})  --術士4T13
end
if procTrinkets then
    --AddSpell( 60437 ,{ name = "Grim Toll", duration = 10 })
	AddSpell( 99232 ,{ name = "天啟",duration = 8})  --術士4T12
	AddSpell( 107982 ,{ name = "速度",duration = 20})  --腐敗心靈徽記
	AddSpell( 105826 ,{ name = "時光恩澤",duration = 23})  --牧師治療2T13
end
if stackingTrinkets then
    --AddSpell( 65006 ,{ name = "EotBM",duration = 10 }) --Eye of the Broodmother
end

if class == "WARLOCK" then
AddSpell( 74434 ,{ name = "靈魂炙燃",duration = 20, color = colors.CURSE })

AddSpell( 348 ,{ name = "獻祭", recast_mark = 1.5, duration = 15, priority = 10, ghost = true, color = colors.RED, init = function(self)self.duration = 15 + Talent(85105)*3 end })
AddSpell( 34936 ,{ name = "反衝",duration = 8, shine = true, color = colors.CURSE })
AddSpell( 47283 ,{ name = "強力小鬼",duration = 8, shine = true, color = colors.CURSE })
AddSpell( 85383 ,{ name = "強化靈魂之火",duration = 8, ghost = true, priority = 4, recast_mark = 3,short = "靈魂之火", color = colors.BLACK })
AddSpell( 80240 ,{ name = "浩劫災厄",duration = 300, color = colors.WOO, short = "浩劫" })
AddSpell( 30283 ,{ name = "暗影之怒",duration = 3, multiTarget = true })
AddSpell( 47960 ,{ name = "暗影之焰",duration = 6, multiTarget = true })
AddCooldown( 50796, { name = "混沌箭", ghost = true, priority = 3, color = colors.LBLUE })
AddCooldown( 17962, { name = "焚燒", ghost = true, priority = 5, color = colors.LRED })

AddSpell({ 47383,71162,71165 },{ name = "熔火之心",duration = 18, shine = true, color = colors.PURPLE})
AddSpell( 54277 ,{ name = "爆燃",duration = 15, shine = true, color = colors.PURPLE})
-- REMOVED_DOSE event is not fired for molten core, so it's stuck at 3
AddSpell({ 63167,63165 },{ name = "屠戮",duration = 8, color = colors.LBLUE })
AddCooldown( 71521, { name = "古爾丹之手",  color = colors.LRED })
AddSpell( 79459 ,{ name = "惡魔之魂: 小鬼",duration = 30, short = "惡魔之魂", color = colors.CURSE })
AddSpell( 79460 ,{ name = "惡魔之魂: 地獄獵犬",duration = 20, short = "惡魔之魂", color = colors.CURSE })
AddSpell( 79463 ,{ name = "惡魔之魂: 魅魔",duration = 20, short = "惡魔之魂", color = colors.CURSE })
AddSpell( 79462 ,{ name = "惡魔之魂: 惡魔衛士",duration = 20, short = "惡魔之魂", color = colors.CURSE })
AddSpell( 79464 ,{ name = "惡魔之魂: 虛無行者",duration = 15, short = "誤導", color = colors.CURSE })
AddSpell( 47241 ,{ name = "惡魔變身",duration = 36, short = "變身", color = colors.PINK })


AddSpell( 86211 ,{ name = "靈魂調換",duration = 20, shine = true, color = colors.BLACK })
AddSpell( 17941 ,{ name = "夜幕",duration = 10, shine = true, color = colors.CURSE })
AddSpell( 64371 ,{ name = "滅絕",duration = 10, color = colors.WOO })
AddSpell( 30108 ,{ name = "痛苦無常", priority = 10, duration = 15, ghost = true, recast_mark = 1.5, color = colors.RED, short = "無常" })
AddSpell( 48181 ,{ name = "蝕魂術",duration = 12, priority = 8, ghost = true, recast_mark = 3, color = colors.TEAL }) --Haunt
AddSpell( 172 ,{ name = "腐蝕術", priority = 9, ghost = true, color = colors.PINK, duration = 18 })
AddSpell( 980 ,{ name = "痛苦災厄",duration = 24, ghost = true, priority = 6, color = colors.WOO, short = "痛苦", init = function(self)self.duration = 24 + Glyph(56241)*4 end })
AddSpell( 603 ,{ name = "末日災厄", ghost = true, duration = 60, color = colors.WOO, short = "末日" })
AddSpell( 1120 ,{ name = "吸取靈魂",duration = 15, color = colors.LRED })
AddSpell( 27243 ,{ name = "腐蝕之種",duration = 15, color = colors.LRED, short = "種子" })

AddSpell( 1714 ,{ name = "語言詛咒",duration = 30, color = colors.CURSE, pvpduration = 12, short = "語言" })
AddSpell( 702 ,{ name = "虛弱詛咒",duration = 120, color = colors.CURSE, short = "虛弱" })
AddSpell( 18223 ,{ name = "疲勞詛咒",duration = 12, color = colors.CURSE, short = "疲勞" })
AddSpell( 1490 ,{ name = "元素詛咒",duration = 300, glowtime = 15, color = colors.CURSE, pvpduration = 120, short = "元素" })
-- JINX ID 85547

AddSpell( 24259 ,{ name = "法術封鎖",duration = 3, color = colors.PINK })
AddSpell( 6358 ,{ name = "誘惑",duration = 15, pvpduration = 8 })
AddSpell( 17767 ,{ name = "吞噬暗影", duration = 6, color = colors.PURPLE})
AddSpell( 89766 ,{ name = "投擲利斧", color = colors.BROWN, duration = 4 })
AddSpell( 7812 ,{ name = "犧牲",duration = 30, color = colors.PURPLE })
--
AddSpell( 5782 ,{ name = "恐懼", duration = 20, pvpduration = 8 })
AddSpell( 5484 ,{ name = "恐懼嚎叫", duration = 8, multiTarget = true })                    
AddSpell( 710 ,{ name = "放逐術", duration = 30 })
--AddCooldown( 48181, { name = "蝕魂術",  color = colors.LRED })
AddCooldown( 47897, { name = "暗影之焰", color = colors.PURPLE })
end
   

if class == "PRIEST" then
-- BUFFS
--AddSpell( 139 ,{ name = "恢復", shinerefresh = true, color = colors.LGREEN, duration = 15 })
--AddSpell( 17 ,{ name = "真言術: 盾", shinerefresh = true, duration = 15, color = colors.LRED, short = "盾" })
AddSpell( 41635 ,{ name = "癒合禱言", shinerefresh = true, duration = 30, color = colors.RED, textfunc = function(timer) return timer.dstName end })
--AddSpell( 88688 ,{ name = "光之澎湃",duration = 10 })
AddSpell( 47788 ,{ name = "守護聖靈", shine = true, duration = 10, color = colors.LBLUE, short = "大天使" })
AddSpell( 33206 ,{ name = "痛苦鎮壓",shine = true, duration = 8, color = colors.LBLUE })
AddSpell( 586 ,{ name = "漸隱術",duration = 10 })
AddSpell( 89485 ,{ name = "心靈專注", shine = true, color = colors.LBLUE, timeless = true, duration = 0.1 })
-- AddSpell( 49694,59000 ,{ name = "Improved Spirit Tap",duration = 8 })
-- AddSpell( 15271 ,{ name = "Spirit Tap",duration = 15 })
AddSpell( 47585 ,{ name = "影散",duration = 6, color = colors.PURPLE })
--~ AddSpell( 47753 ,{ name = "Divine Aegis", duration = 12 })
AddSpell({ 59889,59888,59887 },{ name = "預支時間", duration = 6 })
AddSpell( 77613,{ name = "恩典", shinerefresh = true, color = colors.TEAL, duration = 15 })
-- DEBUFFS
AddSpell( 6788 ,{ name = "虛弱靈魂",duration = 15, shinerefresh = true, priority = 7, color = colors.PURPLE, refreshed = true, short = "虛弱" })
AddSpell( 589 ,{ name = "真言術: 痛",duration = 18, ghost = true, priority = 9, color = colors.PURPLE, refreshed = true, short = "痛" })
AddSpell( 34914 ,{ name = "吸血之觸", recast_mark = 1.5, ghost = true, priority = 10, duration = 15, color = colors.RED, short = "觸", hasted = true })
AddSpell( 2944 ,{ name = "噬靈瘟疫",duration = 24, ghost = true, priority = 8, color = colors.WOO, short = "瘟疫", hasted = true })
AddSpell( 9484 ,{ name = "束縛不死生物",duration = 50, pvpduration = 8, short = "縛死" })
AddSpell( 15487 ,{ name = "沉默",duration = 5, color = colors.PINK })
AddSpell( 95799 ,{ name = "強化暗影",recast_mark = 1.5, ghost = true, priority = 5, short = "紅球", duration = 15, color = colors.BLACK })
--AddSpell( 15286 ,{ name = "吸血鬼的擁抱",duration = 300, color = colors.CURSE, short = "VampEmbrace" })
AddSpell( 8122 ,{ name = "心靈尖嘯",duration = 8, multiTarget = true })
--AddSpell( 15407, { name = "精神鞭笞",  color = colors.CURSE, duration = 3 })

--Shadow Orbs
AddSpell( 77487 ,{ name = "暗影寶珠",duration = 60, charged = true, maxcharge = 3, timeless = true, shine = true, shinerefresh = true, priority = 4, short = "黑球", color = colors.WOO })

AddCooldown( 8092, { name = "心靈震爆",  color = colors.CURSE })
AddCooldown( 32379, { name = "暗言術: 死", ghost = true, short = "SW:Death",  color = colors.PURPLE })

AddSpell( 81781 ,{ name = "真言術: 壁", short = "壁", duration = 25, color = {1,0.7,0.5} }) -- duration actually used here, invisible aura applied

--AddSpell( 77487 ,{ name = "暗影寶珠",duration = 60, color = colors.CURSE })
--AddSpell( 87718 ,{ name = "平靜思緒圖騰",duration = 15, color = colors.CURSE })
AddSpell( 87153 ,{ name = "黑天使",duration = 18, color = colors.CURSE })

AddSpell( 88688 ,{ name = "光之澎湃", color = colors.LRED, duration = 10 })
AddSpell( 14751 ,{ name = "脈輪運轉", color = colors.CURSE, timeless = true, duration = 0.1 })
AddSpell( 81208 ,{ name = "脈輪運轉: 平靜", short = "平靜", color = colors.WOO, shine = true, timeless = true, duration = 9999 })
AddSpell( 81206 ,{ name = "脈輪運轉: 庇護", color = colors.WOO2, short = "庇護", shine = true, timeless = true, duration = 9999 })
AddSpell( 81209 ,{ name = "脈輪運轉: 譴責", short = "譴責", color = colors.RED, shine = true, timeless = true, duration = 9999 })
AddSpell( 88625 ,{ name = "真言術: 譴", color = colors.LRED, short = "譴", duration = 18 })

AddSpell( 81661 ,{ name = "佈道",duration = 15, color = colors.ORANGE, stackcolor = {
                                [1] = {0.7,0,0},
                                [2] = {1,0.6,0.2},
                                [3] = {1,1,0.4},
                                [4] = {0.8,1,0.5},
                                [5] = {0.7,1,0.2},
                            } })
AddSpell( 81700 ,{ name = "大天使",duration = 18, color = colors.CURSE })

AddSpell({ 63731,63735 } ,{ name = "機緣回復",duration = 20, color = {0.4,0.4,0.9} })
end


if class == "ROGUE" then
-- BUFFS
AddSpell( 32645 ,{ name = "毒化", color = { 0, 0.65, 0}, duration = function() return (1+GetCP()) end })

AddSpell( 2983 ,{ name = "疾跑", shine = true, duration = 15 })
AddSpell( 5277 ,{ name = "閃避", color = colors.PINK, duration = 15 })
AddSpell( 31224 ,{ name = "暗影披風", color = colors.CURSE, duration = 5, short = "斗篷" })
AddSpell( 14183 ,{ name = "預謀",duration = 20, color = colors.CURSE })                    
AddSpell( 74002 ,{ name = "戰鬥洞察", shine = true, shinerefresh = true, duration = 6, color = colors.CURSE })
AddSpell( 73651 ,{ name = "養精蓄銳", shinerefresh = true, color = colors.LGREEN ,duration = function() return (6 * GetCP()) end })
AddSpell( 5171 ,{ name = "切割", shinerefresh = true,  short = "切割", color = colors.PURPLE,
    duration = function() return (6 + GetCP()*3)*(1+Talent(14165)*0.25) end,
    init = function(self) self.fixedlen = (21 + Glyph(56810)*6) * (1+Talent(14165)*0.25) end
})
    
-- DEBUFFS
AddSpell( 1833 ,{ name = "偷襲", duration = 4, color = colors.LRED })
AddSpell( 408 ,{ name = "腎擊", shine = true, duration = 5,color = colors.LRED })
AddSpell( 1776 ,{ name = "鑿擊", color = colors.PINK, duration = 4,
    init = function(self) self.duration = 4 + Talent(13741)*1 end
})
AddSpell( 2094 ,{ name = "致盲",duration = 60, pvpduration = 8, color = {0.20, 0.80, 0.2} })
AddSpell( 8647 ,{ name = "破甲", shinerefresh = true, color = colors.LBLUE,
    duration = function() return GetCP() * 10 end
})
AddSpell( 51722 ,{ name = "卸除武裝",duration = 10, short = "繳械", color = colors.LRED })
AddSpell( 6770 ,{ name = "悶棍",duration = 60, color = colors.LBLUE })

AddSpell( 1943 ,{ name = "割裂", shinerefresh = true, color = colors.RED, fixedlen = 16,
    duration = function() return (6 + GetCP() * 2) + Glyph(56801)*4 end,
    init = function(self) self.fixedlen = 16 + Glyph(56801)*4 end
})
AddSpell( 703 ,{ name = "絞喉", color = colors.RED, duration = 18 })
AddSpell( 1330 ,{ name = "沉默", color = colors.PINK, duration = 3 })

--AddSpell( 2818, { name = "致命毒藥", color = { 0.1, 0.75, 0.1}, duration = 12, short = "致命"})
--AddSpell( 3409 ,{ name = "致殘毒藥", color = { 192/255, 77/255, 48/255}, duration = 12, short = "致殘" })
--AddSpell( 51693 ,{ name = "埋伏", color = { 192/255, 77/255, 48/255}, duration = 8 })

AddSpell( 14177 ,{ name = "冷血", shine = true, color = colors.TEAL, timeless = true, duration = 0.1})
AddSpell( 79140 ,{ name = "宿怨", shine = true, color = colors.CURSE, duration = 30 })
AddSpell( 79126 ,{ name = "暈頭轉向", shine = true, color = colors.BLACK, duration = 8 })
--AddSpell( 58427 ,{ name = "極限殺戮", duration = 20, color =  colors.LRED })

AddSpell( 84745 ,{ name = "淺察", short = "1x Insight", shine = true, color = colors.CURSE, duration = 15 })
AddSpell( 84746 ,{ name = "中度洞察", short = "2x Insight", shine = true, color = colors.CURSE, duration = 15 })
AddSpell( 84747 ,{ name = "深度洞察", short = "3x Insight", shine = true, color = colors.CURSE, duration = 15 })
AddSpell( 13750 ,{ name = "能量刺激",duration = 15, color = colors.LRED })
AddSpell( 13877 ,{ name = "劍刃亂舞",duration = 15, color = colors.LRED })

AddSpell( 51713 ,{ name = "暗影之舞",duration = 10, color = colors.BLACK })
AddSpell( 16511 ,{ name = "出血",duration = 60, color = colors.CURSE })

--AddSpell( 1784 ,{ name = "潛行", color = colors.CURSE, timeless = true, duration = 0.1})
-- 1725, { name = "擾亂", color = colors.PURPLE, duration = 10 })

end

if class == "WARRIOR" then
AddSpell( 6673 ,{ name = "戰鬥怒吼", multiTarget = true, glowtime = 10, shout = true, color = colors.PURPLE, duration = 120,init = function(self)self.duration = (120 + Glyph(58385)*120) * (1+Talent(12321) * 0.25)  end })
AddSpell( 469 ,{ name = "命令之吼", multiTarget = true, glowtime = 10, short = "命令", shout = true, color = colors.PURPLE, duration = 120, init = function(self)self.duration = (120 + Glyph(68164)*120) * (1+Talent(12321) * 0.25)  end })
AddSpell( 2565 ,{ name = "盾牌格擋", color = colors.WOO2, duration = 10 })
AddSpell( 85730 ,{ name = "沉著殺機", duration = 10 })
AddSpell( 12328 ,{ name = "橫掃攻擊", color = colors.LRED, short = "橫掃", duration = 10 })

--~ AddSpell( 86346 ,{ name = "巨像碎擊", short = "巨像", color = colors.BLACK, duration = 6 })
AddSpell( 1715 ,{ name = "斷筋", ghost = true, color = colors.BROWN, duration = 15, pvpduration = 8 })
AddSpell( 23694 ,{ name = "強化斷筋", shine = true, color = colors.LRED, duration = 5 })
AddSpell( 85388 ,{ name = "撂倒", color = colors.LRED, duration = 5 })
AddSpell( 94009 ,{ name = "撕裂", color = colors.RED, duration = 15 })   -- like DKs frost fever & plague
AddSpell( 46968 ,{ name = "震懾波", color = { 0.6, 0, 1 }, shine = true, duration = 4, multiTarget = true })
AddSpell( 12809 ,{ name = "震盪猛擊", color = { 1, 0.3, 0.6 }, duration = 5 })
AddSpell( 355 ,{ name = "嘲諷", duration = 3 })
AddSpell( 58567 ,{ name = "破甲攻擊", short = "破甲", anySource = true, color = { 1, 0.2, 0.2}, duration = 30 })
AddSpell( 1160 ,{ name = "挫志怒吼", anySource = true, short = "挫志", color = {0.3, 0.9, 0.3}, duration = 30, multiTarget = true })
AddSpell( 6343 ,{ name = "雷霆一擊", anySource = true, short = "雷霆", color = {149/255, 121/255, 214/255}, duration = 30, multiTarget = true })
--~ AddSpell( 56112 ,{ name = "狂烈攻擊", duration = 10 })
--AddActivation( 5308, { name = "斬殺", shine = true, timeless = true, color = colors.CURSE, duration = 0.1 })

AddCooldown( 12294, { name = "致死打擊", short = "致死", recast_mark = 1.5, fixedlen = 9, ghost = true,  color = colors.CURSE })
--AddSpell( 52437 ,{ name = "驟亡", shine = true, color = colors.BLACK, timeless = true, duration = 0.1 })
--AddActivation( 86346, { name = "Reset", shine = true,  color = colors.BLACK, duration = 0.1 })
AddCooldown( 86346 ,{ name = "巨像碎擊", ghost = true, short = "巨像", color = colors.BLACK, resetable = true, duration = 20 })
--AddActivation( 7384, { name = "壓制", shine = true, color = colors.LBLUE, duration = 6})
AddSpell( 60503 ,{ name = "血腥體驗", recast_mark = 4, color = colors.RED, duration = 9 }) -- Taste for blood
--AddSpell( 90806 ,{ name = "處決者", color = colors.WOO, duration = 30 })

AddCooldown( 23881, { name = "嗜血", short = "", ghost = true, recast_mark = 1.5, fixedlen = 6,  color = colors.CURSE })
AddSpell( 46916 ,{ name = "熱血沸騰", shine = true, color = colors.LRED, duration = 10 })

AddCooldown( 85288, { name = "狂怒之擊", ghost = true,  color = colors.WOO })
AddActivation( 85288, { name = "Enraged", for_cd = true })
AddSpell( 85288, { name = "Enraged", shine = true, showid = 14202, color = colors.RED, duration = 10 })
-- it's enrage timer config

AddCooldown( 1680, { name = "旋風斬", color = colors.LBLUE })

AddSpell( 12976, { name = "破釜沉舟", color = colors.BLACK, duration = 20 })
AddSpell( 871, { name = "盾墻", color = colors.WOO2, duration = 12 })
AddCooldown( 23922, { name = "盾牌猛擊", short = "盾猛", recast_mark = 1.5, ghost = true,  color = colors.CURSE, resetable = true })
--AddActivation( 23922, { name = "Slam!", shine = true, timeless = true, color = colors.CURSE, duration = 0.1 })
--AddSpell( 50227 ,{ name = "劍盾合璧", shine = true, timeless = true, color = colors.CURSE, duration = 0.1 })
AddCooldown( 6572, { name = "復仇", color = colors.WOO, fixedlen = 6, ghost = true })
AddActivation( 6572, { name = "復仇激活", for_cd = true })
-- AddCooldown( 78, { name = "英勇打擊 Strike", short = "英勇", fixedlen = 6, ghost = true })
-- AddCooldown( 6343, { name = "雷霆一擊", short = "雷霆", ghost = true })


AddSpell( 32216, { name = "勝利", color = colors.PINK, duration = 20})

AddSpell( 20253, { name = "攔截", duration = 3 })
AddSpell( 7922, { name = "衝鋒昏迷", duration = 1, init = function(self)self.duration = 1 + Talent(64976)*2 end })
end

if class == "DEATHKNIGHT" then
AddSpell( 55095 ,{ name = "冰霜熱疫", color = colors.CHILL, duration = 21, init = function(self)self.duration = 21 + Talent(49036)*4 end })
AddSpell( 55078 ,{ name = "血魄瘟疫", color = colors.PURPLE, duration = 21, init = function(self)self.duration = 21 + Talent(49036)*4 end })

--BLOOD
AddSpell( 81130 ,{ name = "血色熱疫", duration = 30, color = colors.LRED })
AddSpell( 73975 ,{ name = "亡域打擊", duration = 10, color = colors.WOO })
AddSpell( 55233 ,{ name = "血族之裔", duration = 10, color = colors.RED })
AddSpell( 81256 ,{ name = "符文武器幻舞", short = "符文幻舞", duration = 12, color = colors.RED })
--AddSpell( 49222 ,{ name = "骸骨之盾", duration = 300, color = colors.WOO2 })

--FROST
AddSpell( 57330 ,{ name = "凜冬號角", duration = 120, shout = true, glowtime = 8, color = colors.CURSE, multiTarget = true, short = "號角", init = function(self)self.duration = 120 + Glyph(58680)*60 end })
AddSpell( 45524 ,{ name = "冰鍊術", duration = 8, color = colors.CHILL })
AddSpell( 49203 ,{ name = "噬溫酷寒", duration = 10, color = colors.FROZEN, multiTarget = true })
AddSpell( 48792 ,{ name = "冰錮堅韌", duration = 12 })
AddSpell( 51124 ,{ name = "殺戮酷刑", duration = 30 })
AddSpell( 59052 ,{ name = "冰封之霧", duration = 15 })
AddSpell( 49039 ,{ name = "巫妖之軀", duration = 10, color = colors.BLACK })

--UNHOLY
AddSpell( 91342 ,{ name = "闇能灌注", shinerefresh = true, duration = 30, color = colors.LGREEN, short = "灌注" })
AddSpell( 63560 ,{ name = "黑暗變形", shine = true, duration = 30, color = colors.LGREEN, short = "變形" })
AddSpell( 81340 ,{ name = "厄運驟臨", shine = true, duration = 10, color = colors.CURSE })
AddSpell( 47476 ,{ name = "絞殺", duration = 5 })
AddSpell( 91800 ,{ name = "啃食", duration = 3, color = colors.RED })
AddSpell( 91797 ,{ name = "暴猛痛擊", duration = 4, color = colors.RED, short = "Gnaw" })
AddSpell( 49016 ,{ name = "邪惡狂熱", duration = 30, color = colors.LRED })
AddSpell( 48707 ,{ name = "反魔法護罩", duration = 5, short = "綠罩", color = colors.LGREEN })

end

if class == "MAGE" then
--ARCANE
AddSpell( 80353 ,{ name = "時間扭曲", shine = true, target = "player", duration = 40, color = colors.WOO2 })
AddSpell({ 118,61305,28271,28272,61721,61780 },{ name = "變形術", duration = 50, color = colors.LGREEN, pvpduration = 8, short = "變形" })
AddSpell( 12042 ,{ name = "秘法強化",duration = 15, short = "奧強", color = colors.PINK })
--~ AddSpell( 66 ,{ name = "隱形術",duration = 3 - NugRunning.TalentInfo(31574) })
AddSpell( 32612 ,{ name = "隱形術",duration = 20 })
AddSpell( 12043 ,{ name = "氣定神閒 of Mind", shine = true, timeless = true, duration = 0.1, color = colors.CURSE, short = "氣定" })
AddSpell( 36032 ,{ name = "秘法衝擊",duration = 6, color = colors.CURSE })
AddCooldown( 44425 ,{ name = "秘法彈幕", color = colors.RED })
AddSpell( 79683 ,{ name = "秘法飛彈!", shine = true, duration = 20, color = colors.WOO })
--~ AddSpell( 55342 ,{ name = "幻鏡之像",duration = 30 })
--~ AddSpell( 44413 ,{ name = "咒法移轉",duration = 10, color = colors.LRED, short = "吸收" })

AddSpell( 12536 ,{ name = "節能施法",duration = 15, color = colors.BLACK })
AddSpell( 31589 ,{ name = "減速術", duration = 15, pvpduration = 8 })
AddSpell( 18469 ,{ name = "沉默",duration = 2, color = colors.PINK }) -- imp CS
AddSpell( 55021 ,{ name = "沉默",duration = 4, color = colors.PINK }) -- imp CS
--FIRE
AddSpell( 22959 ,{ name = "火焰重擊", shinerefresh = true, duration = 30, recast_mark = 2.5, color = colors.CURSE})
AddSpell( 64343 ,{ name = "衝擊", shine = true, duration = 10, color = colors.BLACK })
AddSpell( 44457 ,{ name = "活體爆彈",duration = 12, ghost = true, target = "target", color = colors.RED, short = "爆彈" })
AddSpell( 48108 ,{ name = "焦炎之痕",duration = 10, shine = true, color = colors.CURSE})
AddSpell( 11113 ,{ name = "衝擊波", color = colors.CHILL, duration = 3, multiTarget = true })
AddSpell( 31661 ,{ name = "龍之吐息", duration = 5, color = colors.ORANGE, short = "龍息", multiTarget = true })
AddSpell( 2120 ,{ name = "烈焰風暴", duration = 8, color = colors.PURPLE, multiTarget = true })
AddCooldown( 82731, { name = "烈焰之球", color = colors.WOO})
--AddCooldown( 2136, { name = "火焰衝擊", resetable = true, color = colors.LRED})

--FROST
AddSpell( 12472 ,{ name = "冰寒脈動",duration = 20 })
AddSpell( 82691 ,{ name = "霜之環", shine = true, color = colors.FROZEN, multiTarget = true, duration = 12, pvpduration = 8 }) -- it's not multi target, but... it can spam
AddSpell( 122 ,{ name = "冰霜新星",duration = 8, short = "FrNova", color = colors.FROZEN, multiTarget = true })
AddSpell( 33395 ,{ name = "冰凍術",duration = 8, color = colors.FROZEN })
AddSpell( 44544 ,{ name = "冰霜之指", shine = true, duration = 15, color = colors.FROZEN, short = "冰指" })
AddSpell( 57761 ,{ name = "腦部凍結", shine = true, duration = 15, color = colors.LRED, short = "火球!" })
AddSpell( 55080 ,{ name = "碎裂屏障",duration = 4, color = colors.FROZEN, short = "碎裂" })
AddSpell( 11426 ,{ name = "寒冰護體",duration = 60, color = colors.LGREEN })
AddSpell( 45438 ,{ name = "寒冰屏障",duration = 10, short = "冰箱" })
AddSpell( 44572 ,{ name = "極度冰凍",duration = 5, short = "深結" })
AddSpell( 120 ,{ name = "冰錐術", duration = 8, color = colors.CHILL, short = "冰錐", multiTarget = true })
AddSpell( 83302 ,{ name = "強化冰錐術", duration = 4, color = colors.FROZEN, short = "強化冰錐", multiTarget = true })
end

if class == "PALADIN" then

--AddSpell( 53657 ,{ name = "純潔審判", short = "純潔", duration = 100500, color = colors.LBLUE })
AddSpell( 84963 ,{ name = "異端審問",duration = 10, color = colors.PURPLE })  -- 10 * CP
AddSpell( 31884 ,{ name = "復仇之怒",duration = 20, short = "AW" })
AddSpell( 498 ,{ name = "聖佑術",duration = 12, short = "聖佑" })
AddSpell( 642 ,{ name = "聖盾術",duration = 12, short = "聖盾" })
AddSpell( 1022 ,{ name = "保護聖禦",duration = 10, short = "保護" })
AddSpell( 1044 ,{ name = "自由聖禦",duration = 6, short = "自由" })
AddSpell( 10326 ,{ name = "退邪術",duration = 20, pvpduration = 8, color = colors.LGREEN })

AddSpell( 53563 ,{ name = "聖光信標",duration = 300, short = "道標",color = colors.RED })
AddSpell( 54428 ,{ name = "神性祈求",duration = 15, short = "神性祈求" })
AddSpell( 31842 ,{ name = "神恩術",duration = 20, short = "神恩" })
AddSpell( 20066 ,{ name = "懺悔",duration = 60, pvpduration = 8 })
AddSpell( 853 ,{ name = "制裁之錘",duration = 6, short = "制裁", color = colors.FROZEN })
--AddSpell( 31803 ,{ name = "譴責",duration = 15, color = colors.RED})
AddSpell( 85696 ,{ name = "狂熱精神",duration = 20 })

AddCooldown( 35395 ,{ name = "十字軍聖擊", color = colors.RED })
AddCooldown( 20925 ,{ name = "神聖之盾", color = colors.RED })
AddCooldown( 24275 ,{ name = "憤怒之錘", color = colors.TEAL })
AddCooldown( 20271 ,{ name = "審判", color = colors.LRED })
AddCooldown( 26573 ,{ name = "奉獻", color = colors.CURSE })
AddCooldown( 20473 ,{ name = "神聖震擊", color = colors.PINK })


--AddSpell( 94686 ,{ name = "十字軍", duration = 15 })
AddSpell( 59578 ,{ name = "戰爭藝術", shine = true, color = colors.ORANGE, duration = 15 })
--AddActivation( 879 ,{ name = "驅邪術", shine = true, color = colors.ORANGE, duration = 15 })
--AddActivation( 84963 ,{ name = "異端審問", shine = true, showid = 85256, short = "異端", color = colors.PINK, duration = 8 })
AddSpell( 90174 ,{ name = "神聖意圖", shine = true, showid = 85256, short = "意圖", color = colors.PINK, duration = 8 })

AddSpell( 62124 ,{ name = "清算聖禦", duration = 3 })
AddSpell( 85416 ,{ name = "大十字軍", shine = true, timeless = true, duration = 0.1, color = colors.BLACK })
--AddActivation( 31935 ,{ name = "復仇之盾", shine = true, timeless = true, duration = 0.1, color = colors.BLACK })
AddCooldown( 31935 ,{ name = "復仇之盾", resetable = true, duration = 15, short = "復仇之盾", color = colors.BLACK })
end

if class == "DRUID" then
AddSpell( 339 ,{ name = "糾纏根鬚",duration = 30 })
AddSpell( 91565 ,{ name = "精靈之火",duration = 300, pvpduration = 40, color = colors.CURSE }) --second is feral

--AddSpell( 48391 ,{ name = "梟化狂亂", duration = 10 })
AddSpell( 48517 ,{ name = "蝕星蔽月(日蝕)", timeless = true, duration = 0.1, short = "日蝕", color = colors.ORANGE }) -- Wrath boost
AddSpell( 48518 ,{ name = "蝕星蔽月(月蝕)", timeless = true, duration = 0.1, short = "月蝕", color = colors.LBLUE }) -- Starfire boost
AddSpell( 2637 ,{ name = "休眠",duration = 40, pvpduration = 8 })
AddSpell( 33786 ,{ name = "颶風術", duration = 6 })
AddSpell( 8921 ,{ name = "月火術",duration = 12, ghost = true, color = colors.PURPLE, init = function(self) self.duration = 12 + Talent(57810)*2 end })
AddSpell( 93402 ,{ name = "日炎術",duration = 12, ghost = true, color = colors.ORANGE, init = function(self) self.duration = 12 + Talent(57810)*2 end })
AddSpell( 5570 ,{ name = "蟲群",duration = 12, ghost = true, color = colors.LGREEN, init = function(self) self.duration = 12 + Talent(57810)*2 end })
AddSpell( 93400 ,{ name = "流星", shine = true, duration = 12, color = colors.CURSE })
AddCooldown( 78674 ,{ name = "星湧術", resetable = true, ghost = true, color = colors.CURSE })

AddSpell( 50334 ,{ name = "狂暴", duration = 15 })
--cat
AddSpell( 9005 ,{ name = "突襲", duration = 3, color = colors.PINK, init = function(self)self.duration = 3 + Talent(16940)*0.5 end })
AddSpell( 9007 ,{ name = "血襲", color = colors.RED, duration = 18 })
AddSpell( 33876 ,{ name = "割碎", color = colors.CURSE, duration = 60 })
AddSpell( 1822 ,{ name = "掃擊", duration = 15, color = colors.LRED })
AddSpell( 1079 ,{ name = "撕扯",duration = 16, color = colors.RED })
AddSpell( 22570 ,{ name = "傷殘術", color = colors.PINK, duration = function() return GetCP() end })
AddCooldown(5217, { name = "猛虎之怒", color = colors.LBLUE})
AddSpell( 52610 ,{ name = "兇蠻咆哮", color = colors.PURPLE, duration = function() return (17 + GetCP() * 5) end })
AddSpell( 1850 ,{ name = "突進", duration = 15 })
AddSpell( 81022 ,{ name = "奔竄", duration = 8 })
--bear
AddSpell( 99 ,{ name = "挫志咆哮", anySource = true, short = "挫志", color = {0.3, 0.9, 0.3}, duration = 30, multiTarget = true })
AddSpell( 6795 ,{ name = "低吼", duration = 3 })
AddSpell( 33745 ,{ name = "割裂", duration = 15, color = colors.RED })
AddSpell( 5209 ,{ name = "挑戰咆哮", shine = true, duration = 6, multiTarget = true })
AddSpell( 45334 ,{ name = "野性衝鋒",duration = 4, color = colors.LRED, init = function(self)self.duration = 4 + Talent(16940)*0.5 end })
AddSpell( 5211 ,{ name = "重擊",duration = 4, shine = true, color = colors.PINK, init = function(self)self.duration = 4 + Talent(16940)*0.5 end })
AddCooldown( 77758, { name = "痛擊", color = colors.LBLUE })
AddCooldown( 33878 ,{ name = "割碎", resetable = true, color = colors.CURSE })
AddSpell( 93622 ,{ name = "狂暴", shine = true, color = colors.CURSE, duration = 5 })
AddSpell( 80951 ,{ name = "粉碎", shinerefresh = true, color = colors.PURPLE, duration = 18 })

AddSpell( 22812 ,{ name = "樹皮術",duration = 12 })
AddSpell( 17116 ,{ name = "自然迅捷", timeless = true, duration = 0.1, color = colors.TEAL, short = "迅捷" })
AddSpell( 774 ,{ name = "回春術",duration = 12, color = { 1, 0.2, 1} })
AddSpell( 8936 ,{ name = "癒合",duration = 6, color = { 198/255, 233/255, 80/255} })
AddSpell( 33763 ,{ name = "生命之花", shinerefresh = true, duration = 10, init = function(self)self.duration = 7 + Talent(57865)*2 end, stackcolor = {
                                                                            [1] = { 0, 0.8, 0},
                                                                            [2] = { 0.2, 1, 0.2},
                                                                            [3] = { 0.5, 1, 0.5},
                                                                        }})
AddSpell( 48438 ,{ name = "野性痊癒", duration = 7, multiTarget = true, color = colors.LGREEN })
AddSpell( 29166 ,{ name = "啟動",duration = 10 })
AddSpell( 16870 ,{ name = "節能施法",  duration = 15 })
end

if class == "HUNTER" then
AddSpell( 51755 ,{ name = "偽裝", duration = 60, target = "player", color = colors.CURSE })
AddSpell( 19263 ,{ name = "威懾", duration = 5, color = colors.LBLUE })

AddSpell( 19615 ,{ name = "狂亂效果", duration = 10, color = colors.CURSE })
AddSpell( 82654 ,{ name = "寡婦毒液", duration = 30, color = { 0.1, 0.75, 0.1} })

AddSpell( 56453 ,{ name = "蓄勢待發", duration = 12, color = colors.LRED })
AddSpell( 19574 ,{ name = "狂野怒火", duration = 18, color = colors.LRED })

AddSpell( 136 ,{ name = "治療寵物", duration = 10, color = colors.LGREEN })

AddSpell( 2974 ,{ name = "摔絆", duration = 10, pvpduration = 8, color = { 192/255, 77/255, 48/255} })
AddSpell( 19306 ,{ name = "反擊", duration = 5, color = { 192/255, 77/255, 48/255} })
AddSpell( 13797 ,{ name = "獻祭陷阱", duration = 15, color = colors.ORANGE, init = function(self)self.duration = 15 - Glyph(56846)*6 end })
AddSpell( 1978 ,{ name = "毒蛇釘刺", duration = 15, color = colors.PURPLE })
AddSpell( 19503 ,{ name = "驅散射擊", duration = 4, color = colors.CHILL })
AddSpell( 5116 ,{ name = "震盪射擊", duration = 6, color = colors.CHILL, init = function(self)self.duration = 4 + Talent(19407) end })
AddSpell( 34490 ,{ name = "沉默射擊", duration = 3, color = colors.PINK, short = "沉默" })

AddSpell( 24394 ,{ name = "脅迫", duration = 3, color = colors.RED })
AddSpell( 19386 ,{ name = "翼龍釘刺", duration = 30, pvpduration = 8, short = "翼龍",color = colors.RED })


AddSpell( 3355 ,{ name = "冰凍陷阱", duration = 10, pvpduration = 8, color = colors.FROZEN, init = function(self)self.duration = 20 * (1+Talent(19376)*0.1) end })

AddSpell( 1513 ,{ name = "恐嚇野獸", duration = 20, pvpduration = 8, color = colors.CURSE })

AddSpell( 3045 ,{ name = "急速射擊", duration = 15, color = colors.CURSE })

AddCooldown( 83381 ,{ name = "擊殺命令", color = colors.LRED })
AddCooldown( 53209 ,{ name = "奇美拉射擊", color = colors.RED })
AddCooldown( 53301 ,{ name = "爆裂射擊", color = colors.RED })
AddCooldown( 3674 ,{ name = "黑蝕箭", color = colors.CURSE })
end

if class == "SHAMAN" then
AddSpell( 8056 ,{ name = "冰霜震擊", duration = 8, color = colors.CHILL, short = "FrS" })

AddSpell( 16188 ,{ name = "自然迅捷", timeless = true, duration = 0.1, color = colors.TEAL, short = "迅捷" })
AddSpell( 61295 ,{ name = "激流", duration = 15, color = colors.FROZEN })
AddSpell( 76780 ,{ name = "元素束縛", duration = 50, pvpduration = 8, color = colors.PINK })
AddSpell( 51514 ,{ name = "妖術", duration = 50, pvpduration = 8, color = colors.CURSE })
AddSpell( 79206 ,{ name = "靈行者之賜", duration = 10, color = colors.LGREEN })

AddSpell( 8050 ,{ name = "烈焰震擊", duration = 18, color = colors.PURPLE, short = "FlS" })
AddSpell( 16166 ,{ name = "精通元素", duration = 30, color = colors.CURSE })
AddCooldown( 8056 ,{ name = "震擊", color = colors.LRED })
AddCooldown( 51505 ,{ name = "熔岩爆發", color = colors.RED, resetable = true })

AddSpell( 30823 ,{ name = "薩滿之怒", duration = 15, color = colors.BLACK })
AddCooldown( 60103 ,{ name = "熔岩暴擊", color = colors.RED })
AddSpell( 53817 ,{ name = "氣漩武器", duration = 12, color = colors.PURPLE, short = "氣漩" })
AddCooldown( 17364 ,{ name = "風暴打擊", color = colors.CURSE })
AddCooldown( 73680 ,{ name = "釋放元素能量", color = colors.WOO, short = "釋放" })

end