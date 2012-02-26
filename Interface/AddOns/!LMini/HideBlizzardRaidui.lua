local frame = CompactRaidFrameManager
frame:UnregisterAllEvents()
frame.Show = function() end
frame:Hide()
	
local frame = CompactRaidFrameContainer
frame:UnregisterAllEvents()
frame.Show = function() end
frame:Hide()