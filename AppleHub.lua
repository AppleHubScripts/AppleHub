--// Apple Hub v20 | Blox Fruits | Delta Executor (mobile + PC)
if getgenv and getgenv().AppleHubUnload then pcall(getgenv().AppleHubUnload) end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TPS = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RepStorage = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")
local VIM
pcall(function() VIM = game:GetService("VirtualInputManager") end)
local WHITE = Color3.new(1, 1, 1)

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local startTick = tick()
local alive = true
local conns = {}
local function conn(c) table.insert(conns, c) return c end
local Perf = {frames = 0, fps = 0, samples = {}}

local parent = (gethui and gethui()) or game:GetService("CoreGui")
pcall(function() local o = parent:FindFirstChild("AppleHub") if o then o:Destroy() end end)
pcall(function() local o = Lighting:FindFirstChild("AppleHubBlur") if o then o:Destroy() end end)

------------------------------------------------------------------
-- ESTADO + CONFIG SALVA
------------------------------------------------------------------
local State = {
	Shown = false,
	Theme = "Midnight", PanelFont = "Gotham", GameFont = "Padrão", TextScale = 100,
	PanelW = 640, PanelH = 420, Opacity = 0, Corner = 16, Glow = 10, Borders = true, AnimGlow = false,
	TopLine = true, TopLineH = 3, Blur = false, BlurSize = 14, OpenAnim = "Pop", ToggleKey = "RightShift",
	Title = "Apple Hub  •  v20", R = 10, G = 132, B = 255, Rainbow = false,
	Transition = "Deslizar", Easing = "Quint", TransTime = 420,
	BubbleSize = 52, BubbleIcon = "A", BubblePulse = true, Streamer = false,
	PartOn = true, PartShape = "Neve", PartCount = 36, PartSpeed = 60, PartSize = 6, PartAlpha = 55, PartWind = 12,
	PartSway = 14, PartDir = "Cair", PartColor = "Branco", PartFront = false, PartSpin = true, PR = 255, PG = 255, PB = 255,
	TouchParticles = true, PartRepel = 90,
	BtnStyle = "Gradiente", BtnHeight = 42, BtnCorner = 13, BtnGloss = true, BtnRipple = true, BtnColorMode = "Tema", BR = 10, BG = 132, BB = 255,
	TabStyle = "Pílula", TabHeight = 26, SideWidth = 132, TabSide = "Esquerda", TabIcons = true, TabNames = true, TabFont = 12, ShowChip = true, TabOrder = {},
	IntroOn = true, IntroStyle = "Cinemática", IntroSpeed = 100, IntroTitle = "APPLE HUB", IntroSub = "Blox Fruits  •  v20", IntroGreeting = true,
	IntroLogo = "A", IntroLoading = true, IntroBurst = true, IntroBlur = true,
	W_Perf = true, W_Level = true, W_Beli = false, W_Session = false, W_Quest = false, W_Fruit = false, W_Clock = false,
	WScale = 100, WAlpha = 25, WLock = false, WPos = {}, Quick = false, Floats = {}, FloatPick = "",
	Cross = false, CrossStyle = "Cruz", CrossSize = 14, CrossThick = 2, CrossGap = 4, CrossColor = "Branco",
	Places = {},
	TodOn = false, TodNight = "Midnight", TodMorning = "Aurora", TodAfternoon = "Ocean", TodEvening = "Sunset",
	SchCodes = false, SchCodesMin = 60, SchHop = false, SchHopMin = 30, SchReset = false, SchResetMin = 45,
	SchRemind = false, SchRemindMin = 20, SchClock = "", Profiles = {}, Assist = true,
	AutoLevel = false, Farm = false, Weapon = "Melee", Height = 8, Click = false, ClickDelay = 80, AutoEquip = true,
	TravelSpeed = 260, AutoBoss = false, Boss = "Saber Expert", AutoElite = false, Chest = false, FruitGrab = false,
	SkillZ = false, SkillX = false, SkillC = false, SkillV = false, SkillF = false, SkillDelay = 600,
	Hitbox = false, HitboxSize = 20,
	Buso = false, Ken = false, Stat = "Melee", StatPoints = 1, AutoStats = false, AutoCodes = false, Zone = "",
	AutoStore = false, AutoRandom = false, FruitNotify = true, FruitHop = false,
	ESPPlayers = false, ESPFruits = false, ESPChests = false, Fullbright = false, NoFog = false, FOV = 70, Clock = 14,
	SpeedOn = false, Speed = 50, JumpOn = false, Jump = 80, Fly = false, FlySpeed = 60,
	Noclip = false, InfJump = false, Gravity = 196, Water = false, AutoRejoin = false, FPSCap = 60,
}
local CFG_FILE = "AppleHub_v20.json"
local SAVE_KEYS = {"Theme", "PanelFont", "GameFont", "TextScale", "PanelW", "PanelH", "Opacity", "Corner", "Glow", "Borders", "AnimGlow",
	"TopLine", "TopLineH", "Blur", "BlurSize", "OpenAnim", "ToggleKey", "Title", "R", "G", "B", "Rainbow", "Transition", "Easing", "TransTime",
	"BubbleSize", "BubbleIcon", "BubblePulse", "Streamer", "PartOn", "PartShape", "PartCount", "PartSpeed", "PartSize", "PartAlpha", "PartWind",
	"PartSway", "PartDir", "PartColor", "PartFront", "PartSpin", "PR", "PG", "PB", "TouchParticles", "PartRepel", "BtnStyle", "BtnHeight",
	"BtnCorner", "BtnGloss", "BtnRipple", "BtnColorMode", "BR", "BG", "BB", "TabStyle", "TabHeight", "SideWidth", "TabSide", "TabIcons",
	"TabNames", "TabFont", "ShowChip", "TabOrder", "IntroOn", "IntroStyle", "IntroSpeed", "IntroTitle", "IntroSub", "IntroGreeting",
	"IntroLogo", "IntroLoading", "IntroBurst", "IntroBlur", "ScalePct", "W_Perf", "W_Level", "W_Beli", "W_Session", "W_Quest", "W_Fruit",
	"W_Clock", "WScale", "WAlpha", "WLock", "WPos", "Quick", "Floats", "Cross", "CrossStyle", "CrossSize", "CrossThick", "CrossGap",
	"CrossColor", "Places", "TodOn", "TodNight", "TodMorning", "TodAfternoon", "TodEvening", "SchCodes", "SchCodesMin", "SchHop",
	"SchHopMin", "SchReset", "SchResetMin", "SchRemind", "SchRemindMin", "SchClock", "Profiles", "Assist", "Weapon", "Height",
	"ClickDelay", "TravelSpeed", "Boss", "Stat", "StatPoints", "AutoCodes", "AutoRejoin", "SkillDelay", "HitboxSize", "FruitNotify"}
local PROFILE_KEYS = {"AutoLevel", "Farm", "AutoBoss", "AutoElite", "Click", "Chest", "FruitGrab", "Buso", "Ken", "AutoStats", "AutoEquip",
	"ESPPlayers", "ESPFruits", "ESPChests", "Fullbright", "NoFog", "SpeedOn", "JumpOn", "Fly", "Noclip", "InfJump", "Water", "AutoRejoin",
	"FruitNotify", "FruitHop", "AutoStore", "AutoRandom", "SkillZ", "SkillX", "SkillC", "SkillV", "SkillF", "Hitbox", "Weapon", "Stat"}
pcall(function()
	if isfile and isfile(CFG_FILE) then
		local d = HttpService:JSONDecode(readfile(CFG_FILE))
		for _, k in ipairs(SAVE_KEYS) do if d[k] ~= nil then State[k] = d[k] end end
	end
end)

------------------------------------------------------------------
-- TEMAS
------------------------------------------------------------------
local Themes = (function()
	local function th(bg, side, row, text, sub, a1, a2)
		local f = Color3.fromHex
		return {bg = f(bg), side = f(side), row = f(row), text = f(text), sub = f(sub), accent = f(a1), accent2 = f(a2)}
	end
	return {
		Midnight = th("#121218", "#1c1c24", "#282832", "#f5f5f7", "#9696a5", "#0a84ff", "#5e5ce6"),
		Ocean = th("#07131f", "#0b1f30", "#133046", "#ebf8ff", "#82aac3", "#00c8ff", "#006eff"),
		Sunset = th("#1c0f14", "#2a161d", "#3c2028", "#fff2ee", "#be9696", "#ff7d46", "#ff3264"),
		Aurora = th("#0b1816", "#112622", "#1b3832", "#ecfff9", "#82b4a5", "#34e6a0", "#5a78ff"),
		Sakura = th("#1e131c", "#2c1c29", "#3e2638", "#fff0f9", "#c396b4", "#ff78be", "#b96eff"),
		Gold = th("#18140c", "#241e10", "#362d18", "#fff7e4", "#beaa78", "#ffc43c", "#ff871e"),
		Graphite = th("#1c1c1c", "#262626", "#363636", "#f5f5f5", "#969696", "#d2d2d7", "#7d7d8c"),
		Claro = th("#f2f2f7", "#e5e5ea", "#ffffff", "#1c1c1e", "#6e6e78", "#0a84ff", "#5ac8fa"),
		Dracula = th("#191a21", "#21222c", "#2d2f3d", "#f8f8f2", "#8b93b8", "#bd93f9", "#ff79c6"),
		Nord = th("#1e222a", "#272c36", "#333a47", "#eceff4", "#8f9bb3", "#88c0d0", "#81a1c1"),
		Cyberpunk = th("#0d0221", "#170338", "#261047", "#f0e6ff", "#9a86c9", "#ff2a6d", "#05d9e8"),
		Matrix = th("#020a04", "#06150a", "#0c2614", "#d6ffe0", "#5fa575", "#00ff6a", "#00b34a"),
		Lava = th("#1a0a05", "#2a0f07", "#40170b", "#fff0e6", "#c28a70", "#ff4500", "#ffb300"),
		Royal = th("#0c0a1f", "#14123a", "#1f1c55", "#eeeaff", "#8d89c9", "#7c5cff", "#4a6bff"),
		Galaxy = th("#070514", "#0e0a26", "#1a1440", "#efeaff", "#8f86c4", "#9d4edd", "#3a86ff"),
		Synthwave = th("#120a24", "#1c1038", "#2c1a52", "#fff0ff", "#a98ccf", "#ff00a0", "#00cfff"),
	}
end)()
Themes.Custom = {}
for k, v in pairs(Themes.Midnight) do Themes.Custom[k] = v end
local function updateCustom()
	local a = Color3.fromRGB(State.R, State.G, State.B)
	Themes.Custom.accent = a
	Themes.Custom.accent2 = a:Lerp(Color3.fromRGB(255, 80, 200), 0.45)
end
updateCustom()
local ThemeNames = {"Midnight", "Ocean", "Sunset", "Aurora", "Sakura", "Gold", "Graphite", "Claro", "Dracula", "Nord", "Cyberpunk",
	"Matrix", "Lava", "Royal", "Galaxy", "Synthwave", "Custom"}
local T = Themes[State.Theme] or Themes.Midnight

------------------------------------------------------------------
-- FONTES / EASING
------------------------------------------------------------------
local FontOrder = {"Gotham", "GothamMedium", "SourceSans", "Arial", "Roboto", "Ubuntu", "Nunito", "Oswald", "Jura", "Michroma",
	"FredokaOne", "Merriweather", "Code", "SciFi", "Bangers"}
local getFont
do
	local BoldMap = {Gotham = "GothamBold", GothamMedium = "GothamBold", SourceSans = "SourceSansBold", Arial = "ArialBold"}
	getFont = function(name, bold)
		local en = (bold and BoldMap[name]) or name
		local ok, f = pcall(function() return Enum.Font[en] end)
		return (ok and f) or Enum.Font.Gotham
	end
end
local EasingList = {"Quint", "Back", "Elastic", "Bounce", "Sine", "Quad", "Cubic", "Exponential", "Linear"}
local TransList = {"Deslizar", "Subir", "Fade", "Zoom", "Pop", "Girar", "Nenhuma"}
local function ease()
	local ok, e = pcall(function() return Enum.EasingStyle[State.Easing] end)
	return (ok and e) or Enum.EasingStyle.Quint
end

------------------------------------------------------------------
-- HELPERS
------------------------------------------------------------------
local function new(class, props, kids)
	local o = Instance.new(class)
	for k, v in pairs(props) do if k ~= "Parent" then o[k] = v end end
	for _, k in ipairs(kids or {}) do k.Parent = o end
	if props.Parent then o.Parent = props.Parent end
	return o
end
local function corner(r) return new("UICorner", {CornerRadius = UDim.new(0, r)}) end
local function tween(o, t, p, style)
	pcall(function() TS:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p):Play() end)
end

local rc, setCorners
do
	local list = {}
	rc = function(base)
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, math.floor(base * State.Corner / 16 + 0.5))
		table.insert(list, {c, base})
		return c
	end
	setCorners = function()
		for _, e in ipairs(list) do
			pcall(function() e[1].CornerRadius = UDim.new(0, math.floor(e[2] * State.Corner / 16 + 0.5)) end)
		end
	end
end

local binders, fastBinders, fontObjs, tabRefresh, ctl = {}, {}, {}, {}, {}
local Registry, RegByKey = {}, {}
local refreshThemeCards
local function bind(obj, prop, key, fast)
	local function f(d)
		local v = type(key) == "function" and key() or T[key]
		pcall(function()
			if d and d > 0 and typeof(v) ~= "ColorSequence" then tween(obj, d, {[prop] = v}) else obj[prop] = v end
		end)
	end
	table.insert(binders, f)
	if fast or key == "accent" or key == "accent2" then table.insert(fastBinders, f) end
	f(0)
	return f
end
local function applyTheme(name)
	if not Themes[name] then return end
	T = Themes[name]
	State.Theme = name
	for _, f in ipairs(binders) do f(0.4) end
	if refreshThemeCards then refreshThemeCards() end
end
local function offColor() return T.row:Lerp(T.sub, 0.4) end

