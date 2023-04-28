local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local _, Addon = ...

Addon.Options = Addon.Options or {}

local borderTextures = {
	["Interface\\DialogFrame\\UI-DialogBox-Border"] = "Blizzard Dialog",
	["Interface\\Tooltips\\UI-Tooltip-Border"] = "Blizzard Tooltip",
}

local function getBorderColor(chatFrameId)
	return function(info)
		local color = Addon.db.profile.chatFrames[chatFrameId].border.color

		return color.r, color.g, color.b, color.a
	end
end

local function setBorderColor(chatFrame)
	return function(info, r, g, b, a)
		local chatFrameId = chatFrame:GetID()
		local color = Addon.db.profile.chatFrames[chatFrameId].border.color
		color.r, color.g, color.b, color.a = r, g, b, a

		Addon.Modules.Border:Update(chatFrame)
	end
end

local function getBorderTexture(chatFrameId)
	return function(info)
		return Addon.db.profile.chatFrames[chatFrameId].border.texture
	end
end

local function setBorderTexture(chatFrame)
	return function(info, texture)
		local chatFrameId = chatFrame:GetID()

		Addon.db.profile.chatFrames[chatFrameId].border.texture = texture

		Addon.Modules.Border:Update(chatFrame)
	end
end

local function generateOptionsTable(chatFrameId)
	local chatFrame = _G["ChatFrame" .. chatFrameId]

	return {
		borderGroup = {
			type = "group",
			name = "Border Options",
			desc = "Options to modify the appearance of the chat frame border",
			inline = false,
			order = 1,
			args = {
				borderColor = {
					type = "color",
					name = "Border Color",
					desc = "Select the border color",
					order = 1,
					hasAlpha = true,
					width = "full",
					get = getBorderColor(chatFrameId),
					set = setBorderColor(chatFrame),
				},
				borderTexture = {
					type = "select",
					name = "Border Texture",
					desc = "Select the border texture",
					order = 2,
					values = borderTextures,
					width = "full",
					get = getBorderTexture(chatFrameId),
					set = setBorderTexture(chatFrame),
				},
			},
		},
	}
end

function Addon.Options:Init()
	local config = {
		type = "group",
		name = "ChatFramePlus",
		handler = Addon,
		args = {
			chatFrames = {
				type = "group",
				name = "Settings",
				args = {},
				order = 1,
			},
		},
	}

	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrameName = (_G["ChatFrame" .. i].name or ("Chat Frame " .. i))

		config.args.chatFrames.args["chatFrame" .. i] = {
			type = "group",
			name = chatFrameName,
			desc = "Settings for " .. chatFrameName,
			order = i,
			args = generateOptionsTable(i),
		}
	end

	AceConfig:RegisterOptionsTable("ChatFramePlus", config)
	AceConfigDialog:SetDefaultSize("ChatFramePlus", 480, 320)
end

function Addon.Options:Open()
	AceConfigDialog:Open("ChatFramePlus")
end
