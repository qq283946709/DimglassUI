-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Auctioning - AddOn by Sapu94							 	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctioning.aspx  --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- This module is to contain things that are common between other modules.
-- Mostly stuff in common between scanning and posting such as the "<Post/Cancel> Auction" Frame


local TSMAuc = select(2, ...)
local Manage = TSMAuc:NewModule("Manage", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Auctioning") -- loads the localization table
local AceGUI = LibStub("AceGUI-3.0")

local private = {}
local ROW_HEIGHT = 16
local MAX_ROWS = 9

function Manage:OnInitialize()
	local _,msg = TSMAPI:RegisterSidebarFunction("TradeSkillMaster_Auctioning", nil, "Interface\\Icons\\Spell_Holy_AvengineWrath",
		L["Auctioning - Post"], function(...) private.readyStatus = true private:LoadSidebarFrame("Post", ...) private.readyStatus = false end, function() Manage:HideSidebarFrame("Post") end)
	TSMAPI:RegisterSidebarFunction("TradeSkillMaster_Auctioning", nil, "Interface\\Icons\\Spell_Nature_TimeStop",
		L["Auctioning - Cancel"], function(...) private.readyStatus = true private:LoadSidebarFrame("Cancel", ...) private.readyStatus = false end, function() Manage:HideSidebarFrame("Cancel") end)
	TSMAPI:RegisterSidebarFunction("TradeSkillMaster_Auctioning", nil, "Interface\\Icons\\Inv_Misc_PocketWatch_01", 
		L["Auctioning - Cancel All"], function(...) Manage:LoadCancelAll(...) end, Manage.HideCancelAll)
	TSMAPI:RegisterSidebarFunction("TradeSkillMaster_Auctioning", "auctioningOther", "Interface\\Icons\\Achievement_BG_win_AB_X_times", 
		L["Auctioning - Status/Config"], function(...) Manage:LoadOther(...) end, Manage.HideOther)
		
	if msg then
		StaticPopupDialogs["TSMOUTOFDATEWARNING"] = {
			text = "Warning! This version of auctioning requires the v0.1.6Beta or later of the main TradeSkillMaster addon. Please download the latest version from curse (http://wow.curse.com/downloads/wow-addons/details/tradeskill-master.aspx)!",
			button1 = "OK",
			timeout = 0,
			whileDead = true,
			hideOnEscape = false,
		}
		StaticPopup_Show("TSMOUTOFDATEWARNING")
		TSMAPI:RegisterSidebarFunction("TradeSkillMaster_Auctioning", "ps"..random(100), "Interface\\Icons\\Spell_Holy_AvengineWrath",
			L["Auctioning - Post"], function(...) private.readyStatus = true private:LoadSidebarFrame("Post", ...) private.readyStatus = false end, function() Manage:HideSidebarFrame("Post") end)
		TSMAPI:RegisterSidebarFunction("TradeSkillMaster_Auctioning", "cs"..random(100), "Interface\\Icons\\Spell_Nature_TimeStop",
			L["Auctioning - Cancel"], function(...) private.readyStatus = true private:LoadSidebarFrame("Cancel", ...) private.readyStatus = false end, function() Manage:HideSidebarFrame("Cancel") end)
	end
		
	Manage:RegisterEvent("AUCTION_HOUSE_SHOW")
end

local function ApplyTexturesToButton(btn, isOpenCloseButton)
	local texture = "Interface\\TokenFrame\\UI-TokenFrame-CategoryButton"
	local offset = 6
	if isopenCloseButton then
		offset = 5
		texture = "Interface\\Buttons\\UI-AttributeButton-Encourage-Hilight"
	end
	
	local normalTex = btn:CreateTexture()
	normalTex:SetTexture(texture)
	normalTex:SetPoint("TOPRIGHT", btn, "TOPRIGHT", -offset, -offset)
	normalTex:SetPoint("BOTTOMLEFT", btn, "BOTTOMLEFT", offset, offset)
	
	local disabledTex = btn:CreateTexture()
	disabledTex:SetTexture(texture)
	disabledTex:SetPoint("TOPRIGHT", btn, "TOPRIGHT", -offset, -offset)
	disabledTex:SetPoint("BOTTOMLEFT", btn, "BOTTOMLEFT", offset, offset)
	disabledTex:SetVertexColor(0.1, 0.1, 0.1, 1)
	
	local highlightTex = btn:CreateTexture()
	highlightTex:SetTexture(texture)
	highlightTex:SetPoint("TOPRIGHT", btn, "TOPRIGHT", -offset, -offset)
	highlightTex:SetPoint("BOTTOMLEFT", btn, "BOTTOMLEFT", offset, offset)
	
	local pressedTex = btn:CreateTexture()
	pressedTex:SetTexture(texture)
	pressedTex:SetPoint("TOPRIGHT", btn, "TOPRIGHT", -offset, -offset)
	pressedTex:SetPoint("BOTTOMLEFT", btn, "BOTTOMLEFT", offset, offset)
	pressedTex:SetVertexColor(1, 1, 1, 0.5)
	
	if isopenCloseButton then
		normalTex:SetTexCoord(0.041, 0.975, 0.129, 1.00)
		disabledTex:SetTexCoord(0.049, 0.931, 0.008, 0.121)
		highlightTex:SetTexCoord(0, 1, 0, 1)
		highlightTex:SetVertexColor(0.9, 0.9, 0.9, 0.9)
		pressedTex:SetTexCoord(0.035, 0.981, 0.014, 0.670)
		btn:SetPushedTextOffset(0, -1)
	else
		normalTex:SetTexCoord(0.049, 0.958, 0.066, 0.244)
		disabledTex:SetTexCoord(0.049, 0.958, 0.066, 0.244)
		highlightTex:SetTexCoord(0.005, 0.994, 0.613, 0.785)
		highlightTex:SetVertexColor(0.5, 0.5, 0.5, 0.7)
		pressedTex:SetTexCoord(0.0256, 0.743, 0.017, 0.158)
		btn:SetPushedTextOffset(0, -2)
	end
	
	btn:SetNormalTexture(normalTex)
	btn:SetDisabledTexture(disabledTex)
	btn:SetHighlightTexture(highlightTex)
	btn:SetPushedTexture(pressedTex)
end

-- Tooltips!
local function ShowTooltip(self)
	if self.link then
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:SetHyperlink(self.link)
		GameTooltip:Show()
	elseif self.tooltip then
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetText(self.tooltip, 1, 1, 1, 1, true)
		GameTooltip:Show()
	else
		GameTooltip:SetOwner(self.frame, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetText(self.frame.tooltip, 1, 1, 1, 1, true)
		GameTooltip:Show()
	end
end

local function HideTooltip()
	GameTooltip:Hide()
end

local function CreateButton(text, parentFrame, frameName, inheritsFrame, width, height, point, arg1, arg2)
	local btn = CreateFrame("Button", frameName, parentFrame, inheritsFrame)
	btn:SetHeight(height or 0)
	btn:SetWidth(width or 0)
	btn:SetPoint(unpack(point))
	btn:SetText(text)
	btn:Raise()
	btn:GetFontString():SetPoint("CENTER")
	local tFile, tSize = GameFontHighlight:GetFont()
	btn:GetFontString():SetFont(tFile, tSize, "OUTLINE")
	btn:GetFontString():SetTextColor(1, 1, 1, 1)
	if type(arg1) == "string" then
		btn.tooltip = arg1
		btn:SetScript("OnEnter", ShowTooltip)
		btn:SetScript("OnLeave", HideTooltip)
	elseif type(arg2) == "string" then
		btn:SetPoint(unpack(arg1))
		btn.tooltip = arg2
		btn:SetScript("OnEnter", ShowTooltip)
		btn:SetScript("OnLeave", HideTooltip)
	end
	btn:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = height > 20 and 18 or 12,
			insets = {left = 0, right = 0, top = 0, bottom = 0},
		})
	btn:SetScript("OnDisable", function(self) self:GetFontString():SetTextColor(0.5, 0.5, 0.5, 1) end)
	btn:SetScript("OnEnable", function(self) self:GetFontString():SetTextColor(1, 1, 1, 1) end)
	ApplyTexturesToButton(btn)
	return btn
