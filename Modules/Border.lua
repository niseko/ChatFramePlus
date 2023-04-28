local _, Addon = ...

Addon.Modules = Addon.Modules or {}

Addon.Modules.Border = Addon.Modules.Border or {}

local BackdropTemplate = BackdropTemplateMixin and "BackdropTemplate" or nil

local borderPool = CreateFramePool("Frame", nil, BackdropTemplate)

local borderCache = setmetatable({}, { __mode = "v" })

local function GetBorderSettings(chatFrameId)
	local borderSettings = borderCache[chatFrameId] or Addon.db.profile.chatFrames[chatFrameId].border

	return borderSettings
end

local function CreateBorder(chatFrame)
	local border = borderPool:Acquire()
	chatFrame.border = border
	border:SetParent(chatFrame)
	border:SetPoint("BOTTOMRIGHT", chatFrame, "BOTTOMRIGHT", 4, -8)

	if chatFrame.name == "Combat Log" then
		border:SetPoint("TOPLEFT", -4, 28)
	else
		border:SetPoint("TOPLEFT", -4, 4)
	end

	return border
end

local function SetBorderBackdrop(border, borderSettings)
	local borderBackdrop = {
		edgeFile = borderSettings.texture,
		edgeSize = borderSettings.edgeSize,
		insets = {
			left = borderSettings.insets,
			right = borderSettings.insets,
			top = borderSettings.insets,
			bottom = borderSettings.insets,
		},
	}

	border:SetBackdrop(borderBackdrop)
	border:SetBackdropBorderColor(
		borderSettings.color.r,
		borderSettings.color.g,
		borderSettings.color.b,
		borderSettings.color.a
	)
end

local chatFrames = {}

for i = 1, NUM_CHAT_WINDOWS do
	chatFrames[i] = _G["ChatFrame" .. i]
end

function Addon.Modules.Border:Init()
	local borderModule = Addon.Modules.Border

	for _, chatFrame in ipairs(chatFrames) do
		if chatFrame:IsVisible() then
			borderModule:Create(chatFrame)
		end
	end
end

function Addon.Modules.Border:Create(chatFrame)
	local chatFrameId = chatFrame:GetID()
	local borderSettings = GetBorderSettings(chatFrameId)

	local border = CreateBorder(chatFrame)
	SetBorderBackdrop(border, borderSettings)

	borderCache[chatFrameId] = borderSettings

	border:Show()
end

function Addon.Modules.Border:Remove(chatFrame)
	local border = chatFrame.border

	if border then
		borderPool:Release(border)
		chatFrame.border = nil
	end
end

function Addon.Modules.Border:Update(chatFrame)
	local chatFrameId = chatFrame:GetID()
	local border = chatFrame.border
	local borderSettings = GetBorderSettings(chatFrameId)

	if border then
		SetBorderBackdrop(border, borderSettings)
	end
end
