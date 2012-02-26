-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_AuctionDB - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctiondb.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_AuctionDB Locale - ruRU
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_AuctionDB/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_AuctionDB", "ruRU")
if not L then return end

L["%s ago"] = "%s тому назад"
-- L["<No Item SubType Filter>"] = ""
-- L["<No Item Type Filter>"] = ""
L["Alchemy"] = "Алхимия"
-- L["Any items in the AuctionDB database that contain the search phrase in their names will be displayed."] = ""
L["Are you sure you want to clear your AuctionDB data?"] = "Вы точно хотите очистить базу AuctionDB?" -- Needs review
L["Ascending"] = "Возрастание" -- Needs review
L["Auction house must be open in order to scan."] = "Сканирование невозможно, если окно аукциона закрыто."
L["AuctionDB - Auction House Scanning"] = "AuctionDB - сканирование аукциона"
L["AuctionDB - Run Scan"] = "AuctionDB - запустить сканирование"
L["AuctionDB - Scanning"] = "AuctionDB - сканирование"
L["AuctionDB Market Value:"] = "AuctionDB рыночная цена:"
L["AuctionDB Min Buyout:"] = "AuctionDB минимальный выкуп:"
L["AuctionDB Seen Count:"] = "Сколько раз появлялся на ауке (данные AuctionDB):"
L["Blacksmithing"] = "Кузнечное дело"
L["Block Auctioneer while Scanning."] = "Блокировать Аукционер во время сканирования."
L["Complete AH Scan"] = "Полное сканирование аукциона"
L["Cooking"] = "Кулинария"
L["Descending"] = "Убывание" -- Needs review
L["Enable display of AuctionDB data in tooltip."] = "Включить отображение данных AuctionDB в подсказке."
L["Enchanting"] = "Наложение чар"
L["Engineering"] = "Инженерия"
L["Error: AuctionHouse window busy."] = "Ошибка: Окно аукциона занято."
L["General Options"] = "Общие настройки" -- Needs review
L["GetAll Scan:"] = "GetAll сканирование:"
L["Hide poor quality items"] = "Скрыт вещи плохого качества" -- Needs review
-- L["If checked, Auctioneer will be prevented from scanning / processing AuctionDB's scans."] = ""
L[ [=[If checked, a GetAll scan will be used whenever possible.

WARNING: With any GetAll scan there is a risk you may get disconnected from the game.]=] ] = [=[Отметьте для использования GetAll сканирования при первой возможности.
Внимание: при GetAll сканировании ест риск разрыва соединения с сервером.]=]
L["If checked, a regular scan will scan for this profession."] = "Отметьте, чтобы провести обычное сканирования для этой профессии."
L["If checked, poor quality items won't be shown in the search results."] = "Не показывать вещи плохого качества" -- Needs review
L["Inscription"] = "Начертание"
-- L["Invalid value entered. You must enter a number between 5 and 500 inclusive."] = ""
-- L["Item Link"] = ""
-- L["Item MinLevel"] = ""
-- L["Item SubType Filter"] = ""
-- L["Item Type Filter"] = ""
-- L["Items %s - %s (%s total)"] = ""
-- L["Items per page"] = ""
L["Jewelcrafting"] = "Ювелирное дело"
-- L["Last Scanned"] = ""
L["Leatherworking"] = "Кожевничество"
-- L["Market Value"] = ""
-- L["Minimum Buyout"] = ""
-- L["Next Page"] = ""
-- L["No items found"] = ""
L["Not Ready"] = "Не готово"
L["Nothing to scan."] = "Нечего сканировать."
-- L["Opens the main TSM window to the AuctionDB page where you can search through AuctionDB's scan data to quickly lookup items in the AuctionDB database."] = ""
-- L["Options"] = ""
-- L["Previous Page"] = ""
L["Professions to scan for:"] = "Для каких профессий просканировать:"
L["Ready"] = "Готово"
L["Ready in %s min and %s sec"] = "Готовность через %s  мин %s  сек."
-- L["Refresh"] = ""
-- L["Refreshes the current search results."] = ""
-- L["Reset Data"] = ""
-- L["Resets AuctionDB's scan data"] = ""
L["Run GetAll Scan"] = "Запустить GetAll сканирование"
L["Run GetAll Scan if Possible"] = "Запустить GetAll сканирование, если можно."
L["Run Regular Scan"] = "Запустить обычное сканирование."
L["Run Scan"] = "Запустить сканирование"
L["Scan complete!"] = "Сканирование завершено!"
L["Scan interupted due to auction house being closed."] = "Сканирование прекращено, так как окно аукциона было закрыто."
-- L["Search"] = ""
-- L["Search Options"] = ""
-- L["Search Scan Data"] = ""
-- L["Seen Last Scan (Yours)"] = ""
-- L["Select how you would like the search results to be sorted. After changing this option, you may need to refresh your search results by hitting the \"Refresh\" button."] = ""
-- L["Sort items by"] = ""
-- L["Sort search results in ascending order."] = ""
-- L["Sort search results in descending order."] = ""
L[ [=[Starts scanning the auction house based on the below settings.

If you are running a GetAll scan, your game client may temporarily lock up.]=] ] = [=[Начать сканирование аукциона с заданными настройками.
Если вы запустите GetAll сканирование, клиент игры может на какое-то время "повиснуть".]=]
L["Tailoring"] = "Портняжное дело."
-- L["This determines how many items are shown per page in results area of the \"Search\" tab of the AuctionDB page in the main TSM window. You may enter a number between 5 and 500 inclusive. If the page lags, you may want to decrease this number."] = ""
-- L["Use the search box and category filters above to search the AuctionDB data."] = ""
-- L["You can filter the results by item subtype by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in the item type dropdown and \"Herbs\" in this dropdown."] = ""
-- L["You can filter the results by item type by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in this dropdown and \"Herbs\" as the subtype filter."] = ""
-- L["You can use this page to lookup an item or group of items in the AuctionDB database. Note that this does not perform a live search of the AH."] = ""
L["Your version of the main TradeSkillMaster addon is out of date. Please update it in order to be able to view this page."] = "Ваша версия TradeSkillMaster устарела. Пожалуйста, обновите его."
L["|cffff0000WARNING:|r As of 4.0.1 there is a bug with GetAll scans only scanning a maximum of 42554 auctions from the AH which is less than your auction house currently contains. As a result, thousands of items may have been missed. Please use regular scans until blizzard fixes this bug."] = "|cffff0000Внимание: с патча 4.0.1 из-за бага GetAll сканирует только 42554 лота, что меньше общего количества лотов сейчас на вашем аукционе. Тысячи лотов могут быть не учтены. До тех пор, пока Blizzard не исправит эту ошибку, пользуйтесь обычным способом сканирования. "
 