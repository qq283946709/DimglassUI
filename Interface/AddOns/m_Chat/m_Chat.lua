﻿local AutoApply = true											-- /setchat upon UI loading
--Setchat parameters. Those parameters will apply to ChatFrame1 when you use /setchat
local def_position = {"BOTTOMLEFT",UIParent,"BOTTOMLEFT",7,30} -- Chat Frame position
local chat_height = 104
local chat_width = 326
local fontsize = 14
--other variables
local eb_point = {"BOTTOM", -200, 80}		-- Editbox position
local eb_width = 400						-- Editbox width
local tscol = "64C2F5"						-- Timestamp coloring
local TimeStampsCopy = true					-- Enables special time stamps in chat allowing you to copy the specific line from your chat window by clicking the stamp
local LinkHover = {}; LinkHover.show = {	-- enable (true) or disable (false) LinkHover functionality for different things in chat
	["achievement"] = true,
	["enchant"]     = true,
	["glyph"]       = true,
	["item"]        = true,
	["quest"]       = true,
	["spell"]       = true,
	["talent"]      = true,
	["unit"]        = true,}

for i = 1, NUM_CHAT_WINDOWS do
  local cf = _G['ChatFrame'..i]
  if cf then 
    cf:SetFont(NAMEPLATE_FONT, 14, "OUTLINE") 
	cf:SetShadowOffset(0, 0)
	cf:SetShadowColor(0, 0, 0, 1)
    cf:SetFrameStrata("LOW")
    cf:SetFrameLevel(2)
  end
  local tab = _G['ChatFrame'..i..'Tab']
  if tab then
    tab:GetFontString():SetFont(NAMEPLATE_FONT, 13, "OUTLINE")
	tab:GetFontString():SetShadowOffset(0, 0)
	tab:GetFontString():SetShadowColor(0, 0, 0, 1)
    --fix for color and alpha of undocked frames
    tab:GetFontString():SetTextColor(1,0.7,0)
    tab:SetAlpha(1)
  end
end

---------------- > Sticky Channels
ChatTypeInfo.SAY.sticky = 1
ChatTypeInfo.EMOTE.sticky = 0
ChatTypeInfo.YELL.sticky = 0
ChatTypeInfo.PARTY.sticky = 1
ChatTypeInfo.RAID.sticky = 1
ChatTypeInfo.RAID_WARNING.sticky = 1
ChatTypeInfo.GUILD.sticky = 1
ChatTypeInfo.OFFICER.sticky = 0
ChatTypeInfo.WHISPER.sticky = 1
ChatTypeInfo.CHANNEL.sticky = 1
ChatTypeInfo.BN_WHISPER.sticky = 1

-------------- > Custom timestamps color
do
	ChatFrame2ButtonFrameBottomButton:RegisterEvent("PLAYER_LOGIN")
	ChatFrame2ButtonFrameBottomButton:SetScript("OnEvent", function(f)
		TIMESTAMP_FORMAT_HHMM = "|cff"..tscol.."[%I:%M]|r "
		TIMESTAMP_FORMAT_HHMMSS = "|cff"..tscol.."[%I:%M:%S]|r "
		TIMESTAMP_FORMAT_HHMMSS_24HR = "|cff"..tscol.."[%H:%M:%S]|r "
		TIMESTAMP_FORMAT_HHMMSS_AMPM = "|cff"..tscol.."[%I:%M:%S %p]|r "
		TIMESTAMP_FORMAT_HHMM_24HR = "|cff"..tscol.."[%H:%M]|r "
		TIMESTAMP_FORMAT_HHMM_AMPM = "|cff"..tscol.."[%I:%M %p]|r "
		f:UnregisterEvent("PLAYER_LOGIN")
		f:SetScript("OnEvent", nil)
	end)
end

---------------- > Fading alpha
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0

