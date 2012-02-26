-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_AuctionDB - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctiondb.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_AuctionDB", "enUS", true)

if not L then return end

-- TradeSkillMaster_AuctionDB.lua
L["Resets AuctionDB's scan data"] = true
L["AuctionDB Market Value:"] = true
L["AuctionDB Min Buyout:"] = true
L["AuctionDB Seen Count:"] = true
L["Are you sure you want to clear your AuctionDB data?"] = true
L["Reset Data"] = true

-- Scanning.lua
L["Enchanting"] = true
L["Inscription"] = true
L["Jewelcrafting"] = true
L["Alchemy"] = true
L["Blacksmithing"] = true
L["Leatherworking"] = true
L["Tailoring"] = true
L["Engineering"] = true
L["Cooking"] = true
L["Complete AH Scan"] = true
L["AuctionDB - Run Scan"] = true
L["Ready in %s min and %s sec"] = true
L["Not Ready"] = true
L["Ready"] = true
L["AuctionDB - Auction House Scanning"] = true
L["Run Scan"] = true
L["Starts scanning the auction house based on the below settings.\n\nIf you are running a GetAll scan, your game client may temporarily lock up."] = true
L["Run GetAll Scan if Possible"] = true
L["If checked, a GetAll scan will be used whenever possible.\n\nWARNING: With any GetAll scan there is a risk you may get disconnected from the game."] = true
L["GetAll Scan:"] = true
L["Run GetAll Scan"] = true
L["Run Regular Scan"] = true
L["Professions to scan for:"] = true
L["Search Scan Data"] = true
L["Opens the main TSM window to the AuctionDB page where you can search through AuctionDB's scan data to quickly lookup items in the AuctionDB database."] = true
L["If checked, a regular scan will scan for this profession."] = true
L["Auction house must be open in order to scan."] = true
L["AuctionDB - Scanning"] = true
L["Nothing to scan."] = true
L["Error: AuctionHouse window busy."] = true
L["AuctionDB - Scanning"] = true
L["Scan interupted due to auction house being closed."] = true
L["Scan complete!"] = true
L["|cffff0000WARNING:|r As of 4.0.1 there is a bug with GetAll scans only scanning a maximum of 42554 auctions from the AH which is less than your auction house currently contains. As a result, thousands of items may have been missed. Please use regular scans until blizzard fixes this bug."] = true

-- config.lua
L["Your version of the main TradeSkillMaster addon is out of date. Please update it in order to be able to view this page."] = true
L["Search"] = true
L["Options"] = true
L["%s ago"] = true
L["No items found"] = true
L["Use the search box and category filters above to search the AuctionDB data."] = true
L["<No Item SubType Filter>"] = true
L["<No Item Type Filter>"] = true
L["You can use this page to lookup an item or group of items in the AuctionDB database. Note that this does not perform a live search of the AH."] = true
L["Any items in the AuctionDB database that contain the search phrase in their names will be displayed."] = true
L["Item Type Filter"] = true
L["You can filter the results by item type by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in this dropdown and \"Herbs\" as the subtype filter."] = true
L["Item SubType Filter"] = true
L["You can filter the results by item subtype by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in the item type dropdown and \"Herbs\" in this dropdown."] = true
L["Refresh"] = true
L["Refreshes the current search results."] = true
L["Previous Page"] = true
L["Items %s - %s (%s total)"] = true
L["Next Page"] = true
L["Item Link"] = true
L["Num(Yours)"] = true
L["Minimum Buyout"] = true
L["Market Value"] = true
L["Last Scanned"] = true
L["General Options"] = true
L["Enable display of AuctionDB data in tooltip."] = true
L["Search Options"] = true
L["Items per page"] = true
L["Invalid value entered. You must enter a number between 5 and 500 inclusive."] = true
L["This determines how many items are shown per page in results area of the \"Search\" tab of the AuctionDB page in the main TSM window. You may enter a number between 5 and 500 inclusive. If the page lags, you may want to decrease this number."] = true
L["Sort items by"] = true
L["Item MinLevel"] = true
L["Select how you would like the search results to be sorted. After changing this option, you may need to refresh your search results by hitting the \"Refresh\" button."] = true
L["Ascending"] = true
L["Sort search results in ascending order."] = true
L["Descending"] = true
L["Sort search results in descending order."] = true
L["Hide poor quality items"] = true
L["If checked, poor quality items won't be shown in the search results."] = true
L["Block Auctioneer while Scanning."] = true
L["If checked, Auctioneer will be prevented from scanning / processing AuctionDB's scans."] = true