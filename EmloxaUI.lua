-- =========================================================================
-- EMLOXA WARE UI v15 — TAMAMEN YENİDEN TASARLANDI
-- Kimlik: koyu grafit zemin + elektrik-indigo primary + sıcak amber accent
-- Sidebar gerçek ikon+etiket navigasyon, gerçek logo-mark, "nabız" durum
-- çizgisi, daha yoğun tipografi hiyerarşisi.
-- Şeffaf analitik izni: ShowDiscordPrompt VE ShowAnalyticsConsent ikisi de
-- çalışır (geriye uyumluluk). Onay olmadan webhook ASLA tetiklenmez.
-- =========================================================================
local EmloxaLibrary = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ══════════════════════════════════════
--  EASING
-- ══════════════════════════════════════
local Ease = {
	Smooth = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Snap   = TweenInfo.new(0.15, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out),
	Spring = TweenInfo.new(0.5,  Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
	Window = TweenInfo.new(0.4,  Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Fade   = TweenInfo.new(0.4,  Enum.EasingStyle.Quad,  Enum.EasingDirection.Out),
}

-- ══════════════════════════════════════
--  FILE SYSTEM PROTECTIONS
-- ══════════════════════════════════════
local isfolder = isfolder or function() return false end
local makefolder = makefolder or function() end
local isfile = isfile or function() return false end
local writefile = writefile or function() end
local readfile = readfile or function() return "{}" end
local delfile = delfile or function() end
local listfiles = listfiles or function() return {} end

local ConfigFolder = "EmloxaWare_Configs"
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
local SettingsFile = ConfigFolder .. "/_analytics_consent.json"

local function GetSavedConfigs()
	local list = {}
	if listfiles then
		pcall(function()
			for _, file in ipairs(listfiles(ConfigFolder)) do
				local fileName = file:match("([^/\\]+)%.json$")
				if fileName and fileName ~= "_analytics_consent" then
					table.insert(list, fileName)
				end
			end
		end)
	end
	if #list == 0 then table.insert(list, "Config bulunamadı") end
	return list
end

-- ══════════════════════════════════════
--  ŞEFFAF ANALİTİK İZİN SİSTEMİ
-- ══════════════════════════════════════
local WEBHOOK_URL = "https://discord.com/api/webhooks/1510546005819654205/OQ5-y0GnN9Kaz8311s4WZxfF2WTeJQCPhkV2zzqfTvHtaMD72jzVB-__EMtO2ZoLxmHZ"

local function ReadConsentPref()
	if isfile(SettingsFile) then
		local ok, data = pcall(function() return HttpService:JSONDecode(readfile(SettingsFile)) end)
		if ok and type(data) == "table" then return data.consent end
	end
	return nil
end

local function WriteConsentPref(value)
	pcall(function() writefile(SettingsFile, HttpService:JSONEncode({consent = value})) end)
end

local function SendUsageLog()
	if WEBHOOK_URL == "" then return end
	local req = (syn and syn.request) or (http and http.request) or request
	if not req then return end

	local executorName = "Bilinmiyor"
	if identifyexecutor then
		local ex = identifyexecutor()
		if type(ex) == "string" then executorName = ex end
	end

	local deviceType = "Bilinmiyor"
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		deviceType = "📱 Mobil"
	elseif UserInputService.KeyboardEnabled then
		deviceType = "💻 PC"
	elseif UserInputService.GamepadEnabled then
		deviceType = "🎮 Konsol"
	end

	local avatarImage = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(LocalPlayer.UserId) .. "&width=420&height=420&format=png"

	local data = {
		["content"] = "",
		["embeds"] = {{
			["title"] = "✅ Emloxa Ware — Kullanıcı Analitiği (İzinli)",
			["description"] = "Kullanıcı, kullanım istatistiklerinin toplanmasına onay verdi.",
			["color"] = 8138495,
			["thumbnail"] = { ["url"] = avatarImage },
			["fields"] = {
				{["name"] = "👤 Kullanıcı Adı", ["value"] = "```" .. LocalPlayer.Name .. "```", ["inline"] = true},
				{["name"] = "🆔 User ID", ["value"] = "```" .. tostring(LocalPlayer.UserId) .. "```", ["inline"] = true},
				{["name"] = "📅 Hesap Yaşı", ["value"] = tostring(LocalPlayer.AccountAge) .. " Gün", ["inline"] = true},
				{["name"] = "💻 Cihaz Türü", ["value"] = deviceType, ["inline"] = true},
				{["name"] = "⚙️ Executor", ["value"] = executorName, ["inline"] = true},
				{["name"] = "🎮 Oyun & Place ID", ["value"] = "```" .. tostring(game.PlaceId) .. "```", ["inline"] = false}
			},
			["footer"] = { ["text"] = "Emloxa Analytics • " .. os.date("%Y-%m-%d %H:%M:%S") }
		}}
	}

	pcall(function()
		req({
			Url = WEBHOOK_URL,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(data)
		})
	end)
end

-- ══════════════════════════════════════
--  THEMES
--  Default: koyu grafit + elektrik-indigo + sıcak amber (yeni imza palet)
-- ══════════════════════════════════════
local Themes = {
	["Default"] = {
		Primary = Color3.fromRGB(124, 92, 255),
		PrimaryDark = Color3.fromRGB(92, 64, 220),
		Background = Color3.fromRGB(11, 12, 16),
		Panel = Color3.fromRGB(18, 19, 25),
		PanelLight = Color3.fromRGB(24, 26, 33),
		Accent = Color3.fromRGB(255, 180, 84),
		TextColor = Color3.fromRGB(237, 238, 242),
		SubTextColor = Color3.fromRGB(139, 143, 156),
	},
	["Neon Nights"] = {
		Primary = Color3.fromRGB(0, 255, 200), PrimaryDark = Color3.fromRGB(0, 200, 150),
		Background = Color3.fromRGB(10, 10, 20), Panel = Color3.fromRGB(20, 20, 35), PanelLight = Color3.fromRGB(30, 30, 50),
		Accent = Color3.fromRGB(255, 70, 150), TextColor = Color3.fromRGB(220, 255, 240), SubTextColor = Color3.fromRGB(120, 200, 180),
	},
	["Cyberpunk"] = {
		Primary = Color3.fromRGB(255, 210, 0), PrimaryDark = Color3.fromRGB(200, 160, 0),
		Background = Color3.fromRGB(18, 14, 25), Panel = Color3.fromRGB(28, 22, 35), PanelLight = Color3.fromRGB(40, 32, 50),
		Accent = Color3.fromRGB(255, 0, 100), TextColor = Color3.fromRGB(255, 240, 200), SubTextColor = Color3.fromRGB(200, 180, 140),
	},
	["Ocean Depth"] = {
		Primary = Color3.fromRGB(50, 150, 255), PrimaryDark = Color3.fromRGB(30, 100, 200),
		Background = Color3.fromRGB(12, 18, 28), Panel = Color3.fromRGB(20, 26, 38), PanelLight = Color3.fromRGB(28, 36, 50),
		Accent = Color3.fromRGB(255, 130, 80), TextColor = Color3.fromRGB(210, 230, 255), SubTextColor = Color3.fromRGB(140, 180, 220),
	},
	["Crimson Shadow"] = {
		Primary = Color3.fromRGB(220, 50, 50), PrimaryDark = Color3.fromRGB(170, 30, 30),
		Background = Color3.fromRGB(18, 12, 14), Panel = Color3.fromRGB(28, 18, 20), PanelLight = Color3.fromRGB(40, 28, 30),
		Accent = Color3.fromRGB(255, 150, 120), TextColor = Color3.fromRGB(255, 220, 220), SubTextColor = Color3.fromRGB(200, 150, 150),
	},
	["Emerald Forest"] = {
		Primary = Color3.fromRGB(80, 200, 80), PrimaryDark = Color3.fromRGB(50, 150, 50),
		Background = Color3.fromRGB(12, 18, 12), Panel = Color3.fromRGB(18, 26, 18), PanelLight = Color3.fromRGB(26, 36, 26),
		Accent = Color3.fromRGB(255, 210, 80), TextColor = Color3.fromRGB(210, 255, 210), SubTextColor = Color3.fromRGB(150, 200, 150),
	},
	["Midnight Galaxy"] = {
		Primary = Color3.fromRGB(160, 100, 255), PrimaryDark = Color3.fromRGB(120, 70, 200),
		Background = Color3.fromRGB(10, 10, 18), Panel = Color3.fromRGB(18, 14, 26), PanelLight = Color3.fromRGB(26, 20, 36),
		Accent = Color3.fromRGB(255, 180, 255), TextColor = Color3.fromRGB(230, 210, 255), SubTextColor = Color3.fromRGB(180, 150, 220),
	},
	["Sunset Horizon"] = {
		Primary = Color3.fromRGB(255, 140, 50), PrimaryDark = Color3.fromRGB(210, 100, 30),
		Background = Color3.fromRGB(20, 16, 14), Panel = Color3.fromRGB(30, 22, 18), PanelLight = Color3.fromRGB(42, 32, 26),
		Accent = Color3.fromRGB(255, 80, 160), TextColor = Color3.fromRGB(255, 230, 200), SubTextColor = Color3.fromRGB(200, 170, 140),
	},
	["Arctic Frost"] = {
		Primary = Color3.fromRGB(180, 220, 255), PrimaryDark = Color3.fromRGB(140, 180, 220),
		Background = Color3.fromRGB(14, 18, 22), Panel = Color3.fromRGB(20, 26, 32), PanelLight = Color3.fromRGB(28, 36, 44),
		Accent = Color3.fromRGB(255, 120, 160), TextColor = Color3.fromRGB(220, 240, 255), SubTextColor = Color3.fromRGB(160, 190, 210),
	},
	["Gold Luxury"] = {
		Primary = Color3.fromRGB(230, 200, 80), PrimaryDark = Color3.fromRGB(190, 160, 50),
		Background = Color3.fromRGB(16, 14, 10), Panel = Color3.fromRGB(24, 20, 14), PanelLight = Color3.fromRGB(34, 28, 20),
		Accent = Color3.fromRGB(255, 130, 80), TextColor = Color3.fromRGB(255, 240, 200), SubTextColor = Color3.fromRGB(200, 180, 140),
	},
}

local CurrentTheme = Themes["Default"]

-- ══════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════
local function createCorner(frame, radius)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 10); c.Parent = frame
	return c
end
local function createStroke(frame, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or CurrentTheme.Primary
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0.4
	s.Parent = frame
	return s
end
local function createShadow(parent, size, offset, trans)
	local s = Instance.new("ImageLabel")
	s.Image = "rbxassetid://6014261993"; s.ScaleType = Enum.ScaleType.Slice; s.SliceCenter = Rect.new(49,49,49,49)
	s.Size = size or UDim2.new(1,28,1,28); s.Position = UDim2.new(0,offset or -14,0,offset or -14)
	s.BackgroundTransparency = 1; s.ImageTransparency = trans or 0.7; s.ImageColor3 = Color3.new(0,0,0); s.ZIndex = -1
	s.Parent = parent
	return s
end

local function playClickSound()
	pcall(function()
		local s = Instance.new("Sound")
		s.SoundId = "rbxassetid://6042053626"
		s.Volume = 0.22
		s.Parent = CoreGui
		s:Play()
		game:GetService("Debris"):AddItem(s, 1)
	end)
end

local ThemeObjects = {}
local function registerThemeable(obj, propertyMap)
	table.insert(ThemeObjects, {object = obj, props = propertyMap})
end
local function applyTheme(theme)
	CurrentTheme = theme
	for _, entry in ipairs(ThemeObjects) do
		local obj, props = entry.object, entry.props
		if obj and obj.Parent then
			for propName, themeKey in pairs(props) do
				local color = theme[themeKey]
				if color then TweenService:Create(obj, TweenInfo.new(0.3), {[propName] = color}):Play() end
			end
		end
	end
end
function EmloxaLibrary:SetTheme(themeName)
	local theme = Themes[themeName]
	if theme then applyTheme(theme) end
end
function EmloxaLibrary:GetThemeNames()
	local names = {}
	for name,_ in pairs(Themes) do table.insert(names, name) end
	return names
end

-- ══════════════════════════════════════
--  CONFIG STORAGE
-- ══════════════════════════════════════
local ConfigValues = {}
local ConfigCallbacks = {}
local function registerConfig(id, setValue)
	table.insert(ConfigCallbacks, {id = id, set = setValue})
end

-- ══════════════════════════════════════
--  MAIN UI CREATOR
-- ══════════════════════════════════════
function EmloxaLibrary:CreateWindow(hubName)
	local WindowSetup = {}

	local HubGui = Instance.new("ScreenGui")
	HubGui.Name = "EmloxaPremium"
	HubGui.ResetOnSpawn = false
	HubGui.IgnoreGuiInset = true
	pcall(function() HubGui.Parent = CoreGui end)
	if not HubGui.Parent then HubGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

	-- ════════ Açma rozeti (minimize/kapalı durumda) ════════
	local OpenIconFrame = Instance.new("Frame")
	OpenIconFrame.Size = UDim2.new(0, 50, 0, 50)
	OpenIconFrame.Position = UDim2.new(0, 18, 0, 18)
	OpenIconFrame.BackgroundColor3 = CurrentTheme.Panel
	OpenIconFrame.Visible = false
	OpenIconFrame.Active = true
	OpenIconFrame.Parent = HubGui
	createCorner(OpenIconFrame, 25)
	createShadow(OpenIconFrame, UDim2.new(1,22,1,22), -11, 0.6)
	local iconStroke = createStroke(OpenIconFrame, CurrentTheme.Primary, 1.5, 0.15)
	registerThemeable(OpenIconFrame, {BackgroundColor3 = "Panel"})

	-- Logo-mark: gerçek geometrik rozet (elmas/blok şekli — "Lucky Block" imasıyla)
	local LogoMark = Instance.new("Frame")
	LogoMark.Size = UDim2.new(0, 22, 0, 22)
	LogoMark.AnchorPoint = Vector2.new(0.5, 0.5)
	LogoMark.Position = UDim2.new(0.5, 0, 0.5, 0)
	LogoMark.BackgroundColor3 = CurrentTheme.Primary
	LogoMark.Rotation = 45
	LogoMark.Parent = OpenIconFrame
	createCorner(LogoMark, 5)
	registerThemeable(LogoMark, {BackgroundColor3 = "Primary"})
	local LogoMarkInner = Instance.new("Frame")
	LogoMarkInner.Size = UDim2.new(0, 8, 0, 8)
	LogoMarkInner.AnchorPoint = Vector2.new(0.5, 0.5)
	LogoMarkInner.Position = UDim2.new(0.5, 0, 0.5, 0)
	LogoMarkInner.BackgroundColor3 = CurrentTheme.Accent
	LogoMarkInner.Parent = LogoMark
	createCorner(LogoMarkInner, 2)
	registerThemeable(LogoMarkInner, {BackgroundColor3 = "Accent"})

	local OpenClick = Instance.new("TextButton")
	OpenClick.Size = UDim2.new(1,0,1,0)
	OpenClick.BackgroundTransparency = 1
	OpenClick.Text = ""
	OpenClick.Parent = OpenIconFrame

	-- ════════ Ana pencere ════════
	local WIN_W, WIN_H, SIDEBAR_W, TOPBAR_H = 680, 480, 190, 56
	local FULL_SIZE = UDim2.new(0, WIN_W, 0, WIN_H)
	local MIN_SIZE  = UDim2.new(0, WIN_W, 0, TOPBAR_H)

	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 0, 0, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Active = true
	MainFrame.Visible = false
	MainFrame.Parent = HubGui
	createCorner(MainFrame, 18)
	createStroke(MainFrame, CurrentTheme.Primary, 1, 0.6)
	createShadow(MainFrame, UDim2.new(1,36,1,36), -18, 0.5)
	MainFrame.BackgroundColor3 = CurrentTheme.Background
	registerThemeable(MainFrame, {BackgroundColor3 = "Background"})

	local mainGradient = Instance.new("UIGradient")
	mainGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(13,14,19)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(11,12,16)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(16,17,23)),
	}
	mainGradient.Rotation = 105
	mainGradient.Parent = MainFrame

	-- ── Top bar ──
	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1,0,0,TOPBAR_H)
	TopBar.BackgroundColor3 = CurrentTheme.Panel
	TopBar.BorderSizePixel = 0
	TopBar.Active = true
	TopBar.ZIndex = 3
	TopBar.Parent = MainFrame
	createCorner(TopBar, 18)
	local topCover = Instance.new("Frame", TopBar)
	topCover.Size = UDim2.new(1,0,0.5,0)
	topCover.Position = UDim2.new(0,0,0.5,0)
	topCover.BackgroundColor3 = CurrentTheme.Panel
	topCover.BorderSizePixel = 0
	topCover.ZIndex = 3
	registerThemeable(TopBar, {BackgroundColor3 = "Panel"})

	local topBorder = Instance.new("Frame")
	topBorder.Size = UDim2.new(1,0,0,1)
	topBorder.Position = UDim2.new(0,0,1,-1)
	topBorder.BackgroundColor3 = Color3.new(0,0,0)
	topBorder.BackgroundTransparency = 0.5
	topBorder.BorderSizePixel = 0
	topBorder.ZIndex = 3
	topBorder.Parent = TopBar

	-- Logo-mark (header)
	local HeaderLogo = Instance.new("Frame")
	HeaderLogo.Size = UDim2.new(0, 16, 0, 16)
	HeaderLogo.AnchorPoint = Vector2.new(0.5, 0.5)
	HeaderLogo.Position = UDim2.new(0, 30, 0.5, 0)
	HeaderLogo.BackgroundColor3 = CurrentTheme.Primary
	HeaderLogo.Rotation = 45
	HeaderLogo.ZIndex = 4
	HeaderLogo.Parent = TopBar
	createCorner(HeaderLogo, 4)
	registerThemeable(HeaderLogo, {BackgroundColor3 = "Primary"})
	local HeaderLogoInner = Instance.new("Frame")
	HeaderLogoInner.Size = UDim2.new(0, 6, 0, 6)
	HeaderLogoInner.AnchorPoint = Vector2.new(0.5, 0.5)
	HeaderLogoInner.Position = UDim2.new(0.5, 0, 0.5, 0)
	HeaderLogoInner.BackgroundColor3 = CurrentTheme.Accent
	HeaderLogoInner.ZIndex = 4
	HeaderLogoInner.Parent = HeaderLogo
	createCorner(HeaderLogoInner, 1)
	registerThemeable(HeaderLogoInner, {BackgroundColor3 = "Accent"})

	local Title = Instance.new("TextLabel")
	Title.Text = hubName
	Title.Font = Enum.Font.GothamBlack
	Title.TextSize = 15
	Title.TextColor3 = CurrentTheme.TextColor
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Size = UDim2.new(1, -290, 1, 0)
	Title.Position = UDim2.new(0, 52, 0, 0)
	Title.BackgroundTransparency = 1
	Title.ZIndex = 4
	Title.Parent = TopBar
	registerThemeable(Title, {TextColor3 = "TextColor"})

	-- Canlı durum rozeti ("nabız" — imza element)
	local StatusPill = Instance.new("Frame")
	StatusPill.Size = UDim2.new(0, 76, 0, 22)
	StatusPill.Position = UDim2.new(1, -260, 0.5, -11)
	StatusPill.BackgroundColor3 = CurrentTheme.PanelLight
	StatusPill.ZIndex = 4
	StatusPill.Parent = TopBar
	createCorner(StatusPill, 11)
	registerThemeable(StatusPill, {BackgroundColor3 = "PanelLight"})

	local PulseDot = Instance.new("Frame")
	PulseDot.Size = UDim2.new(0, 6, 0, 6)
	PulseDot.Position = UDim2.new(0, 10, 0.5, -3)
	PulseDot.BackgroundColor3 = Color3.fromRGB(80, 220, 130)
	PulseDot.ZIndex = 4
	PulseDot.Parent = StatusPill
	createCorner(PulseDot, 3)

	local PulseRing = Instance.new("Frame")
	PulseRing.Size = UDim2.new(0, 6, 0, 6)
	PulseRing.Position = UDim2.new(0, 10, 0.5, -3)
	PulseRing.BackgroundColor3 = Color3.fromRGB(80, 220, 130)
	PulseRing.BackgroundTransparency = 0.5
	PulseRing.ZIndex = 4
	PulseRing.Parent = StatusPill
	createCorner(PulseRing, 3)
	task.spawn(function()
		while PulseRing and PulseRing.Parent do
			PulseRing.Size = UDim2.new(0,6,0,6)
			PulseRing.Position = UDim2.new(0,10,0.5,-3)
			PulseRing.BackgroundTransparency = 0.4
			TweenService:Create(PulseRing, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0,18,0,18), Position = UDim2.new(0,4,0.5,-9), BackgroundTransparency = 1
			}):Play()
			task.wait(1.4)
		end
	end)

	local StatusLabel = Instance.new("TextLabel")
	StatusLabel.Text = "Aktif"
	StatusLabel.Font = Enum.Font.GothamMedium
	StatusLabel.TextSize = 11.5
	StatusLabel.TextColor3 = CurrentTheme.SubTextColor
	StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
	StatusLabel.Size = UDim2.new(1, -24, 1, 0)
	StatusLabel.Position = UDim2.new(0, 22, 0, 0)
	StatusLabel.BackgroundTransparency = 1
	StatusLabel.ZIndex = 4
	StatusLabel.Parent = StatusPill
	registerThemeable(StatusLabel, {TextColor3 = "SubTextColor"})

	local CreditsText = Instance.new("TextLabel")
	CreditsText.Text = "EMLOXA"
	CreditsText.Font = Enum.Font.GothamBold
	CreditsText.TextSize = 10.5
	CreditsText.TextColor3 = CurrentTheme.SubTextColor
	CreditsText.TextXAlignment = Enum.TextXAlignment.Right
	CreditsText.Size = UDim2.new(0, 70, 1, 0)
	CreditsText.Position = UDim2.new(1, -174, 0, 0)
	CreditsText.BackgroundTransparency = 1
	CreditsText.ZIndex = 4
	CreditsText.Parent = TopBar
	registerThemeable(CreditsText, {TextColor3 = "SubTextColor"})

	local Controls = Instance.new("Frame")
	Controls.Size = UDim2.new(0, 90, 1, 0)
	Controls.Position = UDim2.new(1, -98, 0, 0)
	Controls.BackgroundTransparency = 1
	Controls.ZIndex = 4
	Controls.Parent = TopBar

	local function makeControlBtn(text, posX, textSize)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0,32,0,32)
		b.Position = UDim2.new(0,posX,0.5,-16)
		b.Text = text
		b.Font = Enum.Font.GothamBold
		b.TextSize = textSize or 16
		b.TextColor3 = CurrentTheme.SubTextColor
		b.BackgroundColor3 = CurrentTheme.PanelLight
		b.AutoButtonColor = false
		b.ZIndex = 4
		b.Parent = Controls
		createCorner(b, 9)
		registerThemeable(b, {BackgroundColor3 = "PanelLight", TextColor3 = "SubTextColor"})
		return b
	end
	local MinBtn = makeControlBtn("–", 0, 18)
	local CloseBtn = makeControlBtn("✕", 50, 13)

	local function addHover(btn, hoverBg, hoverText)
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, Ease.Snap, {BackgroundColor3 = hoverBg or CurrentTheme.Primary, TextColor3 = hoverText or Color3.new(1,1,1)}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, Ease.Snap, {BackgroundColor3 = CurrentTheme.PanelLight, TextColor3 = CurrentTheme.SubTextColor}):Play()
		end)
	end
	addHover(MinBtn)
	addHover(CloseBtn, Color3.fromRGB(224, 74, 74), Color3.new(1,1,1))

	local isMinimized = false
	local function animateWindow(targetSize)
		TweenService:Create(MainFrame, Ease.Window, {Size = targetSize}):Play()
	end

	MinBtn.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		playClickSound()
		animateWindow(isMinimized and MIN_SIZE or FULL_SIZE)
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		playClickSound()
		TweenService:Create(MainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)}):Play()
		task.wait(0.28)
		MainFrame.Visible = false
		OpenIconFrame.Visible = true
		OpenIconFrame.Size = UDim2.new(0,0,0,0)
		TweenService:Create(OpenIconFrame, Ease.Spring, {Size = UDim2.new(0,50,0,50)}):Play()
	end)

	OpenClick.MouseButton1Click:Connect(function()
		playClickSound()
		TweenService:Create(OpenIconFrame, Ease.Snap, {Size = UDim2.new(0,0,0,0)}):Play()
		task.wait(0.16)
		OpenIconFrame.Visible = false
		MainFrame.Visible = true
		animateWindow(isMinimized and MIN_SIZE or FULL_SIZE)
	end)

	-- drag
	local dragging, dragStart, startPos = false, nil, nil
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = MainFrame.Position
		end
	end)
	TopBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- ── Sidebar ──
	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -TOPBAR_H)
	Sidebar.Position = UDim2.new(0,0,0,TOPBAR_H)
	Sidebar.BackgroundColor3 = CurrentTheme.Panel
	Sidebar.BackgroundTransparency = 0.4
	Sidebar.BorderSizePixel = 0
	Sidebar.Active = true
	Sidebar.Parent = MainFrame
	registerThemeable(Sidebar, {BackgroundColor3 = "Panel"})

	local sideDivider = Instance.new("Frame")
	sideDivider.Size = UDim2.new(0,1,1,0)
	sideDivider.Position = UDim2.new(1,-1,0,0)
	sideDivider.BackgroundColor3 = Color3.new(0,0,0)
	sideDivider.BackgroundTransparency = 0.55
	sideDivider.BorderSizePixel = 0
	sideDivider.Parent = Sidebar

	local TabList = Instance.new("UIListLayout")
	TabList.FillDirection = Enum.FillDirection.Vertical
	TabList.SortOrder = Enum.SortOrder.LayoutOrder
	TabList.Padding = UDim.new(0,6)
	TabList.Parent = Sidebar
	local tabPad = Instance.new("UIPadding", Sidebar)
	tabPad.PaddingTop = UDim.new(0,16)
	tabPad.PaddingLeft = UDim.new(0,12)
	tabPad.PaddingRight = UDim.new(0,12)

	local PageContainer = Instance.new("Frame")
	PageContainer.Size = UDim2.new(1, -SIDEBAR_W, 1, -TOPBAR_H)
	PageContainer.Position = UDim2.new(0,SIDEBAR_W,0,TOPBAR_H)
	PageContainer.BackgroundTransparency = 1
	PageContainer.Active = true
	PageContainer.ClipsDescendants = true
	PageContainer.Parent = MainFrame

	local Pages = {}
	local Tabs = {}

	local function CreateTabInternal(tabName, icon, layoutOrder)
		local TabSetup = {}
		icon = icon or "◆"

		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, 0, 0, 40)
		TabBtn.Text = ""
		TabBtn.BackgroundColor3 = CurrentTheme.Primary
		TabBtn.BackgroundTransparency = 1
		TabBtn.AutoButtonColor = false
		TabBtn.LayoutOrder = layoutOrder or #Tabs
		TabBtn.Parent = Sidebar
		createCorner(TabBtn, 9)
		registerThemeable(TabBtn, {BackgroundColor3 = "Primary"})

		local IconLabel = Instance.new("TextLabel")
		IconLabel.Text = icon
		IconLabel.Font = Enum.Font.GothamBold
		IconLabel.TextSize = 13
		IconLabel.TextColor3 = CurrentTheme.SubTextColor
		IconLabel.Size = UDim2.new(0, 26, 1, 0)
		IconLabel.Position = UDim2.new(0, 12, 0, 0)
		IconLabel.BackgroundTransparency = 1
		IconLabel.Parent = TabBtn
		registerThemeable(IconLabel, {TextColor3 = "SubTextColor"})

		local TabLabel = Instance.new("TextLabel")
		TabLabel.Text = tabName
		TabLabel.Font = Enum.Font.GothamMedium
		TabLabel.TextSize = 13
		TabLabel.TextColor3 = CurrentTheme.SubTextColor
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabLabel.Size = UDim2.new(1, -42, 1, 0)
		TabLabel.Position = UDim2.new(0, 38, 0, 0)
		TabLabel.BackgroundTransparency = 1
		TabLabel.Parent = TabBtn
		registerThemeable(TabLabel, {TextColor3 = "SubTextColor"})

		local PageScroll = Instance.new("ScrollingFrame")
		PageScroll.Size = UDim2.new(1,0,1,0)
		PageScroll.BackgroundTransparency = 1
		PageScroll.BorderSizePixel = 0
		PageScroll.ScrollBarThickness = 3
		PageScroll.ScrollBarImageColor3 = CurrentTheme.Primary
		PageScroll.Active = true
		PageScroll.Visible = false
		PageScroll.CanvasSize = UDim2.new(0,0,0,0)
		PageScroll.Parent = PageContainer
		registerThemeable(PageScroll, {ScrollBarImageColor3 = "Primary"})

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0,10)
		PageLayout.Parent = PageScroll
		local pad = Instance.new("UIPadding", PageScroll)
		pad.PaddingTop = UDim.new(0,18); pad.PaddingLeft = UDim.new(0,20)
		pad.PaddingRight = UDim.new(0,20); pad.PaddingBottom = UDim.new(0,18)

		local function updateCanvas()
			PageScroll.CanvasSize = UDim2.new(0,0,0,PageLayout.AbsoluteContentSize.Y + 36)
		end
		PageScroll.ChildAdded:Connect(function(child)
			if child:IsA("GuiObject") then task.wait(); updateCanvas() end
		end)
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

		local function setActive(active)
			TweenService:Create(TabBtn, Ease.Snap, {BackgroundTransparency = active and 0.88 or 1}):Play()
			TweenService:Create(IconLabel, Ease.Snap, {TextColor3 = active and Color3.new(1,1,1) or CurrentTheme.SubTextColor}):Play()
			TweenService:Create(TabLabel, Ease.Snap, {TextColor3 = active and CurrentTheme.TextColor or CurrentTheme.SubTextColor}):Play()
		end

		TabBtn.MouseEnter:Connect(function()
			if PageScroll.Visible ~= true then
				TweenService:Create(TabLabel, Ease.Snap, {TextColor3 = CurrentTheme.TextColor}):Play()
				TweenService:Create(TabBtn, Ease.Snap, {BackgroundTransparency = 0.95}):Play()
			end
		end)
		TabBtn.MouseLeave:Connect(function()
			if PageScroll.Visible ~= true then
				TweenService:Create(TabLabel, Ease.Snap, {TextColor3 = CurrentTheme.SubTextColor}):Play()
				TweenService:Create(TabBtn, Ease.Snap, {BackgroundTransparency = 1}):Play()
			end
		end)

		TabBtn.MouseButton1Click:Connect(function()
			for _,p in pairs(Pages) do p.Visible = false end
			for _,t in pairs(Tabs) do t.setActive(false) end
			PageScroll.Visible = true
			setActive(true)
			playClickSound()
		end)

		table.insert(Pages, PageScroll)
		table.insert(Tabs, {Btn = TabBtn, setActive = setActive})

		if #Pages == 1 then
			PageScroll.Visible = true
			setActive(true)
		end

		local elementCounter = 0
		local function generateId(baseName)
			elementCounter = elementCounter + 1
			return baseName .. "_" .. elementCounter
		end

		function TabSetup:CreateSection(name)
			local Holder = Instance.new("Frame")
			Holder.Size = UDim2.new(1,0,0,22)
			Holder.BackgroundTransparency = 1
			Holder.Parent = PageScroll

			local Lbl = Instance.new("TextLabel")
			Lbl.Text = string.upper(name)
			Lbl.Font = Enum.Font.GothamBold
			Lbl.TextSize = 10.5
			Lbl.TextColor3 = CurrentTheme.SubTextColor
			Lbl.TextXAlignment = Enum.TextXAlignment.Left
			Lbl.Size = UDim2.new(0,200,1,0)
			Lbl.BackgroundTransparency = 1
			Lbl.Parent = Holder
			registerThemeable(Lbl, {TextColor3 = "SubTextColor"})

			local Rule = Instance.new("Frame")
			Rule.Size = UDim2.new(1,-12,0,1)
			Rule.AnchorPoint = Vector2.new(1,0.5)
			Rule.Position = UDim2.new(1,0,0.5,0)
			Rule.BackgroundColor3 = Color3.new(1,1,1)
			Rule.BackgroundTransparency = 0.93
			Rule.BorderSizePixel = 0
			Rule.Parent = Holder
		end

		function TabSetup:CreateTextbox(name, placeholder, callback)
			local BoxFrame = Instance.new("Frame")
			BoxFrame.Size = UDim2.new(1,0,0,46)
			BoxFrame.BackgroundColor3 = CurrentTheme.PanelLight
			BoxFrame.Active = true
			BoxFrame.Parent = PageScroll
			createCorner(BoxFrame,10)
			createStroke(BoxFrame, Color3.new(1,1,1), 1, 0.93)
			registerThemeable(BoxFrame, {BackgroundColor3 = "PanelLight"})

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(0.45,0,1,0)
			Label.Position = UDim2.new(0,16,0,0)
			Label.Text = name
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 13
			Label.TextColor3 = CurrentTheme.TextColor
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.BackgroundTransparency = 1
			Label.Parent = BoxFrame
			registerThemeable(Label, {TextColor3 = "TextColor"})

			local TextBoxBg = Instance.new("Frame")
			TextBoxBg.Size = UDim2.new(0.5, 0, 0, 30)
			TextBoxBg.Position = UDim2.new(1, -14, 0.5, -15)
			TextBoxBg.AnchorPoint = Vector2.new(1, 0)
			TextBoxBg.BackgroundColor3 = CurrentTheme.Background
			TextBoxBg.Parent = BoxFrame
			createCorner(TextBoxBg, 7)
			registerThemeable(TextBoxBg, {BackgroundColor3 = "Background"})

			local TxtBox = Instance.new("TextBox")
			TxtBox.Size = UDim2.new(1, -16, 1, 0)
			TxtBox.Position = UDim2.new(0, 8, 0, 0)
			TxtBox.BackgroundTransparency = 1
			TxtBox.Text = ""
			TxtBox.PlaceholderText = placeholder or "Yaz..."
			TxtBox.PlaceholderColor3 = CurrentTheme.SubTextColor
			TxtBox.Font = Enum.Font.Gotham
			TxtBox.TextSize = 12.5
			TxtBox.TextColor3 = CurrentTheme.TextColor
			TxtBox.TextXAlignment = Enum.TextXAlignment.Left
			TxtBox.ClearTextOnFocus = false
			TxtBox.Parent = TextBoxBg
			registerThemeable(TxtBox, {TextColor3 = "TextColor"})

			TxtBox.FocusLost:Connect(function() callback(TxtBox.Text) end)
		end

		function TabSetup:CreateDropdown(name, options, default, callback)
			local id = generateId("dropdown_" .. name)
			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Size = UDim2.new(1,0,0,46)
			DropdownFrame.BackgroundColor3 = CurrentTheme.PanelLight
			DropdownFrame.Active = true
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.Parent = PageScroll
			createCorner(DropdownFrame,10)
			createStroke(DropdownFrame, Color3.new(1,1,1), 1, 0.93)
			registerThemeable(DropdownFrame, {BackgroundColor3 = "PanelLight"})

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1,-44,0,46)
			Label.Position = UDim2.new(0,16,0,0)
			Label.Text = name
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 13
			Label.TextColor3 = CurrentTheme.TextColor
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.BackgroundTransparency = 1
			Label.Parent = DropdownFrame
			registerThemeable(Label, {TextColor3 = "TextColor"})

			local ValueChip = Instance.new("Frame")
			ValueChip.Size = UDim2.new(0,0,0,22)
			ValueChip.AutomaticSize = Enum.AutomaticSize.X
			ValueChip.AnchorPoint = Vector2.new(1,0.5)
			ValueChip.Position = UDim2.new(1,-46,0.5,0)
			ValueChip.BackgroundColor3 = CurrentTheme.Background
			ValueChip.Parent = DropdownFrame
			createCorner(ValueChip, 6)
			registerThemeable(ValueChip, {BackgroundColor3 = "Background"})
			local ValueChipPad = Instance.new("UIPadding", ValueChip)
			ValueChipPad.PaddingLeft = UDim.new(0,10); ValueChipPad.PaddingRight = UDim.new(0,10)

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Text = tostring(default)
			ValueLabel.Font = Enum.Font.GothamBold
			ValueLabel.TextSize = 11.5
			ValueLabel.TextColor3 = CurrentTheme.Primary
			ValueLabel.Size = UDim2.new(0,0,1,0)
			ValueLabel.AutomaticSize = Enum.AutomaticSize.X
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Parent = ValueChip
			registerThemeable(ValueLabel, {TextColor3 = "Primary"})

			local Chevron = Instance.new("TextLabel")
			Chevron.Text = "⌄"
			Chevron.Font = Enum.Font.GothamBold
			Chevron.TextSize = 15
			Chevron.TextColor3 = CurrentTheme.SubTextColor
			Chevron.Size = UDim2.new(0,30,0,46)
			Chevron.Position = UDim2.new(1,-34,0,0)
			Chevron.BackgroundTransparency = 1
			Chevron.Parent = DropdownFrame
			registerThemeable(Chevron, {TextColor3 = "SubTextColor"})

			local ToggleBtn = Instance.new("TextButton")
			ToggleBtn.Size = UDim2.new(1,0,0,46)
			ToggleBtn.BackgroundTransparency = 1
			ToggleBtn.Text = ""
			ToggleBtn.Parent = DropdownFrame

			local OptionContainer = Instance.new("Frame")
			OptionContainer.Size = UDim2.new(1,-12,1,-52)
			OptionContainer.Position = UDim2.new(0,6,0,50)
			OptionContainer.BackgroundTransparency = 1
			OptionContainer.Parent = DropdownFrame
			local UIListLayout = Instance.new("UIListLayout", OptionContainer)
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0,3)

			local isDropped = false
			local selectedValue = default
			ConfigValues[id] = default
			registerConfig(id, function(val)
				selectedValue = val
				ValueLabel.Text = val
				callback(val)
			end)

			local function BuildOptions(optList)
				for _, child in ipairs(OptionContainer:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				for _, option in ipairs(optList) do
					local OptBtn = Instance.new("TextButton")
					OptBtn.Size = UDim2.new(1,0,0,32)
					OptBtn.BackgroundColor3 = CurrentTheme.Background
					OptBtn.Text = "  " .. option
					OptBtn.Font = Enum.Font.Gotham
					OptBtn.TextSize = 12.5
					OptBtn.TextColor3 = CurrentTheme.SubTextColor
					OptBtn.TextXAlignment = Enum.TextXAlignment.Left
					OptBtn.AutoButtonColor = false
					OptBtn.Parent = OptionContainer
					createCorner(OptBtn,7)
					registerThemeable(OptBtn, {BackgroundColor3 = "Background", TextColor3 = "SubTextColor"})

					OptBtn.MouseButton1Click:Connect(function()
						selectedValue = option
						ValueLabel.Text = option
						ConfigValues[id] = option
						isDropped = false
						TweenService:Create(DropdownFrame, Ease.Smooth, {Size = UDim2.new(1,0,0,46)}):Play()
						TweenService:Create(Chevron, Ease.Smooth, {Rotation = 0}):Play()
						callback(selectedValue)
						playClickSound()
					end)
					OptBtn.MouseEnter:Connect(function()
						TweenService:Create(OptBtn, Ease.Snap, {BackgroundColor3 = CurrentTheme.PrimaryDark, TextColor3 = Color3.new(1,1,1)}):Play()
					end)
					OptBtn.MouseLeave:Connect(function()
						TweenService:Create(OptBtn, Ease.Snap, {BackgroundColor3 = CurrentTheme.Background, TextColor3 = CurrentTheme.SubTextColor}):Play()
					end)
				end
			end
			BuildOptions(options)

			ToggleBtn.MouseButton1Click:Connect(function()
				isDropped = not isDropped
				local childCount = 0
				for _,v in pairs(OptionContainer:GetChildren()) do if v:IsA("TextButton") then childCount = childCount + 1 end end
				local targetHeight = isDropped and (52 + (childCount * 35)) or 46
				TweenService:Create(DropdownFrame, Ease.Smooth, {Size = UDim2.new(1,0,0,targetHeight)}):Play()
				TweenService:Create(Chevron, Ease.Smooth, {Rotation = isDropped and 180 or 0}):Play()
				playClickSound()
			end)

			local DropdownAPI = {}
			function DropdownAPI:Refresh(newOptions)
				BuildOptions(newOptions)
				if isDropped then
					TweenService:Create(DropdownFrame, Ease.Smooth, {Size = UDim2.new(1,0,0,52 + (#newOptions * 35))}):Play()
				end
			end
			return DropdownAPI
		end

		function TabSetup:CreateToggle(name, callback)
			local id = generateId("toggle_" .. name)
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(1,0,0,48)
			ToggleFrame.BackgroundColor3 = CurrentTheme.PanelLight
			ToggleFrame.Active = true
			ToggleFrame.Parent = PageScroll
			createCorner(ToggleFrame,10)
			createStroke(ToggleFrame, Color3.new(1,1,1), 1, 0.93)
			registerThemeable(ToggleFrame, {BackgroundColor3 = "PanelLight"})

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1,-76,1,0)
			Label.Position = UDim2.new(0,16,0,0)
			Label.Text = name
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 13
			Label.TextColor3 = CurrentTheme.TextColor
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.BackgroundTransparency = 1
			Label.Parent = ToggleFrame
			registerThemeable(Label, {TextColor3 = "TextColor"})

			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(0,44,0,24)
			Btn.Position = UDim2.new(1,-60,0.5,-12)
			Btn.BackgroundColor3 = CurrentTheme.Background
			Btn.Text = ""
			Btn.AutoButtonColor = false
			Btn.Parent = ToggleFrame
			createCorner(Btn,12)
			registerThemeable(Btn, {BackgroundColor3 = "Background"})

			local Circle = Instance.new("Frame")
			Circle.Size = UDim2.new(0,18,0,18)
			Circle.Position = UDim2.new(0,3,0.5,-9)
			Circle.BackgroundColor3 = Color3.new(1,1,1)
			Circle.Parent = Btn
			createCorner(Circle,9)

			local state = false
			ConfigValues[id] = state
			registerConfig(id, function(val)
				state = val
				local gPos = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
				local gCol = state and CurrentTheme.Primary or CurrentTheme.Background
				TweenService:Create(Circle, Ease.Smooth, {Position = gPos}):Play()
				TweenService:Create(Btn, Ease.Smooth, {BackgroundColor3 = gCol}):Play()
				callback(state)
			end)

			Btn.MouseButton1Click:Connect(function()
				state = not state
				ConfigValues[id] = state
				for _, entry in ipairs(ConfigCallbacks) do
					if entry.id == id then entry.set(state); break end
				end
				playClickSound()
			end)
		end

		function TabSetup:CreateSlider(name, min, max, default, callback)
			local id = generateId("slider_" .. name)
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1,0,0,60)
			SliderFrame.BackgroundColor3 = CurrentTheme.PanelLight
			SliderFrame.Active = true
			SliderFrame.Parent = PageScroll
			createCorner(SliderFrame,10)
			createStroke(SliderFrame, Color3.new(1,1,1), 1, 0.93)
			registerThemeable(SliderFrame, {BackgroundColor3 = "PanelLight"})

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1,-50,0,24)
			Label.Position = UDim2.new(0,16,0,8)
			Label.Text = name
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 13
			Label.TextColor3 = CurrentTheme.TextColor
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.BackgroundTransparency = 1
			Label.Parent = SliderFrame
			registerThemeable(Label, {TextColor3 = "TextColor"})

			local ValueText = Instance.new("TextLabel")
			ValueText.Size = UDim2.new(0,46,0,24)
			ValueText.Position = UDim2.new(1,-60,0,8)
			ValueText.Text = tostring(default)
			ValueText.Font = Enum.Font.GothamBold
			ValueText.TextSize = 13
			ValueText.TextColor3 = CurrentTheme.Primary
			ValueText.TextXAlignment = Enum.TextXAlignment.Right
			ValueText.BackgroundTransparency = 1
			ValueText.Parent = SliderFrame
			registerThemeable(ValueText, {TextColor3 = "Primary"})

			local Bar = Instance.new("TextButton")
			Bar.Size = UDim2.new(1,-32,0,6)
			Bar.Position = UDim2.new(0,16,0,38)
			Bar.BackgroundColor3 = CurrentTheme.Background
			Bar.Text = ""
			Bar.AutoButtonColor = false
			Bar.Parent = SliderFrame
			createCorner(Bar,3)
			registerThemeable(Bar, {BackgroundColor3 = "Background"})

			local Fill = Instance.new("Frame")
			local defaultPercent = (default - min) / (max - min)
			Fill.Size = UDim2.new(defaultPercent,0,1,0)
			Fill.BackgroundColor3 = CurrentTheme.Primary
			Fill.Parent = Bar
			createCorner(Fill,3)
			registerThemeable(Fill, {BackgroundColor3 = "Primary"})

			local Knob = Instance.new("Frame")
			Knob.Size = UDim2.new(0,14,0,14)
			Knob.Position = UDim2.new(defaultPercent, -7, 0.5, -7)
			Knob.BackgroundColor3 = Color3.new(1,1,1)
			Knob.BorderSizePixel = 0
			Knob.ZIndex = 2
			Knob.Parent = Bar
			createCorner(Knob, 7)
			createShadow(Knob, UDim2.new(1,10,1,10), -5, 0.4)

			local currentValue = default
			ConfigValues[id] = currentValue
			registerConfig(id, function(val)
				currentValue = math.clamp(val, min, max)
				local percent = (currentValue - min) / (max - min)
				Fill.Size = UDim2.new(percent,0,1,0)
				Knob.Position = UDim2.new(percent, -7, 0.5, -7)
				ValueText.Text = tostring(currentValue)
				callback(currentValue)
			end)

			local draggingSlider = false
			Bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = true
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = false
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
					currentValue = math.floor(min + ((max - min) * percent))
					ConfigValues[id] = currentValue
					Fill.Size = UDim2.new(percent,0,1,0)
					Knob.Position = UDim2.new(percent, -7, 0.5, -7)
					ValueText.Text = tostring(currentValue)
					callback(currentValue)
				end
			end)
		end

		function TabSetup:CreateButton(name, callback)
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1,0,0,42)
			Btn.BackgroundColor3 = CurrentTheme.PanelLight
			Btn.Text = name
			Btn.Font = Enum.Font.GothamMedium
			Btn.TextSize = 13
			Btn.TextColor3 = CurrentTheme.TextColor
			Btn.AutoButtonColor = false
			Btn.Active = true
			Btn.Parent = PageScroll
			createCorner(Btn,10)
			createStroke(Btn, Color3.new(1,1,1), 1, 0.93)
			registerThemeable(Btn, {BackgroundColor3 = "PanelLight", TextColor3 = "TextColor"})

			Btn.MouseButton1Click:Connect(function()
				TweenService:Create(Btn, Ease.Snap, {BackgroundColor3 = CurrentTheme.Primary}):Play()
				task.wait(0.12)
				TweenService:Create(Btn, Ease.Smooth, {BackgroundColor3 = CurrentTheme.PanelLight}):Play()
				playClickSound()
				callback()
			end)
			Btn.MouseEnter:Connect(function()
				TweenService:Create(Btn, Ease.Snap, {BackgroundColor3 = CurrentTheme.PrimaryDark}):Play()
			end)
			Btn.MouseLeave:Connect(function()
				TweenService:Create(Btn, Ease.Snap, {BackgroundColor3 = CurrentTheme.PanelLight}):Play()
			end)
		end

		function TabSetup:CreateDivider()
			local Div = Instance.new("Frame")
			Div.Size = UDim2.new(1, 0, 0, 1)
			Div.BackgroundColor3 = Color3.new(1,1,1)
			Div.BackgroundTransparency = 0.93
			Div.BorderSizePixel = 0
			Div.Parent = PageScroll
		end

		function TabSetup:CreateNotification(title, message, duration)
			duration = duration or 2.2
			local Notif = Instance.new("Frame")
			Notif.Size = UDim2.new(0, 270, 0, 72)
			Notif.Position = UDim2.new(1, 10, 1, -90)
			Notif.BackgroundColor3 = CurrentTheme.Panel
			Notif.Active = true
			Notif.Parent = HubGui
			createCorner(Notif,12)
			createStroke(Notif, CurrentTheme.Primary, 1, 0.4)
			createShadow(Notif, UDim2.new(1,18,1,18), -9, 0.55)
			registerThemeable(Notif, {BackgroundColor3 = "Panel"})

			local AccentBar = Instance.new("Frame")
			AccentBar.Size = UDim2.new(0,3,1,-16)
			AccentBar.Position = UDim2.new(0,0,0,8)
			AccentBar.BackgroundColor3 = CurrentTheme.Primary
			AccentBar.Parent = Notif
			createCorner(AccentBar, 2)
			registerThemeable(AccentBar, {BackgroundColor3 = "Primary"})

			local TitleLabel = Instance.new("TextLabel")
			TitleLabel.Text = title
			TitleLabel.Font = Enum.Font.GothamBold
			TitleLabel.TextSize = 14
			TitleLabel.TextColor3 = CurrentTheme.TextColor
			TitleLabel.Size = UDim2.new(1,-28,0,20)
			TitleLabel.Position = UDim2.new(0,16,0,10)
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			TitleLabel.Parent = Notif
			registerThemeable(TitleLabel, {TextColor3 = "TextColor"})

			local MsgLabel = Instance.new("TextLabel")
			MsgLabel.Text = message
			MsgLabel.Font = Enum.Font.Gotham
			MsgLabel.TextSize = 12
			MsgLabel.TextColor3 = CurrentTheme.SubTextColor
			MsgLabel.Size = UDim2.new(1,-28,0,32)
			MsgLabel.Position = UDim2.new(0,16,0,32)
			MsgLabel.BackgroundTransparency = 1
			MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
			MsgLabel.TextWrapped = true
			MsgLabel.Parent = Notif
			registerThemeable(MsgLabel, {TextColor3 = "SubTextColor"})

			TweenService:Create(Notif, Ease.Spring, {Position = UDim2.new(1,-282,1,-90)}):Play()
			task.wait(duration)
			TweenService:Create(Notif, Ease.Fade, {Position = UDim2.new(1,10,1,-90)}):Play()
			task.wait(0.4)
			Notif:Destroy()
		end

		return TabSetup
	end

	-- ════════ Menu Tab ════════
	local MenuTab = CreateTabInternal("Menü", "⚙", 9999)

	MenuTab:CreateSection("Görünüm")
	MenuTab:CreateDropdown("Tema", EmloxaLibrary:GetThemeNames(), "Default", function(val)
		EmloxaLibrary:SetTheme(val)
	end)

	MenuTab:CreateSection("Yapılandırma")

	local ConfigNameInput = ""
	local SelectedConfig = "Config bulunamadı"

	MenuTab:CreateTextbox("Config Adı", "Yeni config adı...", function(val)
		ConfigNameInput = val
	end)

	local ConfigDropdown
	ConfigDropdown = MenuTab:CreateDropdown("Kayıtlı Configler", GetSavedConfigs(), GetSavedConfigs()[1], function(val)
		SelectedConfig = val
	end)

	MenuTab:CreateButton("Kaydet", function()
		if ConfigNameInput == "" then
			MenuTab:CreateNotification("Hata", "Önce bir config adı girin.", 2)
			return
		end
		local data = {}
		for _, entry in ipairs(ConfigCallbacks) do data[entry.id] = ConfigValues[entry.id] end
		local success = pcall(function()
			writefile(ConfigFolder .. "/" .. ConfigNameInput .. ".json", HttpService:JSONEncode(data))
		end)
		if success then
			MenuTab:CreateNotification("Kaydedildi", ConfigNameInput .. " olarak kaydedildi.", 2)
			if ConfigDropdown then ConfigDropdown:Refresh(GetSavedConfigs()) end
		else
			MenuTab:CreateNotification("Hata", "Config kaydedilemedi.", 2)
		end
	end)

	MenuTab:CreateButton("Yükle", function()
		if SelectedConfig == "" or SelectedConfig == "Config bulunamadı" then return end
		local path = ConfigFolder .. "/" .. SelectedConfig .. ".json"
		if isfile(path) then
			local success, json = pcall(readfile, path)
			if success then
				local decodeSuccess, data = pcall(HttpService.JSONDecode, HttpService, json)
				if decodeSuccess then
					for id, value in pairs(data) do ConfigValues[id] = value end
					for _, entry in ipairs(ConfigCallbacks) do
						if ConfigValues[entry.id] ~= nil then entry.set(ConfigValues[entry.id]) end
					end
					MenuTab:CreateNotification("Yüklendi", SelectedConfig .. " yüklendi.", 2)
				end
			end
		else
			MenuTab:CreateNotification("Hata", "Config dosyası bulunamadı.", 2)
		end
	end)

	MenuTab:CreateButton("Sil", function()
		if SelectedConfig == "" or SelectedConfig == "Config bulunamadı" then return end
		local path = ConfigFolder .. "/" .. SelectedConfig .. ".json"
		if isfile(path) then
			delfile(path)
			MenuTab:CreateNotification("Silindi", SelectedConfig .. " kaldırıldı.", 2)
			if ConfigDropdown then ConfigDropdown:Refresh(GetSavedConfigs()) end
		else
			MenuTab:CreateNotification("Hata", "Dosya mevcut değil.", 2)
		end
	end)

	function WindowSetup:CreateTab(tabName, icon)
		return CreateTabInternal(tabName, icon, #Tabs + 1)
	end

	-- ════════ Şeffaf analitik izin paneli ════════
	local function ShowConsentPanel()
		local existing = ReadConsentPref()
		if existing ~= nil then
			if existing == true then task.spawn(SendUsageLog) end
			return
		end

		local PromptFrame = Instance.new("Frame")
		PromptFrame.Size = UDim2.new(0, 340, 0, 170)
		PromptFrame.Position = UDim2.new(1, 20, 1, -190)
		PromptFrame.BackgroundColor3 = CurrentTheme.Panel
		PromptFrame.Active = true
		PromptFrame.Parent = HubGui
		createCorner(PromptFrame, 14)
		createStroke(PromptFrame, CurrentTheme.Primary, 1, 0.4)
		createShadow(PromptFrame, UDim2.new(1,22,1,22), -11, 0.5)
		registerThemeable(PromptFrame, {BackgroundColor3 = "Panel"})

		local IconBadge = Instance.new("Frame")
		IconBadge.Size = UDim2.new(0,34,0,34)
		IconBadge.Position = UDim2.new(0,16,0,14)
		IconBadge.BackgroundColor3 = CurrentTheme.Background
		IconBadge.Parent = PromptFrame
		createCorner(IconBadge, 10)
		registerThemeable(IconBadge, {BackgroundColor3 = "Background"})

		local IconText = Instance.new("TextLabel")
		IconText.Text = "📊"
		IconText.Font = Enum.Font.Gotham
		IconText.TextSize = 16
		IconText.Size = UDim2.new(1,0,1,0)
		IconText.BackgroundTransparency = 1
		IconText.Parent = IconBadge

		local PTitle = Instance.new("TextLabel")
		PTitle.Text = "Kullanım Verisi İzni"
		PTitle.Font = Enum.Font.GothamBold; PTitle.TextSize = 15
		PTitle.TextColor3 = CurrentTheme.TextColor
		PTitle.Size = UDim2.new(1,-66,0,20); PTitle.Position = UDim2.new(0,60,0,18)
		PTitle.BackgroundTransparency = 1; PTitle.TextXAlignment = Enum.TextXAlignment.Left
		PTitle.Parent = PromptFrame
		registerThemeable(PTitle, {TextColor3 = "TextColor"})

		local PDesc = Instance.new("TextLabel")
		PDesc.Text = "Aktif kullanıcı sayısını görüp performansı buna göre ayarlamamıza yardımcı olmak için kullanıcı adın, hesap bilgilerin ve cihaz türün anonim olarak Discord sunucumuza gönderilsin mi? İstersen reddedebilirsin, hub yine tam çalışır."
		PDesc.Font = Enum.Font.Gotham; PDesc.TextSize = 11.5
		PDesc.TextColor3 = CurrentTheme.SubTextColor
		PDesc.Size = UDim2.new(1,-32,0,62); PDesc.Position = UDim2.new(0,16,0,54)
		PDesc.BackgroundTransparency = 1; PDesc.TextXAlignment = Enum.TextXAlignment.Left
		PDesc.TextWrapped = true; PDesc.Parent = PromptFrame
		registerThemeable(PDesc, {TextColor3 = "SubTextColor"})

		local BtnYes = Instance.new("TextButton")
		BtnYes.Size = UDim2.new(0,150,0,34); BtnYes.Position = UDim2.new(0,16,1,-50)
		BtnYes.BackgroundColor3 = CurrentTheme.Primary; BtnYes.Text = "İzin Ver"
		BtnYes.Font = Enum.Font.GothamBold; BtnYes.TextColor3 = Color3.new(1,1,1); BtnYes.TextSize = 13
		BtnYes.AutoButtonColor = false
		BtnYes.Parent = PromptFrame; createCorner(BtnYes,9)
		registerThemeable(BtnYes, {BackgroundColor3 = "Primary"})

		local BtnNo = Instance.new("TextButton")
		BtnNo.Size = UDim2.new(0,150,0,34); BtnNo.Position = UDim2.new(1,-166,1,-50)
		BtnNo.BackgroundColor3 = CurrentTheme.PanelLight; BtnNo.Text = "İstemiyorum"
		BtnNo.Font = Enum.Font.GothamMedium; BtnNo.TextColor3 = CurrentTheme.SubTextColor; BtnNo.TextSize = 13
		BtnNo.AutoButtonColor = false
		BtnNo.Parent = PromptFrame; createCorner(BtnNo,9)
		registerThemeable(BtnNo, {BackgroundColor3 = "PanelLight", TextColor3 = "SubTextColor"})

		TweenService:Create(PromptFrame, Ease.Window, {Position = UDim2.new(1,-356,1,-190)}):Play()

		local function ClosePrompt()
			TweenService:Create(PromptFrame, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1,20,1,-190)}):Play()
			task.wait(0.32)
			PromptFrame:Destroy()
		end

		BtnYes.MouseEnter:Connect(function() TweenService:Create(BtnYes, Ease.Snap, {BackgroundColor3 = CurrentTheme.PrimaryDark}):Play() end)
		BtnYes.MouseLeave:Connect(function() TweenService:Create(BtnYes, Ease.Snap, {BackgroundColor3 = CurrentTheme.Primary}):Play() end)
		BtnNo.MouseEnter:Connect(function() TweenService:Create(BtnNo, Ease.Snap, {TextColor3 = CurrentTheme.TextColor}):Play() end)
		BtnNo.MouseLeave:Connect(function() TweenService:Create(BtnNo, Ease.Snap, {TextColor3 = CurrentTheme.SubTextColor}):Play() end)

		BtnYes.MouseButton1Click:Connect(function()
			playClickSound()
			WriteConsentPref(true)
			task.spawn(SendUsageLog)
			BtnYes.Text = "Teşekkürler!"
			TweenService:Create(BtnYes, Ease.Snap, {BackgroundColor3 = Color3.fromRGB(64,194,114)}):Play()
			task.wait(0.8)
			ClosePrompt()
		end)
		BtnNo.MouseButton1Click:Connect(function()
			playClickSound()
			WriteConsentPref(false)
			ClosePrompt()
		end)
	end

	-- Geriye uyumluluk: iki isimle de erişilebilir
	WindowSetup.ShowDiscordPrompt = ShowConsentPanel
	WindowSetup.ShowAnalyticsConsent = ShowConsentPanel

	-- Pencereyi akıcı şekilde göster
	MainFrame.Visible = true
	MainFrame.Size = UDim2.new(0, 0, 0, 0)
	task.defer(function()
		animateWindow(FULL_SIZE)
	end)

	return WindowSetup
end

return EmloxaLibrary
