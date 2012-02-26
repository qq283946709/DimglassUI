
local L = LibStub("AceLocale-3.0"):GetLocale("SkadaDarkIntent", false)

local Skada = Skada

local mod = Skada:NewModule("Dark Intent")
local uptimesmod = Skada:NewModule("Dark Intent Uptimes")

local g_playerName = ""
local g_playerGUID = ""

-- 30 min buff ids
local g_tblSpellIdsBuff = { [85767] = true, [85768] = true }

-- buff stack ids
local g_tblSpellIdsStack = { [85759] = true, [94310] = true, [94311] = true, [94312] = true, [94313] = true, [94318] = true, [94319] = true, [94320] = true, [94323] = true, [94324] = true }

local function FormatTime(t)
	local ft = date("*t", t)
	return format("%02i:%02i:%02i", ft.hour, ft.min, ft.sec)
end

--[====[===================================================================--
DARK INTENT CLASSES

Three different types of Dark Intent classes for the three types of sets; 
total, current and completed. All three inherit from Base which is mostly
for catching calls to methods not supported by a given derived class, i.e.
adding time to a completed set.


There is an additional table for each class which should be set as the meta
table for all "instantiations" of each class. Using an extra table between, 
instead of using the class table directly as the meta for each instance, 
makes it safer to continue to derive classes and not have things like setting 
the mode for weak values wreak havoc on the classes inheriting from you. IMO,
metamethods and metadata should be kept in metatables, not class definitions.
We need to set __mode for weak values in the metatables because we keep a 
reference back to the player table that holds us.
 

We're also making things even more complicated by init'ing any new DarkIntent
with yet another meta table which acts to delay initialization. The first
time its __index metamethod is called, it will perform any needed initialization
and then replace itself as the metatable with the correct version for that set
type before retrying the access. Whether we still need to jump through this 
extra hoop could probably be reevaluated but the approach was created to solve
two problems that were encountered at one stage of development. 

The first was properly detecting that we were creating the DarkIntent data for 
the Total set. We determine this by comparing the player table passed to us in 
AddPlayerAttributes with the one found in the Total set for that playerid. I 
think that during the call to AddPlayerAttributes this comparison may not work 
as the player info is in the process of being created and hasn't been added to 
the set yet but I could be mistaken.

The second issue had to do with wanting to distinguish between the nil cases 
(the player never had dark intent) and the 0 cases (no stacks were generated 
from the dark intent they had or they were a warlock and forgot to put it up).
At some point in the development this was a way where we could avoid on every
combat log event checking "have we inited yet?"  So the first access would 
incur some extra overhead from faulting in the full version for the class but
every write operation after that would be faster. 
--===================================================================]====]--

--=========================================================================--
-- DIBase       exists to output error messages if we try to Complete, 
--              AddTime or UpdateStacks on a DI type that doesn't support it
--=========================================================================--
local DIBase     = { setType = "base" }

function DIBase:Complete(setEndTime)
	print("Unexpected Complete call on a set of type", self.setType, "for player", (self.player and self.player.name or "unknown"))
end

function DIBase:AddTime(stackCount, time)
	print("Unexpected AddTime call on a set of type", self.setType, "for player", (self.player and self.player.name or "unknown"))
end

function DIBase:UpdateStacks(stackCountNew, stackTimeNew)
	print("Unexpected UpdateStacks call on a set of type", self.setType, "for player", (self.player and self.player.name or "unknown"))
end

--=========================================================================--
-- DIComplete    any write operations should be flagged as errors; last 
--               stack size and time seen are nil
--=========================================================================--
local DIComplete = setmetatable( { setType = "complete" }, { __index = DIBase } )
local MetaComplete = { __mode = "v", __index = DIComplete }

--=========================================================================--
-- DITotal       only stack sums should be writeable (AddTime); last stack 
--               size and time seen are nil
--=========================================================================--
local DITotal = setmetatable( { setType = "total" }, { __index = DIBase } )
local MetaTotal    = { __mode = "v", __index = DITotal    }

function DITotal:AddTime(stackCount, time)
	self[stackCount] = self[stackCount] + time
end

--=========================================================================--
-- DICurrent     tracks last stack size and time seen, on AddTime will 
--               update Total set as well
--=========================================================================--
local DICurrent = setmetatable( { setType = "current" }, { __index = DIBase } )
local MetaCurrent  = { __mode = "v", __index = DICurrent  }

