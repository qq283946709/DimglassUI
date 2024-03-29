﻿if GetLocale() ~= "zhTW" then return end

DBM_CORE_NEED_SUPPORT				= "你是否擁有良好的程式開發或語言能力? 如果是的話, DBM團隊真的需要你的幫助以保持成為WOW裡最佳的首領模組。觀看 www.deadlybossmods.com 或發送郵件到 tandanu@deadlybossmods.com 或 nitram@deadlybossmods.com 來加入團隊。"
DBM_HOW_TO_USE_MOD					= "歡迎使用DBM-voice。在聊天頻道輸入 /dbm 打開設定開始設定。你可以載入特定區域後為任何首領設定你喜歡的特別設置。DBM會在第一次啟動時嘗試掃描你的職業天賦，但有些選項你可能想打開。"

DBM_CORE_LOAD_MOD_ERROR				= "載入%s模組時發生錯誤：%s"
DBM_CORE_LOAD_MOD_SUCCESS			= "成功載入%s模組。輸入/dbm或/dbm help有更多選項。"
DBM_CORE_LOAD_GUI_ERROR				= "無法載入圖形介面：%s"

DBM_CORE_COMBAT_STARTED				= "%s開戰。祝好運與盡興! :)"
DBM_CORE_BOSS_DOWN					= "擊敗%s，經過%s!"
DBM_CORE_BOSS_DOWN_LONG				= "擊敗%s!本次經過%s，上次經過%s，最快紀錄%s。"
DBM_CORE_BOSS_DOWN_NEW_RECORD		= "擊敗%s!經過%s，這是一個新記錄!（舊紀錄為%s）"
DBM_CORE_COMBAT_ENDED				= "%s的戰鬥經過%s結束。"
DBM_CORE_COMBAT_STATE_RECOVERED		= "%s的戰鬥在%s前開始，恢復計時器中..."

DBM_CORE_TIMER_FORMAT_SECS			= "%d秒"
DBM_CORE_TIMER_FORMAT_MINS			= "%d分鐘"
DBM_CORE_TIMER_FORMAT				= "%d分%d秒"

DBM_CORE_MIN					= "分"
DBM_CORE_MIN_FMT				= "%d分"
DBM_CORE_SEC					= "秒"
DBM_CORE_SEC_FMT				= "%d秒"
DBM_CORE_DEAD					= "死亡"
DBM_CORE_OK						= "確定"

DBM_CORE_GENERIC_WARNING_BERSERK		= "%s%s後狂暴"
DBM_CORE_GENERIC_TIMER_BERSERK			= "狂暴"
DBM_CORE_OPTION_TIMER_BERSERK			= "狂暴倒計時"
DBM_CORE_OPTION_HEALTH_FRAME			= "顯示首領血量框架"

DBM_CORE_OPTION_CATEGORY_TIMERS			= "計時器"
DBM_CORE_OPTION_CATEGORY_WARNINGS		= "警告"
DBM_CORE_OPTION_CATEGORY_SPECWARNINGS	= "特別警告"
DBM_CORE_OPTION_CATEGORY_SOUND			= "語音警告"
DBM_CORE_OPTION_CATEGORY_MISC			= "其它"

DBM_CORE_AUTO_RESPONDED					= "已自動回覆密語。"
DBM_CORE_STATUS_WHISPER					= "%s：%s，%d/%d存活。"
DBM_CORE_AUTO_RESPOND_WHISPER			= "%s正在與%s交戰（當前%s，%d/%d存活）"
DBM_CORE_WHISPER_COMBAT_END_KILL		= "%s已經擊敗%s!"
DBM_CORE_WHISPER_COMBAT_END_WIPE		= "%s在%s的戰鬥中滅團了。"

DBM_CORE_VERSIONCHECK_HEADER			= "Deadly Boss Mods - 版本檢測"
DBM_CORE_VERSIONCHECK_ENTRY				= "%s：%s(r%d)"
DBM_CORE_VERSIONCHECK_ENTRY_NO_DBM		= "%s：尚未安裝DBM"
DBM_CORE_VERSIONCHECK_FOOTER			= "團隊中有%d名成員正在使用Deadly Boss Mods"
DBM_CORE_YOUR_VERSION_OUTDATED			= "你的 Deadly Boss Mod 已經過期。請到 www.deadlybossmods.com 下載最新版本。"