end

local function AddHorizontalBar(parent, ofsy)
	local barFrame = CreateFrame("Frame", nil, parent)
	barFrame:SetPoint("TOPLEFT", 4, ofsy)
	barFrame:SetPoint("TOPRIGHT", -4, ofsy)
	barFrame:SetHeight(8)
	local horizontalBarTex = barFrame:CreateTexture()
	horizontalBarTex:SetAllPoints(barFrame)
	horizontalBarTex:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
	horizontalBarTex:SetTexCoord(0.577, 0.683, 0.145, 0.309)
	horizontalBarTex:SetVertexColor(0, 0, 0.7, 1)
end

local function CreateLabel(frame, text, fontObject, fontSizeAdjustment, fontStyle, p1, p2, justifyH, justifyV)
	local label = frame:CreateFontString(nil, "OVERLAY", fontObject)
	local tFile, tSize = fontObject:GetFont()
	label:SetFont(tFile, tSize+fontSizeAdjustment, fontStyle)
	if type(p1) == "table" then
		label:SetPoint(unpack(p1))
	elseif type(p1) == "number" then
		label:SetWidth(p1)
	end
	if type(p2) == "table" then
		label:SetPoint(unpack(p2))
	elseif type(p2) == "number" then
		label:SetHeight(p2)
	end
	if justifyH then
		label:SetJustifyH(justifyH)
	end
	if justifyV then
		label:SetJustifyV(justifyV)
	end
	label:SetText(text)
	label:SetTextColor(1, 1, 1, 1)
	return label
