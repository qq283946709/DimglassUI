-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Crafting - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_crafting.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Crafting Locale - esMX
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Crafting/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Crafting", "esMX")
if not L then return end

-- L["%s not queued! Min restock of %s is higher than max restock of %s"] = ""
-- L["2H Weapon"] = ""
L["AH/Bags/Bank/Alts"] = "CS/Bolsas/Banco/Alts"
L["Accept"] = "Aceptar"
-- L["Add Crafted Items from this Group to Auctioning Groups"] = ""
L["Add Item to New Group"] = "Agregar Objeto a Nuevo Grupo"
L["Add Item to Selected Group"] = "Agregar Objeto al Grupo Seleccionado"
L["Add Item to TSM_Auctioning"] = "Agregar Objeto a TSM_Auctioning"
-- L["Added %s crafted items to %s individual groups."] = ""
-- L["Added %s crafted items to: %s."] = ""
L["Additional Item Settings"] = "Configuracion de Objeto Adicionales"
L["Addon to use for alt data:"] = "Addon a usar para información de alts:"
-- L["Adds all items in this Crafting group to Auctioning group(s) as per the above settings."] = ""
L["Alchemy was not found so the craft queue has been disabled."] = "No se encontró Alquimia por lo que la cola de creación se deshabilito."
-- L["All"] = ""
-- L["All in Individual Groups"] = ""
-- L["All in Same Group"] = ""
-- L["Allows you to override the minimum profit settings for this profession."] = ""
-- L["Allows you to set a custom maximum queue quantity for this item."] = ""
-- L["Allows you to set a custom maximum queue quantity for this profession."] = ""
L["Allows you to set a custom minimum queue quantity for this item."] = "Te permite fijar una cantidad minima de cola personalizada para este objeto"
-- L["Allows you to set a custom minimum queue quantity for this profession."] = ""
-- L["Allows you to set a different craft sort method for this profession."] = ""
-- L["Allows you to set a different craft sort order for this profession."] = ""
-- L["Always queue this item."] = ""
L["Are you sure you want to delete the selected profile?"] = "Está seguro que desea eliminar el perfil seleccionado?"
-- L["Armor"] = ""
-- L["Armor - Back"] = ""
-- L["Armor - Chest"] = ""
-- L["Armor - Feet"] = ""
-- L["Armor - Hands"] = ""
-- L["Armor - Head"] = ""
-- L["Armor - Legs"] = ""
-- L["Armor - Shield"] = ""
-- L["Armor - Shoulders"] = ""
-- L["Armor - Waist"] = ""
-- L["Armor - Wrists"] = ""
-- L["Ascending"] = ""
-- L["Auction House"] = ""
-- L["Auction House Value"] = ""
L["AuctionDB - Market Value"] = "AuctionDB - Valor de mercado"
L["AuctionDB - Minimum Buyout"] = "AuctionDB - Precio Compra Mínima"
-- L["Auctionator - Auction Value"] = ""
L["Auctioneer"] = "Auctioneer"
L["Auctioneer - Appraiser"] = "Auctioneer - Appraiser"
L["Auctioneer - Market Value"] = "Auctioneer - Valor de mercado"
L["Auctioneer - Minimum Buyout"] = "Auctioneer - Precio Compra Mínima"
-- L["Bags"] = ""
-- L["Bars"] = ""
-- L["Blackfallow Ink"] = ""
L["Blacksmithing was not found so the craft queue has been disabled."] = "No se encontró Herrería por que lo que la cola de creación se deshabilito."
-- L["Blue Gems"] = ""
-- L["Boots"] = ""
-- L["Bracers"] = ""
-- L["Buy From Vendor"] = ""
L["Can not set a max restock quantity below the minimum restock quantity of %d."] = "No se puede fijar una cantidad maxima de reposición menor a la cantidad mínima de %d."
L["Cancel"] = "Cancelar"
-- L["Celestial Ink"] = ""
L["Characters to include:"] = "Personajes a incluir:"
-- L["Checking this box will allow you to set a custom, fixed price for this item."] = ""
-- L["Chest"] = ""
L["Class"] = "Clase"
L["Clear Queue"] = "Limpiar cola."
-- L["Clear Tradeskill Filters"] = ""
-- L["Click to view and adjust how the price of this material is calculated."] = ""
-- L["Cloak"] = ""
-- L["Close TSM Frame When Opening Craft Management Window"] = ""
L["Close TradeSkillMaster_Crafting"] = "Cerrar TradeSkillMaster_Crafting"
-- L["Cloth"] = ""
-- L["Combine/Split Essences/Eternals"] = ""
-- L["Companions"] = ""
-- L["Consumables"] = ""
L["Cooking was not found so the craft queue has been disabled."] = "No se encontró Cocina por lo que la cola de creación se deshabilito."
L["Copy From"] = "Copiar desde"
L["Copy the settings from one existing profile into the currently active profile."] = "Copiar la configuración de un perfil existente en el perfil activado actualmente."
-- L["Cost"] = ""
-- L["Cost to Craft"] = ""
L["Cost: %s Market Value: %s Profit: %s Times Crafted: %s"] = "Costo: %s Valor de Mercado: %s Ganancía: %s Cantidad de veces creado: %s"
L["Craft"] = "Crear"
-- L["Craft Item (x%s)"] = ""
L["Craft Management Window"] = "Ventana de gestión de creaciones"
L["Craft Next"] = "Crear siguiente"
L["Craft Queue Reset"] = "Reiniciar la cola de creaciones"
-- L["Crafted Item Value"] = ""
-- L["Crafting Cost: %s (%s profit)"] = ""
L["Crafting Options"] = "Opciones de Creaciones"
L["Crafts"] = "Creaciones"
-- L["Create Auctioning Groups"] = ""
L["Create a new empty profile."] = "Crear un perfil vacio nuevo"
L["Current Profile:"] = "Perfil actual"
-- L["Custom"] = ""
-- L["Custom Value"] = ""
L["Data"] = "Información"
L["DataStore"] = "DataStore"
-- L["Death Knight"] = ""
L["Default"] = "Por Defecto"
L["Delete a Profile"] = "Eliminar un Perfil"
L["Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."] = "Elimina perfiles existentes y sin usar de la base de datos para hacer espacio, y limpia el archivo SavedVariables"
-- L["Descending"] = ""
L["Disable All Crafts"] = "Deshabilitar todas las creaciones"
L["Don't queue this item."] = "No incluir este objeto en la cola"
L["Double Click Queue"] = "Doble click cola"
-- L["Druid"] = ""
-- L["Edit Custom Value"] = ""
-- L["Elixir"] = ""
L["Enable / Disable showing this craft in the craft management window."] = "Habilitar / Deshabilitar mostrar esta creacion en la ventana de gestion de creaciones."
L["Enable All Crafts"] = "Habilitar todas las creaciones"
-- L["Enable New TradeSkills"] = ""
L["Enchanting was not found so the craft queue has been disabled."] = "No se encontró Encantamiento por lo que la cola de creación se ha deshabilitado."
L["Engineering was not found so the craft queue has been disabled."] = "No se encontró Ingeniería por lo que la cola de creación se deshabilito."
-- L["Enter a value that Crafting will use as the cost of this material."] = ""
-- L["Enter what you want to multiply the cost of the other item by to calculate the price of this mat."] = ""
-- L["Estimated Total Mat Cost:"] = ""
-- L["Estimated Total Profit:"] = ""
-- L["Ethereal Ink"] = ""
L["Existing Profiles"] = "Perfiles existentes"
-- L["Explosives"] = ""
-- L["Export Crafts to TradeSkillMaster_Auctioning"] = ""
-- L["Filter out items with low seen count."] = ""
-- L["Flask"] = ""
-- L["Force Rescan of Profession (Advanced)"] = ""
L["Frame Scale"] = "Escala del cuadro"
L["Gathering"] = "Recolección"
L["General"] = "General"
-- L["General Price Sources"] = ""
-- L["General Setting Overrides"] = ""
-- L["General Settings"] = ""
L["Get Craft Prices From:"] = "Obtener precios de creaciones desde:"
L["Get Mat Prices From:"] = "Obtener precios de materiales desde:"
-- L["Gloves"] = ""
L["Gold Amount"] = "Cantidad de oro"
-- L["Green Gems"] = ""
L["Group Inscription Crafts By:"] = "Agrupar creaciones de Inscripción por:"
-- L["Group to Add Crafts to:"] = ""
L["Guilds to include:"] = "Hermandades a incluir:"
-- L["Guns"] = ""
L["Help"] = "Ayuda"
-- L["Here you can view and adjust how Crafting is calculating the price for this material."] = ""
-- L["Here, you can override default restock queue settings."] = ""
-- L["Here, you can override general settings."] = ""
-- L["How to add crafts to Auctioning:"] = ""
-- L["Hunter"] = ""
-- L["If checked, Only crafts that are enabled (have the checkbox to the right of the item link checked) below will be added to Auctioning groups."] = ""
-- L["If checked, any crafts which are already in an Auctioning group will be removed from their current group and a new group will be created for them. If you want to maintain the groups you already have setup that include items in this group, leave this unchecked."] = ""
-- L["If checked, the crafting cost of items will be shown in the tooltip for the item."] = ""
L["If checked, the main TSM frame will close when you open the craft management window."] = "Si se marca, el cuadro principal de TSM se cerrara cuando abras la ventana de gestión de creaciones."
-- L["If checked, the profit percent (profit/sell price) will be shown next to the profit in the craft management window."] = ""
-- L["If checked, when Crafting scans a tradeskill for the first time (such as after you learn a new one), it will be enabled by default."] = ""
-- L["If checked, you can change the price source for this mat by clicking on one of the checkboxes below. This source will be used to determine the price of this mat until you remove the override or change the source manually. If this setting is not checked, Crafting will automatically pick the cheapest source."] = ""
L["If enabled, any craft with a profit over this percent of the cost will be added to the craft queue when you use the \"Restock Queue\" button."] = "Si se activa cualquier creación con una ganancía superior a este porcentaje del costo será agregada a la cola de creación cuando uses el boton \"Reponer Cola\""
L["If enabled, any craft with a profit over this value will be added to the craft queue when you use the \"Restock Queue\" button."] = "Si se activa cualquier creacion con una ganancia superior a este valor sera agregada a la cola de creaciones cuando uses el boton de \"Reponer Cola\""
-- L["If enabled, any item with a seen count below this seen count filter value will not be added to the craft queue when using the \"Restock Queue\" button. You can overrride this filter for individual items in the \"Additional Item Settings\"."] = ""
-- L["Ignore Seen Count Filter"] = ""
L["In Bags"] = "En bolsas"
-- L["Include Crafts Already in a Group"] = ""
L["Include Items on AH When Restocking"] = "Incluir los objetos en la Casa de Subastas al Reponer"
L["Ink"] = "Tinta"
-- L["Ink of the Sea"] = ""
-- L["Inks"] = ""
L["Inscription crafts can be grouped in TradeSkillMaster_Crafting either by class or by the ink required to make them."] = "Creaciones de inscripción se puede agrupar en TradeSkillMaster_Crafting ya sea por clase o por tinta requierida para crearlos."
L["Inscription was not found so the craft queue has been disabled."] = "No se encontró inscripción por lo que la cola de creación se deshabilito."
-- L["Invalid Number"] = ""
-- L["Invalid item entered. You can either link the item into this box or type in the itemID from wowhead."] = ""
-- L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = ""
L["Inventory Settings"] = "Configuración de Inventario"
-- L["Item Enhancements"] = ""
-- L["Item Level"] = ""
-- L["Item Name"] = ""
L["Items will only be added to the queue if the number being added is greater than this number. This is useful if you don't want to bother with crafting singles for example."] = "Los objetos se agregaran a la cola solo si el número agregado es mayor que este número. Esto es utíl si no quieres molestarte en crear objetos en singular por ejemplo. " -- Needs review
-- L["Jadefire Ink"] = ""
L["Jewelcrafting was not found so the craft queue has been disabled."] = "No se encontró Joyería por lo que la cola de creación se deshabilito."
-- L["Leather"] = ""
L["Leatherworking was not found so the craft queue has been disabled."] = "No se encontró Peletería por lo que la cola de creación se deshabilito."
-- L["Level 1-35"] = ""
-- L["Level 36-70"] = ""
-- L["Level 71+"] = ""
-- L["Lion's Ink"] = ""
-- L["Mage"] = ""
L["Manual Entry"] = "Entrada manual" -- Needs review
-- L["Mark as Unknown (\"----\")"] = ""
-- L["Mat Price"] = ""
-- L["Material Cost Options"] = ""
L["Materials"] = "Materiales"
L["Max Restock Quantity"] = "Cantidad de Reposición maxima"
-- L["Meta Gems"] = ""
-- L["Midnight Ink"] = ""
-- L["Mill"] = ""
-- L["Milling"] = ""
L["Min Restock Quantity"] = "Cantidad de Reposición mínima"
L["Minimum Profit (in %)"] = "Ganancia mínima (en %)"
L["Minimum Profit (in gold)"] = "Ganancia mínima (en oro)"
L["Minimum Profit Method"] = "Metodo de Ganancia mínima "
-- L["Misc Items"] = ""
-- L["Multiple of Other Item Cost"] = ""
-- L["NOTE: Milling prices can be viewed / adjusted in the mat options for pigments. Click on the button below to go to the pigment options."] = ""
L["Name"] = "Nombre"
L["Name of New Group to Add Item to:"] = "Nombre del Nuevo Grupo para agregar el objeto:" -- Needs review
L["Need"] = "Necesidad"
L["New"] = "Nuevo"
L["No Minimum"] = "Sin mínimo"
L["No crafts have been added for this profession. Crafts are automatically added when you click on the profession icon while logged onto a character which has that profession."] = "Ninguna creación se ha agregado para esta profesión. Las creaciones se agregan automaticamente cuando haces clic en el icono de la profesión mientras estas conectado en un personaje que tiene esa profesión."
-- L["Note: By default, Crafting will use the second cheapest value (herb or pigment cost) to calculate the cost of the pigment as this provides a slightly more accurate value."] = ""
-- L["Number Owned"] = ""
L["OK"] = "OK"
L["On-Hand Queue"] = "Listar cola a mano" -- Needs review
-- L["Only Included Enabled Crafts"] = ""
L["Open Alchemy"] = "Abrir Alquimia"
L["Open Blacksmithing"] = "Abrir Herrería"
L["Open Cooking"] = "Abrir Cocina"
L["Open Enchanting"] = "Abrir Encantamiento"
L["Open Engineering"] = "Abrir Ingeniería"
L["Open Inscription"] = "Abrir Inscripción"
L["Open Jewelcrafting"] = "Abrir Joyería"
L["Open Leatherworking"] = "Abrir Peletería"
-- L["Open Mat Options for Pigment"] = ""
-- L["Open Smelting"] = ""
L["Open Tailoring"] = "Abrir Sastrería"
L["Open TradeSkillMaster_Crafting"] = "Abrir TradeSkillMaster_Crafting"
-- L["Options"] = ""
-- L["Orange Gems"] = ""
-- L["Other"] = ""
-- L["Other Consumable"] = ""
-- L["Other Item"] = ""
-- L["Override Craft Sort Method"] = ""
-- L["Override Craft Sort Order"] = ""
L["Override Max Restock Quantity"] = "Sobreescribir cantidad maxima de reposición"
L["Override Min Restock Quantity"] = "Sobreescribir cantidad mínima de reposición"
-- L["Override Minimum Profit"] = ""
-- L["Override Price Source"] = ""
-- L["Paladin"] = ""
L["Percent and Gold Amount"] = "Porcentaje y cantidad de oro"
L["Percent of Cost"] = "Porcentaje del costo"
L["Percent to subtract from buyout when calculating profits (5% will compensate for AH cut)."] = "Porcentaje a extraer del precio "
-- L["Potion"] = ""
-- L["Price Multiplier"] = ""
L["Price Settings"] = "Configuración de precios"
-- L["Price Source"] = ""
-- L["Price:"] = ""
-- L["Priest"] = ""
-- L["Prismatic Gems"] = ""
L["Profession was not found so the craft queue has been disabled."] = "No se encontro la profesión por lo que la cola de creación se deshabilito."
-- L["Profession-Specific Settings"] = ""
L["Profiles"] = "Perfiles"
L["Profit"] = "Ganancia"
L["Profit Deduction"] = "Deducción de ganancia"
-- L["Purple Gems"] = ""
-- L["Red Gems"] = ""
L["Reset Profile"] = "Reiniciar Perfil"
L["Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."] = "Reiniciar el perfil actual a sus valores por defecto, en caso de que tu configuración este rota, o simplemente quieras empezar de nuevo."
L["Restock Queue"] = "Reponer cola"
-- L["Restock Queue Overrides"] = ""
L["Restock Queue Settings"] = "Configuraciones de reponer cola"
-- L["Right click to remove all items with this mat from the craft queue."] = ""
-- L["Rogue"] = ""
-- L["Scopes"] = ""
-- L["Scrolls"] = ""
-- L["Seen Count"] = ""
-- L["Seen Count Filter"] = ""
-- L["Seen Count Source"] = ""
-- L["Select an Auctioning group to add these crafts to."] = ""
-- L["Select the crafts you would like to add to Auctioning and use the settings / buttons below to do so."] = ""
-- L["Set Market Value to Auctioning Fallback"] = ""
-- L["Shaman"] = ""
-- L["Shield"] = ""
-- L["Shimmering Ink"] = ""
L["Show Craft Management Window"] = "Mostrar la ventana de gestión de creaciones."
-- L["Show Crafting Cost in Tooltip"] = ""
-- L["Show Profit Percentages"] = ""
-- L["Smelting was not found so the craft queue has been disabled."] = ""
-- L["Sort Crafts By"] = ""
-- L["Sort Order:"] = ""
-- L["Sort crafts in ascending order."] = ""
-- L["Sort crafts in descending order."] = ""
-- L["Staff"] = ""
L["Status"] = "Estado."
L["TSM_Auctioning Group to Add Item to:"] = "TSM_Auctioning Grupo al cual agregar objeto:"
L["Tailoring was not found so the craft queue has been disabled."] = "No se encontró Sastrería por lo que la cola de creación se deshabilito."
-- L["The checkboxes in next to each craft determine enable / disable the craft being shown in the Craft Management Window."] = ""
-- L["The item you want to base this mat's price on. You can either link the item into this box or type in the itemID from wowhead."] = ""
-- L["TheUndermineJournal - Market Price"] = ""
-- L["TheUndermineJournal - Mean"] = ""
L["These options control the \"Restock Queue\" button in the craft management window."] = "Estas opciones controlan el boton de \"Reponer Cola\" en la ventana de gestión de creaciones."
-- L["This is where TradeSkillMaster_Crafting will get material prices. AuctionDB is TradeSkillMaster's auction house data module. Alternatively, prices can be entered manually in the \"Materials\" pages."] = ""
-- L["This is where TradeSkillMaster_Crafting will get prices for crafted items. AuctionDB is TradeSkillMaster's auction house data module."] = ""
L["This item is already in the \"%s\" Auctioning group."] = "Este objeto ya está en el grupo de subastas \"%s\" ."
-- L["This item will always be queued (to the max restock quantity) regardless of price data."] = ""
L["This item will not be queued by the \"Restock Queue\" ever."] = "Este objeto no se agregara nunca a la cola con el botón \"Reponer Cola\"."
L["This item will only be added to the queue if the number being added is greater than or equal to this number. This is useful if you don't want to bother with crafting singles for example."] = "Este objeto se agregará a la cola solo si el numero siendo agregado es mayor o igual que este valor. Esto es útil si no quieres molestarte creando objetos en singular."
-- L["This setting determines how crafts are sorted in the craft group pages (NOT the Craft Management Window)."] = ""
-- L["This setting determines where seen count data is retreived from. The seen count data can be retreived from either Auctioneer or TradeSkillMaster's AuctionDB module."] = ""
-- L["This will allow you to base the price of this item on the price of some other item times a multiplier. Be careful not to create circular dependencies (ie Item A is based on the cost of Item B and Item B is based on the price of Item A)!"] = ""
-- L["This will determine how items with unknown profit are dealth with in the Craft Management Window. If you have the Auctioning module installed and an item is in an Auctioning group, the fallback for the item can be used as the market value of the crafted item (will show in light blue in the Craft Management Window)."] = ""
L["This will set the scale of the craft management window. Everything inside the window will be scaled by this percentage."] = "Esto fijará la escala de la ventana de gestión de creaciones. Todo dentro de la ventana se escalara a este porcentaje."
-- L["Times Crafted"] = ""
L["Total"] = "Total"
L["TradeSkillMaster_AuctionDB"] = "TradeSkillMaster_AuctionDB"
-- L["TradeSkillMaster_Crafting - Scanning..."] = ""
L["TradeSkillMaster_Crafting can use TradeSkillMaster_Gathering or DataStore_Containers to provide data for a number of different places inside TradeSkillMaster_Crafting. Use the settings below to set this up."] = "TradeSkillMaster_Crafting puede usar TradeSkillMaster_Gathering o DataStore_Containers para proporcionar datos de un numero de diferentes lugares dentro de TradeSkillMaster_Crafting. Usa las opciones abajo para configurar está opción."
-- L["Transmutes"] = ""
-- L["Trinkets"] = ""
-- L["Unknown Profit Queuing"] = ""
-- L["Use auction house data from the addon you have selected in the Crafting options for the value of this mat."] = ""
L["Use the links on the left to select which page to show."] = "Usa los enlaces a la izquierda para seleccionar que página mostrar."
-- L["Use the price of buying herbs to mill as the cost of this material."] = ""
-- L["Use the price that a vendor sells this item for as the cost of this material."] = ""
-- L["User-Defined Price"] = ""
-- L["Vendor"] = ""
-- L["Vendor Trade"] = ""
-- L["Vendor Trade (x%s)"] = ""
-- L["Warlock"] = ""
-- L["Warning: The min restock quantity must be lower than the max restock quantity."] = ""
--[==[ L[ [=[Warning: Your default minimum restock quantity is higher than your maximum restock quantity! Visit the "Craft Management Window" section of the Crafting options to fix this!

You will get error messages printed out to chat if you try and perform a restock queue without fixing this.]=] ] = "" ]==]
-- L["Warrior"] = ""
-- L["Weapon"] = ""
-- L["Weapon - Main Hand"] = ""
-- L["Weapon - One Hand"] = ""
-- L["Weapon - Thrown"] = ""
-- L["Weapon - Two Hand"] = ""
-- L["When you click on the \"Restock Queue\" button enough of each craft will be queued so that you have this maximum number on hand. For example, if you have 2 of item X on hand and you set this to 4, 2 more will be added to the craft queue."] = ""
-- L["When you double click on a craft in the top-left portion (queuing portion) of the craft management window, it will increment/decrement this many times."] = ""
-- L["When you use the \"Restock Queue\" button, it will ignore any items with a seen count below the seen count filter below. The seen count data can be retreived from either Auctioneer or TradeSkillMaster's AuctionDB module."] = ""
-- L["When you use the \"Restock Queue\" button, it will queue enough of each craft so that you will have the desired maximum quantity on hand. If you check this checkbox, anything that you have on the AH as of the last scan will be included in the number you currently have on hand."] = ""
L["Which group in TSM_Auctioning to add this item to."] = "A cual grupo de TSM_Auctioning agregar este objeto"
L["Which group in TSM_Mailing to add this item to."] = "A cual grupo de TSM_Mailing agregar este objeto."
-- L["Yellow Gems"] = ""
L["You can change the active database profile, so you can have different settings for every character."] = "Puedes cambiar el perfil de la base de datos activa, así puedes tener "
L["You can choose to specify a minimum profit amount (in gold or by percent of cost) for what crafts should be added to the craft queue."] = "Puedes elegir especificar un monto mínimo de ganancia (en oro o por porcentaje de costo) para que creaciones serán agregadas a la cola de creaciones."
-- L["You can either add every craft to one group or make individual groups for each craft."] = ""
L["You can either create a new profile by entering a name in the editbox, or choose one of the already exisiting profiles."] = "Puedes crear un nuevo perfil introduciendo un nombre en el cuadro de edición, o elegir uno de los perfiles ya existentes"
-- L["You can select a category that group(s) will be added to or select \"<No Category>\" to not add the group(s) to a category."] = ""
L["You must have your profession window open in order to use the craft queue. Click on the button below to open it."] = "Debes tener la ventana de tu profesión abierta para usar la cola de creación. Aprieta el botón de abajo para abrirla."
-- L["per pigment"] = ""