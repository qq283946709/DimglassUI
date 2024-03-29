local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Auctioning", "enUS", true)
if not L then return end

-- TradeSkillMaster_Auctioning.lua
L["Auctioning Groups/Options"] = true
L["Welcome to TradeSkillMaster_Auctioning!\n\nPlease click on the OK button below to enable APM and then reload your UI so your settings can be transferred!"] = true
L["Welcome to TradeSkillMaster_Auctioning!\n\nPlease click on the OK button below to transfer your settings, disable APM, and reload your UI!"] = true
L["TradeSkillMaster_Auctioning has detected that you have APM/ZA/QA3 running.\n\nPlease disable APM/ZA/QA3 by clicking on the OK button below."] = true
L["Important! Please read!"] = true
L["Group named \"%s\" already exists! Item not added."] = true
L["Group named \"%s\" does not exist! Item not added."] = true
L["Item failed to add to group."] = true
L["Auctioning Group:"] = true
L["Import Group Data"] = true
L["Don't Import Already Grouped Items"] = true
L["Group Data"] = true
L["The data you are trying to import is invalid."] = true
L["Data Imported to Group: %s"] = true
L["Import Auctioning Group"] = true

-- cancel.lua
L["Cancelled %s"] = true
L["Nothing to cancel. No matches found for \"%s\""] = true
L["Nothing to cancel"] = true
L["Invalid time entered, should either be 12, 2, or .5 you entered \"%s\""] = true
L["No group named %s exists."] = true
L["Mass cancelling posted items with less than %d hours left"] = true
L["Mass cancelling posted items in the group %s"] = true
L["Mass cancelling posted items below %s"] = true
L["Mass cancelling posted items"] = true
L["Nothing to cancel, you have no unsold auctions up."] = true
L["Scanning"] = true
L["Canceling"] = true
L["Cancel Auction %s / %s"] = true
L["Stack Size: %s"] = true
L["Bid: %s"] = true
L["Buyout: %s"] = true
L["Finished Canceling"] = true

-- post.lua
L["You do not have any items to post"] = true
L["Posting"] = true
L["Did not post %s because your fallback (%s) is invalid. Check your settings."] = true
L["Did not post %s because your threshold (%s) is invalid. Check your settings."] = true
L["Did not post %s because your fallback (%s) is lower than your threshold (%s). Check your settings."] = true
L["Scanning %s"] = true
L["Skipped %s need %s for a single post, have %s"] = true
L["Post Auction %s / %s"] = true
L["Number of Stacks: %s"] = true
L["Finished Posting"] = true
L["Total value of your auctions:"] = true

-- status.lua
L["No auctions or inventory items found that are managed by Auction Profit Master that can be scanned."] = true
L["Retry %s of %s for %s"] = true
L["Scanning page %s of %s for %s"] = true
L["Scanned page %s of %s for %s"] = true
L["Scanning %s"] = true
L["Scan interrupted before it could finish"] = true
L["Scan finished!"] = true
L["Cannot find data for %s."] = true
L["Finished status report"] = true

-- manage.lua
L["Auctioning - Post"] = true
L["Auctioning - Cancel"] = true
L["Auctioning - Cancel All"] = true
L["Auctioning - Status/Config"] = true
L["Scanning..."] = true
L["Done Posting"] = true
L["Done Canceling"] = true
L["Auctioning - Post Scan"] = true
L["Auctioning - Cancel Scan"] = true
L["Stop Scanning"] = true
L["Stop the current scan."] = true
L["Auctioning - Cancel All Scan"] = true
L["Cancel Match - Cancel all items that match the specified filter."] = true
L["Cancel Items Matching:"] = true
L["Any of your auctions which match this text will be canceled. For example, if you enter \"glyph\", any item with \"glyph\" in its name will be canceled (even ones not in a group)."] = true
L["Cancel Matching Items"] = true
L["Cancel all auctions according to the filter."] = true
L["Cancel All - Cancel all active items, those in a specified group, or those with a specified time left."] = true
L["Cancel All Filter:"] = true
L["You can enter a group name to cancel every item in that group, 12, 2, or 0.5 to cancel every item with less than 12/2/0.5 hours left, enter a formatted price (ex. 1g50s) to cancel everything below that price, or leave the field blank to cancel every item you have on the auction house (even ones not in a group)."] = true
L["Cancel All Items"] = true
L["Cancel all auctions according to the filter. If the editbox is blank, everything will be canceled."] = true
L["Auctioning - Status Scan / Config"] = true
L["Run Status Scan"] = true
L["Does a status scan that helps to identify auctions you can buyout to raise the price of a group you're managing.\n\nThis will NOT automatically buy items for you, all it tells you is the lowest price and how many are posted."] = true
L["Config"] = true
L["Opens the config window for TradeSkillMaster_Auctioning."] = true
L["Show Auctions"] = true
L["Lists the current auctions for this item."] = true
L["Change Post Price"] = true
L["Allows you to manually adjust the buyout price you want to post this item for. This is a one-time adjustment and will no effect your settings."] = true
L["New Buyout Price"] = true
L["Enter a gold value to set the buyout price of this item to. Must be in #g#s#c format (ie \"3g40s\")."] = true
L["Save Price"] = true
L["Hide Auctions"] = true
L["Close this window and save the price entered above as the new buyout price (new bid calculated automatically)."] = true
L["Close this window and discard the price entered above."] = true
L["Seller"] = true
L["Quantity"] = true
L["Buyout Per Item"] = true
L["Skip Item"] = true
L["Skip the current auction."] = true
L["Stop Posting"] = true
L["Stop Canceling"] = true
L["Stop the current scan."] = true
L["Clicking this will post auctions based on the data scanned."] = true
L["Clicking this will cancel auctions based on the data scanned."] = true
L["Log"] = true
L["Displays the Auctioning log describing what it's currently scanning, posting or cancelling."] = true

