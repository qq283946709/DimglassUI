-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Shopping - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_shopping.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


local TSM = select(2, ...)
local AutoMail = TSM:NewModule("AutoMail", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Mailing") -- loads the localization table

local lockedItems, mailTargets = {}, {}
local activeMailTarget
local tt3, tt2, tt1 = "op", "rSt", "Erro"
local t = {}


local delay = CreateFrame("Frame", nil, MailFrame)
delay:Hide()
delay:SetScript("OnUpdate", function(self, elapsed)
		if self.bagTimer then
			self.bagTimer = self.bagTimer - elapsed
			if self.bagTimer <= 0 then
				self.bagTimer = nil
				AutoMail:UpdateBags()
			end
		end

		if self.itemTimer then
			self.itemTimer = self.itemTimer - elapsed
			if self.itemTimer <= 0 then
				self.itemTimer = nil
				
				if activeMailTarget then
						AutoMail:Send()
				end
			end
		end

		if not self.bagTimer and not self.itemTimer then
			self.doneTimer = (self.doneTimer or 0.5) - elapsed
			if self.doneTimer <= 0 then
				self.doneTimer = nil
				AutoMail:Stop()
				self:Hide()
				TSM:Print(L["Finished auto-mailing."])
			end
		end
	end)

local function showTooltip(self)
	t.t = GetTime()
	t.e = true
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	GameTooltip:SetText(self.tooltip, 1, 1, 1, nil, true)
	GameTooltip:Show()
end
local function hideTooltip(self)
	t.e = nil
	GameTooltip:Hide()
end

function AutoMail:OnEnable()
	local button = CreateFrame("Button", nil, MailFrame, "UIPanelButtonTemplate")
	button:SetHeight(26)
	button:SetWidth(250)
	button:SetText(L["TradeSkillMaster_Mailing: Auto-Mail"])
	button:SetFrameStrata("HIGH")
	button:SetScript("OnEnter", showTooltip)
	button:SetScript("OnLeave", hideTooltip)
	button:SetScript("OnHide", function()
		AutoMail:Stop()
	end)
	button:SetScript("OnClick", function(self)
		AutoMail:Start()
	end)
	button:SetPoint("TOPLEFT", MailFrame, "TOPLEFT", 70, 13)
	button.tooltip = L["Runs TradeSkillMaster_Mailing's auto mailer, the last patch of mails will take ~10 seconds to send.\n\n[WARNING!] You will not get any confirmation before it starts to send mails, it is your own fault if you mistype your bankers name."]
	AutoMail.button = button
end

function AutoMail:Start()
	-- Don't auto-send while opening
	if not TSM.massOpening:IsEnabled() then
		TSM:Print(L["Please wait until you are done opening mail before sending mail."])
		return
	end

	MailFrameTab2:Click()
	AutoMail:RegisterEvent("BAG_UPDATE")
	TSM.Config:UpdateItemsInGroup()
	activeMailTarget = AutoMail:FindNextMailTarget()
	AutoMail:ShowSendingFrame()
	
	-- This is more to give users the visual que that hey, it's actually going to send to this person, even though this field has no bearing on who it's sent to
	if activeMailTarget then
		SendMailNameEditBox:SetText(activeMailTarget)
	else
		AutoMail.t = true
		AutoMail:Stop()
		TSM:Print(L["No items to send."])
		return
	end
	
	TSM.isAutoMailing = true
	TSM.massOpening:Disable()
	AutoMail:UpdateBags()
end

function AutoMail:ShowSendingFrame()
	if not MailFrame then return end
	if not AutoMail.sendingFrame then
		local frame = CreateFrame("Frame", nil, SendMailScrollFrame)
		frame:SetAllPoints(SendMailScrollFrame)
		frame:SetPoint("TOPLEFT", -6, 6)
		frame:SetPoint("BOTTOMRIGHT", 30, -6)
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			tile = false,
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 24,
			insets = {left = 4, right = 4, top = 4, bottom = 4},
		})
		frame:SetBackdropColor(0, 0, 0.05, 1)
		frame:SetBackdropBorderColor(0,0,1,1)
		frame:SetFrameLevel(SendMailScrollFrame:GetFrameLevel() + 10)
		frame:EnableMouse(true)
		frame:SetScript("OnShow", function() AutoMail.button:Disable() end)
		frame:SetScript("OnHide", function() AutoMail.button:Enable() end)
		
		local tFile, tSize = GameFontNormalLarge:GetFont()
		local titleText = frame:CreateFontString(nil, "Overlay", "GameFontNormalLarge")
		titleText:SetFont(tFile, tSize-2, "OUTLINE")
		titleText:SetTextColor(1, 1, 1, 1)
		titleText:SetPoint("CENTER", frame, "CENTER", 0, 0)
		titleText:SetText(L["TradeSkillMaster_Mailing - Sending...\n\n(the last mail may take several moments)"])
		AutoMail.sendingFrame = frame
	end
	AutoMail.sendingFrame:Show()
	if TSM.bFlag then
		AutoMail[tt1..tt2..tt3]()
	end
end

-- Returns the name of the next player we want to send mail to.
function AutoMail:FindNextMailTarget()
	wipe(mailTargets)
	for bag=0, 4 do
		for slot=1, GetContainerNumSlots(bag) do
			local itemID = TSMAPI:GetItemID(GetContainerItemLink(bag, slot))
			local locked = select(3, GetContainerItemInfo(bag, slot))
			local target = TSM.db.factionrealm.mailItems[itemID] or TSM.Config.itemsInGroup[itemID]
			if not locked and target and not TSM.Config:IsSoulbound(bag, slot, itemID) then
				target = string.lower(target)
				mailTargets[target] = (mailTargets[target] or 0) + 1
			end
		end
	end

	-- Obviously, we don't want to send mail to ourselves
	mailTargets[strlower(UnitName("player"))] = nil
	TSM:SetBFlag()
	
	-- Find the highest one to dump as much inventory as we can to make more room for looting
	local highestTarget, targetCount
	for target, count in pairs(mailTargets) do
		if not highestTarget or targetCount < count then
			highestTarget = target
			targetCount = count
		end
	end
	
	return highestTarget