---------------- > Function to move and scale chatframes 
SetChat = function()
    FCF_SetLocked(ChatFrame1, nil)
	FCF_SetChatWindowFontSize(self, ChatFrame1, fontsize) 
    ChatFrame1:ClearAllPoints()
    ChatFrame1:SetPoint(unpack(def_position))
    ChatFrame1:SetWidth(chat_width)
    ChatFrame1:SetHeight(chat_height)
    ChatFrame1:SetFrameLevel(8)
    ChatFrame1:SetUserPlaced(true)
	for i=1,10 do local cf = _G["ChatFrame"..i] FCF_SetWindowAlpha(cf, 0) end
    FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, 1)
end
SlashCmdList["SETCHAT"] = SetChat
SLASH_SETCHAT1 = "/setchat"
if AutoApply then
	local f = CreateFrame"Frame"
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("UI_SCALE_CHANGED")
	f:SetScript("OnEvent", function() SetChat() end)
end

do
	-- Buttons Hiding/moving 
	local kill = function(f) f:Hide() end
	ChatFrameMenuButton:Hide()
	ChatFrameMenuButton:SetScript("OnShow", kill)
	FriendsMicroButton:Hide()
	FriendsMicroButton:SetScript("OnShow", kill)

	for i=1, 10 do
		local cf = _G[format("%s%d", "ChatFrame", i)]
	--fix fading
		local tab = _G["ChatFrame"..i.."Tab"]
		tab:SetAlpha(0)
		tab.noMouseAlpha = 0
		cf:SetFading(false)
	
	-- Hide chat textures
		for j = 1, #CHAT_FRAME_TEXTURES do
			_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
		end
	--Unlimited chatframes resizing
		cf:SetMinResize(0,0)
		cf:SetMaxResize(0,0)
	
	--Allow the chat frame to move to the end of the screen
		cf:SetClampedToScreen(false)
		cf:SetClampRectInsets(0,0,0,0)
	
	--EditBox Module
		local ebParts = {'Left', 'Mid', 'Right'}
		local eb = _G['ChatFrame'..i..'EditBox']
		local cf = _G[format("%s%d", "ChatFrame", i)]
		for _, ebPart in ipairs(ebParts) do
			_G['ChatFrame'..i..'EditBox'..ebPart]:SetTexture(0, 0, 0, 0)
			local ebed = _G['ChatFrame'..i..'EditBoxFocus'..ebPart]
			ebed:SetTexture(0,0,0,0.8)
			ebed:SetHeight(18)
		end
		eb:SetAltArrowKeyMode(false)
		eb:ClearAllPoints()
		eb:SetPoint("BOTTOMLEFT", cf, "TOPLEFT",  0, 0)
		--eb:SetPoint("BOTTOMLEFT", UIParent, eb_point[1], eb_point[2], eb_point[3])
		eb:SetPoint("BOTTOMRIGHT", cf, "TOPRIGHT", 0, 0)
		--eb:SetPoint("BOTTOMRIGHT", UIParent, eb_point[1], eb_point[2]+eb_width, eb_point[3])
		eb:EnableMouse(false)
	
	--Remove scroll buttons
		local bf = _G['ChatFrame'..i..'ButtonFrame']
		bf:Hide()
		bf:SetScript("OnShow",  kill)
	
	--Scroll to the bottom button
		local function BottomButtonClick(self)
			self:GetParent():ScrollToBottom();
		end
		local bb = _G["ChatFrame"..i.."ButtonFrameBottomButton"]
		bb:SetParent(_G["ChatFrame"..i])
		bb:SetHeight(18)
		bb:SetWidth(18)
		bb:ClearAllPoints()
		bb:SetPoint("TOPRIGHT", cf, "TOPRIGHT", 0, -6)
		bb:SetAlpha(0.4)
		bb.SetPoint = function() end
		bb:SetScript("OnClick", BottomButtonClick)
	end
end

---------------- > TellTarget function
local function telltarget(msg)
	if not UnitExists("target") or not (msg and msg:len()>0) or not UnitIsFriend("player","target") then return end
	local name, realm = UnitName("target")
	if realm and not UnitIsSameServer("player", "target") then
		name = ("%s-%s"):format(name, realm)
	end
	SendChatMessage(msg, "WHISPER", nil, name)
