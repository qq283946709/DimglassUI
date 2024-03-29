-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Crafting - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_crafting.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- The following functions are contained attached to this file:
-- Blacksmithing:HasProfession() - determines if the player is an blacksmith

-- The following "global" (within the addon) variables are initialized in this file:
-- Blacksmithing.slot - hardcoded list of the slot of every craft

-- ===================================================================================== --


-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Crafting") -- loads the localization table
local Blacksmithing = TSM:NewModule("Blacksmithing", "AceEvent-3.0")

local debug = function(...) TSM:Debug(...) end -- for debugging

-- determines if the player is an blacksmith
function Blacksmithing:HasProfession()
	local professionIDs = {2018, 3100, 3538, 9785, 29844, 51300, 76666}
	for _, id in pairs(professionIDs) do
		if IsSpellKnown(id) then return true end
	end
end

function Blacksmithing:GetSlot(itemID)
	if not itemID then return end
	return Blacksmithing.slot[itemID] or #Blacksmithing.slotList
end

Blacksmithing.slotList = {L["Item Enhancements"], L["Armor - Chest"], L["Armor - Feet"], L["Armor - Hands"],
	L["Armor - Head"], L["Armor - Legs"], L["Armor - Shield"], L["Armor - Shoulders"], L["Armor - Waist"], L["Armor - Wrists"],
	L["Weapon - Main Hand"], L["Weapon - One Hand"], L["Weapon - Thrown"], L["Weapon - Two Hand"], L["Misc Items"], L["Other"]}