local glass, setBorders
do
	local list = {}
	glass = function(obj, tr)
		local s = new("UIStroke", {Thickness = 1, Transparency = tr or 0.9, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = State.Borders, Parent = obj})
		bind(s, "Color", "text")
		table.insert(list, s)
		return s
	end
	setBorders = function()
		for _, s in ipairs(list) do pcall(function() s.Enabled = State.Borders end) end
	end
end

local function regFont(o, bold)
	table.insert(fontObjs, {o, bold, o.TextSize})
	o.Font = getFont(State.PanelFont, bold)
	if State.TextScale ~= 100 then o.TextSize = math.max(8, math.floor(o.TextSize * State.TextScale / 100 + 0.5)) end
end
local function setPanelFont(name)
	State.PanelFont = name
	for _, e in ipairs(fontObjs) do pcall(function() e[1].Font = getFont(name, e[2]) end) end
end
local function setTextScale()
	for _, e in ipairs(fontObjs) do
		pcall(function() e[1].TextSize = math.max(8, math.floor(e[3] * State.TextScale / 100 + 0.5)) end)
	end
end
-- colorKey: string = tema | false = cor fixa
local function mkText(props, bold, colorKey, class)
	props.BackgroundTransparency = 1
	if colorKey == nil then colorKey = "text" end
	if colorKey then props.TextColor3 = T[colorKey] end
	local o = new(class or "TextLabel", props)
	regFont(o, bold)
	if colorKey then bind(o, "TextColor3", colorKey) end
	return o
end
local function getPing()
	local ok, v = pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
	return ok and math.floor(v) or 0
end
local function fmtTime(s)
	return string.format("%02d:%02d:%02d", math.floor(s / 3600), math.floor(s % 3600 / 60), math.floor(s % 60))
end
local function greeting()
	local h = tonumber(os.date("%H")) or 12
	return (h < 6 and "Boa madrugada") or (h < 12 and "Bom dia") or (h < 18 and "Boa tarde") or "Boa noite"
end

-- modo streamer (esconde seu nome)
local Streamer = {list = {}}
function Streamer.add(lbl, real, fake)
	table.insert(Streamer.list, {lbl, real, fake})
	lbl.Text = State.Streamer and fake or real
end
function Streamer.apply()
	for _, e in ipairs(Streamer.list) do e[1].Text = State.Streamer and e[3] or e[2] end
end

------------------------------------------------------------------
-- GUI BASE
------------------------------------------------------------------
local gui = new("ScreenGui", {Name = "AppleHub", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
gui.Parent = parent

local function autoScale()
	local vp = cam.ViewportSize
	return math.clamp(math.floor(math.min(vp.X / 680, vp.Y / 450) * 100) / 100, 0.5, 1)
end
if not State.ScalePct then State.ScalePct = math.floor(autoScale() * 100) end
State.Scale = State.ScalePct / 100

local main = new("CanvasGroup", {
	Name = "Main", Size = UDim2.fromOffset(State.PanelW, State.PanelH), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
	BackgroundColor3 = T.bg, BackgroundTransparency = State.Opacity / 100, BorderSizePixel = 0, GroupTransparency = 1, Visible = false, Parent = gui,
}, {rc(22)})
bind(main, "BackgroundColor3", "bg")
local uiscale = new("UIScale", {Scale = State.Scale * 0.88, Parent = main})
glass(main, 0.82)

local glow = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BackgroundTransparency = 1 - State.Glow / 100, BorderSizePixel = 0, ZIndex = 0, Parent = main})
local glowG = new("UIGradient", {Rotation = 35, Parent = glow})
bind(glowG, "Color", function() return ColorSequence.new(T.accent, T.accent2) end, true)

local pLayer = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 0, ClipsDescendants = true, Parent = main})

local topLine = new("Frame", {Size = UDim2.new(1, 0, 0, State.TopLineH), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 5, Parent = main})
bind(new("UIGradient", {Parent = topLine}), "Color", function() return ColorSequence.new(T.accent, T.accent2) end, true)

local blur = new("BlurEffect", {Name = "AppleHubBlur", Size = 0, Parent = Lighting})
local function updateBlur()
	tween(blur, 0.4, {Size = (State.Blur and State.Shown) and State.BlurSize or 0})
end

-- mira (crosshair)
local crossF = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(120, 120), BackgroundTransparency = 1, Visible = false, ZIndex = 20, Parent = gui})
local function buildCross()
	for _, ch in ipairs(crossF:GetChildren()) do ch:Destroy() end
	crossF.Visible = State.Cross
	if not State.Cross then return end
	local c = WHITE
	local cc = State.CrossColor
	if cc == "Tema" then c = T.accent
	elseif cc == "Vermelho" then c = Color3.fromRGB(255, 60, 60)
	elseif cc == "Verde" then c = Color3.fromRGB(70, 255, 120)
	elseif cc == "Ciano" then c = Color3.fromRGB(70, 230, 255) end
	local s, t, g, st = State.CrossSize, State.CrossThick, State.CrossGap, State.CrossStyle
	local function bar(x, y, w, h)
		new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, x, 0.5, y), Size = UDim2.fromOffset(w, h), BackgroundColor3 = c, BorderSizePixel = 0, ZIndex = 20, Parent = crossF})
	end
	if st == "Cruz" or st == "Cruz + Ponto" then
		bar(0, -(g + s / 2), t, s); bar(0, g + s / 2, t, s); bar(-(g + s / 2), 0, s, t); bar(g + s / 2, 0, s, t)
	end
	if st == "Ponto" or st == "Cruz + Ponto" then
		new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(t + 2, t + 2), BackgroundColor3 = c, BorderSizePixel = 0, ZIndex = 20, Parent = crossF},
			{new("UICorner", {CornerRadius = UDim.new(1, 0)})})
	end
	if st == "Círculo" then
		new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(s * 2 + g, s * 2 + g), BackgroundTransparency = 1, ZIndex = 20, Parent = crossF},
			{new("UICorner", {CornerRadius = UDim.new(1, 0)}), new("UIStroke", {Color = c, Thickness = t, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})})
	end
end
table.insert(binders, function() if State.CrossColor == "Tema" then buildCross() end end)

-- notificações (com histórico)
local NotifyLog = {}
local notifHolder = new("Frame", {Size = UDim2.new(0, 260, 1, -20), Position = UDim2.new(1, -270, 0, 10), BackgroundTransparency = 1, Parent = gui},
	{new("UIListLayout", {VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder})})
local function notify(title, msg, dur)
	table.insert(NotifyLog, os.date("%H:%M") .. "  " .. title .. ": " .. msg)
	while #NotifyLog > 30 do table.remove(NotifyLog, 1) end
	local f = new("CanvasGroup", {Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = T.row, GroupTransparency = 1, Parent = notifHolder}, {rc(14)})
	bind(f, "BackgroundColor3", "row")
	local bar = new("Frame", {Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = T.accent, BorderSizePixel = 0, Parent = f})
	bind(bar, "BackgroundColor3", "accent")
	mkText({Size = UDim2.new(1, -20, 0, 20), Position = UDim2.fromOffset(14, 6), Text = title, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = f}, true)
	mkText({Size = UDim2.new(1, -20, 0, 22), Position = UDim2.fromOffset(14, 26), Text = msg, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f}, false, "sub")
	tween(f, 0.35, {GroupTransparency = 0})
	task.delay(dur or 3, function()
		tween(f, 0.35, {GroupTransparency = 1})
		task.wait(0.4)
		pcall(function() f:Destroy() end)
	end)
end

-- barra de título
local top = new("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = main})
local red, yellow
do
	local function dot(x, color)
		return new("TextButton", {Size = UDim2.fromOffset(13, 13), Position = UDim2.fromOffset(x, 15), BackgroundColor3 = color, Text = "", AutoButtonColor = false, Parent = top}, {corner(7)})
	end
	red = dot(16, Color3.fromRGB(255, 95, 87))
	yellow = dot(36, Color3.fromRGB(254, 188, 46))
	dot(56, Color3.fromRGB(40, 200, 64))
end
local titleLabel = mkText({Size = UDim2.new(1, 0, 1, 0), Text = State.Title, TextSize = 13, Parent = top}, true, "sub")
local chipLabel = mkText({Size = UDim2.fromOffset(130, 40), Position = UDim2.new(1, -142, 0, 0), Text = "-- FPS", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, Parent = top}, true, "accent")

-- bolha (minimizado) com pulso
local bubble = new("TextButton", {Size = UDim2.fromOffset(State.BubbleSize, State.BubbleSize), Position = UDim2.new(0, 16, 0.4, 0), BackgroundColor3 = WHITE, Text = "", Visible = false, AutoButtonColor = false, Parent = gui},
	{new("UICorner", {CornerRadius = UDim.new(0.5, 0)})})
bind(new("UIGradient", {Rotation = 45, Parent = bubble}), "Color", function() return ColorSequence.new(T.accent, T.accent2) end, true)
local bubbleLbl = new("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = State.BubbleIcon, Font = Enum.Font.GothamBold, TextSize = 24, TextColor3 = WHITE, Parent = bubble})
new("UIStroke", {Color = WHITE, Transparency = 0.55, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = bubble})
do
	local pulse = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 0, Parent = bubble},
		{new("UICorner", {CornerRadius = UDim.new(0.5, 0)})})
	local ps = new("UIStroke", {Thickness = 2, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = pulse})
	bind(ps, "Color", "accent")
	task.spawn(function()
		while alive do
			if bubble.Visible and State.BubblePulse then
				pulse.Size = UDim2.fromScale(1, 1)
				ps.Transparency = 0.15
				tween(pulse, 1.4, {Size = UDim2.fromScale(1.8, 1.8)}, Enum.EasingStyle.Quad)
				tween(ps, 1.4, {Transparency = 1}, Enum.EasingStyle.Quad)
			end
			task.wait(1.6)
		end
	end)
end

local function applyBubble()
	local s = State.BubbleSize
	bubble.Size = UDim2.fromOffset(s, s)
	bubbleLbl.Text = State.BubbleIcon
	bubbleLbl.TextSize = math.floor(s * 0.46)
end
local function applyPanel()
	main.Size = UDim2.fromOffset(State.PanelW, State.PanelH)
	main.BackgroundTransparency = State.Opacity / 100
	glow.BackgroundTransparency = 1 - State.Glow / 100
	topLine.Visible = State.TopLine
	topLine.Size = UDim2.new(1, 0, 0, State.TopLineH)
	pLayer.ZIndex = State.PartFront and 6 or 0
	setBorders()
	State.Scale = State.ScalePct / 100
	if State.Shown then tween(uiscale, 0.25, {Scale = State.Scale}) end
end

local function drag(handle, target, opts)
	opts = opts or {}
	local st = {moved = false}
	local dragging, start, origin
	handle.InputBegan:Connect(function(i)
		if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and not (opts.locked and opts.locked()) then
			dragging, start, origin, st.moved = true, i.Position, target.Position, false
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging = false
					if opts.onEnd and st.moved then pcall(opts.onEnd) end
				end
			end)
		end
	end)
	conn(UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - start
			if d.Magnitude > 6 then st.moved = true end
			target.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
		end
	end))
	return st
end
drag(top, main)
local bubbleDrag = drag(bubble, bubble)

local function showMain()
	State.Shown = true
	main.Visible = true
	bubble.Visible = false
	local sc, a = State.Scale, State.OpenAnim
	main.GroupTransparency = 1
	uiscale.Scale = sc
	if a == "Pop" then
		uiscale.Scale = sc * 0.86
		tween(uiscale, 0.55, {Scale = sc}, Enum.EasingStyle.Back)
	elseif a == "Zoom" then
		uiscale.Scale = sc * 1.18
		tween(uiscale, 0.5, {Scale = sc})
	elseif a == "Subir" then
		local base = main.Position
		main.Position = base + UDim2.fromOffset(0, 50)
		tween(main, 0.5, {Position = base})
	end
	tween(main, 0.4, {GroupTransparency = 0})
	updateBlur()
end
local function hideMain()
	State.Shown = false
	tween(main, 0.25, {GroupTransparency = 1})
	tween(uiscale, 0.25, {Scale = State.Scale * 0.9})
	updateBlur()
	task.delay(0.27, function() if not State.Shown then main.Visible = false; bubble.Visible = true end end)
end
yellow.MouseButton1Click:Connect(hideMain)
bubble.MouseButton1Click:Connect(function() if not bubbleDrag.moved then showMain() end end)
conn(UIS.InputBegan:Connect(function(i, gp)
	if not gp and i.KeyCode.Name == State.ToggleKey then if State.Shown then hideMain() else showMain() end end
end))