end
SlashCmdList["TELLTARGET"] = telltarget
SLASH_TELLTARGET1 = "/tt"
SLASH_TELLTARGET2 = "/ее"
SLASH_TELLTARGET3 = "/wt"

---------------- > Channel names
local gsub = _G.string.gsub
local time = _G.time
local newAddMsg = {}

local chn, rplc
do
	rplc = {
		"[GEN]", --General
		"[T]", --Trade
		"[WD]", --WorldDefense
		"[LD]", --LocalDefense
		"[LFG]", --LookingForGroup
		"[GR]", --GuildRecruitment
		"[BG]", --Battleground
		"[BGL]", --Battleground Leader
		"[G]", --Guild
		"[P]", --Party
		"[PL]", --Party Leader
		"[PL]", --Party Leader (Guide)
		"[O]", --Officer
		"[R]", --Raid
		"[RL]", --Raid Leader
		"[RW]", --Raid Warning
	}
	chn = {
		"%[%d+%. General.-%]",
		"%[%d+%. Trade.-%]",
		"%[%d+%. WorldDefense%]",
		"%[%d+%. LocalDefense.-%]",
		"%[%d+%. LookingForGroup%]",
		"%[%d+%. GuildRecruitment.-%]",
		gsub(CHAT_BATTLEGROUND_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_BATTLEGROUND_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_GUILD_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_GUIDE_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_OFFICER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_WARNING_GET, ".*%[(.*)%].*", "%%[%1%%]"),
	}
	local L = GetLocale()
	if L == "ruRU" then --Russian
		chn[1] = "%[%d+%. Общий.-%]"
		chn[2] = "%[%d+%. Торговля.-%]"
		chn[3] = "%[%d+%. Оборона: глобальный%]" --Defense: Global
		chn[4] = "%[%d+%. Оборона.-%]" --Defense: Zone
		chn[5] = "%[%d+%. Поиск спутников%]"
		chn[6] = "%[%d+%. Гильдии.-%]"
	elseif L == "deDE" then --German
		chn[1] = "%[%d+%. Allgemein.-%]"
		chn[2] = "%[%d+%. Handel.-%]"
		chn[3] = "%[%d+%. Weltverteidigung%]"
		chn[4] = "%[%d+%. LokaleVerteidigung.-%]"
		chn[5] = "%[%d+%. SucheNachGruppe%]"
		chn[6] = "%[%d+%. Gildenrekrutierung.-%]"
	end
end
local function AddMessage(frame, text, ...)
	for i = 1, 16 do
		text = gsub(text, chn[i], rplc[i])
	end
	--If Blizz timestamps is enabled, stamp anything it misses
	if CHAT_TIMESTAMP_FORMAT and not text:find("|r") then
		text = BetterDate(CHAT_TIMESTAMP_FORMAT, time())..text
	end
	text = gsub(text, "%[(%d0?)%. .-%]", "[%1]") --custom channels
	return newAddMsg[frame:GetName()](frame, text, ...)
end
do
	for i = 1, 5 do
		if i ~= 2 then -- skip combatlog
			local f = _G[format("%s%d", "ChatFrame", i)]
			newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
			f.AddMessage = AddMessage
		end
	end
end
---------------- > Enable/Disable mouse for editbox
eb_mouseon = function()
	for i =1, 10 do
		local eb = _G['ChatFrame'..i..'EditBox']
		eb:EnableMouse(true)
	end
end
eb_mouseoff = function()
	for i =1, 10 do
		local eb = _G['ChatFrame'..i..'EditBox']
		eb:EnableMouse(false)
	end
end
hooksecurefunc("ChatFrame_OpenChat",eb_mouseon)
hooksecurefunc("ChatEdit_SendText",eb_mouseoff)

---------------- > Show tooltips when hovering a link in chat (credits to Adys for his LinkHover)
function LinkHover.OnHyperlinkEnter(_this, linkData, link)
	local t = linkData:match("^(.-):")
	if LinkHover.show[t] and IsAltKeyDown() then
		ShowUIPanel(GameTooltip)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end
