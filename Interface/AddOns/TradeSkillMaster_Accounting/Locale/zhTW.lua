-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Accounting - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/TradeSkillMaster_Accounting.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Accounting Locale - zhCN
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Accounting/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Accounting", "zhTW")
if not L then return end

L["%s ago"] = "%s 之前"
L["_ Hr _ Min ago"] = "_ 小时 _ 分钟以前"
L["<none>"] = "无"
L["Accounting"] = "财务部"
L["Activity Log"] = "活动日志"
L["Activity Type"] = "活动类别"
L["AuctionDB - Market Value"] = "市场分析部 - 市场价"
L["AuctionDB - Min Buyout"] = "市场分析部 - 最低一口价"
L["Auctionator - Auction Value"] = "Auctionator - 拍卖价"
L["Auctioneer - Appraiser"] = "Auctioneer - 评估价"
L["Auctioneer - Market Value"] = "Auctioneer - 市场价"
L["Auctioneer - Min Buyout"] = "Auctioneer - 最低一口价"
L["Auctions"] = "拍卖数量"
L["Average Prices:"] = "平均价格："
L["Avg Buy Price"] = "购买均价"
L["Avg Resale Profit"] = "重复出售的平均利润"
L["Avg Sell Price"] = "出售均价"
L["Back to Previous Page"] = "返回上一页"
L["Bought"] = "买入数量："
L["Buyer/Seller"] = "买家/卖家"
L["Click for a detailed report on this item."] = "点击生成该物品的报告。"
L["Common Quality Items"] = "白色物品"
L["DD/MM/YY HH:MM"] = "日/月/年 时:分"
L["Earned Per Day:"] = "每天赚取："
L["Epic Quality Items"] = "紫色物品"
L["General Options"] = "基本选项"
L["Gold Earned:"] = "赚取金币："
L["Gold Spent:"] = "花费金币："
L["If checked, the number you have purchased and the average purchase price will show up in an item's tooltip."] = "在物品的鼠标提示信息中显示该物的购买数量和它的购买均价。"
L["If checked, the number you have sold and the average sale price will show up in an item's tooltip."] = "在物品的鼠标提示信息中显示该物的销售数量和它的销售均价。"
L["Item Name"] = "物品名称"
L["Items"] = "物品"
L["Items NOT in an Auctioning Group"] = "物品不在销售部拍卖分组中"
L["Items in an Auctioning Group"] = "物品在销售部拍卖分组中"
L["Items/Resale Price Format"] = "物品/重复销售价格格式"
L["Last 30 Days:"] = "最近30天："
L["Last 7 Days:"] = "最近7天："
L["Last Purchase"] = "最近购买"
L["Last Sold"] = "最近售出"
L["MM/DD/YY HH:MM"] = "月/日/年 时:分"
L["Market Value"] = "市场价"
L["Market Value Source"] = "市场价来源"
L["Options"] = "选项"
L["Price Per Item"] = "单价"
L["Purchase"] = "购买"
L["Purchase Data"] = "购买数据"
L["Purchased (Avg Price): %s (%s)"] = "购入(均价): %s (%s)"
L["Purchases"] = "购买"
L["Quantity"] = "数量"
L["Quantity Bought:"] = "买入数量："
L["Quantity Sold:"] = "出售数量："
L["Rare Quality Items"] = "蓝色物品"
L["Resale"] = "重复出售"
L["Sale"] = "出售"
L["Sale Data"] = "出售数据"
L["Sales"] = "卖出"
L["Search"] = "搜索"
L["Select how you would like prices to be shown in the \"Items\" and \"Resale\" tabs; either average price per item or total value."] = "选择\"物品\"和\"重复销售\"选项页中的价格格式以何种方式呈现。可以是均价或总价。"
L["Select what format Accounting should use to display times in applicable screens."] = "选择以何种格式在插件上呈现。"
L["Select where you want Accounting to get market value info from to show in applicable screens."] = "插件显示的市场价从哪里获取。"
L["Show purchase info in item tooltips"] = "在物品的鼠标提示信息中显示它的购买情况。"
L["Show sale info in item tooltips"] = "在物品的鼠标提示信息中显示它的销售情况。"

L["Sold"] = "已售出"
L["Sold (Avg Price): %s (%s)"] = "售出(均价): %s (%s)"
L["Special Filters"] = "指定过滤条件"
L["Spent Per Day:"] = "每天花费："
L["Stack Size"] = "堆叠数量"
L["Summary"] = "摘要"
L["TheUndermineJournal - Market Price"] = "TheUndermineJournal - 市场价"
L["TheUndermineJournal - Mean"] = "TheUndermineJournal - 均价"
L["There is no purchase data for this item."] = "该物品的未购买数据。"
L["There is no sale data for this item."] = "该物品的出售数据。"
L["Time"] = "时间"
L["Time Format"] = "时间格式"
L["Tooltip Options"] = "提示信息选项"
L["Top Buyers:"] = "买家排名："
L["Top Item by Gold:"] = "物品价值排名："
L["Top Item by Quantity:"] = "物品数量排名："
L["Top Sellers:"] = "卖家排名："
L["Total Buy Price"] = "购买总价"
L["Total Price"] = "总价"
L["Total Sale Price"] = "出售总价"
L["Total Spent:"] = "总花费:"
L["Total Value"] = "总价"

L["Total:"] = "全部:"
L["TradeSkillMaster_Accounting has detected that you have MySales installed. Would you like to transfer your data over to Accounting?"] = "检测到安装了 MySales 插件，是否将数据导入到财务部？"
L["Uncommon Quality Items"] = "绿色物品"
L["YY/MM/DD HH:MM"] = "年/月/日 时:分"



