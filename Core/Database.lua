local _, Addon = ...

local function createDefaultBorderSettings()
	local borderSettings = {
		color = { r = 1, g = 1, b = 1, a = 1 },
		texture = "Interface\\Tooltips\\UI-Tooltip-Border",
		size = 16,
		insets = 4,
	}

	return borderSettings
end

local getDefaultBorderSettings = Addon.Utils.memoize(createDefaultBorderSettings)

function ChatFramePlus:GetDatabaseDefaults()
	local database = {
		profile = {
			chatFrames = {},
			debug = false,
		},
	}

	local defaultBorderSettings = getDefaultBorderSettings()

	for i = 1, NUM_CHAT_WINDOWS do
		database.profile.chatFrames[i] = {
			border = defaultBorderSettings,
		}
	end

	return database
end
