-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Shopping - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_shopping.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


local TSM = select(2, ...)
local Destroying = TSM:NewModule("Destroying", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Shopping") -- loads the localization table

local function debug(...)
	TSM:Debug(...)
end

function Destroying:OnEnable()
	TSMAPI:RegisterSidebarFunction("TradeSkillMaster_Shopping", "shoppingDestroying", "Interface\\Icons\\Inv_Gizmo_RocketBoot_Destroyed_02", 
		L["Shopping - Milling/Disenchanting/Prospecting/Transforming"], function(...) Destroying:LoadSidebar(...) end, Destroying.HideSidebar)
	Destroying.auctions = {}
	Destroying.label = ""
end

local inks = {
	[37101] = {
		name = GetItemInfo(37101) or L["Ivory Ink"],
		herbs = {
			{itemID = 2449, pigmentPerMill = 3},
			{itemID = 2447, pigmentPerMill = 3},
			{itemID = 765, pigmentPerMill = 2.5},
		},
		pigment = 39151,
		pigmentPerInk = 1,
	},
	[39469] = {
		name = GetItemInfo(39469) or L["Moonglow Ink"],
		herbs = {
			{itemID = 2449, pigmentPerMill = 3},
			{itemID = 2447, pigmentPerMill = 3},
			{itemID = 765, pigmentPerMill = 2.5},
		},
		pigment = 39151,
		pigmentPerInk = 2,
	},
	[39774] = {
		name = GetItemInfo(39774) or L["Midnight Ink"],
		herbs = {
			{itemID = 785, pigmentPerMill = 2.5},
			{itemID = 2450, pigmentPerMill = 2.5},
			{itemID = 2452, pigmentPerMill = 2.5},
			{itemID = 2453, pigmentPerMill = 3},
			{itemID = 3820, pigmentPerMill = 3},
		},
		pigment = 39334,
		pigmentPerInk = 2,
	},
	[43116] = {
		name = GetItemInfo(43116) or L["Lion's Ink"],
		herbs = {
			{itemID = 3355, pigmentPerMill = 2.5},
			{itemID = 3369, pigmentPerMill = 2.5},
			{itemID = 3356, pigmentPerMill = 3},
			{itemID = 3357, pigmentPerMill = 3},
		},
		pigment = 39338,
		pigmentPerInk = 2,
	},
	[43118] = {
		name = GetItemInfo(43118) or L["Jadefire Ink"],
		herbs = {
			{itemID = 3819, pigmentPerMill = 3},
			{itemID = 3818, pigmentPerMill = 2.5},
			{itemID = 3821, pigmentPerMill = 2.5},
			{itemID = 3358, pigmentPerMill = 3},
		},
		pigment = 39339,
		pigmentPerInk = 2,
	},
	[43120] = {
		name = GetItemInfo(43120) or L["Celestial Ink"],
		herbs = {
			{itemID = 4625, pigmentPerMill = 2.5},
			{itemID = 8831, pigmentPerMill = 2.5},
			{itemID = 8836, pigmentPerMill = 2.5},
			{itemID = 8838, pigmentPerMill = 2.5},
			{itemID = 8839, pigmentPerMill = 3},
			{itemID = 8845, pigmentPerMill = 3},
			{itemID = 8846, pigmentPerMill = 3},
		},
		pigment = 39340,
		pigmentPerInk = 2,
	},
	[43122] = {
		name = GetItemInfo(43122) or L["Shimmering Ink"],
		herbs = {
			{itemID = 13464, pigmentPerMill = 2.5},
			{itemID = 13463, pigmentPerMill = 2.5},
			{itemID = 13465, pigmentPerMill = 3},
			{itemID = 13466, pigmentPerMill = 3},
			{itemID = 13467, pigmentPerMill = 3},
		},
		pigment = 39341,
		pigmentPerInk = 2,
	},
	[43124] = {
		name = GetItemInfo(43124) or L["Ethereal Ink"],
		herbs = {
			{itemID = 22786, pigmentPerMill = 2.5},
			{itemID = 22785, pigmentPerMill = 2.5},
			{itemID = 22789, pigmentPerMill = 2.5},
			{itemID = 22787, pigmentPerMill = 2.5}, -- Ragveil
			{itemID = 22790, pigmentPerMill = 3},
			{itemID = 22793, pigmentPerMill = 3},
			{itemID = 22791, pigmentPerMill = 3},
			{itemID = 22792, pigmentPerMill = 3},
		},
		pigment = 39342,
		pigmentPerInk = 2,
	},
	[43126] = {
		name = GetItemInfo(43126) or L["Ink of the Sea"],
		herbs = {
			{itemID = 37921, pigmentPerMill = 2.5},
			{itemID = 36901, pigmentPerMill = 2.5},
			{itemID = 36907, pigmentPerMill = 2.5},
			{itemID = 36904, pigmentPerMill = 2.5},
			{itemID = 39970, pigmentPerMill = 2.5}, -- Fire Leaf, not sure about the pigment in these two
			{itemID = 39969, pigmentPerMill = 2.5}, -- Fire Seed
			{itemID = 36903, pigmentPerMill = 3},
			{itemID = 36906, pigmentPerMill = 3},
			{itemID = 36905, pigmentPerMill = 3},
		},
		pigment = 39343,
		pigmentPerInk = 2,
	},
	[61978] = {
		name = GetItemInfo(61978) or L["Blackfallow Ink"],
		herbs = {
			{itemID = 52983, pigmentPerMill = 2.5},
			{itemID = 52984, pigmentPerMill = 2.5},
			{itemID = 52985, pigmentPerMill = 2.5},
			{itemID = 52986, pigmentPerMill = 2.5},
			{itemID = 52987, pigmentPerMill = 3},
			{itemID = 52988, pigmentPerMill = 3},
		},
		pigment = 61979,
		pigmentPerInk = 2,
	},
	[61981] = {
		name = GetItemInfo(61981) or L["Inferno Ink"],
		herbs = {
			{itemID = 52983, pigmentPerMill = 0.5},
			{itemID = 52984, pigmentPerMill = 0.5},
			{itemID = 52985, pigmentPerMill = 0.5},
			{itemID = 52986, pigmentPerMill = 0.5},
			{itemID = 52987, pigmentPerMill = 0.8},
			{itemID = 52988, pigmentPerMill = 0.8},
		},
		pigment = 61980,
		pigmentPerInk = 2,
	},
}

local gems = {
	["BC - Green Quality"] = {
		gems = {23117, 23077, 23079, 21929, 23112, 23107},
		ore = {
			{itemID = 23424, gemPerProspect = 1.08},
			{itemID = 23425, gemPerProspect = 1.08},
		},
	},
	["BC - Blue Quality"] = {
		gems = {23440, 23436, 23441, 23439, 23438, 23437},
		ore = {
			{itemID = 23424, gemPerProspect = 0.072},
			{itemID = 23425, gemPerProspect = 0.24},
		},
	},
	["Wrath - Green Quality"] = {
		gems = {36917, 36923, 36932, 36929, 36926, 36920},
		ore = {
			{itemID = 36909, gemPerProspect = 1.44},
			{itemID = 36912, gemPerProspect = 1.08},
			{itemID = 36910, gemPerProspect = 1.44},
		},
	},
	["Wrath - Blue Quality"] = {
		gems = {36921, 36933, 36930, 36918, 36924, 36927},
		ore = {
			{itemID = 36909, gemPerProspect = 0.072},
			{itemID = 36912, gemPerProspect = 0.24},
			{itemID = 36910, gemPerProspect = 0.24},
		},
	},
	["Wrath - Epic Quality"] = {
		gems = {36931, 36919, 36928, 36934, 36922, 36925},
		ore = {
			{itemID = 36910, gemPerProspect = 0.30},
		},
	},
	["Cata - Green Quality"] = {
		gems = {52182, 52180, 52178, 52179, 52177, 52181},
		ore = {
			{itemID = 53038, gemPerProspect = 1.488},
			{itemID = 52185, gemPerProspect = 1.116},
			{itemID = 52183, gemPerProspect = 1.02},
		},
	},
	["Cata - Blue Quality"] = {
		gems = {52192, 52193, 52190, 52195, 52194, 52191},
		ore = {
			{itemID = 53038, gemPerProspect = 0.072},
			{itemID = 52185, gemPerProspect = 0.288},
			{itemID = 52183, gemPerProspect = 0.4568},
		},
	},
}

local deMats  = {
	[10940] = {
		name = GetItemInfo(10940) or L["Strange Dust"],
		matType = "dust",
		minRequiredLevel = 0,
		maxRequiredLevel = 20,
		itemTypes = {
			["Armor"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 5,
								maxItemLevel = 15,
								amountOfMats = 1.2
							},
							{
								minItemLevel = 16,
								maxItemLevel = 20,
								amountOfMats = 1.875
							},
							{
								minItemLevel = 21,
								maxItemLevel = 25,
								amountOfMats = 3.75
							},
						},
					},
				},
			},
			["Weapon"] = {
				itemRarity = {
					[2] = {
						levelRanges = {				
							{
								minItemLevel = 5,
								maxItemLevel = 15,
								amountOfMats = 0.3
							},
							{
								minItemLevel = 16,
								maxItemLevel = 20,
								amountOfMats = 0.5
							},
							{
								minItemLevel = 21,
								maxItemLevel = 25,
								amountOfMats = 0.75
							},
						},
					},
				},
			},
		},
	},
	[11083] = {
		name = GetItemInfo(11083) or L["Soul Dust"],
		matType = "dust",
		minRequiredLevel = 21,
		maxRequiredLevel = 30,
		itemTypes = {
			["Armor"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 26,
								maxItemLevel = 30,
								amountOfMats = 1.125
							},
							{
								minItemLevel = 31,
								maxItemLevel = 35,
								amountOfMats = 2.625
							},
						},
					},
				},
			},
			["Weapon"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 26,
								maxItemLevel = 30,
								amountOfMats = 0.3
							},
							{
								minItemLevel = 31,
								maxItemLevel = 35,
								amountOfMats = 0.7
							},
						},
					},
				},
			},
		},
	},
	[11137] = {
		name = GetItemInfo(11137) or L["Vision Dust"],
		matType = "dust",
		minRequiredLevel = 31,
		maxRequiredLevel = 40,
		itemTypes = {
			["Armor"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 36,
								maxItemLevel = 40,
								amountOfMats = 1.125
							},
							{
								minItemLevel = 41,
								maxItemLevel = 45,
								amountOfMats = 2.625
							},
						},
					},
				},
			},
			["Weapon"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 36,
								maxItemLevel = 40,
								amountOfMats = 0.3
							},
							{
								minItemLevel = 41,
								maxItemLevel = 45,
								amountOfMats = 0.7
							},
						},
					},
				},
			},
		},
	},
	[11176] = {
		name = GetItemInfo(11176) or L["Dream Dust"],
		matType = "dust",
		minRequiredLevel = 41,
		maxRequiredLevel = 50,
		itemTypes = {
			["Armor"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 46,
								maxItemLevel = 50,
								amountOfMats = 1.125
							},
							{
								minItemLevel = 51,
								maxItemLevel = 55,
								amountOfMats = 2.625
							},
						},
					},
				},
			},
			["Weapon"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 46,
								maxItemLevel = 50,
								amountOfMats = 0.3
							},
							{
								minItemLevel = 51,
								maxItemLevel = 55,
								amountOfMats = 0.77
							},
						},
					},
				},
			},
		},
	},
	[16204] = {
		name = GetItemInfo(16204) or L["Illusion Dust"],
		matType = "dust",
		minRequiredLevel = 51,
		maxRequiredLevel = 60,
		itemTypes = {
			["Armor"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 56,
								maxItemLevel = 60,
								amountOfMats = 1.125
							},
							{
								minItemLevel = 61,
								maxItemLevel = 65,
								amountOfMats = 2.625
							},
						},
					},
				},
			},
			["Weapon"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 56,
								maxItemLevel = 60,
								amountOfMats = 0.33 
							},
							{
								minItemLevel = 61,
								maxItemLevel = 65,
								amountOfMats = 0.77
							},
						},
					},
				},
			},
		},
	},
	[22445] = {
		name = GetItemInfo(22445) or L["Arcane Dust"],
		matType = "dust",
		minRequiredLevel = 57,
		maxRequiredLevel = 70,
		itemTypes = {
			["Armor"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 79,
								maxItemLevel = 79,
								amountOfMats = 1.125
							},
							{
								minItemLevel = 80,
								maxItemLevel = 99,
								amountOfMats = 1.875
							},
							{
								minItemLevel = 100,
								maxItemLevel = 120,
								amountOfMats = 2.625
							},
						},
					},
				},
			},
			["Weapon"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 80,
								maxItemLevel = 99,
								amountOfMats = 0.55
							},
							{
								minItemLevel = 100,
								maxItemLevel = 120,
								amountOfMats = 0.77
							},
						},
					},
				},
			},
		},
	},
	[34054] = {
		name = GetItemInfo(34054) or L["Infinite Dust"],
		matType = "dust",
		minRequiredLevel = 67,
		maxRequiredLevel = 80,
		itemTypes = {
			["Armor"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 130,
								maxItemLevel = 151,
								amountOfMats = 1.875
							},
							{
								minItemLevel = 152,
								maxItemLevel = 200,
								amountOfMats = 4.125
							},
						},
					},
				},
			},
			["Weapon"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 130,
								maxItemLevel = 151,
								amountOfMats = 0.55
							},
							{
								minItemLevel = 152,
								maxItemLevel = 200,
								amountOfMats = 1.21
							},
						},
					},
				},
			},
		},
	},
	[52555] = {
		name = GetItemInfo(52555) or L["Hypnotic Dust"],
		matType = "dust",
		minRequiredLevel = 77,
		maxRequiredLevel = 85,
		itemTypes = {
			["Armor"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 272,
								maxItemLevel = 275,
								amountOfMats = 1.125
							},
							{
								minItemLevel = 276,
								maxItemLevel = 290,
								amountOfMats = 1.5
							},
							{
								minItemLevel = 291,
								maxItemLevel = 305,
								amountOfMats = 1.875
							},
							{
								minItemLevel = 306,
								maxItemLevel = 315,
								amountOfMats = 2.25
							},
							{
								minItemLevel = 316,
								maxItemLevel = 325,
								amountOfMats = 2.625
							},
							{
								minItemLevel = 326,
								maxItemLevel = 400,
								amountOfMats = 3
							},
						},
					},
				},
			},
			["Weapon"] = {
				itemRarity = {
					[2] = {
						levelRanges = {
							{
								minItemLevel = 272,
								maxItemLevel = 275,
								amountOfMats = 0.375
							},
							{
								minItemLevel = 276,
								maxItemLevel = 290,
								amountOfMats = 0.5
							},
							{
								minItemLevel = 291,
								maxItemLevel = 305,
								amountOfMats = 0.625
							},
							{
								minItemLevel = 306,
								maxItemLevel = 315,
								amountOfMats = 0.75
							},
							{
								minItemLevel = 316,
								maxItemLevel = 325,
								amountOfMats = 0.875
							},
							{
								minItemLevel = 326,
								maxItemLevel = 400,
								amountOfMats = 1
							},
						},
					},
				},
			},
		},
	},
	[52721] = {
 		name = GetItemInfo(52721),
 		matType = "shard",
 		minRequiredLevel = 81,
 		maxRequiredLevel = 85,
 		itemTypes = {
 			["Armor"] = {
 				itemRarity = {
 					[3] = {
 						levelRanges = {
 							{
 								minItemLevel = 318,
 								maxItemLevel = 346,
 								amountOfMats = 1
 							},
 						},
 					},
 				},
 			},
 			["Weapon"] = {
 				itemRarity = {
 					[3] = {
 						levelRanges = {
 							{
 								minItemLevel = 318,
 								maxItemLevel = 346,
 								amountOfMats = 1
 							},
 						},
 					},
 				},
 			},
 		},
 	},
}