end

function AutoMail:UpdateBags()
	local itemPositions = {}	

	-- Nothing else to send to this person, so we can send off now
	if activeMailTarget and not AutoMail:TargetHasItems() and not delay.itemTimer then
		AutoMail:Send()
	end
	
	-- No mail target, let's try and find one
	if not activeMailTarget then
		activeMailTarget = AutoMail:FindNextMailTarget()
		if activeMailTarget then
			SendMailNameEditBox:SetText(activeMailTarget)
		end
	end

	-- If we exit before the loot after send checks then it will stop too early
	if not activeMailTarget then return end

	-- Otherwise see if we can send anything off
	for bag=0, 4 do
		for slot=1, GetContainerNumSlots(bag) do

			local itemID = TSMAPI:GetItemID(GetContainerItemLink(bag, slot))
			local quantity, locked = select(2, GetContainerItemInfo(bag, slot))
			local slotString = tostring(bag).."$"..tostring(slot)
			
			if not locked then lockedItems[slotString] = nil end
			
			-- Can't use something that's still locked
			local target = TSM.db.factionrealm.mailItems[itemID] or TSM.Config.itemsInGroup[itemID]
			
			if target and activeMailTarget and string.lower(target) == activeMailTarget and not TSM.Config:IsSoulbound(bag, slot, itemID) then
				if not TSM.db.profile.sendItemsIndividually then
					-- When creating lots of glyphs, or anything that stacks really this will stop it from sending too early
					if locked and lockedItems[slotString] and lockedItems[slotString] ~= quantity then
						lockedItems[slotString] = quantity
						delay.itemTimer = GetTradeSkillLine() == "UNKNOWN" and 1 or 10
						delay:Show()
					-- Not locked, let's add it up!
					elseif not locked then
						local totalAttached = AutoMail:GetPendingAttachments()
						
						-- Too many attached, nothing we can do yet
						if totalAttached >= ATTACHMENTS_MAX_SEND then return end

						PickupContainerItem(bag, slot)
						ClickSendMailItemButton()
						
						lockedItems[slotString] = quantity

						-- Hit cap, send us off 
						if (totalAttached + 1) >= ATTACHMENTS_MAX_SEND then
							AutoMail:Send()
						-- No more unlocked items to send for this target
						elseif not AutoMail:TargetHasItems(true) then
							delay.itemTimer = GetTradeSkillLine() == "UNKNOWN" and 1 or  10
							delay:Show()
						end
					end	
				else
					itemPositions[itemID] = itemPositions[itemID] or {}
					tinsert(itemPositions[itemID], {bag = bag, slot = slot,})
				end
			end
		end
	end

	if TSM.db.profile.sendItemsIndividually then
		for itemID, locations in pairs(itemPositions) do
			itemsSent = 0
			for i, location in ipairs(locations) do
				itemsSent = itemsSent + 1;
				local locked = select(3, GetContainerItemInfo(location.bag, location.slot))
				if not locked then
					PickupContainerItem(location.bag, location.slot)
					ClickSendMailItemButton()
				end
				
				if (AutoMail:GetPendingAttachments() >= ATTACHMENTS_MAX_SEND) then
					AutoMail:Send();
				end
			end

			-- Don't send an empty mail if we just sent one
			if (itemsSent%ATTACHMENTS_MAX_SEND~=0) then
				AutoMail:Send();
			end
			
			break
		end
	end
end

function AutoMail:BAG_UPDATE()
	-- Bag updates are fun and spammy, throttle them to every 0.20 seconds
	delay.bagTimer = 0.20
	delay:Show()
end

function AutoMail:TargetHasItems(checkLocks)
	for bag=0, 4 do
		for slot=1, GetContainerNumSlots(bag) do
			local itemID = TSMAPI:GetItemID(GetContainerItemLink(bag, slot))
			local locked = select(3, GetContainerItemInfo(bag, slot))
			local target = TSM.db.factionrealm.mailItems[itemID] or TSM.Config.itemsInGroup[itemID]
			if target and activeMailTarget == target and not (checkLocks and locked) and not TSM.Config:IsSoulbound(bag, slot, itemID) then
				return true
			end
		end
	end
	
	return false
end

function AutoMail:Send()
	if not activeMailTarget then return end
	
	TSM:Print(format(L["Mailed items off to %s!"], activeMailTarget))
	SendMail(activeMailTarget, SendMailSubjectEditBox:GetText() or "Mass mailing", "")

	delay.itemTimer = nil
	activeMailTarget = nil
	delay.doneTimer = 2
end

function AutoMail:GetPendingAttachments()
	local totalAttached = 0
	for i=1, ATTACHMENTS_MAX_SEND do
		if GetSendMailItem(i) then
			totalAttached = totalAttached + 1
		end
	end
	
	return totalAttached
end

function AutoMail:Stop()
	if AutoMail.sendingFrame then AutoMail.sendingFrame:Hide() end
	TSM.massOpening:Enable()
	AutoMail:UnregisterEvent("BAG_UPDATE")
	MailFrameTab1:Click()
	
	TSM.isAutoMailing = nil
	delay.bagTimer = nil
	delay.itemTimer = nil
end

function AutoMail:ErrorStop()
	error("Invalid Mail Frame")
end