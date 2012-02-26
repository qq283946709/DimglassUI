--山寨chatbar
local chatFrame = SELECTED_DOCK_FRAME
local editBox = chatFrame.editBox

--每一个button的長、寬，空隙，綜合/交易/本地防務/組隊 頻道的顏色
local buttontex = "Interface\\AddOns\\m_chat\\textures\\bartexture"
local buttonwidth, buttonheight, buttonspacing = 25, 12, 2.5
local c1r, c1g, c1b = 160/255, 200/255 ,215/255  --綜合
local c2r, c2g, c2b = 255/255, 130/255, 130/255  --交易
local c3r, c3g, c3b = 255/255, 255/255, 150/255  --防務
local c4r, c4g, c4b = 150/255, 255/255, 185/255  --組隊


local chat = CreateFrame("Frame","chat",UIParent)
--chat:RegisterEvent("PLAYER_ENTERING_WORLD")
--這一段是定義頻道顏色的，如果不喜歡就刪掉
--[[chat:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
	    ChangeChatColor("CHANNEL1", c1r, c1g, c1b)
		ChangeChatColor("CHANNEL2", c2r, c2g, c2b)
		ChangeChatColor("CHANNEL3", c3r, c3g, c3b)
		ChangeChatColor("CHANNEL4", c4r, c4g, c4b)
		ChangeChatColor("CHANNEL5", 255/255, 180/255, 115/255)
	end
end)]]

chat:SetWidth(330);chat:SetHeight(16);chat:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",5,5);
--[[chat:SetBackdrop({ 
	bgFile = "Interface\\Buttons\\WHITE8x8",
	edgeFile = "Interface\\Buttons\\WHITE8x8", -----這裡自己改樣式（我是沒有這個材質，所以沒有Backdrop）
	tile = false, tileSize = 0, edgeSize = 2, 
	insets = { left = -1, right = -1, top = -1, bottom = -1 }
	})
chat:SetBackdropBorderColor(0,0,0)
chat:SetBackdropColor(0,0,0,0)]]

local shadow = function(self)
    self.shadow = CreateFrame("Frame", nil, frame)
	self.shadow:SetPoint("TOPLEFT", self, -1, 1)
	self.shadow:SetPoint("BOTTOMRIGHT", self, 1, -1)
	self.shadow:SetBackdrop({
		edgeFile = "Interface\\AddOns\\m_chat\\textures\\glowTex",
		edgeSize = 3,
		insets = {
			top = 0,
			bottom = 0,
			left = 0,
			right = 0,
		}
	})
	self.shadow:SetBackdropBorderColor(0,0,0, 0.99)
	self.shadow:SetParent(self)
end

--說
local say = CreateFrame("Button", "SAY", chat);
say:SetWidth(buttonwidth); say:SetHeight(buttonheight); say:SetPoint("LEFT",chat,"LEFT",5,0);
say:RegisterForClicks("AnyUp");
say:SetScript("OnClick", function() say_OnClick() end)

sayTex = say:CreateTexture(nil, "ARTWORK")
sayTex:SetTexture(buttontex) 
sayTex:SetVertexColor(1,1,1)
sayTex:SetPoint("TOPLEFT", say, "TOPLEFT", 2, -2)
sayTex:SetPoint("BOTTOMRIGHT", say, "BOTTOMRIGHT", -2, 2)
shadow(say)

function say_OnClick()
      ChatFrame_OpenChat("/s ", chatFrame)
end

--隊伍
local party = CreateFrame("Button", "PARTY", chat);
party:SetWidth(buttonwidth); party:SetHeight(buttonheight); party:SetPoint("LEFT",chat,"LEFT",5 + buttonwidth * 1 +buttonspacing * 1 ,0);
party:RegisterForClicks("AnyUp");
party:SetScript("OnClick", function() party_OnClick() end)

partyTex = party:CreateTexture(nil, "ARTWORK")
partyTex:SetTexture(buttontex) 
partyTex:SetVertexColor(170/255, 170/255, 255/255)
partyTex:SetPoint("TOPLEFT", party, "TOPLEFT", 2, -2)
partyTex:SetPoint("BOTTOMRIGHT", party, "BOTTOMRIGHT", -2, 2)
shadow(party)

function party_OnClick()
      ChatFrame_OpenChat("/p ", chatFrame)
end

--公會
local guild = CreateFrame("Button", "guild", chat);
guild:SetWidth(buttonwidth); guild:SetHeight(buttonheight); guild:SetPoint("LEFT",chat,"LEFT",5 + buttonwidth * 2 +buttonspacing * 2,0);
guild:RegisterForClicks("AnyUp");
guild:SetScript("OnClick", function() guild_OnClick() end)