Blacksmithing.slot = {
	[55056]=1, -- Item Enhancements
	[55054]=1, -- Item Enhancements
	[41611]=1, -- Item Enhancements
	[44936]=1, -- Item Enhancements
	[55057]=1, -- Item Enhancements
	[41976]=1, -- Item Enhancements
	[42500]=1, -- Item Enhancements
	[55055]=1, -- Item Enhancements
	[23529]=1, -- Item Enhancements
	[23530]=1, -- Item Enhancements
	[28421]=1, -- Item Enhancements
	[33185]=1, -- Item Enhancements
	[18262]=1, -- Item Enhancements
	[12645]=1, -- Item Enhancements
	[7967]=1, -- Item Enhancements
	[7969]=1, -- Item Enhancements
	[23576]=1, -- Item Enhancements
	[25521]=1, -- Item Enhancements
	[23559]=1, -- Item Enhancements
	[23575]=1, -- Item Enhancements
	[23528]=1, -- Item Enhancements
	[28420]=1, -- Item Enhancements
	[12404]=1, -- Item Enhancements
	[12643]=1, -- Item Enhancements
	[6041]=1, -- Item Enhancements
	[7964]=1, -- Item Enhancements
	[7965]=1, -- Item Enhancements
	[6043]=1, -- Item Enhancements
	[6042]=1, -- Item Enhancements
	[2871]=1, -- Item Enhancements
	[3241]=1, -- Item Enhancements
	[2863]=1, -- Item Enhancements
	[3240]=1, -- Item Enhancements
	[2862]=1, -- Item Enhancements
	[3239]=1, -- Item Enhancements
	[55058]=2, -- Armor - Chest
	[55060]=2, -- Armor - Chest
	[55062]=2, -- Armor - Chest
	[47589]=2, -- Armor - Chest
	[47590]=2, -- Armor - Chest
	[47591]=2, -- Armor - Chest
	[47592]=2, -- Armor - Chest
	[47593]=2, -- Armor - Chest
	[47594]=2, -- Armor - Chest
	[43586]=2, -- Armor - Chest
	[31364]=2, -- Armor - Chest
	[31369]=2, -- Armor - Chest
	[22669]=2, -- Armor - Chest
	[22191]=2, -- Armor - Chest
	[22196]=2, -- Armor - Chest
	[12641]=2, -- Armor - Chest
	[55078]=2, -- Armor - Chest
	[55086]=2, -- Armor - Chest
	[55032]=2, -- Armor - Chest
	[41353]=2, -- Armor - Chest
	[42725]=2, -- Armor - Chest
	[41129]=2, -- Armor - Chest
	[40672]=2, -- Armor - Chest
	[23513]=2, -- Armor - Chest
	[23522]=2, -- Armor - Chest
	[23527]=2, -- Armor - Chest
	[23509]=2, -- Armor - Chest
	[23507]=2, -- Armor - Chest
	[22762]=2, -- Armor - Chest
	[19690]=2, -- Armor - Chest
	[19693]=2, -- Armor - Chest
	[12618]=2, -- Armor - Chest
	[20550]=2, -- Armor - Chest
	[12628]=2, -- Armor - Chest
	[11606]=2, -- Armor - Chest
	[12624]=2, -- Armor - Chest
	[7939]=2, -- Armor - Chest
	[3844]=2, -- Armor - Chest
	[2870]=2, -- Armor - Chest
	[55040]=2, -- Armor - Chest
	[55024]=2, -- Armor - Chest
	[40959]=2, -- Armor - Chest
	[40951]=2, -- Armor - Chest
	[39085]=2, -- Armor - Chest
	[23489]=2, -- Armor - Chest
	[23490]=2, -- Armor - Chest
	[12613]=2, -- Armor - Chest
	[12422]=2, -- Armor - Chest
	[12415]=2, -- Armor - Chest
	[12405]=2, -- Armor - Chest
	[7935]=2, -- Armor - Chest
	[7930]=2, -- Armor - Chest
	[3845]=2, -- Armor - Chest
	[7963]=2, -- Armor - Chest
	[2869]=2, -- Armor - Chest
	[2866]=2, -- Armor - Chest
	[6731]=2, -- Armor - Chest
	[2864]=2, -- Armor - Chest
	[3471]=2, -- Armor - Chest
	[10421]=2, -- Armor - Chest
	[49905]=3, -- Armor - Feet
	[49906]=3, -- Armor - Feet
	[49907]=3, -- Armor - Feet
	[45559]=3, -- Armor - Feet
	[45560]=3, -- Armor - Feet
	[45561]=3, -- Armor - Feet
	[43588]=3, -- Armor - Feet
	[41391]=3, -- Armor - Feet
	[41392]=3, -- Armor - Feet
	[41394]=3, -- Armor - Feet
	[32402]=3, -- Armor - Feet
	[20039]=3, -- Armor - Feet
	[55074]=3, -- Armor - Feet
	[55082]=3, -- Armor - Feet
	[41348]=3, -- Armor - Feet
	[42730]=3, -- Armor - Feet
	[41128]=3, -- Armor - Feet
	[40671]=3, -- Armor - Feet
	[23525]=3, -- Armor - Feet
	[23511]=3, -- Armor - Feet
	[19048]=3, -- Armor - Feet
	[55028]=3, -- Armor - Feet
	[55036]=3, -- Armor - Feet
	[54854]=3, -- Armor - Feet
	[40949]=3, -- Armor - Feet
	[39088]=3, -- Armor - Feet
	[23487]=3, -- Armor - Feet
	[12611]=3, -- Armor - Feet
	[12426]=3, -- Armor - Feet
	[12419]=3, -- Armor - Feet
	[12409]=3, -- Armor - Feet
	[7936]=3, -- Armor - Feet
	[7933]=3, -- Armor - Feet
	[3847]=3, -- Armor - Feet
	[3846]=3, -- Armor - Feet
	[7916]=3, -- Armor - Feet
	[3484]=3, -- Armor - Feet
	[3482]=3, -- Armor - Feet
	[6350]=3, -- Armor - Feet
	[3469]=3, -- Armor - Feet
	[34378]=4, -- Armor - Hands
	[34380]=4, -- Armor - Hands
	[23531]=4, -- Armor - Hands
	[23532]=4, -- Armor - Hands
	[23533]=4, -- Armor - Hands
	[22670]=4, -- Armor - Hands
	[19164]=4, -- Armor - Hands
	[22194]=4, -- Armor - Hands
	[12639]=4, -- Armor - Hands
	[55072]=4, -- Armor - Hands
	[55080]=4, -- Armor - Hands
	[55034]=4, -- Armor - Hands
	[41349]=4, -- Armor - Hands
	[41356]=4, -- Armor - Hands
	[41357]=4, -- Armor - Hands
	[42724]=4, -- Armor - Hands
	[41114]=4, -- Armor - Hands
	[41127]=4, -- Armor - Hands
	[23520]=4, -- Armor - Hands
	[23526]=4, -- Armor - Hands
	[23514]=4, -- Armor - Hands
	[23517]=4, -- Armor - Hands
	[23508]=4, -- Armor - Hands
	[22763]=4, -- Armor - Hands
	[19692]=4, -- Armor - Hands
	[19057]=4, -- Armor - Hands
	[20549]=4, -- Armor - Hands
	[12632]=4, -- Armor - Hands
	[12631]=4, -- Armor - Hands
	[7938]=4, -- Armor - Hands
	[54852]=4, -- Armor - Hands
	[55026]=4, -- Armor - Hands
	[40952]=4, -- Armor - Hands
	[41975]=4, -- Armor - Hands
	[23491]=4, -- Armor - Hands
	[23482]=4, -- Armor - Hands
	[12418]=4, -- Armor - Hands
	[7919]=4, -- Armor - Hands
	[7927]=4, -- Armor - Hands
	[9366]=4, -- Armor - Hands
	[7917]=4, -- Armor - Hands
	[3485]=4, -- Armor - Hands
	[3483]=4, -- Armor - Hands
	[3474]=4, -- Armor - Hands
	[3472]=4, -- Armor - Hands
	[41386]=5, -- Armor - Head
	[41387]=5, -- Armor - Head
	[41388]=5, -- Armor - Head
	[31368]=5, -- Armor - Head
	[23534]=5, -- Armor - Head
	[23535]=5, -- Armor - Head
	[23536]=5, -- Armor - Head
	[31371]=5, -- Armor - Head
	[19148]=5, -- Armor - Head
	[12640]=5, -- Armor - Head
	[55077]=5, -- Armor - Head
	[55085]=5, -- Armor - Head
	[55039]=5, -- Armor - Head
	[55023]=5, -- Armor - Head
	[41344]=5, -- Armor - Head
	[41350]=5, -- Armor - Head
	[42728]=5, -- Armor - Head
	[43870]=5, -- Armor - Head
	[40673]=5, -- Armor - Head
	[23519]=5, -- Armor - Head
	[23521]=5, -- Armor - Head
	[23516]=5, -- Armor - Head
	[20551]=5, -- Armor - Head
	[12620]=5, -- Armor - Head
	[12636]=5, -- Armor - Head
	[12633]=5, -- Armor - Head
	[7922]=5, -- Armor - Head
	[55031]=5, -- Armor - Head
	[40955]=5, -- Armor - Head
	[40957]=5, -- Armor - Head
	[39084]=5, -- Armor - Head
	[40942]=5, -- Armor - Head
	[23493]=5, -- Armor - Head
	[12612]=5, -- Armor - Head
	[12417]=5, -- Armor - Head
	[12427]=5, -- Armor - Head
	[12410]=5, -- Armor - Head
	[7937]=5, -- Armor - Head
	[7934]=5, -- Armor - Head
	[7931]=5, -- Armor - Head
	[3837]=5, -- Armor - Head
	[7915]=5, -- Armor - Head
	[3836]=5, -- Armor - Head
	[49902]=6, -- Armor - Legs
	[49903]=6, -- Armor - Legs
	[49904]=6, -- Armor - Legs
	[32404]=6, -- Armor - Legs
	[31367]=6, -- Armor - Legs
	[31370]=6, -- Armor - Legs
	[17013]=6, -- Armor - Legs
	[22385]=6, -- Armor - Legs
	[55076]=6, -- Armor - Legs
	[55084]=6, -- Armor - Legs
	[41345]=6, -- Armor - Legs
	[41346]=6, -- Armor - Legs
	[41347]=6, -- Armor - Legs
	[42726]=6, -- Armor - Legs
	[40674]=6, -- Armor - Legs
	[41126]=6, -- Armor - Legs
	[23512]=6, -- Armor - Legs
	[23518]=6, -- Armor - Legs
	[23523]=6, -- Armor - Legs
	[19694]=6, -- Armor - Legs
	[12619]=6, -- Armor - Legs
	[55030]=6, -- Armor - Legs
	[55038]=6, -- Armor - Legs
	[55022]=6, -- Armor - Legs
	[40958]=6, -- Armor - Legs
	[40943]=6, -- Armor - Legs
	[39086]=6, -- Armor - Legs
	[23488]=6, -- Armor - Legs
	[12614]=6, -- Armor - Legs
	[12420]=6, -- Armor - Legs
	[12429]=6, -- Armor - Legs
	[12414]=6, -- Armor - Legs
	[7921]=6, -- Armor - Legs
	[7926]=6, -- Armor - Legs
	[7920]=6, -- Armor - Legs
	[7929]=6, -- Armor - Legs
	[3843]=6, -- Armor - Legs
	[3842]=6, -- Armor - Legs
	[10423]=6, -- Armor - Legs
	[2865]=6, -- Armor - Legs
	[3473]=6, -- Armor - Legs
	[2852]=6, -- Armor - Legs
	[55069]=7, -- Armor - Shield
	[55070]=7, -- Armor - Shield
	[42508]=7, -- Armor - Shield
	[22198]=7, -- Armor - Shield
	[41113]=7, -- Armor - Shield
	[40670]=7, -- Armor - Shield
	[41117]=7, -- Armor - Shield
	[55042]=7, -- Armor - Shield
	[55041]=7, -- Armor - Shield
	[40668]=7, -- Armor - Shield
	[16988]=8, -- Armor - Shoulders
	[55075]=8, -- Armor - Shoulders
	[55083]=8, -- Armor - Shoulders
	[55029]=8, -- Armor - Shoulders
	[55037]=8, -- Armor - Shoulders
	[54876]=8, -- Armor - Shoulders
	[41351]=8, -- Armor - Shoulders
	[42727]=8, -- Armor - Shoulders
	[40675]=8, -- Armor - Shoulders
	[43865]=8, -- Armor - Shoulders
	[33173]=8, -- Armor - Shoulders
	[19691]=8, -- Armor - Shoulders
	[19695]=8, -- Armor - Shoulders
	[12625]=8, -- Armor - Shoulders
	[11605]=8, -- Armor - Shoulders
	[40956]=8, -- Armor - Shoulders
	[40950]=8, -- Armor - Shoulders
	[39083]=8, -- Armor - Shoulders
	[12610]=8, -- Armor - Shoulders
	[12428]=8, -- Armor - Shoulders
	[7932]=8, -- Armor - Shoulders
	[7918]=8, -- Armor - Shoulders
	[7928]=8, -- Armor - Shoulders
	[3841]=8, -- Armor - Shoulders
	[3840]=8, -- Armor - Shoulders
	[7913]=8, -- Armor - Shoulders
	[3481]=8, -- Armor - Shoulders
	[3480]=8, -- Armor - Shoulders
	[55059]=9, -- Armor - Waist
	[55061]=9, -- Armor - Waist
	[55063]=9, -- Armor - Waist
	[45550]=9, -- Armor - Waist
	[45551]=9, -- Armor - Waist
	[45552]=9, -- Armor - Waist
	[43587]=9, -- Armor - Waist
	[32401]=9, -- Armor - Waist
	[30032]=9, -- Armor - Waist
	[30034]=9, -- Armor - Waist
	[16989]=9, -- Armor - Waist
	[55073]=9, -- Armor - Waist
	[55081]=9, -- Armor - Waist
	[41352]=9, -- Armor - Waist
	[42729]=9, -- Armor - Waist
	[43860]=9, -- Armor - Waist
	[40669]=9, -- Armor - Waist
	[23524]=9, -- Armor - Waist
	[23510]=9, -- Armor - Waist
	[22764]=9, -- Armor - Waist
	[22195]=9, -- Armor - Waist
	[22197]=9, -- Armor - Waist
	[19043]=9, -- Armor - Waist
	[19051]=9, -- Armor - Waist
	[55027]=9, -- Armor - Waist
	[55035]=9, -- Armor - Waist
	[54853]=9, -- Armor - Waist
	[40953]=9, -- Armor - Waist
	[39087]=9, -- Armor - Waist
	[23484]=9, -- Armor - Waist
	[12424]=9, -- Armor - Waist
	[12416]=9, -- Armor - Waist
	[12406]=9, -- Armor - Waist
	[2857]=9, -- Armor - Waist
	[2851]=9, -- Armor - Waist
	[47570]=10, -- Armor - Wrists
	[47571]=10, -- Armor - Wrists
	[47572]=10, -- Armor - Wrists
	[47573]=10, -- Armor - Wrists
	[47574]=10, -- Armor - Wrists
	[47575]=10, -- Armor - Wrists
	[32568]=10, -- Armor - Wrists
	[32571]=10, -- Armor - Wrists
	[32403]=10, -- Armor - Wrists
	[23537]=10, -- Armor - Wrists
	[23538]=10, -- Armor - Wrists
	[23539]=10, -- Armor - Wrists
	[22671]=10, -- Armor - Wrists
	[17014]=10, -- Armor - Wrists
	[55071]=10, -- Armor - Wrists
	[55079]=10, -- Armor - Wrists
	[41354]=10, -- Armor - Wrists
	[41355]=10, -- Armor - Wrists
	[42723]=10, -- Armor - Wrists
	[41116]=10, -- Armor - Wrists
	[43864]=10, -- Armor - Wrists
	[23515]=10, -- Armor - Wrists
	[23506]=10, -- Armor - Wrists
	[54850]=10, -- Armor - Wrists
	[55025]=10, -- Armor - Wrists
	[55033]=10, -- Armor - Wrists
	[40954]=10, -- Armor - Wrists
	[41974]=10, -- Armor - Wrists
	[23494]=10, -- Armor - Wrists
	[12425]=10, -- Armor - Wrists
	[12408]=10, -- Armor - Wrists
	[7924]=10, -- Armor - Wrists
	[6040]=10, -- Armor - Wrists
	[3835]=10, -- Armor - Wrists
	[2868]=10, -- Armor - Wrists
	[2854]=10, -- Armor - Wrists
	[2853]=10, -- Armor - Wrists
	[41383]=11, -- Weapon - Main Hand
	[41384]=11, -- Weapon - Main Hand
	[45085]=11, -- Weapon - Main Hand
	[23554]=11, -- Weapon - Main Hand
	[23556]=11, -- Weapon - Main Hand
	[22383]=11, -- Weapon - Main Hand
	[55064]=11, -- Weapon - Main Hand
	[55065]=11, -- Weapon - Main Hand
	[55045]=11, -- Weapon - Main Hand
	[55046]=11, -- Weapon - Main Hand
	[42443]=11, -- Weapon - Main Hand
	[43871]=11, -- Weapon - Main Hand
	[12260]=11, -- Weapon - Main Hand
	[2850]=11, -- Weapon - Main Hand
	[2849]=11, -- Weapon - Main Hand
	[2848]=11, -- Weapon - Main Hand
	[2844]=11, -- Weapon - Main Hand
	[2845]=11, -- Weapon - Main Hand
	[2847]=11, -- Weapon - Main Hand
	[42435]=12, -- Weapon - One Hand
	[23540]=12, -- Weapon - One Hand
	[23542]=12, -- Weapon - One Hand
	[23544]=12, -- Weapon - One Hand
	[23555]=12, -- Weapon - One Hand
	[19168]=12, -- Weapon - One Hand
	[19170]=12, -- Weapon - One Hand
	[19166]=12, -- Weapon - One Hand
	[22384]=12, -- Weapon - One Hand
	[55067]=12, -- Weapon - One Hand
	[55068]=12, -- Weapon - One Hand
	[67602]=12, -- Weapon - One Hand
	[55043]=12, -- Weapon - One Hand
	[55044]=12, -- Weapon - One Hand
	[41185]=12, -- Weapon - One Hand
	[41184]=12, -- Weapon - One Hand
	[41183]=12, -- Weapon - One Hand
	[41182]=12, -- Weapon - One Hand
	[17015]=12, -- Weapon - One Hand
	[17016]=12, -- Weapon - One Hand
	[12783]=12, -- Weapon - One Hand
	[12794]=12, -- Weapon - One Hand
	[12797]=12, -- Weapon - One Hand
	[12798]=12, -- Weapon - One Hand
	[12781]=12, -- Weapon - One Hand
	[12777]=12, -- Weapon - One Hand
	[12774]=12, -- Weapon - One Hand
	[7961]=12, -- Weapon - One Hand
	[7954]=12, -- Weapon - One Hand
	[41243]=12, -- Weapon - One Hand
	[41239]=12, -- Weapon - One Hand
	[41240]=12, -- Weapon - One Hand
	[23505]=12, -- Weapon - One Hand
	[23504]=12, -- Weapon - One Hand
	[23498]=12, -- Weapon - One Hand
	[23497]=12, -- Weapon - One Hand
	[12792]=12, -- Weapon - One Hand
	[7947]=12, -- Weapon - One Hand
	[7946]=12, -- Weapon - One Hand
	[7944]=12, -- Weapon - One Hand
	[7945]=12, -- Weapon - One Hand
	[7943]=12, -- Weapon - One Hand
	[7942]=12, -- Weapon - One Hand
	[7941]=12, -- Weapon - One Hand
	[17704]=12, -- Weapon - One Hand
	[12259]=12, -- Weapon - One Hand
	[3850]=12, -- Weapon - One Hand
	[3849]=12, -- Weapon - One Hand
	[3492]=12, -- Weapon - One Hand
	[5541]=12, -- Weapon - One Hand
	[3490]=12, -- Weapon - One Hand
	[3491]=12, -- Weapon - One Hand
	[5540]=12, -- Weapon - One Hand
	[3848]=12, -- Weapon - One Hand
	[3489]=12, -- Weapon - One Hand
	[33791]=12, -- Weapon - One Hand
	[7166]=12, -- Weapon - One Hand
	[41245]=13, -- Weapon - Thrown
	[29204]=13, -- Weapon - Thrown
	[41241]=13, -- Weapon - Thrown
	[29203]=13, -- Weapon - Thrown
	[29202]=13, -- Weapon - Thrown
	[29201]=13, -- Weapon - Thrown
	[41257]=14, -- Weapon - Two Hand
	[23541]=14, -- Weapon - Two Hand
	[23543]=14, -- Weapon - Two Hand
	[23546]=14, -- Weapon - Two Hand
	[32854]=14, -- Weapon - Two Hand
	[19169]=14, -- Weapon - Two Hand
	[17193]=14, -- Weapon - Two Hand
	[19167]=14, -- Weapon - Two Hand
	[55066]=14, -- Weapon - Two Hand
	[67605]=14, -- Weapon - Two Hand
	[55052]=14, -- Weapon - Two Hand
	[55246]=14, -- Weapon - Two Hand
	[41181]=14, -- Weapon - Two Hand
	[12784]=14, -- Weapon - Two Hand
	[12790]=14, -- Weapon - Two Hand
	[12796]=14, -- Weapon - Two Hand
	[11607]=14, -- Weapon - Two Hand
	[12776]=14, -- Weapon - Two Hand
	[11608]=14, -- Weapon - Two Hand
	[7960]=14, -- Weapon - Two Hand
	[7959]=14, -- Weapon - Two Hand
	[41242]=14, -- Weapon - Two Hand
	[23503]=14, -- Weapon - Two Hand
	[23502]=14, -- Weapon - Two Hand
	[23499]=14, -- Weapon - Two Hand
	[12775]=14, -- Weapon - Two Hand
	[3854]=14, -- Weapon - Two Hand
	[3856]=14, -- Weapon - Two Hand
	[3855]=14, -- Weapon - Two Hand
	[3853]=14, -- Weapon - Two Hand
	[3852]=14, -- Weapon - Two Hand
	[3851]=14, -- Weapon - Two Hand
	[7958]=14, -- Weapon - Two Hand
	[7957]=14, -- Weapon - Two Hand
	[7956]=14, -- Weapon - Two Hand
	[3487]=14, -- Weapon - Two Hand
	[6214]=14, -- Weapon - Two Hand
	[3488]=14, -- Weapon - Two Hand
	[7955]=14, -- Weapon - Two Hand
	[15869]=15, -- Misc Items
	[15870]=15, -- Misc Items
	[15871]=15, -- Misc Items
	[15872]=15, -- Misc Items
	[43854]=15, -- Misc Items
	[43853]=15, -- Misc Items
	[6338]=15, -- Misc Items
	[11128]=15, -- Misc Items
	[11144]=15, -- Misc Items
	[16206]=15, -- Misc Items
	[25843]=15, -- Misc Items
	[41745]=15, -- Misc Items
	[41741]=15, -- Misc Items
	[25844]=15, -- Misc Items
	[25845]=15, -- Misc Items
	[65358]=15, -- Misc Items
	[55053]=15, -- Misc Items
	[3478]=15, -- Misc Items
	[12644]=15, -- Misc Items
	[3486]=15, -- Misc Items
	[3470]=15, -- Misc Items
	[7966]=15, -- Misc Items
	[65365]=15, -- Misc Items
}