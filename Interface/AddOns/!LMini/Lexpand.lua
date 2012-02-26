--一些擴展功能或者修復
--实名好友弹窗位置
BNToastFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPLEFT", 0, 0)
end)

--副本內自動收起任務追蹤
local autocollapse = CreateFrame("Frame")
autocollapse:RegisterEvent("ZONE_CHANGED_NEW_AREA")
autocollapse:RegisterEvent("PLAYER_ENTERING_WORLD")
autocollapse:SetScript("OnEvent", function(self)
	if IsInInstance() then
		WatchFrame.userCollapsed  = true
		WatchFrame_Collapse(WatchFrame)
	else
		WatchFrame.userCollapsed  = nil
		WatchFrame_Expand(WatchFrame)
	end
end)

--任務追蹤面板移動
local wf = WatchFrame
--local wfmove = false 
wf:SetMovable(true);
wf:SetClampedToScreen(false); 
wf:ClearAllPoints()
wf:SetPoint("LEFT", UIParent)
wf:SetWidth(250)
wf:SetHeight(500)
wf:SetUserPlaced(true)
wf.SetPoint = function() end
--如果想要移動就取消下面的註釋
--[[
local function WATCHFRAMELOCK()
	if wfmove == false then
		wfmove = true
		print("WatchFrame unlocked for drag")
		wf:EnableMouse(true);
		wf:RegisterForDrag("LeftButton"); 
		wf:SetScript("OnDragStart", wf.StartMoving); 
		wf:SetScript("OnDragStop", wf.StopMovingOrSizing);
	elseif wfmove == true then
		wf:EnableMouse(false);
		wfmove = false
		print("WatchFrame locked")
	end
end

SLASH_WATCHFRAMELOCK1 = "/wf"
SlashCmdList["WATCHFRAMELOCK"] = WATCHFRAMELOCK]]

--任務追蹤字體描邊
local WFT = _G["WatchFrameTitle"]
WFT:SetFont(NAMEPLATE_FONT,14,"OUTLINE")
WFT:SetShadowOffset(0, 0)
WFT:SetShadowColor(0, 0, 0, 1)
hooksecurefunc("WatchFrame_SetLine", function(line)
	line.text:SetFont(NAMEPLATE_FONT,14,"OUTLINE")
	line.text:SetShadowOffset(0, 0)
	line.text:SetShadowColor(0, 0, 0, 1)
	if line.dash then
		line.dash:SetFont(NAMEPLATE_FONT,14,"OUTLINE")
		line.dash:SetShadowOffset(0, 0)
		line.dash:SetShadowColor(0, 0, 0, 1)
	end
end)

--移動Extrabarframe
local ebf = ExtraActionBarFrame

ebf:SetParent(UIParent)
ebf:ClearAllPoints()
ebf:SetPoint("CENTER", UIParent, -300, 70)
ebf.SetPoint = function() end

--重載介面
SlashCmdList['RELOADUI'] = function() ReloadUI() end 
SLASH_RELOADUI1 = '/rl'

--自動回收內存
local eventcount = 0
local a = CreateFrame("Frame")
a:RegisterAllEvents()
a:SetScript("OnEvent", function(self, event)
   eventcount = eventcount + 1
   if InCombatLockdown() then return end
   if eventcount > 6000 or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" then
      collectgarbage("collect")
      eventcount = 0
   end
end)

--默認設置更改
local UIcfg = function()
	SetCVar("chatStyle", "im")
	SetCVar("chatMouseScroll", 1)
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", 0.8)
	SetCVar("UnitNameFriendlyPlayerName", 1)
	SetCVar("UnitNameFriendlyPetName", 1)
	SetCVar("UnitNameFriendlyGuardianName", 1)
	SetCVar("UnitNameFriendlyTotemName", 1)
	SetCVar("UnitNameEnemyPlayerName", 1)
	SetCVar("UnitNameEnemyPetName", 1)
	SetCVar("UnitNameEnemyGuardianName", 1)
	SetCVar("UnitNameEnemyTotemName", 1)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("cameraSmoothStyle", 0)
	SetCVar("screenshotQuality", 8)
	SetCVar("lootUnderMouse", 1)
	SetCVar("alwaysShowActionBars", 1)


    ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "GUILD_OFFICER")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
    ReloadUI()
end

SlashCmdList["UICONFIG"] = UIcfg
SLASH_UICONFIG1 = "/uiconfig"