DBM_CORE_UPDATEREMINDER_HEADER			= "你的 Deadly Boss Mod 已經過期。\n你可以在此網址下載到新版本%s(r%d)："
DBM_CORE_UPDATEREMINDER_FOOTER			= "Ctrl-C：複製下載網址到剪貼簿。"
DBM_CORE_UPDATEREMINDER_NOTAGAIN		= "當有新版本時顯示彈出提示"

DBM_CORE_MOVABLE_BAR				= "拖動我!"

DBM_PIZZA_SYNC_INFO					= "|Hplayer:%1$s|h[%1$s]|h向你發送了一個倒數計時：'%2$s'\n|HDBM:cancel:%2$s:nil|h|cff3588ff[取消該計時]|r|h  |HDBM:ignore:%2$s:%1$s|h|cff3588ff[忽略來自%1$s的計時]|r|h"
DBM_PIZZA_CONFIRM_IGNORE			= "是否要在該次遊戲連結中忽略來自%s的計時？"
DBM_PIZZA_ERROR_USAGE				= "命令：/dbm [broadcast] timer <時間（秒）> <文字>"

DBM_CORE_ERROR_DBMV3_LOADED			= "目前有2個版本的Deadly Boss Mods正在運行：DBMv3和DBMv4。\n按一下“確定”按鈕可將DBMv3關閉並重載插件。\n我們建議將插件目錄下的DBMv3刪除。"

DBM_CORE_MINIMAP_TOOLTIP_HEADER		= "Deadly Boss Mods"
DBM_CORE_MINIMAP_TOOLTIP_FOOTER		= "Shift+左鍵或右鍵點擊即可移動，Alt+Shift+點擊即可拖放"

DBM_CORE_RANGECHECK_HEADER			= "距離監視（%d碼）"
DBM_CORE_RANGECHECK_SETRANGE		= "設置距離"
DBM_CORE_RANGECHECK_SOUNDS			= "音效"
DBM_CORE_RANGECHECK_SOUND_OPTION_1	= "當一位玩家在範圍內時播放音效"
DBM_CORE_RANGECHECK_SOUND_OPTION_2	= "當多於一位玩家在範圍內時播放音效"
DBM_CORE_RANGECHECK_SOUND_0			= "沒有音效"
DBM_CORE_RANGECHECK_SOUND_1			= "預設音效"
DBM_CORE_RANGECHECK_SOUND_2			= "蜂鳴聲"
DBM_CORE_RANGECHECK_HIDE			= "隱藏"
DBM_CORE_RANGECHECK_SETRANGE_TO		= "%d碼"
DBM_CORE_RANGECHECK_LOCK			= "鎖定框架"
DBM_CORE_RANGECHECK_OPTION_FRAMES	= "框架"
DBM_CORE_RANGECHECK_OPTION_RADAR	= "顯示雷達框架"
DBM_CORE_RANGECHECK_OPTION_TEXT		= "顯示文字框"
DBM_CORE_RANGECHECK_OPTION_BOTH		= "兩者都顯示"
DBM_CORE_RANGECHECK_OPTION_SPEED	= "更新頻率(需要重載介面)"
DBM_CORE_RANGECHECK_OPTION_SLOW		= "慢(CPU使用量低)"
DBM_CORE_RANGECHECK_OPTION_AVERAGE	= "中"
DBM_CORE_RANGECHECK_OPTION_FAST		= "快(幾近即時)"
DBM_CORE_RANGERADAR_HEADER			= "距離雷達(%d碼)"

DBM_CORE_INFOFRAME_LOCK				= "鎖定框架"
DBM_CORE_INFOFRAME_HIDE				= "隱藏"
DBM_CORE_INFOFRAME_SHOW_SELF		= "總是顯示你的能量"

DBM_LFG_INVITE						= "地城準備確認"

DBM_CORE_SLASHCMD_HELP				= {
	"可用命令：",
	"/dbm version：進行團隊範圍內的版本檢測（也可使用：ver）。",
--	"/dbm version2: 進行團隊範圍內的版本檢測及密語通知已過期的成員（也可使用: ver2）。",
	"/dbm unlock：顯示一個可移動的計時器（也可使用：move）。",
	"/dbm timer <x> <文字>：開始一個以<文字>為名稱的時間為<x>秒的計時器。",
	"/dbm broadcast timer <x> <文字>：向團隊廣播一個以<文字>為名稱，時間為<x>秒的計時器（需要團隊隊長或助理權限）。",
	"/dbm break <分鐘>: 開始休息計時器<分鐘>。向所有團隊成員發送一個DBM休息計時器（需要團隊隊長或助理權限）。",
	"/dbm pull <秒數>: 開始備戰計時器<秒數>。向所有團隊成員發送一個DBM備戰計時器（需要團隊隊長或助理權限）。",
	"/dbm arrow: 顯示DBM箭頭, 輸入 /dbm arrow help 獲得更多訊息。",
	"/dbm lockout: 向團隊成員請求他們當前的團隊副本鎖定訊息(鎖定訊息、副本id) (需要團隊隊長或助理權限)。",
	"/dbm help：顯示可用命令的說明。",
}

