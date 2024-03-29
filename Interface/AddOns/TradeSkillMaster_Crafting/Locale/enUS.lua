-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Crafting - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_crafting.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Crafting Locale - enUS
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Crafting/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Crafting", "enUS", true)
if not L then return end

-- TradeSkillMaster_Crafting.lua
L["Crafting Cost: %s (%s profit)"] = true

-- Crafting.lua
L["Craft Next"] = true
L["All"] = true
L["Restock Queue"] = true
L["On-Hand Queue"] = true
L["Clear Queue"] = true
L["Profession was not found so the craft queue has been disabled."] = true
L["Enchanting was not found so the craft queue has been disabled."] = true
L["Inscription was not found so the craft queue has been disabled."] = true
L["Jewelcrafting was not found so the craft queue has been disabled."] = true
L["Alchemy was not found so the craft queue has been disabled."] = true
L["Blacksmithing was not found so the craft queue has been disabled."] = true
L["Leatherworking was not found so the craft queue has been disabled."] = true
L["Tailoring was not found so the craft queue has been disabled."] = true
L["Engineering was not found so the craft queue has been disabled."] = true
L["Cooking was not found so the craft queue has been disabled."] = true
L["Smelting was not found so the craft queue has been disabled."] = true
L["Open Enchanting"] = true
L["Open Inscription"] = true
L["Open Jewelcrafting"] = true
L["Open Alchemy"] = true
L["Open Blacksmithing"] = true
L["Open Leatherworking"] = true
L["Open Tailoring"] = true
L["Open Engineering"] = true
L["Open Cooking"] = true
L["Open Smelting"] = true
L["You must have your profession window open in order to use the craft queue. Click on the button below to open it."] = true
L["Craft"] = true
L["Combine/Split Essences/Eternals"] = true
L["Close TradeSkillMaster_Crafting"] = true
L["Open TradeSkillMaster_Crafting"] = true
L["Right click to remove all items with this mat from the craft queue."] = true
L["Name"] = true
L["Need"] = true
L["In Bags"] = true
L["Total"] = true
L["Cost"] = true
L["Price Source"] = true
L["AH/Bags/Bank/Alts"] = true
L["Crafted Item Value"] = true
L["Profit"] = true
L["Estimated Total Mat Cost:"] = true
L["Estimated Total Profit:"] = true
L["Clear Tradeskill Filters"] = true
L["Mill"] = true
L["Vendor"] = true
L["Vendor Trade"] = true
L["Auction House"] = true

-- Data.lua
L["Craft Queue Reset"] = true
L["%s not queued! Min restock of %s is higher than max restock of %s"] = true
L["TradeSkillMaster_Crafting - Scanning..."] = true