guildTex = guild:CreateTexture(nil, "ARTWORK")
guildTex:SetTexture(buttontex) 
guildTex:SetVertexColor(64/255, 255/255, 64/255)
guildTex:SetPoint("TOPLEFT", guild, "TOPLEFT", 2, -2)
guildTex:SetPoint("BOTTOMRIGHT", guild, "BOTTOMRIGHT", -2, 2)
shadow(guild)

function guild_OnClick()
      ChatFrame_OpenChat("/g ", chatFrame)
end

--團隊
local raid = CreateFrame("Button", "raid", chat);
raid:SetWidth(buttonwidth); raid:SetHeight(buttonheight); raid:SetPoint("LEFT",chat,"LEFT",5 + buttonwidth * 3 +buttonspacing * 3,0);
raid:RegisterForClicks("AnyUp");
raid:SetScript("OnClick", function() raid_OnClick() end)

raidTex = raid:CreateTexture(nil, "ARTWORK")
raidTex:SetTexture(buttontex) 
raidTex:SetVertexColor(255/255, 127/255, 0)
raidTex:SetPoint("TOPLEFT", raid, "TOPLEFT", 2, -2)
raidTex:SetPoint("BOTTOMRIGHT", raid, "BOTTOMRIGHT", -2, 2)
shadow(raid)

function raid_OnClick()
      ChatFrame_OpenChat("/raid ", chatFrame)
end

--喊
local yell = CreateFrame("Button", "YELL", chat);
yell:SetWidth(buttonwidth); yell:SetHeight(buttonheight); yell:SetPoint("LEFT",chat,"LEFT",5 + buttonwidth * 4 +buttonspacing * 4,0);
yell:RegisterForClicks("AnyUp");
yell:SetScript("OnClick", function() yell_OnClick() end)

yellTex = yell:CreateTexture(nil, "ARTWORK")
yellTex:SetTexture(buttontex) 
yellTex:SetVertexColor(255/255, 64/255, 64/255)
yellTex:SetPoint("TOPLEFT", yell, "TOPLEFT", 2, -2)
yellTex:SetPoint("BOTTOMRIGHT", yell, "BOTTOMRIGHT", -2, 2)
shadow(yell)

function yell_OnClick()
      ChatFrame_OpenChat("/y ", chatFrame)
end

--密語
local whisper = CreateFrame("Button", "whisper", chat);
whisper:SetWidth(buttonwidth); whisper:SetHeight(buttonheight); whisper:SetPoint("LEFT",chat,"LEFT",5 + buttonwidth * 5 +buttonspacing * 5,0);
whisper:RegisterForClicks("AnyUp");
whisper:SetScript("OnClick", function() whisper_OnClick() end)

whisperTex = whisper:CreateTexture(nil, "ARTWORK")
whisperTex:SetTexture(buttontex) 
whisperTex:SetVertexColor(255/255, 128/255, 255/255)
whisperTex:SetPoint("TOPLEFT", whisper, "TOPLEFT", 2, -2)
whisperTex:SetPoint("BOTTOMRIGHT", whisper, "BOTTOMRIGHT", -2, 2)
shadow(whisper)

function whisper_OnClick()
      ChatFrame_OpenChat("/w ", chatFrame)
end

function whisper_OnClick(self,button)
   if button == "RightButton" then   
      ChatFrame_ReplyTell(chatFrame);
      if not editBox:IsVisible() or editBox:GetAttribute("chatType") ~= "WHISPER" then
         ChatFrame_OpenChat("/w ", chatFrame);
      end
   else   
    if(UnitExists("target") and UnitName("target") and UnitIsPlayer("target") and GetDefaultLanguage("player")==GetDefaultLanguage("target") )then
       local name, realm = UnitName("target")
       ChatFrame_OpenChat("/w "..name.." " , chatFrame);
    else
    ChatFrame_OpenChat("/w ", chatFrame);
   end
end         
end

--戰場
local battle = CreateFrame("Button", "battle", chat);
battle:SetWidth(buttonwidth); battle:SetHeight(buttonheight); battle:SetPoint("LEFT",chat,"LEFT",5 + buttonwidth * 6 +buttonspacing * 6,0);
battle:RegisterForClicks("AnyUp");
battle:SetScript("OnClick", function() battle_OnClick() end)

battleTex = battle:CreateTexture(nil, "ARTWORK")
battleTex:SetTexture(buttontex) 
battleTex:SetVertexColor(255/255, 127/255, 0)
battleTex:SetPoint("TOPLEFT", battle, "TOPLEFT", 2, -2)
battleTex:SetPoint("BOTTOMRIGHT", battle, "BOTTOMRIGHT", -2, 2)
shadow(battle)

function battle_OnClick()
      ChatFrame_OpenChat("/bg ", chatFrame)
end

