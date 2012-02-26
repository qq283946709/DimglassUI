-- -------------------------------------------------------------------------- --
-- DrainSouler frFR Localization                                              --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --
if GetLocale() ~= "frFR" then return end
DrainSouler_Locales:CreateLocaleTable({
["Open Configuration"] = "Ouvrez la configuration",

["Configuration"] = "Configuration",
["HP%"] = true, -- HealthPoints in percent -> this is for configuration only
["DMG"] = true, -- Damage -> this is for configuration only
["X"] = true, -- Ticks (number of Ticks) -> this is for configuration only
["click & move"] = true,
["Click and Drag on DrainSouler Frame to move it."] = "Cliquer et faire glisser sur DrainSouler Frame pour le déplacer.",

["Shows DrainSouler in combat only."] = "Montrer DrainSouler seulement au combat.",

["Lock DrainSouler"] = "Verrouiller DrainSouler",
["enables click through frame"] = true,

["Deactivate DrainSouler if you use Demonology or Destruction."] = true,
["Your current Spec:"] = true,

["Size"] = true,

["Target HP"] = "Target HP",
["Shows DrainSouler if maximum target HP is greater than %s."] = true,

["Target HP (in percent)"] = "Target HP (en pourcentage)",
["Shows DrainSouler if target HP (in percent) is less or equal %s."] = true,

["TickSound"] = true,
["No Sound"] = "Désactiver le son",
["Plays a sound when Drain Soul dealt damage."] = true,

["25% HP Sound"] = true,
["Plays a sound when your target is below %s HP and maximum HP is greater than %s."] = true,
["The general 'Target HP' and 'Target HP (in percent)' values are used first!"] = true,

["'ESC -> Interface -> AddOns -> DrainSouler' to change Options!"] = "'ESC -> Interface -> AddOns -> DrainSouler' pour changer les Options!",
["Close Configuration"] = "Fermer la configuration",
})