local TSM = select(2, ...)
local Util = TSM:NewModule("Util")

local qualityColors = {
	[0]="9d9d9d",
	[1]="ffffff",
	[2]="1eff00",
	[3]="0070dd",
	[4]="a335ee",
	[5]="ff8000",
	[6]="e6cc80",
}

local alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_="
local base = #alpha
local function decode(h)
	if strfind(h, "~") then return end
	local result = 0
	
	local i = #h - 1
	for w in string.gmatch(h, "([A-Za-z0-9_=])") do
		result = result + (strfind(alpha, w)-1)*(base^i)
		i = i - 1
	end
	
	return result
end

local function encode(d)
	local r = d % base
	local result
	if d-r == 0 then
		result = strsub(alpha, r+1, r+1)
	else 
		result = encode((d-r)/base) .. strsub(alpha, r+1, r+1)
	end
	return result
end

function Util:EncodeItemString(itemString)
	local _, itemID, _, _, _, _, _, suffixID = (":"):split(itemString)
	itemID, suffixID = tonumber(itemID), tonumber(suffixID)
	result = encode(itemID)
	if suffixID > 0 then
		result = result..":"..encode(suffixID)
	elseif suffixID < 0 then
		result = result..":-"..encode(abs(suffixID))
	end
	return result
end

function Util:DecodeItemString(itemCode)
	local itemID, suffixID = (":"):split(itemCode)
	local itemString
	if suffixID then
		local num
		suffixID, num = gsub(suffixID, "-", "")
		if num > 0 then
			itemString = "item:"..decode(itemID)..":0:0:0:0:0:-"..decode(suffixID)
		else
			itemString = "item:"..decode(itemID)..":0:0:0:0:0:"..decode(suffixID)
		end
	else
		itemString = "item:"..decode(itemID)..":0:0:0:0:0:0"
	end
	
	return itemString
end

function Util:EncodeItemLink(link) --"|cff1eff00|Hitem:36926:0:0:0:0:0:0:1173889664:80:0|h[Shadow Crystal]|h|r"
	link = link:trim()
	link = gsub(link, "|cff", "") -- "1eff00|Hitem:36926:0:0:0:0:0:0:1173889664:80:0|h[Shadow Crystal]|h|r"
	link = gsub(link, "|H", "|") -- "1eff00|item:36926:0:0:0:0:0:0:1173889664:80:0|h[Shadow Crystal]|h|r"
	link = gsub(link, "|h|r", "") -- "1eff00|item:36926:0:0:0:0:0:0:1173889664:80:0|h[Shadow Crystal]"
	link = gsub(link, "|h", "|") -- "1eff00|item:36926:0:0:0:0:0:0:1173889664:80:0|[Shadow Crystal]"
	link = gsub(link, "%[", "") -- "1eff00|item:36926:0:0:0:0:0:0:1173889664:80:0|Shadow Crystal]"
	link = gsub(link, "%]", "") -- "1eff00|item:36926:0:0:0:0:0:0:1173889664:80:0|Shadow Crystal"
	
	local colorHex, itemString, itemName = ("|"):split(link) -- "1eff00", "item:36926:0:0:0:0:0:0:1173889664:80:0", "Shadow Crystal"
	if not (colorHex and itemString and itemName) then return end
	local quality = ""
	for i, c in pairs(qualityColors) do
		if c == colorHex then
			quality = i
			break
		end
	end
	return quality.."|"..Util:EncodeItemString(itemString).."|"..itemName
end

function Util:DecodeItemLink(link)
	local colorCode, itemCode, name = ("|"):split(link)
	local color = qualityColors[tonumber(colorCode) or 0] or qualityColors[0]
	if not (colorCode and itemCode and name) then return end
	return "|cff"..color.."|H"..Util:DecodeItemString(itemCode).."|h["..name.."]|h|r", Util:DecodeItemString(itemCode)
end

