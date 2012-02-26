-- -------------------------------------------------------------------------- --
-- DrainSouler koKR Localization                                              --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --
if GetLocale() ~= "koKR" then return end
DrainSouler_Locales:CreateLocaleTable({
["Open Configuration"] = true,

["Configuration"] = true,
["HP%"] = true, -- HealthPoints in percent -> this is for configuration only
["DMG"] = true, -- Damage -> this is for configuration only
["X"] = true, -- Ticks (number of Ticks) -> this is for configuration only
["click & move"] = true,
["Click and Drag on DrainSouler Frame to move it."] = "클릭하여 영혼 흡수 창을 이동 할수 있습니다.",

["Shows DrainSouler in combat only."] = "전투 중에만 영혼 흡수 창 보기",

["Lock DrainSouler"] = "영혼 흡수 창 잠금",
["enables click through frame"] = true,

["Deactivate DrainSouler if you use Demonology or Destruction."] = true,
["Your current Spec:"] = true,

["Size"] = "크기",

["Target HP"] = "대상 체력",
["Shows DrainSouler if maximum target HP is greater than %s."] = "대상의 최대 체력이 %s 보다 더 높을때에 창 보기.",

["Target HP (in percent)"] = "대상 체력 (백분률)",
["Shows DrainSouler if target HP (in percent) is less or equal %s."] = "대상의 체력(백분률)이 %s 보다 작거나 같을때에 창 보기.",

["TickSound"] = "틱 소리",
["No Sound"] = "소리 끔",
["Plays a sound when Drain Soul dealt damage."] = "플레이어가 영혼 흡수를 할때 나오는 소리 입니다.",

["25% HP Sound"] = true,
["Plays a sound when your target is below %s HP and maximum HP is greater than %s."] = true,
["The general 'Target HP' and 'Target HP (in percent)' values are used first!"] = true,

["'ESC -> Interface -> AddOns -> DrainSouler' to change Options!"] = "'ESC -> Interface -> AddOns -> DrainSouler'에서 설정 변경!",
["Close Configuration"] = "환경 설정 닫기",
})