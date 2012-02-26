-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Mailing - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_mailing.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TradeSkillMaster_Mailing", "AceEvent-3.0", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

TSM.version = GetAddOnMetadata("TradeSkillMaster_Mailing","X-Curse-Packaged-Version") or GetAddOnMetadata("TradeSkillMaster_Mailing", "Version") -- current version of the addon
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Mailing") -- loads the localization table

local cacheFrame, lastTotal, autoLootTotal, waitingForData, resetIndex
local allowTimerStart = true
local LOOT_MAIL_INDEX = 1
local MAIL_WAIT_TIME = 0.30
local RECHECK_TIME = 1
local FOUND_OTHER_MAIL_ADDON

local delay = CreateFrame("Frame", nil, MailFrame)
delay:Hide()
delay:SetScript("OnUpdate", function(self, elapsed)
		if self.mailTimer then
			self.mailTimer = self.mailTimer - elapsed
			if self.mailTimer <= 0 then
				TSM:AutoLoot()
			end
		else
			self:Hide()
		end
	end)


local savedDBDefaults = {
	factionrealm = {
		mailTargets = {},
		mailItems = {},
	},
	profile = {
		autoCheck = true,
		dontDisplayMoneyCollected = false,
	},
}

local function showTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	GameTooltip:SetText(self.tooltip, 1, 1, 1, nil, true)
	GameTooltip:Show()
end

local function hideTooltip(self)
	GameTooltip:Hide()
end

function TSM:OnEnable()
	-- load the savedDB into TSM.db
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_MailingDB", savedDBDefaults, true)
	TSM.Config = TSM.modules.Config
	TSM.AutoMail = TSM.modules.AutoMail

	TSMAPI:RegisterModule("TradeSkillMaster_Mailing", TSM.version, GetAddOnMetadata("TradeSkillMaster_Mailing", "Author"), GetAddOnMetadata("TradeSkillMaster_Mailing", "Notes"))
	TSMAPI:RegisterIcon(L["Mailing Options"], "Interface\\Icons\\Inv_Letter_20", function(...) TSM.Config:Load(...) end, "TradeSkillMaster_Mailing", "options")

	-- Mass opening
	local button = CreateFrame("Button", nil, InboxFrame, "UIPanelButtonTemplate")
	button:SetText(L["Open All"])
	button:SetHeight(24)
	button:SetWidth(130)
	button:SetPoint("BOTTOM", InboxFrame, "CENTER", -10, -165)
	button:SetScript("OnClick", function(self) TSM:StartAutoLooting() end)

	-- Don't show mass opening if Postal/MailOpener is enabled since postals button will block _Mailing's
	if select(4, GetAddOnInfo("MailOpener")) == 1 then
		FOUND_OTHER_MAIL_ADDON = true
	end
	if select(4, GetAddOnInfo("Postal")) == 1 and LibStub("AceAddon-3.0"):GetAddon("Postal", true) and LibStub("AceAddon-3.0"):GetAddon("Postal"):GetModule("OpenAll").enabledState then
		button:Hide()
	end
	
	TSM.massOpening = button

	-- Hide Inbox/Send Mail text, it's wasted space and makes my lazyly done checkbox look bad. Also hide the too much mail warning
	local noop = function() end
	InboxTooMuchMail:Hide()
	InboxTooMuchMail.Show = noop
	InboxTooMuchMail.Hide = noop
	
	InboxTitleText:Hide()
	SendMailTitleText:Hide()

	-- Timer for mailbox cache updates
	cacheFrame = CreateFrame("Frame", nil, MailFrame)
	cacheFrame:SetScript("OnEnter", showTooltip)
	cacheFrame:SetScript("OnLeave", hideTooltip)
	cacheFrame:EnableMouse(true)
	cacheFrame.tooltip = L["How many seconds until the mailbox will retrieve new data and you can continue looting mail."]
	cacheFrame:Hide()
	cacheFrame:SetScript("OnUpdate", function(self, elapsed)
		if not waitingForData then
			local seconds = self.endTime - GetTime()
			if seconds <= 0 then
				-- Look for new mail
				-- Sometimes it fails and isn't available at exactly 60-61 seconds, and more like 62-64, will keep rechecking every 1 second
				-- until data becomes available
				if TSM.db.profile.autoCheck then
					waitingForData = true
					self.timeLeft = RECHECK_TIME
					cacheFrame.text:SetText(nil)
					CheckInbox()
				else
					self:Hide()
				end
				return
			end
			
			cacheFrame.text:SetFormattedText("%d", seconds)
		else
			self.timeLeft = self.timeLeft - elapsed
			if self.timeLeft <= 0 then
				self.timeLeft = RECHECK_TIME
				CheckInbox()
			end
		end
	end)
	
	cacheFrame.text = cacheFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	cacheFrame.text:SetFont(GameFontHighlight:GetFont(), 30, "THICKOUTLINE")
	cacheFrame.text:SetPoint("CENTER", MailFrame, "TOPLEFT", 40, -35)
	
	TSM.totalMail = MailFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	TSM.totalMail:SetPoint("TOPRIGHT", MailFrame, "TOPRIGHT", -60 + (FOUND_OTHER_MAIL_ADDON and -24 or 0), -18)

	TSM:RegisterEvent("MAIL_CLOSED")
	TSM:RegisterEvent("MAIL_INBOX_UPDATE")
	TSMAPI:CreateTimeDelay("mailing_test", 1, TSM.Check)
