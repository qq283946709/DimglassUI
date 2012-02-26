-- -------------------------------------------------------------------------- --
-- DrainSouler zhCN Localization                                              --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --
if GetLocale() ~= "zhCN" then return end
DrainSouler_Locales:CreateLocaleTable({
["Open Configuration"] = true,

["Configuration"] = true,
["HP%"] = true, -- HealthPoints in percent -> this is for configuration only
["DMG"] = true, -- Damage -> this is for configuration only
["X"] = true, -- Ticks (number of Ticks) -> this is for configuration only
["click & move"] = "点击 & 移动",
["Click and Drag on DrainSouler Frame to move it."] = "点击和拖曳 DrainSouler 框体来移动.",

["Shows DrainSouler in combat only."] = "仅在战斗中显示 DrainSouler ",

["Lock DrainSouler"] = "锁定 DrainSouler ",
["enables click through frame"] = true,

["Deactivate DrainSouler if you use Demonology or Destruction."] = true,
["Your current Spec:"] = true,

["Size"] = "大小",

["Target HP"] = "目标生命值",
["Shows DrainSouler if maximum target HP is greater than %s."] = "如果目标生命值大于 %s 时显示 DrainSouler.",

["Target HP (in percent)"] = "目标生命值(百分比)",
["Shows DrainSouler if target HP (in percent) is less or equal %s."] = "如果目标生命值百分比小于等于 %s 时显示 DrainSouler.",

["TickSound"] = "跳数音效",
["No Sound"] = "没有音效",
["Plays a sound when Drain Soul dealt damage."] = "当吸取灵魂造成伤害时播放音效.",

["25% HP Sound"] = true,
["Plays a sound when your target is below %s HP and maximum HP is greater than %s."] = true,
["The general 'Target HP' and 'Target HP (in percent)' values are used first!"] = true,

["'ESC -> Interface -> AddOns -> DrainSouler' to change Options!"] = "'ESC -> 界面 -> 插件 -> DrainSouler 来修改选项!",
["Close Configuration"] = "关闭配置",
})