end
function LinkHover.OnHyperlinkLeave(_this, linkData, link)
	local t = linkData:match("^(.-):")
	if LinkHover.show[t] then
		HideUIPanel(GameTooltip)
	end
end
local function LinkHoverOnLoad()
	for i = 1, NUM_CHAT_WINDOWS do
		local f = _G["ChatFrame"..i]
		f:SetScript("OnHyperlinkEnter", LinkHover.OnHyperlinkEnter)
		f:SetScript("OnHyperlinkLeave", LinkHover.OnHyperlinkLeave)
	end
end
LinkHoverOnLoad()

---------------- > Chat Scroll Module
hooksecurefunc('FloatingChatFrame_OnMouseScroll', function(self, dir)
	if dir > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		elseif IsControlKeyDown() then
			--only need to scroll twice because of blizzards scroll
			self:ScrollUp()
			self:ScrollUp()
		end
	elseif dir < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		elseif IsControlKeyDown() then
			--only need to scroll twice because of blizzards scroll
			self:ScrollDown()
			self:ScrollDown()
		end
	end
end)

---------------- > afk/dnd msg filter
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)

---------------- > Batch ChatCopy Module
local lines = {}
do
	--Create Frames/Objects
	local frame = CreateFrame("Frame", "BCMCopyFrame", UIParent)
	frame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 3, right = 3, top = 5, bottom = 3}})
	frame:SetBackdropColor(0,0,0,1)
	frame:SetWidth(500)
	frame:SetHeight(400)
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "BCMCopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	local editBox = CreateFrame("EditBox", "BCMCopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(400)
	editBox:SetHeight(270)
	editBox:SetScript("OnEscapePressed", function(f) f:GetParent():GetParent():Hide() f:SetText("") end)
	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "BCMCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	local copyFunc = function(frame, btn)
		local cf = _G[format("%s%d", "ChatFrame", frame:GetID())]
		local _, size = cf:GetFont()
		FCF_SetChatWindowFontSize(cf, cf, 0.01)
		local ct = 1
		for i = select("#", cf:GetRegions()), 1, -1 do
			local region = select(i, cf:GetRegions())
			if region:GetObjectType() == "FontString" then
				lines[ct] = tostring(region:GetText())
				ct = ct + 1
			end
		end
		local lineCt = ct - 1
		local text = table.concat(lines, "\n", 1, lineCt)
		FCF_SetChatWindowFontSize(cf, cf, size)
		BCMCopyFrame:Show()
		BCMCopyBox:SetText(text)
		BCMCopyBox:HighlightText(0)
		wipe(lines)
	end
	local hintFunc = function(frame)
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		if SHOW_NEWBIE_TIPS == "1" then
			GameTooltip:AddLine(CHAT_OPTIONS_LABEL, 1, 1, 1)
			GameTooltip:AddLine(NEWBIE_TOOLTIP_CHATOPTIONS, nil, nil, nil, 1)
		end
		GameTooltip:AddLine((SHOW_NEWBIE_TIPS == "1" and "\n" or "").."|TInterface\\Buttons\\UI-GuildButton-OfficerNote-Disabled:27|tDouble-click to copy chat.", 1, 0, 0)
		GameTooltip:Show()
	end
	for i = 1, 10 do
		local tab = _G[format("%s%d%s", "ChatFrame", i, "Tab")]
		tab:SetScript("OnDoubleClick", copyFunc)
		tab:SetScript("OnEnter", hintFunc)
	end
end

---------------- > Per-line chat copy via time stamps
if TimeStampsCopy then
	local AddMsg = {}
	local AddMessage = function(frame, text, ...)
		text = string.gsub(text, "%[(%d+)%. .-%]", "[%1]")
		text = ('|cffffffff|Hm_Chat|h|r%s|h %s'):format('|cff'..tscol..''..date('%H:%M')..'|r', text)
		return AddMsg[frame:GetName()](frame, text, ...)
	end
	for i = 1, 10 do
		if i ~= 2 then
			AddMsg["ChatFrame"..i] = _G["ChatFrame"..i].AddMessage
			_G["ChatFrame"..i].AddMessage = AddMessage
		end
	end
