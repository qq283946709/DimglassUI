
local _, ns = ...
local ycc = ns.ycc

local _VIEW_DEFAULT = 'playerStatus'
local _VIEW = _VIEW_DEFAULT

local function viewChanged(view)
    _VIEW = view or _VIEW_DEFAULT
end

local function update()
    if(_VIEW == 'tradeskil') then return end

    local playerArea = GetRealZoneText()
    local buttons = GuildRosterContainer.buttons

    for i, button in ipairs(buttons) do
        -- why the fuck no continue?
        if(button:IsShown() and button.online and button.guildIndex) then
            local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPnts, achievementRank, isMobile = GetGuildRosterInfo(button.guildIndex)
            local displayedName = ycc.classColor[classFileName] .. name
            if(isMobile) then
                name = ChatFrame_GetMobileEmbeddedTexture(73/255, 177/255, 73/255) .. name
            end

            if(_VIEW == 'playerStatus') then
                button.string1:SetText(ycc.diffColor[level] .. level)
                button.string2:SetText(displayedName)
                if(zone == playerArea) then
                    button.string3:SetText('|cff00ff00' .. zone)
                end
            elseif(_VIEW == 'guildStatus') then
                button.string1:SetText(displayedName)
                if(rankIndex and rank) then
                    button.string2:SetText(ycc.guildRankColor[rankIndex] .. rank)
                end
            elseif(_VIEW == 'achievement') then
                button.string1:SetText(ycc.diffColor[level] .. level)
                if(classFileName and name) then
                    button.string2:SetText(displayedName)
                end
            elseif(_VIEW == 'weeklyxp' or _VIEW == 'totalxp') then
                button.string1:SetText(ycc.diffColor[level] .. level)
                button.string2:SetText(displayedName)
            end
        end
    end
end

local function tradeupdate()
    local myZone = GetRealZoneText()
    for i, button in ipairs(GuildRosterContainer.buttons) do
        if(button:IsShown() and button.online and button.guildIndex) then
			local skillID, isCollapsed, iconTexture, headerName, numOnline, numVisible, numPlayers, playerName, class, online, zone, skill, classFileName, isMobile = GetGuildTradeSkillInfo(button.guildIndex)
            if(not headerName) then
                button.string1:SetText(ycc.classColor[classFileName] .. playerName)
                if(zone == myZone) then
                    button.string2:SetText('|cff00ff00' .. zone)
                end
            end
        end
    end
end

local loaded = false
hooksecurefunc('GuildFrame_LoadUI', function()
    if(loaded) then return end
    loaded = true

    hooksecurefunc('GuildRoster_SetView', viewChanged)
    hooksecurefunc('GuildRoster_Update', update)
    hooksecurefunc(GuildRosterContainer, 'update', update)
    hooksecurefunc('GuildRoster_UpdateTradeSkills', tradeupdate)
end)