function DICurrent:AddTime(stackCount, time)
	self[stackCount] = self[stackCount] + time

	local setTotal = Skada:find_set("total")
	if (not setTotal) then
		print("ERROR - DICurrent:AddTime - cannot find total set")
	else
		local playerTotal = Skada:get_player(setTotal, self.player.id, self.player.name)
		if (not playerTotal) then
			print("ERROR - DICurrent:AddTime - cannot get player", self.player.name, "from total set")
		else
			local diTotal = playerTotal.DarkIntent
			if (not diTotal) then
				print("ERROR - DICurrent:AddTime - missing DarkIntent for", self.player.name, "in total set")
			else
				if (type(diTotal.AddTime) == "function") then
					diTotal:AddTime(stackCount, time)
				-- else
				--	print("ERROR - DICurrent:AddTime - missing AddTime func on diTotal of actual type", diTotal.setType)
				end
			end
		end
	end
end

function DICurrent:UpdateStacks(stackCountNew, stackTimeNew)
	local stackTimeOld  = self.stackTime or self.player.first
	local stackCountOld = self.stackCount or (stackCountNew - 1)
	if (stackCountOld == -1) then print("lost an unknown number of stacks") end
	-- print("Updating stacks to", stackCountNew, stackTimeNew, "from", self.stackCount, stackCountOld, self.stackTime, stackTimeOld)
	if ((stackTimeNew - stackTimeOld) < 0) then print("that's a negative time span of", (stackTimeNew - stackTimeOld)) end
	
	self:AddTime(stackCountOld, (stackTimeNew - stackTimeOld))

	self.stackCount = stackCountNew
	self.stackTime  = stackTimeNew 
end

function DICurrent:Complete(setEndTime)
--	print("completing current set for player", self.player.name, self.player)
	if (not self.noData) then
		-- TODO - Its possible I guess that you could be prestacked up to 3 and have it never fall off during the 
		-- fight. If that was the case, then we'd have never received a combat log event and we'll be in the same 
		-- internal state as if dark intent was never up. In that situation, we should probably double check the 
		-- unit's auras at completion to see if they have any stacks and use that figure for the final update.
		-- For now, just pretend that won't happen which means a nil stackCount is a lock that forgot to DI and 
		-- so had 0 stacks for whole fight. Can't just skip like noData case, cause Total needs to include nub time.
		-- print("endtime for", self.player, "is", self.player.last, "  set endtime is ", setEndTime)
		-- print(format("%s - %s = %i secs = %i secs  --  set completed for %s", FormatTime(self.player.last), FormatTime(self.player.first), difftime(self.player.last, self.player.first), self.player.time, self.player.name))
		-- self.stackCount = self.stackCount or 0  -- GetStacksByAura(self.player)
		self:UpdateStacks(1, self.player.last) -- if for some reason self.stackCount is nil, we'll end up using a 0 this way
		-- self:UpdateStacks(1, max(setEndTime, self.player.last)) -- if for some reason self.stackCount is nil, we'll end up using a 0 this way

		self.stackCount = nil -- should have been nil'ed out by UpdateStacks call, but just in case that changes
		self.stackTime = nil  -- stack count was nil'ed out by update stacks call
	end
	
	setmetatable(self, MetaComplete)
end

--=========================================================================--
-- delay init meta, on first read access, initializes needed table values 
-- and replaces itself with a meta of the correct type
--=========================================================================--
local MetaJitter   = { 
	__mode = "v", 
	__index = function(t,k)
		local mt = MetaCurrent

		local setTotal = Skada:find_set("total")
		if (setTotal) then
			local playerTotal = Skada:find_player(setTotal, t.player.id)
			if (t.player == playerTotal) then
				mt = MetaTotal
			end
		end

		-- print("jitting DI meta of type", mt.__index.setType)
		setmetatable(t, mt)

		-- the only time we don't init is if we're completing a completely empty table
		-- so, init if noData is false or not completing
		if (not t.noData or k ~= "Complete") then
	--		print("read access for key", k, "is initializing Dark Intent of type", mt.__index.setType, "for player", t.player.name, t.player)
			t.noData = nil
			for i=-1, 3 do
				t[i] = 0
			end
		end

		return t[k]
	end,
}