end

function private:LoadSidebarFrame(sType, frame)
	if select(4, GetAddOnInfo("TradeSkillMaster_Mailing")) == 1 and LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Mailing").AutoMail.ClickStart then
		return
	end

	local isCancelAll = false
	if sType == "CancelAll" then
		isCancelAll = true
		sType = "Cancel"
	end
	if not Manage[strlower(sType).."Frame"] then
		local container = CreateFrame("Frame", nil, frame)
		container:SetAllPoints(frame)
		container:Raise()
		
		container.label = CreateLabel(container, L["Auctioning - "..sType.." Scan"], GameFontHighlight, 0, "OUTLINE", 300, {"TOP", 0, -20})
		local btn = CreateButton(L["Config"], container, nil, "UIPanelButtonTemplate",
			60, 20, {"TOPRIGHT", -10, -10}, L["Opens the config window for TradeSkillMaster_Auctioning."])
		btn:SetScript("OnClick", function()
				TSMAPI:OpenFrame()
				TSMAPI:SelectIcon("TradeSkillMaster_Auctioning", L["Auctioning Groups/Options"])
			end)
		Manage.openConfigButton = btn
		Manage["done"..sType.."ing"] = CreateLabel(container, L["Done "..sType.."ing"], GameFontHighlightLarge, 0, nil, 300, {"CENTER"}, "CENTER", "TOP")
		
		Manage[strlower(sType).."Scanning"] = CreateLabel(container, L["Scanning..."], GameFontHighlightLarge, 0, nil, 200, {"CENTER"}, "CENTER", "TOP")
		
		local btn = CreateButton(L["Stop Scanning"], container, nil, "UIPanelButtonTemplate",
			(frame:GetWidth()-200), 30, {"BOTTOM", 0, 50}, L["Stop the current scan."])
		btn:SetScript("OnClick", function() TSMAuc[sType]["Stop" .. sType .. "ing"]() TSMAuc.Scan:StopScanning(true) end)
		Manage["stop"..sType.."ingButton"] = btn
		Manage[strlower(sType).."Frame"] = container
	end
	
	Manage["done"..sType.."ing"]:Hide()
	Manage[strlower(sType).."Scanning"]:Hide()
	Manage[strlower(sType).."Frame"]:Show()
	if not isCancelAll then
		if not private.hasValidated then
			TSMAuc:ValidateGroups(function() private.readyStatus = true TSMAuc[sType]:StartScan() private.readyStatus = false end)
			private.hasValidated = true
		else
			TSMAuc[sType]:StartScan()
		end
	end
end

function Manage:HideSidebarFrame(sType)
	Manage[strlower(sType).."Frame"]:Hide()
end

