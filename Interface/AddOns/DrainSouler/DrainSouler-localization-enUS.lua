-- -------------------------------------------------------------------------- --
-- DrainSouler DEFAULT (english) Localization                                 --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --

DrainSouler_Locales = {
["Open Configuration"] = true,

["Configuration"] = true,
["HP%"] = true, -- HealthPoints in percent -> this is for configuration only
["DMG"] = true, -- Damage -> this is for configuration only
["X"] = true, -- Ticks (number of Ticks) -> this is for configuration only
["click & move"] = true,
["Click and Drag on DrainSouler Frame to move it."] = true,

["Shows DrainSouler in combat only."] = true,

["Lock DrainSouler"] = true,
["enables click through frame"] = true,

["Deactivate DrainSouler if you use Demonology or Destruction."] = true,
["Your current Spec:"] = true,

["Size"] = true,

["Target HP"] = true,
["Shows DrainSouler if maximum target HP is greater than %s."] = true,

["Target HP (in percent)"] = true,
["Shows DrainSouler if target HP (in percent) is less or equal %s."] = true,

["TickSound"] = true,
["No Sound"] = true,
["Plays a sound when Drain Soul dealt damage."] = true,

["25% HP Sound"] = true,
["Plays a sound when your target is below %s HP and maximum HP is greater than %s."] = true,
["The general 'Target HP' and 'Target HP (in percent)' values are used first!"] = true,

["'ESC -> Interface -> AddOns -> DrainSouler' to change Options!"] = true,
["Close Configuration"] = true,
}

function DrainSouler_Locales:CreateLocaleTable(t)
	for k,v in pairs(t) do
		self[k] = (v == true and k) or v
	end
end

DrainSouler_Locales:CreateLocaleTable(DrainSouler_Locales)