local ignoreDE = {
 	[20408] = true,
 	[20406] = true,
 	[20407] = true,
}

local transformations = {
	[52719] = {
		name = GetItemInfo(52719) or L["Greater Celestial Essence"],
		otherItemID = 52718,
		numNeeded = 3,
	},
	[52718] = {
		name = GetItemInfo(52718) or L["Lesser Celestial Essence"],
		otherItemID = 52719,
		numNeeded = 1/3,
	},
	[52721] = {
		name = GetItemInfo(52721) or L["Heavenly Shard"],
		otherItemID = 52720,
		numNeeded = 3,
	},
	[34052] = {
		name = GetItemInfo(34052) or L["Dream Shard"],
		otherItemID = 34053,
		numNeeded = 3,
	},
	[34055] = {
		name = GetItemInfo(34055) or L["Greater Cosmic Essence"],
		otherItemID = 34056,
		numNeeded = 3,
	},
	[34056] = {
		name = GetItemInfo(34056) or L["Lesser Cosmic Essence"],
		otherItemID = 34055,
		numNeeded = 1/3,
	},
}

function Destroying:GetDisenchantQuantity(itemID, matID)
	local mat = deMats[matID]
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType = GetItemInfo(itemID)
	
	if not (deMats[matID] and deMats[matID].itemTypes[itemType] and deMats[matID].itemTypes[itemType].itemRarity[itemRarity]) then
		return 0
	end
	
	if ignoreDE[itemID] then
 		return 0
 	end
	
	for _, data in pairs(deMats[matID].itemTypes[itemType].itemRarity[itemRarity].levelRanges) do
		if itemLevel >= data.minItemLevel and itemLevel <= data.maxItemLevel then
			return data.amountOfMats
		end
	end
	
	return 0