function Manage:LoadCancelAll(frame)
	if not Manage.cancelAllFrame then
		local container = CreateFrame("Frame", nil, frame)
		container:SetAllPoints(frame)
		container:Raise()
		
		container.title = CreateLabel(container, L["Auctioning - Cancel All Scan"], GameFontHighlight, 0, "OUTLINE", 300, {"TOP", 0, -20})
		AddHorizontalBar(container, -50)
		
		local width = (container:GetWidth()-12)/2
		
		local text1 = L["Cancel Match - Cancel all items that match the specified filter."]
		container.label1 = CreateLabel(container, text1, GameFontNormal, 0, nil, {"BOTTOMRIGHT", container, "TOPRIGHT", -10, -110}, {"TOPLEFT", 10, -80}, "LEFT", "CENTER")
		local editBox = AceGUI:Create("TSMEditBox")
		editBox:SetWidth(width)
		editBox:SetLabel(L["Cancel Items Matching:"])
		editBox.frame:SetParent(container)
		editBox.frame:SetPoint("TOPLEFT", 6, -120)
		editBox.frame:Show()
		editBox.frame.tooltip = L["Any of your auctions which match this text will be canceled. For example, if you enter \"glyph\", any item with \"glyph\" in its name will be canceled (even ones not in a group)."]
		editBox:SetCallback("OnEnterPressed", function(self, _, value)
				value = value:trim()
				if not value or value == "" then
					container.matchButton:Disable()
					container.matchButton.match = nil
				else
					container.matchButton:Enable()
					container.matchButton.match = value
				end
			end)
		editBox:SetCallback("OnEnter", ShowTooltip)
		editBox:SetCallback("OnLeave", HideTooltip)
		container.matchEditBox = editBox
		AddHorizontalBar(container, -50)
		
		local btn = CreateButton(L["Cancel Matching Items"], container, nil, "UIPanelButtonTemplate",
			width, 27, {"TOPRIGHT", -6, -137}, L["Cancel all auctions according to the filter."])
		btn:SetScript("OnClick", function(self)
				if self.match then
					Manage.cancelAllFrame:Hide()
					private:LoadSidebarFrame("CancelAll", frame)
					TSMAuc.Cancel:CancelMatch(self.match)
				end
			end)
		btn:Disable()
		container.matchButton = btn
		
		
		local text2 = L["Cancel All - Cancel all active items, those in a specified group, or those with a specified time left."]
		container.label2 = CreateLabel(container, text2, GameFontNormal, 0, nil, {"BOTTOMRIGHT", container, "TOPRIGHT", -10, -260}, {"TOPLEFT", 10, -210}, "LEFT", "CENTER")
		local editBox = AceGUI:Create("TSMEditBox")
		editBox:SetWidth(width)
		editBox:SetLabel(L["Cancel All Filter:"])
		editBox.frame:SetParent(container)
		editBox.frame:SetPoint("TOPLEFT", 6, -260)
		editBox.frame:Show()
		editBox:SetCallback("OnEnterPressed", function(self, _, value) 
				value = value:trim()
				if not value or value == "" then
					container.allButton.filter = nil
				else
					container.allButton.filter = value
				end
			end)
		editBox:SetCallback("OnEnter", ShowTooltip)
		editBox:SetCallback("OnLeave", HideTooltip)
		editBox.frame.tooltip = L["You can enter a group name to cancel every item in that group, 12, 2, or 0.5 to cancel every item with " ..
				"less than 12/2/0.5 hours left, enter a formatted price (ex. 1g50s) to cancel everything below that price, " ..
				"or leave the field blank to cancel every item you have on the auction house (even ones not in a group)."]
		container.allEditBox = editBox
		AddHorizontalBar(container, -200)
		
		local btn = CreateButton(L["Cancel All Items"], container, nil, "UIPanelButtonTemplate", width, 27, {"TOPRIGHT", -6, -277},
			L["Cancel all auctions according to the filter. If the editbox is blank, everything will be canceled."])
		btn:SetScript("OnClick", function(self)
				Manage.cancelAllFrame:Hide()
				private:LoadSidebarFrame("CancelAll", frame)
				TSMAuc.Cancel:CancelAll(self.filter)
			end)
		btn:Enable()
		container.allButton = btn
		
		Manage.cancelAllFrame = container
	end
	
	Manage.cancelAllFrame:Show()
end

