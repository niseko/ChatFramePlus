local _, Addon = ...

Addon.Utils = Addon.Utils or {}

--[[
Memoize function to cache results of a function call for faster future calls.
Function found at https://www.lua.org/gems/sample.pdf
Copyright 2008 by Roberto Ierusalimschy. Used by permission.
]]
--
function Addon.Utils.memoize(f)
	local mem = {}
	setmetatable(mem, { __mode = "kv" })
	return function(x)
		x = x or "NO_ARGUMENT"
		local r = mem[x]
		if r == nil then
			r = f(x)
			mem[x] = r
		end
		return r
	end
end

function Addon.Utils.tableEquals(t1, t2)
	for k, v in pairs(t1) do
		if t2[k] ~= v then
			return false
		end
	end
	for k, v in pairs(t2) do
		if t1[k] ~= v then
			return false
		end
	end
	return true
end

function Addon.Utils.getChatFrames()
	local chatFrames = {}
	for i = 1, NUM_CHAT_WINDOWS do
		chatFrames[i] = _G["ChatFrame" .. i]
	end
	return chatFrames
end