local function NewDarkIntent(player)
	local di = setmetatable( { player = player, noData = true }, MetaJitter )
	
	if (player.class == "WARLOCK") then
		di.noData = nil  -- first check will force init so we show 0's instead of nothing for warlocks
	end

	return di
end



local function Applied(timestamp, eventtype, srcGUID, srcName, _, dstGUID, dstName, _, spellId, ...)
	if (g_tblSpellIdsStack[spellId]) then
--		print(eventtype, srcName, dstName)
		if (not Skada.current) then
			print("SDI ERROR: ", eventtype, "recieved but Skada.current is nil")
			return
		end

		local unit = { playerid = dstGUID, playername = dstName }
		Skada:FixPets(unit)

--		print("Applied - original dst guid and name", dstGUID, dstName)
--		print("Applied - after FixMyPets", Skada:FixMyPets(dstGUID, dstName))
--		print("Applied - after FixPets", unit.playerid, unit.playername)
--		print(unit.playername, "stack count", 1)
--		print("Applied", unit.playername, FormatTime(timestamp), FormatTime(time()))
--		local curtime = time()
--		print(format("%s event time stamp -- %s time call -- Applied  %s", FormatTime(timestamp), FormatTime(curtime), unit.playername))

		local di = Skada:get_player(Skada.current, unit.playerid, unit.playername).DarkIntent
		di:UpdateStacks(1, time()) --timestamp)
	end
end

local function Dose(timestamp, eventtype, srcGUID, srcName, _, dstGUID, dstName, _, spellId, ...)
	if (g_tblSpellIdsStack[spellId]) then
		local stackCount = select(4, ...)

--		print(eventtype, srcName, dstName)
		if (not Skada.current) then
			print("SDI ERROR: ", eventtype, "recieved but Skada.current is nil")
			return
		end

		local unit = { playerid = dstGUID, playername = dstName }
		Skada:FixPets(unit)

--		print("Dose", stackCount, "- original dst guid and name", dstGUID, dstName)
--		print("Dose", stackCount, "- after FixMyPets", Skada:FixMyPets(dstGUID, dstName))
--		print("Dose", stackCount, "- after FixPets", unit.playerid, unit.playername)
--		print(unit.playername, "stack count", stackCount)
--		print("Dose", stackCount, unit.playername, FormatTime(timestamp), FormatTime(time()))
--		local curtime = time()
--		print(format("%s event time stamp -- %s time call -- Dose %i  %s", FormatTime(timestamp), FormatTime(time()), stackCount, unit.playername))

		local di = Skada:get_player(Skada.current, unit.playerid, unit.playername).DarkIntent
		di:UpdateStacks(stackCount, time()) --timestamp)
	end
end

local function Removed(timestamp, eventtype, srcGUID, srcName, _, dstGUID, dstName, _, spellId, ...)
	if (g_tblSpellIdsStack[spellId]) then
--		print(eventtype, srcName, dstName)
		if (not Skada.current) then
			print("SDI ERROR: ", eventtype, "recieved but Skada.current is nil")
			return
		end

		local unit = { playerid = dstGUID, playername = dstName }
		Skada:FixPets(unit)

--		print("Removed - original dst guid and name", dstGUID, dstName)
--		print("Removed - after FixMyPets", Skada:FixMyPets(dstGUID, dstName))
--		print("Removed - after FixPets", unit.playerid, unit.playername)
--		print(unit.playername, "stack count", 0)
--		print("Removed", unit.playername, FormatTime(timestamp), FormatTime(time()))
--		local curtime = time()
--		print(format("%s event time stamp -- %s time call -- Removed  %s", FormatTime(timestamp), FormatTime(time()), unit.playername))

		local di = Skada:get_player(Skada.current, unit.playerid, unit.playername).DarkIntent
		di:UpdateStacks(0, time()) --timestamp)
	end
end



