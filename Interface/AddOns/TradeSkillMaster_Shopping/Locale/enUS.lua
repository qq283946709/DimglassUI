-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Shopping - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_shopping.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Shopping Locale - enUS
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Shopping/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Shopping", "enUS", true)
if not L then return end

-- TradeSkillMaster_Shopping.lua
L["Shopping Options"] = true

-- Automatic.lua
L["Shopping - Crafting Mats"] = true
L["Shopping will automatically buy materials you need for your craft queue in TradeSkillMaster_Crafting.\n\nNote that all queues will be shopped for so make sure you clear any queues you don't want to buy mats for."] = true
L["Start Shopping for Crafting Mats!"] = true
L["Disable prospecting for gems"] = true
L["If checked, you will not be given the option to buy ore in order to obtain raw gems."] = true
L["Disable disenchanting for mats"] = true
L["If checked, you will not be given the option to buy items to disenchant to obtain enchanting mats."] = true
L["Shopping - Automatic Mode"] = true
L["Skip Current Item"] = true
L["Skips the item currently being shopped for."] = true
L["Exit Automatic Mode"] = true
L["Cancels automatic mode and allows manual searches to resume."] = true
L["Done shopping."] = true

-- Config.lua
L["Options"] = true
L["Add / Remove Items"] = true
L["Folder Management"] = true
L["<Unorganized Items>"] = true
L["Dealfinding"] = true
L["Block Auctioneer while Scanning"] = true
L["Prevents Auctioneer from scanning / processing while Shopping is doing a scan."] = true
L["Shopping - Milling/Disenchanting/Prospecting/Transforming Options"] = true
L["The options below apply to \"Shopping - Milling/Disenchanting/Prospecting/Transforming\" searches (including those done while shopping for crafting mats)."] = true
L["Buy Inks to Trade if Cheaper"] = true
L["If checked, blackfallow ink will be shopped for in order to trade down to lower inks if it's cheaper."] = true
L["If checked, when buying ore / herbs only stacks that are evenly divisible by 5 will be purchased."] = true
L["Herbs / Ore Only"] = true
L["If checked, only herbs / ore will be searched for; not inks / raw gems."] = true
L["Shopping - Crafting Mats Options"] = true
L["The options below apply to \"Shopping - Crafting Mats\" searches."] = true
L["Skip Intro Screen"] = true
L["If checked, the intro screen for scanning for crafting mats will be skipped and the scanning will start immediately after clicking on the sidebar icon."] = true
L["The item you entered was invalid. See the tooltip for the \"%s\" editbox for info about how to add items."] = true
L["This item has not been seen on the server recently. Until the server has seen the item, Dealfinding will not be able to search for it on the AH and it will show up as the itemID in the Shopping options."] = true
L["Item has already been added to dealfinding."] = true
L["Invalid folder name. A folder with this name may already exist."] = true
L["Add Item"] = true
L["Adds an item to the dealfinding list. When you run a dealfinding scan, this item will be searched for and you will be prompted to buy any auctions of this item that meet the criteria you set."] = true
L["Item to Add"] = true
L["You can either drag an item into this box, paste (shift click) an item link into this box, or enter an itemID."] = true
L["Create Folder"] = true
L["Folders are simply for organization of your dealfinding items. They do not provide any additional settings. You can add items to a folder by clicking on the folder name in the list on the left."] = true
L["Folder Name"] = true
L["Name of the new folder."] = true
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
L["Are you sure you want to delete the selected profile?"] = true
L["Accept"] = true
L["Cancel"] = true
L["Default"] = true
L["General Options"] = true
L["Below are some general options dealfinding will follow for this item."] = true
L["Even Stacks Only"] = true
L["Only even stacks (5/10/15/20) of this item will be purchased. This is useful for buying herbs / ore to mill / prospect."] = true
L["Maximum Price"] = true
L["Here, you can set the maximum price you want to pay."] = true
L["Maximum Price Per Item"] = true
L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = true
L["This is the maximum price you want to pay per item (NOT per stack) for this item. You will be prompted to buy all items on the AH that are below this price."] = true
L["Item Management"] = true
L["Below are general management options for this item."] = true
L["Remove Item from Dealfinding"] = true
L["Removes this item from dealfinding completely."] = true
L["Items not in any folder:"] = true
L["Items in this folder:"] = true
L["Rename Folder"] = true
L["New Folder Name"] = true
L["Delete Folder"] = true

-- Dealfinding.lua
L["Shopping - Dealfinding"] = true
L["Add Item to Dealfinding List:"] = true
L["You can either drag an item into this box, paste (shift click) an item link into this box, or enter an itemID."] = true
L["<Invalid! See Tooltip>"] = true
L["Max Price (Per 1 Item):"] = true
L["The max price (per 1 item) you want to have a Dealfinding scan buy something for. \n\nMust be entered in the form of \"#g#s#c\". For example \"5g24s98c\" would be 5 gold 24 silver 98 copper."] = true
L["Add Item"] = true
L["Scans for all items in your Dealfinding list."] = true
L["Item was already in the Dealfinding list. Price has been overriden (old price was %s)."] = true
L["Edit Selected Item"] = true
L["Delete Selected Item"] = true
L["Config"] = true
L["Opens the config window for TradeSkillMaster_Shopping."] = true
L["Stop Scanning"] = true
L["Stops the scan."] = true
L["Scan Canceled"] = true
L["BUY"] = true
L["Buy the next cheapest auction."] = true
L["SKIP"] = true
L["Skip this auction."] = true
L["Run Dealfinding Scan"] = true
L["Configures your Dealfinding list."] = true
L["Configure Dealfinding List"] = true
L["No auctions are under your Dealfinding prices."] = true
L["No more auctions"] = true
L["%s%% above maximum price."] = true
L["%s%% below maximum price."] = true
L["%s below your Dealfinding price."] = true
L["per item"] = true
L["Total Spent this Session:"] = true
L["No more auctions."] = true

