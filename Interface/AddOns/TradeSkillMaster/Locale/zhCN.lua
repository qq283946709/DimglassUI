-- TradeSkillMaster Locale - zhCN
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkill-Master/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster", "zhCH")
if not L then return end

L["\"/tsm adbreset\" will reset AuctionDB's scan data. There is a confirmation prompt."] = "\"/tsm adbreset\" 重置AuctionDB的扫描数据。该操作将弹出确认框。"
L["%s/tsm help%s for a list of slash commands"] = "输入%s/tsm help%s获得指令列表"
L["%sDrag%s to move this button"] = "%s拖动%s以移动此按钮"
L["%sLeft-Click%s to open the main window"] = "%s鼠标左键点击%s来打开主窗口"
L["/tsm help|r - Shows this help listing"] = "/tsm help|r - 显示帮助列表"
L["/tsm|r - opens the main TSM window."] = "/tsm|r - 打开TSM主窗口."
L["Active Developers:"] = "活跃开发者:"
L["Alpha Testers:"] = "测试人员:"
L["Any craft that is disabled in the category pages of one of the Crafting profession icons in the main TSM window won't show up in the Craft Management Window."] = "一些已经在TSM主窗口专业技能图标下分类页面中禁用的制作条目不会显示在制作管理窗口。"
L["Auctinoing keeps a log of what it's doing during a post/cancel/status scan. Click on the \"Log\" button at the top of the Auctions tab of the AH to view it."] = "Auctioning在 发布/取消/状态 扫描的同时输出日志.点击拍卖行拍卖标签上方的\"日志\"按钮来查看."
L["AuctionDB can put market value, min buyout, and seen count info into item tooltips. You can turn this on / off in the options tab of the AuctionDB page."] = "AuctionDB可以在鼠标提示中显示物品的市场价值,最低一口价,统计数据.你可以在AuctionDB的设置页面开启或关闭这个功能."
L["Auctioning's CancelAll scan can be used to quickly cancel specific items. Anything from items under a certain duration to specific items, to entire groups."] = "Auctioning中的条件撤销可以快速撤销一些特殊物品, 像是在一定拍卖持续时间內的物品或某个群组中的所有物品。" -- Needs review
L["Author(s):"] = "作者:"
L["Automatically Open Sidebar"] = "自动打开侧边栏"
L["Contributing Developers (no longer active):"] = "有贡献者(非活跃)："
L["Crafting can make Auctioning groups for you. Just click on a profession icon, a category, and then the \"Create Auctioning Groups\" button."] = "Crafting可以为你建立制作群组, 只需要点击一个专业技能图标, 然后点击\"创建拍卖群组\"按钮即可。" -- Needs review
L["Crafting's on-hand queue will queue up the most profitable items you can make from the materials you have in your bags."] = "Crafting中的\"一键队列\"功能会根据你背包中持有的材料自动生成一份利润最大化的制作队列。" -- Needs review
L["Credits"] = "制作组"
L["Description:"] = "说明:"
L["Gathering can collect materials you need for your craft queue from your bank, guild bank, and alts."] = "Gathering可以为你的制造队列从银行,公会银行与小号收集必要的材料." -- Needs review
L["Gathering has an option for showing inventory info in item tooltips."] = "Gathering有一个选项使用鼠标提示来显示背包信息." -- Needs review
L["Have you tried running a GetAll scan? It's the fastest possible way to scan by far so give it a shot!"] = "试过运行快速扫描吗?它是最快的扫描方法,来试一试吧!" -- Needs review
L["Hide the TradeSkillMaster minimap icon."] = "隐藏TradeSkillMaster小地图图标"
L["If checked, the sidebar will open automatically whenever you open up the auction house window."] = "若勾选此项，你每次打开拍卖行时都将自动打开侧边栏"
L["If the Craft Management Window is too big, you can scale it down in the Crafting options."] = "如果制作管理窗口太大了, 你可以在制作选项中按比例缩小它."
L["Installed Modules"] = "已安装模块"
L["Lead Developer and Project Manager:"] = "主要开发者及项目负责人:"
L["Module:"] = "模块:"
L["No modules are currently loaded.  Enable or download some for full functionality!"] = "目前未加载任何模块.启用或下载一些模块以完善插件功能!" -- Needs review
L["Project Organizer / Resident Master Goblin:"] = "项目组织者/常驻大地精"
L["Provides the main central frame as well as APIs for all TSM modules."] = "为TSM所有模块提供主体框架及支持接口"
L["Slash Commands:"] = "快捷指令:" -- Needs review
L["Special thanks to our alpha testers:"] = "特别感谢我们的测试人员:"
L["Status"] = "状态"
L["The only required module of TradeSkillMaster is the main one (TradeSkillMaster). All others may be disabled if you are not using them."] = "TradeSkillMaster唯一的一个必須载入的模块只有TradeSkillMaster,所有其他模块在你不需要的情況下都可以关闭."
L["There is a checkbox for hiding the minimap icon in the status page of the main TSM window."] = "在TSM主窗口的概述页面有一个复选框可以隐藏TSM的小地图图标."
L["There is an option for hiding Auctioning's advanced options in the top \"Options\" page of the Auctioning page in the main TSM window."] = "有一个选项可关闭Auctioning的高级选项, 它位于TSM主窗口的Auctioning页面最上方\"选项\"中。" -- Needs review
L["TradeSkillMaster Info:"] = "TradeSkillMaster 信息:"
L["TradeSkillMaster Sidebar"] = "TradeSkillMaster 侧边栏" -- Needs review
L["TradeSkillMaster Team:"] = "TradeSkillMaster 开发组:"
L["Translators:"] = "翻译:"
L["Version:"] = "版本:"
L["Visit http://wow.curse.com/downloads/wow-addons/details/tradeskill-master.aspx for information about the different TradeSkillMaster modules as well as download links."] = "访问 http://wow.curse.com/downloads/wow-addons/details/tradeskill-master.aspx 以获取不同的TradeSkillMaster模块信息及其下载链接"
L["Want more tips? Click on the \"New Tip\" button at the bottom of the status page."] = "想要更多的小提示? 点击概述页面的\"新提示\"按钮即可。"
L["When using shopping to buy herbs for inks, it will automatically check if it's cheaper to buy herbs for blackfallow ink and trade down (this can be turned off)."] = "当使用Shopping来购买草药用于研磨制造墨水时, 插件会自动扫描是否购买制造秋闲墨水的原材料更便宜.(该功能可关闭)"
L["You can use the icons on the right side of this frame to quickly access auction house related functions for TradeSkillMaster modules."] = "你可以借助本窗口右边的图标来快速使用TradeSkillMaster模块中的拍卖行相关功能"
L["and many others"] = "及其他人" -- Needs review
