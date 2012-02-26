-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_AuctionDB - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctiondb.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_AuctionDB Locale - frFR
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_AuctionDB/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_AuctionDB", "frFR")
if not L then return end

L["%s ago"] = "Il y a %s"
L["<No Item SubType Filter>"] = "<Aucune sous-catégorie d'objet>"
L["<No Item Type Filter>"] = "<Aucune catégorie d'objet>"
L["Alchemy"] = "Alchimie"
L["Any items in the AuctionDB database that contain the search phrase in their names will be displayed."] = "Tout objets présent dans la base de donnée d'AuctionDB contenant la phrase recherché dans son nom sera affiché."
L["Are you sure you want to clear your AuctionDB data?"] = "Êtes vous sûr de vouloir vider les données d'AuctionDB?"
L["Ascending"] = "Croissant"
L["Auction house must be open in order to scan."] = "L’hôtel des vente doit être ouvert pour pouvoir lancer l'analyse."
L["AuctionDB - Auction House Scanning"] = "AuctionDB - Analyse de l’hôtel des vente"
L["AuctionDB - Run Scan"] = "AuctionDB - Lancer une analyse"
L["AuctionDB - Scanning"] = "AuctionDB - Analyse en cours"
L["AuctionDB Market Value:"] = "AuctionDB - Valeur du marché:"
L["AuctionDB Min Buyout:"] = "AuctionDB - Prix Minimum:"
L["AuctionDB Seen Count:"] = "AuctionDB - Nbr de vue:"
L["Blacksmithing"] = "Forge"
L["Block Auctioneer while Scanning."] = "Bloquer Auctioneer pendant l'analyse de TSM"
L["Complete AH Scan"] = "Analyse complète"
L["Cooking"] = "Cuisine"
L["Descending"] = "Décroissant"
L["Enable display of AuctionDB data in tooltip."] = "Activer l'affichage des données d'AuctionDB dans les tooltip."
L["Enchanting"] = "Enchantement"
L["Engineering"] = "Ingénierie"
L["Error: AuctionHouse window busy."] = "Erreur: Fenêtre de l’hôtel des ventes occupé."
L["General Options"] = "Options générales"
L["GetAll Scan:"] = "Analyse complète:"
L["Hide poor quality items"] = "Masquer les objets gris"
L["If checked, Auctioneer will be prevented from scanning / processing AuctionDB's scans."] = "Si coché, Auctioneer ne pourra pas faire n'analyse en même temps qu'AuctionDB"
L[ [=[If checked, a GetAll scan will be used whenever possible.

WARNING: With any GetAll scan there is a risk you may get disconnected from the game.]=] ] = [=[Si coché, une analyse complète sera effectué dès que possible.

ATTENTION: Une analyse complète de l'HV risque de vous déconnecter du jeu.]=]
L["If checked, a regular scan will scan for this profession."] = "Si coché, cette profession sera analysé."
L["If checked, poor quality items won't be shown in the search results."] = "Si coché, les objets gris ne seront pas affiché lors de la recherche"
L["Inscription"] = "Calligraphie"
L["Invalid value entered. You must enter a number between 5 and 500 inclusive."] = "Valeur non valide. Vous devez entrer un nombre entre 5 et 500 inclus."
L["Item Link"] = "Lien de l'objet"
L["Item MinLevel"] = "Niveau min. de l'objet"
L["Item SubType Filter"] = "Sous catégorie de l'objet"
L["Item Type Filter"] = "Catégorie de l'objet"
L["Items %s - %s (%s total)"] = "Objets %s - %s (%s au total)"
L["Items per page"] = "Objets par page"
L["Jewelcrafting"] = "Joaillerie"
L["Last Scanned"] = "Dernière fois analysé"
L["Leatherworking"] = "Travail du Cuir"
L["Market Value"] = "Prix du marché"
L["Minimum Buyout"] = "Prix d'achat Minimum"
L["Next Page"] = "Page suivante"
L["No items found"] = "Aucun objet trouvé"
L["Not Ready"] = "Pas prêt"
L["Nothing to scan."] = "Rien à analyser."
L["Opens the main TSM window to the AuctionDB page where you can search through AuctionDB's scan data to quickly lookup items in the AuctionDB database."] = "Ouvre la fenêtre principale de TSM et affiche la fenêtre d'AuctionDB où vous pourrez chercher des objets dans la base de données d'AuctionDB"
L["Options"] = "Options"
L["Previous Page"] = "Page précédente"
L["Professions to scan for:"] = "Professions à analyser:"
L["Ready"] = "Prêt"
L["Ready in %s min and %s sec"] = "Prêt dans %s min et %s sec"
L["Refresh"] = "Actualiser"
L["Refreshes the current search results."] = "Actualise la recherche actuelle"
L["Reset Data"] = "Réinitialiser les données"
L["Resets AuctionDB's scan data"] = "Réinitialise les données d'AuctionDB"
L["Run GetAll Scan"] = "Lancer une analyse complète"
L["Run GetAll Scan if Possible"] = "Lancer une analyse complète si possible"
L["Run Regular Scan"] = "Lancer une analyse normale"
L["Run Scan"] = "Lancer une analyse"
L["Scan complete!"] = "Analyse terminée!"
L["Scan interupted due to auction house being closed."] = "Analyse interrompue (l’hôtel des vent a été fermé)."
L["Search"] = "Rechercher"
L["Search Options"] = "Options de recherche"
L["Search Scan Data"] = "Chercher les données scannées"
L["Seen Last Scan (Yours)"] = "Vu au dernier scan (Vos objets)"
L["Select how you would like the search results to be sorted. After changing this option, you may need to refresh your search results by hitting the \"Refresh\" button."] = "Choisissez comment vous voulez que les objets soit trier. Après avoir changer cette option, cliquez sur \"Actualiser\" pour mettre a jour le mode de tri."
L["Sort items by"] = "Trier les objets par"
L["Sort search results in ascending order."] = "Trier les résultat par ordre croissant"
L["Sort search results in descending order."] = "Trier les résultat par ordre décroissant"
L[ [=[Starts scanning the auction house based on the below settings.

If you are running a GetAll scan, your game client may temporarily lock up.]=] ] = [=[Commence une analyse de l’hôtel des vente basé sur les paramètres ci-dessous.

Si vous lancez une analyse complète, votre jeu peut se figer quelques instants.]=]
L["Tailoring"] = "Couture"
L["This determines how many items are shown per page in results area of the \"Search\" tab of the AuctionDB page in the main TSM window. You may enter a number between 5 and 500 inclusive. If the page lags, you may want to decrease this number."] = "Ceci détermine combien d'objets seront affiché par page dans l'onglet de Recherche d'AuctionDB. Vous pouvez entrer un nombre entre 5 et 500 inclus. Si vous subissez quelques lags, baissez ce nombre."
L["Use the search box and category filters above to search the AuctionDB data."] = "Utilisez le champs de recherche ainsi que le tri par catégorie pour faire une recherche dans les données d'AuctionDB."
L["You can filter the results by item subtype by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in the item type dropdown and \"Herbs\" in this dropdown."] = "Vous pouvez filtrez les résultats en utilisant cette option. Par exemple, si vous voulez chercher toute les herbes, vous choisiriez \"Artisanat\" dans la catégorie puis \"Herbes\" dans la sous catégorie."
L["You can filter the results by item type by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in this dropdown and \"Herbs\" as the subtype filter."] = "Vous pouvez filtrez les résultats en utilisant cette option. Par exemple, si vous voulez chercher toute les herbes, vous choisiriez \"Artisanat\" dans la catégorie puis \"Herbes\" dans la sous catégorie."
L["You can use this page to lookup an item or group of items in the AuctionDB database. Note that this does not perform a live search of the AH."] = "Vous pouvez utiliser cette page pour cherche un objet ou un groupe d'objets dans la base de donnée d'AuctionDB. Notez que ca ne lance pas une analyse en direct de 'HV, mais ne fait que parcourir la base de donnée de AuctionDB."
L["Your version of the main TradeSkillMaster addon is out of date. Please update it in order to be able to view this page."] = "Votre version du module principal de TSM n'est pas a jour. Merci de mettre a jour l'addon pour être en mesure de voir cette page."
L["|cffff0000WARNING:|r As of 4.0.1 there is a bug with GetAll scans only scanning a maximum of 42554 auctions from the AH which is less than your auction house currently contains. As a result, thousands of items may have been missed. Please use regular scans until blizzard fixes this bug."] = "|cffff0000ATTENTION:|r Depuis la 4.0.1, il y a un bug avec l'analyse complète. Elle ne peut analyser que 42554 ventes depuis l'HV, ce qui est moins que ce que votre HV contient actuellement. Résultat: Des milliers d'objets peuvent avoir été oublié. Merci d'utiliser les analyses normales en attendant une correction de Blizzard."
 