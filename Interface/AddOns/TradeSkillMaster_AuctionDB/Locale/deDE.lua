-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_AuctionDB - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctiondb.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_AuctionDB Locale - deDE
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_AuctionDB/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_AuctionDB", "deDE")
if not L then return end

L["%s ago"] = "Vor %s" -- Needs review
L["<No Item SubType Filter>"] = "<Kein Gegenstands-Unterkategorie-Filter>" -- Needs review
L["<No Item Type Filter>"] = "<Kein Gegenstand-Kategorie-Filter>" -- Needs review
L["Alchemy"] = "Alchemie" -- Needs review
L["Any items in the AuctionDB database that contain the search phrase in their names will be displayed."] = "Es werden alle Gegenstände in der \"AuctionDB\" Datenbank angezeigt, deren Namen mit der Sucheingabe übereinstimmen." -- Needs review
L["Are you sure you want to clear your AuctionDB data?"] = "Sind Sie sicher, dass Sie die \"AuctionDB\" Daten löschen wollen?" -- Needs review
L["Ascending"] = "Aufsteigend" -- Needs review
L["Auction house must be open in order to scan."] = "Das Auktionshaus muss geöffnet sein um scannen zu können." -- Needs review
L["AuctionDB - Auction House Scanning"] = "AuctionDB - Auction House Scanning" -- Needs review
L["AuctionDB - Run Scan"] = "AuctionDB - Scan durchführen" -- Needs review
L["AuctionDB - Scanning"] = "AuctionDB - Scannen" -- Needs review
L["AuctionDB Market Value:"] = "AuctionDB Markwert:" -- Needs review
L["AuctionDB Min Buyout:"] = "AuctionDB Min. Sofortkauf" -- Needs review
L["AuctionDB Seen Count:"] = "AuctionDB gesehen:" -- Needs review
L["Blacksmithing"] = "Schmiedekunst" -- Needs review
L["Block Auctioneer while Scanning."] = "Blockiere Auctioneer während des Scannens." -- Needs review
L["Complete AH Scan"] = "Kompletter AH Scan" -- Needs review
L["Cooking"] = "Kochen" -- Needs review
L["Descending"] = "Absteigend" -- Needs review
L["Enable display of AuctionDB data in tooltip."] = "Aktiviere die Anzeige der AuctionDB-Daten im Tooltip." -- Needs review
L["Enchanting"] = "Verzauberkunst" -- Needs review
L["Engineering"] = "Ingenieurskunst" -- Needs review
L["Error: AuctionHouse window busy."] = "Fehler: Auktionshaus-Fenster ist beschäftigt." -- Needs review
L["General Options"] = "Allgemeine Optionen" -- Needs review
L["GetAll Scan:"] = "Komplettscan" -- Needs review
L["Hide poor quality items"] = "Verstecke Gegenstände von geringer Qualität" -- Needs review
L["If checked, Auctioneer will be prevented from scanning / processing AuctionDB's scans."] = "Wenn markiert wird verhindert, dass Auctioneer \"AuctionDB\" Scans scannt oder verarbeitet." -- Needs review
L[ [=[If checked, a GetAll scan will be used whenever possible.

WARNING: With any GetAll scan there is a risk you may get disconnected from the game.]=] ] = [=[Wenn aktiviert, wird immer ein Komplettscan durchgeführt, wenn dies möglich ist.

WARNUNG: bei einem Komplettscan könntest du vom Spiel disconnected werden.]=] -- Needs review
L["If checked, a regular scan will scan for this profession."] = "Wenn aktiviert, wird ein regulärer Scan für diesen Beruf durchgeführt." -- Needs review
L["If checked, poor quality items won't be shown in the search results."] = "Wenn markiert, tauchen Gegenstände niedriger Qualität nicht in den Suchergebnissen auf." -- Needs review
L["Inscription"] = "Inschriftenkunde" -- Needs review
L["Invalid value entered. You must enter a number between 5 and 500 inclusive."] = "Eingebener Wert ist ungültig. Sie müssen eine Zahl zwischen 5 und 5 eingeben." -- Needs review
L["Item Link"] = "Gegenstands-Link" -- Needs review
L["Item MinLevel"] = "Gegenstand MinLevel" -- Needs review
L["Item SubType Filter"] = "Gegenstands-Unterkategorie-Filter" -- Needs review
L["Item Type Filter"] = "Gegenstands-Kategorie-Filter" -- Needs review
L["Items %s - %s (%s total)"] = "Gegenstände %s - %s (%s gesamt)" -- Needs review
L["Items per page"] = "Gegenstände pro Seite" -- Needs review
L["Jewelcrafting"] = "Juwelenschleifen" -- Needs review
L["Last Scanned"] = "Zuletzt gescannt" -- Needs review
L["Leatherworking"] = "Lederkunst" -- Needs review
L["Market Value"] = "Marktwert" -- Needs review
L["Minimum Buyout"] = "Minimaler Sofortkaufpreis" -- Needs review
L["Next Page"] = "Nächste Seite" -- Needs review
L["No items found"] = "Keine Gegenstände gefunden" -- Needs review
L["Not Ready"] = "Nicht bereit" -- Needs review
L["Nothing to scan."] = "Nichts zum scannen vorhanden." -- Needs review
L["Opens the main TSM window to the AuctionDB page where you can search through AuctionDB's scan data to quickly lookup items in the AuctionDB database."] = "Öffnet im TSM Hauptfenster die Seite der \"AuctionDB\", wo Sie die Scandaten der \"AuctionDB\" durchsuchen und auf einen Blick Itemdaten nachschlagen können. " -- Needs review
L["Options"] = "Optionen" -- Needs review
L["Previous Page"] = "Vorherige Seite" -- Needs review
L["Professions to scan for:"] = "Beruf zum scannen:" -- Needs review
L["Ready"] = "Bereit" -- Needs review
L["Ready in %s min and %s sec"] = "Bereit in %s Minuten und %s Sekunden" -- Needs review
L["Refresh"] = "Aktualisieren" -- Needs review
L["Refreshes the current search results."] = "Aktualisiert die derzeitigen Suchergebnisse." -- Needs review
L["Reset Data"] = "Daten zurücksetzen" -- Needs review
L["Resets AuctionDB's scan data"] = "Setzt die Scandaten der \"AuctionDB\" zurück" -- Needs review
L["Run GetAll Scan"] = "Starte Komplettscan" -- Needs review
L["Run GetAll Scan if Possible"] = "Starte Komplettscan wenn möglich" -- Needs review
L["Run Regular Scan"] = "Starte normalen Scan" -- Needs review
L["Run Scan"] = "Starte scan" -- Needs review
L["Scan complete!"] = "Scan komplett!" -- Needs review
L["Scan interupted due to auction house being closed."] = "Scan wurde abgebrochen da das Auktionshaus geschlossen wurde." -- Needs review
L["Search"] = "Suche" -- Needs review
L["Search Options"] = "Suchoptionen" -- Needs review
L["Search Scan Data"] = "Durchsuche Scandaten " -- Needs review
L["Seen Last Scan (Yours)"] = "Beim letzen Scan gesehen(Ihre)" -- Needs review
L["Select how you would like the search results to be sorted. After changing this option, you may need to refresh your search results by hitting the \"Refresh\" button."] = "Wählen Sie aus, wie Ihre Suchergebnisse sortiert werden sollen. Nach Ändern der Option kann es notwendig sein Ihre Suchergebnisse zu aktualisieren, indem Sie den \"Aktualisieren\"-Button drücken." -- Needs review
L["Sort items by"] = "Gegenstände sortieren nach" -- Needs review
L["Sort search results in ascending order."] = "Sortiere Suchergebnisse in aufsteigender Reihenfolge." -- Needs review
L["Sort search results in descending order."] = "Sortiere Suchergebnisse in absteigender Reihenfolge." -- Needs review
L[ [=[Starts scanning the auction house based on the below settings.

If you are running a GetAll scan, your game client may temporarily lock up.]=] ] = "Starte den Scan mit der unteren Konfiguration." -- Needs review
L["Tailoring"] = "Schneider" -- Needs review
L["This determines how many items are shown per page in results area of the \"Search\" tab of the AuctionDB page in the main TSM window. You may enter a number between 5 and 500 inclusive. If the page lags, you may want to decrease this number."] = "Dies bestimmt wieviele Gegenstände pro Seite im Ergebnisbereich des \"Suche\"-Reiters der \"AuctionDB\" im TSM Hauptfenster angezeigt werden. Sie können eine Zahl zwischen 5 und 500 wählen. Wenn die Seite Verzögerungen verursacht, wäre es ratsam die Anzahl zu reduzieren." -- Needs review
L["Use the search box and category filters above to search the AuctionDB data."] = "Benutzen Sie die Sucheingabe und Kategorie-Filter oben um die \"AuctionDB\"-Daten zu durchsuchen." -- Needs review
L["You can filter the results by item subtype by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in the item type dropdown and \"Herbs\" in this dropdown."] = "Sie können die Ergebnisse eingrenzen, indem Sie eine Gegenstands-Unterkategorie aus der Auswahlliste wählen. Wenn Sie zum Beispiel nach allen Kräutern suchen wollen, würden Sie \"Handwerkswaren\" als Gegenstands-Kategorie wählen und \"Kräuter\" in dieser Auswahlliste." -- Needs review
L["You can filter the results by item type by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in this dropdown and \"Herbs\" as the subtype filter."] = "Sie können die Ergebnisse eingrenzen, indem Sie eine Gegenstands-Kategorie aus der Auswahlliste wählen. Wenn Sie zum Beispiel nach allen Kräutern suchen wollen, würden Sie \"Handwerkswaren\" in dieser Auswahlliste wählen und \"Kräuter\" in der Auswahlliste für die Gegenstands-Unterkategorie." -- Needs review
L["You can use this page to lookup an item or group of items in the AuctionDB database. Note that this does not perform a live search of the AH."] = "Diese Seite können Sie benutzen um Gegenstände oder Gegenstandsgruppe in der \"AuctionDB\"-Datenbank nachzuschlagen. Beachten Sie, dass dies keine Echtzeitsuche für das AH ist." -- Needs review
L["Your version of the main TradeSkillMaster addon is out of date. Please update it in order to be able to view this page."] = "Ihre Version des \"TradesSkillMaster\"-Hauptmoduls ist veraltet. Bitte updaten Sie, um die Seite korrekt anzeigen zu können." -- Needs review
L["|cffff0000WARNING:|r As of 4.0.1 there is a bug with GetAll scans only scanning a maximum of 42554 auctions from the AH which is less than your auction house currently contains. As a result, thousands of items may have been missed. Please use regular scans until blizzard fixes this bug."] = "|cffff0000WARNUNG:|r Seit 4.0.1 existiert ein Bug mit Komplettscans, da nur maximal 42554 Auktionen eingelesen werden können. Da das Auktionshaus momentan mehr Auktionen hat, könnten dadurch tausende Items übersehen werden. Bitte nutze normale Scans bis Blizzard diesen Bug fixed." -- Needs review
 