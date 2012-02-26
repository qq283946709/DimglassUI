-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Crafting - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_crafting.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Crafting Locale - zhCN
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Crafting/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Crafting", "zhCH")
if not L then return end

L["%s not queued! Min restock of %s is higher than max restock of %s"] = "%s 不制造！最小的补货量%s比最大补货量%s大" -- Needs review
L["2H Weapon"] = "双手武器"
L["AH/Bags/Bank/Alts"] = "AH/背包/银行/小号"
L["Accept"] = "接受" -- Needs review
L["Add Crafted Items from this Group to Auctioning Groups"] = "添加该分组中已制造物品到 Auctioning 拍卖分组"
L["Add Item to New Group"] = "添加物品到新的分组"
L["Add Item to Selected Group"] = "添加物品到所选分组" -- Needs review
L["Add Item to TSM_Auctioning"] = "添加物品至TSM_Auctioning"
L["Added %s crafted items to %s individual groups."] = "新增 %s 已制造物品到单独的分组 %s 。"
L["Added %s crafted items to: %s."] = "新增 %s 已制造物品到：%s。"
L["Additional Item Settings"] = "额外设置" -- Needs review
L["Addon to use for alt data:"] = "插件使用小号数据：" -- Needs review
L["Adds all items in this Crafting group to Auctioning group(s) as per the above settings."] = "参照上面的设置添加该制造项目分组的所有物品到 Auctioning 拍卖分组。"
L["Alchemy was not found so the craft queue has been disabled."] = "炼金术未找到，制造队列已被禁用。" -- Needs review
L["All"] = "全部"
L["All in Individual Groups"] = "全部添加在不同的分组"
L["All in Same Group"] = "全部添加到相同的分组"
L["Allows you to override the minimum profit settings for this profession."] = "允许你修改该专业的最低利润设置"
L["Allows you to set a custom maximum queue quantity for this item."] = "允许你为该物品设置加入队列的最大值"
L["Allows you to set a custom maximum queue quantity for this profession."] = "允许你为该专业设置加入队列的最大值"
L["Allows you to set a custom minimum queue quantity for this item."] = "允许你为该物品设置加入队列的最小值" -- Needs review
L["Allows you to set a custom minimum queue quantity for this profession."] = "允许你为该专业设置加入队列的最小值"
L["Allows you to set a different craft sort method for this profession."] = "允许你为该专业设置不同的队列排序模式"
L["Allows you to set a different craft sort order for this profession."] = "允许你为该专业设置不同的队列排序方式"
L["Always queue this item."] = "始终队列该物品。"
L["Are you sure you want to delete the selected profile?"] = "确定要删除选定的配置？" -- Needs review
L["Armor"] = "护甲"
L["Armor - Back"] = "护甲 - 披风"
L["Armor - Chest"] = "护甲 - 胸甲"
L["Armor - Feet"] = "护甲 - 靴子"
L["Armor - Hands"] = "护甲 - 手套"
L["Armor - Head"] = "护甲 - 头"
L["Armor - Legs"] = "护甲 - 腿"
L["Armor - Shield"] = "护甲 - 盾牌"
L["Armor - Shoulders"] = "护甲 - 肩"
L["Armor - Waist"] = "护甲 - 腰带"
L["Armor - Wrists"] = "护甲 - 手腕"
L["Ascending"] = "顺序"
L["Auction House"] = "拍卖行"
L["Auction House Value"] = "拍卖行价格"
L["AuctionDB - Market Value"] = "AuctionDB 的市场价"
L["AuctionDB - Minimum Buyout"] = "AuctionDB 的最低一口价"
L["Auctionator - Auction Value"] = "Auctionator 的拍卖价"
L["Auctioneer"] = "Auctioneer 插件"
L["Auctioneer - Appraiser"] = "Auctioneer 的评估价"
L["Auctioneer - Market Value"] = "Auctioneer 的市场价"
L["Auctioneer - Minimum Buyout"] = "Auctioneer 的最低一口价"
L["Bags"] = "容器"
L["Bars"] = "熔锭"
L["Blackfallow Ink"] = "黑棕墨水"
L["Blacksmithing was not found so the craft queue has been disabled."] = "锻造专业未找到，制造队列已被禁用。" -- Needs review
L["Blue Gems"] = "蓝色宝石"
L["Boots"] = "靴子" -- Needs review
L["Bracers"] = "护腕"
L["Buy From Vendor"] = "从供应商购买"
L["Can not set a max restock quantity below the minimum restock quantity of %d."] = "最大补货量不能小于最小补货量(%d)" -- Needs review
L["Cancel"] = "取消" -- Needs review
L["Celestial Ink"] = "苍穹墨水"
L["Characters to include:"] = "包含角色：" -- Needs review
L["Checking this box will allow you to set a custom, fixed price for this item."] = "勾选本项，允许你为该物品设置一个自定义的固定价格。"
L["Chest"] = "胸甲"
L["Class"] = "职业" -- Needs review
L["Clear Queue"] = "清除队列" -- Needs review
L["Clear Tradeskill Filters"] = "清除商业技能搜索框"
L["Click to view and adjust how the price of this material is calculated."] = "点击查看和调整已计算好的原材料价格。"
L["Cloak"] = "披风"
-- L["Close TSM Frame When Opening Craft Management Window"] = ""
L["Close TradeSkillMaster_Crafting"] = "退出 生产部"
L["Cloth"] = "布卷"
L["Combine/Split Essences/Eternals"] = "合并/拆分 精华/永恒"
L["Companions"] = "宠物"
L["Consumables"] = "消耗品"
L["Cooking was not found so the craft queue has been disabled."] = "烹饪未找到，制造队列已被禁用。" -- Needs review
L["Copy From"] = "复制自" -- Needs review
L["Copy the settings from one existing profile into the currently active profile."] = "复制一个存在的配置到当前使用的配置。" -- Needs review
L["Cost"] = "成本"
-- L["Cost to Craft"] = ""
L["Cost: %s Market Value: %s Profit: %s Times Crafted: %s"] = "成本：%s 市价：%s 利润：%s 已制造：%s"
L["Craft"] = "制造" -- Needs review
L["Craft Item (x%s)"] = "制造物品 (x%s)"
L["Craft Management Window"] = "制造队列管理窗口" -- Needs review
L["Craft Next"] = "制造下一个"
L["Craft Queue Reset"] = "重置制造队列"
L["Crafted Item Value"] = "制造物品价值"
L["Crafting Cost: %s (%s profit)"] = "制造成本：%s (利润 %s)"
L["Crafting Options"] = "生产部"
L["Crafts"] = "制造"
L["Create Auctioning Groups"] = "创建拍卖分组"
L["Create a new empty profile."] = "创建一个新的空白配置文件。"
L["Current Profile:"] = "当前配置："
L["Custom"] = "自定义"
L["Custom Value"] = "自定义价格"
L["Data"] = "数据" -- Needs review
-- L["DataStore"] = ""
L["Death Knight"] = "死亡骑士" -- Needs review
L["Default"] = "默认" -- Needs review
L["Delete a Profile"] = "删除一个配置文件"
L["Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."] = "删除不需要的配置文件，释放磁盘空间。"
L["Descending"] = "倒序"
L["Disable All Crafts"] = "禁用所有制造"
L["Don't queue this item."] = "不排序该物品。"
L["Double Click Queue"] = "双击队列" -- Needs review
L["Druid"] = "德鲁伊" -- Needs review
L["Edit Custom Value"] = "编辑自定义价"
L["Elixir"] = "药剂"
L["Enable / Disable showing this craft in the craft management window."] = "启用/禁用该制造在造队列管理窗口中显示。"
L["Enable All Crafts"] = "启用所有制造"
L["Enable New TradeSkills"] = "启用新的商业技能"
L["Enchanting was not found so the craft queue has been disabled."] = "附魔专业未找到，制造列队已被禁用。"
L["Engineering was not found so the craft queue has been disabled."] = "工程学未找到，制造队列已被禁用。"
L["Enter a value that Crafting will use as the cost of this material."] = "以输入的价格作为制造队列中该材料的成本。"
L["Enter what you want to multiply the cost of the other item by to calculate the price of this mat."] = "物品价格是原材料成本价格的多少倍。"
L["Estimated Total Mat Cost:"] = "预计材料总成本："
L["Estimated Total Profit:"] = "预计总利润："
L["Ethereal Ink"] = "虚灵墨水"
L["Existing Profiles"] = "配置文件已存在"
L["Explosives"] = "炸药"
L["Export Crafts to TradeSkillMaster_Auctioning"] = "导出制造项目到销售部"
L["Filter out items with low seen count."] = "排除 low seen count 物品"
L["Flask"] = "合剂"
L["Force Rescan of Profession (Advanced)"] = "强制再次运行专业扫描(高级)"
L["Frame Scale"] = "窗口缩放"
L["Gathering"] = "采集" -- Needs review
L["General"] = "基本设置"
L["General Price Sources"] = "一般价格来源"
L["General Setting Overrides"] = "修改基本设置"
L["General Settings"] = "总体设置" -- Needs review
L["Get Craft Prices From:"] = "制造价格获取来源："
L["Get Mat Prices From:"] = "原材料价格来源："
L["Gloves"] = "手套" -- Needs review
L["Gold Amount"] = "金额"
L["Green Gems"] = "绿色宝石" -- Needs review
L["Group Inscription Crafts By:"] = "铭文制造队列分组方式："
L["Group to Add Crafts to:"] = "添加制造项目到分组："
L["Guilds to include:"] = "包含公会:"
L["Guns"] = "枪械" -- Needs review
L["Help"] = "帮助" -- Needs review
L["Here you can view and adjust how Crafting is calculating the price for this material."] = "你可以在这里查看和调整队列中该材料的计算价格。"
L["Here, you can override default restock queue settings."] = "你可以在这修改默认的补货队列设置"
L["Here, you can override general settings."] = "你可以在这里修改一般设置。"
L["How to add crafts to Auctioning:"] = "怎么添加制造项目到销售部："
L["Hunter"] = "猎人" -- Needs review
L["If checked, Only crafts that are enabled (have the checkbox to the right of the item link checked) below will be added to Auctioning groups."] = "只将启用（在项目连接的右侧的复选框设置）的制造项目添加到下面设置的拍卖分组。"
L["If checked, any crafts which are already in an Auctioning group will be removed from their current group and a new group will be created for them. If you want to maintain the groups you already have setup that include items in this group, leave this unchecked."] = "任意存在于销售部拍卖分组中的已准备就绪制造项目将从它们的当前分组中移除，并为它们创建一个新的分组。假如你想维持当前的分组设置，请取消本设置。"
L["If checked, the crafting cost of items will be shown in the tooltip for the item."] = "在提示信息中显示该物品的制造成本。"
L["If checked, the main TSM frame will close when you open the craft management window."] = "当打开制造窗口时，TSM主窗口将关闭" -- Needs review
L["If checked, the profit percent (profit/sell price) will be shown next to the profit in the craft management window."] = "勾选后制造队列管理窗口将不再显示利润比率(利润/售价)。"
L["If checked, when Crafting scans a tradeskill for the first time (such as after you learn a new one), it will be enabled by default."] = "插件首次扫描已学专业后，本选项将默认启用。（假设你以后换了新专业，须选中本项才能被扫描到。）"
L["If checked, you can change the price source for this mat by clicking on one of the checkboxes below. This source will be used to determine the price of this mat until you remove the override or change the source manually. If this setting is not checked, Crafting will automatically pick the cheapest source."] = "允许你通过下列的设置来决定原材料的价格，直到你取消此该设置或手动设置来源。如果未勾选本设置，将自动选择价格来源中最便宜的价格。"
L["If enabled, any craft with a profit over this percent of the cost will be added to the craft queue when you use the \"Restock Queue\" button."] = "当点击\"补货队列\"按钮时，只有利润超过该百分比的制造项目才会添加到制造队列。"
L["If enabled, any craft with a profit over this value will be added to the craft queue when you use the \"Restock Queue\" button."] = "当点击\"补货队列\"时，只有利润大于这个数额的制造项目才会添加到制造队列。"
L["If enabled, any item with a seen count below this seen count filter value will not be added to the craft queue when using the \"Restock Queue\" button. You can overrride this filter for individual items in the \"Additional Item Settings\"."] = "当你使用\"补货队列\"按钮时，任何低于Seen Count过滤中设置的数量的物品将不会添加到制造队列。你可以为某制造项目单独修改这个过滤设置。"
L["Ignore Seen Count Filter"] = "忽略Seen Count过滤"
L["In Bags"] = "在背包中"
L["Include Crafts Already in a Group"] = "包括分组中已就绪制造项目。"
-- L["Include Items on AH When Restocking"] = ""
L["Ink"] = "墨水" -- Needs review
L["Ink of the Sea"] = "海洋墨水" -- Needs review
L["Inks"] = "墨水"
L["Inscription crafts can be grouped in TradeSkillMaster_Crafting either by class or by the ink required to make them."] = "铭文的制造队列可以按铭文职业分组，或按制造所需墨水分组。"
L["Inscription was not found so the craft queue has been disabled."] = "铭文学未找到，制造队列已被禁用。"
L["Invalid Number"] = "无效数字"
L["Invalid item entered. You can either link the item into this box or type in the itemID from wowhead."] = "输入的物品无效，可以通过输入物品ID或物品连接到本框。"
L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = "输入的金额格式无效，参照格式\"#g#s#c\"，如\"25g4s50c\"为25金4银50铜。"
L["Inventory Settings"] = "库存设置"
L["Item Enhancements"] = "物品强化"
L["Item Level"] = "物品等级" -- Needs review
L["Item Name"] = "物品名称"
L["Items will only be added to the queue if the number being added is greater than this number. This is useful if you don't want to bother with crafting singles for example."] = "如果原数值比添加的数值大，制造项目将只添加到队列。如果你只需要一个特例而不影响其他设置这是个非常有用的设置。"
L["Jadefire Ink"] = "碧火墨水" -- Needs review
L["Jewelcrafting was not found so the craft queue has been disabled."] = "珠宝加工专业未找到，制造队列已被禁用。"
L["Leather"] = "皮革"
L["Leatherworking was not found so the craft queue has been disabled."] = "制皮专业未找到，制造队列已被禁用。"
L["Level 1-35"] = "1-35级"
L["Level 36-70"] = "36-70级"
L["Level 71+"] = "71+级"
L["Lion's Ink"] = "狮王墨水"
L["Mage"] = "法师" -- Needs review
L["Manual Entry"] = "手动输入"
L["Mark as Unknown (\"----\")"] = "未知市场价 (\"----\")"
L["Mat Price"] = "原材料价格"
L["Material Cost Options"] = "原材料成本选项"
L["Materials"] = "材料" -- Needs review
L["Max Restock Quantity"] = "最大补货量"
L["Meta Gems"] = "多彩宝石"
L["Midnight Ink"] = "午夜墨水" -- Needs review
L["Mill"] = "磨草"
L["Milling"] = "研磨"
L["Min Restock Quantity"] = "最小补货量"
L["Minimum Profit (in %)"] = "最低利润(%)："
L["Minimum Profit (in gold)"] = "最低利润(G)："
L["Minimum Profit Method"] = "最低利润设定"
L["Misc Items"] = "杂项物品"
L["Multiple of Other Item Cost"] = "其他物品的成本倍数"
L["NOTE: Milling prices can be viewed / adjusted in the mat options for pigments. Click on the button below to go to the pigment options."] = "注：点击下面的按钮打开颜料选项，可以在颜料原材料选项中查看或调整研磨的价值。"
L["Name"] = "名称"
L["Name of New Group to Add Item to:"] = "添加物品到新命名的分组"
L["Need"] = "需求"
L["New"] = "创建新配置"
L["No Minimum"] = "无最低值"
L["No crafts have been added for this profession. Crafts are automatically added when you click on the profession icon while logged onto a character which has that profession."] = "没有为该专业添加可制造项目。当你登录的角色有该专业，并点击该专业图标时会自动将可制造项目添加到此。"
L["Note: By default, Crafting will use the second cheapest value (herb or pigment cost) to calculate the cost of the pigment as this provides a slightly more accurate value."] = "注：默认状态下，制造将使用第二低价（草药或颜料成本）来计算颜料的成本，提供更精确的数据。"
L["Number Owned"] = "拥有数量"
L["OK"] = "确定"
L["On-Hand Queue"] = "手头队列"
L["Only Included Enabled Crafts"] = "只添加允许的队列"
L["Open Alchemy"] = "打开炼金"
L["Open Blacksmithing"] = "打开锻造"
L["Open Cooking"] = "打开烹饪"
L["Open Enchanting"] = "打开附魔"
L["Open Engineering"] = "打开工程学"
L["Open Inscription"] = "打开铭文学"
L["Open Jewelcrafting"] = "打开珠宝加工"
L["Open Leatherworking"] = "打开制皮"
L["Open Mat Options for Pigment"] = "打开颜料原材料选项"
L["Open Smelting"] = "打开冶炼"
L["Open Tailoring"] = "打开裁缝"
L["Open TradeSkillMaster_Crafting"] = "进入 生产部"
L["Options"] = "选项"
L["Orange Gems"] = "橙色宝石"
L["Other"] = "其他"
L["Other Consumable"] = "其他消耗品"
L["Other Item"] = "其他物品"
L["Override Craft Sort Method"] = "修改队列排序模式"
L["Override Craft Sort Order"] = "修改队列排序方式"
L["Override Max Restock Quantity"] = "修改最大补货量"
L["Override Min Restock Quantity"] = "修改最小补货量"
L["Override Minimum Profit"] = "修改最低利润"
L["Override Price Source"] = "修改价格来源"
L["Paladin"] = "圣骑士" -- Needs review
L["Percent and Gold Amount"] = "金额百分比"
L["Percent of Cost"] = "成本的百分比"
L["Percent to subtract from buyout when calculating profits (5% will compensate for AH cut)."] = "计算利润时从一口价中减去百分之几（拍卖行手续费为5%）。"
L["Potion"] = "药水"
L["Price Multiplier"] = "价格倍数"
L["Price Settings"] = "价格设置" -- Needs review
L["Price Source"] = "价格来源"
L["Price:"] = "价格："
L["Priest"] = "牧师" -- Needs review
L["Prismatic Gems"] = "棱彩宝石"
L["Profession was not found so the craft queue has been disabled."] = "专业未找到，制造队列已被禁用。"
L["Profession-Specific Settings"] = "具体专业设置"
L["Profiles"] = "配置文件"
L["Profit"] = "利润" -- Needs review
L["Profit Deduction"] = "利润扣除"
L["Purple Gems"] = "紫色宝石" -- Needs review
L["Red Gems"] = "红色宝石" -- Needs review
L["Reset Profile"] = "重置配置"
L["Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."] = "恢复当前的配置到原始设置。"
L["Restock Queue"] = "补货队列"
L["Restock Queue Overrides"] = "修改补货队列"
L["Restock Queue Settings"] = "补货队列设置"
L["Right click to remove all items with this mat from the craft queue."] = "鼠标右击从制造队列中移除所有制造项目及原材料。"
L["Rogue"] = "潜行者" -- Needs review
L["Scopes"] = "瞄准镜"
L["Scrolls"] = "卷轴" -- Needs review
-- L["Seen Count"] = ""
L["Seen Count Filter"] = "Seen Count 过滤"
L["Seen Count Source"] = "Seen Count 来源"
L["Select an Auctioning group to add these crafts to."] = "将这些制造项目添加到所选择的销售部拍卖分组。"
L["Select the crafts you would like to add to Auctioning and use the settings / buttons below to do so."] = "使用下面的设置/按钮来将制造项目添加到销售部。"
-- L["Set Market Value to Auctioning Fallback"] = ""
L["Shaman"] = "萨满祭司"
L["Shield"] = "盾牌" -- Needs review
L["Shimmering Ink"] = "闪光墨水" -- Needs review
L["Show Craft Management Window"] = "显示制造队列管理窗口"
L["Show Crafting Cost in Tooltip"] = "提示制造成本"
L["Show Profit Percentages"] = "显示利润比率"
L["Smelting was not found so the craft queue has been disabled."] = "冶炼未找到，制造列队已被禁用。"
-- L["Sort Crafts By"] = ""
L["Sort Order:"] = "排序方式："
L["Sort crafts in ascending order."] = "按顺序排序队列。"
L["Sort crafts in descending order."] = "按倒序排序队列。"
L["Staff"] = "法杖"
L["Status"] = "专业"
L["TSM_Auctioning Group to Add Item to:"] = "添加物品到销售部的拍卖分组："
L["Tailoring was not found so the craft queue has been disabled."] = "裁缝专业未找到，制造队列已被禁用。"
L["The checkboxes in next to each craft determine enable / disable the craft being shown in the Craft Management Window."] = "下列可制造物品名称前面的复选框，是用来设置启用/禁用它在制造队列管理窗口中的选项。"
L["The item you want to base this mat's price on. You can either link the item into this box or type in the itemID from wowhead."] = "物品基于该原材料的价格上。可以通过输入物品ID或物品连接到本框。"
L["TheUndermineJournal - Market Price"] = "TheUndermineJournal 的市场价"
L["TheUndermineJournal - Mean"] = "TheUndermineJournal 的均价"
-- L["These options control the \"Restock Queue\" button in the craft management window."] = ""
L["This is where TradeSkillMaster_Crafting will get material prices. AuctionDB is TradeSkillMaster's auction house data module. Alternatively, prices can be entered manually in the \"Materials\" pages."] = "从哪里获取原材料的价格。或者，你也可以在\"原材料\"页中手工输入价格。"
L["This is where TradeSkillMaster_Crafting will get prices for crafted items. AuctionDB is TradeSkillMaster's auction house data module."] = "从哪里获得已制造物品的价格。"
L["This item is already in the \"%s\" Auctioning group."] = "该物品已经存在于销售部的拍卖分组 %s 中。"
L["This item will always be queued (to the max restock quantity) regardless of price data."] = "该物品不考虑价格因素始终加入到队列（给予最大补货量）。"
L["This item will not be queued by the \"Restock Queue\" ever."] = "该物品从不在\"补货队列\"补货。"
L["This item will only be added to the queue if the number being added is greater than or equal to this number. This is useful if you don't want to bother with crafting singles for example."] = "如果原数值大于或等于添加的数值，制造项目将只添加到队列。如果你只需要一个特例而不影响其他设置这是个非常有用的设置。"
L["This setting determines how crafts are sorted in the craft group pages (NOT the Craft Management Window)."] = "本设置决定制造组页面的制造队列怎么排序（非制造队列管理窗口）。"
L["This setting determines where seen count data is retreived from. The seen count data can be retreived from either Auctioneer or TradeSkillMaster's AuctionDB module."] = "本设置决定seen count的数据从哪里获取。seen count数据可以从Auctioneer插件或市场分析部模块获取。"
L["This will allow you to base the price of this item on the price of some other item times a multiplier. Be careful not to create circular dependencies (ie Item A is based on the cost of Item B and Item B is based on the price of Item A)!"] = "允许你设置该物品的价格是基于某物品的价格的倍数。小心不要创建循环参考的物品（例如物品A的成本是基于物品B上，而物品B的价值又是基于物品A的价格。）"
L["This will determine how items with unknown profit are dealth with in the Craft Management Window. If you have the Auctioning module installed and an item is in an Auctioning group, the fallback for the item can be used as the market value of the crafted item (will show in light blue in the Craft Management Window)."] = "在生产部界面中决定那些未知利润的物品将如何交易。如果你安装有销售部模块，并且该物品在销售部的拍卖分组内，那么可以使用已经制造物品的市场价作为该物品的回跌价（在生产部界面中以蓝色高亮显示）。"
L["This will set the scale of the craft management window. Everything inside the window will be scaled by this percentage."] = "设置生产部界面的缩放比例，界面内的一切均按此比例缩放。"
-- L["Times Crafted"] = ""
L["Total"] = "总计" -- Needs review
L["TradeSkillMaster_AuctionDB"] = "市场分析部"
L["TradeSkillMaster_Crafting - Scanning..."] = "扫描中..."
L["TradeSkillMaster_Crafting can use TradeSkillMaster_Gathering or DataStore_Containers to provide data for a number of different places inside TradeSkillMaster_Crafting. Use the settings below to set this up."] = "销售部可以使用资源管理部或数据存储容器提供的不同的数据，使用下列设置来设置它。"
L["Transmutes"] = "转化"
L["Trinkets"] = "饰品"
L["Unknown Profit Queuing"] = "未知利润队列"
L["Use auction house data from the addon you have selected in the Crafting options for the value of this mat."] = "原材料的价格将参考你在制造队列选项中选定插件从拍卖行所获取的数据。"
L["Use the links on the left to select which page to show."] = "使用左侧的树形菜单选择显示制造项目。"
L["Use the price of buying herbs to mill as the cost of this material."] = "使用所购买草药用来研磨的价格作为原材料的成本。"
L["Use the price that a vendor sells this item for as the cost of this material."] = "使用供应商出售该物品的价格作为原材料的成本。"
L["User-Defined Price"] = "用户定义价格"
L["Vendor"] = "供应商"
L["Vendor Trade"] = "供应商贸易"
L["Vendor Trade (x%s)"] = "供应商贸易 (x%s)"
L["Warlock"] = "术士" -- Needs review
L["Warning: The min restock quantity must be lower than the max restock quantity."] = "警告：最低补货量必须小于最大补货量。"
L[ [=[Warning: Your default minimum restock quantity is higher than your maximum restock quantity! Visit the "Craft Management Window" section of the Crafting options to fix this!

You will get error messages printed out to chat if you try and perform a restock queue without fixing this.]=] ] = [=[警告：你的默认最小补货数量大于你的最高补货数量！访问"生产部"的队列选项来修改这个设置。

在你修复这个错误之前继续尝试补货将会在聊天框看到程序的错误信息！]=]
L["Warrior"] = "战士" -- Needs review
L["Weapon"] = "武器" -- Needs review
L["Weapon - Main Hand"] = "武器 - 主手"
L["Weapon - One Hand"] = "武器 - 单手"
L["Weapon - Thrown"] = "武器 - 投掷武器"
L["Weapon - Two Hand"] = "武器 - 双手"
L["When you click on the \"Restock Queue\" button enough of each craft will be queued so that you have this maximum number on hand. For example, if you have 2 of item X on hand and you set this to 4, 2 more will be added to the craft queue."] = "当你点击\"补货队列\"按钮时，只添加最大补货量减去手上拥有量的差。例如，你设置的最大补货为4件，并且手头上有2件，那么只会添加2件的制造任务到制造队列。"
L["When you double click on a craft in the top-left portion (queuing portion) of the craft management window, it will increment/decrement this many times."] = "双击队列管理窗口左上部分(队列部分)的某制造项目，可以增加/减少它的制造数量。"
L["When you use the \"Restock Queue\" button, it will ignore any items with a seen count below the seen count filter below. The seen count data can be retreived from either Auctioneer or TradeSkillMaster's AuctionDB module."] = "当你使用\"补货队列\"按钮时，它将忽略任何低于seen count过滤中设置的数量的物品。seen count数据可以从Auctioneer插件或市场分析部模块获取。"
-- L["When you use the \"Restock Queue\" button, it will queue enough of each craft so that you will have the desired maximum quantity on hand. If you check this checkbox, anything that you have on the AH as of the last scan will be included in the number you currently have on hand."] = ""
L["Which group in TSM_Auctioning to add this item to."] = "该物品添加到销售部的哪个拍卖分组。"
L["Which group in TSM_Mailing to add this item to."] = "该物品添加到物流部的哪个分组。"
L["Yellow Gems"] = "黄色宝石" -- Needs review
L["You can change the active database profile, so you can have different settings for every character."] = "选择其他的配置文件。"
L["You can choose to specify a minimum profit amount (in gold or by percent of cost) for what crafts should be added to the craft queue."] = "为添加到制造队列的制造项目选择一个指定的利润阀值(可以是百分比或金额)。"
L["You can either add every craft to one group or make individual groups for each craft."] = "可以添加所有的制造项目到一个分组，或为每个制造项目创建单独的分组。"
L["You can either create a new profile by entering a name in the editbox, or choose one of the already exisiting profiles."] = "输入一个名称用以创建新的配置文件，或选择一个已经存在的配置文件。"
L["You can select a category that group(s) will be added to or select \"<No Category>\" to not add the group(s) to a category."] = "你可以选择一个分类来将分组添加到其中。或选择\"无分类\"不将分组添加到其中。"
L["You must have your profession window open in order to use the craft queue. Click on the button below to open it."] = "你必须打开你的专业窗口才能使用制造队列。点击下面按钮打开它。"
L["per pigment"] = "每个颜料"
