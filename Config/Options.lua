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

local function getBorderEdgeSize(chatFrameId)
	return function(info)
		return Addon.db.profile.chatFrames[chatFrameId].border.edgeSize
	end
end

local function setBorderEdgeSize(chatFrame)
	return function(info, edgeSize)
		local chatFrameId = chatFrame:GetID()

		Addon.db.profile.chatFrames[chatFrameId].border.edgeSize = edgeSize

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

local function borderOptions(chatFrameId, chatFrame)
	return {
		type = "group",
		name = "Border",
		desc = "Options to modify the appearance of the chat frame border",
		inline = false,
		order = 1,
		args = {
			borderColor = {
				type = "color",
				name = "Color",
				desc = "Select the border color",
				order = 1,
				hasAlpha = true,
				width = "full",
				get = getBorderColor(chatFrameId),
				set = setBorderColor(chatFrame),
			},
			borderEdgeSize = {
				type = "range",
				name = "Edge Size",
				desc = "Adjust the border edge size",
				min = 8,
				max = 16,
				step = 4,
				order = 2,
				width = "full",
				get = getBorderEdgeSize(chatFrameId),
				set = setBorderEdgeSize(chatFrame),
			},
			borderTexture = {
				type = "select",
				name = "Texture",
				desc = "Select the border texture",
				order = 3,
				values = borderTextures,
				width = "full",
				get = getBorderTexture(chatFrameId),
				set = setBorderTexture(chatFrame),
			},
		},
	}
end

local function generateOptionsTable(chatFrameId)
	local chatFrame = _G["ChatFrame" .. chatFrameId]

	return {
		borderGroup = borderOptions(chatFrameId, chatFrame),
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
