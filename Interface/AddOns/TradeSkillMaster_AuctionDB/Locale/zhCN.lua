-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_AuctionDB - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctiondb.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_AuctionDB Locale - zhCN
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_AuctionDB/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_AuctionDB", "zhCN")
if not L then return end

L["%s ago"] = "%s 之前" -- Needs review
L["<No Item SubType Filter>"] = "<无物品子类型过滤>" -- Needs review
L["<No Item Type Filter>"] = "<无物品类型过滤>" -- Needs review
L["Alchemy"] = "炼金术" -- Needs review
-- L["Any items in the AuctionDB database that contain the search phrase in their names will be displayed."] = ""
L["Are you sure you want to clear your AuctionDB data?"] = "你确定你要清除AuctionDB的数据吗?" -- Needs review
L["Ascending"] = "递增" -- Needs review
L["Auction house must be open in order to scan."] = "必须打开拍卖行才能扫描" -- Needs review
L["AuctionDB - Auction House Scanning"] = "AuctionDB - 拍卖行扫描" -- Needs review
L["AuctionDB - Run Scan"] = "AuctionDB - 开始扫描" -- Needs review
L["AuctionDB - Scanning"] = "AuctionDB - 扫描中" -- Needs review
L["AuctionDB Market Value:"] = "AuctionDB 市场价" -- Needs review
L["AuctionDB Min Buyout:"] = "AuctionDB 最低一口价" -- Needs review
L["AuctionDB Seen Count:"] = "AuctionDB 历史计数" -- Needs review
L["Blacksmithing"] = "锻造" -- Needs review
L["Block Auctioneer while Scanning."] = "在扫描时锁定 Auctioneer" -- Needs review
L["Complete AH Scan"] = "完全扫描" -- Needs review
L["Cooking"] = "烹饪" -- Needs review
L["Descending"] = "递减" -- Needs review
L["Enable display of AuctionDB data in tooltip."] = "在鼠标提示中显示AuctionDB数据" -- Needs review
L["Enchanting"] = "附魔" -- Needs review
L["Engineering"] = "工程学" -- Needs review
L["Error: AuctionHouse window busy."] = "错误：拍卖行窗口繁忙" -- Needs review
L["General Options"] = "常规选项" -- Needs review
L["GetAll Scan:"] = "快速扫描" -- Needs review
L["Hide poor quality items"] = "隐藏灰色物品" -- Needs review
L["If checked, Auctioneer will be prevented from scanning / processing AuctionDB's scans."] = "开启本选项,Auctioneer将无法干预AuctionDB的扫描." -- Needs review
L[ [=[If checked, a GetAll scan will be used whenever possible.

WARNING: With any GetAll scan there is a risk you may get disconnected from the game.]=] ] = "开启本选项，则每次可以运行快速扫描时都都使用快速扫描." -- Needs review
L["If checked, a regular scan will scan for this profession."] = "开启本选项，则使用更专业的常规扫描." -- Needs review
L["If checked, poor quality items won't be shown in the search results."] = "开启本选项,灰色物品将不在扫描结果中显示." -- Needs review
L["Inscription"] = "铭文" -- Needs review
L["Invalid value entered. You must enter a number between 5 and 500 inclusive."] = "输入错误,你必须输入一个5 - 500 之间的数字." -- Needs review
L["Item Link"] = "物品链接" -- Needs review
L["Item MinLevel"] = "最低物品等级" -- Needs review
L["Item SubType Filter"] = "物品子类型过滤" -- Needs review
L["Item Type Filter"] = "物品类型过滤" -- Needs review
L["Items %s - %s (%s total)"] = "物品 %s - %s (总数 %s) " -- Needs review
L["Items per page"] = "每页显示的物品" -- Needs review
L["Jewelcrafting"] = "珠宝加工" -- Needs review
L["Last Scanned"] = "最后一次扫描" -- Needs review
L["Leatherworking"] = "制皮" -- Needs review
L["Market Value"] = "市场价" -- Needs review
L["Minimum Buyout"] = "最低一口价" -- Needs review
L["Next Page"] = "下一页" -- Needs review
L["No items found"] = "未找到物品" -- Needs review
L["Not Ready"] = "还未就绪" -- Needs review
L["Nothing to scan."] = "未找到任何物品." -- Needs review
L["Opens the main TSM window to the AuctionDB page where you can search through AuctionDB's scan data to quickly lookup items in the AuctionDB database."] = "开打TSM主窗口的AuctionDB页面,你可以通过搜索AuctionDB的扫描数据来快速查看AuctionDB的数据." -- Needs review
L["Options"] = "选项" -- Needs review
L["Previous Page"] = "上一页" -- Needs review
L["Professions to scan for:"] = "专业扫描" -- Needs review
L["Ready"] = "准备完毕" -- Needs review
L["Ready in %s min and %s sec"] = "在%s分钟%s秒內完成" -- Needs review
L["Refresh"] = "刷新" -- Needs review
L["Refreshes the current search results."] = "刷新当前搜索结果." -- Needs review
L["Reset Data"] = "重置数据" -- Needs review
L["Resets AuctionDB's scan data"] = "重置AuctionDB扫描数据" -- Needs review
L["Run GetAll Scan"] = "进行快速扫描" -- Needs review
L["Run GetAll Scan if Possible"] = "如果可以,则进行快速扫描" -- Needs review
L["Run Regular Scan"] = "进行常规扫描" -- Needs review
L["Run Scan"] = "进行扫描" -- Needs review
L["Scan complete!"] = "扫描完成!" -- Needs review
L["Scan interupted due to auction house being closed."] = "因拍卖行窗口关闭而中断扫描." -- Needs review
L["Search"] = "搜索" -- Needs review
L["Search Options"] = "搜索选项" -- Needs review
L["Search Scan Data"] = "搜索扫描数据" -- Needs review
L["Seen Last Scan (Yours)"] = "查看最后一次扫描" -- Needs review
L["Select how you would like the search results to be sorted. After changing this option, you may need to refresh your search results by hitting the \"Refresh\" button."] = "将搜索结果按你的要求排序.改变该选项后,你可能需要点击\"刷新\"按钮来刷新搜索结果." -- Needs review
L["Sort items by"] = "排序物品按" -- Needs review
L["Sort search results in ascending order."] = "升序排列" -- Needs review
L["Sort search results in descending order."] = "降序排列" -- Needs review
L[ [=[Starts scanning the auction house based on the below settings.

If you are running a GetAll scan, your game client may temporarily lock up.]=] ] = [=[根据下面的设定扫描拍卖行.

如果你运行的是快速扫描,游戏可能会因此掉线.]=] -- Needs review
L["Tailoring"] = "裁缝" -- Needs review
L["This determines how many items are shown per page in results area of the \"Search\" tab of the AuctionDB page in the main TSM window. You may enter a number between 5 and 500 inclusive. If the page lags, you may want to decrease this number."] = "这个数字决定TSM主窗口中AuctionDB页面的\"搜索\"标签的搜索结果区域每页显示多少物品.你可以输入一个5到500之间的数字.如果你觉得页面很卡,你可能需要减小这个数字." -- Needs review
L["Use the search box and category filters above to search the AuctionDB data."] = "使用搜索框和过滤器来搜索AuctionDB数据." -- Needs review
L["You can filter the results by item subtype by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in the item type dropdown and \"Herbs\" in this dropdown."] = "你可以用这个下拉菜单来按物品子类型过滤搜索结果.例如,如果你想搜索所有的草药,你需要物品类型下拉菜单中选择\"商品\",并在物品子类型下拉菜单中选择\"草药\"." -- Needs review
L["You can filter the results by item type by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in this dropdown and \"Herbs\" as the subtype filter."] = "你可以用这个下拉菜单来按物品类型过滤搜索结果.例如,如果你想搜索所有的草药,你需要物品类型下拉菜单中选择\"商品\",并在物品子类型下拉菜单中选择\"草药\"." -- Needs review
L["You can use this page to lookup an item or group of items in the AuctionDB database. Note that this does not perform a live search of the AH."] = "你可以使用这个页面来查看AuctionDB数据库中的物品或者物品组.请注意,这并不是在拍卖行的实时搜索." -- Needs review
L["Your version of the main TradeSkillMaster addon is out of date. Please update it in order to be able to view this page."] = "你的TardeSkillMaster插件版本过低,请升级插件以查看该页面." -- Needs review
L["|cffff0000WARNING:|r As of 4.0.1 there is a bug with GetAll scans only scanning a maximum of 42554 auctions from the AH which is less than your auction house currently contains. As a result, thousands of items may have been missed. Please use regular scans until blizzard fixes this bug."] = "|cffff0000警告:|r 亲!在4.0.1有个关于快速扫描的BUG哦,扫描结果可能会遗漏很多物品,在坑爹的玻璃渣修复这个BUG前亲们还是用常规扫描吧." -- Needs review
 