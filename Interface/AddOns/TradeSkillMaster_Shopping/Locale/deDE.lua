-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Shopping - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_shopping.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Shopping Locale - deDE
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Shopping/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Shopping", "deDE")
if not L then return end

L["%s @ %s(%s per)"] = "%s @ %s(%s pro)"
L["%s @ %s(~%s per )"] = "%s @ %s(%s pro)"
L["%s @ %s(~%s per Enchanting Mat)"] = "%s @ %s(%s pro Verzauber Mat)"
L["%s @ %s(~%s per Ink)"] = "%s @ %s(%s pro Tinte)"
L["%s @ %s(~%s per Raw Gem)"] = "%s @ %s(%s pro roh Edelstein)"
L["%s below your Dealfinding price."] = "%s unter deinem Dealfinding Preis."
L["%s%% above maximum price."] = "%s%% über maximum Preis."
L["%s%% below maximum price."] = "%s%% unter maximum Preis."
L["<Invalid! See Tooltip>"] = "<Ungültig! Siehe Tooltip>"
L["<Unorganized Items>"] = "<Ungeordnete Items>" -- Needs review
L["Accept"] = "Akzeptieren" -- Needs review
L["Add / Remove Items"] = "Gegenstände hinzufügen/entfernen" -- Needs review
L["Add Item"] = "Füge Gegenstand hinzu"
-- L["Add Item to Dealfinding List:"] = ""
L["Adds an item to the dealfinding list. When you run a dealfinding scan, this item will be searched for and you will be prompted to buy any auctions of this item that meet the criteria you set."] = "Fügt einen Gegenstand der Dealfinder Liste hinzu.Wenn sie einen Dealfinder scan durchführen, werden sie gefragt, ob sie die Gegenstände, die ihren festgelegten Suchkriterien entsprechen, kaufen möchten." -- Needs review
-- L["Arcane Dust"] = ""
L["Are you sure you want to delete the selected profile?"] = "Sind sie sicher, dass sie das ausgewählte Profil löschen möchten?" -- Needs review
L["Auction house must be open in order to scan."] = "Das Auktionsfenster muss zum Scannen geöffnet sein." -- Needs review
L["BC - Blue Quality"] = "BC - Blaue Qualität" -- Needs review
L["BC - Green Quality"] = "BC - Grüne Qualität" -- Needs review
L["BUY"] = "KAUFE"
L["Below are general management options for this item."] = "Nachfolgend finden sie allgemeine Verwaltungsoptionen für diesen Gegenstand." -- Needs review
L["Below are some general options dealfinding will follow for this item."] = "Nachfolgend finden sie einige allgemeine Einstellungen, die der Dealfinder für diesen Gegenstand berücksichtigt." -- Needs review
L["Blackfallow Ink"] = "Schwarzfahltinte" -- Needs review
L["Block Auctioneer while Scanning"] = "Blockiere Auctioneer während des Scannens" -- Needs review
L["Bought at least the max quantity set for this item."] = "Sie haben (mindestens) die maximale Menge, die für diesen Gegenstand festgelegt wurde, erworben." -- Needs review
L["Buy Inks to Trade if Cheaper"] = "Wenn es billige Tinte gibt, dann kaufe sie damit ich damit handeln kann" -- Needs review
L["Buy for:"] = "Kaufe für:"
L["Buy the next cheapest auction."] = "Kaufe den nächst günstigeren Auktionsartikel." -- Needs review
L["Buying: %s(%s at this price)"] = "Kaufe: %s(%s zu diesem Preis)" -- Needs review
L["Cancel"] = "Abbrechen" -- Needs review
L["Cancels automatic mode and allows manual searches to resume."] = "Bricht den automatischen Modus ab und erlaubt das manuelle Weiterführen der Suche." -- Needs review
L["Cata - Blue Quality"] = "Cata - Blaue Qualität" -- Needs review
L["Cata - Green Quality"] = "Cata - Grüne Qualität" -- Needs review
L["Celestial Ink"] = "Firmamenttinte" -- Needs review
L["Config"] = "Einstellungen" -- Needs review
-- L["Configure Dealfinding List"] = ""
-- L["Configures your Dealfinding list."] = ""
L["Copy From"] = "Kopieren von" -- Needs review
L["Copy the settings from one existing profile into the currently active profile."] = "Kopiere die Einstellungen von einem existierenden Profil in das derzeit aktive Profil." -- Needs review
L["Create Folder"] = "Erstelle Ordner" -- Needs review
L["Create a new empty profile."] = "Erstelle neues leeres Profil" -- Needs review
L["Current Profile:"] = "Aktuelles Profil:" -- Needs review
L["Dealfinding"] = "Schnäppchenjagt" -- Needs review
L["Default"] = "Standard" -- Needs review
L["Delete Folder"] = "Lösche Ordner" -- Needs review
L["Delete Selected Item"] = "Ausgewählten Gegenstand löschen" -- Needs review
L["Delete a Profile"] = "Lösche ein Profil" -- Needs review
L["Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."] = "Lösche existierende aber unbenutzte Profile aus der Datenbank um Platz zu gewinnen, und säubere die SavedVariables Datei." -- Needs review
-- L["Disable disenchanting for mats"] = ""
L["Disable prospecting for gems"] = "Deaktiviere das sondieren von Edelsteinen." -- Needs review
L["Disenchanting"] = "Entzaubern"
L["Done shopping."] = "Einkauf beendet." -- Needs review
-- L["Dream Dust"] = ""
L["Edit Selected Item"] = "Ausgewähltes Item editieren" -- Needs review
L["Ethereal Ink"] = "Astraltinte" -- Needs review
L["Even Stacks Only"] = "Nur passende Stacks" -- Needs review
L["Existing Profiles"] = "Vorhandene Profile" -- Needs review
L["Exit Automatic Mode"] = "Automatischen Modus verlassen" -- Needs review
L["Folder Management"] = "Ordner Verwaltung" -- Needs review
L["Folder Name"] = "Ordner Name" -- Needs review
L["Folders are simply for organization of your dealfinding items. They do not provide any additional settings. You can add items to a folder by clicking on the folder name in the list on the left."] = "Die Ordner sind einfach nur dazu da Ihre Schnäppchenjäger Items zu verwalten. Sie bieten keine weiteren Einstellungen. Sie können Items einem Ordner zuordnen, indem Sie den gewünschten Ordner in der linken Liste anklicken." -- Needs review
L["Found %s at this price."] = "%s wurde zu diesem Preis gefunden." -- Needs review
L["GO"] = "Los!" -- Needs review
L["General Options"] = "Allgemeine Einstellungen" -- Needs review
L["Herbs / Ore Only"] = "Nur Kräuter / Erz " -- Needs review
L["Here, you can set the maximum price you want to pay."] = "Hier können Sie den maximalen Preis eintragen, den Sie bereit sind zu zahlen." -- Needs review
L["How many you want to buy."] = "Wieviele sie kaufen möchten." -- Needs review
-- L["Hypnotic Dust"] = ""
L["If checked, blackfallow ink will be shopped for in order to trade down to lower inks if it's cheaper."] = "Wenn ausgewählt, wird Schwarzfahltinte eingekauft oder andere Tinte die billiger ist und die Sie beim NPC gegen Schwarzfahltinte eintauschen können." -- Needs review
L["If checked, only herbs / ore will be searched for; not inks / raw gems."] = "Wenn ausgewählt, wird nach Kräutern / Erz gesucht, und nicht nach Tinte / Rohedelsteine." -- Needs review
L["If checked, the intro screen for scanning for crafting mats will be skipped and the scanning will start immediately after clicking on the sidebar icon."] = "Wenn ausgewählt, wird kein Einführungsbild für die Suche nach Herstellungsmaterialien gezeigt und sofort mit der Suche nachdem das Icon Seitenleiste gedrückt wurde gestartet." -- Needs review
L["If checked, when buying ore / herbs only stacks that are evenly divisible by 5 will be purchased."] = "Bei Aktivierung werden nur Erze/Kräuter gekauft die durch 5 teilbar sind (ohne Rest)." -- Needs review
-- L["If checked, you will not be given the option to buy items to disenchant to obtain enchanting mats."] = ""
L["If checked, you will not be given the option to buy ore in order to obtain raw gems."] = "Wenn ausgewählt, erhalten Sie nicht die Alternative zur Wahl die Rohedelsteine über den Kauf von Erz (durch sondieren) zu Ersteigern." -- Needs review
-- L["Illusion Dust"] = ""
L["Inferno Ink"] = "Infernotinte" -- Needs review
-- L["Infinite Dust"] = ""
L["Ink of the Sea"] = "Meerestinte" -- Needs review
L["Invalid folder name. A folder with this name may already exist."] = "Ungültiger Ordner Name. Ein Ordner mit diesen Name existiert vielleicht schon." -- Needs review
-- L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = ""
L["Item Management"] = "Item Verwaltung" -- Needs review
L["Item has already been added to dealfinding."] = "Item wurde bereits zur Schnäppchensuche hinzugefügt." -- Needs review
L["Item to Add"] = "Item hinzufügen" -- Needs review
-- L["Item was already in the Dealfinding list. Price has been overriden (old price was %s)."] = ""
L["Items in this folder:"] = "Items in diesem Ordner:" -- Needs review
L["Items not in any folder:"] = "Items die in keinem Ordner enthalten sind:" -- Needs review
L["Ivory Ink"] = "Elfenbeintinte" -- Needs review
L["Jadefire Ink"] = "Jadefeuertinte" -- Needs review
L["Lion's Ink"] = "Löwentinte" -- Needs review
L[ [=[Manual controls disabled when Shopping in automatic mode.

Click on the "Exit Automatic Mode" button to enable manual controls.]=] ] = "Die manuelle Steuerung ist deaktiviert wenn sie im automatischem Modus einkaufen." -- Needs review
L["Max Price (Per 1 Item):"] = "Maximaler Preis (pro 1 Item):" -- Needs review
L["Max Price (optional):"] = "Maximaler Preis (beliebig):" -- Needs review
L["Maximum Price"] = "Maximaler Preis" -- Needs review
L["Maximum Price Per Item"] = "Maximaler Preis pro Item" -- Needs review
L["Midnight Ink"] = "Mitternachtstinte" -- Needs review
L["Milling"] = "Zermahlen (Kräuter)" -- Needs review
L["Mode:"] = "Modus:" -- Needs review
L["Moonglow Ink"] = "Mondlichttinte" -- Needs review
L["Name of item to serach for:"] = "Name des Items nachdem Sie suchen wollen:" -- Needs review
L["Name of the new folder."] = "Name des neuen Ordners" -- Needs review
L["New"] = "Neu" -- Needs review
L["New Folder Name"] = "Neuen Ordner Name" -- Needs review
-- L["No auctions are under your Dealfinding prices."] = ""
L["No auctions for this item."] = "Keine Auktionen zu diesem Item gefunden." -- Needs review
L["No auctions found."] = "Keine Auktionen gefunden." -- Needs review
L["No auctions matched \"%s\""] = "Keine Auktionen passen zu \"%s\"" -- Needs review
L["No more auctions"] = "Keine weiteren Auktionen" -- Needs review
L["No more auctions for this item."] = "Keine weiteren Auktionen für dieses Item." -- Needs review
L["No more auctions."] = "Keine weiteren Auktionen." -- Needs review
L["Nothing to scan."] = "Es gibts nichts zu scannen." -- Needs review
L["Only even stacks (5/10/15/20) of this item will be purchased. This is useful for buying herbs / ore to mill / prospect."] = "Es werden nur Stacks gekauft die durch 5 teilbar sind. Damit können Sie diese Kräuter / Erze mahlen oder sondieren." -- Needs review
L["Opens the config window for TradeSkillMaster_Shopping."] = "Öffnet das Einstellungs-Fenster für TradeSkillMaster_Shopping." -- Needs review
L["Options"] = "Einstellungen" -- Needs review
L["Prevents Auctioneer from scanning / processing while Shopping is doing a scan."] = "Verhindere das Auctioneer scant während Einkaufen einen scan durchführt." -- Needs review
L["Profiles"] = "Profile" -- Needs review
L["Prospecting"] = "Sondieren" -- Needs review
L["Quantity (optional)"] = "Anzahl" -- Needs review
L["Remove Item from Dealfinding"] = "Entferne das Item beim Schnäppchenjäger" -- Needs review
L["Removes this item from dealfinding completely."] = "Entferne das Item beim Schnäppchenjäger vollständig." -- Needs review
L["Rename Folder"] = "Ordner umbenennen" -- Needs review
L["Reset Profile"] = "Profil zurücksetzen" -- Needs review
L["Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."] = "Setzte das Profil auf die Grundeinstellungen zurück, falls ihre Konfiguration Fehler hat oder Sie einfach nochmal von vorne Anfangen wollen." -- Needs review
-- L["Run Dealfinding Scan"] = ""
L["SKIP"] = "Überspringen" -- Needs review
L["Scan Canceled"] = "Scan abgebrochen" -- Needs review
-- L["Scan interrupted due to auction house being closed."] = ""
-- L["Scan interrupted due to automatic mode being canceled."] = ""
-- L["Scans for all items in your Dealfinding list."] = ""
L["Select a raw gem which you would like to buy for (through prospecting ore)."] = "Wählen Sie einen Roh-Edelstein aus, den Sie (durch Sondierung von Erz) erhalten möchten." -- Needs review
L["Select an enchanting mat which you would like to buy for (through disenchanting items)."] = "Wählen Sie ein Verzauberungs-Material aus, das sie (durch Entzaubern) erhalten möchten." -- Needs review
L["Select an ink which you would like to buy for (through milling herbs)."] = "Wählen sie eine Tinte aus, die Sie (durch das zermahlen von Kräutern) erhalten möchten." -- Needs review
L["Shimmering Ink"] = "Perlmutttinte" -- Needs review
L["Shop for items to Disenchant"] = "Gegenstände zum Entzaubern kaufen" -- Needs review
L["Shop for items to Mill"] = "Gegenstände zum Mahlen kaufen" -- Needs review
L["Shop for items to Prospect"] = "Gegenstände zum Sondieren kaufen" -- Needs review
L["Shopping - Automatic Mode"] = "Einkaufen - Automatischer Modus" -- Needs review
L["Shopping - Crafting Mats"] = "Einkaufen - Herstellungsmaterial" -- Needs review
L["Shopping - Crafting Mats Options"] = "Einkaufen - Einstellungen für Herstellungsmaterialien" -- Needs review
L["Shopping - Dealfinding"] = "Einkaufen - Dealfinding" -- Needs review
L["Shopping - General Buying"] = "Einkaufen - Allgemeines Kaufen" -- Needs review
L["Shopping - Milling / Disenchanting / Prospecting"] = "Einkaufen - Mahlen / Entzaubern / Sondieren" -- Needs review
L["Shopping - Milling / Disenchanting / Prospecting Options"] = "Einkaufen - Mahlen / Entzaubern / Sondieren - Einstellungen" -- Needs review
L["Shopping - Scanning"] = "Shopping - Durchsuchen" -- Needs review
L["Shopping Options"] = "Einkaufseinstellungen" -- Needs review
L[ [=[Shopping will automatically buy materials you need for your craft queue in TradeSkillMaster_Crafting.

Note that all queues will be shopped for so make sure you clear any queues you don't want to buy mats for.]=] ] = "Shopping (Einkaufen) wird automatisch das Material kaufen, welches Sie zum Abarbeiten Ihrer Herstellungsliste im TradeSkillMaster_Crafting benötigen." -- Needs review
L["Skip Current Item"] = "Aktuelles Item überspringen" -- Needs review
L["Skip Intro Screen"] = "Überspringe das Introbild" -- Needs review
L["Skip this auction."] = "Diese Auktion überspringen" -- Needs review
L["Skips the item currently being shopped for."] = "Überspringt das aktuelle Item welches eingekauft werden soll." -- Needs review
-- L["Soul Dust"] = ""
L["Start Shopping for Crafting Mats!"] = "Shopping zum Einkaufen von Herstellungsmaterialien beginnen!" -- Needs review
L["Start buying!"] = "Mit dem Ersteigern beginnen!" -- Needs review
L["Stop Scanning"] = "Scannen stoppen" -- Needs review
L["Stops the scan."] = "Stoppt den Scan." -- Needs review
-- L["Strange Dust"] = ""
L["The item you entered was invalid. See the tooltip for the \"%s\" editbox for info about how to add items."] = "Das Item welches Sie eingegeben haben war falsch. Schauen Sie sich den Hinweis für \"%s\" an, damit Sie wissen wie Sie es richtig machen." -- Needs review
--[==[ L[ [=[The max price (per 1 item) you want to have a Dealfinding scan buy something for. 

Must be entered in the form of "#g#s#c". For example "5g24s98c" would be 5 gold 24 silver 98 copper.]=] ] = "" ]==]
L[ [=[The most you want to pay for something. 

Must be entered in the form of "#g#s#c". For example "5g24s98c" would be 5 gold 24 silver 98 copper.]=] ] = "Höchstbetrag den Sie für etwas bezahlen möchten." -- Needs review
L["The options below apply to \"Shopping - Crafting Mats\" searches."] = "Die Option unten bezieht sich auf die \"Einkaufen - Herstellungsmaterialien\" Suche." -- Needs review
L["The options below apply to \"Shopping - Milling / Disenchanting / Prospecting\" searches (including those done while shopping for crafting mats)."] = "Die Option unten bezieht sich auf die \"Einkaufen - Mahlen / Entzaubern / Sondieren\" Suche (einschließlich der Suche nach Herstellungsmaterialien)." -- Needs review
L["This is the maximum price you want to pay per item (NOT per stack) for this item. You will be prompted to buy all items on the AH that are below this price."] = "Dies ist der maximale Preis den Sie pro Item (NICHT pro Stack) ausgeben möchten. Bei allen Items die unterhalb dieses Preises gefunden werden, erhalten Sie eine Eingabeaufforderung ob Sie dieses Item kaufen möchten." -- Needs review
-- L["This item has not been seen on the server recently. Until the server has seen the item, Dealfinding will not be able to search for it on the AH and it will show up as the itemID in the Shopping options."] = ""
L["Total Spent this Session:"] = "Während dieser Sitzung insgesamt ausgegeben:" -- Needs review
L["Total Spent this Session: %s Bought this Session: %sAverage Cost Per  this session: %s"] = "Während dieser Sitzung insgesamt ausgegeben: %s Erworben in dieser Sitzung: %s Durchschnittspreis während dieser Sitzung: %s" -- Needs review
L["Total Spent this Session: %sAverage Cost Per  this session: %s"] = "Während dieser Sitzung insgesamt ausgegeben: %s Durchschnittspreis während dieser Sitzung: %s" -- Needs review
L["Total Spent this Session: %sAverage Cost Per Enchanting Mat this session: %s"] = "Gesamtausgaben in dieser Sitzung: %s Durchschnittskosten pro Verzauberungs-Material in dieser Sitzung: %s" -- Needs review
L["Total Spent this Session: %sAverage Cost Per Ink this session: %s"] = "Gesamtausgaben in dieser Sitzung: %s Durchschnittskosten pro Tinte in dieser Sitzung: %s" -- Needs review
L["Total Spent this Session: %sAverage Cost Per Raw Gem this session: %s"] = "Gesamtausgaben in dieser Sitzung: %s Durchschnittskosten pro Rohedelstein in dieser Sitzung: %s" -- Needs review
L["Total Spent this Session: %sEnchanting Mats Bought this Session: %sAverage Cost Per Enchanting Mat this session: %s"] = "Gesamtausgaben in dieser Sitzung: %s Gekauftes Verzauberungs-Material in dieser Sitzung: %s Durchschnittskosten pro Verzauberungs-Material in dieser Sitzung: %s" -- Needs review
L["Total Spent this Session: %sInks Bought this Session: %sAverage Cost Per Ink this session: %s"] = "Gesamtausgaben in dieser Sitzung: %s Gekaufte Tinte in dieser Sitzung: %s Durchschnittskosten pro Tinte in dieser Sitzung: %s" -- Needs review
L["Total Spent this Session: %sItems Bought This Session: %sAverage Cost Per Item this Session: %s"] = "Gesamtausgaben in dieser Sitzung: %s Gekaufte Gegenstände in dieser Sitzung: %s Durchschnittskosten pro Item in dieser Sitzung: %s" -- Needs review
L["Total Spent this Session: %sRaw Gems Bought this Session: %sAverage Cost Per Raw Gem this session: %s"] = "Gesamtausgaben in dieser Session: %s Gekaufte Rohedelsteine in dieser Session: %s Durchschnittskosten pro Rohedelstein in dieser Session: %s" -- Needs review
-- L["Vision Dust"] = ""
L["What would you like to buy?"] = "Was möchten Sie gerne kaufen?" -- Needs review
L["Wrath - Blue Quality"] = "Wrath - Blaue Qualität" -- Needs review
L["Wrath - Epic Quality"] = "Wrath - Epische Qualität" -- Needs review
L["Wrath - Green Quality"] = "Wrath - Grüne Qualität" -- Needs review
L["You can change the active database profile, so you can have different settings for every character."] = "Sie können das aktive Datenbank Profil ändern, damit Sie unterschiedliche Einstellungen für jeden Ihrer Charaktere haben." -- Needs review
L["You can either create a new profile by entering a name in the editbox, or choose one of the already exisiting profiles."] = "Sie können entweder ein neues Profil erstellen, indem Sie einen Namen in das Feld eingeben, oder eines der schon existierenden Profile wählen." -- Needs review
L["You can either drag an item into this box, paste (shift click) an item link into this box, or enter an itemID."] = "Sie können entweder ein Item über Drag&Drop in dieses Fenster ziehen, oder über Shift-Mausklick einfügen, oder die Item-ID eingeben." -- Needs review
L["per item"] = "pro Item" -- Needs review
