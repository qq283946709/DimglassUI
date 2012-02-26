﻿-- ------------------------------------------------------------------------------------- --
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

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_AuctionDB", "zhTW")
if not L then return end

L["%s ago"] = "%s 以前"
L["|cffff0000WARNING:|r As of 4.0.1 there is a bug with GetAll scans only scanning a maximum of 42554 auctions from the AH which is less than your auction house currently contains. As a result, thousands of items may have been missed. Please use regular scans until blizzard fixes this bug."] ="|cffff0000警告：|r4.0.1版本的全部扫描存在一个bug，它最多只能扫描到42554个拍卖，更多的拍卖将无法显示。在暴雪修复此bug前最好使用定期扫描。"
L["<No Item SubType Filter>"] = "<不过滤>"
L["<No Item Type Filter>"] = "<不过滤>"
L["Alchemy"] = "炼金"
L["Any items in the AuctionDB database that contain the search phrase in their names will be displayed."] = "显示拍卖行数据库中的所有物品，包括它们的名称和描述。"
L["Are you sure you want to clear your AuctionDB data?"] = "确定要清除你的市场分析部扫描的数据？"
L["Ascending"] = "顺序"
L["Auction house must be open in order to scan."] = "扫描时必须打开拍卖行。"
L["AuctionDB - Auction House Scanning"] = "扫描拍卖行"
L["AuctionDB - Run Scan"] = "市场分析部-扫描市场"
L["AuctionDB - Scanning"] = "扫描中"
L["AuctionDB Market Value:"] = "市场分析部 市场价："
L["AuctionDB Min Buyout:"] = "市场分析部 最低一口价："
L["AuctionDB Seen Count:"] = "市场分析部 扫描到的数量："
L["AuctionDB"] = "市场分析部"
L["Blacksmithing"] = "锻造"
L["Block Auctioneer while Scanning."] = "扫描时屏蔽 Auctioneer 插件。"
L["Complete AH Scan"] = "拍卖行扫描完毕"
L["Cooking"] = "烹饪"
L["Descending"] = "倒序"
L["Enable display of AuctionDB data in tooltip."] = "在鼠标提示中显示拍卖行数据库的数据。"
L["Enchanting"] = "附魔"
L["Engineering"] = "工程学"
L["Error: AuctionHouse window busy."] = "错误：拍卖行窗口正忙。"
L["General Options"] = "通用设置"
L["GetAll Scan:"] = "全部扫描："
L["Hide poor quality items"] = "隐藏灰色物品"
L["If checked, a GetAll scan will be used whenever possible.\n\nWARNING: With any GetAll scan there is a risk you may get disconnected from the game."] = "选中后每次扫描均启用全部扫描。\n\n警告：全部扫描可能会使你的游戏掉线。"
L["If checked, a regular scan will scan for this profession."] = "选中后将对当前的专业进行定期扫描。"
L["If checked, Auctioneer will be prevented from scanning / processing AuctionDB's scans."] = "防止 Auctioneer 插件在本插件扫描/处理时工作，影响速度。"
L["If checked, poor quality items won't be shown in the search results."] = "选中将不在搜索结果中显示灰色物品。"
L["Inscription"] = "铭文学"
L["Invalid value entered. You must enter a number between 5 and 500 inclusive."] = "输入无效，只允许输入5至500之间的数字。"
L["Item Link"] = "物品连接"
L["Item MinLevel"] = "物品最低等级"
L["Item SubType Filter"] = "子分类过滤"
L["Item Type Filter"] = "分类过滤"
L["Items %s - %s (%s total)"] = "物品数 %s - %s (总共 %s)"
L["Items per page"] = "每页物品数"
L["Jewelcrafting"] = "珠宝加工"
L["Last Scanned"] = "最后扫描"
L["Leatherworking"] = "制皮"
L["Market Value"] = "市场价"
L["Minimum Buyout"] = "最小一口价"
L["Next Page"] = "下一页"
L["No items found"] = "未找到物品"
L["Not Ready"] = "未准备好"
L["Notes"] = "扫描市场并分析市场价。"
L["Nothing to scan."] = "没数据可扫描。"
L["Num(Yours)"] = "数量(你的)"
L["Opens the main TSM window to the AuctionDB page where you can search through AuctionDB's scan data to quickly lookup items in the AuctionDB database."] = "打开市场分析部主窗口，你可以通过它快速的浏览市场上物品的相关数据。"
L["Options"] = "选项"
L["Previous Page"] = "上一页"
L["Professions to scan for:"] = "专业扫描："
L["Ready in %s min and %s sec"] = " %s 分 %s 秒后准备就绪"
L["Ready"] = "准备就绪"
L["Refresh"] = "刷新"
L["Refreshes the current search results."] = "刷新当前搜索结果。"
L["Reset Data"] = "重置数据"
L["Resets AuctionDB's scan data"] = "重置市场分析数据"
L["Run GetAll Scan if Possible"] = "全部扫描(假设可用)"
L["Run GetAll Scan"] = "运行全部扫描"
L["Run Regular Scan"] = "运行定期扫描"
L["Run Scan"] = "运行扫描"
L["Scan complete!"] = "扫描完毕！"
L["Scan interupted due to auction house being closed."] = "拍卖行被关闭，扫描中断。"
L["Search Options"] = "搜索选项"
L["Search Scan Data"] = "搜索扫描数据"
L["Search"] = "搜索"
L["Select how you would like the search results to be sorted. After changing this option, you may need to refresh your search results by hitting the \"Refresh\" button."] = "选择你喜欢的排序方式。改变排序方式后，必须点击\"更新\"按钮来更新你的搜索结果。"
L["Sort items by"] = "物品排序方式为"
L["Sort search results in ascending order."] = "按顺序排列搜索结果。"
L["Sort search results in descending order."] = "按倒序排列搜索结果。"
L["Starts scanning the auction house based on the below settings.\n\nIf you are running a GetAll scan, your game client may temporarily lock up."] = "基于下列设置开始扫描拍卖行。\n\n如果运行全部扫描，游戏可能会暂时锁定。"
L["Tailoring"] = "裁缝"
L["This determines how many items are shown per page in results area of the \"Search\" tab of the AuctionDB page in the main TSM window. You may enter a number between 5 and 500 inclusive. If the page lags, you may want to decrease this number."] = "设定\"搜索\"标签的搜索结果页的每页可显示条目数，可以是5至500之间的任何数。"
L["Use the search box and category filters above to search the AuctionDB data."] = "使用上面的搜索框和分类过滤条件来搜索拍卖行数据库的数据。"
L["You can filter the results by item subtype by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in the item type dropdown and \"Herbs\" in this dropdown."] = "使用分类过滤，可以缩小搜索范围。如你只想搜索草药，在分类过滤中选择\"商品\"，然后在子分类过滤中选择\"草药\"。"
L["You can filter the results by item type by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in this dropdown and \"Herbs\" as the subtype filter."] = "使用分类过滤，可以缩小搜索范围。如你只想搜索草药，在分类过滤中选择\"商品\"，然后在子分类过滤中选择\"草药\"。"
L["You can use this page to lookup an item or group of items in the AuctionDB database. Note that this does not perform a live search of the AH."] = "你可以用这个页面来查看一项或者一组物品的拍卖行数据库信息。【注意】这并不执行拍卖行的即时扫描。"
L["Your version of the main TradeSkillMaster addon is out of date. Please update it in order to be able to view this page."] = "你的 TSM 插件已经过期，请更新以查看本页。"
