-- By wowui.cn

if ( GetLocale() == "zhTW" ) then

EASYMAIL_FORWARDTEXT = "引用";
EASYMAIL_CLEAROPTION = "清除";
EASYMAIL_ATTBUTTONTEXT = "收取所有";
EASYMAIL_CHECKALLTEXT = "標記所有";
EASYMAIL_CLEARALLTEXT = "清除所有";
EASYMAIL_GETALLTEXT = "拿取附件";
EASYMAIL_GUILDTEXT = "公會成員";
EASYMAIL_FRIENDSTEXT = "好友";
EASYMAIL_RECEIVEMONEY = "你獲得金錢: %s %s";
EASYMAIL_FROMAUCTION = "(拍賣行 %s)";
EASYMAIL_FROM = "(來自 %s)";
EASYMAIL_MONEYSUBJECT = "金錢: %s";
EASYMAIL_TOTALMONEY = "從附件獲得的總金錢數: %s";
EASYMAIL_NOTEXT = "<無文本>";
EASYMAIL_FORWARD_PREFIX = "FW:"

EASYMAIL_CLEARQUESTION = "清除所有的最近郵寄列表從EasyMail地址列表?";
EASYMAIL_CLEARMSG = "最近的郵寄列表地址已清除.";
EASYMAIL_DELNAMEQUESTION = "清除 %s 從地址列表?";
EASYMAIL_DELNAMEMSG = "已刪除 %s 從地址列表.";
EASYMAIL_DELETEQUESTION = "刪除來自 %s 的郵件?";
EASYMAIL_DELETEUNREADQUESTION = "刪除來自 %s 的未讀郵件?";
EASYMAIL_MAXLENMSG = "EasyMail 最近郵寄地址列表最大長度設置為 %i.";
EASYMAIL_AUTOADDMSG = "EasyMail 自動添加已登陸角色到最近郵寄地址列表: %s.";
EASYMAIL_GUILDMSG = "EasyMail 在地址下拉列表顯示公會成員: %s.";
EASYMAIL_FRIENDSMSG = "EasyMail 在地址下拉列表顯示好友: %s.";
EASYMAIL_CLICKGETMSG = "EasyMail 右鍵拿取附件: %s.";
EASYMAIL_CLICKDELMSG = "EasyMail 右鍵郵件刪除: %s.";
EASYMAIL_DELPROMPTMSG = "EasyMail 右鍵點擊立即刪除已讀郵件: %s.";
EASYMAIL_DELPENDINGMSG = "EasyMail 當拿取所有附件后刪除拍賣所郵件: %s.";
EASYMAIL_MONEYMSG = "EasyMail 輸出每封郵件獲得的金錢到聊天窗口: %s.";
EASYMAIL_TOTALMSG = "EasyMail 輸出獲得的總的金錢到聊天窗口: %s.";
EASYMAIL_TOOLTIPMSG = "EasyMail 在收件箱物品上顯示郵件內容: %s.";

EASYMAIL_CLEARHELPMSG = "清除所有的最近郵寄列表從地址列表.";
EASYMAIL_MAXLENHELPMSG = "修改最近郵寄地址列表的最大長度.";
EASYMAIL_AUTOADDHELPMSG = "自動添加已登陸角色到最近郵寄地址列表.";
EASYMAIL_GUILDHELPMSG = "在地址下拉列表中包含公會成員.";
EASYMAIL_FRIENDSHELPMSG = "在地址下拉列表中包含好友名字.";
EASYMAIL_CLICKGETHELPMSG = "啟用 右鍵點擊 在收件箱中拿取附件.";
EASYMAIL_CLICKDELHELPMSG = "啟用 右鍵點擊 在收件箱中刪除郵件.";
EASYMAIL_DELPROMPTHELPMSG = "右鍵點擊立即刪除已讀郵件.";
EASYMAIL_DELPENDINGHELPMSG = "當拿取所有附件后刪除拍賣所郵件";
EASYMAIL_MONEYHELPMSG = "輸出每封郵件獲得的金錢到聊天窗口.";
EASYMAIL_TOTALHELPMSG = "輸出獲得的總的金錢到聊天窗口.";
EASYMAIL_TOOLTIPHELPMSG = "收件箱物品上顯示郵件內容. 警告: 郵件將被標記為 "
   .."已讀當郵件內容已顯示. 郵件內容可能會延遲幾秒后顯示.";

EASYMAIL_CONFIG_HEADERINFO = "設置發送新郵件時默認使用最后一次的郵寄地址，允許"
   .."用戶從地址下拉列表中選擇收件地址.";
EASYMAIL_CONFIG_MAXLEN = "最大列表長度 (%i - %i):";
EASYMAIL_CONFIG_CLEARLIST = "清除最近的郵寄列表";
EASYMAIL_CONFIG_CLEARLISTBTNTEXT = "清除列表";
EASYMAIL_CONFIG_AUTOADD = "添加已登陸角色到最近郵寄地址列表";
EASYMAIL_CONFIG_GUILD = "增加公會成員到地址列表";
EASYMAIL_CONFIG_FRIENDS = "增加好友到地址列表";
EASYMAIL_CONFIG_CLICKGET = "右鍵點擊 拿取附件";
EASYMAIL_CONFIG_CLICKDEL = "右鍵點擊 郵件刪除";
EASYMAIL_CONFIG_DELPROMPT = "立即刪除已讀郵件";
EASYMAIL_CONFIG_DELPENDING = "刪除拍賣所郵件";
EASYMAIL_CONFIG_MONEY = "輸出每封郵件獲取的金錢";
EASYMAIL_CONFIG_TOTAL = "輸出獲得的總的金錢";
EASYMAIL_CONFIG_TOOLTIP = "在收件箱物品上顯示郵件內容";

EASYMAIL_ERRINVALIDPARM = "無效的列表長度數值.";
EASYMAIL_ERROUTOFRANGE = "列表長度必須在 %i 和 %i 之間.";
EASYMAIL_ERRTOGGLE = "無效的參數. 使用 ON 或 OFF.";
EASYMAIL_ERRTIMEOUT = "不能拿取一個附件 %i 秒. 檢測是否有足夠的背包空間或是否是唯一的物品. "
   .."如果你有網路延遲問題, 請在以后嘗試所有操作.";
EASYMAIL_ERRCOD = "不允許右鍵拿取付款收信郵件.";
EASYMAIL_ERRMAILATT = "右鍵拿取附件沒有被啟用.";
EASYMAIL_ERRDELETE = "右鍵刪除右鍵沒有被啟用.";
EASYMAIL_ERRUNREAD = "不允許右鍵刪除未讀右鍵.";
end