DBM_ERROR_NO_PERMISSION				= "無權進行此操作。"

DBM_CORE_BOSSHEALTH_HIDE_FRAME		= "關閉血量框架"

DBM_CORE_ALLIANCE				= "聯盟"
DBM_CORE_HORDE					= "部落"

DBM_CORE_UNKNOWN				= "未知"

DBM_CORE_BREAK_START				= "現在開始休息-你有%s分鐘!"
DBM_CORE_BREAK_MIN					= "%s分鐘後休息時間結束!"
DBM_CORE_BREAK_SEC					= "%s秒後休息時間結束!"
DBM_CORE_TIMER_BREAK				= "休息時間!"
DBM_CORE_ANNOUNCE_BREAK_OVER		= "休息時間已經結束"

DBM_CORE_TIMER_PULL					= "戰鬥準備"
DBM_CORE_ANNOUNCE_PULL				= "%d秒後拉怪"
DBM_CORE_ANNOUNCE_PULL_NOW			= "拉怪囉!"

DBM_CORE_ACHIEVEMENT_TIMER_SPEED_KILL 		= "快速擊殺"

-- Auto-generated Timer Localizations
DBM_CORE_AUTO_TIMER_TEXTS = {
	target					= "%s:%%s",
	cast					= "%s",
	active					= "%s結束",
	fades					= "%s消散",
	cd						= "%s冷卻",
	cdcount					= "%s冷卻 (%%d)",
	next 					= "下一次%s",
	nextcount 				= "下一次%s (%%d)",
	achievement 			= "%s"
}

DBM_CORE_AUTO_TIMER_OPTIONS = {
	target					= "計時器：$spell:%s減益效果持續時間",
	cast					= "計時器：$spell:%s施法時間",
	active					= "計時器：$spell:%s持續時間",
	fades					= "計時器：$spell:%s何時從玩家身上消失",
	cd						= "計時器：$spell:%s冷卻時間",
	cdcount					= "計時器：$spell:%s冷卻時間",
	next					= "計時器：下一次$spell:%s",
	nextcount				= "計時器：下一次$spell:%s",
	achievement				= "計時器：成就%s"
}

-- Auto-generated Warning Localizations
DBM_CORE_AUTO_ANNOUNCE_TEXTS = {
	target					= "%s：>%%s<",
	targetcount				= "%s (%%d)：>%%s<",
	spell					= "%s",
	adds					= "%s 剩餘：%%d",
	cast					= "正在施放 %s: %.1f 秒",
	soon					= "%s 即將到來",
	prewarn					= "%2$s後 %1$s",
	phase					= "第%s階段",
	prephase				= "第%s階段 即將到來",
	count					= "%s (%%d)",
	stack					= "%s: >%%s< (%%d)",
}

local prewarnOption				= "預先警告：$spell:%s"
DBM_CORE_AUTO_ANNOUNCE_OPTIONS = {
	target					= "警告：$spell:%s的目標",
	targetcount				= "警告：$spell:%s的目標",
	spell					= "警告：$spell:%s",
	adds					= "警告：$spell:%s剩餘數量",
	cast					= "警告：$spell:%s的施放",
	soon					= prewarnOption,
	prewarn					= prewarnOption,
	phase					= "警告：第%s階段",
	prephase				= "預先警告：第%s階段",
	count					= "警告：$spell:%s",
	stack					= "警告：$spell:%s疊加層數",
}

-- Auto-generated Special Warning Localizations
DBM_CORE_AUTO_SPEC_WARN_OPTIONS = {
	spell					= "特別警告：$spell:%s",
	dispel					= "特別警告：需要驅散/竊取$spell:%s時",
	interrupt				= "特別警告：需要打斷$spell:%s時",
	you						= "特別警告：當你中了$spell:%s時",
	target					= "特別警告：當有人中了$spell:%s時",
	close					= "特別警告：當你附近有人中了$spell:%s時",
	move					= "特別警告：當你受到$spell:%s影響時",
	run						= "特別警告：$spell:%s",
	cast					= "特別警告：$spell:%s的施放",
	stack					= "特別警告：當疊加了至少%d層$spell:%s時",
	switch 					= "特別警告：針對$spell:%s轉換目標"
}

