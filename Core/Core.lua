local _, Addon = ...

ChatFramePlus = LibStub("AceAddon-3.0"):NewAddon("ChatFramePlus", "AceConsole-3.0")

ChatFramePlus.VERSION = GetAddOnMetadata("ChatFramePlus", "Version")

local chatCommandHandler = {
	options = {
		func = function()
			Addon.Options:Open()
		end,
		description = "Open ChatFramePlus options",
	},
	version = {
		func = function()
			ChatFramePlus:Print("Version: " .. ChatFramePlus.VERSION)
		end,
		description = "Show ChatFramePlus version",
	},
}

local function showCommands()
	for command, handler in pairs(chatCommandHandler) do
		ChatFramePlus:Print("/cfp " .. command)
		ChatFramePlus:Print(handler.description)
	end
end

local function chatCommand(input)
	local command = input:lower()
	local handler = chatCommandHandler[command]

	if handler then
		handler.func()
	else
		showCommands()
	end
end

function ChatFramePlus:OnInitialize()
	Addon.db = LibStub("AceDB-3.0"):New("ChatFramePlusDB", self:GetDatabaseDefaults(), true)

	Addon.Options:Init()

	self:RegisterChatCommand("cfp", chatCommand)
	self:RegisterChatCommand("chatframeplus", chatCommand)
end

function ChatFramePlus:OnEnable()
	Addon.Modules.Border:Init()
end
