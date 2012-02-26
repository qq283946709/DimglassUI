-- -------------------------------------------------------------------------- --
-- DrainSouler deDE Localization                                              --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --
if GetLocale() ~= "deDE" then return end
DrainSouler_Locales:CreateLocaleTable({
["Open Configuration"] = "Konfiguration öffnen",

["Configuration"] = "Konfiguration",
["HP%"] = "HP%", -- HealthPoints in percent -> this is for configuration only
["DMG"] = "DMG", -- Damage -> this is for configuration only
["X"] = "X", -- Ticks (number of Ticks) -> this is for configuration only
["click & move"] = "klicken & bewegen",
["Click and Drag on DrainSouler Frame to move it."] = "DrainSouler Frame klicken und bewegen zum Verschieben.",

["Shows DrainSouler in combat only."] = "Zeigt DrainSouler nur im Kampf",

["Lock DrainSouler"] = "DrainSouler sperren",
["enables click through frame"] = "ermöglicht 'durch-den-Rahmen-klicken'",

["Deactivate DrainSouler if you use Demonology or Destruction."] = "Deaktiviert DrainSouler, wenn du Dämonologie oder Zerstörung benutzt.",
["Your current Spec:"] = "Deine momentane Talentspezialisierung:",

["Size"] = "Größe",

["Target HP"] = "Ziel HP",
["Shows DrainSouler if maximum target HP is greater than %s."] = "Zeigt DrainSouler, wenn maximale Ziel HP größer als %s ist.",

["Target HP (in percent)"] = "Ziel HP (in Prozent)",
["Shows DrainSouler if target HP (in percent) is less or equal %s."] = "Zeigt DrainSouler, wenn Ziel HP (in Prozent) kleiner oder gleich %s ist.",

["TickSound"] = "TickSound",
["No Sound"] = "Kein Sound",
["Plays a sound when Drain Soul dealt damage."] = "Spielt einen Sound, wenn Seelendieb Schaden verursacht hat.",

["25% HP Sound"] = "25% HP Sound",
["Plays a sound when your target is below %s HP and maximum HP is greater than %s."] = "Spielt einen Sound, wenn dein Ziel unter %s HP und maximale HP größer als %s ist.",
["The general 'Target HP' and 'Target HP (in percent)' values are used first!"] = "Die Hauptwerte von 'Ziel HP' und 'Ziel HP (in Prozent)' werden zuerst benutzt!",

["'ESC -> Interface -> AddOns -> DrainSouler' to change Options!"] = "'ESC -> Interface -> AddOns -> DrainSouler' um Optionen zu ändern!",
["Close Configuration"] = "Konfiguration schließen",
})