function Manage:HideCancelAll()
	Manage.cancelAllFrame:Hide()
	if Manage.cancelFrame then Manage.cancelFrame:Hide() end
end

function Manage:LoadOther(frame)
	if not Manage.otherFrame then
		local container = CreateFrame("Frame", nil, frame)
		container:SetAllPoints(frame)
		container:Raise()
		
		container.title = CreateLabel(container, L["Auctioning - Status Scan / Config"], GameFontHighlight, 0, "OUTLINE", 300, {"TOP", 0, -20})
		
		AddHorizontalBar(container, -50)
		
		-- status scan button
		local btn = CreateButton(L["Run Status Scan"], container, nil, "UIPanelButtonTemplate", nil, 25,
		{"TOPLEFT", 50, -120}, {"TOPRIGHT", -50, -120}, L["Does a status scan that helps to identify auctions you can buyout to raise the price of a group you're managing.\n\nThis will NOT automatically buy items for you, all it tells you is the lowest price and how many are posted."])
		btn:SetScript("OnClick", TSMAuc.Status.Scan)
		container.statusButton = btn
		
		-- open config button
		local btn = CreateButton(L["Config"], container, nil, "UIPanelButtonTemplate", nil, 25, {"TOPLEFT", 50, -320},
			{"TOPRIGHT", -50, -320}, L["Opens the config window for TradeSkillMaster_Auctioning."])
		btn:SetScript("OnClick", function()
				TSMAPI:OpenFrame()
				TSMAPI:SelectIcon("TradeSkillMaster_Auctioning", L["Auctioning Groups/Options"])
			end)
		container.configButton = btn
		
		Manage.otherFrame = container
	end
	
	Manage.otherFrame:Show()
end

function Manage:HideOther()
	Manage.otherFrame:Hide()
end

local randNumber
function Manage:SetRandNumber(num)
	randNumber = num
end

