-- TradeSkillMaster_Auctioning Locale - esES
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Auctioning/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Auctioning", "esES")
if not L then return end

-- L["% of AuctionDB Market Value"] = ""
-- L["% of AuctionDB Minimum Buyout"] = ""
-- L["% of Auctioneer Appraiser"] = ""
-- L["% of Auctioneer Market Value"] = ""
-- L["% of Auctioneer Minimum Buyout"] = ""
-- L["% of Crafting cost"] = ""
-- L["% of ItemAuditor cost"] = ""
-- L["12 hours"] = ""
-- L["24 hours"] = ""
-- L["48 hours"] = ""
-- L["<Uncategorized Groups>"] = ""
-- L["<none>"] = ""
-- L["A category contains groups with similar settings and acts like an organizational folder. You may override default settings by category (and then override category settings by group)."] = ""
-- L["A group contains items that you wish to sell with similar conditions (stack size, fallback price, etc).  Default settings may be overridden by a group's individual settings."] = ""
-- L["ALT"] = ""
-- L["Accept"] = ""
-- L["Add a new player to your blacklist."] = ""
-- L["Add a new player to your whitelist."] = ""
-- L["Add category"] = ""
-- L["Add group"] = ""
-- L["Add player"] = ""
-- L["Add/Remove"] = ""
-- L["Add/Remove Groups"] = ""
-- L["Add/Remove Items"] = ""
-- L["Advanced"] = ""
-- L["Advanced Price Settings (Market Reset)"] = ""
-- L["Allows you to manually adjust the buyout price you want to post this item for. This is a one-time adjustment and will no effect your settings."] = ""
-- L["Any auctions at or below the selected duration will be ignored. Selecting \"<none>\" will cause no auctions to be ignored based on duration."] = ""
-- L["Any of your auctions which match this text will be canceled. For example, if you enter \"glyph\", any item with \"glyph\" in its name will be canceled (even ones not in a group)."] = ""
-- L["Are you SURE you want to delete this category?"] = ""
-- L["Are you SURE you want to delete this group?"] = ""
-- L["Are you sure you want to delete the selected profile?"] = ""
-- L["Auction Defaults"] = ""
-- L["Auctioning - Cancel"] = ""
-- L["Auctioning - Cancel All"] = ""
-- L["Auctioning - Cancel All Scan"] = ""
-- L["Auctioning - Cancel Scan"] = ""
-- L["Auctioning - Post"] = ""
-- L["Auctioning - Post Scan"] = ""
-- L["Auctioning - Status Scan / Config"] = ""
-- L["Auctioning - Status/Config"] = ""
-- L["Auctioning Group:"] = ""
-- L["Auctioning Groups/Options"] = ""
-- L["Auctioning will follow the 'Advanced Price Settings' when the market goes below %s."] = ""
-- L["Auctioning will never post your auctions for below %s."] = ""
-- L["Auctioning will post at %s when there are no other auctions up."] = ""
-- L["Auctioning will post at %s when you are the only one posting below %s."] = ""
-- L["Auctioning will undercut your competition by %s. When posting, the bid of your auctions will be set to %s percent of the buyout."] = ""
-- L["Auctions will be posted at %s when the market goes below your threshold."] = ""
-- L["Auctions will be posted at a price such that they are undercutting the cheapest auction above your threshold when the market goes below your threshold."] = ""
-- L["Auctions will be posted at your fallback price of %s when the market goes below your threshold."] = ""
-- L["Auctions will be posted at your threshold price of %s when the market goes below your threshold."] = ""
-- L["Auctions will be posted for %s hours in stacks of %s. A maximum of %s auctions will be posted."] = ""
-- L["Auctions will be posted for %s hours in stacks of up to %s. A maximum of %s auctions will be posted."] = ""
-- L["Auctions will not be posted when the market goes below your threshold."] = ""
-- L["Beginner"] = ""
-- L["Bid percent"] = ""
-- L["Bid: %s"] = ""
-- L["Blacklist"] = ""
-- L["Blacklists allows you to undercut a competitor no matter how low their threshold may be. If the lowest auction of an item is owned by somebody on your blacklist, your threshold will be ignored for that item and you will undercut them regardless of whether they are above or below your threshold."] = ""
-- L["Block Auctioneer while scanning"] = ""
-- L["Buyout Per Item"] = ""
-- L["Buyout: %s"] = ""
-- L["CTRL"] = ""
-- L["Cancel"] = ""
-- L["Cancel All - Cancel all active items, those in a specified group, or those with a specified time left."] = ""
-- L["Cancel All Filter:"] = ""
-- L["Cancel All Items"] = ""
-- L["Cancel Auction %s / %s"] = ""
-- L["Cancel Items Matching:"] = ""
-- L["Cancel Match - Cancel all items that match the specified filter."] = ""
-- L["Cancel Matching Items"] = ""
-- L["Cancel all auctions according to the filter."] = ""
-- L["Cancel all auctions according to the filter. If the editbox is blank, everything will be canceled."] = ""
-- L["Cancel auctions with bids"] = ""
-- L["Canceling"] = ""
-- L["Cancelled %s"] = ""
-- L["Cannot find data for %s."] = ""
-- L["Categories / Groups"] = ""
-- L["Category Overrides"] = ""
-- L["Category name"] = ""
-- L["Change Post Price"] = ""
-- L["Clicking this will cancel auctions based on the data scanned."] = ""
-- L["Clicking this will post auctions based on the data scanned."] = ""
-- L["Close this window and discard the price entered above."] = ""
-- L["Close this window and save the price entered above as the new buyout price (new bid calculated automatically)."] = ""
-- L["Completely disables this group. This group will not be scanned for and will be effectively invisible to Auctioning."] = ""
-- L["Config"] = ""
-- L["Copy From"] = ""
-- L["Copy the settings from one existing profile into the currently active profile."] = ""
-- L["Create Category / Group"] = ""
-- L["Create Macro and Bind ScrollWheel (with selected options)"] = ""
-- L["Create a new empty profile."] = ""
-- L["Current Profile:"] = ""
-- L["Custom Reset Price (gold)"] = ""
-- L["Custom Value"] = ""
-- L["Custom market reset price. If the market goes below your threshold, items will be posted at this price."] = ""
-- L["Data Imported to Group: %s"] = ""
-- L["Default"] = ""
-- L["Delete"] = ""
-- L["Delete a Profile"] = ""
-- L["Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."] = ""
-- L["Delete group"] = ""
-- L["Delete this category, this cannot be undone!"] = ""
-- L["Delete this group, this cannot be undone!"] = ""
-- L["Determines which order the group / category settings tabs will appear in."] = ""
-- L["Did not post %s because your fallback (%s) is invalid. Check your settings."] = ""
-- L["Did not post %s because your fallback (%s) is lower than your threshold (%s). Check your settings."] = ""
-- L["Did not post %s because your threshold (%s) is invalid. Check your settings."] = ""
-- L["Disable auto cancelling"] = ""
-- L["Disable automatically cancelling of items in this group if undercut."] = ""
-- L["Disable posting and canceling"] = ""
-- L["Disables cancelling of auctions with a market price below the threshold, also will cancel auctions if you are the only one with that item up and you can relist it for more."] = ""
-- L["Displays the Auctioning log describing what it's currently scanning, posting or cancelling."] = ""
--[==[ L[ [=[Does a status scan that helps to identify auctions you can buyout to raise the price of a group you're managing.

This will NOT automatically buy items for you, all it tells you is the lowest price and how many are posted.]=] ] = "" ]==]
-- L["Don't Import Already Grouped Items"] = ""
-- L["Don't Post Items"] = ""
-- L["Done Canceling"] = ""
-- L["Done Posting"] = ""
-- L["Down"] = ""
-- L["Enable sounds"] = ""
-- L["Enter a gold value to set the buyout price of this item to. Must be in #g#s#c format (ie \"3g40s\")."] = ""
-- L["Existing Profiles"] = ""
-- L["Export"] = ""
-- L["Export Group Data"] = ""
-- L["Exports the data for this group. This allows you to share your group data with other TradeSkillMaster_Auctioning users."] = ""
-- L["Fallback price"] = ""
-- L["Finished Canceling"] = ""
-- L["Finished Posting"] = ""
-- L["Finished status report"] = ""
-- L["First Tab in Group / Category Settings"] = ""
-- L["Fixed Gold Amount"] = ""
-- L["General"] = ""
-- L["General Price Settings (Undercut / Bid)"] = ""
-- L["General Settings"] = ""
-- L["Group Data"] = ""
-- L["Group Overrides"] = ""
-- L["Group name"] = ""
-- L["Group named \"%s\" already exists! Item not added."] = ""
-- L["Group named \"%s\" does not exist! Item not added."] = ""
-- L["Group/Category named \"%s\" already exists!"] = ""
-- L["Groups in this Category:"] = ""
-- L["Help"] = ""
-- L["Hide Auctions"] = ""
-- L["Hide advanced options"] = ""
-- L["Hide help text"] = ""
-- L["Hide poor quality items"] = ""
-- L["Hides advanced auction settings. Provides for an easier learning curve for new users."] = ""
-- L["Hides all poor (gray) quality items from the 'Add items' pages."] = ""
-- L["Hides auction setting help text throughout the options."] = ""
-- L["How long auctions should be up for."] = ""
-- L["How low the market can go before an item should no longer be posted. The minimum price you want to post an item for."] = ""
-- L["How many auctions at the lowest price tier can be up at any one time."] = ""
-- L["How many items should be in a single auction, 20 will mean they are posted in stacks of 20."] = ""
--[==[ L[ [=[How much of a difference between auction prices should be allowed before posting at the second highest value.

For example. If Apple is posting Runed Scarlet Ruby at 50g, Orange posts one at 30g and you post one at 29g, then Oranges expires. If you set price threshold to 30% then it will cancel yours at 29g and post it at 49g next time because the difference in price is 42% and above the allowed threshold.]=] ] = "" ]==]
-- L["How much to undercut other auctions by, format is in \"#g#s#c\" but can be in any order, \"50g30s\" means 50 gold, 30 silver and so on."] = ""
--[==[ L[ [=[If the market price is above fallback price * maximum price, items will be posted at the fallback * maximum price instead.

Effective for posting prices in a sane price range when someone is posting an item at 5000g when it only goes for 100g.]=] ] = "" ]==]
-- L["If you don't have enough items for a full post, it will post with what you have."] = ""
-- L["Ignore low duration auctions"] = ""
-- L["Ignore stacks over"] = ""
-- L["Ignore stacks under"] = ""
-- L["Import Auctioning Group"] = ""
-- L["Import Group Data"] = ""
-- L["Important! Please read!"] = ""
-- L["Invalid category name."] = ""
-- L["Invalid group name."] = ""
-- L["Invalid monney format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = ""
-- L["Invalid percent format entered, should be \"#%\", \"105%\" is 105 percent."] = ""
-- L["Invalid time entered, should either be 12 or 2 you entered \"%s\""] = ""
-- L["Item failed to add to group."] = ""
-- L["Items in this group will not be posted or canceled automatically."] = ""
-- L["Items in this group:"] = ""
-- L["Items not in any group:"] = ""
-- L["Items that are stacked beyond the set amount are ignored when calculating the lowest market price."] = ""
-- L["Lists the current auctions for this item."] = ""
-- L["Log"] = ""
-- L["Macro Help"] = ""
-- L["Macro created and keybinding set!"] = ""
-- L["Management"] = ""
-- L["Mass cancelling posted items"] = ""
-- L["Mass cancelling posted items below %s"] = ""
-- L["Mass cancelling posted items in the group %s"] = ""
-- L["Mass cancelling posted items with less than %d hours left"] = ""
-- L["Maximum Price Settings (Fallback)"] = ""
-- L["Maximum price"] = ""
-- L["Maximum price gap"] = ""
-- L["Minimum Price Settings (Threshold)"] = ""
-- L["Modifiers:"] = ""
-- L["Name of the new category, this can be whatever you want and has no relation to how the category itself functions."] = ""
-- L["Name of the new group, this can be whatever you want and has no relation to how the group itself functions."] = ""
-- L["New"] = ""
-- L["New Buyout Price"] = ""
-- L["New category name"] = ""
-- L["New group name"] = ""
-- L["No auctions or inventory items found that are managed by Auction Profit Master that can be scanned."] = ""
-- L["No group named %s exists."] = ""
-- L["No name entered."] = ""
-- L["Nothing to cancel"] = ""
-- L["Nothing to cancel, you have no unsold auctions up."] = ""
-- L["Nothing to cancel. No matches found for \"%s\""] = ""
-- L["Number of Stacks: %s"] = ""
-- L["Opens the config window for TradeSkillMaster_Auctioning."] = ""
-- L["Options"] = ""
-- L["Overrides"] = ""
-- L["Per auction"] = ""
-- L["Percentage of the buyout as bid, if you set this to 90% then a 100g buyout will have a 90g bid."] = ""
-- L["Player name"] = ""
-- L["Plays the ready check sound when a post / cancel scan is complete and items are ready to be posting / canceled (the gray bar is all the way across)."] = ""
-- L["Post Auction %s / %s"] = ""
-- L["Post Settings (Quantity / Duration)"] = ""
-- L["Post at Fallback"] = ""
-- L["Post at Threshold"] = ""
-- L["Post cap"] = ""
-- L["Post time"] = ""
-- L["Posting"] = ""
-- L["Prevents Auctioneer from scanning while Auctioning is doing a scan."] = ""
-- L["Prevents the scanning of items in groups that are disabled (for post and cancel scans) or set to not auto cancel (for cancel scans only)."] = ""
-- L["Price threshold"] = ""
-- L["Price to fallback too if there are no other auctions up, the lowest market price is too high."] = ""
-- L["Profiles"] = ""
-- L["Quantity"] = ""
-- L["Rename"] = ""
-- L["Rename this category to something else!"] = ""
-- L["Rename this group to something else!"] = ""
-- L["Reset Profile"] = ""
-- L["Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."] = ""
-- L["Retry %s of %s for %s"] = ""
-- L["Right click to override this setting."] = ""
-- L["Right click to remove the override of this setting."] = ""
-- L["Run Status Scan"] = ""
-- L["SHIFT"] = ""
-- L["Save Price"] = ""
-- L["Scan finished!"] = ""
-- L["Scan interrupted before it could finish"] = ""
-- L["Scan interrupted due to Auction House being closed."] = ""
-- L["Scanned page %s of %s for %s"] = ""
-- L["Scanning"] = ""
-- L["Scanning %s"] = ""
-- L["Scanning page %s of %s for %s"] = ""
-- L["Scanning..."] = ""
-- L["ScrollWheel Direction (both recommended):"] = ""
-- L["Select Matches:"] = ""
-- L["Selects all items in either list matching the entered filter. Entering \"Glyph of\" will select any item with \"Glyph of\" in the name."] = ""
-- L["Seller"] = ""
-- L["Set fallback as a"] = ""
-- L["Set threshold as a"] = ""
-- L["Show Auctions"] = ""
-- L["Show group name in tooltip"] = ""
-- L["Shows the name of the group an item belongs to in that item's tooltip."] = ""
-- L["Skip Item"] = ""
-- L["Skip the current auction."] = ""
-- L["Skipped %s need %s for a single post, have %s"] = ""
-- L["Smart cancelling"] = ""
-- L["Smart scanning"] = ""
-- L["Stack Size: %s"] = ""
-- L["Stop Canceling"] = ""
-- L["Stop Posting"] = ""
-- L["Stop Scanning"] = ""
-- L["Stop the current scan."] = ""
--[==[ L[ [=[The below are fallback settings for groups, if you do not override a setting in a group then it will use the settings below.

Warning! All auction prices are per item, not overall. If you set it to post at a fallback of 1g and you post in stacks of 20 that means the fallback will be 20g.]=] ] = "" ]==]
-- L["The data you are trying to import is invalid."] = ""
-- L["The player \"%s\" is already on your blacklist."] = ""
-- L["The player \"%s\" is already on your whitelist."] = ""
-- L["There are two ways of making clicking the Post / Cancel Auction button easier. You can put %s and %s in a macro (on separate lines), or use the utility below to have a macro automatically made and bound to scrollwheel for you."] = ""
-- L["This dropdown determines what Auctioning will do when the market for an item goes below your threshold value. You can either not post the items or post at your fallback/threshold/a custom value."] = ""
-- L["This feature can be used to import groups from outside of the game. For example, if somebody exported their group onto a blog, you could use this feature to import that group and Auctioning would create a group with the same settings / items."] = ""
-- L["Total value of your auctions:"] = ""
--[==[ L[ [=[TradeSkillMaster_Auctioning has detected that you have APM/ZA/QA3 running.

Please disable APM/ZA/QA3 by clicking on the OK button below.]=] ] = "" ]==]
-- L["Uncategorized Groups:"] = ""
-- L["Undercut by"] = ""
-- L["Up"] = ""
-- L["Use per auction as cap"] = ""
--[==[ L[ [=[Welcome to TradeSkillMaster_Auctioning!

Please click on the OK button below to enable APM and then reload your UI so your settings can be transferred!]=] ] = "" ]==]
--[==[ L[ [=[Welcome to TradeSkillMaster_Auctioning!

Please click on the OK button below to transfer your settings, disable APM, and reload your UI!]=] ] = "" ]==]
-- L["When posting and canceling, ignore auctions with more than %s items or less than %s items in them. Ingoring the lowest auction if the price difference between the lowest two auctions is more than %s."] = ""
-- L["When posting, ignore auctions with more than %s items or less than %s items in them. Ingoring the lowest auction if the price difference between the lowest two auctions is more than %s. Items in this group will not be canceled automatically."] = ""
-- L["Whitelist"] = ""
-- L["Whitelists allow you to set other players besides you and your alts that you do not want to undercut; however, if somebody on your whitelist matches your buyout but lists a lower bid it will still consider them undercutting."] = ""
-- L["Will bind ScrollWheelDown (plus modifiers below) to the macro created."] = ""
-- L["Will bind ScrollWheelUp (plus modifiers below) to the macro created."] = ""
-- L["Will cancel auctions even if they have a bid on them, you will take an additional gold cost if you cancel an auction with bid."] = ""
-- L["Would you like to load these options in beginner or advanced mode? If you have not used APM, QA3, or ZA before, beginner is recommended. Your selection can always be changed using the \"Hide advanced options\" checkbox in the \"Options\" page."] = ""
-- L["You can change the active database profile, so you can have different settings for every character."] = ""
-- L["You can either create a new profile by entering a name in the editbox, or choose one of the already exisiting profiles."] = ""
-- L["You can enter a group name to cancel every item in that group, 12 or 2 to cancel every item with less than 12/2 hours left, enter a formatted price (ex. 1g50s) to cancel everything below that price, or leave the field blank to cancel every item you have on the auction house (even ones not in a group)."] = ""
-- L["You can not blacklist characters whom are on your whitelist."] = ""
-- L["You can not blacklist yourself."] = ""
-- L["You can not whitelist characters whom are on your blacklist."] = ""
-- L["You can set a fixed fallback price for this group, or have the fallback price be automatically calculated to a percentage of a value. If you have multiple different items in this group and use a percentage, the highest value will be used for the entire group."] = ""
-- L["You can set a fixed threshold price for this group, or have the threshold price be automatically calculated to a percentage of a value. If you have multiple different items in this group and use a percentage, the highest value will be used for the entire group."] = ""
-- L["You do not have any items to post"] = ""
-- L["You do not have any players on your blacklist yet."] = ""
-- L["You do not have any players on your whitelist yet."] = ""
-- L["You do not need to add \"%s\", alts are whitelisted automatically."] = ""
-- L["long (2 - 12 hours)"] = ""
-- L["medium (30 minutes - 2 hours)"] = ""
-- L["short (less than 30 minutes)"] = ""
