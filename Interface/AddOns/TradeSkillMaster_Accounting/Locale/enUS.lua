-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Accounting - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeSkillMaster_accounting.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Gathering Locale - enUS
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/tradeSkillMaster_accounting/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Accounting", "enUS", true)
if not L then return end

--TradeSkillMaster_Accounting.lua
L["Accounting"] = true
L["Sold (Avg Price): %s (%s)"] = true
L["Purchased (Avg Price): %s (%s)"] = true
L["TradeSkillMaster_Accounting has detected that you have MySales installed. Would you like to transfer your data over to Accounting?"] = true
L["Starting to import MySales data. This requires building a large cache of item names which will take about 20-30 seconds. Please be patient."] = true
L["MySales is currently disabled. Would you like Accounting to enable it and reload your UI so it can transfer settings?"] = true
L["MySales Import Progress"] = true
L["MySales Import Complete! Imported %s sales. Was unable to import %s sales."] = true

--data.lua
L["%s ago"] = true
L["Purchase"] = true
L["Sale"] = true

--gui.lua
L["Sales"] = true
L["Purchases"] = true
L["Items"] = true
L["Resale"] = true
L["Summary"] = true
L["Options"] = true
L["Click for a detailed report on this item."] = true
L["Back to Previous Page"] = true
L["Sale Data"] = true
L["Purchase Data"] = true
L["Activity Log"] = true
L["Average Prices:"] = true
L["Total:"] = true
L["Last 30 Days:"] = true
L["Last 7 Days:"] = true
L["Quantity Sold:"] = true
L["Gold Earned:"] = true
L["Top Buyers:"] = true
L["There is no sale data for this item."] = true
L["Quantity Bought:"] = true
L["Total Spent:"] = true
L["Top Sellers:"] = true
L["There is no purchase data for this item."] = true
L["Earned Per Day:"] = true
L["Top Item by Gold:"] = true
L["Top Item by Quantity:"] = true
L["Gold Spent:"] = true
L["Spent Per Day:"] = true
L["AuctionDB - Market Value"] = true
L["AuctionDB - Min Buyout"] = true
L["Auctioneer - Appraiser"] = true
L["Auctioneer - Min Buyout"] = true
L["Auctioneer - Market Value"] = true
L["Auctionator - Auction Value"] = true
L["TheUndermineJournal - Market Price"] = true
L["TheUndermineJournal - Mean"] = true
L["General Options"] = true
L["_ Hr _ Min ago"] = true
L["MM/DD/YY HH:MM"] = true
L["YY/MM/DD HH:MM"] = true
L["DD/MM/YY HH:MM"] = true
L["Time Format"] = true
L["Select what format Accounting should use to display times in applicable screens."] = true
L["Market Value Source"] = true
L["Select where you want Accounting to get market value info from to show in applicable screens."] = true
L["Items/Resale Price Format"] = true
L["Price Per Item"] = true
L["Total Value"] = true
L["Select how you would like prices to be shown in the \"Items\" and \"Resale\" tabs; either average price per item or total value."] = true
L["Tooltip Options"] = true
L["Show sale info in item tooltips"] = true
L["If checked, the number you have sold and the average sale price will show up in an item's tooltip."] = true
L["Show purchase info in item tooltips"] = true
L["If checked, the number you have purchased and the average purchase price will show up in an item's tooltip."] = true
L["Item Name"] = true
L["Stack Size"] = true
L["Auctions"] = true
L["Price Per Item"] = true
L["Total Sale Price"] = true
L["Last Sold"] = true
L["Total Buy Price"] = true
L["Last Purchase"] = true
L["Market Value"] = true
L["Sold"] = true
L["Avg Sell Price"] = true
L["Bought"] = true
L["Avg Buy Price"] = true
L["Avg Resale Profit"] = true
L["Activity Type"] = true
L["Buyer/Seller"] = true
L["Quantity"] = true
L["Total Price"] = true
L["Time"] = true
L["Items in an Auctioning Group"] = true
L["Items NOT in an Auctioning Group"] = true
L["Common Quality Items"] = true
L["Uncommon Quality Items"] = true
L["Rare Quality Items"] = true
L["Epic Quality Items"] = true
L["<none>"] = true
L["Search"] = true
L["Special Filters"] = true