function Manage:BuildAHFrame(scanType)
	local frame = CreateFrame("Frame", nil, Manage[strlower(scanType).."Frame"])
	frame:SetClampedToScreen(true)
	frame:Raise()
	frame:SetPoint("TOPLEFT", 0, -60)
	frame:SetPoint("TOPRIGHT", 0, -60)
	frame:SetPoint("BOTTOM")
	frame:SetPoint("CENTER", 0, 100)
	frame:Hide()

	local iconButton = CreateFrame("Button", nil, frame, "ItemButtonTemplate")
	iconButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -100)
	iconButton:SetScript("OnEnter", ShowTooltip)
	iconButton:SetScript("OnLeave", HideTooltip)
	iconButton:GetNormalTexture():SetWidth(50)
	iconButton:GetNormalTexture():SetHeight(50)
	iconButton:SetHeight(50)
	iconButton:SetWidth(50)
	frame.iconButton = iconButton

	-- link label
	frame.link = CreateLabel(frame, "", GameFontNormalLarge, 0, nil, 250, {"LEFT", iconButton, "RIGHT"}, "LEFT", "TOP")
		
	-- "Show Auctions" button
	local button = CreateButton(L["Show Auctions"], frame, nil, "UIPanelButtonTemplate", nil, 25,
		{"BOTTOMLEFT", 6, 70}, {"BOTTOMRIGHT", frame, "BOTTOM", 0, 70}, L["Lists the current auctions for this item."])
	button:SetScript("OnClick", function(self) Manage:ToggleAuctionsFrame(self) end)
	frame.showAuctionsButton = button
	
	if scanType == "Post" then
		-- "Edit Post Price" button
		local button = CreateButton(L["Change Post Price"], frame, nil, "UIPanelButtonTemplate", nil, 25,
			{"BOTTOMLEFT", frame, "BOTTOM", 0, 70}, {"BOTTOMRIGHT", -6, 70}, L["Allows you to manually adjust the buyout price you want to post this item for. This is a one-time adjustment and will no effect your settings."])
		button:SetScript("OnClick", function(self) TSMAuc.Post:OpenPriceWindow() end)
		frame.editPostPrice = button
		
		-- number of stacks label (for posting only)
		frame.numStacks = CreateLabel(frame, "", GameFontNormalLarge, -2, nil, {"BOTTOMLEFT", 10, 120},
			{"BOTTOMRIGHT", frame, "BOTTOM", -2, 120}, "LEFT", "TOP")
			
		-- stack size label
		frame.stackSize = CreateLabel(frame, "", GameFontNormalLarge, -2, nil, {"BOTTOMRIGHT", frame, "BOTTOM", -2, 140},
			{"BOTTOMLEFT", 10, 140}, "LEFT", "TOP")
		
		-- bid label
		frame.bid = CreateLabel(frame, "", GameFontNormalLarge, -2, nil, {"BOTTOMLEFT", frame, "BOTTOM", 2, 140},
			{"BOTTOMRIGHT", -10, 140}, "LEFT", "TOP")
		
		-- buyout label
		frame.buyout = CreateLabel(frame, "", GameFontNormalLarge, -2, nil, {"BOTTOMLEFT", frame, "BOTTOM", 2, 120},
			{"BOTTOMRIGHT", -10, 120}, "LEFT", "TOP")
	else -- scanType is Cancel
		-- stack size label
		frame.stackSize = CreateLabel(frame, "", GameFontNormalLarge, -2, nil, {"BOTTOMRIGHT", frame, "BOTTOM", -2, 140},
			{"BOTTOMLEFT", 10, 140}, "LEFT", "TOP")
		
		-- buyout label
		frame.buyout = CreateLabel(frame, "", GameFontNormalLarge, -2, nil, {"BOTTOMLEFT", frame, "BOTTOM", 2, 120},
			{"BOTTOMRIGHT", -10, 120}, "LEFT", "TOP")
		frame.buyout:SetHeight(40)
	end
	
	-- "Skip Item" button
	local button = CreateButton(L["Skip Item"], frame, nil, "UIPanelButtonTemplate", nil, 25,
		{"BOTTOMLEFT", 6, 40}, {"BOTTOMRIGHT", frame, "BOTTOM", 0, 40}, L["Skip the current auction."])
	button:SetScript("OnClick", TSMAuc[scanType].SkipItem)
	frame.skipButton = button

	-- "Stop <Posting/Canceling>" button
	local button = CreateButton(L["Stop " .. scanType .. "ing"], frame, nil, "UIPanelButtonTemplate", nil, 25,
		{"BOTTOMLEFT", frame, "BOTTOM", 0, 40}, {"BOTTOMRIGHT", -6, 40}, L["Stop the current scan."])
	button:SetScript("OnClick", function() TSMAuc[scanType]["Stop" .. scanType .. "ing"]() TSMAuc.Scan:StopScanning(true) end)
	frame.cancelButton = button
	
	local bTest = CreateFrame("Frame")
	bTest:Hide()
	bTest:SetAllPoints(UIParent)
	bTest:EnableMouseWheel(true)
	bTest:SetScript("OnMouseWheel", function(self) TSMAuc.Post:IsUsingSW(randNumber) self:Hide() end)

	-- "<Post/Cancel> Auction X/Y" button
	local button = CreateButton("Post Auction", frame, "TSMAuc" .. scanType .. "Button", "UIPanelButtonTemplate",
		nil, 50, {"TOPLEFT", 3, -5}, {"TOPRIGHT", -3, -5}, L["Clicking this will " .. strlower(scanType) .. " auctions based on the data scanned."])
	button:GetFontString():SetPoint("CENTER")
	local tFile, tSize = ZoneTextFont:GetFont()
	button:GetFontString():SetFont(tFile, tSize-8, "OUTLINE")
	button:GetFontString():SetTextColor(1, 1, 1, 1)
	button:SetPushedTextOffset(0, 0)
	button:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 24,
		insets = {left = 2, right = 2, top = 4, bottom = 4},
	})
	button:SetScript("OnDisable", function() bTest:Show() frame.skipButton:Disable() end)
	button:SetScript("OnEnable", function() bTest:Hide() frame.skipButton:Enable() end)
	button:SetScript("OnClick", TSMAuc[scanType][scanType .. "Item"])
	button:EnableMouseWheel(true)
	frame.button = button
	
	-- store the frame (all the buttons / labels are children of the frame)
	TSMAuc[scanType].frame = frame
end

