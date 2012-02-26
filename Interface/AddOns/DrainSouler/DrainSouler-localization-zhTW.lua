-- -------------------------------------------------------------------------- --
-- DrainSouler zhTW Localization                                              --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --
if GetLocale() ~= "zhTW" then return end
DrainSouler_Locales:CreateLocaleTable({
["Open Configuration"] = true,

["Configuration"] = true,
["HP%"] = true, -- HealthPoints in percent -> this is for configuration only
["DMG"] = true, -- Damage -> this is for configuration only
["X"] = true, -- Ticks (number of Ticks) -> this is for configuration only
["click & move"] = "點擊 & 移動",
["Click and Drag on DrainSouler Frame to move it."] = "擊點拖曳 DrainSouler 框架移動",

["Shows DrainSouler in combat only."] = "只在戰鬥中顯示 DrainSouler",

["Lock DrainSouler"] = "鎖定 DrainSouler",
["enables click through frame"] = true,

["Deactivate DrainSouler if you use Demonology or Destruction."] = true,
["Your current Spec:"] = true,

["Size"] = "大小",

["Target HP"] = "目標生命值",
["Shows DrainSouler if maximum target HP is greater than %s."] = "如果目標生命值大於 %s 時顯示 DrainSouler.",

["Target HP (in percent)"] = "目標生命值(百分比)",
["Shows DrainSouler if target HP (in percent) is less or equal %s."] = "如果目標生命值百分比小於等於 %s 時顯示 DrainSouler.",

["TickSound"] = "每一跳音效",
["No Sound"] = "不使用音效",
["Plays a sound when Drain Soul dealt damage."] = "當靈魂吸取造成傷害時播放音效.",

["25% HP Sound"] = true,
["Plays a sound when your target is below %s HP and maximum HP is greater than %s."] = true,
["The general 'Target HP' and 'Target HP (in percent)' values are used first!"] = true,

["'ESC -> Interface -> AddOns -> DrainSouler' to change Options!"] = "ESC -> 介面 -> 插件 -> DrainSouler 來修改選項!",
["Close Configuration"] = "關閉設定",
})