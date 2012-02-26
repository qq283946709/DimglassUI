-- TradeSkillMaster_Mailing Locale - frFR
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/tradeskillmaster_mailing/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Mailing", "frFR")
if not L then return end

L["%d mail"] = "%d courriers"
L["Add Mail Target"] = "Ajouter un joueur"
L["Auto Recheck Mail"] = "Vérifier auto. les courriers"
L["Auto mailing will let you setup groups and specific items that should be mailed to another characters."] = "le module _Mailiing vous permettra de configurer des groupes & objets spécifique à envoyer a d'autres personnages."
L[ [=[Automatically rechecks mail every 60 seconds when you have too much mail.

If you loot all mail with this enabled, it will wait and recheck then keep auto looting.]=] ] = [=[Vérifie automatiquement les courriers toute les 60secondes lorsque vous avez trop de courriers.

Si vous récupérer tout les courriers avec ceci d'activé, l'auto-récupération des courriers continuera après l'actualisation.]=]
L["Cannot finish auto looting, inventory is full or too many unique items."] = "Impossible de finir de récupérer le courriers, l'inventaire est plein où vous avez trop d'objets unique."
L["Check your spelling! If you typo a name, it will send to the wrong person."] = "Faites attention a l'orthographe ! Si vous écrivez incorrectement un pseudo, ça enverra le courrier a la mauvaise personne."
L["Checking this will stop TradesSkillMaster_Mailing from displaying money collected from your mailbox after auto looting"] = "TSM_Mailing n'affichera plus l'argent ramassé si vous cochez ceci"
L["Don't Display Money Received"] = "Ne pas afficher l'argent ramassé"
L["How many seconds until the mailbox will retrieve new data and you can continue looting mail."] = "Combien de secondes avant que la boite aux lettres récupérera les nouvelles données  et vous laissera récupérer vos courriers."
L["Items/Groups to Add:"] = "Objets/Groupes à ajouter:"
L["Items/Groups to remove:"] = "Objets/Groupes à supprimer:"
L["Mailed items off to %s!"] = "Objets envoyés à %s!"
L["Mailing Options"] = "Mailing - Options"
L["No items to send."] = "Aucun objets à envoyer."
L["No player name entered."] = "Aucun pseudo n'a été entré."
L["Open All"] = "Tout ouvrir"
L["Opening..."] = "Ouverture..."
L["Options"] = "Options"
L["Player \"%s\" is already a mail target."] = "Le joueur \"%s\" a déjà été ajouté."
L["Player Name"] = "Nom du joueur"
L["Remove Mail Target"] = "Supprimer un joueur"
L[ [=[Runs TradeSkillMaster_Mailing's auto mailer, the last patch of mails will take ~10 seconds to send.

[WARNING!] You will not get any confirmation before it starts to send mails, it is your own fault if you mistype your bankers name.]=] ] = [=[Lancer l'envoi de courriers de TSM_Mailing, ça ne devrait pas prendre plus de ~10 secondes.

[ATTENTION!]Il n'y aura aucune confirmation avant de commencer l'envoi, c'est de votre propre faute si vous avez mal orthographié le pseudo d'un joueur.]=]
L[ [=[The name of the player to send items to.

Check your spelling!]=] ] = "Le nom d'un joueur auquel envoyer des objets."
L["TradeSkillMaster_Mailing: Auto-Mail"] = "TSM_Mailing : Envoi auto de courriers"
L["Waiting..."] = "En attente..."