------------------------------------------------------------------
-- PARTÍCULAS (reagem ao toque / mouse)
------------------------------------------------------------------
local rebuildParticles, setPartCount, styleAllParticles
do
	local pool = {}
	local pointer, pointerT = nil, 0
	local glyphs = {["Neve"] = "❄", ["Estrela"] = "✦", ["Coração"] = "♥", ["Flor"] = "✿"}
	local shapes = {"Círculo", "Neve", "Estrela", "Coração", "Flor", "Quadrado", "Diamante", "Anel"}
	local function pColor(i)
		local m = State.PartColor
		if m == "Tema" then return (i % 2 == 0) and T.accent or T.accent2
		elseif m == "Arco-íris" then return Color3.fromHSV((i * 0.071 + tick() * 0.12) % 1, 0.55, 1)
		elseif m == "Personalizada" then return Color3.fromRGB(State.PR, State.PG, State.PB) end
		return WHITE
	end
	local function stylePart(p, i)
		local s = State.PartSize * p.sz
		local col = pColor(i)
		local tr = 1 - State.PartAlpha / 100
		local o = p.o
		if p.glyph then
			o.TextSize = math.max(6, math.floor(s * 2.6))
			o.Size = UDim2.fromOffset(s * 3, s * 3)
			o.TextColor3 = col
			o.TextTransparency = tr
		else
			o.Size = UDim2.fromOffset(s, s)
			if p.stroke then p.stroke.Color = col; p.stroke.Transparency = tr
			else o.BackgroundColor3 = col; o.BackgroundTransparency = tr end
		end
	end
	local function newPart()
		local shape = State.PartShape
		if shape == "Aleatório" then shape = shapes[math.random(1, #shapes)] end
		local o, stroke
		local g = glyphs[shape]
		if g then
			o = new("TextLabel", {BackgroundTransparency = 1, Text = g, Font = Enum.Font.GothamBold, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(16, 16), Parent = pLayer})
		else
			o = new("Frame", {BackgroundColor3 = WHITE, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Parent = pLayer})
			if shape == "Círculo" or shape == "Anel" then new("UICorner", {CornerRadius = UDim.new(1, 0), Parent = o}) end
			if shape == "Quadrado" then new("UICorner", {CornerRadius = UDim.new(0, 2), Parent = o}) end
			if shape == "Anel" then
				o.BackgroundTransparency = 1
				stroke = new("UIStroke", {Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = o})
			end
		end
		return {o = o, glyph = g ~= nil, stroke = stroke, base = (shape == "Diamante") and 45 or 0,
			x = math.random(0, State.PanelW), y = math.random(0, State.PanelH), spd = 0.6 + math.random() * 0.8,
			sz = 0.6 + math.random() * 0.9, t = math.random() * 10, ph = math.random() * 6.28,
			vx = 0, vy = 0, rot = (math.random() - 0.5) * 120, r = 0}
	end
	setPartCount = function()
		local n = State.PartOn and State.PartCount or 0
		while #pool > n do local p = table.remove(pool); p.o:Destroy() end
		while #pool < n do
			local p = newPart()
			table.insert(pool, p)
			stylePart(p, #pool)
		end
	end
	rebuildParticles = function()
		for _, p in ipairs(pool) do p.o:Destroy() end
		pool = {}
		setPartCount()
	end
	styleAllParticles = function()
		for i, p in ipairs(pool) do pcall(stylePart, p, i) end
	end
	table.insert(binders, function() styleAllParticles() end)

	local function track(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
			pointer = Vector2.new(i.Position.X, i.Position.Y)
			pointerT = tick()
		end
	end
	conn(UIS.InputChanged:Connect(track))
	conn(UIS.InputBegan:Connect(track))

	conn(RS.RenderStepped:Connect(function(dt)
		Perf.frames = Perf.frames + 1
		if not State.PartOn or not main.Visible then return end
		local pw, ph = State.PanelW, State.PanelH
		local dir = (State.PartDir == "Subir") and -1 or 1
		local lx, ly, R
		if State.TouchParticles and pointer and tick() - pointerT < 0.7 then
			local sc = math.max(uiscale.Scale, 0.05)
			lx = (pointer.X - main.AbsolutePosition.X) / sc
			ly = (pointer.Y - main.AbsolutePosition.Y) / sc
			R = State.PartRepel
		end
		local damp = math.max(0, 1 - dt * 2.5)
		for _, p in ipairs(pool) do
			p.t = p.t + dt
			if lx then
				local dx, dy = p.x - lx, p.y - ly
				local d2 = dx * dx + dy * dy
				if d2 < R * R and d2 > 1 then
					local d = math.sqrt(d2)
					local f = (1 - d / R) * 900 * dt
					p.vx = p.vx + dx / d * f
					p.vy = p.vy + dy / d * f
				end
			end
			p.vx, p.vy = p.vx * damp, p.vy * damp
			p.y = p.y + dir * State.PartSpeed * p.spd * dt + p.vy * dt * 6
			p.x = p.x + State.PartWind * p.spd * dt + p.vx * dt * 6
			if dir == 1 and p.y > ph + 14 then p.y = -14; p.x = math.random(0, pw)
			elseif dir == -1 and p.y < -14 then p.y = ph + 14; p.x = math.random(0, pw) end
			if p.y < -60 or p.y > ph + 60 then p.y = (dir == 1) and -14 or ph + 14 end
			if p.x > pw + 14 then p.x = -14 elseif p.x < -14 then p.x = pw + 14 end
			p.o.Position = UDim2.fromOffset(p.x + math.sin(p.t * 1.1 + p.ph) * State.PartSway, p.y)
			if State.PartSpin then
				p.r = p.r + p.rot * dt
				p.o.Rotation = p.base + p.r
			else
				p.o.Rotation = p.base
			end
		end
	end))
	task.spawn(function()
		while alive do
			task.wait(0.15)
			if State.PartOn and State.PartColor == "Arco-íris" and main.Visible then styleAllParticles() end
		end
	end)
end

------------------------------------------------------------------
-- INTRO (cores do tema, saudação por horário, dicas)
------------------------------------------------------------------
local playIntro
do
	local playing = false
	local tips = {"Arraste os widgets pela tela para posicioná-los.", "Use a aba Busca para achar qualquer função.",
		"Crie botões flutuantes para atalhos rápidos.", "Perfis trocam várias funções com um toque.", "Salve seu visual em Perfis → Salvar tudo.",
		"Marque locais no Teleport e volte neles depois."}
	playIntro = function(onDone)
		if playing then return end
		if State.IntroStyle == "Nenhuma" then if onDone then onDone() end return end
		playing = true
		task.spawn(function()
			local sp = 100 / math.max(State.IntroSpeed, 30)
			local skipped, done = false, false
			local function w(t)
				local t0 = tick()
				while tick() - t0 < t * sp and not skipped do task.wait(0.03) end
			end
			local cfgs = {
				["Cinemática"] = {rings = 3, burst = 30, typed = true, bar = true},
				["Explosão"] = {rings = 5, burst = 70, typed = false, bar = false},
				["Minimal"] = {rings = 0, burst = 0, typed = false, bar = true},
			}
			local cfg = cfgs[State.IntroStyle] or cfgs["Cinemática"]
			local useBurst = State.IntroBurst and cfg.burst > 0
			local useBar = State.IntroLoading and cfg.bar
			local c1, c2 = T.accent, T.accent2
			local function grad(obj, rot) return new("UIGradient", {Color = ColorSequence.new(c1, c2), Rotation = rot or 45, Parent = obj}) end

			local ov = new("CanvasGroup", {Name = "Intro", Size = UDim2.fromScale(1, 1), BackgroundColor3 = T.bg:Lerp(Color3.new(0, 0, 0), 0.55),
				BackgroundTransparency = 0.04, GroupTransparency = 1, ZIndex = 50, Parent = gui})
			local skipBtn = new("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 60, Parent = ov})
			skipBtn.MouseButton1Click:Connect(function() skipped = true end)
			new("TextLabel", {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -14), Size = UDim2.fromOffset(300, 18), BackgroundTransparency = 1,
				Text = "toque para pular", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Color3.fromRGB(190, 190, 205), TextTransparency = 0.5, Parent = ov})

			local stage = new("Frame", {Size = UDim2.fromOffset(360, 310), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -10), BackgroundTransparency = 1, Parent = ov})
			new("UIScale", {Scale = math.clamp(math.min(cam.ViewportSize.X / 520, cam.ViewportSize.Y / 390), 0.5, 1.3), Parent = stage})
			local CX, CY = 180, 100
			local center = Vector2.new(0.5, 0.5)

			tween(ov, 0.45, {GroupTransparency = 0})
			if State.IntroBlur then tween(blur, 0.6, {Size = 26}) end

			for i = 1, cfg.rings do
				task.delay((0.12 + i * 0.16) * sp, function()
					if skipped or done then return end
					local ring = new("Frame", {AnchorPoint = center, Position = UDim2.fromOffset(CX, CY), Size = UDim2.fromOffset(40, 40), BackgroundTransparency = 1, Parent = stage},
						{new("UICorner", {CornerRadius = UDim.new(1, 0)})})
					local st = new("UIStroke", {Thickness = 3, Color = WHITE, Transparency = 0.1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = ring})
					grad(st)
					tween(ring, 1.3 * sp, {Size = UDim2.fromOffset(560, 560)}, Enum.EasingStyle.Quint)
					tween(st, 1.3 * sp, {Transparency = 1, Thickness = 0.5}, Enum.EasingStyle.Quad)
					task.delay(1.4 * sp, function() ring:Destroy() end)
				end)
			end

			local orb = new("Frame", {AnchorPoint = center, Position = UDim2.fromOffset(CX, CY), Size = UDim2.fromOffset(250, 250), BackgroundColor3 = WHITE, BackgroundTransparency = 0.82, Parent = stage},
				{new("UICorner", {CornerRadius = UDim.new(1, 0)})})
			grad(orb)
			local orbS = new("UIScale", {Scale = 0, Parent = orb})
			local logo = new("Frame", {AnchorPoint = center, Position = UDim2.fromOffset(CX, CY), Size = UDim2.fromOffset(96, 96), BackgroundColor3 = WHITE, Rotation = -120, Parent = stage},
				{new("UICorner", {CornerRadius = UDim.new(0, 28)})})
			grad(logo)
			local logoS = new("UIScale", {Scale = 0, Parent = logo})
			new("UIStroke", {Color = WHITE, Transparency = 0.45, Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = logo})
			new("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = State.IntroLogo, Font = Enum.Font.GothamBold, TextSize = 54, TextColor3 = WHITE, Parent = logo})

			w(0.25)
			tween(orbS, 0.9 * sp, {Scale = 1}, Enum.EasingStyle.Quint)
			tween(logoS, 0.8 * sp, {Scale = 1}, Enum.EasingStyle.Back)
			tween(logo, 0.9 * sp, {Rotation = 0}, Enum.EasingStyle.Quint)
			task.spawn(function()
				w(0.9)
				while not done and not skipped do
					tween(orbS, 0.7 * sp, {Scale = 1.12}, Enum.EasingStyle.Sine)
					w(0.7)
					tween(orbS, 0.7 * sp, {Scale = 0.95}, Enum.EasingStyle.Sine)
					w(0.7)
				end
			end)
			w(0.45)

			if useBurst then
				for i = 1, cfg.burst do
					local a = math.random() * math.pi * 2
					local d = 110 + math.random() * 200
					local sz = math.random(3, 8)
					local col = (i % 3 == 0) and WHITE or ((i % 2 == 0) and c1 or c2)
					local s_ = new("Frame", {AnchorPoint = center, Position = UDim2.fromOffset(CX, CY), Size = UDim2.fromOffset(sz, sz), BackgroundColor3 = col, BorderSizePixel = 0, Parent = stage},
						{new("UICorner", {CornerRadius = UDim.new(1, 0)})})
					local dur = (0.8 + math.random() * 0.7) * sp
					tween(s_, dur, {Position = UDim2.fromOffset(CX + math.cos(a) * d, CY + math.sin(a) * d), BackgroundTransparency = 1, Size = UDim2.fromOffset(1, 1)}, Enum.EasingStyle.Quint)
					task.delay(dur + 0.1, function() s_:Destroy() end)
				end
			end

			local ttxt = State.IntroTitle
			pcall(function()
				local parts = {}
				for _, c in utf8.codes(State.IntroTitle) do table.insert(parts, utf8.char(c)) end
				ttxt = table.concat(parts, " ")
			end)
			local title = new("TextLabel", {Size = UDim2.fromOffset(360, 40), Position = UDim2.fromOffset(0, 166), BackgroundTransparency = 1, Text = ttxt,
				Font = Enum.Font.GothamBold, TextSize = 28, TextColor3 = WHITE, Parent = stage})
			grad(title, 0)
			if cfg.typed then
				title.MaxVisibleGraphemes = 0
				local n = utf8.len(ttxt) or #ttxt
				for i = 1, n do
					if skipped then break end
					title.MaxVisibleGraphemes = i
					w(0.05)
				end
				title.MaxVisibleGraphemes = -1
			else
				title.TextTransparency = 1
				tween(title, 0.5 * sp, {TextTransparency = 0})
			end
			local subText = State.IntroGreeting and (greeting() .. ", " .. (State.Streamer and "Jogador" or lp.DisplayName)) or State.IntroSub
			local sub = new("TextLabel", {Size = UDim2.fromOffset(360, 22), Position = UDim2.fromOffset(0, 208), BackgroundTransparency = 1, Text = subText,
				Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(205, 205, 220), TextTransparency = 1, Parent = stage})
			tween(sub, 0.5 * sp, {TextTransparency = 0})
			local tip = new("TextLabel", {Size = UDim2.fromOffset(360, 18), Position = UDim2.fromOffset(0, 286), BackgroundTransparency = 1, Text = "Dica: " .. tips[math.random(1, #tips)],
				Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Color3.fromRGB(170, 170, 190), TextTransparency = 1, Parent = stage})
			tween(tip, 0.6 * sp, {TextTransparency = 0.2})

			if useBar then
				local track = new("Frame", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromOffset(CX, 246), Size = UDim2.fromOffset(240, 6), BackgroundColor3 = WHITE, BackgroundTransparency = 0.88, Parent = stage}, {corner(3)})
				local fill = new("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = WHITE, Parent = track}, {corner(3)})
				grad(fill, 0)
				local st = new("TextLabel", {Size = UDim2.fromOffset(360, 18), Position = UDim2.fromOffset(0, 258), BackgroundTransparency = 1, Text = "",
					Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Color3.fromRGB(190, 190, 205), Parent = stage})
				local steps = {"Iniciando núcleo", "Carregando temas", "Montando widgets", "Conectando ao jogo", "Pronto!"}
				for i, s in ipairs(steps) do
					if skipped then break end
					st.Text = s
					tween(fill, 0.3 * sp, {Size = UDim2.new(i / #steps, 0, 1, 0)}, Enum.EasingStyle.Quad)
					w(0.34)
				end
			else
				w(0.6)
			end

			done = true
			w(0.3)
			if onDone then pcall(onDone) end
			tween(logoS, 0.5, {Scale = 1.6}, Enum.EasingStyle.Quad)
			tween(ov, 0.55, {GroupTransparency = 1})
			task.wait(0.6)
			pcall(function() ov:Destroy() end)
			playing = false
		end)
	end
end

------------------------------------------------------------------
-- SIDEBAR (rolável) + ABAS (reordenáveis) + TRANSIÇÕES
------------------------------------------------------------------
local side = new("Frame", {Size = UDim2.new(0, State.SideWidth, 1, -50), Position = UDim2.fromOffset(8, 42), BackgroundColor3 = T.side, BackgroundTransparency = 0.2, ClipsDescendants = true, Parent = main}, {rc(16)})
bind(side, "BackgroundColor3", "side")
glass(side, 0.92)
local tabScroll = new("ScrollingFrame", {Size = UDim2.new(1, 0, 1, -52), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(), Parent = side})
local indicator = new("Frame", {Size = UDim2.new(1, -12, 0, State.TabHeight), Position = UDim2.fromOffset(6, 8), BackgroundColor3 = WHITE, ZIndex = 1, Parent = tabScroll},
	{new("UICorner", {CornerRadius = UDim.new(0, 11)}), new("UIGradient", {})})
bind(indicator:FindFirstChildOfClass("UIGradient"), "Color", function() return ColorSequence.new(T.accent, T.accent2) end, true)
bind(new("UIStroke", {Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = false, Parent = indicator}), "Color", "accent")

local chip = new("Frame", {Size = UDim2.new(1, -12, 0, 40), Position = UDim2.new(0, 6, 1, -46), BackgroundColor3 = T.row, BackgroundTransparency = 0.25, Parent = side}, {rc(12)})
bind(chip, "BackgroundColor3", "row")
local chipAv = new("ImageLabel", {Size = UDim2.fromOffset(28, 28), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = T.side, Parent = chip}, {corner(14)})
bind(chipAv, "BackgroundColor3", "side")
local chipName = mkText({Size = UDim2.new(1, -44, 0, 18), Position = UDim2.fromOffset(40, 3), Text = lp.DisplayName, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = chip}, true)
Streamer.add(chipName, lp.DisplayName, "Jogador")
local chipLv = mkText({Size = UDim2.new(1, -44, 0, 14), Position = UDim2.fromOffset(40, 21), Text = "Lv —", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = chip}, false, "accent")

local content = new("Frame", {Size = UDim2.new(1, -(State.SideWidth + 24), 1, -50), Position = UDim2.fromOffset(State.SideWidth + 18, 42), BackgroundTransparency = 1, ClipsDescendants = true, Parent = main})

local pages, pageScale, tabY, tabIdx, tabBtns, tabOrder, current = {}, {}, {}, {}, {}, {}, nil
local function P(ox, oy) return UDim2.new(0.5, ox, 0.5, oy) end
local function reindex() for i, n in ipairs(tabOrder) do tabIdx[n] = i end end

local function indicatorPos(name)
	local y, h, s = tabY[name], State.TabHeight, State.TabStyle
	if s == "Barra" then return UDim2.fromOffset(3, y + 5) end
	if s == "Sublinhado" then return UDim2.fromOffset(18, y + h - 4) end
	return UDim2.fromOffset(6, y)
end
local function selColor() return (State.TabStyle == "Pílula") and WHITE or T.accent end

local function styleIndicator()
	local s, h = State.TabStyle, State.TabHeight
	local cr, st, g = indicator:FindFirstChildOfClass("UICorner"), indicator:FindFirstChildOfClass("UIStroke"), indicator:FindFirstChildOfClass("UIGradient")
	indicator.Visible = (s ~= "Nenhum")
	indicator.BackgroundColor3 = WHITE
	indicator.BackgroundTransparency = 0
	st.Enabled = false
	g.Enabled = true
	cr.CornerRadius = UDim.new(0, math.floor(11 * State.Corner / 16 + 0.5))
	if s == "Pílula" then
		indicator.Size = UDim2.new(1, -12, 0, h)
	elseif s == "Brilho" then
		indicator.Size = UDim2.new(1, -12, 0, h)
		indicator.BackgroundTransparency = 0.78
		st.Enabled = true
	elseif s == "Barra" then
		indicator.Size = UDim2.fromOffset(4, h - 10)
		cr.CornerRadius = UDim.new(0, 2)
	elseif s == "Sublinhado" then
		indicator.Size = UDim2.new(1, -36, 0, 3)
		cr.CornerRadius = UDim.new(0, 2)
	end
end

local function layoutTabs()
	local h = State.TabHeight
	for name, t in pairs(tabBtns) do
		local y = 8 + (tabIdx[name] - 1) * (h + 4)
		tabY[name] = y
		t.btn.Size = UDim2.new(1, -12, 0, h)
		t.btn.Position = UDim2.fromOffset(6, y)
		t.btn.TextSize = math.max(8, math.floor(State.TabFont * State.TextScale / 100 + 0.5))
		local txt = ""
		if State.TabIcons then txt = t.icon end
		if State.TabNames then txt = txt .. (State.TabIcons and "  " or "") .. name end
		t.btn.Text = txt
		t.btn.TextXAlignment = State.TabNames and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
		t.pad.PaddingLeft = UDim.new(0, State.TabNames and 12 or 0)
	end
	tabScroll.CanvasSize = UDim2.fromOffset(0, 12 + #tabOrder * (h + 4))
end

local function revealTab(name)
	pcall(function()
		local winH = tabScroll.AbsoluteWindowSize.Y / math.max(uiscale.Scale, 0.1)
		local maxY = math.max(0, tabScroll.CanvasSize.Y.Offset - winH)
		local target = math.clamp(tabY[name] - winH / 2 + State.TabHeight / 2, 0, maxY)
		tween(tabScroll, 0.3, {CanvasPosition = Vector2.new(0, target)})
	end)
end

local function applyLayout()
	local sw = State.SideWidth
	local right = (State.TabSide == "Direita")
	side.Size = UDim2.new(0, sw, 1, -50)
	side.Position = right and UDim2.new(1, -(sw + 8), 0, 42) or UDim2.fromOffset(8, 42)
	content.Size = UDim2.new(1, -(sw + 24), 1, -50)
	content.Position = right and UDim2.fromOffset(10, 42) or UDim2.fromOffset(sw + 18, 42)
	chip.Visible = State.ShowChip
	tabScroll.Size = UDim2.new(1, 0, 1, State.ShowChip and -52 or -6)
end

local function applyTabs()
	styleIndicator()
	layoutTabs()
	if current then indicator.Position = indicatorPos(current) end
	for _, f in ipairs(tabRefresh) do f(0.2) end
end

local function moveTab(name, dir)
	local i = tabIdx[name]
	if not i then return end
	local j = i + dir
	if j < 1 or j > #tabOrder then return end
	tabOrder[i], tabOrder[j] = tabOrder[j], tabOrder[i]
	reindex()
	State.TabOrder = {table.unpack(tabOrder)}
	layoutTabs()
	if current then tween(indicator, 0.3, {Position = indicatorPos(current)}) end
end

local function switchTab(name)
	if current == name then return end
	local oldName = current
	current = name
	for _, f in ipairs(tabRefresh) do f(0.25) end
	local tt = math.max(State.TransTime, 50) / 1000
	local es = ease()
	local kind = State.Transition
	tween(indicator, tt, {Position = indicatorPos(name)}, es)
	revealTab(name)
	local dir = (oldName and tabIdx[name] < tabIdx[oldName]) and -1 or 1

	if oldName then
		local old, oldS = pages[oldName], pageScale[oldName]
		if kind == "Nenhuma" then
			old.Visible = false
		else
			local goal = {GroupTransparency = 1}
			if kind == "Deslizar" then goal.Position = P(-30 * dir, 0)
			elseif kind == "Subir" then goal.Position = P(0, -30 * dir)
			elseif kind == "Girar" then goal.Rotation = -8 * dir end
			tween(old, tt * 0.5, goal, Enum.EasingStyle.Quad)
			if kind == "Zoom" or kind == "Pop" then tween(oldS, tt * 0.5, {Scale = 1.06}, Enum.EasingStyle.Quad) end
			task.delay(tt * 0.5 + 0.03, function() if current ~= oldName then old.Visible = false end end)
		end
	end

	local pg, ps = pages[name], pageScale[name]
	pg.Position = P(0, 0)
	pg.Rotation = 0
	ps.Scale = 1
	if kind == "Deslizar" then pg.Position = P(34 * dir, 0)
	elseif kind == "Subir" then pg.Position = P(0, 34 * dir)
	elseif kind == "Zoom" then ps.Scale = 0.9
	elseif kind == "Pop" then ps.Scale = 0.7
	elseif kind == "Girar" then pg.Rotation = 8 * dir end
	pg.GroupTransparency = (kind == "Nenhuma") and 0 or 1
	pg.Visible = true
	if kind == "Nenhuma" then return end
	task.delay(tt * 0.2, function()
		if current ~= name then return end
		tween(pg, tt, {GroupTransparency = 0, Position = P(0, 0), Rotation = 0}, es)
		tween(ps, tt, {Scale = 1}, es)
	end)
end

local function addPage(name, icon)
	local grp = new("CanvasGroup", {Size = UDim2.fromScale(1, 1), AnchorPoint = Vector2.new(0.5, 0.5), Position = P(0, 0), BackgroundTransparency = 1, GroupTransparency = 1, Visible = false, Parent = content})
	local ps = new("UIScale", {Parent = grp})
	local sc = new("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
		AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = grp,
	}, {
		new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}),
		new("UIPadding", {PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 12)}),
	})
	bind(sc, "ScrollBarImageColor3", "accent")
	pages[name], pageScale[name] = grp, ps
	table.insert(tabOrder, name)
	reindex()
	local btn = new("TextButton", {Size = UDim2.new(1, -12, 0, State.TabHeight), Position = UDim2.fromOffset(6, 8), BackgroundTransparency = 1, Text = icon .. "  " .. name,
		TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2, AutoButtonColor = false, TextColor3 = T.sub, Parent = tabScroll})
	regFont(btn, true)
	local pad = new("UIPadding", {PaddingLeft = UDim.new(0, 12), Parent = btn})
	tabBtns[name] = {btn = btn, icon = icon, pad = pad}
	local refresh = function(d)
		tween(btn, d or 0.2, {TextColor3 = (current == name) and selColor() or T.sub})
	end
	table.insert(tabRefresh, refresh)
	table.insert(binders, refresh)
	btn.MouseButton1Click:Connect(function() switchTab(name) end)
	layoutTabs()
	return sc
end

------------------------------------------------------------------
-- COMPONENTES
------------------------------------------------------------------
local function row(page, h)
	local r = new("Frame", {Size = UDim2.new(1, -4, 0, h or 40), BackgroundColor3 = T.row, BackgroundTransparency = 0.2, Parent = page}, {rc(13)})
	bind(r, "BackgroundColor3", "row")
	glass(r, 0.93)
	return r
end
local function Section(page, text)
	mkText({Size = UDim2.new(1, -4, 0, 22), Text = string.upper(text), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = page}, true, "accent")
end
local function Label(page, text)
	return mkText({Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = text, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = page}, false, "sub")
end

local function Toggle(page, text, key, cb)
	if not RegByKey[key] then
		local e = {text = text, key = key, cb = cb}
		table.insert(Registry, e)
		RegByKey[key] = e
	end
	local r = row(page, 42)
	mkText({Size = UDim2.new(1, -76, 1, 0), Position = UDim2.fromOffset(14, 0), Text = text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, false)
	local sw = new("TextButton", {Size = UDim2.fromOffset(46, 26), Position = UDim2.new(1, -60, 0.5, -13), Text = "", AutoButtonColor = false, Parent = r}, {corner(13)})
	local knob = new("Frame", {Size = UDim2.fromOffset(22, 22), Position = State[key] and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2), BackgroundColor3 = WHITE, Parent = sw}, {corner(11)})
	local refresh = bind(sw, "BackgroundColor3", function() return State[key] and T.accent or offColor() end, true)
	ctl[key] = function(v)
		State[key] = v
		refresh(0.2)
		knob.Position = v and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
	end
	sw.MouseButton1Click:Connect(function()
		State[key] = not State[key]
		refresh(0.25)
		tween(knob, 0.3, {Position = State[key] and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)}, Enum.EasingStyle.Back)
		if cb then task.spawn(function() local ok, err = pcall(cb, State[key]); if not ok then notify("Erro", tostring(err)) end end) end
	end)
end

local function Slider(page, text, min, max, key, cb, suffix)
	suffix = suffix or ""
	local r = row(page, 58)
	mkText({Size = UDim2.new(0.6, 0, 0, 28), Position = UDim2.fromOffset(14, 2), Text = text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, false)
	local vl = mkText({Size = UDim2.new(0.4, -28, 0, 28), Position = UDim2.new(0.6, 14, 0, 2), Text = State[key] .. suffix, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = r}, true, "accent")
	local bar = new("Frame", {Size = UDim2.new(1, -28, 0, 8), Position = UDim2.fromOffset(14, 40), BackgroundColor3 = T.sub, Parent = r}, {corner(4)})
	bind(bar, "BackgroundColor3", offColor)
	local fill = new("Frame", {Size = UDim2.new(math.clamp((State[key] - min) / (max - min), 0, 1), 0, 1, 0), BackgroundColor3 = WHITE, Parent = bar}, {corner(4)})
	bind(new("UIGradient", {Parent = fill}), "Color", function() return ColorSequence.new(T.accent, T.accent2) end, true)
	new("Frame", {Size = UDim2.fromOffset(18, 18), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = WHITE, Parent = fill},
		{corner(9), new("UIStroke", {Color = Color3.new(0, 0, 0), Transparency = 0.8, Thickness = 1})})
	ctl[key] = function(v)
		State[key] = v
		fill.Size = UDim2.new(math.clamp((v - min) / (max - min), 0, 1), 0, 1, 0)
		vl.Text = v .. suffix
	end
	local sliding = false
	local function set(x)
		local a = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		local v = math.floor(min + (max - min) * a + 0.5)
		State[key] = v
		fill.Size = UDim2.new(a, 0, 1, 0)
		vl.Text = v .. suffix
		if cb then pcall(cb, v) end
	end
	local hit = new("TextButton", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.fromOffset(0, 28), BackgroundTransparency = 1, Text = "", Parent = r})
	hit.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			sliding = true
			page.ScrollingEnabled = false
			set(i.Position.X)
		end
	end)
	conn(UIS.InputChanged:Connect(function(i)
		if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then set(i.Position.X) end
	end))
	conn(UIS.InputEnded:Connect(function(i)
		if sliding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
			sliding = false
			page.ScrollingEnabled = true
		end
	end))
end

local Button, restyleButtons
do
	local btnList = {}
	local function btnColors()
		if State.BtnColorMode == "Personalizada" then
			local c = Color3.fromRGB(State.BR, State.BG, State.BB)
			return c, c:Lerp(WHITE, 0.3)
		end
		return T.accent, T.accent2
	end
	Button = function(page, text, cb)
		local wrap = new("CanvasGroup", {Size = UDim2.new(1, -4, 0, State.BtnHeight), BackgroundColor3 = WHITE, Parent = page})
		local cr = new("UICorner", {Parent = wrap})
		local g = new("UIGradient", {Parent = wrap})
		local st = new("UIStroke", {Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = false, Parent = wrap})
		local gloss = new("Frame", {Size = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 2, Parent = wrap})
		new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(0.8, 1), Parent = gloss})
		local lbl = mkText({Size = UDim2.fromScale(1, 1), Text = text, TextSize = 13, TextColor3 = WHITE, ZIndex = 3, Parent = wrap}, true, false)
		local hit = new("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = wrap})
		local function restyle()
			local s = State.BtnStyle
			local c1, c2 = btnColors()
			wrap.Size = UDim2.new(1, -4, 0, State.BtnHeight)
			cr.CornerRadius = UDim.new(0, (s == "Pílula") and 999 or State.BtnCorner)
			gloss.Visible = State.BtnGloss and (s == "Gradiente" or s == "Pílula" or s == "Sólido")
			if s == "Gradiente" or s == "Pílula" then
				wrap.BackgroundColor3 = WHITE; wrap.BackgroundTransparency = 0
				g.Enabled = true; g.Color = ColorSequence.new(c1, c2)
				st.Enabled = false; lbl.TextColor3 = WHITE
			elseif s == "Sólido" then
				wrap.BackgroundColor3 = c1; wrap.BackgroundTransparency = 0
				g.Enabled = false; st.Enabled = false; lbl.TextColor3 = WHITE
			elseif s == "Vidro" then
				wrap.BackgroundColor3 = T.row; wrap.BackgroundTransparency = 0.25
				g.Enabled = false; st.Enabled = true; st.Color = c1; st.Thickness = 1.5; lbl.TextColor3 = T.text
			else
				wrap.BackgroundColor3 = T.bg; wrap.BackgroundTransparency = 0.15
				g.Enabled = false; st.Enabled = true; st.Color = c1; st.Thickness = 2.5; lbl.TextColor3 = c1
			end
		end
		restyle()
		table.insert(btnList, restyle)
		table.insert(binders, function() restyle() end)

		hit.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				tween(wrap, 0.08, {GroupTransparency = 0.2})
				if State.BtnRipple then
					local sc_ = math.max(uiscale.Scale, 0.1)
					local rx = (i.Position.X - wrap.AbsolutePosition.X) / sc_
					local ry = (i.Position.Y - wrap.AbsolutePosition.Y) / sc_
					local d = wrap.AbsoluteSize.X / sc_ * 1.5
					local rp = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(rx, ry), Size = UDim2.fromOffset(0, 0),
						BackgroundColor3 = WHITE, BackgroundTransparency = 0.55, ZIndex = 4, Parent = wrap}, {new("UICorner", {CornerRadius = UDim.new(1, 0)})})
					tween(rp, 0.6, {Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
					task.delay(0.65, function() rp:Destroy() end)
				end
			end
		end)
		local function release() tween(wrap, 0.2, {GroupTransparency = 0}) end
		hit.MouseButton1Up:Connect(release)
		hit.MouseLeave:Connect(release)
		hit.MouseButton1Click:Connect(function()
			task.spawn(function() local ok, err = pcall(cb); if not ok then notify("Erro", tostring(err)) end end)
		end)
	end
	restyleButtons = function() for _, f in ipairs(btnList) do pcall(f) end end
end

local function Input(page, text, placeholder, cb)
	local r = row(page, 42)
	mkText({Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.fromOffset(14, 0), Text = text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, false)
	local box = mkText({Size = UDim2.new(0.6, -24, 0, 28), Position = UDim2.new(0.4, 6, 0.5, -14), Text = "", PlaceholderText = placeholder, TextSize = 13, ClearTextOnFocus = false, BackgroundColor3 = T.side, Parent = r}, false, "text", "TextBox")
	box.BackgroundTransparency = 0.3
	new("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})
	bind(box, "BackgroundColor3", "side")
	box.FocusLost:Connect(function(enter) if enter and box.Text ~= "" then pcall(cb, box.Text); box.Text = "" end end)
end

local function Dropdown(page, text, options, key, cb)
	local r = row(page, 42)
	r.ClipsDescendants = true
	local head = new("TextButton", {Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Text = "", Parent = r})
	mkText({Size = UDim2.new(0.5, 0, 0, 42), Position = UDim2.fromOffset(14, 0), Text = text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, false)
	local val = mkText({Size = UDim2.new(0.5, -40, 0, 42), Position = UDim2.new(0.5, 0, 0, 0), Text = tostring(State[key]), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, Parent = r}, true, "accent")
	local arrow = mkText({Size = UDim2.fromOffset(20, 42), Position = UDim2.new(1, -30, 0, 0), Text = "▾", TextSize = 15, Parent = r}, true, "sub")
	local list = new("Frame", {Size = UDim2.new(1, -16, 0, #options * 32), Position = UDim2.fromOffset(8, 46), BackgroundTransparency = 1, Parent = r}, {new("UIListLayout", {Padding = UDim.new(0, 3)})})
	ctl[key] = function(v) State[key] = v; val.Text = tostring(v) end
	local open = false
	for _, o in ipairs(options) do
		local b = mkText({Size = UDim2.new(1, 0, 0, 29), Text = o, TextSize = 13, BackgroundColor3 = T.side, AutoButtonColor = false, Parent = list}, false, "text", "TextButton")
		b.BackgroundTransparency = 0.35
		new("UICorner", {CornerRadius = UDim.new(0, 8), Parent = b})
		bind(b, "BackgroundColor3", "side")
		b.MouseButton1Click:Connect(function()
			State[key] = o
			val.Text = o
			open = false
			tween(r, 0.3, {Size = UDim2.new(1, -4, 0, 42)})
			tween(arrow, 0.3, {Rotation = 0})
			if cb then task.spawn(function() local ok, err = pcall(cb, o); if not ok then notify("Erro", tostring(err)) end end) end
		end)
	end
	head.MouseButton1Click:Connect(function()
		open = not open
		tween(r, 0.35, {Size = UDim2.new(1, -4, 0, open and (50 + #options * 32) or 42)})
		tween(arrow, 0.35, {Rotation = open and 180 or 0})
	end)
end

local function Grid(page, w, h)
	return new("Frame", {Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = page},
		{new("UIGridLayout", {CellSize = UDim2.fromOffset(w, h), CellPadding = UDim2.fromOffset(8, 8), SortOrder = Enum.SortOrder.LayoutOrder})})
end

local ThemeGrid
do
	local themeStrokes = {}
	refreshThemeCards = function()
		for name, s in pairs(themeStrokes) do s.Enabled = (State.Theme == name) end
	end
	ThemeGrid = function(page)
		local g = Grid(page, 134, 58)
		for _, name in ipairs(ThemeNames) do
			local tt = Themes[name]
			local b = new("TextButton", {BackgroundColor3 = tt.bg, Text = "", AutoButtonColor = false, Parent = g}, {rc(12)})
			local strip = new("Frame", {Size = UDim2.new(1, -12, 0, 16), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = WHITE, Parent = b}, {corner(6)})
			local sg = new("UIGradient", {Color = ColorSequence.new(tt.accent, tt.accent2), Parent = strip})
			if name == "Custom" then
				bind(sg, "Color", function() return ColorSequence.new(Themes.Custom.accent, Themes.Custom.accent2) end, true)
			end
			new("Frame", {Size = UDim2.new(1, -12, 0, 8), Position = UDim2.fromOffset(6, 27), BackgroundColor3 = tt.row, Parent = b}, {corner(4)})
			new("TextLabel", {Size = UDim2.new(1, 0, 0, 16), Position = UDim2.fromOffset(0, 38), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = tt.text, Parent = b})
			local st = new("UIStroke", {Thickness = 2.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = (State.Theme == name), Parent = b})
			bind(st, "Color", "accent")
			themeStrokes[name] = st
			b.MouseButton1Click:Connect(function()
				if name == "Custom" then updateCustom() end
				applyTheme(name)
			end)
		end
	end
end

local function FontGrid(page, key, withDefault, cb)
	local g = Grid(page, 134, 40)
	local list = {}
	if withDefault then table.insert(list, "Padrão") end
	for _, n in ipairs(FontOrder) do table.insert(list, n) end
	local strokes = {}
	ctl[key] = function(v) State[key] = v; for nm, s in pairs(strokes) do s.Enabled = (nm == v) end end
	for _, n in ipairs(list) do
		local b = new("TextButton", {BackgroundColor3 = T.row, Text = "Aa  " .. n, TextSize = 13, TextColor3 = T.text, AutoButtonColor = false, TextTruncate = Enum.TextTruncate.AtEnd,
			Font = (n == "Padrão") and Enum.Font.Gotham or getFont(n, false), Parent = g}, {rc(11)})
		bind(b, "BackgroundColor3", "row")
		bind(b, "TextColor3", "text")
		local st = new("UIStroke", {Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = (State[key] == n), Parent = b})
		bind(st, "Color", "accent")
		strokes[n] = st
		b.MouseButton1Click:Connect(function()
			State[key] = n
			for nm, s in pairs(strokes) do s.Enabled = (nm == n) end
			task.spawn(function() pcall(cb, n) end)
		end)
	end
end

local function InfoRow(page, name, fn)
	local r = row(page, 34)
	mkText({Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.fromOffset(14, 0), Text = name, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, false, "sub")
	local v = mkText({Size = UDim2.new(0.55, -28, 1, 0), Position = UDim2.new(0.45, 14, 0, 0), Text = "...", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, Parent = r}, true)
	return function()
		local ok, val = pcall(fn)
		v.Text = ok and tostring(val) or "—"
	end
end

local function Chart(page, title, h)
	local r = row(page, h or 104)
	mkText({Size = UDim2.new(1, -28, 0, 22), Position = UDim2.fromOffset(14, 4), Text = title, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, true, "sub")
	local area = new("Frame", {Size = UDim2.new(1, -28, 1, -36), Position = UDim2.fromOffset(14, 28), BackgroundTransparency = 1, Parent = r})
	local N, bars = 24, {}
	for i = 1, N do
		local b = new("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new((i - 1) / N, 1, 1, 0), Size = UDim2.new(1 / N, -2, 0.03, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = area}, {corner(2)})
		bind(new("UIGradient", {Rotation = 90, Parent = b}), "Color", function() return ColorSequence.new(T.accent, T.accent2) end, true)
		bars[i] = b
	end
	return function(values)
		local mx = 1
		for _, v in ipairs(values) do if v > mx then mx = v end end
		local off = N - #values
		for i = 1, N do
			local v = values[i - off] or 0
			tween(bars[i], 0.4, {Size = UDim2.new(1 / N, -2, math.max(v / mx, 0.03), 0)})
		end
	end
end

------------------------------------------------------------------
-- LÓGICA DO JOGO
------------------------------------------------------------------
local function root() local c = lp.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function hum() local c = lp.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function invoke(...)
	local args = table.pack(...)
	local rem = RepStorage:FindFirstChild("Remotes")
	local cf = rem and rem:FindFirstChild("CommF_")
	if not cf then return nil end
	local ok, res = pcall(function() return cf:InvokeServer(table.unpack(args, 1, args.n)) end)
	return ok and res or nil
end
local function loop(interval, fn)
	task.spawn(function()
		while alive do
			task.wait(interval)
			pcall(fn)
		end
	end)
end
local function dataVal(n)
	local ok, v = pcall(function() return lp.Data[n].Value end)
	return ok and v or nil
end
local function commas(n)
	n = tonumber(n) or 0
	local s = tostring(math.floor(n))
	local out = s:reverse():gsub("(%d%d%d)", "%1."):reverse()
	return (out:gsub("^%.", ""))
end
local function anyAuto() return State.AutoLevel or State.Farm or State.AutoBoss or State.AutoElite or State.Chest or State.FruitGrab end

local function goTo(cf)
	local r = root()
	if not r then return end
	local d = (cf.Position - r.Position).Magnitude
	if d < 80 then r.CFrame = cf return end
	local t = d / math.max(State.TravelSpeed, 50)
	local tw = TS:Create(r, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = cf})
	local done = false
	local c = tw.Completed:Connect(function() done = true end)
	tw:Play()
	local t0 = tick()
	while not done and alive and tick() - t0 < t + 1 do
		if not anyAuto() and not State.ManualTravel then tw:Cancel() break end
		task.wait(0.05)
	end
	c:Disconnect()
end
local function hoverTo(pos)
	local r = root()
	if not r then return end
	local tp = pos + Vector3.new(0, State.Height, 0)
	if (tp - r.Position).Magnitude > 120 then goTo(CFrame.new(tp)) else r.CFrame = CFrame.new(tp, pos) end
	r.AssemblyLinearVelocity = Vector3.zero
end
local function equipWeapon()
	local c = lp.Character
	if not c then return end
	local cur = c:FindFirstChildOfClass("Tool")
	if cur and cur.ToolTip == State.Weapon then return end
	local bp = lp:FindFirstChild("Backpack")
	if not bp then return end
	for _, t in ipairs(bp:GetChildren()) do
		if t:IsA("Tool") and t.ToolTip == State.Weapon then
			local h = hum()
			if h then h:EquipTool(t) end
			return
		end
	end
end
local function nearestMob(name)
	local r = root()
	local folder = workspace:FindFirstChild("Enemies")
	if not r or not folder then return end
	local best, bd
	for _, m in ipairs(folder:GetChildren()) do
		if not name or m.Name == name then
			local h, mr = m:FindFirstChildOfClass("Humanoid"), m:FindFirstChild("HumanoidRootPart")
			if h and mr and h.Health > 0 then
				local d = (mr.Position - r.Position).Magnitude
				if not bd or d < bd then best, bd = mr, d end
			end
		end
	end
	return best
end
local function findFruit()
	for _, v in ipairs(workspace:GetChildren()) do
		if (v:IsA("Tool") or v:IsA("Model")) and v.Name:lower():find("fruit") and v:FindFirstChild("Handle") then return v end
	end
end

-- QUESTS (nível, mob, quest, NPC, mob)
local questFor, seaIndex
local ZoneNames, ZoneMap = {}, {}
do
	local function Q(a, b, mob, qn, ql, qx, qy, qz, mx, my, mz)
		return {min = a, max = b, mob = mob, qn = qn, ql = ql, q = Vector3.new(qx, qy, qz), m = Vector3.new(mx, my, mz)}
	end
	local Sea1 = {
		Q(1, 9, "Bandit", "BanditQuest1", 1, 1059.37, 15.45, 1550.42, 1045.96, 27.00, 1560.00),
		Q(10, 14, "Monkey", "JungleQuest", 1, -1598.09, 35.55, 153.38, -1448.52, 67.85, 11.47),
		Q(15, 29, "Gorilla", "JungleQuest", 2, -1598.09, 35.55, 153.38, -1129.88, 40.46, -525.42),
		Q(30, 39, "Pirate", "BuggyQuest1", 1, -1141.07, 4.10, 3831.55, -1103.51, 13.75, 3896.09),
		Q(40, 59, "Brute", "BuggyQuest1", 2, -1141.07, 4.10, 3831.55, -1140.08, 14.81, 4322.92),
		Q(60, 74, "Desert Bandit", "DesertQuest", 1, 896.51, 6.43, 4390.14, 984.99, 16.11, 4417.91),
		Q(75, 89, "Desert Officer", "DesertQuest", 2, 896.51, 6.43, 4390.14, 1547.15, 14.45, 4381.00),
		Q(90, 99, "Snow Bandit", "SnowQuest", 1, 1386.80, 87.27, -1298.35, 1356.30, 105.77, -1328.24),
		Q(100, 119, "Snowman", "SnowQuest", 2, 1386.80, 87.27, -1298.35, 1218.80, 138.01, -1488.03),
		Q(120, 149, "Chief Petty Officer", "MarineQuest2", 1, -5035.49, 28.67, 4324.18, -4931.15, 65.79, 4121.83),
		Q(150, 174, "Sky Bandit", "SkyQuest", 1, -4842.13, 717.69, -2623.04, -4955.64, 365.46, -2908.18),
		Q(175, 189, "Dark Master", "SkyQuest", 2, -4842.13, 717.69, -2623.04, -5148.16, 439.04, -2332.96),
		Q(190, 209, "Prisoner", "PrisonerQuest", 1, 5310.60, 0.35, 474.94, 5098.97, -0.32, 474.23),
		Q(210, 249, "Dangerous Prisoner", "PrisonerQuest", 2, 5310.60, 0.35, 474.94, 5654.56, 15.63, 866.30),
		Q(250, 274, "Toga Warrior", "ColosseumQuest", 1, -1580.04, 6.35, -2986.47, -1820.21, 51.68, -2740.66),
		Q(275, 299, "Gladiator", "ColosseumQuest", 2, -1580.04, 6.35, -2986.47, -1292.84, 56.38, -3339.03),
		Q(300, 324, "Military Soldier", "MagmaQuest", 1, -5313.37, 10.95, 8515.29, -5411.16, 11.08, 8454.29),
		Q(325, 374, "Military Spy", "MagmaQuest", 2, -5313.37, 10.95, 8515.29, -5802.87, 86.26, 8828.86),
		Q(375, 399, "Fishman Warrior", "FishmanQuest", 1, 61122.65, 18.50, 1569.40, 60878.30, 18.48, 1543.76),
		Q(400, 449, "Fishman Commando", "FishmanQuest", 2, 61122.65, 18.50, 1569.40, 61922.63, 18.48, 1493.93),
		Q(450, 474, "God's Guard", "SkyExp1Quest", 1, -4721.89, 845.28, -1953.84, -4628.05, 866.93, -1931.24),
		Q(475, 524, "Shanda", "SkyExp1Quest", 2, -7859.09, 5544.19, -381.48, -7685.12, 5601.08, -441.38),
		Q(525, 549, "Royal Squad", "SkyExp2Quest", 1, -7906.82, 5634.66, -1411.99, -7654.25, 5637.10, -1407.75),
		Q(550, 624, "Royal Soldier", "SkyExp2Quest", 2, -7906.82, 5634.66, -1411.99, -7760.41, 5679.90, -1884.81),
		Q(625, 649, "Galley Pirate", "FountainQuest", 1, 5259.82, 37.35, 4050.03, 5551.02, 78.90, 3930.41),
		Q(650, 699, "Galley Captain", "FountainQuest", 2, 5259.82, 37.35, 4050.03, 5441.95, 42.50, 4950.09),
	}
	local Sea2 = {
		Q(700, 724, "Raider", "Area1Quest", 1, -427.72, 72.99, 1835.94, 68.87, 93.63, 2429.67),
		Q(725, 774, "Mercenary", "Area1Quest", 2, -427.72, 72.99, 1835.94, -864.85, 122.47, 1453.15),
		Q(775, 799, "Swan Pirate", "Area2Quest", 1, 635.61, 73.10, 917.81, 1065.36, 137.64, 1324.37),
		Q(800, 874, "Factory Staff", "Area2Quest", 2, 635.61, 73.10, 917.81, 533.22, 128.47, 355.62),
		Q(875, 899, "Marine Lieutenant", "MarineQuest3", 1, -2440.79, 71.71, -3216.07, -2489.26, 84.61, -3151.88),
		Q(900, 949, "Marine Captain", "MarineQuest3", 2, -2440.79, 71.71, -3216.07, -2335.20, 79.79, -3245.87),
		Q(950, 974, "Zombie", "ZombieQuest", 1, -5494.34, 48.50, -794.59, -5536.50, 101.08, -836.83),
		Q(975, 999, "Vampire", "ZombieQuest", 2, -5494.34, 48.50, -794.59, -5806.98, 16.72, -1164.43),
		Q(1000, 1049, "Snow Trooper", "SnowMountainQuest", 1, 607.06, 401.44, -5370.55, 535.21, 432.74, -5484.92),
		Q(1050, 1099, "Winter Warrior", "SnowMountainQuest", 2, 607.06, 401.44, -5370.55, 1234.44, 456.95, -5174.13),
		Q(1100, 1124, "Lab Subordinate", "IceSideQuest", 1, -6061.84, 15.93, -4902.03, -5720.55, 63.31, -4784.61),
		Q(1125, 1174, "Horned Warrior", "IceSideQuest", 2, -6061.84, 15.93, -4902.03, -6292.75, 91.18, -5502.65),
		Q(1175, 1199, "Magma Ninja", "FireSideQuest", 1, -5429.04, 15.97, -5297.96, -5461.84, 130.36, -5836.47),
		Q(1200, 1249, "Lava Pirate", "FireSideQuest", 2, -5429.04, 15.97, -5297.96, -5251.18, 55.16, -4774.40),
		Q(1250, 1274, "Ship Deckhand", "ShipQuest1", 1, 1037.80, 125.09, 32911.60, 1212.01, 150.79, 33059.24),
		Q(1275, 1299, "Ship Engineer", "ShipQuest1", 2, 1037.80, 125.09, 32911.60, 919.47, 43.54, 32779.96),
		Q(1300, 1324, "Ship Steward", "ShipQuest2", 1, 968.80, 125.09, 33244.12, 919.43, 129.55, 33436.03),
		Q(1325, 1349, "Ship Officer", "ShipQuest2", 2, 968.80, 125.09, 33244.12, 1036.01, 181.43, 33315.72),
		Q(1350, 1374, "Arctic Warrior", "FrostQuest", 1, 5668.13, 28.52, -6483.33, 5935.45, 77.26, -6472.75),
		Q(1375, 1424, "Snow Lurker", "FrostQuest", 2, 5668.13, 28.52, -6483.33, 5628.48, 57.57, -6618.34),
		Q(1425, 1449, "Sea Soldier", "ForgottenQuest", 1, -3054.58, 236.87, -10147.78, -3185.01, 58.78, -9663.60),
		Q(1450, 1499, "Water Fighter", "ForgottenQuest", 2, -3054.58, 236.87, -10147.78, -3262.93, 298.69, -10552.53),
	}
	local Sea3 = {
		Q(1500, 1524, "Pirate Millionaire", "PiratePortQuest", 1, -290.07, 42.90, 5581.59, -245.99, 47.31, 5584.10),
		Q(1525, 1574, "Pistol Billionaire", "PiratePortQuest", 2, -290.07, 42.90, 5581.59, -187.33, 86.24, 6013.51),
		Q(1575, 1599, "Dragon Crew Warrior", "AmazonQuest", 1, 5832.83, 51.69, -1101.51, 6141.14, 51.35, -1340.74),
		Q(1600, 1624, "Dragon Crew Archer", "AmazonQuest", 2, 5832.83, 51.69, -1101.51, 6616.42, 441.77, 446.04),
		Q(1625, 1649, "Female Islander", "AmazonQuest2", 1, 5448.86, 601.52, 751.13, 4685.26, 735.80, 815.34),
		Q(1650, 1699, "Giant Islander", "AmazonQuest2", 2, 5448.86, 601.52, 751.13, 4729.09, 590.44, -36.97),
		Q(1700, 1724, "Marine Commodore", "MarineTreeIsland", 1, 2179.99, 28.73, -6740.06, 2286.00, 73.13, -7159.81),
		Q(1725, 1774, "Marine Rear Admiral", "MarineTreeIsland", 2, 2179.99, 28.73, -6740.06, 3656.77, 160.52, -7001.60),
		Q(1775, 1799, "Fishman Raider", "DeepForestIsland3", 1, -10581.66, 330.87, -8761.19, -10407.53, 331.76, -8368.52),
		Q(1800, 1824, "Fishman Captain", "DeepForestIsland3", 2, -10581.66, 330.87, -8761.19, -10994.70, 352.38, -9002.11),
		Q(1825, 1849, "Forest Pirate", "DeepForestIsland", 1, -13234.04, 331.49, -7625.40, -13274.48, 332.38, -7769.58),
		Q(1850, 1899, "Mythological Pirate", "DeepForestIsland", 2, -13234.04, 331.49, -7625.40, -13680.61, 501.08, -6991.19),
		Q(1900, 1924, "Jungle Pirate", "DeepForestIsland2", 1, -12680.38, 389.97, -9902.02, -12256.16, 331.74, -10485.84),
		Q(1925, 1974, "Musketeer Pirate", "DeepForestIsland2", 2, -12680.38, 389.97, -9902.02, -13457.90, 391.55, -9859.18),
		Q(1975, 1999, "Reborn Skeleton", "HauntedQuest1", 1, -9479.22, 141.22, 5566.09, -8763.72, 165.72, 6159.86),
		Q(2000, 2024, "Living Zombie", "HauntedQuest1", 2, -9479.22, 141.22, 5566.09, -10144.13, 138.63, 5838.09),
		Q(2025, 2049, "Demonic Soul", "HauntedQuest2", 1, -9516.99, 178.01, 6078.99, -9505.87, 172.10, 6158.99),
		Q(2050, 2074, "Posessed Mummy", "HauntedQuest2", 2, -9516.99, 178.01, 6078.99, -9582.02, 6.25, 6205.48),
		Q(2075, 2099, "Peanut Scout", "NutsIslandQuest", 1, -2104.39, 38.13, -10194.22, -2143.24, 47.72, -10029.99),
		Q(2100, 2124, "Peanut President", "NutsIslandQuest", 2, -2104.39, 38.13, -10194.22, -1859.35, 38.10, -10422.43),
		Q(2125, 2149, "Ice Cream Chef", "IceCreamIslandQuest", 1, -820.65, 65.82, -10965.80, -872.24, 65.82, -10919.96),
		Q(2150, 2199, "Ice Cream Commander", "IceCreamIslandQuest", 2, -820.65, 65.82, -10965.80, -558.06, 112.05, -11290.77),
		Q(2200, 2224, "Cookie Crafter", "CakeQuest1", 1, -2021.32, 37.80, -12028.73, -2374.14, 37.80, -12125.30),
		Q(2225, 2249, "Cake Guard", "CakeQuest1", 2, -2021.32, 37.80, -12028.73, -1598.31, 43.77, -12244.58),
		Q(2250, 2274, "Baking Staff", "CakeQuest2", 1, -1927.92, 37.80, -12842.54, -1887.80, 77.62, -12998.35),
		Q(2275, 2299, "Head Baker", "CakeQuest2", 2, -1927.92, 37.80, -12842.54, -2216.19, 82.88, -12869.29),
		Q(2300, 2324, "Cocoa Warrior", "ChocQuest1", 1, 233.22, 29.88, -12201.23, -21.55, 80.57, -12352.38),
		Q(2325, 2349, "Chocolate Bar Battler", "ChocQuest1", 2, 233.22, 29.88, -12201.23, 582.59, 77.19, -12463.16),
		Q(2350, 2374, "Sweet Thief", "ChocQuest2", 1, 148.65, 29.88, -12204.59, 165.18, 76.06, -12600.83),
		Q(2375, 2399, "Candy Rebel", "ChocQuest2", 2, 148.65, 29.88, -12204.59, 134.86, 77.25, -12876.54),
	}
	seaIndex = function()
		local id = game.PlaceId
		if id == 2753915549 then return 1 elseif id == 4442272183 then return 2 elseif id == 7449423635 then return 3 end
		local lvl = dataVal("Level") or 1
		if lvl >= 1500 then return 3 elseif lvl >= 700 then return 2 end
		return 1
	end
	local function seaTable() local i = seaIndex() return i == 1 and Sea1 or (i == 2 and Sea2 or Sea3) end
	questFor = function(lvl)
		for _, e in ipairs(seaTable()) do
			if lvl >= e.min and lvl <= e.max then return e end
		end
	end
	for _, e in ipairs(seaTable()) do
		if e.ql == 1 then
			local label = e.mob .. " (Lv " .. e.min .. ")"
			table.insert(ZoneNames, label)
			ZoneMap[label] = e
		end
	end
	if State.Zone == "" and ZoneNames[1] then State.Zone = ZoneNames[1] end

	local lastQuest, lastAbandon = 0, 0
	local function questVisible()
		local ok, v = pcall(function() return lp.PlayerGui.Main.Quest.Visible end)
		return ok and v
	end
	local function questTitle()
		local ok, v = pcall(function() return lp.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text end)
		return ok and tostring(v) or ""
	end
	loop(0.1, function()
		if not State.AutoLevel then return end
		if not root() then return end
		if State.AutoEquip then equipWeapon() end
		local e = questFor(dataVal("Level") or 1)
		if not e then
			local t = nearestMob()
			if t then hoverTo(t.Position) end
			return
		end
		local vis = questVisible()
		if vis and not questTitle():lower():find(e.mob:sub(1, 5):lower(), 1, true) and tick() - lastAbandon > 15 then
			invoke("AbandonQuest")
			lastAbandon = tick()
			vis = false
		end
		if not vis then
			if tick() - lastQuest > 1.5 then
				goTo(CFrame.new(e.q + Vector3.new(0, 3, 0)))
				task.wait(0.3)
				invoke("StartQuest", e.qn, e.ql)
				lastQuest = tick()
			end
			return
		end
		local t = nearestMob(e.mob)
		if t then hoverTo(t.Position) else goTo(CFrame.new(e.m + Vector3.new(0, State.Height, 0))) end
	end)
end

-- farm manual / boss / elite / click / coleta / haki / stats
do
	loop(0.02, function()
		if not State.Farm or State.AutoLevel then return end
		if not root() then return end
		if State.AutoEquip then equipWeapon() end
		local t = nearestMob()
		if t then hoverTo(t.Position) end
	end)
	loop(0.05, function()
		if not State.AutoBoss or State.AutoLevel then return end
		if not root() then return end
		if State.AutoEquip then equipWeapon() end
		local t = nearestMob(State.Boss)
		if t then hoverTo(t.Position) end
	end)
	local lastElite = 0
	loop(0.3, function()
		if not State.AutoElite or State.AutoLevel then return end
		if not root() then return end
		local f = workspace:FindFirstChild("Enemies")
		if not f then return end
		local target
		for _, n in ipairs({"Diablo", "Urban", "Deandre"}) do
			local m = f:FindFirstChild(n)
			local h = m and m:FindFirstChildOfClass("Humanoid")
			if m and h and h.Health > 0 and m:FindFirstChild("HumanoidRootPart") then target = m.HumanoidRootPart break end
		end
		if target then
			if State.AutoEquip then equipWeapon() end
			hoverTo(target.Position)
		elseif tick() - lastElite > 10 then
			lastElite = tick()
			invoke("EliteHunter")
		end
	end)
	task.spawn(function()
		while alive do
			task.wait(math.max(State.ClickDelay, 20) / 1000)
			if State.Click or State.Farm or State.AutoLevel or State.AutoBoss or State.AutoElite then
				pcall(function() VU:CaptureController(); VU:ClickButton1(Vector2.new(900, 500)) end)
			end
		end
	end)
	loop(0.3, function()
		if not State.Chest then return end
		local r = root()
		if not r then return end
		local best, bd
		for _, c in ipairs(CS:GetTagged("_ChestTagged")) do
			if c.Parent then
				local p = c:GetPivot().Position
				local d = (p - r.Position).Magnitude
				if not bd or d < bd then best, bd = p, d end
			end
		end
		if best then goTo(CFrame.new(best + Vector3.new(0, 2, 0))) end
	end)
	loop(0.6, function()
		if not State.FruitGrab then return end
		local f = findFruit()
		if f then goTo(f.Handle.CFrame) end
	end)
	loop(1.5, function()
		if State.Buso and lp.Character and not lp.Character:FindFirstChild("HasBuso") then invoke("Buso") end
	end)
	loop(4, function()
		if State.Ken then
			local rem = RepStorage:FindFirstChild("Remotes")
			local ce = rem and rem:FindFirstChild("CommE")
			if ce then ce:FireServer("Ken", true) end
		end
	end)
	loop(1, function()
		if State.AutoStats then invoke("AddPoint", State.Stat, State.StatPoints) end
	end)
end

-- códigos
local Codes = {list = {"Sub2UncleKizaru", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "fudd10", "FUDD10_V2",
	"Bignews", "TheGreatAce", "Sub2NoobMaster123", "Sub2Daigrock", "Axiore", "StrawHatMaine", "KITT_RESET", "Sub2OfficialNoobie",
	"NOMOREHACK", "BANEXPLOIT", "TRIPLEABUSE", "NEWTROLL", "CODE_SERVICE", "SECRET_ADMIN", "3BVISITS", "2BILLION", "1MLIKES"}}
do
	local lines, redeeming = {}, false
	local function logCode(line)
		table.insert(lines, line)
		while #lines > 7 do table.remove(lines, 1) end
		if Codes.log then Codes.log.Text = table.concat(lines, "\n") end
	end
	Codes.one = function(code)
		local rem = RepStorage:FindFirstChild("Remotes")
		local rd = rem and rem:FindFirstChild("Redeem")
		if not rd then logCode(code .. " → remote não encontrado") return end
		local ok, res = pcall(function() return rd:InvokeServer(code) end)
		logCode(code .. " → " .. string.sub(ok and tostring(res) or "falhou", 1, 34))
	end
	Codes.all = function()
		if redeeming then return end
		redeeming = true
		notify("Códigos", "Resgatando " .. #Codes.list .. " códigos...", 3)
		for _, c in ipairs(Codes.list) do
			if not alive then break end
			Codes.one(c)
			task.wait(1.4)
		end
		redeeming = false
		notify("Códigos", "Terminei! Veja o log na aba Auto.", 3)
	end
end

-- ESP
do
	local folder = new("Folder", {Name = "ESP", Parent = gui})
	local cacheAll = {}
	local function sync(kind, on, targets)
		cacheAll[kind] = cacheAll[kind] or {}
		local cache, seen = cacheAll[kind], {}
		if on then
			for _, t in ipairs(targets()) do
				seen[t.inst] = true
				local e = cache[t.inst]
				if not e then
					local hl = new("Highlight", {Adornee = t.inst, FillTransparency = 0.65, OutlineTransparency = 0, FillColor = t.color, OutlineColor = t.color, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = folder})
					local bb = new("BillboardGui", {Adornee = t.part, Size = UDim2.fromOffset(150, 28), AlwaysOnTop = true, StudsOffset = Vector3.new(0, 3, 0), Parent = folder})
					local lb = new("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, TextColor3 = t.color, TextStrokeTransparency = 0.4, TextSize = 13, Font = Enum.Font.GothamBold, Parent = bb})
					e = {hl, bb, lb}
					cache[t.inst] = e
				end
				e[3].Text = t.text
			end
		end
		for inst, e in pairs(cache) do
			if not seen[inst] or not inst.Parent then
				pcall(function() e[1]:Destroy(); e[2]:Destroy() end)
				cache[inst] = nil
			end
		end
	end
	local function dist(p)
		local r = root()
		return r and math.floor((p - r.Position).Magnitude) or 0
	end
	loop(0.5, function()
		sync("players", State.ESPPlayers, function()
			local list = {}
			for _, p in ipairs(Players:GetPlayers()) do
				local c = p.Character
				local hr = c and c:FindFirstChild("HumanoidRootPart")
				local h = c and c:FindFirstChildOfClass("Humanoid")
				if p ~= lp and hr and h then
					table.insert(list, {inst = c, part = hr, color = Color3.fromRGB(255, 85, 85), text = p.DisplayName .. " [" .. dist(hr.Position) .. "m] " .. math.floor(h.Health) .. "HP"})
				end
			end
			return list
		end)
		sync("fruits", State.ESPFruits, function()
			local list = {}
			for _, v in ipairs(workspace:GetChildren()) do
				if (v:IsA("Tool") or v:IsA("Model")) and v.Name:lower():find("fruit") and v:FindFirstChild("Handle") then
					table.insert(list, {inst = v, part = v.Handle, color = Color3.fromRGB(255, 196, 60), text = v.Name .. " [" .. dist(v.Handle.Position) .. "m]"})
				end
			end
			return list
		end)
		sync("chests", State.ESPChests, function()
			local list = {}
			for _, c in ipairs(CS:GetTagged("_ChestTagged")) do
				if c.Parent then
					local part = c:IsA("BasePart") and c or c:FindFirstChildWhichIsA("BasePart", true)
					if part then table.insert(list, {inst = c, part = part, color = Color3.fromRGB(90, 220, 255), text = "Baú [" .. dist(part.Position) .. "m]"}) end
				end
			end
			return list
		end)
	end)
end

-- ambiente
local applyLight, applyWater, boostFPS
do
	local orig = {Brightness = Lighting.Brightness, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient}
	applyLight = function()
		if State.Fullbright then
			Lighting.Brightness = 2
			Lighting.GlobalShadows = false
			Lighting.Ambient = Color3.fromRGB(200, 200, 200)
			Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
		else
			Lighting.Brightness = orig.Brightness
			Lighting.GlobalShadows = orig.GlobalShadows
			Lighting.Ambient = orig.Ambient
			Lighting.OutdoorAmbient = orig.OutdoorAmbient
		end
		Lighting.FogEnd = State.NoFog and 1e6 or orig.FogEnd
	end
	local waterOrig
	applyWater = function()
		pcall(function()
			local w = workspace.Map["WaterBase-Plane"]
			waterOrig = waterOrig or w.Size
			w.Size = State.Water and Vector3.new(1000, 112, 1000) or waterOrig
		end)
	end
	boostFPS = function()
		pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
		Lighting.GlobalShadows = false
		for _, d in ipairs(workspace:GetDescendants()) do
			if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then d.Enabled = false
			elseif d:IsA("BasePart") then d.CastShadow = false end
		end
		notify("FPS", "Modo desempenho ativado!", 2.5)
	end
end

-- movimento
local stopMove
do
	local flyBV, holdBV
	local function stopFly() if flyBV then flyBV:Destroy() flyBV = nil end end
	local function stopHold() if holdBV then holdBV:Destroy() holdBV = nil end end
	stopMove = function() pcall(stopFly); pcall(stopHold) end
	conn(RS.Heartbeat:Connect(function()
		local c, h, r = lp.Character, hum(), root()
		if not c or not h or not r then return end
		if State.SpeedOn then h.WalkSpeed = State.Speed end
		if State.JumpOn then h.UseJumpPower = true; h.JumpPower = State.Jump end
		if State.Fly then
			stopHold()
			if not flyBV or flyBV.Parent ~= r then
				stopFly()
				flyBV = Instance.new("BodyVelocity")
				flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
				flyBV.Velocity = Vector3.zero
				flyBV.Parent = r
			end
			local md, look = h.MoveDirection, cam.CFrame.LookVector
			local vel = md * State.FlySpeed
			if md.Magnitude > 0 then
				local s = md:Dot(Vector3.new(look.X, 0, look.Z))
				vel = vel + Vector3.new(0, look.Y * State.FlySpeed * (s >= 0 and 1 or -1), 0)
			end
			flyBV.Velocity = vel
		else
			stopFly()
			if anyAuto() then
				if not holdBV or holdBV.Parent ~= r then
					stopHold()
					holdBV = Instance.new("BodyVelocity")
					holdBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
					holdBV.Velocity = Vector3.zero
					holdBV.Parent = r
				end
			else
				stopHold()
			end
		end
	end))
	conn(RS.Stepped:Connect(function()
		if (State.Noclip or anyAuto()) and lp.Character then
			for _, p in ipairs(lp.Character:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide = false end
			end
		end
	end))
	conn(UIS.JumpRequest:Connect(function()
		if State.InfJump then
			local h = hum()
			if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end))
	conn(lp.Idled:Connect(function() VU:CaptureController(); VU:ClickButton1(Vector2.new()) end))
	conn(game:GetService("GuiService").ErrorMessageChanged:Connect(function()
		if State.AutoRejoin then task.wait(2); pcall(function() TPS:Teleport(game.PlaceId, lp) end) end
	end))
end

-- fonte do jogo
local refreshGameFont
do
	local orig = setmetatable({}, {__mode = "k"})
	local function apply(inst)
		if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
			if orig[inst] == nil then orig[inst] = inst.Font end
			if State.GameFont == "Padrão" then
				inst.Font = orig[inst]
			else
				inst.Font = getFont(State.GameFont, tostring(orig[inst]):find("Bold") ~= nil)
			end
		end
	end
	refreshGameFont = function()
		local pg = lp:FindFirstChild("PlayerGui")
		if not pg then return end
		for _, d in ipairs(pg:GetDescendants()) do pcall(apply, d) end
	end
	conn(lp:WaitForChild("PlayerGui").DescendantAdded:Connect(function(d)
		if State.GameFont ~= "Padrão" then task.defer(pcall, apply, d) end
	end))
end

local function serverHop()
	notify("Server Hop", "Procurando servidor...", 3)
	local ok, data = pcall(function()
		return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
	end)
	if ok and data and data.data then
		for _, s in ipairs(data.data) do
			if s.id ~= game.JobId and s.playing < s.maxPlayers - 1 then
				TPS:TeleportToPlaceInstance(game.PlaceId, s.id, lp)
				return
			end
		end
	end
	notify("Server Hop", "Nenhum servidor encontrado.", 3)
end

-- sessão (estatísticas) + skills / hitbox / frutas
local Sess = {t0 = tick(), beli0 = nil, lvl0 = nil, last = nil, samples = {}, fruits = 0}
local applyHitbox
do
	loop(1, function()
		local b, l = dataVal("Beli"), dataVal("Level")
		if b and not Sess.beli0 then Sess.beli0 = b; Sess.last = b end
		if l and not Sess.lvl0 then Sess.lvl0 = l end
	end)
	loop(30, function()
		local b = dataVal("Beli")
		if b and Sess.last then
			table.insert(Sess.samples, math.max(0, b - Sess.last))
			Sess.last = b
			while #Sess.samples > 24 do table.remove(Sess.samples, 1) end
			if Sess.chart then Sess.chart(Sess.samples) end
		end
	end)
	loop(10, function()
		table.insert(Perf.samples, Perf.fps)
		while #Perf.samples > 24 do table.remove(Perf.samples, 1) end
		if Perf.chart then Perf.chart(Perf.samples) end
	end)
	Sess.gain = function() local b = dataVal("Beli") return (b and Sess.beli0) and (b - Sess.beli0) or 0 end
	Sess.hours = function() return math.max((tick() - Sess.t0) / 3600, 0.01) end
	Sess.beliRate = function() return math.floor(Sess.gain() / Sess.hours()) end
	Sess.lvlGain = function() local l = dataVal("Level") return (l and Sess.lvl0) and (l - Sess.lvl0) or 0 end
	Sess.reset = function()
		Sess.t0 = tick(); Sess.beli0 = dataVal("Beli"); Sess.last = Sess.beli0; Sess.lvl0 = dataVal("Level"); Sess.samples = {}; Sess.fruits = 0
		if Sess.chart then Sess.chart(Sess.samples) end
	end

	local keys = {SkillZ = Enum.KeyCode.Z, SkillX = Enum.KeyCode.X, SkillC = Enum.KeyCode.C, SkillV = Enum.KeyCode.V, SkillF = Enum.KeyCode.F}
	task.spawn(function()
		while alive do
			task.wait(math.max(State.SkillDelay, 150) / 1000)
			if VIM then
				for key, code in pairs(keys) do
					if State[key] then
						pcall(function()
							VIM:SendKeyEvent(true, code, false, game)
							task.wait(0.05)
							VIM:SendKeyEvent(false, code, false, game)
						end)
					end
				end
			end
		end
	end)
	local orig = setmetatable({}, {__mode = "k"})
	applyHitbox = function()
		local f = workspace:FindFirstChild("Enemies")
		if not f then return end
		for _, m in ipairs(f:GetChildren()) do
			local mr = m:FindFirstChild("HumanoidRootPart")
			if mr then
				if State.Hitbox then
					orig[mr] = orig[mr] or {mr.Size, mr.Transparency}
					local s = State.HitboxSize
					mr.Size = Vector3.new(s, s, s)
					mr.Transparency = 0.85
					mr.CanCollide = false
				elseif orig[mr] then
					mr.Size = orig[mr][1]
					mr.Transparency = orig[mr][2]
				end
			end
		end
	end
	loop(1, function() if State.Hitbox then applyHitbox() end end)

	local notified = setmetatable({}, {__mode = "k"})
	local joinTick = tick()
	loop(2, function()
		local f = findFruit()
		if f and not notified[f] then
			notified[f] = true
			Sess.fruits = Sess.fruits + 1
			if State.FruitNotify then notify("Fruta spawnou!", f.Name, 4) end
		end
		if State.FruitHop and not f and tick() - joinTick > 14 then
			joinTick = tick() + 60
			serverHop()
		end
	end)
	loop(3, function()
		if not State.AutoStore then return end
		for _, cont in ipairs({lp:FindFirstChild("Backpack"), lp.Character}) do
			if cont then
				for _, t in ipairs(cont:GetChildren()) do
					if t:IsA("Tool") and t.ToolTip == "Blox Fruit" then
						invoke("StoreFruit", t:GetAttribute("OriginalName") or t.Name, t)
					end
				end
			end
		end
	end)
	loop(15, function() if State.AutoRandom then invoke("Cousin", "Buy") end end)
end

------------------------------------------------------------------
-- APPLY / PERFIS / BOTÕES FLUTUANTES
------------------------------------------------------------------
local function setKey(k, v)
	State[k] = v
	if ctl[k] then pcall(ctl[k], v) end
end
local function toggleByKey(key)
	local e = RegByKey[key]
	setKey(key, not State[key])
	if e and e.cb then pcall(e.cb, State[key]) end
end
local function refreshEffects()
	pcall(applyLight)
	pcall(applyWater)
	pcall(applyHitbox)
end
local function applyProfile(t)
	for k, v in pairs(t) do setKey(k, v) end
	refreshEffects()
end
local function applyAll()
	setCorners()
	applyPanel()
	applyBubble()
	applyLayout()
	setTextScale()
	setPanelFont(State.PanelFont)
	applyTabs()
	restyleButtons()
	rebuildParticles()
	updateBlur()
	buildCross()
	Streamer.apply()
	if Themes[State.Theme] then applyTheme(State.Theme) end
	refreshGameFont()
end
local function applyKeys(tbl)
	for k, v in pairs(tbl) do
		if State[k] ~= nil then
			State[k] = v
			if ctl[k] then pcall(ctl[k], v) end
		end
	end
	applyAll()
end

-- botões flutuantes (atalhos na tela, ótimos no celular)
local Floats = {}
do
	local folder = new("Folder", {Name = "Floats", Parent = gui})
	local live = {}
	local function initials(text)
		local s = ""
		for w in text:gmatch("%a+") do
			s = s .. w:sub(1, 1):upper()
			if #s >= 2 then break end
		end
		return s ~= "" and s or "•"
	end
	Floats.make = function(entry)
		local e = RegByKey[entry.key]
		if not e or live[entry.key] then return end
		local b = new("TextButton", {Size = UDim2.fromOffset(46, 46), Position = UDim2.new(entry.x or 0.85, 0, entry.y or 0.3, 0), BackgroundColor3 = WHITE, Text = "", AutoButtonColor = false, Parent = folder},
			{new("UICorner", {CornerRadius = UDim.new(0.5, 0)})})
		local g = new("UIGradient", {Rotation = 45, Parent = b})
		new("UIStroke", {Color = WHITE, Transparency = 0.6, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = b})
		new("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = initials(e.text), Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = WHITE, Parent = b})
		local function paint()
			if State[entry.key] then
				g.Color = ColorSequence.new(T.accent, T.accent2)
				b.BackgroundTransparency = 0
			else
				g.Color = ColorSequence.new(Color3.fromRGB(78, 78, 90), Color3.fromRGB(52, 52, 60))
				b.BackgroundTransparency = 0.1
			end
		end
		paint()
		local st = drag(b, b, {onEnd = function()
			local ap, vp = b.AbsolutePosition, cam.ViewportSize
			entry.x, entry.y = ap.X / vp.X, ap.Y / vp.Y
		end})
		b.MouseButton1Click:Connect(function()
			if st.moved then return end
			toggleByKey(entry.key)
			paint()
		end)
		live[entry.key] = {b = b, paint = paint}
	end
	Floats.add = function(key)
		if not RegByKey[key] then return end
		for _, en in ipairs(State.Floats) do if en.key == key then return end end
		local entry = {key = key, x = 0.84, y = math.min(0.2 + 0.09 * #State.Floats, 0.85)}
		table.insert(State.Floats, entry)
		Floats.make(entry)
	end
	Floats.remove = function(key)
		if live[key] then live[key].b:Destroy(); live[key] = nil end
		for i = #State.Floats, 1, -1 do if State.Floats[i].key == key then table.remove(State.Floats, i) end end
	end
	Floats.clear = function()
		for k in pairs(live) do if live[k] then live[k].b:Destroy() end end
		live = {}
		State.Floats = {}
	end
	Floats.load = function()
		for _, entry in ipairs(State.Floats) do pcall(Floats.make, entry) end
	end
	loop(0.5, function() for _, v in pairs(live) do v.paint() end end)
	table.insert(binders, function() for _, v in pairs(live) do v.paint() end end)
end

-- assistente (sugestões pelo seu progresso)
local function suggest()
	local out = {}
	local lvl = dataVal("Level") or 1
	local sea = seaIndex()
	local function add(txt, fn) table.insert(out, {txt, fn}) end
	if not State.AutoLevel and lvl <= 2399 then add("Ligue o Auto Level para subir de nível sozinho.", function() setKey("AutoLevel", true) end) end
	if sea == 1 and lvl >= 700 then add("Você já pode ir para o Segundo Mar.", function() invoke("TravelDressrosa") end) end
	if sea == 2 and lvl >= 1500 then add("Você já pode ir para o Terceiro Mar.", function() invoke("TravelZou") end) end
	if not State.Buso and not (lp.Character and lp.Character:FindFirstChild("HasBuso")) then add("Ative o Auto Buso Haki.", function() setKey("Buso", true) end) end
	if not State.AutoStats then add("Ligue o Auto Status para gastar seus pontos.", function() setKey("AutoStats", true) end) end
	if lvl > 2399 then add("Acima do level 2399 não há dados de quest: use Auto Farm ou Auto Boss.", function() setKey("Farm", true) end) end
	if (dataVal("Beli") or 0) > 250000 then add("Beli sobrando! Compre uma fruta aleatória.", function() invoke("Cousin", "Buy") end) end
	if #out == 0 then add("Tudo certo! Continue farmando.", function() end) end
	return out
end

------------------------------------------------------------------
-- WIDGETS NA TELA + JANELA RÁPIDA
------------------------------------------------------------------
local Widgets = {}
do
	local wf = new("Folder", {Name = "Widgets", Parent = gui})
	local list = {}
	local function mk(id, title, get)
		local idx = #list + 1
		local sp = State.WPos[id]
		local f = new("CanvasGroup", {Name = id, Size = UDim2.fromOffset(170, 54),
			Position = sp and UDim2.new(sp[1], 0, sp[2], 0) or UDim2.fromOffset(12, 56 + (idx - 1) * 62),
			BackgroundColor3 = T.bg, BackgroundTransparency = State.WAlpha / 100, Visible = State["W_" .. id] and true or false, Parent = wf}, {rc(14)})
		bind(f, "BackgroundColor3", "bg")
		glass(f, 0.8)
		local sc = new("UIScale", {Scale = State.WScale / 100, Parent = f})
		local bar = new("Frame", {Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = f})
		bind(new("UIGradient", {Rotation = 90, Parent = bar}), "Color", function() return ColorSequence.new(T.accent, T.accent2) end, true)
		mkText({Size = UDim2.new(1, -20, 0, 16), Position = UDim2.fromOffset(14, 6), Text = title, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = f}, true, "sub")
		local val = mkText({Size = UDim2.new(1, -20, 0, 26), Position = UDim2.fromOffset(14, 22), Text = "—", TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f}, true)
		drag(f, f, {
			locked = function() return State.WLock end,
			onEnd = function()
				local ap, vp = f.AbsolutePosition, cam.ViewportSize
				State.WPos[id] = {ap.X / vp.X, ap.Y / vp.Y}
			end,
		})
		table.insert(list, {id = id, f = f, sc = sc, val = val, get = get})
	end
	mk("Perf", "DESEMPENHO", function() return Perf.fps .. " fps  •  " .. getPing() .. " ms" end)
	mk("Level", "LEVEL", function() local l = dataVal("Level") return (l and ("Lv " .. commas(l)) or "Lv —") .. "  •  Mar " .. seaIndex() end)
	mk("Beli", "BELI", function() local b = dataVal("Beli") return (b and commas(b) or "—") .. "  (+" .. commas(Sess.beliRate()) .. "/h)" end)
	mk("Session", "SESSÃO", function() return fmtTime(tick() - Sess.t0) .. "  •  +" .. Sess.lvlGain() .. " lv" end)
	mk("Quest", "FARM", function()
		if State.AutoLevel then local e = questFor(dataVal("Level") or 1) return e and ("Quest: " .. e.mob) or "Sem dados de quest" end
		return (State.Farm or State.AutoBoss or State.AutoElite) and "Farmando..." or "Parado"
	end)
	mk("Fruit", "FRUTA", function()
		local f, r = findFruit(), root()
		if f and r then return f.Name .. "  " .. math.floor((f.Handle.Position - r.Position).Magnitude) .. "m" end
		return "nenhuma no mapa"
	end)
	mk("Clock", "HORA", function() return os.date("%H:%M:%S") end)

	Widgets.refresh = function()
		for _, w in ipairs(list) do
			w.f.Visible = State["W_" .. w.id] and true or false
			if w.f.Visible then
				local ok, v = pcall(w.get)
				w.val.Text = ok and tostring(v) or "—"
			end
		end
	end
	Widgets.style = function()
		for _, w in ipairs(list) do
			w.sc.Scale = State.WScale / 100
			w.f.BackgroundTransparency = State.WAlpha / 100
		end
	end
	Widgets.reset = function()
		State.WPos = {}
		for i, w in ipairs(list) do w.f.Position = UDim2.fromOffset(12, 56 + (i - 1) * 62) end
	end
	loop(0.5, Widgets.refresh)

	local quick = new("CanvasGroup", {Name = "Quick", Size = UDim2.fromOffset(190, 0), AutomaticSize = Enum.AutomaticSize.Y,
		Position = State.WPos.quick and UDim2.new(State.WPos.quick[1], 0, State.WPos.quick[2], 0) or UDim2.new(1, -206, 0.35, 0),
		BackgroundColor3 = T.bg, BackgroundTransparency = State.WAlpha / 100, Visible = State.Quick, Parent = gui}, {rc(16)})
	bind(quick, "BackgroundColor3", "bg")
	glass(quick, 0.8)
	new("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = quick})
	new("UIPadding", {PaddingBottom = UDim.new(0, 8), Parent = quick})
	local qHead = new("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = 0, Parent = quick})
	mkText({Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(12, 0), Text = "⚡ RÁPIDO", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = qHead}, true, "accent")
	drag(qHead, quick, {onEnd = function()
		local ap, vp = quick.AbsolutePosition, cam.ViewportSize
		State.WPos.quick = {ap.X / vp.X, ap.Y / vp.Y}
	end})
	local qs = {}
	for i, k in ipairs({{"Auto Level", "AutoLevel"}, {"Auto Farm", "Farm"}, {"Auto Baús", "Chest"}, {"Auto Frutas", "FruitGrab"}, {"Auto Click", "Click"},
		{"ESP Jogadores", "ESPPlayers"}, {"Voar", "Fly"}, {"Noclip", "Noclip"}}) do
		local key = k[2]
		local rowf = new("Frame", {Size = UDim2.new(1, -16, 0, 26), BackgroundColor3 = T.row, BackgroundTransparency = 0.3, LayoutOrder 
