local _, Addon = ...

ChatFramePlus.Hooks = ChatFramePlus.Hooks or {}

ChatFramePlus.Hooks.ChatFrame = {}

local function OnChatFrameShow(chatFrame)
	Addon.Modules.Border:Create(chatFrame)
end

local function OnChatFrameHide(chatFrame)
	Addon.Modules.Border:Remove(chatFrame)
end

function ChatFramePlus.Hooks.ChatFrame:Init()
	local chatFrames = {}

	for i = 1, NUM_CHAT_WINDOWS do
		chatFrames[i] = _G["ChatFrame" .. i]
	end

	for _, chatFrame in ipairs(chatFrames) do
		ChatFramePlus:SecureHookScript(chatFrame, "OnShow", OnChatFrameShow)
		ChatFramePlus:SecureHookScript(chatFrame, "OnHide", OnChatFrameHide)
	end
end