function Util:EncodeRecord(record, dType)
	local stackSize = encode(record.stackSize)
	local quantity = encode(record.quantity)
	local sTime = encode(floor(record.time))
	local price = encode(record.price)
	local otherPerson = record[dType] or ""
	local player = record.player or ""
	return stackSize.."#"..quantity.."#"..sTime.."#"..price.."#"..otherPerson.."#"..player
end

function Util:DecodeRecord(record, dType)
	local stackSize, quantity, sTime, price, otherPerson, player = ("#"):split(record)
	if not otherPerson then return end
	local result = {}
	result.stackSize = tonumber(decode(stackSize))
	result.quantity = tonumber(decode(quantity))
	result.time = tonumber(decode(sTime))
	result.price = tonumber(decode(price))
	result[dType] = otherPerson ~= "x" and otherPerson
	result.player = player ~= "x" and player
	return result
end

function Util:Serialize()
	local sellData
	for itemString, data in pairs(TSM.soldData) do
		data.link = data.link or select(2, GetItemInfo(itemString))
		local link = data.link and Util:EncodeItemLink(data.link) or("x"..Util:EncodeItemString(itemString))
		local records
		for _, record in pairs(data.records) do
			if records then
				records = records.."@"..Util:EncodeRecord(record, "buyer")
			else
				records = Util:EncodeRecord(record, "buyer")
			end
		end
		local itemData = link.."!"..records
		if sellData then
			sellData = sellData .. "?"..itemData
		else
			sellData = itemData
		end
	end
	TSM.db.factionrealm.sellDataRope = sellData
	
	local buyData
	for itemString, data in pairs(TSM.buyData) do
		data.link = data.link or select(2, GetItemInfo(itemString))
		local link = data.link and Util:EncodeItemLink(data.link) or ("x"..Util:EncodeItemString(itemString))
		local records
		for _, record in pairs(data.records) do
			if records then
				records = records.."@"..Util:EncodeRecord(record, "seller")
			else
				records = Util:EncodeRecord(record, "seller")
			end
		end
		local itemData = link.."!"..records
		if buyData then
			buyData = buyData .. "?"..itemData
		else
			buyData = itemData
		end
	end
	TSM.db.factionrealm.buyDataRope = buyData
end

function Util:Deserialize()
	TSM.soldData = {}
	TSM.buyData = {}
	
	local errorNum = 0
	if TSM.db.factionrealm.sellDataRope then
		for _, itemData in ipairs({("?"):split(TSM.db.factionrealm.sellDataRope)}) do
			local encodedLink, encodedRecords = ("!"):split(itemData)
			local itemLink, itemString
			local records = {}
			if encodedLink and encodedRecords then
				if strsub(encodedLink, 1, 1) == "x" then
					itemString = Util:DecodeItemString(strsub(encodedLink, 2))
				else
					itemLink, itemString = Util:DecodeItemLink(encodedLink)
				end
				for i, record in ipairs({("@"):split(encodedRecords)}) do
					local decodedData = Util:DecodeRecord(record, "buyer")
					if decodedData then
						tinsert(records, decodedData)
					end
				end
			end
			if itemString then
				TSM.soldData[itemString] = {records=records, link=itemLink}
			else
				print("ERROR3")
			end
		end
	else
		print("ERROR")
	end
	
	if TSM.db.factionrealm.buyDataRope then
		for _, itemData in ipairs({("?"):split(TSM.db.factionrealm.buyDataRope)}) do
			local encodedLink, encodedRecords = ("!"):split(itemData)
			local itemLink, itemString
			local records = {}
			if encodedLink and encodedRecords then
				if strsub(encodedLink, 1, 1) == "x" then
					itemString = Util:DecodeItemString(strsub(encodedLink, 2))
				else
					itemLink, itemString = Util:DecodeItemLink(encodedLink)
				end
				if encodedRecords then
					for i, record in ipairs({("@"):split(encodedRecords)}) do
						local decodedData = Util:DecodeRecord(record, "seller")
						if decodedData then
							tinsert(records, decodedData)
						end
					end
				end
			end
			if itemString then
				TSM.buyData[itemString] = {records=records, link=itemLink}
			else
				print("ERROR2")
			end
		end
	else
		print("ERROR")
	end
end