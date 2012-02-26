local wh = CreateFrame("Frame", nil, UIParent)

--local spn = GetSpellInfo(85383)
local spn = GetSpellInfo(17)

wh:RegisterEvent("PLAYER_REGEN_ENABLED")
wh:RegisterEvent("PLAYER_REGEN_DISABLED")
wh:RegisterEvent("UNIT_AURA")
wh:SetScript("OnEvent",function(event)
	if event == "PLAYER_REGEN_ENABLED" then
		--wh:Show()
	elseif event == "PLAYER_REGEN_DISABLED" then
		--wh:Hide()
	end
end)

wh:SetScript("OnUpdate",function(self,elapsed)
	if UnitBuff("player", spn) then
		_, _, _, _, _, duration, expirationTime = UnitBuff("player", spn)
		local timer = expirationTime - GetTime()
		if timer <= 5 and timer > 4.95 then
			PlaySoundFile("Interface\\AddOns\\warlockhelper\\media\\soulfire.mp3", "Master")
		end
	end
end)