-- GUI.lua
L["Are you sure you want to delete the selected profile?"] = true
L["Accept"] = true
L["Cancel"] = true
L["Crafting Options"] = true
L["Options"] = true
L["Crafts"] = true
L["Materials"] = true
L["Status"] = true
L["Use the links on the left to select which page to show."] = true
L["Show Craft Management Window"] = true
L["Force Rescan of Profession (Advanced)"] = true
L["Warning: Your default minimum restock quantity is higher than your maximum restock quantity! Visit the \"Craft Management Window\" section of the Crafting options to fix this!\n\nYou will get error messages printed out to chat if you try and perform a restock queue without fixing this."] = true
L["OK"] = true
L["Add Item to TSM_Auctioning"] = true
L["TSM_Auctioning Group to Add Item to:"] = true
L["Which group in TSM_Auctioning to add this item to."] = true
L["Add Item to Selected Group"] = true
L["Name of New Group to Add Item to:"] = true
L["Add Item to New Group"] = true
L["Which group in TSM_Mailing to add this item to."] = true
L["Override Max Restock Quantity"] = true
L["Max Restock Quantity"] = true
L["Can not set a max restock quantity below the minimum restock quantity of %d."] = true
L["Override Min Restock Quantity"] = true
L["Allows you to set a custom minimum queue quantity for this item."] = true
L["Min Restock Quantity"] = true
L["This item will only be added to the queue if the number being added is greater than or equal to this number. This is useful if you don't want to bother with crafting singles for example."] = true
L["Ignore Seen Count Filter"] = true
L["Allows you to set a custom minimum queue quantity for this item."] = true
L["Don't queue this item."] = true
L["This item will not be queued by the \"Restock Queue\" ever."] = true
L["Always queue this item."] = true
L["This item will always be queued (to the max restock quantity) regardless of price data."] = true
L["This item is already in the \"%s\" Auctioning group."] = true
L["Export Crafts to TradeSkillMaster_Auctioning"] = true
L["Select the crafts you would like to add to Auctioning and use the settings / buttons below to do so."] = true
L["You can select a category that group(s) will be added to or select \"<No Category>\" to not add the group(s) to a category."] = true
L["All in Individual Groups"] = true
L["All in Same Group"] = true
L["How to add crafts to Auctioning:"] = true
L["You can either add every craft to one group or make individual groups for each craft."] = true
L["Group to Add Crafts to:"] = true
L["Select an Auctioning group to add these crafts to."] = true
L["Include Crafts Already in a Group"] = true
L["If checked, any crafts which are already in an Auctioning group will be removed from their current group and a new group will be created for them. If you want to maintain the groups you already have setup that include items in this group, leave this unchecked."] = true
L["Only Included Enabled Crafts"] = true
L["If checked, Only crafts that are enabled (have the checkbox to the right of the item link checked) below will be added to Auctioning groups."] = true
L["Add Crafted Items from this Group to Auctioning Groups"] = true
L["Added %s crafted items to: %s."] = true
L["Added %s crafted items to %s individual groups."] = true
L["Adds all items in this Crafting group to Auctioning group(s) as per the above settings."] = true
L["Help"] = true
L["The checkboxes in next to each craft determine enable / disable the craft being shown in the Craft Management Window."] = true
L["Enable All Crafts"] = true
L["Disable All Crafts"] = true
L["Create Auctioning Groups"] = true
L["Cost: %s Market Value: %s Profit: %s Times Crafted: %s"] = true
L["Enable / Disable showing this craft in the craft management window."] = true
L["Additional Item Settings"] = true
L["No crafts have been added for this profession. Crafts are automatically added when you click on the profession icon while logged onto a character which has that profession."] = true
L["General Setting Overrides"] = true
L["Here, you can override general settings."] = true
L["Override Craft Sort Method"] = true
L["Allows you to set a different craft sort method for this profession."] = true
L["Override Craft Sort Order"] = true
L["Allows you to set a different craft sort order for this profession."] = true
L["Profession-Specific Settings"] = true
L["Restock Queue Overrides"] = true
L["Here, you can override default restock queue settings."] = true
L["Override Minimum Profit"] = true
L["Allows you to set a custom maximum queue quantity for this item."] = true
L["Allows you to set a custom minimum queue quantity for this profession."] = true
L["Allows you to set a custom maximum queue quantity for this profession."] = true
L["Allows you to override the minimum profit settings for this profession."] = true
L["Price / Inventory Settings"] = true
L["Profession Page Settings"] = true
L["Craft Management Window Settings"] = true
L["Craft Management Window"] = true
L["Profiles"] = true
L["Manual Entry"] = true
L["Auctioneer - Market Value"] = true
L["Auctioneer - Appraiser"] = true
L["Auctioneer - Minimum Buyout"] = true
L["Auctioneer - Market Value"] = true
L["Auctioneer - Appraiser"] = true
L["Auctioneer - Minimum Buyout"] = true
L["AuctionDB - Market Value"] = true
L["AuctionDB - Minimum Buyout"] = true
L["AuctionDB - Market Value"] = true
L["AuctionDB - Minimum Buyout"] = true
L["Auctionator - Auction Value"] = true
L["TheUndermineJournal - Market Price"] = true
L["TheUndermineJournal - Mean"] = true
L["DataStore"] = true
L["Gathering"] = true
L["General Settings"] = true
L["Sort Crafts By"] = true
L["Name"] = true
L["Cost to Craft"] = true
L["Profit"] = true
L["Seen Count"] = true
L["Times Crafted"] = true
L["Item Level"] = true
L["This setting determines how crafts are sorted in the craft group pages (NOT the Craft Management Window)."] = true
L["Sort Order:"] = true
L["Ascending"] = true
L["Sort crafts in ascending order."] = true
L["Descending"] = true
L["Sort crafts in descending order."] = true
L["Min ilvl to craft:"] = true
L["Place lower limit on ilvl to craft"] = true
L["Allows you to set a custom minimum ilvl to queue."] = true
L["Min Craft ilvl"] = true
L["Enable New TradeSkills"] = true
L["If checked, when Crafting scans a tradeskill for the first time (such as after you learn a new one), it will be enabled by default."] = true
L["Show Crafting Cost in Tooltip"] = true
L["If checked, the crafting cost of items will be shown in the tooltip for the item."] = true
L["Price Settings"] = true
L["Group Inscription Crafts By:"] = true
L["Ink"] = true
L["Class"] = true
L["Inscription crafts can be grouped in TradeSkillMaster_Crafting either by class or by the ink required to make them."] = true
L["Get Mat Prices From:"] = true
L["This is where TradeSkillMaster_Crafting will get material prices. AuctionDB is TradeSkillMaster's auction house data module. Alternatively, prices can be entered manually in the \"Materials\" pages."] = true
L["Get Craft Prices From:"] = true
L["This is where TradeSkillMaster_Crafting will get prices for crafted items. AuctionDB is TradeSkillMaster's auction house data module."] = true
L["Profit Deduction"] = true
L["Percent to subtract from buyout when calculating profits (5% will compensate for AH cut)."] = true
L["Inventory Settings"] = true
L["TradeSkillMaster_Crafting can use TradeSkillMaster_Gathering or DataStore_Containers to provide data for a number of different places inside TradeSkillMaster_Crafting. Use the settings below to set this up."] = true
L["Addon to use for alt data:"] = true
L["Characters to include:"] = true
L["Guilds to include:"] = true
L["Mark as Unknown (\"----\")"] = true
L["Set Crafted Item Cost to Auctioning Fallback"] = true
L["General"] = true
L["Unknown Profit Queuing"] = true
L["This will determine how items with unknown profit are dealt with in the Craft Management Window. If you have the Auctioning module installed and an item is in an Auctioning group, the fallback for the item can be used as the market value of the crafted item (will show in light blue in the Craft Management Window)."] = true
L["Frame Scale"] = true
L["This will set the scale of the craft management window. Everything inside the window will be scaled by this percentage."] = true
L["Double Click Queue"] = true
L["When you double click on a craft in the top-left portion (queuing portion) of the craft management window, it will increment/decrement this many times."] = true
L["Show Profit Percentages"] = true
L["If checked, the profit percent (profit/sell price) will be shown next to the profit in the craft management window."] = true
L["Queue Settings"] = true
L["Restock Queue Settings"] = true
L["These options control the \"Restock Queue\" button in the craft management window. These settings can be overriden by profession or by item in the profession pages of the main TSM window."] = true
L["Include Items on AH"] = true
L["If checked, Crafting will account for items you have on the AH."] = true
L["Minimum Profit Method"] = true
L["Gold Amount"] = true
L["Percent of Cost"] = true
L["No Minimum"] = true
L["Percent and Gold Amount"] = true
L["You can choose to specify a minimum profit amount (in gold or by percent of cost) for what crafts should be added to the craft queue."] = true
L["Min Restock Quantity"] = true
L["Warning: The min restock quantity must be lower than the max restock quantity."] = true
L["Items will only be added to the queue if the number being added is greater than this number. This is useful if you don't want to bother with crafting singles for example."] = true
L["Max Restock Quantity"] = true
L["When you click on the \"Restock Queue\" button enough of each craft will be queued so that you have this maximum number on hand. For example, if you have 2 of item X on hand and you set this to 4, 2 more will be added to the craft queue."] = true
L["Minimum Profit (in %)"] = true
L["If enabled, any craft with a profit over this percent of the cost will be added to the craft queue when you use the \"Restock Queue\" button."] = true
L["Minimum Profit (in gold)"] = true
L["If enabled, any craft with a profit over this value will be added to the craft queue when you use the \"Restock Queue\" button."] = true
L["Filter out items with low seen count."] = true
L["When you use the \"Restock Queue\" button, it will ignore any items with a seen count below the seen count filter below. The seen count data can be retreived from either Auctioneer or TradeSkillMaster's AuctionDB module."] = true
L["Seen Count Source"] = true
L["TradeSkillMaster_AuctionDB"] = true
L["Auctioneer"] = true
L["This setting determines where seen count data is retreived from. The seen count data can be retreived from either Auctioneer or TradeSkillMaster's AuctionDB module."] = true
L["Seen Count Filter"] = true
L["If enabled, any item with a seen count below this seen count filter value will not be added to the craft queue when using the \"Restock Queue\" button. You can overrride this filter for individual items in the \"Additional Item Settings\"."] = true
L["Ignore Vendor Items"] = true
L["If checked, the on-hand queue will assume you have all vendor items when queuing crafts."] = true
L["Limit Vendor Item Price"] = true
L["If checked, only vendor items below a maximum price will be ignored by the on-hand queue."] = true
L["Maximum Price Per Vendor Item"] = true
L["All vendor items that cost more than this price will not be ignored by the on-hand queue."] = true
L["Default"] = true
L["You can change the active database profile, so you can have different settings for every character."] = true
L["Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."] = true
L["Reset Profile"] = true
L["You can either create a new profile by entering a name in the editbox, or choose one of the already exisiting profiles."] = true
L["New"] = true
L["Create a new empty profile."] = true
L["Existing Profiles"] = true
L["Copy the settings from one existing profile into the currently active profile."] = true
L["Copy From"] = true
L["Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."] = true
L["Delete a Profile"] = true
L["Profiles"] = true
L["Current Profile:"] = true
L["Custom"] = true
L["Item Name"] = true
L["Mat Price"] = true
L["Number Owned"] = true
L["You can click on one of the rows of the scrolling table below to view or adjust how the price of a material is calculated."] = true
L["Click to view and adjust how the price of this material is calculated."] = true
L["Material Cost Options"] = true
L["Price:"] = true
L["Here you can view and adjust how Crafting is calculating the price for this material."] = true
L["Override Price Source"] = true
L["If checked, you can change the price source for this mat by clicking on one of the checkboxes below. This source will be used to determine the price of this mat until you remove the override or change the source manually. If this setting is not checked, Crafting will automatically pick the cheapest source."] = true
L["General Price Sources"] = true
L["Auction House Value"] = true
L["Use auction house data from the addon you have selected in the Crafting options for the value of this mat."] = true
L["User-Defined Price"] = true
L["Custom Value"] = true
L["Checking this box will allow you to set a custom, fixed price for this item."] = true
L["Edit Custom Value"] = true
L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = true
L["Enter a value that Crafting will use as the cost of this material."] = true
L["Multiple of Other Item Cost"] = true
L["This will allow you to base the price of this item on the price of some other item times a multiplier. Be careful not to create circular dependencies (ie Item A is based on the cost of Item B and Item B is based on the price of Item A)!"] = true
L["Other Item"] = true
L["Invalid item entered. You can either link the item into this box or type in the itemID from wowhead."] = true
L["The item you want to base this mat's price on. You can either link the item into this box or type in the itemID from wowhead."] = true
L["Price Multiplier"] = true
L["Invalid Number"] = true
L["Enter what you want to multiply the cost of the other item by to calculate the price of this mat."] = true
L["Buy From Vendor"] = true
L["Use the price that a vendor sells this item for as the cost of this material."] = true
L["Vendor Trade (x%s)"] = true
L["Note: By default, Crafting will use the second cheapest value (herb or pigment cost) to calculate the cost of the pigment as this provides a slightly more accurate value."] = true
L["Milling"] = true
L["Use the price of buying herbs to mill as the cost of this material."] = true
L["per pigment"] = true
L["Craft Item (x%s)"] = true
L["NOTE: Milling prices can be viewed / adjusted in the mat options for pigments. Click on the button below to go to the pigment options."] = true
L["Open Mat Options for Pigment"] = true