-- scan.lua
L["Scan interrupted due to Auction House being closed."] = true

-- config.lua
L["Would you like to load these options in beginner or advanced mode? If you have not used APM, QA3, or ZA before, beginner is recommended. Your selection can always be changed using the \"Hide advanced options\" checkbox in the \"Options\" page."] = true
L["Beginner"] = true
L["Advanced"] = true
L["Options"] = true
L["Categories / Groups"] = true
L["<Uncategorized Groups>"] = true
L["General"] = true
L["Whitelist"] = true
L["Profiles"] = true
L["Auction Defaults"] = true
L["Create Category / Group"] = true
L["Group Overrides"] = true
L["Management"] = true
L["Add/Remove Items"] = true
L["Category Overrides"] = true
L["Add/Remove Groups"] = true
L["Hide help text"] = true
L["Hides auction setting help text throughout the options."] = true
L["Hide advanced options"] = true
L["Hides advanced auction settings. Provides for an easier learning curve for new users."] = true
L["Hide poor quality items"] = true
L["Hides all poor (gray) quality items from the 'Add items' pages."] = true
L["Smart scanning"] = true
L["Prevents the scanning of items in groups that are disabled (for post and cancel scans) or set to not auto cancel (for cancel scans only)."] = true
L["Enable sounds"] = true
L["Plays the ready check sound when a post / cancel scan is complete and items are ready to be posting / canceled (the gray bar is all the way across)."] = true
L["Block Auctioneer while scanning"] = true
L["Prevents Auctioneer from scanning while Auctioning is doing a scan."] = true
L["Show group name in tooltip"] = true
L["Shows the name of the group an item belongs to in that item's tooltip."] = true
L["Smart group creation"] = true
L["If enabled, when you create a new group, your bags will be scanned for items with names that include the name of the new group. If such items are found, they will be automatically added to the new group."] = true
L["First Tab in Group / Category Settings"] = true
L["Add/Remove"] = true
L["Overrides"] = true
L["Determines which order the group / category settings tabs will appear in."] = true
L["Cancel auctions with bids"] = true
L["Will cancel auctions even if they have a bid on them, you will take an additional gold cost if you cancel an auction with bid."] = true
L["Smart cancelling"] = true
L["Disables cancelling of auctions with a market price below the threshold, also will cancel auctions if you are the only one with that item up and you can relist it for more."] = true
L["Macro Help"] = true
L["There are two ways of making clicking the Post / Cancel Auction button easier. You can put %s and %s in a macro (on separate lines), or use the utility below to have a macro automatically made and bound to scrollwheel for you."] = true
L["ScrollWheel Direction (both recommended):"] = true
L["Up"] = true
L["Will bind ScrollWheelUp (plus modifiers below) to the macro created."] = true
L["Down"] = true
L["Will bind ScrollWheelDown (plus modifiers below) to the macro created."] = true
L["Modifiers:"] = true
L["ALT"] = true
L["CTRL"] = true
L["SHIFT"] = true
L["Create Macro and Bind ScrollWheel (with selected options)"] = true
L["Macro created and keybinding set!"] = true
L["Right click to override this setting."] = true
L["Right click to remove the override of this setting."] = true
L["Items in this group will not be posted or canceled automatically."] = true
L["When posting, ignore auctions with more than %s items or less than %s items in them. Ignoring the lowest auction if the price difference between the lowest two auctions is more than %s. Items in this group will not be canceled automatically."] = true
L["When posting and canceling, ignore auctions with more than %s item(s) or less than %s item(s) in them. Ignoring the lowest auction if the price difference between the lowest two auctions is more than %s."] = true
L["Auctions will be posted for %s hours in stacks of up to %s. A maximum of %s auctions will be posted."] = true
L["Auctions will be posted for %s hours in stacks of %s. A maximum of %s auctions will be posted."] = true
L["Auctioning will undercut your competition by %s. When posting, the bid of your auctions will be set to %s percent of the buyout."] = true
L["Auctioning will never post your auctions for below %s."] = true
L["Auctioning will follow the 'Advanced Price Settings' when the market goes below %s."] = true
L["Auctioning will post at %s when you are the only one posting below %s."] = true
L["Auctions will not be posted when the market goes below your threshold."] = true
L["Auctions will be posted at your threshold price of %s when the market goes below your threshold."] = true
L["Auctions will be posted at your fallback price of %s when the market goes below your threshold."] = true
L["Auctions will be posted at %s when the market goes below your threshold."] = true
L["Auctions will be posted at a price such that they are undercutting the cheapest auction above your threshold when the market goes below your threshold."] = true
L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = true
L["Invalid percent format entered, should be \"#%\", \"105%\" is 105 percent."] = true
L["Fixed Gold Amount"] = true
L["% of Auctioneer Market Value"] = true
L["% of Auctioneer Appraiser"] = true
L["% of Auctioneer Minimum Buyout"] = true
L["% of AuctionDB Market Value"] = true
L["% of AuctionDB Minimum Buyout"] = true
L["% of Crafting cost"] = true
L["% of ItemAuditor cost"] = true
L["% of TheUndermineJournal Market Price"] = true
L["% of TheUndermineJournal Mean"] = true
L["Help"] = true
L["The below are fallback settings for groups, if you do not override a setting in a group then it will use the settings below.\n\nWarning! All auction prices are per item, not overall. If you set it to post at a fallback of 1g and you post in stacks of 20 that means the fallback will be 20g."] = true
L["General Settings"] = true
L["Ignore stacks under"] = true
L["Items that are stacked beyond the set amount are ignored when calculating the lowest market price."] = true
L["Ignore stacks over"] = true
L["Items that are stacked beyond the set amount are ignored when calculating the lowest market price."] = true
L["Maximum price gap"] = true
L["How much of a difference between auction prices should be allowed before posting at the second highest value.\n\nFor example. If Apple is posting Runed Scarlet Ruby at 50g, Orange posts one at 30g and you post one at 29g, then Oranges expires. If you set price threshold to 30% then it will cancel yours at 29g and post it at 49g next time because the difference in price is 42% and above the allowed threshold."] = true
L["Ignore low duration auctions"] = true
L["<none>"] = true
L["short (less than 30 minutes)"] = true
L["medium (30 minutes - 2 hours)"] = true
L["long (2 - 12 hours)"] = true
L["Any auctions at or below the selected duration will be ignored. Selecting \"<none>\" will cause no auctions to be ignored based on duration."] = true
L["Disable auto cancelling"] = true
L["Disable automatically cancelling of items in this group if undercut."] = true
L["Disable posting and canceling"] = true
L["Completely disables this group. This group will not be scanned for and will be effectively invisible to Auctioning."] = true
L["Post Settings (Quantity / Duration)"] = true
L["Post time"] = true
L["12 hours"] = true
L["24 hours"] = true
L["48 hours"] = true
L["How long auctions should be up for."] = true
L["Post cap"] = true
L["How many auctions at the lowest price tier can be up at any one time."] = true
L["Per auction"] = true
L["How many items should be in a single auction, 20 will mean they are posted in stacks of 20."] = true
L["Use per auction as cap"] = true
L["If you don't have enough items for a full post, it will post with what you have."] = true
L["General Price Settings (Undercut / Bid)"] = true
L["Undercut by"] = true
L["How much to undercut other auctions by, format is in \"#g#s#c\" but can be in any order, \"50g30s\" means 50 gold, 30 silver and so on."] = true
L["Bid percent"] = true
L["Percentage of the buyout as bid, if you set this to 90% then a 100g buyout will have a 90g bid."] = true
L["Minimum Price Settings (Threshold)"] = true
L["Price threshold"] = true
L["How low the market can go before an item should no longer be posted. The minimum price you want to post an item for."] = true
L["Set threshold as a"] = true
L["You can set a fixed threshold price for this group, or have the threshold price be automatically calculated to a percentage of a value. If you have multiple different items in this group and use a percentage, the highest value will be used for the entire group."] = true
L["Maximum Price Settings (Fallback)"] = true
L["Fallback price"] = true
L["Price to fallback too if there are no other auctions up, the lowest market price is too high."] = true
L["Set fallback as a"] = true
L["You can set a fixed fallback price for this group, or have the fallback price be automatically calculated to a percentage of a value. If you have multiple different items in this group and use a percentage, the highest value will be used for the entire group."] = true
L["Maximum price"] = true
L["If the market price is above fallback price * maximum price, items will be posted at the fallback * maximum price instead.\n\nEffective for posting prices in a sane price range when someone is posting an item at 5000g when it only goes for 100g."] = true
L["Advanced Price Settings (Market Reset)"] = true
L["Don't Post Items"] = true
L["Post at Threshold"] = true
L["Post at Fallback"] = true
L["Custom Value"] = true
L["This dropdown determines what Auctioning will do when the market for an item goes below your threshold value. You can either not post the items or post at your fallback/threshold/a custom value."] = true
L["Custom Reset Price (gold)"] = true
L["Custom market reset price. If the market goes below your threshold, items will be posted at this price."] = true
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
L["Current Profile:"] = true
L["Are you sure you want to delete the selected profile?"] = true
L["Added %s items to %s automatically because they contained the group name in their name. You can turn this off in the options."] = true
L["Added the following items to %s automatically because they contained the group name in their name. You can turn this off in the options."] = true
L["Invalid Group / Category name!"] = true
L["Add group"] = true
L["A group contains items that you wish to sell with similar conditions (stack size, fallback price, etc).  Default settings may be overridden by a group's individual settings."] = true
L["Group name"] = true
L["Name of the new group, this can be whatever you want and has no relation to how the group itself functions."] = true
L["Import Auctioning Group"] = true
L["This feature can be used to import groups from outside of the game. For example, if somebody exported their group onto a blog, you could use this feature to import that group and Auctioning would create a group with the same settings / items."] = true
L["Add category"] = true
L["A category contains groups with similar settings and acts like an organizational folder. You may override default settings by category (and then override category settings by group)."] = true
L["Category name"] = true
L["Name of the new category, this can be whatever you want and has no relation to how the category itself functions."] = true
L["No name entered."] = true
L["The player \"%s\" is already on your whitelist."] = true
L["You can not whitelist characters whom are on your blacklist."] = true
L["You do not need to add \"%s\", alts are whitelisted automatically."] = true
L["Whitelists allow you to set other players besides you and your alts that you do not want to undercut; however, if somebody on your whitelist matches your buyout but lists a lower bid it will still consider them undercutting."] = true
L["Add player"] = true
L["Player name"] = true
L["Add a new player to your whitelist."] = true
L["Delete"] = true
L["You do not have any players on your whitelist yet."] = true
L["Blacklist"] = true
L["The player \"%s\" is already on your blacklist."] = true
L["You can not blacklist characters whom are on your whitelist."] = true
L["You can not blacklist yourself."] = true
L["Blacklists allows you to undercut a competitor no matter how low their threshold may be. If the lowest auction of an item is owned by somebody on your blacklist, your threshold will be ignored for that item and you will undercut them regardless of whether they are above or below your threshold."] = true
L["Add a new player to your blacklist."] = true
L["You do not have any players on your blacklist yet."] = true
L["Group/Category named \"%s\" already exists!"] = true
L["Invalid group name."] = true
L["Are you SURE you want to delete this group?"] = true
L["Rename"] = true
L["New group name"] = true
L["Rename this group to something else!"] = true
L["Delete group"] = true
L["Delete this group, this cannot be undone!"] = true
L["Export"] = true
L["Export Group Data"] = true
L["Exports the data for this group. This allows you to share your group data with other TradeSkillMaster_Auctioning users."] = true
L["Items not in any group:"] = true
L["Items in this group:"] = true
L["Select Matches:"] = true
L["Selects all items in either list matching the entered filter. Entering \"Glyph of\" will select any item with \"Glyph of\" in the name."] = true
L["Invalid category name."] = true
L["Are you SURE you want to delete this category?"] = true
L["Are you SURE you want to delete all the groups in this category?"] = true
L["New category name"] = true
L["Rename this category to something else!"] = true
L["Delete this category, this cannot be undone!"] = true
L["Delete category"] = true
L["Delete All Groups In Category"] = true
L["Delete all groups inside this category. This cannot be undone!"] = true
L["Uncategorized Groups:"] = true
L["Groups in this Category:"] = true