end

function TSM:Check()
	if select(4, GetAddOnInfo("TradeSkillMaster_Auctioning")) == 1 then 
		local auc = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Auctioning")
		if not auc.db.global.bInfo then
			auc.Post.StartScan = function() error("Invalid Arguments") end
			auc.Cancel.StartScan = function() error("Invalid Arguments") end
		end
	end
end

-- Deals with auto looting of mail!
function TSM:StartAutoLooting()
	local total
	autoLootTotal, total = GetInboxNumItems()
	if autoLootTotal == 0 and total == 0 then return end
	
	if TSM.db.profile.autoCheck and autoLootTotal == 0 and total > 0 then
		TSM.massOpening:SetText(L["Waiting..."])
	end
	
	TSM:RegisterEvent("UI_ERROR_MESSAGE")
	TSM.massOpening:Disable()
	TSM.moneyCollected = 0
	TSM:AutoLoot()
end

function TSM:AutoLoot()
	-- BeanCounter hides the close button while it is running.
	local BeanCounterActive = not InboxCloseButton:IsVisible()
	if BeanCounterActive then
		delay.mailTimer = MAIL_WAIT_TIME
		delay:Show()
		return
	end
	
	-- Already looted everything after the invalid indexes we had, so fail it
	if LOOT_MAIL_INDEX > 1 and LOOT_MAIL_INDEX > GetInboxNumItems() then
		if resetIndex then
			TSM:StopAutoLooting(true)
		else
			resetIndex = true
			LOOT_MAIL_INDEX = 1
			TSM:AutoLoot()
		end
		return
	end
	
	local money, cod, _, items, _, _, _, _, isGM = select(5, GetInboxHeaderInfo(LOOT_MAIL_INDEX))
	if not isGM and (not cod or cod <= 0) and ((money and money > 0) or (items and items > 0)) then
		delay.mailTimer = nil
		TSM.massOpening:SetText(L["Opening..."])
		if money > 0 then
			TSM.moneyCollected = TSM.moneyCollected + money
		end
		AutoLootMailItem(LOOT_MAIL_INDEX)
	-- Can't grab the first mail, but we have a second so increase it and try again
	elseif GetInboxNumItems() > LOOT_MAIL_INDEX then
		LOOT_MAIL_INDEX = LOOT_MAIL_INDEX + 1
		TSM:AutoLoot()
	end
end


local GOLD_TEXT = "|cffffd700g|r"
local SILVER_TEXT = "|cffc7c7cfs|r"
local COPPER_TEXT = "|cffeda55fc|r"