DBM_CORE_AUTO_SPEC_WARN_TEXTS = {
	spell					= "%s!",
	dispel					= "%%s中了%s - 快驅散",
	interrupt				= "%s - 快打斷",
	you					= "你中了%s",
	target					= "%%s中了%s",
	close					= "你附近的%%s中了%s",
	move					= "%s - 快離開",
	run						= "%s - 快跑開",
	cast					= "%s - 停止施法",
	stack					= "%s(%%d)",
	switch					= "%s - 轉換目標"
}


DBM_CORE_AUTO_ICONS_OPTION_TEXT			= "為$spell:%s的目標設置團隊標記"
DBM_CORE_AUTO_SOUND_OPTION_TEXT			= "語音警告：當你中了$spell:%s時"
DBM_CORE_AUTO_COUNTDOWN_OPTION_TEXT		= "倒計時：$spell:%s的冷卻時間"
DBM_CORE_AUTO_COUNTOUT_OPTION_TEXT		= "正計時：$spell:%s的持續時間"
DBM_CORE_AUTO_YELL_OPTION_TEXT			= "自動喊話：當你中了$spell:%s時"
DBM_CORE_AUTO_YELL_ANNOUNCE_TEXT		= "我中了%s!"


-- New special warnings
DBM_CORE_MOVE_SPECIAL_WARNING_BAR		= "可拖動的特別警告"
DBM_CORE_MOVE_SPECIAL_WARNING_TEXT		= "特別警告"


DBM_CORE_RANGE_CHECK_ZONE_UNSUPPORTED	= "在此區域中不支援%d碼的距離檢查。\n已支援的距離有10，11，15及28碼。"

DBM_ARROW_MOVABLE					= "可移動箭頭"
DBM_ARROW_NO_RAIDGROUP				= "此功能僅作用於團隊副本中的團隊小隊。"
DBM_ARROW_ERROR_USAGE	= {
	"DBM-Arrow 用法:",
	"/dbm arrow <x> <y>  建立一個箭頭在特定的位置(0 < x/y < 100)",
	"/dbm arrow <玩家>  建立並箭頭指向你的隊伍或團隊中特定的玩家",
	"/dbm arrow hide  隱藏箭頭",
	"/dbm arrow move  可移動箭頭",
}

DBM_SPEED_KILL_TIMER_TEXT			= "記錄擊殺"
DBM_SPEED_KILL_TIMER_OPTION			= "計時器：上次的最快擊殺"


DBM_REQ_INSTANCE_ID_PERMISSION		= "%s想要查看你的副本ID和進度鎖定情況。\n你想發送該訊息給%s嗎? 在你的當前進程（除非你下線）他可以一直查閱該訊息。"
DBM_ERROR_NO_RAID					= "你必須在一個團隊中才可以使用這個功能。"
DBM_INSTANCE_INFO_REQUESTED			= "查看團隊成員的副本鎖定訊息。\n請注意，隊員們將會被詢問是否願意發送資料給你，因此可能需要等待一段時間才能獲得全部的回覆。"
DBM_INSTANCE_INFO_STATUS_UPDATE		= "從%d個玩家獲得訊息，來自%d個DBM用戶：%d人發送了資料, %d人拒絕回傳資料。繼續為更多回覆等待%d秒..."
DBM_INSTANCE_INFO_ALL_RESPONSES		= "已獲得全部團隊成員的回傳資料"
DBM_INSTANCE_INFO_DETAIL_DEBUG		= "發送者:%s 結果類型:%s 副本名:%s 副本ID:%s 難度:%d 大小:%d 進度:%s"
DBM_INSTANCE_INFO_DETAIL_HEADER		= "%s(%d), 難度%d:"
DBM_INSTANCE_INFO_DETAIL_INSTANCE	= "    ID %s, 進度%d:%s"
DBM_INSTANCE_INFO_STATS_DENIED		= "拒絕回傳數據:%s"
DBM_INSTANCE_INFO_STATS_AWAY		= "離開:%s"
DBM_INSTANCE_INFO_STATS_NO_RESPONSE	= "沒有安裝最新版本的DBM:%s"
DBM_INSTANCE_INFO_RESULTS			= "副本ID掃描結果。注意如果團隊中有不同語言版本的魔獸客戶端，那麼同一副本可能會出現不止一次。"
DBM_INSTANCE_INFO_SHOW_RESULTS		= "回复請求的玩家: %s\n|HDBM:showRaidIdResults|h|cff3588ff[查看結果]|r|h"