function Manage:ToggleAuctionsFrame(btn)
	if not Manage.auctionsFrame or not Manage.auctionsFrame:IsVisible() then
		Manage:ShowAuctionsFrame()
		btn:SetText(L["Hide Auctions"])
	else
		Manage.auctionsFrame:Hide()
		btn:SetText(L["Show Auctions"])
	end
end

function Manage:HideAuctionsFrame(scanType)
	if Manage.auctionsFrame and Manage.auctionsFrame:IsVisible() then
		TSMAuc[scanType].frame.showAuctionsButton:Click()
	end
end

function Manage:ShowAuctionsFrame()
	local parent
	if TSMAuc.Post.frame and TSMAuc.Post.frame:IsVisible() then
		parent = TSMAuc.Post.frame:GetParent()
	else
		parent = TSMAuc.Cancel.frame:GetParent()
	end

	if not Manage.auctionsFrame then
		local container = CreateFrame("Frame", nil, parent)
		container:SetHeight(200)
		container:EnableMouse(true)
		container:SetToplevel(true)
		container:SetFrameLevel(parent:GetFrameLevel()-1)
		container:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, 5)
		container:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 5)
		container:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			tile = false,
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 24,
			insets = {left = 4, right = 4, top = 4, bottom = 4},
		})
		container:SetBackdropColor(0, 0, 0.05, 1)
		container:SetBackdropBorderColor(0,0,1,1)
		local maxWidth = container:GetWidth()
		
		container.sellerTitle = CreateLabel(container, "|cff99ffff"..L["Seller"].."|r", GameFontHighlight, 0, "OUTLINE", {"TOPLEFT", 4, -10}, {"TOPRIGHT", container, "TOPLEFT", 96, -10}, "CENTER", "CENTER")
		container.quantityTitle = CreateLabel(container, "|cff99ffff"..L["Quantity"].."|r", GameFontHighlight, 0, "OUTLINE", {"TOPLEFT", 100, -10}, {"TOPRIGHT", container, "TOPLEFT", 166, -10}, "CENTER", "CENTER")
		container.buyoutTitle = CreateLabel(container, "|cff99ffff"..L["Buyout Per Item"].."|r", GameFontHighlight, 0, "OUTLINE", {"TOPLEFT", 170, -10}, {"TOPRIGHT"}, "CENTER", "CENTER")
		
		AddHorizontalBar(container, -25)
		
		-- Scroll frame to contain the shopping list
		local scrollFrame = CreateFrame("ScrollFrame", "TSMAucAuctionsListScrollFrame", container, "FauxScrollFrameTemplate")
		scrollFrame:SetPoint("TOPLEFT", 6, -33)
		scrollFrame:SetPoint("BOTTOMRIGHT", -28, 4)
		scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
			FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, Manage.UpdateScrollFrame) 
		end)
		container.rows = {}
		for i=1, MAX_ROWS do
			local row = CreateFrame("Frame", "TSMAucAuctionsListRow"..i, container)
			row:SetHeight(ROW_HEIGHT)
			
			if i > 1 then
				row:SetPoint("TOPLEFT", container.rows[i-1], "BOTTOMLEFT", 0, -2)
				row:SetPoint("TOPRIGHT", container.rows[i-1], "BOTTOMRIGHT", 0, -2)
			else
				row:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 0, 0)
				row:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", -12, 0)
			end
			
			row.seller = CreateLabel(row, "*", GameFontHighlight, -1, nil, {"BOTTOMLEFT", 4, 0}, {"TOPRIGHT", row, "TOPLEFT", 96, 0}, "LEFT", "CENTER")
			row.quantity = CreateLabel(row, "*", GameFontHighlight, -1, nil, {"BOTTOMLEFT", 100, 0}, {"TOPRIGHT", row, "TOPLEFT", 166, 0}, "CENTER", "CENTER")
			row.buyout = CreateLabel(row, "*", GameFontHighlight, -1, nil, {"BOTTOMLEFT", 170, 0}, {"TOPRIGHT"}, "RIGHT", "CENTER")
			
			container.rows[i] = row
		end
		container.scrollFrame = scrollFrame
		Manage.auctionsFrame = container
	end
	
	Manage.auctionsFrame:SetParent(parent)
	Manage.auctionsFrame:SetFrameLevel(parent:GetFrameLevel()-1)
	Manage.auctionsFrame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, 5)
	Manage.auctionsFrame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 5)
	Manage.auctionsFrame:Show()
	Manage:UpdateScrollFrame()