function mod:SetComplete(set)
	-- cool; we can use this notification to catch the uptime of the stack value at combats end
	-- print("SetComplete called on set", set.name, set)
	-- print("Set start times differ by", stest.combatStart - set.starttime)
	-- print("Set end times differ by", stest.combatEnd - set.endtime)
	-- print("Set duration differs by", (stest.combatEnd - stest.combatStart) - (set.endtime - set.starttime))
	-- print(format("set %s completed - combat ran from %s to %s for a duration of %s  %s", set.name, FormatTime(set.starttime), FormatTime(set.endtime), FormatTime(set.endtime-set.starttime), FormatTime(set.time)))
	-- print(format("%s - %s = %i secs = %i secs  -- set %s completed", FormatTime(set.endtime), FormatTime(set.starttime), difftime(set.endtime, set.starttime), set.time, set.name))

	for _,player in ipairs(set.players) do
		player.DarkIntent:Complete(set.endtime)
	end
	
	-- Skada:ScheduleTimer(function() Skada:Report("WarfareMeters", "channel", "Dark Intent", "current", 3) end, 3)
	-- Skada:Report("WarfareMeters", "channel", "Dark Intent", "current", 3)
end

local function GetAverages(set, player)
	local di = player and player.DarkIntent

	if (not di or di.noData) then
		return nil, nil
	end
	
	local totalStacks = 0
	for i=1, 3 do
		totalStacks = totalStacks + (i * di[i])
	end
	local totalTime = max(1, Skada:PlayerActiveTime(set, player))
	
	local averageStacks = totalStacks / totalTime
	local averageBuff = averageStacks * 3
	
	return averageStacks, averageBuff
end

function mod:Update(win, set)
	local displayRow = 0
	wipe(win.dataset)
	
	for _, player in ipairs(set.players) do
		local averageStacks, averageBuff = GetAverages(set, player)
		if (averageStacks) then
			displayRow = displayRow + 1
			local rowData = {}
			win.dataset[displayRow] = rowData

			rowData.id = player.id
			rowData.label = player.name
			rowData.class = player.class
			rowData.value = averageStacks
			rowData.valuetext = Skada:FormatValueText(
				format("%02.1f", averageStacks),
				self.metadata.columns.AverageStackSize,
				format("%02.1f%%", averageBuff),
				self.metadata.columns.AverageBuff
			)
		end
	end

	win.metadata.maxvalue = self.metadata.columns.AverageStackSize and 3 or 9
end

local function uptime_tooltip(win, id, label, tooltip)
	for _, rowData in ipairs(win.dataset) do
		if (rowData.id == id) then
			tooltip:AddLine(label.."'s Averages")
			tooltip:AddDoubleLine("average stack size:", format("%02.1f", rowData.value), 255,255,255,255,255,255)
			tooltip:AddDoubleLine("average buff size:", format("%02.1f%%", rowData.value*3), 255,255,255,255,255,255)
		end
	end
--[===[
	local set = win:get_selected_set()
	local player = Skada:find_player(set, id)

	if player then
		local di = player.DarkIntent
		if (di and not di.noData) then
--[==[
			-- TODO - should we assert that if this is true that we must be in the current set
			if player.DarkIntent.timeCurStack and player.DarkIntent.sizeCurStack then
				player.DarkIntent:AddTime(nil, player.id, player.name)
			end
--]==]		
			local totalTime = max(1, Skada:PlayerActiveTime(set, player))
			
			tooltip:AddLine(label.." - Stack Uptimes")
			tooltip:AddDoubleLine("9% buff"..":", format("%02.1f%%", 100 * di[3] / totalTime), 255,255,255,255,255,255)
			tooltip:AddDoubleLine("6% buff"..":", format("%02.1f%%", 100 * di[2] / totalTime), 255,255,255,255,255,255)
			tooltip:AddDoubleLine("3% buff"..":", format("%02.1f%%", 100 * di[1] / totalTime), 255,255,255,255,255,255)
			tooltip:AddDoubleLine("0% buff"..":", format("%02.1f%%", 100 * di[0] / totalTime), 255,255,255,255,255,255)
			if (di[-1] > 0) then
				tooltip:AddDoubleLine("error"..":", format("%02.1f%%", 100 * di[0] / totalTime), 255,255,255,255,255,255)
			end
		end
	end
--]===]
end


function mod:OnEnable()
	g_playerName = UnitName("player")
	g_playerGUID = UnitGUID("player")

--	mod.metadata = {showspots = true,                      tooltip=uptime_tooltip, columns = {AverageStackSize = true, AverageBuff = true}}
	mod.metadata = {showspots = true, click1 = uptimesmod, tooltip=uptime_tooltip, columns = {AverageStackSize = true, AverageBuff = true}}
	uptimesmod.metadata 	= {showspots = false, ordersort = true, columns = {Time = true, Percent = true}}
	
	Skada:RegisterForCL(Dose, 'SPELL_AURA_APPLIED_DOSE', {src_is_interesting = true})
	Skada:RegisterForCL(Applied, 'SPELL_AURA_APPLIED', {src_is_interesting = true})
	Skada:RegisterForCL(Removed, 'SPELL_AURA_REMOVED', {src_is_interesting = true})

	Skada:AddMode(self)
