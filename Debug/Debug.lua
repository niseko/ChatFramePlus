local _, Addon = ...

function Addon:DebugPrint(...)
	if Addon.db.profile.debug then
		print("ChatFramePlus [Debug]:", ...)
	end
end