-- Alchemy.lua
L["Elixir"] = true
L["Potion"] = true
L["Flask"] = true
L["Other Consumable"] = true
L["Transmutes"] = true
L["Misc Items"] = true
L["Other"] = true

-- Blacksmithing.lua
L["Item Enhancements"] = true
L["Armor - Chest"] = true
L["Armor - Feet"] = true
L["Armor - Hands"] = true
L["Armor - Head"] = true
L["Armor - Legs"] = true
L["Armor - Shield"] = true
L["Armor - Shoulders"] = true
L["Armor - Waist"] = true
L["Armor - Wrists"] = true
L["Weapon - Main Hand"] = true
L["Weapon - One Hand"] = true
L["Weapon - Thrown"] = true
L["Weapon - Two Hand"] = true

-- Cooking.lua
L["Level 1-35"] = true
L["Level 36-70"] = true
L["Level 71+"] = true

-- Enchanting.lua
L["2H Weapon"] = true
L["Boots"] = true
L["Bracers"] = true
L["Chest"] = true
L["Cloak"] = true
L["Gloves"] = true
L["Shield"] = true
L["Staff"] = true
L["Weapon"] = true

-- Engineering.lua
L["Armor"] = true
L["Guns"] = true
L["Scopes"] = true
L["Consumables"] = true
L["Explosives"] = true
L["Companions"] = true
L["Trinkets"] = true