-- Destroying.lua
L["Shopping - Milling/Disenchanting/Prospecting/Transforming"] = true
L["Ivory Ink"] = true
L["Moonglow Ink"] = true
L["Midnight Ink"] = true
L["Lion's Ink"] = true
L["Jadefire Ink"] = true
L["Celestial Ink"] = true
L["Shimmering Ink"] = true
L["Ethereal Ink"] = true
L["Ink of the Sea"] = true
L["Blackfallow Ink"] = true
L["Inferno Ink"] = true
L["Strange Dust"] = true
L["Soul Dust"] = true
L["Vision Dust"] = true
L["Dream Dust"] = true
L["Illusion Dust"] = true
L["Arcane Dust"] = true
L["Infinite Dust"] = true
L["Hypnotic Dust"] = true
L["Greater Celestial Essence"] = true
L["Lesser Celestial Essence"] = true
L["Heavenly Shard"] = true
L["Dream Shard"] = true
L["Greater Cosmic Essence"] = true
L["Lesser Cosmic Essence"] = true
L["Select an ink which you would like to buy for (through milling herbs)."] = true
L["Select an enchanting mat which you would like to buy for (through disenchanting items)."] = true
L["Select a raw gem which you would like to buy for (through prospecting ore)."] = true
L["Select a target item for the transformation."] = true
L["Mode:"] = true
L["Shop for items to Disenchant"] = true
L["Shop for items to Mill"] = true
L["Shop for items to Prospect"] = true
L["Shop for items to Transform (essences to split/combine for example)."] = true
L["Milling"] = true
L["Prospecting"] = true
L["Disenchanting"] = true
L["Transform"] = true
L["Buy for:"] = true
L["GO"] = true
L["Start buying!"] = true
L["Total Spent this Session: %sRaw Gems Bought this Session: %sAverage Cost Per Raw Gem this session: %s"] = true
L["Total Spent this Session: %sInks Bought this Session: %sAverage Cost Per Ink this session: %s"] = true
L["Total Spent this Session: %sEnchanting Mats Bought this Session: %sAverage Cost Per Enchanting Mat this session: %s"] = true
L["Total Spent this Session: %sItems Bought this Session: %sAverage Cost Per Item this session: %s"] = true
L["Max Price (optional):"] = true
L["The most you want to pay for something. \n\nMust be entered in the form of \"#g#s#c\". For example \"5g24s98c\" would be 5 gold 24 silver 98 copper."] = true
L["Quantity (optional)"] = true
L["How many you want to buy."] = true
L["Manual controls disabled when Shopping in automatic mode.\n\nClick on the \"Exit Automatic Mode\" button to enable manual controls."] = true
L["BUY"] = true
L["Buy the next cheapest auction."] = true
L["SKIP"] = true
L["Skip this auction."] = true
L["Total Spent this Session: %sAverage Cost Per  this session: %s"] = true
L["Total Spent this Session: %sAverage Cost Per Raw Gem this session: %s"] = true
L["Total Spent this Session: %sAverage Cost Per Ink this session: %s"] = true
L["Total Spent this Session: %sAverage Cost Per Enchanting Mat this session: %s"] = true
L["Total Spent this Session: %sAverage Cost Per Item this session: %s"] = true
L["No auctions for this item."] = true
L["Found %s at this price."] = true
L["%s @ %s(~%s per )"] = true
L["%s @ %s(~%s per Raw Gem)"] = true
L["%s @ %s(~%s per Ink)"] = true
L["%s @ %s(~%s per Enchanting Mat)"] = true
L["%s @ %s(~%s per Item)"] = true
L["Bought at least the max quantity set for this item."] = true
L["Cata - Blue Quality"] = true
L["Cata - Green Quality"] = true
L["BC - Green Quality"] = true
L["BC - Blue Quality"] = true
L["Wrath - Green Quality"] = true
L["Wrath - Blue Quality"] = true
L["Wrath - Epic Quality"] = true

-- General.lua
L["Shopping - General Buying"] = true
L["Name of item to serach for:"] = true
L["What would you like to buy?"] = true
L["No auctions matched \"%s\""] = true
L["No more auctions for this item."] = true
L["Buying: %s(%s at this price)"] = true
L["%s @ %s(%s per)"] = true
L["Total Spent this Session: %sItems Bought This Session: %sAverage Cost Per Item this Session: %s"] = true
L["No auctions found."] = true

-- Scan.lua
L["Auction house must be open in order to scan."] = true
L["Nothing to scan."] = true
L["Shopping - Scanning"] = true
L["Scan interrupted due to auction house being closed."] = true
L["Scan interrupted due to automatic mode being canceled."] = true