end

function Destroying:GetDestroyableInfo(itemID)
	if inks[itemID] then return "mill" end
	if deMats[itemID] then return "disenchant" end
	if transformations[itemID] then return "transform" end
	
	for key, data in pairs(gems) do
		for _, gem in pairs(data.gems) do
			if gem == itemID then
				return "prospect", key
			end
		end
	end
end

function Destroying:LoadSidebar(parentFrame)
	Destroying.selectedItem = nil
	wipe(Destroying.auctions)
	Destroying.currentItem = {}
	
	if not Destroying.frame then
		local maxWidth = parentFrame:GetWidth() - 16
	
		local container = CreateFrame("Frame", nil, parentFrame)
		container:SetAllPoints(parentFrame)
		container:Raise()
		
		container.title = TSM.GUI:CreateLabel(container, L["Shopping - Milling/Disenchanting/Prospecting/Transforming"], GameFontHighlight, -2, "OUTLINE", maxWidth, {"TOP", 0, -15})
		TSM.GUI:AddHorizontalBar(container, -30)
		
		local function OnIconClick(self)
			local ddList = {}
			local tooltip
			if self.mode == "Milling" then
				tooltip = L["Select an ink which you would like to buy for (through milling herbs)."]
				Destroying.label = "Ink"
				for itemID, data in pairs(inks) do
					local name = TSM:GetItemName(itemID) or data.name
					if name then
						ddList[itemID] = name
					end
				end
			elseif self.mode == "Disenchanting" then
				tooltip = L["Select an enchanting mat which you would like to buy for (through disenchanting items)."]
				Destroying.label = "Enchanting Mat"
				for itemID, data in pairs(deMats) do
					local name = TSM:GetItemName(itemID) or data.name
					if name then
						ddList[itemID] = name
					end
				end
			elseif self.mode == "Prospecting" then
				tooltip = L["Select a raw gem which you would like to buy for (through prospecting ore)."]
				Destroying.label = "Raw Gem"
				for name in pairs(gems) do
					ddList[name] = L[name]
				end
			elseif self.mode == "Transforming" then
				tooltip = L["Select a target item for the transformation."]
				Destroying.label = "Item"
				for itemID, data in pairs(transformations) do
					local name = TSM:GetItemName(itemID) or data.name
					if name then
						ddList[itemID] = name
					end
				end
			end
			
			container.prospectIcon:UnlockHighlight()
			container.deIcon:UnlockHighlight()
			container.millIcon:UnlockHighlight()
			container.transformIcon:UnlockHighlight()
			self:LockHighlight()
			Destroying.mode = self.mode
			Destroying.frame.itemDropdown:SetList(ddList)
			Destroying.frame.itemDropdown:SetValue(0)
			Destroying.frame:EnableAll()
			Destroying.frame.goButton:Disable()
		end
		
		function container:DisableAll()
			Destroying.frame.itemDropdown:SetDisabled(true)
			Destroying.frame.maxPrice:SetDisabled(true)
			Destroying.frame.maxQuantity:SetDisabled(true)
			Destroying.frame.goButton:Disable()
		end
		
		function container:EnableAll()
			Destroying.frame.itemDropdown:SetDisabled(false)
			Destroying.frame.maxPrice:SetDisabled(false)
			Destroying.frame.maxQuantity:SetDisabled(false)
			Destroying.frame.goButton:Enable()
		end
		
		container.modeLabel = TSM.GUI:CreateLabel(container, L["Mode:"], GameFontNormal, 0, nil, 80, {"TOPLEFT", 10, -55}, "LEFT", "CENTER")
		local icon = TSM.GUI:CreateIcon(container, "Interface\\Icons\\Ability_Miling", 32, {"TOPLEFT", 90, -45}, L["Shop for items to Mill"])
		icon:SetScript("OnClick", OnIconClick)
		icon.mode = "Milling"
		container.millIcon = icon
		local icon = TSM.GUI:CreateIcon(container, "Interface\\Icons\\Inv_Enchant_Disenchant", 32, {"TOPLEFT", 150, -45}, L["Shop for items to Disenchant"])
		icon:SetScript("OnClick", OnIconClick)
		icon.mode = "Disenchanting"
		container.deIcon = icon
		local icon = TSM.GUI:CreateIcon(container, "Interface\\Icons\\inv_misc_gem_bloodgem_01", 32, {"TOPLEFT", 210, -45}, L["Shop for items to Prospect"])
		icon:SetScript("OnClick", OnIconClick)
		icon.mode = "Prospecting"
		container.prospectIcon = icon
		local icon = TSM.GUI:CreateIcon(container, "Interface\\Icons\\Spell_Shaman_SpectralTransformation", 32, {"TOPLEFT", 270, -45}, L["Shop for items to Transform (essences to split/combine for example)."])
		icon:SetScript("OnClick", OnIconClick)
		icon.mode = "Transforming"
		container.transformIcon = icon
		
		TSM.GUI:AddHorizontalBar(container, -180)
		
		local dd = TSM.GUI:CreateDropdown(container, L["Buy for:"], 250, nil, {"TOPLEFT", 10, -85}, "")
		dd:SetCallback("OnValueChanged", function(_,_,key)
				if key ~= 0 then
					if not Destroying.automaticMode then
						Destroying.frame.goButton:Enable()
					end
					Destroying.selectedItem = key
				end
			end)
		container.itemDropdown = dd
		
		local btn = TSM.GUI:CreateButton(L["GO"], container, "TSMShoppingDestroyingStartButton", "UIPanelButtonTemplate", -1, nil, 25, {"TOPLEFT", 271, -105}, {"TOPRIGHT", -8, -105}, L["Start buying!"])
		btn:SetScript("OnClick", function(self)
				wipe(Destroying.auctions)
				Destroying.maxPrice = Destroying.selectedMaxPrice
				Destroying.maxQuantity = Destroying.selectedMaxQuantity
				Destroying.skipCost = nil
				Destroying.totalSpent = 0
				Destroying.numItems = 0
				Destroying.frame:DisableAll()
				Destroying.frame.noAuctionsLabel:Hide()
				Destroying.frame.buyFrame:Hide()
				Destroying.frame.buyFrame:DisableButtons()
				Destroying.frame.buyFrame.infoLabel:SetText(format(L["Total Spent this Session: %s"..Destroying.label.."s Bought this Session: %sAverage Cost Per "..Destroying.label.." this session: %s"], TSM:FormatTextMoney(Destroying.totalSpent).."\n\n", Destroying.numItems.."\n\n", "---"))
				Destroying.runDelay.totalDelay = 0
				debug("s2", Destroying.selectedMaxPrice, Destroying.selectedMaxQuantity)
				Destroying:RunScan(Destroying.selectedItem)
			end)
		container.goButton = btn
		
		local eb = TSM.GUI:CreateEditBox(container, L["Max Price (optional):"], maxWidth/2, {"TOPLEFT", 8, -135}, L["The most you want to pay for something. \n\nMust be entered in the form of \"#g#s#c\". For example \"5g24s98c\" would be 5 gold 24 silver 98 copper."])
		eb:SetCallback("OnEnterPressed", function(self,_,value)
				value = value:trim()
				if value ~= "" then
					local money = TSM:UnformatTextMoney(value)
					if money then
						Destroying.selectedMaxPrice = money
						self:SetText(TSM:FormatTextMoney(money))
					else
						Destroying.selectedMaxPrice = nil
						self:SetText(L["<Invalid! See Tooltip>"])
					end
				else
					Destroying.selectedMaxPrice = nil
					self:SetText("")
				end
				self:ClearFocus()
			end)
		container.maxPrice = eb
		
		local eb = TSM.GUI:CreateEditBox(container, L["Quantity (optional)"], maxWidth/2, {"TOPLEFT", 8+(maxWidth/2), -135}, L["How many you want to buy."])
		eb:SetCallback("OnEnterPressed", function(self,_,value)
				value = value:trim()
				if tonumber(value) then
					Destroying.selectedMaxQuantity = tonumber(value)
					self:SetText(value)
				elseif value == "" then
					Destroying.selectedMaxQuantity = nil
					self:SetText("")
				else
					Destroying.selectedMaxQuantity = nil
					self:SetText(L["<Invalid Number>"])
				end
				self:ClearFocus()
			end)
		container.maxQuantity = eb
		
		container.automaticLabel = TSM.GUI:CreateLabel(container, L["Manual controls disabled when Shopping in automatic mode.\n\nClick on the \"Exit Automatic Mode\" button to enable manual controls."], GameFontNormal, 0, nil, maxWidth, {"TOP", 0, -60})
		container.automaticLabel:Hide()
		
		
		local frame = CreateFrame("Frame", nil, container)
		frame:SetPoint("TOPLEFT", 0, -190)
		frame:SetPoint("BOTTOMRIGHT")
		frame:Raise()
		frame:Hide()
		frame.EnableButtons = function(self)
			self.buyButton:Enable()
			self.skipButton:Enable()
		end
		frame.DisableButtons = function(self)
			self.buyButton:Disable()
			self.skipButton:Disable()
		end
		
		local label = TSM.GUI:CreateLabel(frame, "*", GameFontHighlight, 0, nil, maxWidth, {"TOP", 0, 0}, "CENTER")
		frame.buyLabel = label
		
		local btn = TSM.GUI:CreateButton(L["BUY"], frame, "TSMShoppingDestroyingBuyButton", "UIPanelButtonTemplate", 8, nil, 40, {"TOPLEFT", 250, -20}, {"TOPRIGHT", -10, -20}, L["Buy the next cheapest auction."])
		btn:SetScript("OnClick", Destroying.BuyItem)
		frame.buyButton = btn
		
		local btn = TSM.GUI:CreateButton(L["SKIP"], frame, "TSMShoppingDestroyingSkipButton", "UIPanelButtonTemplate", -1, nil, 25, {"TOPLEFT", 250, -65}, {"TOPRIGHT", -10, -65}, L["Skip this auction."])
		btn:SetScript("OnClick", Destroying.SkipItem)
		frame.skipButton = btn
		
		local label = TSM.GUI:CreateLabel(frame, "*", GameFontHighlight, 2, nil, maxWidth, {"TOPLEFT", 10, -25}, "LEFT")
		frame.currentLabel = label
		
		TSM.GUI:AddHorizontalBar(frame, -100)
		
		local label = TSM.GUI:CreateLabel(frame, format(L["Total Spent this Session: %sAverage Cost Per "..Destroying.label.." this session: %s"], TSM:FormatTextMoney(0).."\n\n", TSM:FormatTextMoney(0)), GameFontHighlight, 0, nil, maxWidth, {"TOP", 0, -120}, "LEFT")
		frame.infoLabel = label
		
		container.buyFrame = frame
		
		local label = TSM.GUI:CreateLabel(container, "*", GameFontHighlight, 0, nil, maxWidth, {"CENTER"}, "CENTER")
		label:Hide()
		container.noAuctionsLabel = label
		
		Destroying.frame = container
	end
	
	Destroying.frame:Show()
	if Destroying.mode then
		Destroying.frame:EnableAll()
	else
		Destroying.frame:DisableAll()
	end
	Destroying.frame.goButton:Disable()