-- Inscription.lua
L["Blackfallow Ink"] = true
L["Ink of the Sea"] = true
L["Ethereal Ink"] = true
L["Shimmering Ink"] = true
L["Celestial Ink"] = true
L["Jadefire Ink"] = true
L["Lion's Ink"] = true
L["Midnight Ink"] = true
L["Death Knight"] = true
L["Druid"] = true
L["Hunter"] = true
L["Mage"] = true
L["Paladin"] = true
L["Priest"] = true
L["Rogue"] = true
L["Shaman"] = true
L["Warlock"] = true
L["Warrior"] = true
L["Inks"] = true
L["Scrolls"] = true

-- Jewelcrafting.lua
L["Red Gems"] = true
L["Blue Gems"] = true
L["Yellow Gems"] = true
L["Purple Gems"] = true
L["Green Gems"] = true
L["Orange Gems"] = true
L["Meta Gems"] = true
L["Prismatic Gems"] = true

-- Leatherworking.lua
L["Armor - Back"] = true
L["Armor - Chest"] = true
L["Armor - Feet"] = true
L["Armor - Hands"] = true
L["Armor - Head"] = true
L["Armor - Legs"] = true
L["Armor - Shoulders"] = true
L["Armor - Waist"] = true
L["Armor - Wrists"] = true
L["Bags"] = true
L["Consumables"] = true
L["Leather"] = true

-- Smelting.lua
L["Bars"] = true

-- Tailoring.lua
L["Armor - Back"] = true
L["Armor - Chest"] = true
L["Armor - Feet"] = true
L["Armor - Hands"] = true
L["Armor - Head"] = true
L["Armor - Legs"] = true
L["Armor - Shoulders"] = true
L["Armor - Waist"] = true
L["Armor - Wrists"] = true
L["Bags"] = true
L["Consumables"] = true
L["Cloth"] = true