--綜合
local CNL1 = CreateFrame("Button", "CNL1", chat);
CNL1:SetWidth(buttonwidth); CNL1:SetHeight(buttonheight); CNL1:SetPoint("LEFT",chat,"LEFT",5 + buttonwidth * 7 +buttonspacing * 7,0);
CNL1:RegisterForClicks("AnyUp");
CNL1:SetScript("OnClick", function() CNL1_OnClick() end)

CNL1Tex = CNL1:CreateTexture(nil, "ARTWORK")
CNL1Tex:SetTexture(buttontex) 
CNL1Tex:SetVertexColor(c1r, c1g, c1b)
CNL1Tex:SetPoint("TOPLEFT", CNL1, "TOPLEFT", 2, -2)
CNL1Tex:SetPoint("BOTTOMRIGHT", CNL1, "BOTTOMRIGHT", -2, 2)
shadow(CNL1)

function CNL1_OnClick()
      ChatFrame_OpenChat("/1 ", chatFrame)
end

--交易
local CNL2 = CreateFrame("Button", "CNL2", chat);
CNL2:SetWidth(buttonwidth); CNL2:SetHeight(buttonheight); CNL2:SetPoint("LEFT",chat,"LEFT",5 + buttonwidth * 8 +buttonspacing * 8,0);
CNL2:RegisterForClicks("AnyUp");
CNL2:SetScript("OnClick", function() CNL2_OnClick() end)

CNL2Tex = CNL2:CreateTexture(nil, "ARTWORK")
CNL2Tex:SetTexture(buttontex) 
CNL2Tex:SetVertexColor(c2r, c2g, c2b)
CNL2Tex:SetPoint("TOPLEFT", CNL2, "TOPLEFT", 2, -2)
CNL2Tex:SetPoint("BOTTOMRIGHT", CNL2, "BOTTOMRIGHT", -2, 2)
shadow(CNL2)

function CNL2_OnClick()
      ChatFrame_OpenChat("/2 ", chatFrame)
end

--本地防務
local CNL3 = CreateFrame("Button", "CNL3", chat);
CNL3:SetWidth(buttonwidth); CNL3:SetHeight(buttonheight); CNL3:SetPoint("LEFT",chat,"LEFT",5 + buttonwidth * 9 +buttonspacing * 9,0);
CNL3:RegisterForClicks("AnyUp");
CNL3:SetScript("OnClick", function() CNL3_OnClick() end)

CNL3Tex = CNL3:CreateTexture(nil, "ARTWORK")
CNL3Tex:SetTexture(buttontex) 
CNL3Tex:SetVertexColor(c3r, c3g, c3b)
CNL3Tex:SetPoint("TOPLEFT", CNL3, "TOPLEFT", 2, -2)
CNL3Tex:SetPoint("BOTTOMRIGHT", CNL3, "BOTTOMRIGHT", -2, 2)
shadow(CNL3)

function CNL3_OnClick()
      ChatFrame_OpenChat("/3 ", chatFrame)
end

--尋求組隊
local CNL4 = CreateFrame("Button", "CNL4", chat);
CNL4:SetWidth(buttonwidth); CNL4:SetHeight(buttonheight); CNL4:SetPoint("LEFT",chat,"LEFT",5 + buttonwidth * 10 +buttonspacing * 10,0);
CNL4:RegisterForClicks("AnyUp");
CNL4:SetScript("OnClick", function() CNL4_OnClick() end)

CNL4Tex = CNL4:CreateTexture(nil, "ARTWORK")
CNL4Tex:SetTexture(buttontex) 
CNL4Tex:SetVertexColor(c4r, c4g, c4b)
CNL4Tex:SetPoint("TOPLEFT", CNL4, "TOPLEFT", 2, -2)
CNL4Tex:SetPoint("BOTTOMRIGHT", CNL4, "BOTTOMRIGHT", -2, 2)
shadow(CNL4)

function CNL4_OnClick()
      ChatFrame_OpenChat("/4 ", chatFrame)
end

--ROLL
local roll = CreateFrame("Button", "roll", UIParent, "SecureActionButtonTemplate")
roll:SetAttribute("*type*", "macro")
roll:SetAttribute("macrotext", "/roll")
--SetOverrideBindingClick(roll, true, "5", "rollMacro", nil) --此处的意思是把该宏绑在5号快捷键上，也就是按数字键5就可以使用该宏，因为用了69无脑宏，所以空出些键，如果不喜，可直接修改数字5为任何你不常用的按键，或者直接删除这一句。
roll:SetWidth(16);roll:SetHeight(16);roll:SetPoint("LEFT",chat,"LEFT",310,0);

rollText =roll:CreateFontString("ROLLText", "OVERLAY")
rollText:SetFont(GameTooltipText:GetFont(), 12, "OUTLINE")
rollText:SetJustifyH("CENTER")
rollText:SetWidth(20)
rollText:SetHeight(20)
rollText:SetText("R")
rollText:SetPoint("CENTER", 0, 0)
rollText:SetTextColor(200/255, 255/255, 150/255) 