end

function Destroying:HideSidebar()
	wipe(Destroying.auctions)
	wipe(Destroying.currentItem)
	Destroying.frame.buyFrame:Hide()
	Destroying.frame.itemDropdown:SetValue(0)
	Destroying.frame.maxQuantity:SetText("")
	Destroying.frame.maxQuantity:Fire("OnEnterPressed", "")
	Destroying.frame.maxPrice:SetText("")
	Destroying.frame.maxPrice:Fire("OnEnterPressed", "")
	Destroying.frame:Hide()
end

function Destroying:GetData(itemID, record)
	if Destroying.mode == "Milling" then
		local herbConversion = {}
		for _, herbData in pairs(inks[Destroying.selectedItem].herbs) do
			herbConversion[herbData.itemID] = 5*inks[Destroying.selectedItem].pigmentPerInk/herbData.pigmentPerMill
		end
		
		if itemID == Destroying.selectedItem then
			return record.buyout, record.quantity
		elseif itemID == inks[Destroying.selectedItem].pigment then
			return record.buyout*inks[Destroying.selectedItem].pigmentPerInk, record.quantity/inks[Destroying.selectedItem].pigmentPerInk
		elseif herbConversion[itemID] then
			if record.quantity%5 == 0 or not TSM.db.profile.fullStacksOnly then
				return record.buyout*herbConversion[itemID], record.quantity/herbConversion[itemID], TSM.db.profile.fullStacksOnly
			end
		elseif TSM.db.profile.tradeInks then
			local herbConversion = {}
			for _, herbData in pairs(inks[61978].herbs) do
				herbConversion[herbData.itemID] = 5*inks[61978].pigmentPerInk/herbData.pigmentPerMill
			end
			
			if itemID == 61978 then
				return record.buyout, record.quantity
			elseif itemID == inks[61978].pigment then
				return record.buyout*inks[61978].pigmentPerInk, record.quantity/inks[61978].pigmentPerInk
			elseif herbConversion[itemID] then
				return record.buyout*herbConversion[itemID], record.quantity/herbConversion[itemID], TSM.db.profile.fullStacksOnly
			end
		end
	elseif Destroying.mode == "Prospecting" then
		for _, sID in pairs(gems[Destroying.selectedItem].gems) do
			if sID == itemID then
				return record.buyout, record.quantity
			end
		end
		
		local gemConversion = {}
		for _, gemData in pairs(gems[Destroying.selectedItem].ore) do
			gemConversion[gemData.itemID] = 5/gemData.gemPerProspect
		end
		
		if gemConversion[itemID] then
			if record.quantity%5 == 0 or not TSM.db.profile.fullStacksOnly then
				return record.buyout*gemConversion[itemID], record.quantity/gemConversion[itemID], TSM.db.profile.fullStacksOnly
			end
		end
	elseif Destroying.mode == "Disenchanting" then
		if itemID == Destroying.selectedItem then
			return record.buyout, record.quantity
		end
		
		local num = Destroying:GetDisenchantQuantity(itemID, Destroying.selectedItem)
		return TSMAPI:SafeDivide(record.buyout, num), num
	elseif Destroying.mode == "Transforming" then
		if itemID == Destroying.selectedItem then
			return record.buyout, record.quantity
		end
		
		for _, data in pairs(transformations) do
			if data.otherItemID == itemID then
				return record.buyout*data.numNeeded, 1/data.numNeeded
			end
		end
	end
