-- TradeSkillMaster Locale - enUS
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkill-Master/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster", "enUS", true)
if not L then return end

-- TradeSkillMaster.lua
L["%sLeft-Click%s to open the main window"] = true
L["%sDrag%s to move this button"] = true
L["%s/tsm help%s for a list of slash commands"] = true
L["TradeSkillMaster Info:"] = true
L["Slash Commands:"] = true
L["/tsm|r - opens the main TSM window."] = true
L["/tsm help|r - Shows this help listing"] = true
L["Installed Modules"] = true
L["Module:"] = true
L["Version:"] = true
L["Author(s):"] = true
L["Description:"] = true
L["No modules are currently loaded.  Enable or download some for full functionality!"] = true
L["Visit http://wow.curse.com/downloads/wow-addons/details/tradeskill-master.aspx for information about the different TradeSkillMaster modules as well as download links."] = true
L["Credits"] = true
L["TradeSkillMaster Team:"] = true
L["Lead Developer and Project Manager:"] = true
L["Project Organizer / Resident Master Goblin:"] = true
L["Active Developers:"] = true
L["Contributing Developers (no longer active):"] = true
L["Translators:"] = true
L["Special thanks to our alpha testers:"] = true
L["Alpha Testers:"] = true
L["and many others"] = true
L["Status"] = true
L["Provides the main central frame as well as APIs for all TSM modules."] = true
L["Hide the TradeSkillMaster minimap icon."] = true

-- Remote.lua
L["TradeSkillMaster Sidebar"] = true
L["You can use the icons on the right side of this frame to quickly access auction house related functions for TradeSkillMaster modules."] = true
L["Automatically Open Sidebar"] = true
L["If checked, the sidebar will open automatically whenever you open up the auction house window."] = true

-- Tips.lua
L["There is a checkbox for hiding the minimap icon in the status page of the main TSM window."] = true
L["The only required module of TradeSkillMaster is the main one (TradeSkillMaster). All others may be disabled if you are not using them."] = true
L["Want more tips? Click on the \"New Tip\" button at the bottom of the status page."] = true
L["Have you tried running a GetAll scan? It's the fastest possible way to scan by far so give it a shot!"] = true
L["AuctionDB can put market value, min buyout, and seen count info into item tooltips. You can turn this on / off in the options tab of the AuctionDB page."] = true
L["\"/tsm adbreset\" will reset AuctionDB's scan data. There is a confirmation prompt."] = true
L["Auctioning's CancelAll scan can be used to quickly cancel specific items. Anything from items under a certain duration to specific items, to entire groups."] = true
L["Auctioning keeps a log of what it's doing during a post/cancel/status scan. Click on the \"Log\" button at the top of the Auctions tab of the AH to view it."] = true
L["There is an option for hiding Auctioning's advanced options in the top \"Options\" page of the Auctioning page in the main TSM window."] = true
L["If the Craft Management Window is too big, you can scale it down in the Crafting options."] = true
L["Crafting can make Auctioning groups for you. Just click on a profession icon, a category, and then the \"Create Auctioning Groups\" button."] = true
L["Any craft that is disabled in the category pages of one of the Crafting profession icons in the main TSM window won't show up in the Craft Management Window."] = true
L["Crafting's on-hand queue will queue up the most profitable items you can make from the materials you have in your bags."] = true
L["Gathering can collect materials you need for your craft queue from your bank, guild bank, and alts."] = true
L["Gathering has an option for showing inventory info in item tooltips."] = true
L["When using shopping to buy herbs for inks, it will automatically check if it's cheaper to buy herbs for blackfallow ink and trade down (this can be turned off)."] = true