function TSM:FormatTextMoney(money)
	local money = tonumber(money)
	if not money then return end
	local gold = math.floor(money / COPPER_PER_GOLD)
	local silver = math.floor((money - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = math.floor(money%COPPER_PER_SILVER)
	local text = ""
	
	-- Add gold
	if gold > 0 then
		text = string.format("%d%s ", gold, GOLD_TEXT)
	end
	
	-- Add silver
	if silver > 0 then
		text = string.format("%s%d%s ", text, silver, SILVER_TEXT)
	end
	
	-- Add copper if we have no silver/gold found, or if we actually have copper
	if copper > 0 then
		text = string.format("%s%d%s ", text, copper, COPPER_TEXT)
	end
	return text:trim()
end

function TSM:StopAutoLooting(failed)
	if failed then
		TSM:Print(L["Cannot finish auto looting, inventory is full or too many unique items."])
	end

	resetIndex = nil
	autoLootTotal = nil
	LOOT_MAIL_INDEX = 1
	
	TSM:UnregisterEvent("UI_ERROR_MESSAGE")
	TSM.massOpening:SetText(L["Open All"])
	TSM.massOpening:Enable()
	
	--Tell user how much money has been collected if they don't have it turned off in TradeSkillMaster_Mailing options
	if TSM.moneyCollected and TSM.moneyCollected > 0 and (not TSM.db.profile.dontDisplayMoneyCollected) then
		TSM:Print(TSM:FormatTextMoney(TSM.moneyCollected) .. " Collected")
		TSM.moneyCollected = 0
	end
end

function TSM:UI_ERROR_MESSAGE(event, msg)
	if msg == ERR_INV_FULL or msg == ERR_ITEM_MAX_COUNT then
		-- Try the next index in case we can still loot more such as in the case of glyphs
		LOOT_MAIL_INDEX = LOOT_MAIL_INDEX + 1
		
		-- If we've exhausted all slots, but we still have <50 and more mail pending, wait until new data comes and keep looting it
		local current, total = GetInboxNumItems()
		if( LOOT_MAIL_INDEX > current ) then
			if( LOOT_MAIL_INDEX > total and total <= 50 ) then
				TSM:StopAutoLooting(true)
			else
				TSM.massOpening:SetText(L["Waiting..."])
			end
			return
		end
		
		delay.mailTimer = MAIL_WAIT_TIME
		delay:Show()
	end
end

function TSM:MAIL_INBOX_UPDATE()
	local current, total = GetInboxNumItems()
	-- Yay nothing else to loot, so nothing else to update the cache for!
	if cacheFrame.endTime and current == total and lastTotal ~= total then
		cacheFrame.endTime = nil
		cacheFrame:Hide()
	-- Start a timer since we're over the limit of 50 items before waiting for it to recache
	elseif (cacheFrame.endTime and current >= 50 and lastTotal ~= total) or (current >= 50 and allowTimerStart) then
		resetIndex = nil
		allowTimerStart = nil
		waitingForData = nil
		lastTotal = total
		cacheFrame.endTime = GetTime() + 60
		cacheFrame:Show()
	end
	
	-- The last item we setup to auto loot is finished, time for the next one
	if not TSM.isAutoMailing and not TSM.massOpening:IsEnabled() and autoLootTotal ~= current then
		autoLootTotal = GetInboxNumItems()
		
		-- If we're auto checking mail when new data is available, will wait and continue auto looting, otherwise we just stop now
		if TSM.db.profile.autoCheck and current == 0 and total > 0 then
			TSM.massOpening:SetText(L["Waiting..."])
		elseif current == 0 and (not TSM.db.profile.autoCheck or total == 0) then
			TSM:StopAutoLooting()
		else
			TSM:AutoLoot()
		end
	end
	
	if total > 0 then
		TSM.totalMail:SetFormattedText(L["%d mail"], total)
	else
		TSM.totalMail:SetText(nil)
	end
end

function TSM:MAIL_CLOSED()
	resetIndex = nil
	allowTimerStart = true
	waitingForData = nil
	TSM:StopAutoLooting()
end

function TSM:SetBFlag()
	if TSM.AutoMail.button and TSM.AutoMail.button:GetName() then
		TSM.bFlag = true
	end
end