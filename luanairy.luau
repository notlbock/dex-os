--Luanairy
local DataStore = {}

-- A1Z26 helpers
local function charToA1Z26(c)
	local code = string.byte(c:lower())
	if code >= 97 and code <= 122 then
		return code - 96
	end
	return nil  -- non-letter
end

local function A1Z26ToChar(num)
	return string.char(num + 96)
end


-----------------------------------------------------------
-- ENCODE STRING → REVERSIBLE ENCODED STRING
-----------------------------------------------------------
function DataStore.StringToData(str)
	local encodedPieces = {}

	for i = 1, #str do
		local c = str:sub(i, i)
		local a1 = charToA1Z26(c)

		if a1 then
			-- Encode letters
			local digits = tostring(a1)
			local enc = {}

			for d = 1, #digits do
				local digit = tonumber(digits:sub(d, d))
				digit = (digit + 10) / 23
				table.insert(enc, digit)
			end

			table.insert(encodedPieces, table.concat(enc, ","))
		else
			-- Preserve non-letters EXACTLY
			table.insert(encodedPieces, "#" .. c)
		end
	end

	return table.concat(encodedPieces, ";")
end


-----------------------------------------------------------
-- DECODE BACK → ORIGINAL STRING
-----------------------------------------------------------
function DataStore.DataToString(encoded)
	local parts = string.split(encoded, ";")
	local result = {}

	for _, part in ipairs(parts) do
		if part:sub(1,1) == "#" then
			-- This was a preserved non-letter
			table.insert(result, part:sub(2))
		elseif part:match("^%d") then
			-- Reversible encoded letter
			local nums = string.split(part, ",")
			local dig = {}

			for _, n in ipairs(nums) do
				local val = tonumber(n)
				val = (val * 23) - 10
				table.insert(dig, tostring(val))
			end

			local a1 = tonumber(table.concat(dig))
			table.insert(result, A1Z26ToChar(a1))
		end
	end

	return table.concat(result)
end

return DataStore
