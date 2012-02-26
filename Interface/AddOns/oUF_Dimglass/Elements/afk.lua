local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local GetTime = GetTime
local floor = floor
local timer = {}

local AfkTime = function(s)
    local minute = 60
    local min = floor(s/minute)
    local sec = floor(s-(min*minute))
    if sec < 10 then sec = "0"..sec end
    if min < 10 then min = "0"..min end
    return min..":"..sec
end

oUF.Tags['freebgrid:afk'] = function(u)
    local name = UnitName(u)
    if(UnitIsAFK(u) or not UnitIsConnected(u)) then
        if not timer[name] then
            timer[name] = GetTime()
        end
        local time = (GetTime()-timer[name])

        return AfkTime(time)
    elseif timer[name] then
        timer[name] = nil
    end
end
oUF.TagEvents['freebgrid:afk'] = 'PLAYER_FLAGS_CHANGED UNIT_CONNECTION'

local Enable = function(self)
    if not self.freebAfk then return end

    local afktext = self.Health:CreateFontString(nil, "OVERLAY")
    afktext:SetPoint("TOP")
    afktext:SetFont(GameTooltipText:GetFont(), 14, "OUTLINE")
    afktext:SetWidth(200)
    afktext.frequentUpdates = 1
    self:Tag(afktext, "[freebgrid:afk]")
    self.AFKtext = afktext
end

oUF:AddElement('freebAfk', nil, Enable, nil)