end

local testDelay = CreateFrame("Frame")
testDelay.totalDelay = 0
testDelay.timeLeft = 0
testDelay:Hide()
testDelay:SetScript("OnUpdate", function(self, elapsed)
		self.totalDelay = self.totalDelay + elapsed
		self.timeLeft = self.timeLeft - elapsed
		if self.timeLeft <= 0 or self.totalDelay >= 5 then
			Destroying:RunScan(self.item)
			self:Hide()
		end
	end)
Destroying.runDelay = testDelay

function Destroying:RunScan(item)
	debug("s3", item, Destroying.mode)
	item = item or Destroying.selectedItem
	local queue = {}
	if Destroying.mode == "Milling" then
		for sID, data in pairs(inks) do
			if sID == item then
				-- add the ink to the queue
				if not TSM.db.profile.herbsOreOnly then
					local name = TSM:GetItemName(sID) or data.name
					if name and not TSM.db.profile.herbsOreOnly then
						tinsert(queue, {itemID=sID, name=name})
					else
						Destroying.runDelay.timeLeft = 0.1
						Destroying.runDelay.item = item
						Destroying.runDelay:Show()
						return
					end
				end
				
				-- add the pigment to the queue
				if not TSM.db.profile.herbsOreOnly then
					name = TSM:GetItemName(data.pigment)
					if name then
						tinsert(queue, {itemID=data.pigment, name=name})
					else
						Destroying.runDelay.timeLeft = 0.1
						Destroying.runDelay.item = item
						Destroying.runDelay:Show()
						return
					end
				end
				
				-- add all the herbs to the queue
				for _, hData in pairs(data.herbs) do
					local name = TSM:GetItemName(hData.itemID)
					if name then
						tinsert(queue, {itemID=hData.itemID, name=name})
					else
						Destroying.runDelay.timeLeft = 0.1
						Destroying.runDelay.item = item
						Destroying.runDelay:Show()
						return
					end
				end
				
				-- add blackfallow for trade-ins
				if TSM.db.profile.tradeInks and sID ~= 61978 and sID ~= 61981 then
					local sID = 61978
					local data = inks[61978]
					-- add the ink to the queue
					if not TSM.db.profile.herbsOreOnly then
						local name = TSM:GetItemName(sID) or data.name
						if name and not TSM.db.profile.herbsOreOnly then
							tinsert(queue, {itemID=sID, name=name})
						else
							Destroying.runDelay.timeLeft = 0.1
							Destroying.runDelay.item = item
							Destroying.runDelay:Show()
							return
						end
					end
					
					-- add the pigment to the queue
					if not TSM.db.profile.herbsOreOnly then
						name = TSM:GetItemName(data.pigment)
						if name then
							tinsert(queue, {itemID=data.pigment, name=name})
						else
							Destroying.runDelay.timeLeft = 0.1
							Destroying.runDelay.item = item
							Destroying.runDelay:Show()
							return
						end
					end
					
					-- add all the herbs to the queue
					for _, hData in pairs(data.herbs) do
						local name = TSM:GetItemName(hData.itemID)
						if name then
							tinsert(queue, {itemID=hData.itemID, name=name})
						else
							Destroying.runDelay.timeLeft = 0.1
							Destroying.runDelay.item = item
							Destroying.runDelay:Show()
							return
						end
					end
				end
				break
			end
		end
	elseif Destroying.mode == "Prospecting" then
		for group, data in pairs(gems) do
			debug("e", group, item)
			if group == item then
				-- add all the raw gems to the queue
				if not TSM.db.profile.herbsOreOnly then
					for _, itemID in pairs(data.gems) do
						local name = TSM:GetItemName(itemID)
						if name and (itemID == Destroying.automaticMode or not Destroying.automaticMode) then
							tinsert(queue, {itemID=itemID, name=name})
						elseif itemID == Destroying.automaticMode or not Destroying.automaticMode then
							debug("DELAY", itemID)
							Destroying.runDelay.timeLeft = 0.1
							Destroying.runDelay.item = item
							Destroying.runDelay:Show()
							return
						end
					end
				end
				
				-- add all the ore to the queue
				for _, gData in pairs(data.ore) do
					local name = TSM:GetItemName(gData.itemID)
					if name then
						tinsert(queue, {itemID=gData.itemID, name=name})
					else
						debug("DELAY", gData.itemID)
						Destroying.runDelay.timeLeft = 0.1
						Destroying.runDelay.item = item
						Destroying.runDelay:Show()
						return
					end
				end
				debug("break")
				break
			end
		end
	elseif Destroying.mode == "Disenchanting" then
		debug(item, deMats[item].minRequiredLevel, deMats[item].maxRequiredLevel)
		local name = TSM:GetItemName(item) or deMats[item].name
		if name then
			tinsert(queue, {itemID=item, name=name})
		else
			Destroying.runDelay.timeLeft = 0.1
			Destroying.runDelay.item = item
			Destroying.runDelay:Show()
			return
		end
		tinsert(queue, {minLevel=deMats[item].minRequiredLevel, maxLevel=deMats[item].maxRequiredLevel, classIndex=1, quality=2})
		tinsert(queue, {minLevel=deMats[item].minRequiredLevel, maxLevel=deMats[item].maxRequiredLevel, classIndex=2, quality=2})
	elseif Destroying.mode == "Transforming" then
		debug(item, transformations[item])
		local name = TSM:GetItemName(item) or transformations[item].name
		if name then
			tinsert(queue, {itemID=item, name=name})
		else
			Destroying.runDelay.timeLeft = 0.1
			Destroying.runDelay.item = item
			Destroying.runDelay:Show()
			return
		end
		
		local otherItemID = transformations[item].otherItemID
		local name = TSM:GetItemName(otherItemID) or (transformations[otherItemID] and transformations[otherItemID].name)
		if name then
			tinsert(queue, {itemID=otherItemID, name=name})
		else
			debug("DELAY", gData.itemID)
			Destroying.runDelay.timeLeft = 0.1
			Destroying.runDelay.item = item
			Destroying.runDelay:Show()
			return
		end
	end
	
	debug("start scan", #queue)
	TSM.Scan:StartScan(queue, "Destroying")
end

function Destroying:Process(scanData)
	local selectedItem = Destroying.selectedItem
	local auctions = {}
	
	for itemID, data in pairs(scanData) do
		for _, record in pairs(data.records) do
			local cost, numItems, stackSizeFlag = Destroying:GetData(itemID, record)
			if cost then
				tinsert(auctions, {itemID=itemID, buyout=record.buyout, quantity=record.quantity, cost=cost, page=record.page, stackSizeFlag=stackSizeFlag, numItems=floor(numItems*100+0.5)/100})
			end
		end
	end
	
	debug("NUM AUCTIONS:", #auctions)
	TSM:SortAuctions(auctions, {"cost", "itemID", "page", "buyout"})
	auctions.totalQuantity = {}
	local currentCost = 0
	for _, data in ipairs(auctions) do
		if data.cost > currentCost then
			currentCost = data.cost
			auctions.totalQuantity[currentCost] = data.quantity
		else
			auctions.totalQuantity[currentCost] = auctions.totalQuantity[currentCost] + data.quantity
		end
	end
	
	debug("GOTO CHEAPEST")
	Destroying.frame.buyFrame:DisableButtons()
	Destroying.auctions = auctions
	if Destroying.auctions[1] then
		local nextAuction = CopyTable(Destroying.auctions[1])
		local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
		TSM.Scan:FindAuction(Destroying.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page)
	else
		debug("NO FIRST AUCTION")
		Destroying.frame.buyFrame:Hide()
		Destroying.frame.noAuctionsLabel:Show()
		Destroying.frame.noAuctionsLabel:SetText(L["No auctions for this item."])
		if not Destroying.automaticMode then
			Destroying.frame:EnableAll()
		else
			TSM.Automatic.autoFrame.skipButton:Enable()
		end
	end
end

function Destroying:ProcessCheapest(index, haveCheapest)
	debug("Process", index)
	local cheapest = tremove(Destroying.auctions, 1)
	
	if not index or not cheapest then
		if Destroying.auctions[1] then
			local nextAuction = CopyTable(Destroying.auctions[1])
			local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
			TSM.Scan:FindAuction(Destroying.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page)
		else
			Destroying.frame.buyFrame:Hide()
			Destroying.frame.noAuctionsLabel:Show()
			Destroying.frame.noAuctionsLabel:SetText(L["No more auctions for this item."])
			if not Destroying.automaticMode then
				Destroying.frame:EnableAll()
			else
				TSM.Automatic.autoFrame.skipButton:Enable()
			end
		end
		return
	end

	if not Destroying.automaticMode then
		Destroying.frame:EnableAll()
	else
		TSM.Automatic.autoFrame.skipButton:Enable()
	end
	
	local cQuantity, cCost = Destroying.auctions.totalQuantity[cheapest.cost], TSM:FormatTextMoney(cheapest.cost)
	local link = GetAuctionItemLink("list", index) or GetItemInfo(cheapest.itemID) or ""
	local _, _, quantity, _, _, _, _, _, buyout, newBuyout = GetAuctionItemInfo("list", index)
	if select(4, GetBuildInfo()) >= 40300 then -- fix for added parameter in 4.3
		buyout = newBuyout
	end
	if not buyout then
		return Destroying:ProcessCheapest()
	end
	local extraText = ""
	
	if Destroying.maxPrice then
		local percent = floor(((Destroying.maxPrice - cheapest.cost)/Destroying.maxPrice)*10000 + 0.5)/100
		if percent < 0 then
			extraText = format("|cffff0000"..L["%s%% above maximum price."].."|r", abs(percent))
		else
			extraText = format("|cff00ff00"..L["%s%% below maximum price."].."|r", percent)
		end
	end
	
	Destroying.frame.buyFrame:Show()
	Destroying.frame.buyFrame:EnableButtons()
	Destroying.frame.buyFrame.buyLabel:SetText(format(L["Found %s at this price."], cQuantity.."x"..link))
	Destroying.frame.buyFrame.currentLabel:SetText(format(L["%s @ %s(~%s per "..Destroying.label..")"].."%s", link.."x"..quantity, TSM:FormatTextMoney(buyout).."\n\n", cCost, "\n\n"..extraText))
	Destroying.currentItem = {itemID=cheapest.itemID, index=index, buyout=buyout, cost=cheapest.cost, quantity=quantity, numItems=cheapest.numItems}
end

function Destroying:BuyItem()
	debug("BUY11")
	local _, _, quantity, _, _, _, _, _, buyout, newBuyout = GetAuctionItemInfo("list", Destroying.currentItem.index)
	if select(4, GetBuildInfo()) >= 40300 then -- fix for added parameter in 4.3
		buyout = newBuyout
	end
	debug(Destroying.currentItem.index, Destroying.currentItem.itemID, buyout, Destroying.currentItem.buyout, quantity, Destroying.currentItem.quantity)
	if abs(buyout - Destroying.currentItem.buyout) > 1 or abs(quantity - Destroying.currentItem.quantity) > 0.5 then
		Destroying.frame.buyFrame:DisableButtons()
		TSM:Print("The auction house has changed in the time between the last scan and you clicking this button. The item failed to be purchased. Try again.")
		TSM.Scan:FindAuction(function(_,index) Destroying.currentItem.index = index Destroying.frame.buyFrame:EnableButtons() end, Destroying.currentItem.itemID, Destroying.currentItem.quantity, Destroying.currentItem.buyout)
		return
	end
	Destroying.totalSpent = Destroying.totalSpent + Destroying.currentItem.buyout
	Destroying.numItems = Destroying.numItems + Destroying.currentItem.numItems
	if Destroying.numItems - floor(Destroying.numItems) < 0.01 then
		Destroying.numItems = floor(Destroying.numItems)
	end
	Destroying.frame.buyFrame.infoLabel:SetText(format(L["Total Spent this Session: %s"..Destroying.label.."s Bought this Session: %sAverage Cost Per "..Destroying.label.." this session: %s"], TSM:FormatTextMoney(Destroying.totalSpent).."\n\n", Destroying.numItems.."\n\n", TSM:FormatTextMoney(TSMAPI:SafeDivide(Destroying.totalSpent, Destroying.numItems))))
	Destroying.auctions.totalQuantity[Destroying.currentItem.cost] = Destroying.auctions.totalQuantity[Destroying.currentItem.cost] - Destroying.currentItem.quantity
	PlaceAuctionBid("list", Destroying.currentItem.index, Destroying.currentItem.buyout)
	
	if Destroying.automaticMode and TSM.Automatic:BoughtItem(Destroying.currentItem.numItems) then
		return
	elseif Destroying.maxQuantity and Destroying.numItems >= Destroying.maxQuantity then
		Destroying.frame.buyFrame:Hide()
		Destroying.frame.EnableAll()
		Destroying.frame.noAuctionsLabel:Show()
		Destroying.frame.noAuctionsLabel:SetText(L["Bought at least the max quantity set for this item."])
	elseif Destroying.auctions[1] then
		Destroying:WaitForEvent()
	else
		Destroying.frame.buyFrame:Hide()
		Destroying.frame.noAuctionsLabel:Show()
		Destroying.frame.noAuctionsLabel:SetText(L["No more auctions for this item."])
		if not Destroying.automaticMode then
			Destroying.frame:EnableAll()
		else
			TSM.Automatic.autoFrame.skipButton:Enable()
		end
	end
end

function Destroying:WaitForEvent()
	debug("START WAIT")
	Destroying.frame.buyFrame:DisableButtons()
	Destroying.waitingFor = {chatMsg = true, listUpdate = true}
	Destroying:RegisterEvent("CHAT_MSG_SYSTEM", function(_, msg)
			local targetMsg = gsub(ERR_AUCTION_BID_PLACED, "%%s", "")
			if msg:match(targetMsg) then
				Destroying:UnregisterEvent("CHAT_MSG_SYSTEM")
				Destroying.waitingFor.chatMsg = false
				if not Destroying.waitingFor.listUpdate then
					debug("chat msg enable")
					local nextAuction = CopyTable(Destroying.auctions[1])
					local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
					TSMAPI:CreateTimeDelay("shoppingFindNext", 0.1, function() TSM.Scan:FindAuction(Destroying.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page) end)
				else
					debug("waiting on list update")
				end
			end
		end)
		
	local nextAuction = Destroying.auctions[1]
	local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
	Destroying:RegisterEvent("AUCTION_ITEM_LIST_UPDATE", function()
			Destroying:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
			Destroying.waitingFor.listUpdate = false
			if not Destroying.waitingFor.chatMsg then
				debug("list update enable")
				local nextAuction = Destroying.auctions[1]
				local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
				TSMAPI:CreateTimeDelay("shoppingFindNext", 0.3, function() TSM.Scan:FindAuction(Destroying.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page) end)
			else
				debug("waiting on chat msg")
			end
		end)
end

function Destroying:SkipItem()
	debug("SKIP")
	Destroying.auctions.totalQuantity[Destroying.currentItem.cost] = Destroying.auctions.totalQuantity[Destroying.currentItem.cost] - Destroying.currentItem.quantity
	Destroying.frame.buyFrame:DisableButtons()
	if Destroying.auctions[1] then
		local nextAuction = CopyTable(Destroying.auctions[1])
		local buyout = floor(nextAuction.buyout*nextAuction.quantity+0.5)
		TSM.Scan:FindAuction(Destroying.ProcessCheapest, nextAuction.itemID, nextAuction.quantity, buyout, nextAuction.page)
	else
		Destroying.frame.buyFrame:Hide()
		Destroying.frame.noAuctionsLabel:Show()
		Destroying.frame.noAuctionsLabel:SetText("No more auctions for this item.")
		if not Destroying.automaticMode then
			Destroying.frame:EnableAll()
		else
			TSM.Automatic.autoFrame.skipButton:Enable()
		end
	end
end

function Destroying:AutomaticQuery(item)
	TSMAPI:SelectRemoteFunction("shoppingDestroying", true)
	local mode, dropdownSelection = Destroying:GetDestroyableInfo(item.itemID)
	Destroying.neededQuantity = item.quantity
	debug("destroy query", mode, dropdownSelection)
	
	if mode == "mill" then
		Destroying.frame.itemDropdown.frame:Show()
		Destroying.frame.itemDropdown:SetDisabled(false)
		Destroying.frame.millIcon:Click()
		Destroying.frame.itemDropdown:SetValue(item.itemID)
		Destroying.frame.itemDropdown:Fire("OnValueChanged", item.itemID)
		Destroying.frame.goButton:Click()
		Destroying:StartAutomaticMode()
	elseif mode == "prospect" then
		Destroying.frame.itemDropdown.frame:Show()
		Destroying.frame.itemDropdown:SetDisabled(false)
		Destroying.frame.prospectIcon:Click()
		Destroying.frame.itemDropdown:SetValue(dropdownSelection)
		Destroying.frame.itemDropdown:Fire("OnValueChanged", dropdownSelection)
		Destroying.automaticMode = item.itemID
		Destroying.frame.goButton:Click()
		Destroying:StartAutomaticMode(true)
	elseif mode == "disenchant" then
		Destroying.frame.itemDropdown.frame:Show()
		Destroying.frame.itemDropdown:SetDisabled(false)
		Destroying.frame.deIcon:Click()
		Destroying.frame.itemDropdown:SetValue(item.itemID)
		Destroying.frame.itemDropdown:Fire("OnValueChanged", item.itemID)
		Destroying.automaticMode = item.itemID
		Destroying.frame.goButton:Click()
		Destroying:StartAutomaticMode(true)
	elseif mode == "transform" then
		Destroying.frame.itemDropdown.frame:Show()
		Destroying.frame.itemDropdown:SetDisabled(false)
		Destroying.frame.transformIcon:Click()
		Destroying.frame.itemDropdown:SetValue(item.itemID)
		Destroying.frame.itemDropdown:Fire("OnValueChanged", item.itemID)
		Destroying.automaticMode = item.itemID
		Destroying.frame.goButton:Click()
		Destroying:StartAutomaticMode(true)
	end
end

function Destroying:StartAutomaticMode(ignore)
	debug("s1", Destroying.automaticMode, ignore)
	if Destroying.automaticMode and not ignore then return end
	Destroying.automaticMode = true

	Destroying.frame:DisableAll()
	Destroying.frame.automaticLabel:Show()
	Destroying.frame.maxQuantity.frame:Hide()
	Destroying.frame.goButton:Hide()
	Destroying.frame.itemDropdown.frame:Hide()
	Destroying.frame.maxQuantity.frame:Hide()
	Destroying.frame.maxPrice.frame:Hide()
	Destroying.frame.modeLabel:Hide()
	Destroying.frame.deIcon:Hide()
	Destroying.frame.millIcon:Hide()
	Destroying.frame.prospectIcon:Hide()
	Destroying.frame.transformIcon:Hide()
end

function Destroying:StopAutomaticMode()
	if not Destroying.automaticMode then return end
	Destroying.automaticMode = nil
	TSMAPI:SelectRemoteFunction("shoppingDestroying", true)

	Destroying.frame:EnableAll()
	Destroying.frame.automaticLabel:Hide()
	Destroying.frame.goButton:Show()
	Destroying.frame.itemDropdown.frame:Show()
	Destroying.frame.maxQuantity.frame:Show()
	Destroying.frame.maxPrice.frame:Show()
	Destroying.frame.modeLabel:Show()
	Destroying.frame.deIcon:Show()
	Destroying.frame.millIcon:Show()
	Destroying.frame.prospectIcon:Show()
	Destroying.frame.transformIcon:Show()
end