end

function mod:OnDisable()
	Skada:RemoveMode(self)
end


function mod:AddToTooltip(set, tooltip)
	print("AddToTooltip called")
	local avg = self:GetSetSummary(set)
	GameTooltip:AddDoubleLine(L["DI"], format("%02.1f", avg), 1,1,1)
end

-- Called by Skada when a new player is added to a set.
function mod:AddPlayerAttributes(player)
--	print("AddPlayerAttributes called for", player.name, player, player.DarkIntent)
--	print(debugstack(1,8,0))
	if not player.DarkIntent then
		player.DarkIntent = NewDarkIntent(player)
	end
end

-- Called by Skada when a new set is created.
-- Conveniently this is when a new fight starts, so we can clear our shield cache.
function mod:AddSetAttributes(set)
--	print("AddSetAttributes called on set", set.name, set)
end

function mod:GetSetSummary(set)
--	return Skada:FormatNumber(set.healing+set.absorbTotal)
	local player = Skada:find_player(set, g_playerGUID)
	local averageStacks, averageBuff = GetAverages(set, player)

	if (self.metadata.columns.AverageStackSize) then
		return averageStacks
	elseif (self.metadata.columns.AverageBuff) then
		return averageBuff
	else
		return nil
	end
end

--[==[
local function GetStacksByAura(player)
	-- hack for testing stacks on my imp because skada doesn't have an "UnFixPet" method
	local name = string.match(player.name, "Zeptai") or player.name
	local fTrack = false	
	local iAura = 0
	
	repeat
		iAura = iAura + 1
		local name, _, _, count, _, duration, _, _, _, _, spellId, _, _, value1, value2, value3 = UnitAura(tblPlayer.name, iAura)

		if (g_tblSpellIdsStack[spellId]) then
--			print("SDI - stacks found during init. initial stack value is", count)
--			print(UnitAura(tblPlayer.name, iAura))
			return count
		end
		
		fTrack = fTrack or g_tblSpellIdsBuff[spellId]
	until (name == nil)
	
	return fTrack and 0 or nil
end
--]==]


function uptimesmod:Enter(win, id, label)
	uptimesmod.playerid = id
	uptimesmod.title = label.."'s Uptimes"
--	uptimesmod.title = label..L["'s Uptimes"]
end

-- Stack uptimes view of a player.
function uptimesmod:Update(win, set)
	wipe(win.dataset)
		
	local player = Skada:find_player(set, self.playerid)
	if (player) then
		local di = player.DarkIntent
		if (di and not di.noData) then
			local totalTime = max(1, Skada:PlayerActiveTime(set, player))
	
			for displayRow = 1, 4 do
				local rowData = {}
				win.dataset[displayRow] = rowData
				
				local stack = 4-displayRow
				local time = di[stack]
				local min, sec = math.modf(time/60)
				sec = floor(sec * 60)
				local pct = 100 * time / totalTime

				rowData.id = stack
				rowData.label = format("%i%% buff", stack*3)
				rowData.value = pct
				rowData.valuetext = Skada:FormatValueText(
					format("%02.1f%%", pct),
					self.metadata.columns.Percent,
					format("%02i:%02i", min, sec),
					self.metadata.columns.Time
				)
			end
			
			if (di[-1] and di[-1] ~= 0) then
				local displayRow = 5
				local rowData = {}
				win.dataset[displayRow] = rowData
				
				local stack = 4-displayRow
				local time = di[stack]
				local min, sec = math.modf(time/60)
				sec = floor(sec * 60)
				local pct = 100 * time / totalTime

				rowData.id = stack
				rowData.label = "error: lost time"
				rowData.value = pct
				rowData.valuetext = Skada:FormatValueText(
					format("%02i:%02i", min, sec),
					self.metadata.columns.Time,
					format("%02.1f%%", pct),
					self.metadata.columns.Percent
				)
			end
			
			win.metadata.maxvalue = 100
		end
	end
end