end

---------------- > URL copy Module
local tlds = {
	"[Cc][Oo][Mm]", "[Uu][Kk]", "[Nn][Ee][Tt]", "[Dd][Ee]", "[Ff][Rr]", "[Ee][Ss]",
	"[Bb][Ee]", "[Cc][Cc]", "[Uu][Ss]", "[Kk][Oo]", "[Cc][Hh]", "[Tt][Ww]",
	"[Cc][Nn]", "[Rr][Uu]", "[Gg][Rr]", "[Ii][Tt]", "[Ee][Uu]", "[Tt][Vv]",
	"[Nn][Ll]", "[Hh][Uu]", "[Oo][Rr][Gg]", "[Ss][Ee]", "[Nn][Oo]", "[Ff][Ii]"
}

local uPatterns = {
	'(http://%S+)',
	'(www%.%S+)',
	'(%d+%.%d+%.%d+%.%d+:?%d*)',
}

local cTypes = {
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_YELL",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_SAY",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_CONVERSATION",
}

for _, event in pairs(cTypes) do
	ChatFrame_AddMessageEventFilter(event, function(self, event, text, ...)
		for i=1, 24 do
			local result, matches = string.gsub(text, "(%S-%."..tlds[i].."/?%S*)", "|cff8A9DDE|Hurl:%1|h[%1]|h|r")
			if matches > 0 then
				return false, result, ...
			end
		end
 		for _, pattern in pairs(uPatterns) do
			local result, matches = string.gsub(text, pattern, '|cff8A9DDE|Hurl:%1|h[%1]|h|r')
			if matches > 0 then
				return false, result, ...
			end
		end 
	end)
end

local GetText = function(...)
	for l = 1, select("#", ...) do
		local obj = select(l, ...)
		if obj:GetObjectType() == "FontString" and obj:IsMouseOver() then
			return obj:GetText()
		end
	end
end

local SetIRef = SetItemRef
SetItemRef = function(link, text, ...)
	local txt, frame
	if link:sub(1, 6) == 'm_Chat' then
		frame = GetMouseFocus():GetParent()
		txt = GetText(frame:GetRegions())
		txt = txt:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
		txt = txt:gsub("|H.-|h(.-)|h", "%1")
	elseif link:sub(1, 3) == 'url' then
		frame = GetMouseFocus():GetParent()
		txt = link:sub(5)
	end
	if txt then
		local editbox
		if GetCVar('chatStyle') == 'classic' then
			editbox = LAST_ACTIVE_CHAT_EDIT_BOX
		else
			editbox = _G['ChatFrame'..frame:GetID()..'EditBox']
		end
		editbox:Show()
		editbox:Insert(txt)
		editbox:HighlightText()
		editbox:SetFocus()
		return
	end
	return SetIRef(link, text, ...)
end

--隐藏标签材质
for i = 1, NUM_CHAT_WINDOWS do
    chat = _G[format("ChatFrame%s", i)]:GetName()
for j = 1, #CHAT_FRAME_TEXTURES do 
    _G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil) 
end
    _G[format("ChatFrame%sTabLeft", i)]:SetTexture(nil) 
    _G[format("ChatFrame%sTabMiddle", i)]:SetTexture(nil) 
    _G[format("ChatFrame%sTabRight", i)]:SetTexture(nil) 
    _G[format("ChatFrame%sTabSelectedLeft", i)]:SetTexture(nil) 
    _G[format("ChatFrame%sTabSelectedMiddle", i)]:SetTexture(nil) 
    _G[format("ChatFrame%sTabSelectedRight", i)]:SetTexture(nil) 
	_G[format("ChatFrame%sTabHighlightLeft", i)]:SetTexture(nil) 
	_G[format("ChatFrame%sTabHighlightMiddle", i)]:SetTexture(nil) 
	_G[format("ChatFrame%sTabHighlightRight", i)]:SetTexture(nil) 
end