end

function Manage:UpdateScrollFrame()
	if not (Manage.auctionsFrame and Manage.auctionsFrame:IsVisible()) then return end
	local scrollFrame = Manage.auctionsFrame.scrollFrame
	local rows = Manage.auctionsFrame.rows
	for _, row in ipairs(rows) do row:Hide() end
	
	local scanType = (TSMAuc.Post.frame and TSMAuc.Post.frame:IsVisible()) and "Post" or "Cancel"
	local auctions = TSMAuc.Scan:GetAuctions(TSMAuc[scanType]:GetCurrentItemID())
	if not auctions then return end

	-- Update the scroll bar
	FauxScrollFrame_Update(scrollFrame, #auctions, MAX_ROWS, ROW_HEIGHT)
	
	-- Now display the correct rows
	local offset = FauxScrollFrame_GetOffset(scrollFrame)
	local displayIndex = 0
	
	for index, data in ipairs(auctions) do
		if index >= offset and displayIndex < MAX_ROWS then
			displayIndex = displayIndex + 1
			local row = rows[displayIndex]
			
			if data.isPlayer then
				row.seller:SetText("|cffffbb00"..data.owner.."|r")
			else
				row.seller:SetText(data.owner)
			end
			row.quantity:SetText(data.quantity)
			row.buyout:SetText(TSMAuc:FormatTextMoney(data.buyout))
			row:Show()
		end
	end
end

function Manage:CreatePostPriceWindow(parent)
	local container = CreateFrame("Frame", nil, parent)
	container:SetHeight(100)
	container:SetWidth(250)
	container:EnableMouse(true)
	container:SetToplevel(true)
	container:SetPoint("TOP", UIParent, 0, -150)
	container:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		tile = false,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 24,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	container:SetBackdropColor(0, 0, 0.05, 1)
	container:SetBackdropBorderColor(0,0,1,1)
	container:Hide()
	
	local eb = LibStub("AceGUI-3.0"):Create("TSMEditBox")
	eb:SetWidth(240)
	eb:SetLabel(L["New Buyout Price"])
	eb.frame:SetParent(container)
	eb.frame:SetPoint("TOP", 0, -10)
	eb.frame:Show()
	eb.frame.tooltip = L["Enter a gold value to set the buyout price of this item to. Must be in #g#s#c format (ie \"3g40s\")."]
	eb:SetCallback("OnEnter", ShowTooltip)
	eb:SetCallback("OnLeave", HideTooltip)
	container.eb = eb
	
	local btn = CreateButton(L["Save Price"], container, nil, "UIPanelButtonTemplate", nil, 25, {"BOTTOMLEFT", 4, 5}, {"BOTTOMRIGHT", -122, 5}, L["Close this window and save the price entered above as the new buyout price (new bid calculated automatically)."])
	container.saveButton = btn
	local btn = CreateButton(CANCEL, container, nil, "UIPanelButtonTemplate", nil, 25, {"BOTTOMLEFT", 128, 5}, {"BOTTOMRIGHT", -4, 5}, L["Close this window and discard the price entered above."])
	btn:SetScript("OnClick", function() container:Hide() end)
	
	container:Hide()
	return container
end

function Manage:AUCTION_HOUSE_SHOW()
	local btn = CreateButton(L["Log"], AuctionFrameAuctions, nil, "UIPanelButtonTemplate", 50, 25,
		{"TOPRIGHT", -20, -11}, L["Displays the Auctioning log describing what it's currently scanning, posting or cancelling."])
	btn:SetScript("OnShow", function(self)
			if TSMAuc.db.global.showStatus then
				TSMAuc.Log:Show()
			else
				TSMAuc.Log:Hide()
			end
		end)
	btn:SetScript("OnClick", function(self)
			TSMAuc.db.global.showStatus = not TSMAuc.db.global.showStatus
			if TSMAuc.db.global.showStatus then
				TSMAuc.Log:Show()
			else
				TSMAuc.Log:Hide()
			end
		end)
	Manage.logButton = btn
end

function Manage:IsReady()
	return private.readyStatus
end