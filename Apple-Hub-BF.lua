--// Apple Hub v9 | Blox Fruits | Delta Executor (mobile + PC)  — PARTE 1/2
if getgenv and getgenv().AppleHubUnload then pcall(getgenv().AppleHubUnload) end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local CS = game:GetService("CollectionService")
local TPS = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RepStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")
local Market = game:GetService("MarketplaceService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local startTick = tick()
local alive = true
local conns = {}
local function conn(c) table.insert(conns, c) return c end
local frames, fps = 0, 0

local parent = (gethui and gethui()) or CoreGui
pcall(function() local o = parent:FindFirstChild("AppleHub") if o then o:Destroy() end end)
pcall(function() local o = Lighting:FindFirstChild("AppleHubBlur") if o then o:Destroy() end end)

local function autoScalePct()
	local vp = cam.ViewportSize
	return math.clamp(math.floor(math.min(vp.X / 640, vp.Y / 410) * 100), 50, 100)
end

------------------------------------------------------------------
-- ESTADO + CONFIG
------------------------------------------------------------------
local State = {
	Theme = "Midnight", PanelFont = "Gotham", GameFont = "Padrão", Opacity = 0, Corner = 16, Glow = 10,
	Borders = true, AnimGlow = false, Rainbow = false, Blur = false, BlurSize = 14,
	Transition = "Deslizar", Easing = "Quint", TransTime = 420, Title = "Apple Hub  •  Blox Fruits", ToggleKey = "RightShift",
	R = 10, G = 132, B = 255, ScalePct = autoScalePct(),
	PanelW = 600, PanelH = 380, TitleSize = 13, TitleAlign = "Centro", TopLine = true, TopLineH = 3,
	BorderMode = "Vidro", BorderThick = 1, BorderAlpha = 82, RowAlpha = 20, ItemGap = 8, GlowAngle = 35,
	ShowChip = true, ShowCard = true, BubbleSize = 52, BubbleText = "A", BubbleShape = "Redonda",
	NotifyOn = true, NotifyPos = "Direita", SideW = 128, SideAlpha = 20, LockPos = false,
	SoundOn = false, SoundType = "Clique", SoundVol = 50,
	TabStyle = "Preenchido", TabH = 32, TabGap = 3, TabSize = 13, TabIcons = true, TabAlign = "Esquerda", TabCorner = 11,
	BtnStyle = "Gradiente", BtnCorner = 13, BtnH = 40, BtnShine = true, BtnRipple = true, BtnGloss = true,
	BtnTextSize = 13, BtnAngle = 0, BtnHover = true, SwShape = "Pílula",
	PartOn = true, PType = "Neve", PCount = 45, PSpeed = 100, PSize = 8, PWind = 0, PAlpha = 25, PColor = "Original",
	PR = 255, PG = 255, PB = 255, PLayer = "Atrás", PFull = false, PSway = true, PSpin = true, PTwinkle = false, PDir = "Auto",
	IntroOn = true, IntroStyle = "Cinematic", IntroText = "APPLE HUB", IntroSub = "B L O X   F R U I T S", IntroTime = 4,
	IntroColor = "Tema", IR = 10, IG = 132, IB = 255, IntroStars = true, IntroBar = true, IntroBg = 96, IntroTitleSize = 46, IntroSkip = true,
	HudOn = false, HudFPS = true, HudLevel = true, HudBeli = true, HudTime = true, HudRate = true, HudStatus = true, HudScale = 100, HudAlpha = 35,
	Binds = {}, BindFeat = "Auto Level", Pos = {},
	-- farm
	AutoLevel = false, Farm = false, Weapon = "Melee", Height = 8, Click = false, ClickDelay = 80, AutoEquip = true,
	TravelSpeed = 260, AutoBoss = false, Boss = "Saber Expert",
	Chest = false, FruitGrab = false, Buso = false, Ken = false,
	Stat = "Melee", StatPoints = 1, AutoStats = false, AutoCodes = false, Zone = "",
	-- blox extras
	BringMobs = false, BringRadius = 300, SafeMode = false, SafePct = 30, AutoSkills = false, SkillDelay = 900,
	SkillZ = true, SkillX = true, SkillC = false, SkillV = false, SkillF = false,
	AutoStore = false, FruitNotify = false, AutoRoll = false, AutoElite = false, Style = "Black Leg",
	-- visual / player
	ESPPlayers = false, ESPFruits = false, ESPChests = false, ESPBosses = false,
	Fullbright = false, NoFog = false, FOV = 70, Clock = 14,
	SpeedOn = false, Speed = 50, JumpOn = false, Jump = 80, Fly = false, FlySpeed = 60,
	Noclip = false, InfJump = false, Gravity = 196, Water = false, AutoRejoin = false, FPSCap = 60, BlackScreen = false,
}
local CFG_FILE = "AppleHub_v9.json"
local SAVE_KEYS = {}
for k in ("Theme PanelFont GameFont Opacity Corner Glow Borders AnimGlow Rainbow Blur BlurSize Transition Easing TransTime Title ToggleKey R G B ScalePct Weapon Height ClickDelay TravelSpeed Stat StatPoints AutoCodes Boss AutoRejoin PanelW PanelH TitleSize TitleAlign TopLine TopLineH BorderMode BorderThick BorderAlpha RowAlpha ItemGap GlowAngle ShowChip ShowCard BubbleSize BubbleText BubbleShape NotifyOn NotifyPos SideW SideAlpha LockPos SoundOn SoundType SoundVol TabStyle TabH TabGap TabSize TabIcons TabAlign TabCorner BtnStyle BtnCorner BtnH BtnShine BtnRipple BtnGloss BtnTextSize BtnAngle BtnHover SwShape PartOn PType PCount PSpeed PSize PWind PAlpha PColor PR PG PB PLayer PFull PSway PSpin PTwinkle PDir IntroOn IntroStyle IntroText IntroSub IntroTime IntroColor IR IG IB IntroStars IntroBar IntroBg IntroTitleSize IntroSkip HudOn HudFPS HudLevel HudBeli HudTime HudRate HudStatus HudScale HudAlpha Binds Pos BringRadius SafePct SkillDelay SkillZ SkillX SkillC SkillV SkillF Style"):gmatch("%S+") do
	table.insert(SAVE_KEYS, k)
end
local APPEAR_KEYS = {}
for k in ("Theme Opacity Corner Glow Borders AnimGlow Blur BlurSize PanelW PanelH TitleSize TitleAlign TopLine TopLineH BorderMode BorderThick BorderAlpha RowAlpha ItemGap GlowAngle ShowChip ShowCard BubbleSize BubbleText BubbleShape NotifyOn NotifyPos SideW SideAlpha TabStyle TabH TabGap TabSize TabIcons TabAlign TabCorner BtnStyle BtnCorner BtnH BtnShine BtnRipple BtnGloss BtnTextSize BtnAngle BtnHover SwShape PartOn PType PCount PSpeed PSize PWind PAlpha PColor PR PG PB PLayer PFull PSway PSpin PTwinkle PDir ScalePct"):gmatch("%S+") do
	table.insert(APPEAR_KEYS, k)
end
local Default = {}
for _, k in ipairs(SAVE_KEYS) do Default[k] = State[k] end
pcall(function()
	if isfile and isfile(CFG_FILE) then
		local d = HttpService:JSONDecode(readfile(CFG_FILE))
		for _, k in ipairs(SAVE_KEYS) do if d[k] ~= nil then State[k] = d[k] end end
	end
end)
State.Scale = State.ScalePct / 100

------------------------------------------------------------------
-- TEMAS (43)
------------------------------------------------------------------
local function th(bg, side, row, text, sub, a1, a2)
	local f = Color3.fromHex
	return {bg = f(bg), side = f(side), row = f(row), text = f(text), sub = f(sub), accent = f(a1), accent2 = f(a2)}
end
local Themes = {
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
	TokyoNight = th("#14151f", "#1a1b2a", "#24283b", "#c0caf5", "#7a85b0", "#7aa2f7", "#bb9af7"),
	Cyberpunk = th("#0d0221", "#170338", "#261047", "#f0e6ff", "#9a86c9", "#ff2a6d", "#05d9e8"),
	Matrix = th("#020a04", "#06150a", "#0c2614", "#d6ffe0", "#5fa575", "#00ff6a", "#00b34a"),
	Lava = th("#1a0a05", "#2a0f07", "#40170b", "#fff0e6", "#c28a70", "#ff4500", "#ffb300"),
	Neon = th("#0a0a12", "#12121f", "#1c1c30", "#ffffff", "#8a8ab0", "#39ff14", "#00e5ff"),
	Emerald = th("#06140f", "#0b2219", "#12362a", "#e8fff4", "#6fb89a", "#10d98c", "#00a876"),
	Ruby = th("#1a0609", "#2a0d12", "#401520", "#fff0f2", "#c48a92", "#ff2d55", "#c4004a"),
	Royal = th("#0c0a1f", "#14123a", "#1f1c55", "#eeeaff", "#8d89c9", "#7c5cff", "#4a6bff"),
	Mocha = th("#1b1512", "#281f1a", "#3a2d25", "#f5ebe0", "#b39a86", "#d4a373", "#b5835a"),
	Candy = th("#1f1230", "#2e1a45", "#432661", "#fff0fb", "#bc96d6", "#ff7ad9", "#7af0ff"),
	Galaxy = th("#070514", "#0e0a26", "#1a1440", "#efeaff", "#8f86c4", "#9d4edd", "#3a86ff"),
	Ice = th("#0a1620", "#112433", "#1b3a52", "#eaf8ff", "#86b3cc", "#a0e9ff", "#5ec2ff"),
	Forest = th("#0d1a0e", "#15281a", "#203c27", "#ecfff0", "#86b393", "#7bd88f", "#4fae6b"),
	RoseGold = th("#1c1415", "#2a1d1f", "#3d2a2d", "#fff1ef", "#c9a09c", "#f4b6a6", "#e0897a"),
	AMOLED = th("#000000", "#0a0a0a", "#161616", "#ffffff", "#8a8a8a", "#0a84ff", "#64d2ff"),
	Synthwave = th("#120a24", "#1c1038", "#2c1a52", "#fff0ff", "#a98ccf", "#ff00a0", "#00cfff"),
	Lemon = th("#1a1a0a", "#26260f", "#38381a", "#fffff0", "#b8b88a", "#ffe600", "#b8d400"),
	Steel = th("#0f1419", "#171e26", "#212b36", "#e6edf3", "#7d8b99", "#58a6ff", "#2f81f7"),
	Lavender = th("#17141f", "#221d2e", "#302842", "#f3eeff", "#a89ac4", "#b79cff", "#8f7cf2"),
	Coral = th("#1a1010", "#271717", "#3a2323", "#fff1ef", "#c19a97", "#ff6b6b", "#ffa94d"),
	Menta = th("#eefaf4", "#dcefe5", "#ffffff", "#14281e", "#5f7f6e", "#14b87a", "#0a8f5e"),
	Rosa = th("#fdf0f4", "#f6dde5", "#ffffff", "#2c1620", "#8a6676", "#ff4d8d", "#ff8fb3"),
	Abyss = th("#05080f", "#0a1020", "#121c33", "#e6f0ff", "#7188b3", "#3b82f6", "#06b6d4"),
	Toxic = th("#0a1405", "#111f09", "#1b3010", "#efffe0", "#8aae6a", "#a3ff00", "#2bd600"),
	Sand = th("#f6efe2", "#eadfca", "#fffaf0", "#2b2418", "#8a7a5c", "#d98c2b", "#e0a95a"),
	Plum = th("#170a1c", "#231029", "#341a3d", "#fbeaff", "#b48ac0", "#d946ef", "#8b5cf6"),
	Cherry = th("#1c0a10", "#2b1018", "#40192a", "#ffeef2", "#c48a9a", "#ff4d6d", "#c9184a"),
	Peacock = th("#04141a", "#08222c", "#0f3643", "#e4faff", "#74aab8", "#00d4c8", "#0077b6"),
	Twilight = th("#120d24", "#1b1436", "#2a2050", "#f0ecff", "#9a90c8", "#ff9a3c", "#8f6cff"),
	Mono = th("#101010", "#1a1a1a", "#262626", "#ffffff", "#888888", "#ffffff", "#a0a0a0"),
	Blood = th("#0d0000", "#190303", "#2b0808", "#ffeaea", "#b07070", "#e60000", "#8f0000"),
	Sky = th("#eaf6ff", "#d8ecfa", "#ffffff", "#10253a", "#5d7a94", "#1e90ff", "#00bfff"),
}
Themes.Custom = {}
for k, v in pairs(Themes.Midnight) do Themes.Custom[k] = v end
local function updateCustom()
	local a = Color3.fromRGB(State.R, State.G, State.B)
	Themes.Custom.accent = a
	Themes.Custom.accent2 = a:Lerp(Color3.fromRGB(255, 80, 200), 0.45)
end
updateCustom()
local ThemeNames = {"Midnight", "Ocean", "Sunset", "Aurora", "Sakura", "Gold", "Graphite", "Claro", "Dracula", "Nord", "TokyoNight",
	"Cyberpunk", "Matrix", "Lava", "Neon", "Emerald", "Ruby", "Royal", "Mocha", "Candy", "Galaxy", "Ice", "Forest", "RoseGold",
	"AMOLED", "Synthwave", "Lemon", "Steel", "Lavender", "Coral", "Menta", "Rosa", "Abyss", "Toxic", "Sand", "Plum", "Cherry",
	"Peacock", "Twilight", "Mono", "Blood", "Sky", "Custom"}
local T = Themes[State.Theme] or Themes.Midnight

------------------------------------------------------------------
-- FONTES
------------------------------------------------------------------
local FontOrder = {"Gotham", "GothamMedium", "SourceSans", "SourceSansLight", "Arial", "Roboto", "RobotoCondensed", "RobotoMono", "Ubuntu",
	"Nunito", "Oswald", "Jura", "Michroma", "FredokaOne", "Merriweather", "JosefinSans", "TitilliumWeb", "Sarpanch", "Code", "SciFi",
	"Arcade", "Highway", "Cartoon", "Bangers", "LuckiestGuy", "IndieFlower", "PatrickHand", "Kalam", "AmaticSC", "PermanentMarker",
	"SpecialElite", "DenkOne", "Fondamento", "Garamond", "Bodoni", "Antique", "Fantasy", "Creepster", "GrenzeGotisch"}
local BoldMap = {Gotham = "GothamBold", GothamMedium = "GothamBold", SourceSans = "SourceSansBold", SourceSansLight = "SourceSansBold", Arial = "ArialBold"}
local function getFont(name, bold)
	local en = (bold and BoldMap[name]) or name
	local ok, f = pcall(function() return Enum.Font[en] end)
	return (ok and f) or Enum.Font.Gotham
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
local cornerList = {}
local function rc(base)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, math.floor(base * State.Corner / 16 + 0.5))
	table.insert(cornerList, {c, base})
	return c
end
local function setCorners()
	for _, e in ipairs(cornerList) do
		pcall(function() e[1].CornerRadius = UDim.new(0, math.floor(e[2] * State.Corner / 16 + 0.5)) end)
	end
end

local binders, fastBinders, fontObjs, tabRefresh = {}, {}, {}, {}
local rowList, syncers, swList, btnList, pageLayouts, strokeList = {}, {}, {}, {}, {}, {}
local refreshThemeCards
local recolorParts
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
local function glass(obj, tr)
	local s = new("UIStroke", {Thickness = 1, Transparency = tr or 0.9, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = State.Borders, Parent = obj})
	bind(s, "Color", "text")
	table.insert(strokeList, s)
	return s
end
local function regFont(o, bold)
	table.insert(fontObjs, {o, bold})
	o.Font = getFont(State.PanelFont, bold)
end
local function setPanelFont(name)
	State.PanelFont = name
	for _, e in ipairs(fontObjs) do pcall(function() e[1].Font = getFont(name, e[2]) end) end
end
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
	local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
	return ok and math.floor(v) or 0
end
local function gradSeq() return ColorSequence.new(T.accent, T.accent2) end

-- sons de UI
local SoundIds = {["Clique"] = "rbxasset://sounds/button.wav", ["Switch"] = "rbxasset://sounds/switch.wav", ["Snap"] = "rbxasset://sounds/snap.mp3"}
local function uiSound()
	if not State.SoundOn then return end
	pcall(function()
		local s = Instance.new("Sound")
		s.SoundId = SoundIds[State.SoundType] or SoundIds["Clique"]
		s.Volume = State.SoundVol / 100
		s.Parent = game:GetService("SoundService")
		s:Play()
		game:GetService("Debris"):AddItem(s, 2)
	end)
end

-- busca
local searchItems = {}
local function regSearch(frame, text, isSection)
	table.insert(searchItems, {f = frame, t = string.lower(text or ""), s = isSection})
end
local function applySearch(q)
	q = string.lower(q or "")
	for _, it in ipairs(searchItems) do
		pcall(function()
			if q == "" then it.f.Visible = true
			elseif it.s then it.f.Visible = false
			else it.f.Visible = it.t:find(q, 1, true) ~= nil end
		end)
	end
end

------------------------------------------------------------------
-- GUI BASE
------------------------------------------------------------------
local gui = new("ScreenGui", {Name = "AppleHub", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
gui.Parent = parent

local W, H = State.PanelW, State.PanelH
local main = new("CanvasGroup", {
	Name = "Main", Size = UDim2.fromOffset(W, H), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
	BackgroundColor3 = T.bg, BackgroundTransparency = State.Opacity / 100, BorderSizePixel = 0, GroupTransparency = 1, Parent = gui,
}, {rc(22)})
bind(main, "BackgroundColor3", "bg")
local uiscale = new("UIScale", {Scale = State.Scale * 0.88, Parent = main})
local mainStroke = glass(main, State.BorderAlpha / 100)
local borderBind = bind(mainStroke, "Color", function() return State.BorderMode == "Destaque" and T.accent or T.text end, true)

local glow = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1 - State.Glow / 100, BorderSizePixel = 0, ZIndex = 0, Parent = main})
local glowG = new("UIGradient", {Rotation = State.GlowAngle, Parent = glow})
bind(glowG, "Color", gradSeq, true)

local topLine = new("Frame", {Size = UDim2.new(1, 0, 0, State.TopLineH), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 5, Visible = State.TopLine, Parent = main})
bind(new("UIGradient", {Parent = topLine}), "Color", gradSeq, true)

local shown = true
local blur = new("BlurEffect", {Name = "AppleHubBlur", Size = 0, Parent = Lighting})
local function updateBlur()
	tween(blur, 0.4, {Size = (State.Blur and shown) and State.BlurSize or 0})
end

local notifLay = new("UIListLayout", {VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder})
local notifHolder = new("Frame", {Size = UDim2.new(0, 260, 1, -20), Position = UDim2.new(1, -270, 0, 10), BackgroundTransparency = 1, ZIndex = 60, Parent = gui}, {notifLay})
local function applyNotifyPos()
	local p = State.NotifyPos
	if p == "Esquerda" then
		notifHolder.AnchorPoint = Vector2.new(0, 0); notifHolder.Position = UDim2.new(0, 10, 0, 10)
		notifLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
	elseif p == "Centro" then
		notifHolder.AnchorPoint = Vector2.new(0.5, 0); notifHolder.Position = UDim2.new(0.5, 0, 0, 10)
		notifLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
	else
		notifHolder.AnchorPoint = Vector2.new(0, 0); notifHolder.Position = UDim2.new(1, -270, 0, 10)
		notifLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
	end
end
local function notify(title, msg, dur)
	if not State.NotifyOn then return end
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
local function dot(x, color)
	return new("TextButton", {Size = UDim2.fromOffset(13, 13), Position = UDim2.fromOffset(x, 15), BackgroundColor3 = color, Text = "", AutoButtonColor = false, Parent = top}, {corner(7)})
end
local red = dot(16, Color3.fromRGB(255, 95, 87))
local yellow = dot(36, Color3.fromRGB(254, 188, 46))
dot(56, Color3.fromRGB(40, 200, 64))
local titleLabel = mkText({Size = UDim2.new(1, 0, 1, 0), Text = State.Title, TextSize = State.TitleSize, Parent = top}, true, "sub")
local chipLabel = mkText({Size = UDim2.fromOffset(130, 40), Position = UDim2.new(1, -142, 0, 0), Text = "-- FPS", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, Parent = top}, true, "accent")
local searchBox = new("TextBox", {Size = UDim2.fromOffset(110, 24), Position = UDim2.fromOffset(80, 8), BackgroundColor3 = T.row, BackgroundTransparency = 0.35, Text = "",
	PlaceholderText = "Buscar...", TextSize = 12, ClearTextOnFocus = false, TextColor3 = T.text, PlaceholderColor3 = T.sub, ZIndex = 3, Parent = top}, {corner(8)})
regFont(searchBox, false)
bind(searchBox, "BackgroundColor3", "row"); bind(searchBox, "TextColor3", "text"); bind(searchBox, "PlaceholderColor3", "sub")
searchBox:GetPropertyChangedSignal("Text"):Connect(function() applySearch(searchBox.Text) end)

-- bolha
local bubbleCorner = new("UICorner", {CornerRadius = UDim.new(0.5, 0)})
local bubble = new("TextButton", {Size = UDim2.fromOffset(State.BubbleSize, State.BubbleSize), Position = UDim2.new(0, 16, 0.4, 0), BackgroundColor3 = Color3.new(1, 1, 1), Text = "", Visible = false, AutoButtonColor = false, Parent = gui}, {bubbleCorner})
bind(new("UIGradient", {Rotation = 45, Parent = bubble}), "Color", gradSeq, true)
local bubbleTxt = mkText({Size = UDim2.fromScale(1, 1), Text = State.BubbleText, TextSize = 24, TextColor3 = Color3.new(1, 1, 1), Parent = bubble}, true, false)
new("UIStroke", {Color = Color3.new(1, 1, 1), Transparency = 0.55, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = bubble})

local function drag(handle, target, canDrag)
	local st = {moved = false}
	local dragging, start, origin
	handle.InputBegan:Connect(function(i)
		if canDrag and not canDrag() then return end
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, start, origin, st.moved = true, i.Position, target.Position, false
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
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
drag(top, main, function() return not State.LockPos end)
local bubbleDrag = drag(bubble, bubble)

local function showMain()
	shown = true
	main.Visible = true
	bubble.Visible = false
	tween(main, 0.4, {GroupTransparency = 0})
	tween(uiscale, 0.5, {Scale = State.Scale}, Enum.EasingStyle.Back)
	updateBlur()
end
local function hideMain()
	shown = false
	tween(main, 0.25, {GroupTransparency = 1})
	tween(uiscale, 0.25, {Scale = State.Scale * 0.9})
	updateBlur()
	task.delay(0.27, function() if not shown then main.Visible = false; bubble.Visible = true end end)
end
yellow.MouseButton1Click:Connect(hideMain)
bubble.MouseButton1Click:Connect(function() if not bubbleDrag.moved then showMain() end end)
conn(UIS.InputBegan:Connect(function(i, gp)
	if not gp and i.KeyCode.Name == State.ToggleKey then if shown then hideMain() else showMain() end end
end))

-- alça de redimensionar (canto inferior direito)
local syncAll
do
	local grip = new("TextButton", {Size = UDim2.fromOffset(22, 22), AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
		Text = "◢", TextSize = 14, TextColor3 = T.sub, ZIndex = 20, AutoButtonColor = false, Parent = main})
	bind(grip, "TextColor3", "sub")
	local rs, sp, sw, sh, op = false, nil, 0, 0, nil
	grip.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			rs, sp, sw, sh, op = true, i.Position, State.PanelW, State.PanelH, main.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then rs = false; if syncAll then syncAll() end end
			end)
		end
	end)
	conn(UIS.InputChanged:Connect(function(i)
		if rs and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = (i.Position - sp) / State.Scale
			local nw, nh = math.clamp(sw + d.X, 480, 900), math.clamp(sh + d.Y, 300, 560)
			State.PanelW, State.PanelH = math.floor(nw), math.floor(nh)
			W, H = State.PanelW, State.PanelH
			main.Size = UDim2.fromOffset(W, H)
			main.Position = UDim2.new(op.X.Scale, op.X.Offset + (nw - sw) * State.Scale / 2, op.Y.Scale, op.Y.Offset + (nh - sh) * State.Scale / 2)
		end
	end))
end

------------------------------------------------------------------
-- PARTÍCULAS
------------------------------------------------------------------
local buildParts, scheduleParts
local PTypeNames = {"Neve", "Flocos ❄", "Chuva", "Estrelas", "Pétalas", "Sakura", "Corações", "Bolhas", "Confete", "Brasas", "Vaga-lumes", "Cinzas", "Matrix"}
do
	local PKinds = {
		["Neve"] = {mode = "dot", dir = 1, spd = 1},
		["Flocos ❄"] = {mode = "glyph", chars = {"❄", "❅", "❆"}, dir = 1, spd = 0.9},
		["Chuva"] = {mode = "line", dir = 1, spd = 3.8},
		["Estrelas"] = {mode = "glyph", chars = {"✦", "✧", "★"}, dir = 1, spd = 0.6},
		["Pétalas"] = {mode = "glyph", chars = {"✿", "❀"}, dir = 1, spd = 0.8},
		["Sakura"] = {mode = "glyph", chars = {"❀", "✿"}, dir = 1, spd = 0.7, fixed = Color3.fromRGB(255, 170, 200)},
		["Corações"] = {mode = "glyph", chars = {"♥"}, dir = -1, spd = 0.7, fixed = Color3.fromRGB(255, 100, 150)},
		["Bolhas"] = {mode = "ring", dir = -1, spd = 0.8},
		["Confete"] = {mode = "rect", dir = 1, spd = 1.3, rand = true},
		["Brasas"] = {mode = "dot", dir = -1, spd = 1.1, fixed = Color3.fromRGB(255, 140, 40)},
		["Vaga-lumes"] = {mode = "dot", dir = -1, spd = 0.35, fixed = Color3.fromRGB(220, 255, 120)},
		["Cinzas"] = {mode = "dot", dir = 1, spd = 0.5, fixed = Color3.fromRGB(170, 170, 170)},
		["Matrix"] = {mode = "glyph", chars = {"0", "1", "ア", "ネ", "ﾊ", "9"}, dir = 1, spd = 1.8, fixed = Color3.fromRGB(0, 255, 106)},
	}
	local pLayer = new("Frame", {Name = "Particles", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 1, Parent = main})
	local parts, rainbowH, rebuildTok, lastRecolor = {}, 0, 0, 0
	local function partColor(p)
		local mode = State.PColor
		local kind = PKinds[State.PType] or PKinds["Neve"]
		if mode == "Tema" then return (p.i % 2 == 0) and T.accent or T.accent2
		elseif mode == "Arco-íris" then return Color3.fromHSV((p.h + rainbowH) % 1, 0.6, 1)
		elseif mode == "Personalizada" then return Color3.fromRGB(State.PR, State.PG, State.PB) end
		if kind.rand then return Color3.fromHSV(p.h, 0.65, 1) end
		return kind.fixed or Color3.new(1, 1, 1)
	end
	local function setAlpha(p, a)
		if p.mode == "glyph" then p.o.TextTransparency = a elseif p.mode == "ring" then p.st.Transparency = a else p.o.BackgroundTransparency = a end
	end
	local function paintPart(p)
		local c = partColor(p)
		if p.mode == "glyph" then p.o.TextColor3 = c elseif p.mode == "ring" then p.st.Color = c else p.o.BackgroundColor3 = c end
		setAlpha(p, State.PAlpha / 100)
	end
	recolorParts = function() for _, p in ipairs(parts) do paintPart(p) end end
	table.insert(binders, function() if recolorParts then recolorParts() end end)
	buildParts = function()
		for _, p in ipairs(parts) do pcall(function() p.o:Destroy() end) end
		table.clear(parts)
		local full = State.PFull
		pLayer.Parent = full and gui or main
		pLayer.ZIndex = full and (State.PLayer == "Atrás" and 0 or 10) or (State.PLayer == "Atrás" and 1 or 6)
		pLayer.Visible = State.PartOn
		if not State.PartOn then return end
		local kind = PKinds[State.PType] or PKinds["Neve"]
		for i = 1, State.PCount do
			local sz = State.PSize * (0.5 + math.random() * 0.9)
			local o, st
			if kind.mode == "glyph" then
				o = new("TextLabel", {BackgroundTransparency = 1, Text = kind.chars[math.random(#kind.chars)], TextSize = math.max(8, sz * 1.8), Size = UDim2.fromOffset(sz * 2, sz * 2), Font = Enum.Font.GothamBold})
			elseif kind.mode == "line" then
				o = new("Frame", {BorderSizePixel = 0, Size = UDim2.fromOffset(math.max(1, sz / 6), sz * 2.6)})
			elseif kind.mode == "ring" then
				o = new("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromOffset(sz * 1.6, sz * 1.6)}, {corner(100)})
				st = new("UIStroke", {Thickness = 1.3, Parent = o})
			elseif kind.mode == "rect" then
				o = new("Frame", {BorderSizePixel = 0, Size = UDim2.fromOffset(sz, sz * 0.55)})
			else
				o = new("Frame", {BorderSizePixel = 0, Size = UDim2.fromOffset(sz, sz)}, {corner(100)})
			end
			o.AnchorPoint = Vector2.new(0.5, 0.5)
			o.Rotation = (kind.mode == "line") and 0 or math.random(0, 360)
			o.Parent = pLayer
			local p = {o = o, st = st, mode = kind.mode, x = math.random(), y = math.random(), vy = (30 + math.random() * 55) * kind.spd,
				k = 0.6 + math.random() * 0.8, sw = 0.8 + math.random() * 1.6, ph = math.random() * 6.28, rs = (math.random() - 0.5) * 160,
				tw = 1 + math.random() * 3, h = math.random(), i = i}
			o.Position = UDim2.fromScale(p.x, p.y)
			parts[i] = p
			paintPart(p)
		end
	end
	scheduleParts = function()
		rebuildTok = rebuildTok + 1
		local t = rebuildTok
		task.delay(0.15, function() if t == rebuildTok and alive then pcall(buildParts) end end)
	end
	conn(RS.RenderStepped:Connect(function(dt)
		if not State.PartOn or #parts == 0 then return end
		dt = math.min(dt, 0.05)
		local kind = PKinds[State.PType] or PKinds["Neve"]
		local hpx = State.PFull and cam.ViewportSize.Y or H
		local wpx = State.PFull and cam.ViewportSize.X or W
		local dir = State.PDir == "Cair" and 1 or (State.PDir == "Subir" and -1 or kind.dir)
		local t = tick()
		local spd = State.PSpeed / 100
		if State.PColor == "Arco-íris" then
			rainbowH = (rainbowH + dt * 0.1) % 1
			if t - lastRecolor > 0.1 then lastRecolor = t; recolorParts() end
		end
		local base = State.PAlpha / 100
		for _, p in ipairs(parts) do
			p.y = p.y + dir * p.vy * spd * dt / hpx
			p.x = p.x + State.PWind * 0.8 * p.k * dt / wpx
			if p.y > 1.06 then p.y = -0.06; p.x = math.random() elseif p.y < -0.06 then p.y = 1.06; p.x = math.random() end
			if p.x > 1.05 then p.x = -0.05 elseif p.x < -0.05 then p.x = 1.05 end
			local sx = State.PSway and math.sin(t * p.sw + p.ph) * 10 / wpx or 0
			p.o.Position = UDim2.fromScale(p.x + sx, p.y)
			if State.PSpin and p.mode ~= "line" and p.mode ~= "ring" then p.o.Rotation = (p.o.Rotation + p.rs * dt) % 360 end
			if State.PTwinkle then setAlpha(p, base + (1 - base) * (0.5 + 0.5 * math.sin(t * p.tw + p.ph)) * 0.85) end
		end
	end))
end

------------------------------------------------------------------
-- SIDEBAR + ABAS
------------------------------------------------------------------
local side = new("Frame", {Size = UDim2.new(0, State.SideW, 1, -50), Position = UDim2.fromOffset(8, 42), BackgroundColor3 = T.side, BackgroundTransparency = State.SideAlpha / 100, Parent = main}, {rc(16)})
bind(side, "BackgroundColor3", "side")
glass(side, 0.92)

local tabHolder = new("ScrollingFrame", {Size = UDim2.new(1, 0, 1, -54), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(), Parent = side})
local indCorner = new("UICorner", {CornerRadius = UDim.new(0, 11)})
local indicator = new("Frame", {Size = UDim2.new(1, -12, 0, 32), Position = UDim2.fromOffset(6, 8), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 1, Parent = tabHolder}, {indCorner})
bind(new("UIGradient", {Parent = indicator}), "Color", gradSeq, true)
local indStroke = new("UIStroke", {Thickness = 2, Color = Color3.new(1, 1, 1), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = false, Parent = indicator})
bind(new("UIGradient", {Parent = indStroke}), "Color", gradSeq, true)

local chip = new("Frame", {Size = UDim2.new(1, -12, 0, 40), Position = UDim2.new(0, 6, 1, -46), BackgroundColor3 = T.row, BackgroundTransparency = 0.25, Visible = State.ShowCard, Parent = side}, {rc(12)})
bind(chip, "BackgroundColor3", "row")
local chipAv = new("ImageLabel", {Size = UDim2.fromOffset(28, 28), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = T.side, Parent = chip}, {corner(14)})
bind(chipAv, "BackgroundColor3", "side")
mkText({Size = UDim2.new(1, -44, 0, 18), Position = UDim2.fromOffset(40, 3), Text = lp.DisplayName, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = chip}, true)
local chipLv = mkText({Size = UDim2.new(1, -44, 0, 14), Position = UDim2.fromOffset(40, 21), Text = "Lv —", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = chip}, false, "accent")

local content = new("Frame", {Size = UDim2.new(1, -(State.SideW + 24), 1, -50), Position = UDim2.fromOffset(State.SideW + 18, 42), BackgroundTransparency = 1, ClipsDescendants = true, Parent = main})

local layoutTabs, switchTab, addPage
do
	local pages, pageScale, tabY, tabIdx, current, tabList = {}, {}, {}, {}, nil, {}
	local function P(ox, oy) return UDim2.new(0.5, ox, 0.5, oy) end
	local function selCol()
		local s = State.TabStyle
		if s == "Preenchido" then return Color3.new(1, 1, 1) elseif s == "Suave" then return T.text end
		return T.accent
	end
	local function applyIndicator(instant, tt, es)
		if not current or not tabY[current] then return end
		local y, h, s = tabY[current], State.TabH, State.TabStyle
		local size, pos, tr, cr
		if s == "Barra" then size, pos, tr, cr = UDim2.fromOffset(4, h - 10), UDim2.fromOffset(8, y + 5), 0, UDim.new(0, 2)
		elseif s == "Sublinhado" then size, pos, tr, cr = UDim2.new(1, -28, 0, 3), UDim2.fromOffset(14, y + h - 4), 0, UDim.new(0, 2)
		else
			size, pos, cr = UDim2.new(1, -12, 0, h), UDim2.fromOffset(6, y), UDim.new(0, State.TabCorner)
			tr = (s == "Contorno") and 1 or ((s == "Suave") and 0.78 or 0)
		end
		indCorner.CornerRadius = cr
		indStroke.Enabled = (s == "Contorno")
		if instant then
			indicator.Size, indicator.Position, indicator.BackgroundTransparency = size, pos, tr
		else
			tween(indicator, tt or 0.3, {Size = size, Position = pos, BackgroundTransparency = tr}, es or ease())
		end
	end
	layoutTabs = function()
		local h, gap = State.TabH, State.TabGap
		for i, t in ipairs(tabList) do
			local y = 8 + (i - 1) * (h + gap)
			tabY[t.name] = y
			t.btn.Position = UDim2.fromOffset(6, y)
			t.btn.Size = UDim2.new(1, -12, 0, h)
			t.btn.TextSize = State.TabSize
			t.btn.Text = (State.TabIcons and (t.icon .. "  ") or "") .. t.name
			t.btn.TextXAlignment = State.TabAlign == "Centro" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
		end
		tabHolder.CanvasSize = UDim2.fromOffset(0, 16 + #tabList * (h + gap))
		applyIndicator(true)
		for _, f in ipairs(tabRefresh) do f(0) end
	end
	switchTab = function(name)
		if current == name then return end
		local oldName = current
		current = name
		for _, f in ipairs(tabRefresh) do f(0.25) end
		local tt = math.max(State.TransTime, 50) / 1000
		local es = ease()
		local kind = State.Transition
		applyIndicator(false, tt, es)
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
	addPage = function(name, icon)
		local grp = new("CanvasGroup", {Size = UDim2.fromScale(1, 1), AnchorPoint = Vector2.new(0.5, 0.5), Position = P(0, 0), BackgroundTransparency = 1, GroupTransparency = 1, Visible = false, Parent = content})
		local ps = new("UIScale", {Parent = grp})
		local lay = new("UIListLayout", {Padding = UDim.new(0, State.ItemGap), SortOrder = Enum.SortOrder.LayoutOrder})
		table.insert(pageLayouts, lay)
		local sc = new("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
			AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = grp,
		}, {lay, new("UIPadding", {PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 12)})})
		bind(sc, "ScrollBarImageColor3", "accent")
		pages[name], pageScale[name] = grp, ps
		tabIdx[name] = #tabList + 1
		local btn = mkText({Size = UDim2.new(1, -12, 0, 32), Text = name, TextSize = 13, ZIndex = 2, AutoButtonColor = false, Parent = tabHolder}, true, false, "TextButton")
		new("UIPadding", {PaddingLeft = UDim.new(0, 12), Parent = btn})
		table.insert(tabList, {name = name, icon = icon, btn = btn})
		table.insert(tabRefresh, function(d) tween(btn, d or 0.2, {TextColor3 = current == name and selCol() or T.sub}) end)
		table.insert(binders, function() tween(btn, 0.2, {TextColor3 = current == name and selCol() or T.sub}) end)
		btn.TextColor3 = T.sub
		btn.MouseButton1Click:Connect(function() uiSound(); switchTab(name) end)
		return sc
	end
end

------------------------------------------------------------------
-- COMPONENTES
------------------------------------------------------------------
local function row(page, h)
	local r = new("Frame", {Size = UDim2.new(1, -4, 0, h or 40), BackgroundColor3 = T.row, BackgroundTransparency = State.RowAlpha / 100, Parent = page}, {rc(13)})
	bind(r, "BackgroundColor3", "row")
	glass(r, 0.93)
	table.insert(rowList, r)
	return r
end
local function Section(page, text)
	regSearch(mkText({Size = UDim2.new(1, -4, 0, 22), Text = string.upper(text), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = page}, true, "accent"), "", true)
end
local function Label(page, text)
	local l = mkText({Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = text, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = page}, false, "sub")
	regSearch(l, "", true)
	return l
end

local function Toggle(page, text, key, cb)
	local r = row(page, 42)
	regSearch(r, text)
	mkText({Size = UDim2.new(1, -76, 1, 0), Position = UDim2.fromOffset(14, 0), Text = text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, false)
	local swc, kc = corner(13), corner(11)
	local sw = new("TextButton", {Size = UDim2.fromOffset(46, 26), Position = UDim2.new(1, -60, 0.5, -13), Text = "", AutoButtonColor = false, Parent = r}, {swc})
	local knob = new("Frame", {Size = UDim2.fromOffset(22, 22), Position = State[key] and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.new(1, 1, 1), Parent = sw}, {kc})
	table.insert(swList, {swc, kc})
	local refresh = bind(sw, "BackgroundColor3", function() return State[key] and T.accent or offColor() end, true)
	table.insert(syncers, function()
		knob.Position = State[key] and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
		refresh(0)
	end)
	sw.MouseButton1Click:Connect(function()
		uiSound()
		State[key] = not State[key]
		refresh(0.25)
		tween(knob, 0.3, {Position = State[key] and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)}, Enum.EasingStyle.Back)
		if cb then task.spawn(function() local ok, err = pcall(cb, State[key]); if not ok then notify("Erro", tostring(err)) end end) end
	end)
end
local function restyleSwitches()
	local pill = State.SwShape == "Pílula"
	for _, e in ipairs(swList) do
		e[1].CornerRadius = UDim.new(0, pill and 13 or 6)
		e[2].CornerRadius = UDim.new(0, pill and 11 or 4)
	end
end

local function Slider(page, text, min, max, key, cb, suffix)
	suffix = suffix or ""
	local r = row(page, 58)
	regSearch(r, text)
	mkText({Size = UDim2.new(0.6, 0, 0, 28), Position = UDim2.fromOffset(14, 2), Text = text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, false)
	local vl = mkText({Size = UDim2.new(0.4, -28, 0, 28), Position = UDim2.new(0.6, 14, 0, 2), Text = State[key] .. suffix, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = r}, true, "accent")
	local bar = new("Frame", {Size = UDim2.new(1, -28, 0, 8), Position = UDim2.fromOffset(14, 40), BackgroundColor3 = T.sub, Parent = r}, {corner(4)})
	bind(bar, "BackgroundColor3", offColor)
	local a0 = math.clamp((State[key] - min) / (max - min), 0, 1)
	local fill = new("Frame", {Size = UDim2.new(a0, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), Parent = bar}, {corner(4)})
	bind(new("UIGradient", {Parent = fill}), "Color", gradSeq, true)
	new("Frame", {Size = UDim2.fromOffset(18, 18), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = Color3.new(1, 1, 1), Parent = fill},
		{corner(9), new("UIStroke", {Color = Color3.new(0, 0, 0), Transparency = 0.8, Thickness = 1})})
	table.insert(syncers, function()
		fill.Size = UDim2.new(math.clamp((State[key] - min) / (max - min), 0, 1), 0, 1, 0)
		vl.Text = State[key] .. suffix
	end)
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

local function styleBtn(e)
	local s = State.BtnStyle
	local a1, a2 = T.accent, T.accent2
	local white = Color3.new(1, 1, 1)
	e.b.Size = UDim2.new(1, -4, 0, State.BtnH)
	e.bc.CornerRadius = UDim.new(0, State.BtnCorner)
	e.lb.TextSize = State.BtnTextSize
	e.g.Rotation = State.BtnAngle
	e.g.Color = ColorSequence.new(a1, a2)
	e.sg.Color = ColorSequence.new(a1, a2)
	e.gloss.Visible = State.BtnGloss and (s == "Gradiente" or s == "Sólido")
	e.sg.Enabled = (s == "Contorno" or s == "Neon")
	e.st.Color = white
	e.st.Transparency = 0
	if s == "Gradiente" then
		e.b.BackgroundColor3 = white; e.b.BackgroundTransparency = 0; e.g.Enabled = true; e.st.Enabled = false; e.lb.TextColor3 = white
	elseif s == "Sólido" then
		e.b.BackgroundColor3 = a1; e.b.BackgroundTransparency = 0; e.g.Enabled = false; e.st.Enabled = false; e.lb.TextColor3 = white
	elseif s == "Contorno" then
		e.b.BackgroundColor3 = a1; e.b.BackgroundTransparency = 0.88; e.g.Enabled = false; e.st.Enabled = true; e.st.Thickness = 2; e.lb.TextColor3 = a1
	elseif s == "Vidro" then
		e.b.BackgroundColor3 = T.row; e.b.BackgroundTransparency = 0.15; e.g.Enabled = false; e.st.Enabled = true; e.st.Thickness = 1
		e.st.Color = T.text; e.st.Transparency = 0.85; e.lb.TextColor3 = T.text
	else
		e.b.BackgroundColor3 = T.side; e.b.BackgroundTransparency = 0.1; e.g.Enabled = false; e.st.Enabled = true; e.st.Thickness = 2.5; e.lb.TextColor3 = T.text
	end
end
local function restyleButtons() for _, e in ipairs(btnList) do styleBtn(e) end end
local function playShine(e)
	if not State.BtnShine then return end
	e.shine.Position = UDim2.new(-0.25, 0, -0.7, 0)
	tween(e.shine, 0.8, {Position = UDim2.new(1.15, 0, -0.7, 0)}, Enum.EasingStyle.Quad)
end
local function Button(page, text, cb)
	local bc = new("UICorner", {})
	local holder = new("CanvasGroup", {Size = UDim2.new(1, -4, 0, State.BtnH), BackgroundColor3 = Color3.new(1, 1, 1), Parent = page}, {bc})
	regSearch(holder, text)
	local g = new("UIGradient", {Parent = holder})
	local st = new("UIStroke", {ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = holder})
	local sg = new("UIGradient", {Parent = st})
	local sc = new("UIScale", {Parent = holder})
	local gloss = new("Frame", {Size = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 2, Parent = holder},
		{new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.82), NumberSequenceKeypoint.new(1, 1)})})})
	local shine = new("Frame", {Size = UDim2.new(0, 46, 2.4, 0), Position = UDim2.new(-0.25, 0, -0.7, 0), Rotation = 20, BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 3, Parent = holder},
		{new("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.55), NumberSequenceKeypoint.new(1, 1)})})})
	local lb = mkText({Size = UDim2.fromScale(1, 1), Text = text, TextSize = State.BtnTextSize, ZIndex = 3, Parent = holder}, true, false)
	local hit = new("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 10, Parent = holder})
	local e = {b = holder, bc = bc, g = g, st = st, sg = sg, gloss = gloss, shine = shine, lb = lb, page = page}
	table.insert(btnList, e)
	styleBtn(e)
	table.insert(binders, function() styleBtn(e) end)
	hit.MouseEnter:Connect(function() if State.BtnHover then tween(sc, 0.2, {Scale = 1.02}) end playShine(e) end)
	hit.MouseLeave:Connect(function() tween(sc, 0.2, {Scale = 1}) end)
	hit.InputBegan:Connect(function(i)
		if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
		tween(sc, 0.12, {Scale = 0.97})
		if not State.BtnRipple then return end
		local ax, ay = holder.AbsoluteSize.X, holder.AbsoluteSize.Y
		if ax <= 0 then return end
		local fx = math.clamp((i.Position.X - holder.AbsolutePosition.X) / ax, 0, 1)
		local fy = math.clamp((i.Position.Y - holder.AbsolutePosition.Y) / ay, 0, 1)
		local rp = new("Frame", {Size = UDim2.fromOffset(0, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(fx, fy), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.55, BorderSizePixel = 0, ZIndex = 4, Parent = holder}, {corner(500)})
		tween(rp, 0.6, {Size = UDim2.fromOffset(300, 300), BackgroundTransparency = 1})
		task.delay(0.65, function() pcall(function() rp:Destroy() end) end)
	end)
	hit.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then tween(sc, 0.25, {Scale = 1}, Enum.EasingStyle.Back) end
	end)
	hit.MouseButton1Click:Connect(function()
		uiSound()
		playShine(e)
		task.spawn(function() local ok, err = pcall(cb); if not ok then notify("Erro", tostring(err)) end end)
	end)
end
task.spawn(function()
	while alive do
		task.wait(3)
		for i, e in ipairs(btnList) do
			if State.BtnShine and shown and e.b.Parent and e.page.Parent and e.page.Parent.Visible then
				task.delay((i % 8) * 0.1, function() pcall(playShine, e) end)
			end
		end
	end
end)

local function Input(page, text, placeholder, cb)
	local r = row(page, 42)
	regSearch(r, text)
	mkText({Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.fromOffset(14, 0), Text = text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, false)
	local box = mkText({Size = UDim2.new(0.6, -24, 0, 28), Position = UDim2.new(0.4, 6, 0.5, -14), Text = "", PlaceholderText = placeholder, TextSize = 13, ClearTextOnFocus = false, BackgroundColor3 = T.side, Parent = r}, false, "text", "TextBox")
	box.BackgroundTransparency = 0.3
	new("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})
	bind(box, "BackgroundColor3", "side")
	box.FocusLost:Connect(function(enter) if enter and box.Text ~= "" then pcall(cb, box.Text); box.Text = "" end end)
end

local function Dropdown(page, text, options, key, cb)
	local r = row(page, 42)
	regSearch(r, text)
	r.ClipsDescendants = true
	local head = new("TextButton", {Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Text = "", Parent = r})
	mkText({Size = UDim2.new(0.5, 0, 0, 42), Position = UDim2.fromOffset(14, 0), Text = text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, false)
	local val = mkText({Size = UDim2.new(0.5, -40, 0, 42), Position = UDim2.new(0.5, 0, 0, 0), Text = tostring(State[key]), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, Parent = r}, true, "accent")
	local arrow = mkText({Size = UDim2.fromOffset(20, 42), Position = UDim2.new(1, -30, 0, 0), Text = "▾", TextSize = 15, Parent = r}, true, "sub")
	local list = new("Frame", {Size = UDim2.new(1, -16, 0, #options * 32), Position = UDim2.fromOffset(8, 46), BackgroundTransparency = 1, Parent = r}, {new("UIListLayout", {Padding = UDim.new(0, 3)})})
	table.insert(syncers, function() val.Text = tostring(State[key]) end)
	local open = false
	for _, o in ipairs(options) do
		local b = mkText({Size = UDim2.new(1, 0, 0, 29), Text = o, TextSize = 13, BackgroundColor3 = T.side, AutoButtonColor = false, Parent = list}, false, "text", "TextButton")
		b.BackgroundTransparency = 0.35
		new("UICorner", {CornerRadius = UDim.new(0, 8), Parent = b})
		bind(b, "BackgroundColor3", "side")
		b.MouseButton1Click:Connect(function()
			uiSound()
			State[key] = o
			val.Text = o
			open = false
			tween(r, 0.3, {Size = UDim2.new(1, -4, 0, 42)})
			tween(arrow, 0.3, {Rotation = 0})
			if cb then task.spawn(function() local ok, err = pcall(cb, o); if not ok then notify("Erro", tostring(err)) end end) end
		end)
	end
	head.MouseButton1Click:Connect(function()
		uiSound()
		open = not open
		tween(r, 0.35, {Size = UDim2.new(1, -4, 0, open and (50 + #options * 32) or 42)})
		tween(arrow, 0.35, {Rotation = open and 180 or 0})
	end)
end

local function Grid(page, w, h)
	local g = new("Frame", {Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = page},
		{new("UIGridLayout", {CellSize = UDim2.fromOffset(w, h), CellPadding = UDim2.fromOffset(8, 8), SortOrder = Enum.SortOrder.LayoutOrder})})
	regSearch(g, "", true)
	return g
end

local themeStrokes = {}
refreshThemeCards = function()
	for name, s in pairs(themeStrokes) do s.Enabled = (State.Theme == name) end
end
local function ThemeGrid(page)
	local g = Grid(page, 134, 58)
	for _, name in ipairs(ThemeNames) do
		local tt = Themes[name]
		local b = new("TextButton", {BackgroundColor3 = tt.bg, Text = "", AutoButtonColor = false, Parent = g}, {rc(12)})
		local strip = new("Frame", {Size = UDim2.new(1, -12, 0, 16), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = Color3.new(1, 1, 1), Parent = b}, {corner(6)})
		local sg = new("UIGradient", {Color = ColorSequence.new(tt.accent, tt.accent2), Parent = strip})
		if name == "Custom" then bind(sg, "Color", function() return ColorSequence.new(Themes.Custom.accent, Themes.Custom.accent2) end, true) end
		new("Frame", {Size = UDim2.new(1, -12, 0, 8), Position = UDim2.fromOffset(6, 27), BackgroundColor3 = tt.row, Parent = b}, {corner(4)})
		new("TextLabel", {Size = UDim2.new(1, 0, 0, 16), Position = UDim2.fromOffset(0, 38), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = tt.text, Parent = b})
		local st = new("UIStroke", {Thickness = 2.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = (State.Theme == name), Parent = b})
		bind(st, "Color", "accent")
		themeStrokes[name] = st
		b.MouseButton1Click:Connect(function()
			uiSound()
			if name == "Custom" then updateCustom() end
			applyTheme(name)
		end)
	end
end

local function FontGrid(page, key, withDefault, cb)
	local g = Grid(page, 134, 40)
	local list = {}
	if withDefault then table.insert(list, "Padrão") end
	for _, n in ipairs(FontOrder) do table.insert(list, n) end
	local strokes = {}
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

local infoRows = {}
local function InfoRow(page, name, fn)
	local r = row(page, 34)
	regSearch(r, name)
	mkText({Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.fromOffset(14, 0), Text = name, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, false, "sub")
	local v = mkText({Size = UDim2.new(0.6, -28, 1, 0), Position = UDim2.new(0.4, 14, 0, 0), Text = "...", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, Parent = r}, true)
	table.insert(infoRows, {v, fn})
end

------------------------------------------------------------------
-- APARÊNCIA GLOBAL + PRESETS
------------------------------------------------------------------
syncAll = function() for _, f in ipairs(syncers) do pcall(f) end end
local function applyAppearanceRaw()
	W, H = State.PanelW, State.PanelH
	main.Size = UDim2.fromOffset(W, H)
	main.BackgroundTransparency = State.Opacity / 100
	setCorners()
	glow.BackgroundTransparency = 1 - State.Glow / 100
	glowG.Rotation = State.GlowAngle
	for _, s in ipairs(strokeList) do s.Enabled = State.Borders end
	mainStroke.Thickness = State.BorderThick
	mainStroke.Transparency = State.BorderAlpha / 100
	borderBind(0)
	topLine.Visible = State.TopLine
	topLine.Size = UDim2.new(1, 0, 0, State.TopLineH)
	titleLabel.TextSize = State.TitleSize
	if State.TitleAlign == "Esquerda" then
		titleLabel.Position = UDim2.fromOffset(200, 0); titleLabel.Size = UDim2.new(1, -340, 1, 0); titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	else
		titleLabel.Position = UDim2.new(); titleLabel.Size = UDim2.new(1, 0, 1, 0); titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	end
	chipLabel.Visible = State.ShowChip
	chip.Visible = State.ShowCard
	side.Size = UDim2.new(0, State.SideW, 1, -50)
	side.BackgroundTransparency = State.SideAlpha / 100
	content.Position = UDim2.fromOffset(State.SideW + 18, 42)
	content.Size = UDim2.new(1, -(State.SideW + 24), 1, -50)
	for _, r in ipairs(rowList) do r.BackgroundTransparency = State.RowAlpha / 100 end
	for _, l in ipairs(pageLayouts) do l.Padding = UDim.new(0, State.ItemGap) end
	bubble.Size = UDim2.fromOffset(State.BubbleSize, State.BubbleSize)
	bubbleCorner.CornerRadius = State.BubbleShape == "Redonda" and UDim.new(0.5, 0) or UDim.new(0, 12)
	bubbleTxt.Text = State.BubbleText
	bubbleTxt.TextSize = State.BubbleSize * 0.46
	applyNotifyPos()
	layoutTabs()
	restyleButtons()
	restyleSwitches()
	updateBlur()
end
local function applyAppearance()
	local ok, e = pcall(applyAppearanceRaw)
	if not ok then warn("[AppleHub] " .. tostring(e)) end
end

local Presets = {
	["Vidro"] = {Theme = "Midnight", Opacity = 18, Corner = 20, Glow = 14, Borders = true, BtnStyle = "Vidro", TabStyle = "Suave", SwShape = "Pílula", RowAlpha = 35, PartOn = true, PType = "Neve", PCount = 45},
	["Sólido"] = {Opacity = 0, Corner = 10, Glow = 0, Borders = false, BtnStyle = "Sólido", TabStyle = "Preenchido", RowAlpha = 0, PartOn = false},
	["Neon"] = {Theme = "Cyberpunk", Opacity = 8, Corner = 8, Glow = 22, Borders = true, AnimGlow = true, BtnStyle = "Neon", TabStyle = "Contorno", PartOn = true, PType = "Estrelas", PCount = 40, PTwinkle = true},
	["Minimal"] = {Theme = "AMOLED", Opacity = 0, Corner = 6, Glow = 0, Borders = false, BtnStyle = "Contorno", TabStyle = "Barra", RowAlpha = 10, PartOn = false},
	["Fofo"] = {Theme = "Sakura", Corner = 26, Glow = 16, BtnStyle = "Gradiente", TabStyle = "Preenchido", PartOn = true, PType = "Sakura", PCount = 35, BubbleShape = "Redonda"},
	["Inverno"] = {Theme = "Ice", Corner = 18, Glow = 12, BtnStyle = "Vidro", TabStyle = "Suave", PartOn = true, PType = "Neve", PCount = 80, PColor = "Original", PWind = 15},
	["Hacker"] = {Theme = "Matrix", Corner = 4, Glow = 6, Borders = true, BtnStyle = "Contorno", TabStyle = "Sublinhado", PartOn = true, PType = "Matrix", PCount = 60, SwShape = "Quadrado"},
	["Lava"] = {Theme = "Lava", Corner = 14, Glow = 20, BtnStyle = "Gradiente", TabStyle = "Preenchido", PartOn = true, PType = "Brasas", PCount = 55, AnimGlow = true},
	["Festa"] = {Theme = "Candy", Corner = 22, Glow = 18, BtnStyle = "Gradiente", TabStyle = "Preenchido", PartOn = true, PType = "Confete", PCount = 50, PColor = "Original"},
	["Galáxia"] = {Theme = "Galaxy", Corner = 18, Glow = 20, BtnStyle = "Neon", TabStyle = "Contorno", PartOn = true, PType = "Estrelas", PCount = 70, PColor = "Tema", PTwinkle = true, AnimGlow = true},
	["Abismo"] = {Theme = "Abyss", Corner = 14, Glow = 16, Borders = true, BtnStyle = "Neon", TabStyle = "Barra", PartOn = true, PType = "Bolhas", PCount = 40, PColor = "Tema"},
	["Floresta"] = {Theme = "Forest", Corner = 18, Glow = 10, BtnStyle = "Vidro", TabStyle = "Suave", PartOn = true, PType = "Vaga-lumes", PCount = 35, PTwinkle = true},
}
local PresetOrder = {"Vidro", "Sólido", "Neon", "Minimal", "Fofo", "Inverno", "Hacker", "Lava", "Festa", "Galáxia", "Abismo", "Floresta"}
local function applyPreset(name)
	local p = Presets[name]
	if not p then return end
	for k, v in pairs(p) do State[k] = v end
	if p.Theme then applyTheme(p.Theme) end
	applyAppearance(); syncAll(); scheduleParts()
	notify("Estilo", "Preset \"" .. name .. "\" aplicado!", 2)
end
local function PresetGrid(page)
	local g = Grid(page, 134, 40)
	for _, name in ipairs(PresetOrder) do
		local b = new("TextButton", {BackgroundColor3 = T.row, Text = name, TextSize = 13, TextColor3 = T.text, AutoButtonColor = false, Parent = g}, {rc(11)})
		regFont(b, true)
		bind(b, "BackgroundColor3", "row")
		bind(b, "TextColor3", "text")
		b.MouseButton1Click:Connect(function() uiSound(); applyPreset(name) end)
	end
end
local function resetAppearance()
	for _, k in ipairs(APPEAR_KEYS) do if Default[k] ~= nil then State[k] = Default[k] end end
	State.Scale = State.ScalePct / 100
	tween(uiscale, 0.25, {Scale = State.Scale})
	applyTheme(State.Theme)
	applyAppearance(); syncAll(); scheduleParts()
	notify("Visual", "Visual restaurado ao padrão.", 2)
end

-- ===== FIM DA PARTE 1 — cole a PARTE 2 logo abaixo desta linha =====
-- ===== PARTE 2/2 — cole logo abaixo da PARTE 1 =====
local G = {safeUp = false, after = {}}

------------------------------------------------------------------
-- BLOCO 1: base do jogo
------------------------------------------------------------------
;(function()
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
	local function anyAuto()
		return State.AutoLevel or State.Farm or State.AutoBoss or State.Chest or State.FruitGrab or State.AutoElite
	end
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
		local tp = pos + Vector3.new(0, G.safeUp and 230 or State.Height, 0)
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
	local function bringMobs(target)
		if not State.BringMobs or not target then return end
		local folder = workspace:FindFirstChild("Enemies")
		if not folder then return end
		pcall(function() sethiddenproperty(lp, "SimulationRadius", math.huge) end)
		for _, m in ipairs(folder:GetChildren()) do
			local h, mr = m:FindFirstChildOfClass("Humanoid"), m:FindFirstChild("HumanoidRootPart")
			if h and mr and h.Health > 0 and m.Name == target.Parent.Name and (mr.Position - target.Position).Magnitude < State.BringRadius then
				mr.CFrame = target.CFrame
				mr.CanCollide = false
				mr.AssemblyLinearVelocity = Vector3.zero
				h.WalkSpeed = 0
			end
		end
	end
	local function findFruit()
		for _, v in ipairs(workspace:GetChildren()) do
			if (v:IsA("Tool") or v:IsA("Model")) and v.Name:lower():find("fruit") and v:FindFirstChild("Handle") then return v end
		end
	end
	G.root, G.hum, G.invoke, G.loop, G.dataVal, G.commas = root, hum, invoke, loop, dataVal, commas
	G.anyAuto, G.goTo, G.hoverTo, G.equipWeapon, G.nearestMob, G.bringMobs, G.findFruit = anyAuto, goTo, hoverTo, equipWeapon, nearestMob, bringMobs, findFruit
end)()

------------------------------------------------------------------
-- BLOCO 2: quests, auto level, farm, boss, elite, skills
------------------------------------------------------------------
;(function()
	local root, hum, invoke, loop, dataVal = G.root, G.hum, G.invoke, G.loop, G.dataVal
	local goTo, hoverTo, equipWeapon, nearestMob, bringMobs = G.goTo, G.hoverTo, G.equipWeapon, G.nearestMob, G.bringMobs

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
	local function seaIndex()
		local id = game.PlaceId
		if id == 2753915549 then return 1 elseif id == 4442272183 then return 2 elseif id == 7449423635 then return 3 end
		local lvl = dataVal("Level") or 1
		if lvl >= 1500 then return 3 elseif lvl >= 700 then return 2 end
		return 1
	end
	local function seaTable() local i = seaIndex() return i == 1 and Sea1 or (i == 2 and Sea2 or Sea3) end
	local function questFor(lvl)
		for _, e in ipairs(seaTable()) do
			if lvl >= e.min and lvl <= e.max then return e end
		end
	end
	local ZoneNames, ZoneMap = {}, {}
	for _, e in ipairs(seaTable()) do
		if e.ql == 1 then
			local label = e.mob .. " (Lv " .. e.min .. ")"
			table.insert(ZoneNames, label)
			ZoneMap[label] = e
		end
	end
	if State.Zone == "" and ZoneNames[1] then State.Zone = ZoneNames[1] end
	G.seaIndex, G.questFor, G.ZoneNames, G.ZoneMap = seaIndex, questFor, ZoneNames, ZoneMap

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
		local r = root()
		if not r then return end
		if State.AutoEquip then equipWeapon() end
		local e = questFor(dataVal("Level") or 1)
		if not e then
			local t = nearestMob()
			if t then hoverTo(t.Position); bringMobs(t) end
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
		if t then hoverTo(t.Position); bringMobs(t) else goTo(CFrame.new(e.m + Vector3.new(0, State.Height, 0))) end
	end)
	loop(0.02, function()
		if not State.Farm or State.AutoLevel then return end
		if not root() then return end
		if State.AutoEquip then equipWeapon() end
		local t = nearestMob()
		if t then hoverTo(t.Position); bringMobs(t) end
	end)

	local Bosses = {"Saber Expert", "The Gorilla King", "Bobby", "Yeti", "Vice Admiral", "Warden", "Chief Warden", "Swan", "Magma Admiral",
		"Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Awakened Ice Admiral",
		"Tide Keeper", "Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen", "Longma", "Soul Reaper"}
	local EliteNames = {"Deandre", "Diablo", "Urban"}
	local BossSet = {}
	for _, b in ipairs(Bosses) do BossSet[b] = true end
	for _, b in ipairs(EliteNames) do BossSet[b] = true end
	G.Bosses, G.BossSet = Bosses, BossSet
	loop(0.05, function()
		if not State.AutoBoss or State.AutoLevel then return end
		if not root() then return end
		if State.AutoEquip then equipWeapon() end
		local t = nearestMob(State.Boss)
		if t then hoverTo(t.Position) end
	end)
	local lastElite = 0
	loop(0.1, function()
		if not State.AutoElite or State.AutoLevel then return end
		if not root() then return end
		if State.AutoEquip then equipWeapon() end
		local t
		for _, n in ipairs(EliteNames) do t = nearestMob(n); if t then break end end
		if t then hoverTo(t.Position); bringMobs(t)
		elseif tick() - lastElite > 6 then lastElite = tick(); invoke("EliteHunter") end
	end)

	task.spawn(function()
		while alive do
			task.wait(math.max(State.ClickDelay, 20) / 1000)
			if (State.Click or State.Farm or State.AutoLevel or State.AutoBoss or State.AutoElite) and not G.safeUp then
				pcall(function() VU:CaptureController(); VU:ClickButton1(Vector2.new(900, 500)) end)
			end
		end
	end)
	local function pressKey(k)
		pcall(function()
			VIM:SendKeyEvent(true, Enum.KeyCode[k], false, game)
			task.wait(0.06)
			VIM:SendKeyEvent(false, Enum.KeyCode[k], false, game)
		end)
	end
	task.spawn(function()
		while alive do
			task.wait(math.max(State.SkillDelay, 200) / 1000)
			if State.AutoSkills and not G.safeUp then
				for _, k in ipairs({"Z", "X", "C", "V", "F"}) do
					if State["Skill" .. k] then pressKey(k); task.wait(0.15) end
				end
			end
		end
	end)
	loop(0.2, function()
		local h = hum()
		if not State.SafeMode or not h then G.safeUp = false return end
		local pct = h.Health / math.max(h.MaxHealth, 1) * 100
		if pct < State.SafePct then G.safeUp = true elseif pct > 85 then G.safeUp = false end
	end)
end)()

------------------------------------------------------------------
-- BLOCO 3: coleta, frutas, haki, status, códigos
------------------------------------------------------------------
;(function()
	local root, invoke, loop, goTo, findFruit = G.root, G.invoke, G.loop, G.goTo, G.findFruit
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
	local lastFruit
	loop(2, function()
		if not State.FruitNotify then return end
		local f = findFruit()
		if f and f ~= lastFruit then lastFruit = f; notify("Fruta spawnou!", f.Name, 5) elseif not f then lastFruit = nil end
	end)
	loop(3, function()
		if not State.AutoStore then return end
		local bp = lp:FindFirstChild("Backpack")
		if not bp then return end
		for _, t in ipairs(bp:GetChildren()) do
			if t:IsA("Tool") and t.ToolTip == "Blox Fruit" then
				invoke("StoreFruit", t:GetAttribute("OriginalName") or t.Name, t)
			end
		end
	end)
	loop(10, function() if State.AutoRoll then invoke("Cousin", "Buy") end end)
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

	local CodeList = {"Sub2UncleKizaru", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "fudd10", "FUDD10_V2",
		"Bignews", "TheGreatAce", "Sub2NoobMaster123", "Sub2Daigrock", "Axiore", "StrawHatMaine", "KITT_RESET", "Sub2OfficialNoobie",
		"NOMOREHACK", "BANEXPLOIT", "TRIPLEABUSE", "NEWTROLL", "CODE_SERVICE", "SECRET_ADMIN", "3BVISITS", "2BILLION", "1MLIKES"}
	local codeLines, redeeming = {}, false
	local function logCode(line)
		table.insert(codeLines, line)
		while #codeLines > 7 do table.remove(codeLines, 1) end
		if G.codeLog then G.codeLog.Text = table.concat(codeLines, "\n") end
	end
	local function redeemOne(code)
		local rem = RepStorage:FindFirstChild("Remotes")
		local rd = rem and rem:FindFirstChild("Redeem")
		if not rd then logCode(code .. " → remote não encontrado") return end
		local ok, res = pcall(function() return rd:InvokeServer(code) end)
		logCode(code .. " → " .. string.sub(ok and tostring(res) or "falhou", 1, 34))
	end
	local function redeemAll()
		if redeeming then return end
		redeeming = true
		notify("Códigos", "Resgatando " .. #CodeList .. " códigos...", 3)
		for _, c in ipairs(CodeList) do
			if not alive then break end
			redeemOne(c)
			task.wait(1.4)
		end
		redeeming = false
		notify("Códigos", "Terminei! Veja o log na aba Auto.", 3)
	end
	G.redeemAll = redeemAll
	G.addCode = function(code) table.insert(CodeList, code); task.spawn(function() redeemOne(code) end) end
end)()

------------------------------------------------------------------
-- BLOCO 4: ESP
------------------------------------------------------------------
;(function()
	local root, loop = G.root, G.loop
	local espFolder = new("Folder", {Name = "ESP", Parent = gui})
	local espCache = {}
	local function syncESP(kind, on, targets)
		espCache[kind] = espCache[kind] or {}
		local cache, seen = espCache[kind], {}
		if on then
			for _, t in ipairs(targets()) do
				seen[t.inst] = true
				local e = cache[t.inst]
				if not e then
					local hl = new("Highlight", {Adornee = t.inst, FillTransparency = 0.65, OutlineTransparency = 0, FillColor = t.color, OutlineColor = t.color, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = espFolder})
					local bb = new("BillboardGui", {Adornee = t.part, Size = UDim2.fromOffset(150, 28), AlwaysOnTop = true, StudsOffset = Vector3.new(0, 3, 0), Parent = espFolder})
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
		syncESP("players", State.ESPPlayers, function()
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
		syncESP("fruits", State.ESPFruits, function()
			local list = {}
			for _, v in ipairs(workspace:GetChildren()) do
				if (v:IsA("Tool") or v:IsA("Model")) and v.Name:lower():find("fruit") and v:FindFirstChild("Handle") then
					table.insert(list, {inst = v, part = v.Handle, color = Color3.fromRGB(255, 196, 60), text = v.Name .. " [" .. dist(v.Handle.Position) .. "m]"})
				end
			end
			return list
		end)
		syncESP("chests", State.ESPChests, function()
			local list = {}
			for _, c in ipairs(CS:GetTagged("_ChestTagged")) do
				if c.Parent then
					local part = c:IsA("BasePart") and c or c:FindFirstChildWhichIsA("BasePart", true)
					if part then table.insert(list, {inst = c, part = part, color = Color3.fromRGB(90, 220, 255), text = "Baú [" .. dist(part.Position) .. "m]"}) end
				end
			end
			return list
		end)
		syncESP("bosses", State.ESPBosses, function()
			local list = {}
			local folder = workspace:FindFirstChild("Enemies")
			if folder then
				for _, m in ipairs(folder:GetChildren()) do
					local mr = m:FindFirstChild("HumanoidRootPart")
					if G.BossSet[m.Name] and mr then
						table.insert(list, {inst = m, part = mr, color = Color3.fromRGB(190, 90, 255), text = "BOSS " .. m.Name .. " [" .. dist(mr.Position) .. "m]"})
					end
				end
			end
			return list
		end)
	end)
end)()

------------------------------------------------------------------
-- BLOCO 5: ambiente, player, fontes, desempenho
------------------------------------------------------------------
;(function()
	local root, hum = G.root, G.hum
	local origLight = {Brightness = Lighting.Brightness, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient}
	local function applyLight()
		if State.Fullbright then
			Lighting.Brightness = 2
			Lighting.GlobalShadows = false
			Lighting.Ambient = Color3.fromRGB(200, 200, 200)
			Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
		else
			Lighting.Brightness = origLight.Brightness
			Lighting.GlobalShadows = origLight.GlobalShadows
			Lighting.Ambient = origLight.Ambient
			Lighting.OutdoorAmbient = origLight.OutdoorAmbient
		end
		Lighting.FogEnd = State.NoFog and 1e6 or origLight.FogEnd
	end
	local waterOrig
	local function applyWater()
		pcall(function()
			local w = workspace.Map["WaterBase-Plane"]
			waterOrig = waterOrig or w.Size
			w.Size = State.Water and Vector3.new(1000, 112, 1000) or waterOrig
		end)
	end
	local function boostFPS()
		pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
		Lighting.GlobalShadows = false
		for _, d in ipairs(workspace:GetDescendants()) do
			if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then d.Enabled = false
			elseif d:IsA("BasePart") then d.CastShadow = false end
		end
		notify("FPS", "Modo desempenho ativado!", 2.5)
	end
	local function ultraFPS()
		notify("Ultra FPS", "Aplicando... pode travar um instante.", 3)
		task.spawn(function()
			pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 1e6
			for _, e in ipairs(Lighting:GetChildren()) do
				if e:IsA("PostEffect") and e ~= blur then pcall(function() e.Enabled = false end)
				elseif e:IsA("Atmosphere") then pcall(function() e.Density = 0 end) end
			end
			pcall(function()
				local t = workspace.Terrain
				t.WaterWaveSize, t.WaterWaveSpeed, t.WaterReflectance, t.WaterTransparency = 0, 0, 0, 1
			end)
			local n = 0
			for _, d in ipairs(workspace:GetDescendants()) do
				pcall(function()
					if d:IsA("BasePart") then d.Material = Enum.Material.SmoothPlastic; d.CastShadow = false; d.Reflectance = 0
					elseif d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 1
					elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then d.Enabled = false end
				end)
				n = n + 1
				if n % 2500 == 0 then task.wait() end
			end
			notify("Ultra FPS", "Pronto! Reentre no servidor pra desfazer.", 4)
		end)
	end
	local flyBV, holdBV
	local function stopFly() if flyBV then flyBV:Destroy() flyBV = nil end end
	local function stopHold() if holdBV then holdBV:Destroy() holdBV = nil end end
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
			if G.anyAuto() then
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
		if (State.Noclip or G.anyAuto()) and lp.Character then
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
	conn(GuiService.ErrorMessageChanged:Connect(function()
		if State.AutoRejoin then task.wait(2); pcall(function() TPS:Teleport(game.PlaceId, lp) end) end
	end))
	conn(RS.RenderStepped:Connect(function() frames = frames + 1 end))

	local origFonts = setmetatable({}, {__mode = "k"})
	local function applyGameFont(inst)
		if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
			if origFonts[inst] == nil then origFonts[inst] = inst.Font end
			if State.GameFont == "Padrão" then inst.Font = origFonts[inst]
			else inst.Font = getFont(State.GameFont, tostring(origFonts[inst]):find("Bold") ~= nil) end
		end
	end
	local function refreshGameFont()
		local pg = lp:FindFirstChild("PlayerGui")
		if not pg then return end
		for _, d in ipairs(pg:GetDescendants()) do pcall(applyGameFont, d) end
	end
	conn(lp:WaitForChild("PlayerGui").DescendantAdded:Connect(function(d)
		if State.GameFont ~= "Padrão" then task.defer(pcall, applyGameFont, d) end
	end))
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
	G.applyLight, G.applyWater, G.boostFPS, G.ultraFPS = applyLight, applyWater, boostFPS, ultraFPS
	G.stopFly, G.stopHold, G.refreshGameFont, G.serverHop = stopFly, stopHold, refreshGameFont, serverHop
end)()

------------------------------------------------------------------
-- BLOCO 6: compras, config, slots, exportar/importar
------------------------------------------------------------------
;(function()
	G.buy = function(label, ...)
		local r = G.invoke(...)
		notify(label, r ~= nil and tostring(r) or "Sem resposta do servidor", 3)
	end
	G.StyleMap = {["Black Leg"] = "BuyBlackLeg", ["Electro"] = "BuyElectro", ["Fishman Karate"] = "BuyFishmanKarate", ["Dragon Claw"] = "BuyDragonClaw",
		["Superhuman"] = "BuySuperhuman", ["Death Step"] = "BuyDeathStep", ["Sharkman Karate"] = "BuySharkmanKarate", ["Electric Claw"] = "BuyElectricClaw",
		["Dragon Talon"] = "BuyDragonTalon", ["Godhuman"] = "BuyGodhuman", ["Sanguine Art"] = "BuySanguineArt"}
	G.StyleNames = {"Black Leg", "Electro", "Fishman Karate", "Dragon Claw", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman", "Sanguine Art"}

	local function collect()
		local d = {}
		for _, k in ipairs(SAVE_KEYS) do d[k] = State[k] end
		return d
	end
	local function applyCfg(d)
		for _, k in ipairs(SAVE_KEYS) do
			if d[k] ~= nil and type(d[k]) == type(Default[k]) then State[k] = d[k] end
		end
		State.Scale = State.ScalePct / 100
		updateCustom()
		applyTheme(State.Theme)
		setPanelFont(State.PanelFont)
		titleLabel.Text = State.Title
		tween(uiscale, 0.25, {Scale = State.Scale})
		applyAppearance(); syncAll(); scheduleParts()
		if G.hudApply then G.hudApply() end
		if G.refreshPos then G.refreshPos() end
		if G.refreshBinds then G.refreshBinds() end
		if G.applyBlack then G.applyBlack() end
	end
	G.saveConfig = function()
		local ok = pcall(function() writefile(CFG_FILE, HttpService:JSONEncode(collect())) end)
		notify("Config", ok and "Configuração salva! Carrega ao reexecutar." or "Seu executor não permite salvar arquivos.", 3)
	end
	G.resetConfig = function()
		local ok = pcall(function() if isfile(CFG_FILE) then delfile(CFG_FILE) end end)
		notify("Config", ok and "Config apagada. Reexecute o script." or "Não foi possível apagar.", 3)
	end
	G.saveSlot = function(n)
		local ok = pcall(function() writefile("AppleHub_v9_slot" .. n .. ".json", HttpService:JSONEncode(collect())) end)
		notify("Slot " .. n, ok and "Config salva no slot!" or "Executor não permite salvar.", 2.5)
	end
	G.loadSlot = function(n)
		local ok, d = pcall(function()
			local f = "AppleHub_v9_slot" .. n .. ".json"
			if isfile(f) then return HttpService:JSONDecode(readfile(f)) end
		end)
		if ok and d then applyCfg(d); notify("Slot " .. n, "Config carregada!", 2.5)
		else notify("Slot " .. n, "Slot vazio.", 2.5) end
	end
	G.exportCfg = function()
		local ok = pcall(function() setclipboard(HttpService:JSONEncode(collect())) end)
		notify("Exportar", ok and "Config copiada para a área de transferência!" or "Executor não tem setclipboard.", 3)
	end
	G.importCfg = function(text)
		local ok, d = pcall(function() return HttpService:JSONDecode(text) end)
		if ok and type(d) == "table" then applyCfg(d); notify("Importar", "Config importada!", 3)
		else notify("Importar", "Texto inválido.", 3) end
	end
end)()

------------------------------------------------------------------
-- BLOCO 7: tracker, HUD, tela preta
------------------------------------------------------------------
;(function()
	local dataVal, commas, loop = G.dataVal, G.commas, G.loop
	G.base = {}
	loop(2, function()
		for _, n in ipairs({"Beli", "Level", "Fragments", "Exp"}) do
			if G.base[n] == nil then
				local v = dataVal(n)
				if v then G.base[n] = v end
			end
		end
	end)
	G.gain = function(n)
		local cur, base = dataVal(n), G.base[n]
		return (cur and base) and (cur - base) or 0
	end
	G.rate = function(n)
		local el = tick() - startTick
		if el < 20 then return "—" end
		return commas(G.gain(n) / (el / 3600))
	end

	G.Feats = {{"Auto Level", "AutoLevel"}, {"Auto Farm", "Farm"}, {"Auto Boss", "AutoBoss"}, {"Auto Click", "Click"}, {"Auto Baús", "Chest"},
		{"Auto Frutas", "FruitGrab"}, {"Bring Mobs", "BringMobs"}, {"Modo Seguro", "SafeMode"}, {"Auto Skills", "AutoSkills"}, {"Auto Elite", "AutoElite"},
		{"Buso", "Buso"}, {"Ken", "Ken"}, {"ESP Jogadores", "ESPPlayers"}, {"ESP Frutas", "ESPFruits"}, {"Fullbright", "Fullbright"},
		{"Voar", "Fly"}, {"Noclip", "Noclip"}, {"Pulo Infinito", "InfJump"}, {"Tela Preta", "BlackScreen"}, {"HUD", "HudOn"}}
	G.FeatNames, G.FeatMap = {}, {}
	for _, f in ipairs(G.Feats) do table.insert(G.FeatNames, f[1]); G.FeatMap[f[1]] = f[2] end

	local hud = new("Frame", {Name = "HUD", Size = UDim2.fromOffset(180, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(0, 12, 0, 70),
		BackgroundColor3 = T.bg, BackgroundTransparency = State.HudAlpha / 100, ZIndex = 30, Visible = State.HudOn, Parent = gui})
	new("UICorner", {CornerRadius = UDim.new(0, 12), Parent = hud})
	new("UIListLayout", {Padding = UDim.new(0, 2), Parent = hud})
	new("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = hud})
	local hs = new("UIScale", {Scale = State.HudScale / 100, Parent = hud})
	local hstroke = new("UIStroke", {Thickness = 1, Transparency = 0.8, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = hud})
	bind(hud, "BackgroundColor3", "bg")
	bind(hstroke, "Color", "accent")
	local L = {}
	for i, k in ipairs({"fps", "lv", "beli", "time", "rate", "st"}) do
		L[k] = mkText({Size = UDim2.new(1, 0, 0, 16), Text = "", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 31, LayoutOrder = i, Parent = hud}, k == "fps", k == "fps" and "accent" or "text")
	end
	L.st.AutomaticSize = Enum.AutomaticSize.Y
	L.st.Size = UDim2.new(1, 0, 0, 0)
	L.st.TextWrapped = true
	L.st.TextColor3 = T.sub
	bind(L.st, "TextColor3", "sub")
	drag(hud, hud)
	G.hudApply = function()
		hud.Visible = State.HudOn
		hud.BackgroundTransparency = State.HudAlpha / 100
		hs.Scale = State.HudScale / 100
		L.fps.Visible, L.lv.Visible, L.beli.Visible = State.HudFPS, State.HudLevel, State.HudBeli
		L.time.Visible, L.rate.Visible, L.st.Visible = State.HudTime, State.HudRate, State.HudStatus
	end
	G.hudUpdate = function()
		if not State.HudOn then return end
		local lvl, beli = dataVal("Level"), dataVal("Beli")
		L.fps.Text = fps .. " FPS  •  " .. getPing() .. " ms"
		L.lv.Text = "Lv " .. (lvl and commas(lvl) or "—") .. "  (+" .. G.gain("Level") .. ")"
		L.beli.Text = "Beli " .. (beli and commas(beli) or "—")
		local s = math.floor(tick() - startTick)
		L.time.Text = string.format("Sessão %02d:%02d:%02d", math.floor(s / 3600), math.floor(s % 3600 / 60), s % 60)
		L.rate.Text = "Beli/h " .. G.rate("Beli") .. "  Lv/h " .. G.rate("Level")
		local on = {}
		for _, f in ipairs(G.Feats) do if State[f[2]] and f[2] ~= "HudOn" then table.insert(on, f[1]) end end
		L.st.Text = #on > 0 and ("ON: " .. table.concat(on, ", ")) or "Nenhuma função ligada"
	end

	-- tela preta (AFK)
	local bs = new("Frame", {Name = "BlackScreen", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Visible = false, ZIndex = 400, Active = true, Parent = gui})
	new("TextLabel", {Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromScale(0, 0.42), BackgroundTransparency = 1, Text = "Tela preta ativa  •  toque 2x para sair", TextSize = 16,
		Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(90, 90, 100), ZIndex = 401, Parent = bs})
	G.bsLabel = new("TextLabel", {Size = UDim2.new(1, 0, 0, 20), Position = UDim2.fromScale(0, 0.48), BackgroundTransparency = 1, Text = "", TextSize = 13,
		Font = Enum.Font.Gotham, TextColor3 = Color3.fromRGB(70, 70, 80), ZIndex = 401, Parent = bs})
	local lastTap = 0
	bs.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			if tick() - lastTap < 0.45 then State.BlackScreen = false; G.applyBlack(); syncAll() end
			lastTap = tick()
		end
	end)
	G.applyBlack = function()
		bs.Visible = State.BlackScreen
		pcall(function() RS:Set3dRenderingEnabled(not State.BlackScreen) end)
	end
	G.after.BlackScreen = G.applyBlack
	G.after.HudOn = G.hudApply
	G.after.Fullbright = G.applyLight
end)()

------------------------------------------------------------------
-- BLOCO 8: atalhos de teclado
------------------------------------------------------------------
;(function()
	conn(UIS.InputBegan:Connect(function(i, gp)
		if gp or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
		for fname, kn in pairs(State.Binds) do
			if i.KeyCode.Name == kn then
				local key = G.FeatMap[fname]
				if key then
					State[key] = not State[key]
					if G.after[key] then pcall(G.after[key], State[key]) end
					syncAll()
					notify(fname, State[key] and "Ligado" or "Desligado", 1.5)
				end
			end
		end
	end))
	G.refreshBinds = function()
		if not G.bindLabel then return end
		local lines = {}
		for f, k in pairs(State.Binds) do table.insert(lines, f .. "  →  " .. k) end
		table.sort(lines)
		G.bindLabel.Text = #lines > 0 and table.concat(lines, "\n") or "Nenhum atalho definido."
	end
	G.setBind = function(t)
		local k = t:gsub("%s", "")
		local ok = pcall(function() return Enum.KeyCode[k] end) and Enum.KeyCode[k] ~= nil
		if not ok then k = k:upper(); ok = pcall(function() return Enum.KeyCode[k] end) and Enum.KeyCode[k] ~= nil end
		if not ok then notify("Atalho", "Tecla inválida: " .. t, 2.5) return end
		State.Binds[State.BindFeat] = k
		G.refreshBinds()
		notify("Atalho", State.BindFeat .. " → " .. k, 2.5)
	end
end)()

------------------------------------------------------------------
-- BLOCO 9: INTRO (6 estilos)
------------------------------------------------------------------
;(function()
	local introActive, introSkip = false, false
	local function introColors()
		if State.IntroColor == "Personalizada" then
			local a = Color3.fromRGB(State.IR, State.IG, State.IB)
			return a, a:Lerp(Color3.fromRGB(255, 80, 200), 0.45)
		end
		return T.accent, T.accent2
	end
	local function playIntro(onDone)
		if introActive then return end
		introActive, introSkip = true, false
		local c1, c2 = introColors()
		local white = Color3.new(1, 1, 1)
		local style, dur = State.IntroStyle, math.max(State.IntroTime, 1.5)
		local typing, pulse = style == "Digitando", style == "Pulse"
		local vp = cam.ViewportSize
		local layer = new("CanvasGroup", {Name = "Intro", Size = UDim2.fromScale(1, 1), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = white, BackgroundTransparency = 1 - State.IntroBg / 100, GroupTransparency = 1, ZIndex = 100, Active = true, Parent = gui})
		new("UIGradient", {Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(2, 2, 8), c1:Lerp(Color3.new(0, 0, 0), 0.82)), Parent = layer})
		local lscale = new("UIScale", {Parent = layer})
		tween(layer, 0.5, {GroupTransparency = 0}, Enum.EasingStyle.Quad)

		local stars = {}
		if State.IntroStars and style ~= "Minimal" then
			for i = 1, 80 do
				local f = new("Frame", {Size = UDim2.fromOffset(2, 2), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = (i % 3 == 0) and c1 or ((i % 3 == 1) and c2 or white), BorderSizePixel = 0, ZIndex = 1, Parent = layer}, {corner(4)})
				stars[i] = {f = f, a = math.random() * math.pi * 2, d = math.random() * 0.6, s = 0.12 + math.random() * 0.3}
			end
		end

		local logoY = 0.36
		local LS = math.clamp(vp.Y * 0.16, 64, 120)
		local glowC = new("Frame", {Size = UDim2.fromOffset(0, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, logoY), BackgroundColor3 = white, BackgroundTransparency = 0.75, ZIndex = 2, Parent = layer},
			{corner(500), new("UIGradient", {Color = ColorSequence.new(c1, c2)})})
		local logo = new("Frame", {Size = UDim2.fromOffset(0, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, logoY), BackgroundColor3 = white, ZIndex = 3, Parent = layer}, {corner(500)})
		local logoG = new("UIGradient", {Color = ColorSequence.new(c1, c2), Rotation = 45, Parent = logo})
		new("UIStroke", {Color = white, Transparency = 0.5, Thickness = 2, Parent = logo})
		new("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = string.sub(State.IntroText, 1, 1), TextSize = LS * 0.5, Font = getFont(State.PanelFont, true), TextColor3 = white, ZIndex = 4, Parent = logo})
		tween(logo, 0.9, {Size = UDim2.fromOffset(LS, LS)}, Enum.EasingStyle.Back)
		tween(glowC, 1.1, {Size = UDim2.fromOffset(LS * 2.2, LS * 2.2)}, Enum.EasingStyle.Back)

		local finished = false
		task.spawn(function()
			task.wait(0.5)
			while introActive and not finished do
				local r = new("Frame", {Size = UDim2.fromOffset(LS, LS), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, logoY), BackgroundTransparency = 1, ZIndex = 2, Parent = layer},
					{corner(500), new("UIStroke", {Color = c1, Thickness = 3})})
				tween(r, 1.6, {Size = UDim2.fromOffset(LS * 4.5, LS * 4.5)}, Enum.EasingStyle.Quad)
				tween(r:FindFirstChildOfClass("UIStroke"), 1.6, {Transparency = 1}, Enum.EasingStyle.Quad)
				task.delay(1.7, function() pcall(function() r:Destroy() end) end)
				task.wait(pulse and 0.45 or 0.75)
			end
		end)

		local tsize = State.IntroTitleSize
		local holder = new("Frame", {Size = UDim2.new(1, 0, 0, tsize + 10), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.62), BackgroundTransparency = 1, ZIndex = 4, Parent = layer},
			{new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, math.floor(tsize * 0.12))})})
		local text = State.IntroText ~= "" and State.IntroText or "APPLE HUB"
		local chars = {}
		for _, cp in utf8.codes(text) do table.insert(chars, utf8.char(cp)) end
		local letters = {}
		local step = typing and 0.1 or 0.07
		local t0letters = typing and 0.6 or 0.9
		for i, ch in ipairs(chars) do
			local l = new("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, tsize + 6), BackgroundTransparency = 1, Text = ch == " " and "  " or ch, TextSize = tsize,
				Font = typing and Enum.Font.Code or getFont(State.PanelFont, true), TextColor3 = c1:Lerp(c2, (i - 1) / math.max(#chars - 1, 1)), TextTransparency = 1, LayoutOrder = i, ZIndex = 5, Parent = holder})
			local st = new("UIStroke", {Color = l.TextColor3, Thickness = 1.2, Transparency = 1, Parent = l})
			local sc = new("UIScale", {Scale = typing and 1 or 2.4, Parent = l})
			letters[i] = {l = l, sc = sc, st = st, c = l.TextColor3}
			task.delay(t0letters + i * step, function()
				if finished then return end
				if typing then l.TextTransparency = 0; st.Transparency = 0.7
				else
					tween(l, 0.5, {TextTransparency = 0}, Enum.EasingStyle.Quad)
					tween(st, 0.6, {Transparency = 0.55})
					tween(sc, 0.6, {Scale = 1}, Enum.EasingStyle.Back)
				end
			end)
		end
		local cursor
		if typing then
			cursor = new("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, tsize + 6), BackgroundTransparency = 1, Text = "▌", TextSize = tsize, Font = Enum.Font.Code,
				TextColor3 = c2, LayoutOrder = 9999, ZIndex = 5, Parent = holder})
		end
		local sub = new("TextLabel", {Size = UDim2.new(1, 0, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.62, tsize * 0.75 + 12), BackgroundTransparency = 1,
			Text = State.IntroSub, TextSize = 13, Font = typing and Enum.Font.Code or getFont(State.PanelFont, false), TextColor3 = Color3.fromRGB(190, 190, 210), TextTransparency = 1, ZIndex = 4, Parent = layer})
		task.delay(t0letters + #chars * step + 0.3, function() if not finished then tween(sub, 0.6, {TextTransparency = 0.1}, Enum.EasingStyle.Quad) end end)

		local fill, pct, status
		local barW = math.clamp(vp.X * 0.4, 180, 340)
		if State.IntroBar then
			local bar = new("Frame", {Size = UDim2.fromOffset(barW, 6), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.8), BackgroundColor3 = white, BackgroundTransparency = 0.88, BorderSizePixel = 0, ZIndex = 4, Parent = layer}, {corner(3)})
			fill = new("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = white, BorderSizePixel = 0, ZIndex = 5, Parent = bar}, {corner(3), new("UIGradient", {Color = ColorSequence.new(c1, c2)})})
			status = new("TextLabel", {Size = UDim2.fromOffset(barW, 18), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.8, -16), BackgroundTransparency = 1, Text = "Iniciando...", TextSize = 12,
				Font = getFont(State.PanelFont, false), TextColor3 = Color3.fromRGB(200, 200, 220), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = layer})
			pct = new("TextLabel", {Size = UDim2.fromOffset(barW, 18), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.8, -16), BackgroundTransparency = 1, Text = "0%", TextSize = 12,
				Font = getFont(State.PanelFont, true), TextColor3 = c1, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4, Parent = layer})
		end
		if State.IntroSkip then
			new("TextLabel", {Size = UDim2.new(1, 0, 0, 16), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.94), BackgroundTransparency = 1, Text = "toque para pular", TextSize = 11,
				Font = getFont(State.PanelFont, false), TextColor3 = Color3.fromRGB(140, 140, 160), ZIndex = 4, Parent = layer})
		end
		local scan = (style == "Glitch") and new("Frame", {Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = c1, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 6, Parent = layer}) or nil

		if style == "Explosão" then
			for _, when in ipairs({0.9, 2.2}) do
				task.delay(when, function()
					if finished then return end
					for i = 1, 40 do
						local a, d = math.random() * math.pi * 2, 0.2 + math.random() * 0.45
						local p = new("TextLabel", {Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, logoY), BackgroundTransparency = 1,
							Text = ({"✦", "✧", "●", "★"})[math.random(4)], TextSize = 10 + math.random() * 14, TextColor3 = (i % 2 == 0) and c1 or c2, ZIndex = 3, Parent = layer})
						tween(p, 1.4, {Position = UDim2.fromScale(0.5 + math.cos(a) * d * 0.8, logoY + math.sin(a) * d), TextTransparency = 1}, Enum.EasingStyle.Quad)
						task.delay(1.5, function() pcall(function() p:Destroy() end) end)
					end
				end)
			end
		end

		layer.InputBegan:Connect(function(i)
			if State.IntroSkip and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then introSkip = true end
		end)

		local t0, rcn = tick(), nil
		local steps = {"Iniciando...", "Carregando módulos...", "Sincronizando Blox Fruits...", "Aplicando tema...", "Pronto!"}
		local function finish()
			if finished then return end
			finished = true
			if rcn then rcn:Disconnect() end
			local flash = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = white, BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 50, Parent = layer})
			tween(flash, 0.5, {BackgroundTransparency = 1})
			tween(lscale, 0.7, {Scale = 1.25}, Enum.EasingStyle.Quint)
			tween(layer, 0.6, {GroupTransparency = 1}, Enum.EasingStyle.Quad)
			task.delay(0.35, function() if onDone then pcall(onDone) end end)
			task.delay(0.8, function() pcall(function() layer:Destroy() end); introActive = false end)
		end
		rcn = conn(RS.RenderStepped:Connect(function(dt)
			if finished then return end
			local el = tick() - t0
			local prog = math.clamp(el / dur, 0, 1)
			local warp = style == "Cinematic" and (1 + prog * 5) or 1
			for _, s in ipairs(stars) do
				s.d = s.d + s.s * dt * warp * 0.6
				if s.d > 0.75 then s.d = 0.02 + math.random() * 0.05; s.a = math.random() * math.pi * 2 end
				s.f.Position = UDim2.fromScale(0.5 + math.cos(s.a) * s.d * 0.75, logoY + math.sin(s.a) * s.d)
				local sz = 1 + s.d * (style == "Cinematic" and 8 * (0.6 + prog) or 3)
				s.f.Size = UDim2.fromOffset(sz, sz)
				s.f.BackgroundTransparency = 1 - math.min(1, s.d * 3)
			end
			logoG.Rotation = 45 + el * 120
			if pulse and el > 1.0 then
				local k = 1 + 0.07 * math.sin(el * 7)
				logo.Size = UDim2.fromOffset(LS * k, LS * k)
				glowC.Size = UDim2.fromOffset(LS * 2.2 * k, LS * 2.2 * k)
				if el > 1.6 then
					for i, e in ipairs(letters) do e.sc.Scale = 1 + 0.05 * math.sin(el * 7 - i * 0.35) end
				end
			end
			if cursor then cursor.TextTransparency = (math.floor(el * 3) % 2 == 0) and 0 or 1 end
			if fill then
				local p = 1 - (1 - prog) ^ 2
				fill.Size = UDim2.new(p, 0, 1, 0)
				pct.Text = math.floor(p * 100) .. "%"
				status.Text = steps[math.clamp(math.floor(prog * 4) + 1, 1, 5)]
			end
			if style == "Glitch" then
				if prog < 0.7 then
					holder.Position = UDim2.new(0.5, math.random(-6, 6), 0.62, math.random(-3, 3))
					for _, e in ipairs(letters) do
						if math.random() < 0.15 then e.l.TextColor3 = ({c1, c2, white, Color3.fromRGB(255, 40, 80), Color3.fromRGB(0, 255, 255)})[math.random(5)] end
					end
				else
					holder.Position = UDim2.fromScale(0.5, 0.62)
					for _, e in ipairs(letters) do e.l.TextColor3 = e.c end
				end
				if scan then scan.Position = UDim2.fromScale(0, (el * 0.6) % 1) end
			end
			if (prog >= 1 and el > dur + 0.3) or introSkip then finish() end
		end))
	end
	G.playIntro = playIntro
end)()

------------------------------------------------------------------
-- BLOCO 10: PÁGINAS
------------------------------------------------------------------
;(function()
	local commas = G.commas
	local pFarm = addPage("Farm", "⚔")
	local pBlox = addPage("Blox", "★")
	local pAuto = addPage("Auto", "⚙")
	local pTp = addPage("Teleport", "➤")
	local pVis = addPage("Visual", "◉")
	local pPlr = addPage("Player", "☻")
	local pInfo = addPage("Info", "ⓘ")
	local pStyle = addPage("Estilo", "✿")
	local pPanel = addPage("Painel", "▣")
	local pTabs = addPage("Abas", "☰")
	local pBtn = addPage("Botões", "◈")
	local pPart = addPage("Partículas", "❄")
	local pIntro = addPage("Intro", "▶")
	local pHud = addPage("HUD", "▤")
	local pKeys = addPage("Atalhos", "✱")
	local pCfg = addPage("Config", "✦")

	-- FARM
	Section(pFarm, "Auto Level (com quests)")
	Toggle(pFarm, "Auto Level + Quest automática", "AutoLevel")
	G.farmInfo = Label(pFarm, "Mar: —")
	Slider(pFarm, "Velocidade de viagem", 100, 600, "TravelSpeed", nil, " st/s")
	Section(pFarm, "Farm manual")
	Toggle(pFarm, "Auto Farm (mob mais próximo)", "Farm")
	Dropdown(pFarm, "Arma", {"Melee", "Sword", "Gun", "Blox Fruit"}, "Weapon")
	Toggle(pFarm, "Equipar arma automático", "AutoEquip")
	Slider(pFarm, "Altura sobre o mob", 4, 25, "Height", nil, " st")
	Section(pFarm, "Boss")
	Dropdown(pFarm, "Boss", G.Bosses, "Boss")
	Toggle(pFarm, "Auto Boss (se estiver no mapa)", "AutoBoss")
	Section(pFarm, "Ataque")
	Toggle(pFarm, "Auto Click rápido", "Click")
	Slider(pFarm, "Delay do ataque", 20, 500, "ClickDelay", nil, " ms")
	Section(pFarm, "Coleta")
	Toggle(pFarm, "Auto Baús", "Chest")
	Toggle(pFarm, "Auto Pegar Frutas", "FruitGrab")

	-- BLOX
	Section(pBlox, "Combate")
	Toggle(pBlox, "Puxar mobs (Bring Mobs)", "BringMobs")
	Slider(pBlox, "Raio de puxar", 100, 600, "BringRadius", nil, " st")
	Toggle(pBlox, "Modo seguro (sobe se HP baixo)", "SafeMode")
	Slider(pBlox, "HP mínimo", 10, 70, "SafePct", nil, "%")
	Toggle(pBlox, "Auto Elite Hunter", "AutoElite")
	Section(pBlox, "Skills automáticas")
	Toggle(pBlox, "Usar skills automaticamente", "AutoSkills")
	Slider(pBlox, "Intervalo", 200, 3000, "SkillDelay", nil, " ms")
	Toggle(pBlox, "Skill Z", "SkillZ")
	Toggle(pBlox, "Skill X", "SkillX")
	Toggle(pBlox, "Skill C", "SkillC")
	Toggle(pBlox, "Skill V", "SkillV")
	Toggle(pBlox, "Skill F", "SkillF")
	Section(pBlox, "Frutas")
	Toggle(pBlox, "Auto guardar frutas no inventário", "AutoStore")
	Toggle(pBlox, "Avisar quando fruta nascer", "FruitNotify")
	Toggle(pBlox, "Auto comprar fruta aleatória (10s)", "AutoRoll")
	Section(pBlox, "Compras")
	Button(pBlox, "Comprar Geppo", function() G.buy("Geppo", "BuyHaki", "Geppo") end)
	Button(pBlox, "Comprar Buso Haki", function() G.buy("Buso", "BuyHaki", "Buso") end)
	Button(pBlox, "Comprar Soru", function() G.buy("Soru", "BuyHaki", "Soru") end)
	Button(pBlox, "Comprar Ken Haki", function() G.buy("Ken", "KenTalk", "Buy") end)
	Dropdown(pBlox, "Estilo de luta", G.StyleNames, "Style")
	Button(pBlox, "Comprar estilo selecionado", function() G.buy(State.Style, G.StyleMap[State.Style] or "BuyBlackLeg") end)
	Section(pBlox, "Jogadores")
	Input(pBlox, "Ir até jogador", "nome e Enter", function(name)
		name = name:lower()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= lp and (p.Name:lower():find(name, 1, true) or p.DisplayName:lower():find(name, 1, true)) then
				local hr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				if hr then
					State.ManualTravel = true
					G.goTo(hr.CFrame * CFrame.new(0, 4, 0))
					State.ManualTravel = false
					notify("Teleporte", "Cheguei em " .. p.DisplayName, 2)
					return
				end
			end
		end
		notify("Teleporte", "Jogador não encontrado", 2)
	end)

	-- AUTO
	Section(pAuto, "Haki")
	Toggle(pAuto, "Auto Buso Haki", "Buso")
	Toggle(pAuto, "Auto Ken Haki", "Ken")
	Section(pAuto, "Status")
	Dropdown(pAuto, "Status", {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}, "Stat")
	Slider(pAuto, "Pontos por vez", 1, 10, "StatPoints")
	Toggle(pAuto, "Auto Status", "AutoStats")
	Section(pAuto, "Códigos")
	Toggle(pAuto, "Auto resgatar códigos ao ligar", "AutoCodes", function(v) if v then G.redeemAll() end end)
	Button(pAuto, "Resgatar todos os códigos agora", function() G.redeemAll() end)
	Input(pAuto, "Adicionar código", "digite e dê Enter", function(code) G.addCode(code) end)
	G.codeLog = Label(pAuto, "Log dos códigos aparece aqui.")
	Section(pAuto, "Conta")
	Button(pAuto, "Entrar no time Pirata", function() G.invoke("SetTeam", "Pirates") notify("Time", "Pedido enviado: Pirata", 2) end)
	Button(pAuto, "Entrar no time Marinha", function() G.invoke("SetTeam", "Marines") notify("Time", "Pedido enviado: Marinha", 2) end)
	Button(pAuto, "Comprar fruta aleatória (Beli)", function() G.buy("Fruta", "Cousin", "Buy") end)

	-- TELEPORT
	Section(pTp, "Mares")
	Button(pTp, "Primeiro Mar", function() G.invoke("TravelMain") end)
	Button(pTp, "Segundo Mar", function() G.invoke("TravelDressrosa") end)
	Button(pTp, "Terceiro Mar", function() G.invoke("TravelZou") end)
	Section(pTp, "Zonas do mar atual")
	if #G.ZoneNames > 0 then
		Dropdown(pTp, "Zona", G.ZoneNames, "Zone")
		Button(pTp, "Viajar até a zona", function()
			local e = G.ZoneMap[State.Zone]
			if not e then return end
			State.ManualTravel = true
			G.goTo(CFrame.new(e.m + Vector3.new(0, 6, 0)))
			State.ManualTravel = false
		end)
	end
	Section(pTp, "Posições salvas")
	Input(pTp, "Salvar posição atual", "nome e Enter", function(name)
		local r = G.root()
		if not r then notify("Posição", "Sem personagem.", 2) return end
		State.Pos[name] = {math.floor(r.Position.X), math.floor(r.Position.Y), math.floor(r.Position.Z)}
		G.refreshPos()
		notify("Posição", "\"" .. name .. "\" salva!", 2)
	end)
	local posBox = new("Frame", {Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = pTp},
		{new("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})})
	local function smallBtn(parent, txt, x, color)
		local b = mkText({Size = UDim2.fromOffset(34, 26), Position = UDim2.new(1, x, 0.5, -13), Text = txt, TextSize = 12, AutoButtonColor = false, Parent = parent}, true, false, "TextButton")
		b.BackgroundTransparency = 0
		b.BackgroundColor3 = color
		b.TextColor3 = Color3.new(1, 1, 1)
		new("UICorner", {CornerRadius = UDim.new(0, 8), Parent = b})
		return b
	end
	G.refreshPos = function()
		for _, c in ipairs(posBox:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
		local names = {}
		for n in pairs(State.Pos) do table.insert(names, n) end
		table.sort(names)
		for i, n in ipairs(names) do
			local p = State.Pos[n]
			local r = row(posBox, 38)
			r.LayoutOrder = i
			mkText({Size = UDim2.new(1, -100, 1, 0), Position = UDim2.fromOffset(12, 0), Text = n, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = r}, true)
			local go = smallBtn(r, "Ir", -80, T.accent)
			local del = smallBtn(r, "✕", -40, Color3.fromRGB(220, 70, 70))
			go.MouseButton1Click:Connect(function()
				task.spawn(function()
					State.ManualTravel = true
					G.goTo(CFrame.new(p[1], p[2] + 4, p[3]))
					State.ManualTravel = false
				end)
			end)
			del.MouseButton1Click:Connect(function() State.Pos[n] = nil; G.refreshPos() end)
		end
	end
	G.refreshPos()
	Section(pTp, "Utilidades")
	Button(pTp, "Ir até a fruta mais próxima", function()
		local f = G.findFruit()
		if f then
			State.ManualTravel = true
			G.goTo(f.Handle.CFrame)
			State.ManualTravel = false
			notify("Fruta", f.Name, 2)
		else
			notify("Fruta", "Nenhuma fruta no mapa", 2)
		end
	end)
	Button(pTp, "Server Hop", function() G.serverHop() end)
	Button(pTp, "Reentrar no servidor", function() TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp) end)
	Button(pTp, "Resetar personagem", function() local h = G.hum() if h then h.Health = 0 end end)

	-- VISUAL
	Section(pVis, "ESP")
	Toggle(pVis, "ESP Jogadores", "ESPPlayers")
	Toggle(pVis, "ESP Frutas", "ESPFruits")
	Toggle(pVis, "ESP Baús", "ESPChests")
	Toggle(pVis, "ESP Bosses", "ESPBosses")
	Section(pVis, "Ambiente")
	Toggle(pVis, "Fullbright (claridade)", "Fullbright", G.applyLight)
	Toggle(pVis, "Remover neblina", "NoFog", G.applyLight)
	Slider(pVis, "Campo de visão", 30, 120, "FOV", function(v) cam.FieldOfView = v end)
	Slider(pVis, "Hora do dia", 0, 24, "Clock", function(v) Lighting.ClockTime = v end, "h")
	Section(pVis, "Desempenho")
	Button(pVis, "Modo desempenho (menos lag)", function() G.boostFPS() end)
	Button(pVis, "Ultra FPS (remove texturas)", function() G.ultraFPS() end)

	-- PLAYER
	Section(pPlr, "Movimento")
	Toggle(pPlr, "Velocidade personalizada", "SpeedOn", function(v) if not v then local h = G.hum() if h then h.WalkSpeed = 16 end end end)
	Slider(pPlr, "Velocidade", 16, 200, "Speed")
	Toggle(pPlr, "Pulo personalizado", "JumpOn", function(v) if not v then local h = G.hum() if h then h.JumpPower = 50 end end end)
	Slider(pPlr, "Força do pulo", 50, 300, "Jump")
	Toggle(pPlr, "Voar", "Fly")
	Slider(pPlr, "Velocidade do voo", 20, 200, "FlySpeed")
	Toggle(pPlr, "Noclip", "Noclip")
	Toggle(pPlr, "Pulo infinito", "InfJump")
	Toggle(pPlr, "Andar na água", "Water", G.applyWater)
	Slider(pPlr, "Gravidade", 20, 300, "Gravity", function(v) workspace.Gravity = v end)

	-- INFO
	local head = row(pInfo, 96)
	local av = new("ImageLabel", {Size = UDim2.fromOffset(74, 74), Position = UDim2.fromOffset(12, 11), BackgroundColor3 = T.side, Parent = head}, {corner(37)})
	bind(av, "BackgroundColor3", "side")
	bind(new("UIStroke", {Color = T.accent, Thickness = 2.5, Parent = av}), "Color", "accent")
	mkText({Size = UDim2.new(1, -110, 0, 28), Position = UDim2.fromOffset(98, 18), Text = lp.DisplayName, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = head}, true)
	mkText({Size = UDim2.new(1, -110, 0, 20), Position = UDim2.fromOffset(98, 46), Text = "@" .. lp.Name, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = head}, false, "sub")
	task.spawn(function()
		local ok, img = pcall(function() return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
		if ok then av.Image = img; chipAv.Image = img end
	end)
	local gameName = "..."
	task.spawn(function()
		local ok, info = pcall(function() return Market:GetProductInfo(game.PlaceId) end)
		gameName = ok and info.Name or "Desconhecido"
	end)
	local function fmtTime(s) return string.format("%02d:%02d:%02d", math.floor(s / 3600), math.floor(s % 3600 / 60), math.floor(s % 60)) end
	Section(pInfo, "Conta")
	InfoRow(pInfo, "ID do usuário", function() return tostring(lp.UserId) end)
	InfoRow(pInfo, "Conta criada em", function() return os.date("!%d/%m/%Y", os.time() - lp.AccountAge * 86400) end)
	InfoRow(pInfo, "Idade da conta", function() return lp.AccountAge .. " dias" end)
	InfoRow(pInfo, "Assinatura", function() return lp.MembershipType.Name end)
	InfoRow(pInfo, "Time", function() return lp.Team and lp.Team.Name or "Nenhum" end)
	Section(pInfo, "Blox Fruits")
	InfoRow(pInfo, "Level", function() local v = G.dataVal("Level") return v and commas(v) or "—" end)
	InfoRow(pInfo, "Beli", function() local v = G.dataVal("Beli") return v and commas(v) or "—" end)
	InfoRow(pInfo, "Fragmentos", function() local v = G.dataVal("Fragments") return v and commas(v) or "—" end)
	InfoRow(pInfo, "Fruta", function() local v = G.dataVal("DevilFruit") return (v and v ~= "") and tostring(v) or "—" end)
	Section(pInfo, "Tracker da sessão")
	InfoRow(pInfo, "Levels ganhos", function() return commas(G.gain("Level")) end)
	InfoRow(pInfo, "Levels por hora", function() return G.rate("Level") end)
	InfoRow(pInfo, "Beli ganho", function() return commas(G.gain("Beli")) end)
	InfoRow(pInfo, "Beli por hora", function() return G.rate("Beli") end)
	InfoRow(pInfo, "Fragmentos ganhos", function() return commas(G.gain("Fragments")) end)
	Section(pInfo, "Sessão")
	InfoRow(pInfo, "Jogo", function() return gameName end)
	InfoRow(pInfo, "Place ID", function() return tostring(game.PlaceId) end)
	InfoRow(pInfo, "Jogadores", function() return #Players:GetPlayers() .. "/" .. Players.MaxPlayers end)
	InfoRow(pInfo, "Server ID", function() return string.sub(game.JobId, 1, 13) .. "…" end)
	InfoRow(pInfo, "Dispositivo", function() return (UIS.TouchEnabled and not UIS.KeyboardEnabled) and "Celular / Tablet" or "PC" end)
	InfoRow(pInfo, "Executor", function() local ok, n = pcall(identifyexecutor) return ok and tostring(n) or "Desconhecido" end)
	InfoRow(pInfo, "FPS", function() return tostring(fps) end)
	InfoRow(pInfo, "Ping", function() return getPing() .. " ms" end)
	InfoRow(pInfo, "Tempo de sessão", function() return fmtTime(tick() - startTick) end)

	-- ESTILO
	Section(pStyle, "Estilos prontos (muda tudo de uma vez)")
	PresetGrid(pStyle)
	Section(pStyle, "Temas")
	ThemeGrid(pStyle)
	Section(pStyle, "Cor personalizada")
	Slider(pStyle, "Vermelho", 0, 255, "R", function() updateCustom(); applyTheme("Custom") end)
	Slider(pStyle, "Verde", 0, 255, "G", function() updateCustom(); applyTheme("Custom") end)
	Slider(pStyle, "Azul", 0, 255, "B", function() updateCustom(); applyTheme("Custom") end)
	Toggle(pStyle, "Cor de destaque arco-íris", "Rainbow", function(v)
		if v then
			for k, val in pairs(T) do Themes.Custom[k] = val end
			applyTheme("Custom")
		end
	end)
	Section(pStyle, "Fonte do painel")
	FontGrid(pStyle, "PanelFont", false, setPanelFont)
	Section(pStyle, "Fonte do jogo (menus, chat, HUD)")
	FontGrid(pStyle, "GameFont", true, G.refreshGameFont)

	-- PAINEL
	Section(pPanel, "Tamanho e posição")
	Label(pPanel, "Dica: arraste o canto ◢ do painel para redimensionar na hora.")
	Slider(pPanel, "Escala do painel", 50, 120, "ScalePct", function(v) State.Scale = v / 100; tween(uiscale, 0.25, {Scale = State.Scale}) end, "%")
	Slider(pPanel, "Largura", 480, 900, "PanelW", applyAppearance, " px")
	Slider(pPanel, "Altura", 300, 560, "PanelH", applyAppearance, " px")
	Toggle(pPanel, "Travar posição do painel", "LockPos")
	Section(pPanel, "Fundo")
	Slider(pPanel, "Transparência do painel", 0, 60, "Opacity", applyAppearance, "%")
	Slider(pPanel, "Arredondamento", 0, 32, "Corner", applyAppearance)
	Slider(pPanel, "Brilho do fundo", 0, 50, "Glow", applyAppearance, "%")
	Slider(pPanel, "Ângulo do brilho", 0, 360, "GlowAngle", applyAppearance, "°")
	Toggle(pPanel, "Brilho animado (giratório)", "AnimGlow")
	Toggle(pPanel, "Linha de destaque no topo", "TopLine", applyAppearance)
	Slider(pPanel, "Espessura da linha", 1, 8, "TopLineH", applyAppearance, " px")
	Section(pPanel, "Bordas")
	Toggle(pPanel, "Bordas de vidro", "Borders", applyAppearance)
	Dropdown(pPanel, "Cor da borda do painel", {"Vidro", "Destaque"}, "BorderMode", applyAppearance)
	Slider(pPanel, "Espessura da borda", 0, 6, "BorderThick", applyAppearance, " px")
	Slider(pPanel, "Transparência da borda", 0, 100, "BorderAlpha", applyAppearance, "%")
	Section(pPanel, "Cards e espaçamento")
	Slider(pPanel, "Transparência dos cards", 0, 80, "RowAlpha", applyAppearance, "%")
	Slider(pPanel, "Espaço entre itens", 2, 20, "ItemGap", applyAppearance, " px")
	Section(pPanel, "Janela")
	Toggle(pPanel, "Desfocar o jogo atrás do painel", "Blur", updateBlur)
	Slider(pPanel, "Intensidade do desfoque", 2, 30, "BlurSize", updateBlur)
	Input(pPanel, "Nome do hub", "digite e dê Enter", function(t) State.Title = t; titleLabel.Text = t end)
	Slider(pPanel, "Tamanho do título", 10, 22, "TitleSize", applyAppearance)
	Dropdown(pPanel, "Alinhar título", {"Centro", "Esquerda"}, "TitleAlign", applyAppearance)
	Toggle(pPanel, "Mostrar FPS e ping", "ShowChip", applyAppearance)
	Toggle(pPanel, "Mostrar cartão do jogador", "ShowCard", applyAppearance)
	Dropdown(pPanel, "Tecla mostrar/esconder", {"RightShift", "RightControl", "LeftAlt", "Insert", "K", "M", "P"}, "ToggleKey")
	Section(pPanel, "Bolha (minimizado)")
	Slider(pPanel, "Tamanho da bolha", 36, 80, "BubbleSize", applyAppearance, " px")
	Dropdown(pPanel, "Formato da bolha", {"Redonda", "Quadrada"}, "BubbleShape", applyAppearance)
	Input(pPanel, "Letra da bolha", "1-2 letras e Enter", function(t) State.BubbleText = string.sub(t, 1, 2); applyAppearance() end)
	Section(pPanel, "Notificações")
	Toggle(pPanel, "Mostrar notificações", "NotifyOn")
	Dropdown(pPanel, "Posição", {"Direita", "Esquerda", "Centro"}, "NotifyPos", applyAppearance)
	Section(pPanel, "Sons da interface")
	Toggle(pPanel, "Sons ao clicar", "SoundOn")
	Dropdown(pPanel, "Tipo de som", {"Clique", "Switch", "Snap"}, "SoundType")
	Slider(pPanel, "Volume", 5, 100, "SoundVol", nil, "%")
	Button(pPanel, "Testar som", function() local old = State.SoundOn; State.SoundOn = true; uiSound(); State.SoundOn = old end)
	Section(pPanel, "Restaurar")
	Button(pPanel, "Restaurar visual padrão", resetAppearance)

	-- ABAS
	Section(pTabs, "Estilo das abas")
	Dropdown(pTabs, "Indicador", {"Preenchido", "Contorno", "Suave", "Barra", "Sublinhado"}, "TabStyle", applyAppearance)
	Slider(pTabs, "Altura da aba", 24, 48, "TabH", applyAppearance, " px")
	Slider(pTabs, "Espaço entre abas", 0, 12, "TabGap", applyAppearance, " px")
	Slider(pTabs, "Tamanho do texto", 10, 18, "TabSize", applyAppearance)
	Slider(pTabs, "Arredondamento da aba", 0, 20, "TabCorner", applyAppearance)
	Toggle(pTabs, "Mostrar ícones", "TabIcons", applyAppearance)
	Dropdown(pTabs, "Alinhamento do texto", {"Esquerda", "Centro"}, "TabAlign", applyAppearance)
	Section(pTabs, "Barra lateral")
	Slider(pTabs, "Largura da barra", 90, 180, "SideW", applyAppearance, " px")
	Slider(pTabs, "Transparência da barra", 0, 80, "SideAlpha", applyAppearance, "%")
	Section(pTabs, "Transição entre abas")
	Dropdown(pTabs, "Tipo de transição", TransList, "Transition")
	Dropdown(pTabs, "Suavização", EasingList, "Easing")
	Slider(pTabs, "Duração", 100, 1000, "TransTime", nil, " ms")

	-- BOTÕES
	Section(pBtn, "Visual do botão")
	Dropdown(pBtn, "Estilo", {"Gradiente", "Sólido", "Contorno", "Vidro", "Neon"}, "BtnStyle", applyAppearance)
	Slider(pBtn, "Altura", 30, 60, "BtnH", applyAppearance, " px")
	Slider(pBtn, "Arredondamento", 0, 30, "BtnCorner", applyAppearance)
	Slider(pBtn, "Tamanho do texto", 10, 18, "BtnTextSize", applyAppearance)
	Slider(pBtn, "Ângulo do gradiente", 0, 360, "BtnAngle", applyAppearance, "°")
	Section(pBtn, "Efeitos")
	Toggle(pBtn, "Reflexo de vidro", "BtnGloss", applyAppearance)
	Toggle(pBtn, "Brilho passando", "BtnShine")
	Toggle(pBtn, "Ondinha ao tocar", "BtnRipple")
	Toggle(pBtn, "Zoom ao passar o mouse", "BtnHover")
	Section(pBtn, "Interruptores")
	Dropdown(pBtn, "Formato", {"Pílula", "Quadrado"}, "SwShape", applyAppearance)
	Section(pBtn, "Teste")
	Button(pBtn, "Botão de exemplo ✦", function() notify("Botão", "Ficou lindo, né? 😄", 2) end)
	Button(pBtn, "Outro botão de exemplo", function() notify("Botão", "Mude o estilo acima!", 2) end)

	-- PARTÍCULAS
	Section(pPart, "Partículas")
	Toggle(pPart, "Ativar partículas", "PartOn", scheduleParts)
	Dropdown(pPart, "Tipo", PTypeNames, "PType", scheduleParts)
	Slider(pPart, "Quantidade", 5, 150, "PCount", scheduleParts)
	Slider(pPart, "Velocidade", 20, 300, "PSpeed", nil, "%")
	Slider(pPart, "Tamanho", 2, 24, "PSize", scheduleParts, " px")
	Slider(pPart, "Vento", -100, 100, "PWind")
	Slider(pPart, "Transparência", 0, 90, "PAlpha", function() recolorParts() end, "%")
	Dropdown(pPart, "Direção", {"Auto", "Cair", "Subir"}, "PDir")
	Section(pPart, "Cor")
	Dropdown(pPart, "Modo de cor", {"Original", "Tema", "Arco-íris", "Personalizada"}, "PColor", function() recolorParts() end)
	Slider(pPart, "Vermelho", 0, 255, "PR", function() recolorParts() end)
	Slider(pPart, "Verde", 0, 255, "PG", function() recolorParts() end)
	Slider(pPart, "Azul", 0, 255, "PB", function() recolorParts() end)
	Section(pPart, "Comportamento")
	Dropdown(pPart, "Camada", {"Atrás", "Na frente"}, "PLayer", scheduleParts)
	Toggle(pPart, "Cobrir a tela inteira", "PFull", scheduleParts)
	Toggle(pPart, "Balançar de lado", "PSway")
	Toggle(pPart, "Girar partículas", "PSpin")
	Toggle(pPart, "Piscar", "PTwinkle", function() recolorParts() end)

	-- INTRO
	Section(pIntro, "Intro")
	Toggle(pIntro, "Mostrar intro ao executar", "IntroOn")
	Button(pIntro, "▶ Testar intro agora", function() G.playIntro() end)
	Dropdown(pIntro, "Estilo", {"Cinematic", "Glitch", "Explosão", "Minimal", "Digitando", "Pulse"}, "IntroStyle")
	Input(pIntro, "Título", "texto e Enter", function(t) State.IntroText = t end)
	Input(pIntro, "Subtítulo", "texto e Enter", function(t) State.IntroSub = t end)
	Slider(pIntro, "Duração", 2, 10, "IntroTime", nil, " s")
	Slider(pIntro, "Tamanho do título", 24, 72, "IntroTitleSize")
	Slider(pIntro, "Opacidade do fundo", 40, 100, "IntroBg", nil, "%")
	Section(pIntro, "Cores e extras")
	Dropdown(pIntro, "Cor da intro", {"Tema", "Personalizada"}, "IntroColor")
	Slider(pIntro, "Vermelho", 0, 255, "IR")
	Slider(pIntro, "Verde", 0, 255, "IG")
	Slider(pIntro, "Azul", 0, 255, "IB")
	Toggle(pIntro, "Estrelas / partículas", "IntroStars")
	Toggle(pIntro, "Barra de carregamento", "IntroBar")
	Toggle(pIntro, "Tocar para pular", "IntroSkip")

	-- HUD
	Section(pHud, "Mini HUD (arrastável)")
	Toggle(pHud, "Mostrar HUD na tela", "HudOn", function() G.hudApply() end)
	Toggle(pHud, "FPS e ping", "HudFPS", function() G.hudApply() end)
	Toggle(pHud, "Level e ganho", "HudLevel", function() G.hudApply() end)
	Toggle(pHud, "Beli", "HudBeli", function() G.hudApply() end)
	Toggle(pHud, "Tempo de sessão", "HudTime", function() G.hudApply() end)
	Toggle(pHud, "Beli e Lv por hora", "HudRate", function() G.hudApply() end)
	Toggle(pHud, "Funções ligadas", "HudStatus", function() G.hudApply() end)
	Slider(pHud, "Tamanho do HUD", 60, 160, "HudScale", function() G.hudApply() end, "%")
	Slider(pHud, "Transparência do HUD", 0, 90, "HudAlpha", function() G.hudApply() end, "%")

	-- ATALHOS
	Section(pKeys, "Atalhos de teclado (PC)")
	Label(pKeys, "Escolha a função, digite a tecla (ex: F, G, F5, RightAlt) e dê Enter. Aperte a tecla para ligar/desligar.")
	Dropdown(pKeys, "Função", G.FeatNames, "BindFeat")
	Input(pKeys, "Tecla", "ex: F e Enter", function(t) G.setBind(t) end)
	Button(pKeys, "Remover atalho da função", function() State.Binds[State.BindFeat] = nil; G.refreshBinds() end)
	Button(pKeys, "Limpar todos os atalhos", function() State.Binds = {}; G.refreshBinds() end)
	Section(pKeys, "Atalhos atuais")
	G.bindLabel = Label(pKeys, "Nenhum atalho definido.")
	G.refreshBinds()

	-- CONFIG
	Section(pCfg, "Configuração")
	Button(pCfg, "Salvar aparência e ajustes", function() G.saveConfig() end)
	Button(pCfg, "Apagar config salva", function() G.resetConfig() end)
	Section(pCfg, "Slots de config")
	for n = 1, 3 do
		Button(pCfg, "Salvar no slot " .. n, function() G.saveSlot(n) end)
		Button(pCfg, "Carregar slot " .. n, function() G.loadSlot(n) end)
	end
	Section(pCfg, "Compartilhar")
	Button(pCfg, "Exportar config (copiar)", function() G.exportCfg() end)
	Input(pCfg, "Importar config", "cole o texto e Enter", function(t) G.importCfg(t) end)
	Section(pCfg, "AFK e sistema")
	Toggle(pCfg, "Tela preta (economiza bateria/GPU)", "BlackScreen", G.applyBlack)
	Toggle(pCfg, "Reconectar automaticamente se cair", "AutoRejoin")
	Slider(pCfg, "Limite de FPS", 15, 360, "FPSCap", function(v) pcall(function() setfpscap(v) end) end)
	Label(pCfg, "Anti-AFK sempre ligado. No PC, use a tecla escolhida em Painel. No celular, use a bolinha amarela e toque na bolha.")
	Section(pCfg, "Hub")
	Button(pCfg, "Descarregar hub", function() if getgenv and getgenv().AppleHubUnload then getgenv().AppleHubUnload() end end)
end)()

------------------------------------------------------------------
-- BLOCO 11: loops da interface, unload e abertura
------------------------------------------------------------------
;(function()
	G.loop(1, function()
		fps = frames
		frames = 0
		chipLabel.Text = fps .. " FPS  •  " .. getPing() .. " ms"
		local lvl = G.dataVal("Level")
		chipLv.Text = lvl and ("Lv " .. G.commas(lvl)) or "Lv —"
		local e = G.questFor(lvl or 1)
		if G.farmInfo then
			G.farmInfo.Text = "Mar " .. G.seaIndex() .. "  •  Level " .. (lvl and G.commas(lvl) or "?") .. "  •  Quest: " .. (e and e.mob or "sem dados (farma o mais próximo)")
		end
		for _, r in ipairs(infoRows) do
			local ok, v = pcall(r[2])
			r[1].Text = ok and tostring(v) or "—"
		end
		G.hudUpdate()
		if State.BlackScreen and G.bsLabel then
			G.bsLabel.Text = fps .. " FPS  •  Lv " .. (lvl and G.commas(lvl) or "—") .. "  •  Beli +" .. G.commas(G.gain("Beli"))
		end
	end)
	local hue = 0
	task.spawn(function()
		while alive do
			task.wait(0.05)
			if State.AnimGlow then glowG.Rotation = (glowG.Rotation + 2) % 360 end
			if State.Rainbow then
				hue = (hue + 0.008) % 1
				Themes.Custom.accent = Color3.fromHSV(hue, 0.7, 1)
				Themes.Custom.accent2 = Color3.fromHSV((hue + 0.12) % 1, 0.7, 1)
				if T == Themes.Custom then
					for _, f in ipairs(fastBinders) do f(0) end
				end
			end
		end
	end)

	local function unload()
		alive = false
		State.AutoLevel, State.Farm, State.AutoBoss, State.Chest, State.FruitGrab, State.AutoElite = false, false, false, false, false, false
		State.Fly, State.Fullbright, State.NoFog, State.Water, State.GameFont, State.BlackScreen = false, false, false, false, "Padrão", false
		pcall(G.applyLight)
		pcall(G.applyWater)
		pcall(G.refreshGameFont)
		pcall(G.stopFly)
		pcall(G.stopHold)
		pcall(function() RS:Set3dRenderingEnabled(true) end)
		pcall(function() workspace.Gravity = 196.2 end)
		pcall(function() blur:Destroy() end)
		for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
		pcall(function() gui:Destroy() end)
	end
	if getgenv then getgenv().AppleHubUnload = unload end
	red.MouseButton1Click:Connect(unload)

	-- ABERTURA
	layoutTabs()
	switchTab("Farm")
	applyAppearance()
	buildParts()
	G.hudApply()
	G.applyBlack()
	uiscale.Scale = State.Scale * 0.88
	local function startup()
		showMain()
		task.delay(0.7, function() notify("Apple Hub v9", "Carregado! Bom jogo ✦", 3) end)
		if State.AutoCodes then task.delay(5, G.redeemAll) end
	end
	if State.IntroOn then
		local ok = pcall(G.playIntro, startup)
		if not ok then startup() end
		task.delay(State.IntroTime + 3, function() if alive and main.GroupTransparency >= 1 then startup() end end)
	else
		startup()
	end
end)()
-- ===== APPLE HUB v16 — PARTE 3 (cole depois das Partes 1 e 2 do v9) =====

------------------------------------------------------------------
-- BLOCO A: estado novo, log, webhook
------------------------------------------------------------------
;(function()
	if not (G and G.loop and addPage and Section) then warn("[AppleHub v16] Cole esta parte DEPOIS das Partes 1 e 2 do v9.") return end
	local V = {}
	G.V = V
	local NEW = {
		RadarOn = false, RadarSize = 140, RadarRange = 250, RadarAlpha = 35, RadarPlayers = true, RadarFruits = true, RadarBosses = true, RadarChests = false,
		DockOn = false, DockSize = 34, DockVert = false, DockAlpha = 25, DockPick = "Voar", DockItems = {"Auto Level", "Auto Farm", "Voar", "Noclip"},
		FilterOn = false, FPreset = "Nenhum", FBright = 0, FContrast = 0, FSat = 0, FTR = 255, FTG = 255, FTB = 255, FBloom = 0, FSun = 0, FBlur = 0, FVig = 0,
		AuraOn = false, AuraFill = 70, TrailOn = false, TrailLife = 10, SparkOn = false, SparkRate = 25, CosMode = "Tema",
		ZoomInf = false, ZoomMax = 600, ClickTP = false, CineBars = false, CineSize = 12, CoordsOn = false,
		QuestNPC = "", AfkMove = false, AfkEvery = 60, AutoSaveCfg = false, AutoSaveEvery = 120,
		WebhookOn = false, WhFruit = true, WhLevel = true, WhBoss = true, WhEvery = 0,
		GoalLevel = 2550, TargetFruit = "Leopard", SrvSort = "Menos jogadores",
	}
	for k, v in pairs(NEW) do
		State[k] = v
		Default[k] = v
		table.insert(SAVE_KEYS, k)
	end
	pcall(function()
		if isfile and isfile(CFG_FILE) then
			local d = HttpService:JSONDecode(readfile(CFG_FILE))
			for k, v in pairs(NEW) do
				if d[k] ~= nil and type(d[k]) == type(v) then State[k] = d[k] end
			end
		end
	end)
	-- a URL do webhook fica num arquivo separado (não vai no "Exportar config")
	local WH_FILE = "AppleHub_v16_webhook.txt"
	State.WebhookURL = ""
	pcall(function() if isfile and isfile(WH_FILE) then State.WebhookURL = readfile(WH_FILE) end end)
	V.saveWebhookURL = function(u)
		State.WebhookURL = u
		pcall(function() writefile(WH_FILE, u) end)
	end
	if State.Title == Default.Title then
		State.Title = "Apple Hub v16  •  Blox Fruits"
		titleLabel.Text = State.Title
	end

	-- log de notificações
	V.log = {}
	local oldNotify = notify
	notify = function(t, m, d)
		table.insert(V.log, 1, os.date("%H:%M:%S") .. "  " .. tostring(t) .. " — " .. tostring(m))
		if #V.log > 40 then table.remove(V.log) end
		return oldNotify(t, m, d)
	end

	-- novas funções para dock / atalhos / console
	local extra = {{"Radar", "RadarOn"}, {"Aura", "AuraOn"}, {"Rastro", "TrailOn"}, {"Brilhos", "SparkOn"}, {"Filtros", "FilterOn"},
		{"Click TP", "ClickTP"}, {"Barras Cinema", "CineBars"}, {"Coordenadas", "CoordsOn"}, {"Dock", "DockOn"},
		{"Zoom Infinito", "ZoomInf"}, {"Anti-AFK Mov.", "AfkMove"}}
	for _, f in ipairs(extra) do
		table.insert(G.Feats, f)
		table.insert(G.FeatNames, f[1])
		G.FeatMap[f[1]] = f[2]
	end

	-- webhook
	local req = (syn and syn.request) or http_request or request or (http and http.request)
	V.webhook = function(title, desc, color)
		local url = State.WebhookURL
		if not State.WebhookOn or url == "" or not req or not url:find("^https://") then return false end
		pcall(function()
			req({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"},
				Body = HttpService:JSONEncode({username = "Apple Hub", embeds = {{title = title, description = desc, color = color or 3447003,
					footer = {text = lp.DisplayName .. " • " .. os.date("%H:%M")}}}})})
		end)
		return true
	end
	V.summary = function()
		local s = math.floor(tick() - startTick)
		V.webhook("📊 Resumo da sessão", string.format("Tempo: %02d:%02d:%02d\nLevel: %s (+%s)\nBeli: %s (+%s)\nBeli/h: %s",
			math.floor(s / 3600), math.floor(s % 3600 / 60), s % 60, G.commas(G.dataVal("Level") or 0), G.commas(G.gain("Level")),
			G.commas(G.dataVal("Beli") or 0), G.commas(G.gain("Beli")), G.rate("Beli")), 3447003)
	end
	V.rateNum = function(n)
		local el = tick() - startTick
		if el < 20 then return 0 end
		return G.gain(n) / (el / 3600)
	end
	local lastLv, lastFruit, lastBoss, lastSum = nil, nil, {}, tick()
	G.loop(3, function()
		if not State.WebhookOn then return end
		local lvl = G.dataVal("Level")
		if State.WhLevel and lvl then
			if lastLv and lvl > lastLv then V.webhook("⬆ Level up!", "Level **" .. lvl .. "**\nSessão: +" .. G.gain("Level") .. " levels", 5763719) end
			lastLv = lvl
		end
		if State.WhFruit then
			local f = G.findFruit()
			if f and f ~= lastFruit then
				lastFruit = f
				V.webhook("🍎 Fruta spawnou!", f.Name .. "\nServidor: " .. string.sub(game.JobId, 1, 8), 15844367)
			elseif not f then lastFruit = nil end
		end
		if State.WhBoss then
			local folder = workspace:FindFirstChild("Enemies")
			if folder then
				for _, m in ipairs(folder:GetChildren()) do
					if G.BossSet[m.Name] and not lastBoss[m] then lastBoss[m] = true; V.webhook("👑 Boss no mapa", m.Name, 10181046) end
				end
				for m in pairs(lastBoss) do if not m.Parent then lastBoss[m] = nil end end
			end
		end
	end)
	G.loop(10, function()
		if State.WebhookOn and State.WhEvery > 0 and tick() - lastSum >= State.WhEvery * 60 then lastSum = tick(); V.summary() end
	end)
end)()

------------------------------------------------------------------
-- BLOCO B: filtros, cosméticos, câmera, extras
------------------------------------------------------------------
;(function()
	if not (G and G.V) then return end
	local V = G.V
	for _, n in ipairs({"AppleHubCC", "AppleHubBloom", "AppleHubSun", "AppleHubFBlur"}) do
		local o = Lighting:FindFirstChild(n)
		if o then o:Destroy() end
	end
	local fx = new("Folder", {Name = "FX", Parent = gui})
	local cc = new("ColorCorrectionEffect", {Name = "AppleHubCC", Enabled = false, Parent = Lighting})
	local bloom = new("BloomEffect", {Name = "AppleHubBloom", Enabled = false, Size = 24, Threshold = 0.9, Parent = Lighting})
	local sun = new("SunRaysEffect", {Name = "AppleHubSun", Enabled = false, Parent = Lighting})
	local fblur = new("BlurEffect", {Name = "AppleHubFBlur", Enabled = false, Size = 0, Parent = Lighting})

	-- vinheta (4 bordas)
	local vigF = {}
	local function vig(anchor, pos, size, rot)
		local f = new("Frame", {AnchorPoint = anchor, Position = pos, Size = size, BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 0, Visible = false, Parent = gui})
		new("UIGradient", {Rotation = rot, Transparency = NumberSequence.new(0, 1), Parent = f})
		table.insert(vigF, f)
	end
	vig(Vector2.new(0, 0), UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0.3, 0), 90)
	vig(Vector2.new(0, 1), UDim2.new(0, 0, 1, 0), UDim2.new(1, 0, 0.3, 0), 270)
	vig(Vector2.new(0, 0), UDim2.new(0, 0, 0, 0), UDim2.new(0.22, 0, 1, 0), 0)
	vig(Vector2.new(1, 0), UDim2.new(1, 0, 0, 0), UDim2.new(0.22, 0, 1, 0), 180)

	V.applyFilters = function()
		local on = State.FilterOn
		cc.Enabled = on
		cc.Brightness = State.FBright / 100
		cc.Contrast = State.FContrast / 100
		cc.Saturation = State.FSat / 100
		cc.TintColor = Color3.fromRGB(State.FTR, State.FTG, State.FTB)
		bloom.Enabled = on and State.FBloom > 0
		bloom.Intensity = State.FBloom / 40
		sun.Enabled = on and State.FSun > 0
		sun.Intensity = State.FSun / 100
		fblur.Enabled = on and State.FBlur > 0
		fblur.Size = State.FBlur
		for _, f in ipairs(vigF) do
			f.Visible = on and State.FVig > 0
			f.BackgroundTransparency = 1 - State.FVig / 100
		end
	end
	local function P(b, c, s, r, g, bl, bo, su, bu, vi)
		return {FBright = b, FContrast = c, FSat = s, FTR = r, FTG = g, FTB = bl, FBloom = bo, FSun = su, FBlur = bu, FVig = vi}
	end
	V.FPresets = {
		["Nenhum"] = P(0, 0, 0, 255, 255, 255, 0, 0, 0, 0),
		["Cinema"] = P(-5, 25, -10, 255, 235, 215, 15, 0, 0, 35),
		["Vívido"] = P(3, 20, 45, 255, 255, 255, 20, 0, 0, 0),
		["Noir"] = P(-5, 35, -100, 255, 255, 255, 0, 0, 0, 40),
		["Sépia"] = P(0, 10, -60, 255, 220, 170, 0, 0, 0, 20),
		["Gelo"] = P(2, 10, -10, 190, 225, 255, 20, 0, 0, 10),
		["Pôr do sol"] = P(0, 15, 25, 255, 190, 150, 30, 25, 0, 20),
		["Sonho"] = P(5, 0, 15, 255, 230, 250, 60, 10, 2, 15),
		["Matrix"] = P(-3, 25, -20, 150, 255, 170, 10, 0, 0, 30),
	}
	V.FNames = {"Nenhum", "Cinema", "Vívido", "Noir", "Sépia", "Gelo", "Pôr do sol", "Sonho", "Matrix"}
	V.applyFPreset = function(name)
		local p = V.FPresets[name]
		if not p then return end
		for k, v in pairs(p) do State[k] = v end
		State.FilterOn = name ~= "Nenhum"
		V.applyFilters()
		syncAll()
	end

	-- cosméticos
	local aura, trail, spark, att0, att1
	V.applyAura = function()
		if aura then pcall(function() aura:Destroy() end) aura = nil end
		if not State.AuraOn then return end
		local c = lp.Character
		if not c then return end
		aura = new("Highlight", {Adornee = c, FillTransparency = 1 - State.AuraFill / 100, OutlineTransparency = 0, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = fx})
	end
	local function clearAtt()
		pcall(function() if att0 then att0:Destroy() end if att1 then att1:Destroy() end end)
		att0, att1 = nil, nil
	end
	V.applyTrail = function()
		if trail then pcall(function() trail:Destroy() end) trail = nil end
		clearAtt()
		if not State.TrailOn then return end
		local r = G.root()
		if not r then return end
		att0 = new("Attachment", {Position = Vector3.new(0, 1.2, 0), Parent = r})
		att1 = new("Attachment", {Position = Vector3.new(0, -1.2, 0), Parent = r})
		trail = new("Trail", {Attachment0 = att0, Attachment1 = att1, Lifetime = State.TrailLife / 10, Transparency = NumberSequence.new(0.1, 1), LightEmission = 1, FaceCamera = true, Parent = r})
	end
	V.applySpark = function()
		if spark then pcall(function() spark:Destroy() end) spark = nil end
		if not State.SparkOn then return end
		local r = G.root()
		if not r then return end
		spark = new("ParticleEmitter", {Texture = "rbxasset://textures/particles/sparkles_main.dds", Rate = State.SparkRate, Lifetime = NumberRange.new(0.8, 1.4),
			Speed = NumberRange.new(1, 3), SpreadAngle = Vector2.new(180, 180), Size = NumberSequence.new(0.5, 0), LightEmission = 1, Parent = r})
	end
	local function cosCol(i)
		local m = State.CosMode
		if m == "Arco-íris" then return Color3.fromHSV((tick() * 0.2 + i * 0.12) % 1, 0.7, 1)
		elseif m == "Branco" then return Color3.new(1, 1, 1) end
		return i == 0 and T.accent or T.accent2
	end
	G.loop(0.1, function()
		if aura then aura.FillColor = cosCol(0); aura.OutlineColor = cosCol(1); aura.FillTransparency = 1 - State.AuraFill / 100 end
		if trail then trail.Color = ColorSequence.new(cosCol(0), cosCol(1)); trail.Lifetime = State.TrailLife / 10 end
		if spark then spark.Color = ColorSequence.new(cosCol(0), cosCol(1)); spark.Rate = State.SparkRate end
	end)
	conn(lp.CharacterAdded:Connect(function()
		task.wait(1.2)
		V.applyAura(); V.applyTrail(); V.applySpark()
	end))

	-- câmera
	V.origZoom = lp.CameraMaxZoomDistance
	V.applyZoom = function()
		pcall(function() lp.CameraMaxZoomDistance = State.ZoomInf and State.ZoomMax or V.origZoom end)
	end
	local barT = new("Frame", {Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 0, Parent = gui})
	local barB = new("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 0, Parent = gui})
	V.applyCine = function()
		local h = State.CineBars and State.CineSize / 100 or 0
		tween(barT, 0.5, {Size = UDim2.new(1, 0, h, 0)})
		tween(barB, 0.5, {Size = UDim2.new(1, 0, h, 0)})
	end
	local coords = new("TextLabel", {Size = UDim2.fromOffset(260, 18), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 4), BackgroundTransparency = 1, Text = "",
		TextSize = 12, Font = Enum.Font.GothamBold, TextColor3 = T.accent, TextStrokeTransparency = 0.5, ZIndex = 70, Visible = State.CoordsOn, Parent = gui})
	bind(coords, "TextColor3", "accent")
	V.applyCoords = function() coords.Visible = State.CoordsOn end
	G.loop(0.2, function()
		if not State.CoordsOn then return end
		local r = G.root()
		if r then
			local p = r.Position
			coords.Text = string.format("X %d   Y %d   Z %d", math.floor(p.X), math.floor(p.Y), math.floor(p.Z))
		end
	end)

	-- click teleport (PC: Ctrl + clique)
	local mouse = lp:GetMouse()
	conn(UIS.InputBegan:Connect(function(i, gp)
		if gp or not State.ClickTP then return end
		if i.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			local r = G.root()
			if r and mouse.Hit then r.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 4, 0)) end
		end
	end))

	-- anti-AFK com movimento
	task.spawn(function()
		while alive do
			task.wait(math.max(State.AfkEvery, 10))
			if State.AfkMove and not G.anyAuto() then
				local h = G.hum()
				if h then
					pcall(function()
						h:Move(Vector3.new(math.random() - 0.5, 0, math.random() - 0.5), false)
						h.Jump = true
						task.wait(0.6)
						h:Move(Vector3.zero, false)
					end)
				end
			end
		end
	end)

	-- auto-save
	local function silentSave()
		pcall(function()
			local d = {}
			for _, k in ipairs(SAVE_KEYS) do d[k] = State[k] end
			writefile(CFG_FILE, HttpService:JSONEncode(d))
		end)
	end
	task.spawn(function()
		while alive do
			task.wait(math.max(State.AutoSaveEvery, 30))
			if State.AutoSaveCfg then silentSave() end
		end
	end)

	-- limpeza ao descarregar
	gui.Destroying:Connect(function()
		if State.AutoSaveCfg then silentSave() end
		for _, o in ipairs({cc, bloom, sun, fblur}) do pcall(function() o:Destroy() end) end
		pcall(function() lp.CameraMaxZoomDistance = V.origZoom end)
		pcall(function() local h = G.hum(); if h then cam.CameraSubject = h end end)
		pcall(function() if trail then trail:Destroy() end if spark then spark:Destroy() end clearAtt() end)
	end)

	G.after.FilterOn = function() V.applyFilters() end
	G.after.AuraOn = function() V.applyAura() end
	G.after.TrailOn = function() V.applyTrail() end
	G.after.SparkOn = function() V.applySpark() end
	G.after.ZoomInf = function() V.applyZoom() end
	G.after.CineBars = function() V.applyCine() end
	G.after.CoordsOn = function() V.applyCoords() end
end)()

------------------------------------------------------------------
-- BLOCO C: radar + dock
------------------------------------------------------------------
;(function()
	if not (G and G.V) then return end
	local V = G.V
	local radar = new("Frame", {Name = "Radar", Size = UDim2.fromOffset(State.RadarSize, State.RadarSize), Position = UDim2.new(1, -State.RadarSize - 14, 0, 70),
		BackgroundColor3 = T.bg, BackgroundTransparency = State.RadarAlpha / 100, ZIndex = 30, Visible = State.RadarOn, Parent = gui}, {corner(500)})
	bind(radar, "BackgroundColor3", "bg")
	bind(new("UIStroke", {Thickness = 2, Transparency = 0.3, Parent = radar}), "Color", "accent")
	for _, f in ipairs({0.33, 0.66}) do
		new("Frame", {Size = UDim2.fromScale(f, f), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 31, Parent = radar},
			{corner(500), new("UIStroke", {Thickness = 1, Transparency = 0.8, Color = Color3.new(1, 1, 1)})})
	end
	new("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromScale(0, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.85, BorderSizePixel = 0, ZIndex = 31, Parent = radar})
	new("Frame", {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.fromScale(0.5, 0), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.85, BorderSizePixel = 0, ZIndex = 31, Parent = radar})
	new("Frame", {Size = UDim2.fromOffset(8, 8), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 34, Parent = radar}, {corner(4)})
	local rlabel = new("TextLabel", {Size = UDim2.new(1, 0, 0, 12), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, -4), BackgroundTransparency = 1, Text = "", TextSize = 10,
		Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(200, 200, 215), ZIndex = 35, Parent = radar})
	drag(radar, radar)
	V.applyRadar = function()
		radar.Visible = State.RadarOn
		radar.Size = UDim2.fromOffset(State.RadarSize, State.RadarSize)
		radar.BackgroundTransparency = State.RadarAlpha / 100
		rlabel.Text = State.RadarRange .. "m"
	end
	local dots = {}
	local function dotAt(i)
		local d = dots[i]
		if not d then
			d = new("Frame", {Size = UDim2.fromOffset(6, 6), AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, ZIndex = 33, Visible = false, Parent = radar}, {corner(4)})
			dots[i] = d
		end
		return d
	end
	G.loop(0.1, function()
		if not State.RadarOn then return end
		local r = G.root()
		if not r then return end
		local cf = cam.CFrame
		local fv = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
		if fv.Magnitude < 0.01 then return end
		fv = fv.Unit
		local rv = Vector3.new(-fv.Z, 0, fv.X)
		local range, half, n = State.RadarRange, State.RadarSize / 2 - 6, 0
		local function add(pos, col, big)
			if n >= 150 then return end
			local d = pos - r.Position
			local x, y = d:Dot(rv), -d:Dot(fv)
			local len = math.sqrt(x * x + y * y)
			local edge = len > range
			if edge then x, y = x / len * range, y / len * range end
			n = n + 1
			local dd = dotAt(n)
			dd.Visible = true
			dd.BackgroundColor3 = col
			local sz = big and 8 or 6
			dd.Size = UDim2.fromOffset(sz, sz)
			dd.BackgroundTransparency = edge and 0.55 or 0
			dd.Position = UDim2.new(0.5, x / range * half, 0.5, y / range * half)
		end
		if State.RadarPlayers then
			for _, p in ipairs(Players:GetPlayers()) do
				local hr = p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				if hr then add(hr.Position, Color3.fromRGB(255, 85, 85)) end
			end
		end
		if State.RadarFruits then
			for _, v in ipairs(workspace:GetChildren()) do
				if (v:IsA("Tool") or v:IsA("Model")) and v.Name:lower():find("fruit") and v:FindFirstChild("Handle") then add(v.Handle.Position, Color3.fromRGB(255, 196, 60), true) end
			end
		end
		if State.RadarBosses then
			local folder = workspace:FindFirstChild("Enemies")
			if folder then
				for _, m in ipairs(folder:GetChildren()) do
					local mr = m:FindFirstChild("HumanoidRootPart")
					if G.BossSet[m.Name] and mr then add(mr.Position, Color3.fromRGB(190, 90, 255), true) end
				end
			end
		end
		if State.RadarChests then
			local c = 0
			for _, ch in ipairs(CS:GetTagged("_ChestTagged")) do
				if ch.Parent and c < 40 then
					c = c + 1
					add(ch:GetPivot().Position, Color3.fromRGB(90, 220, 255))
				end
			end
		end
		for i = n + 1, #dots do dots[i].Visible = false end
	end)

	-- dock
	local dock = new("Frame", {Name = "Dock", AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -90),
		BackgroundColor3 = T.bg, BackgroundTransparency = State.DockAlpha / 100, ZIndex = 35, Visible = State.DockOn, Parent = gui}, {corner(16), new("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)})})
	bind(dock, "BackgroundColor3", "bg")
	bind(new("UIStroke", {Thickness = 1, Transparency = 0.75, Parent = dock}), "Color", "accent")
	local dockLay = new("UIListLayout", {Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Parent = dock})
	drag(dock, dock)
	local dockBtns = {}
	V.rebuildDock = function()
		for _, c in ipairs(dock:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
		table.clear(dockBtns)
		dockLay.FillDirection = State.DockVert and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
		for i, name in ipairs(State.DockItems) do
			local key = G.FeatMap[name]
			if key then
				local b = new("TextButton", {Size = UDim2.fromOffset(State.DockVert and 120 or 0, State.DockSize), AutomaticSize = State.DockVert and Enum.AutomaticSize.None or Enum.AutomaticSize.X,
					BackgroundColor3 = T.row, Text = name, TextSize = 12, AutoButtonColor = false, TextColor3 = T.text, LayoutOrder = i, ZIndex = 36, Parent = dock},
					{corner(10), new("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})})
				regFont(b, true)
				b.MouseButton1Click:Connect(function()
					uiSound()
					State[key] = not State[key]
					if G.after[key] then pcall(G.after[key], State[key]) end
					syncAll()
				end)
				table.insert(dockBtns, {b, key})
			end
		end
		dock.BackgroundTransparency = State.DockAlpha / 100
		dock.Visible = State.DockOn
	end
	G.loop(0.25, function()
		if not State.DockOn then return end
		for _, e in ipairs(dockBtns) do
			local on = State[e[2]]
			e[1].BackgroundColor3 = on and T.accent or T.row
			e[1].TextColor3 = on and Color3.new(1, 1, 1) or T.text
		end
	end)
	G.after.RadarOn = function() V.applyRadar() end
	G.after.DockOn = function() V.rebuildDock() end
end)()

------------------------------------------------------------------
-- BLOCO D: console de comandos (lógica)
------------------------------------------------------------------
;(function()
	if not (G and G.V) then return end
	local V = G.V
	local lines = {}
	local function say(t)
		table.insert(lines, tostring(t))
		while #lines > 10 do table.remove(lines, 1) end
		if V.out then V.out.Text = table.concat(lines, "\n") end
	end
	V.say = say
	V.clearConsole = function() lines = {}; if V.out then V.out.Text = "" end end
	local function findFeat(q)
		q = q:lower()
		for _, f in ipairs(G.Feats) do if f[1]:lower():find(q, 1, true) then return f end end
	end
	local function findPlayer(q)
		q = q:lower()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= lp and (p.Name:lower():find(q, 1, true) or p.DisplayName:lower():find(q, 1, true)) then return p end
		end
	end
	local function setFeat(f, val)
		State[f[2]] = val
		if G.after[f[2]] then pcall(G.after[f[2]], val) end
		syncAll()
		say((val and "ligado: " or "desligado: ") .. f[1])
	end
	local cmds = {}
	cmds.help = function() say("tp, speed, jump, fov, grav, on/off/toggle <função>, theme, goal, hop, rejoin, reset, fruit, save, intro, pos, goto, hora, clear") end
	cmds.tp = function(a)
		local p = findPlayer(a)
		local hr = p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		if not hr then say("jogador não encontrado") return end
		State.ManualTravel = true
		G.goTo(hr.CFrame * CFrame.new(0, 4, 0))
		State.ManualTravel = false
		say("cheguei em " .. p.DisplayName)
	end
	cmds.speed = function(a)
		local n = tonumber(a)
		if not n then say("uso: speed 80") return end
		State.Speed = math.clamp(n, 16, 500); State.SpeedOn = true; syncAll(); say("velocidade " .. State.Speed)
	end
	cmds.jump = function(a)
		local n = tonumber(a)
		if not n then say("uso: jump 100") return end
		State.Jump = math.clamp(n, 50, 500); State.JumpOn = true; syncAll(); say("pulo " .. State.Jump)
	end
	cmds.fov = function(a)
		local n = tonumber(a)
		if not n then say("uso: fov 90") return end
		State.FOV = math.clamp(n, 30, 120); cam.FieldOfView = State.FOV; syncAll(); say("fov " .. State.FOV)
	end
	cmds.grav = function(a)
		local n = tonumber(a)
		if not n then say("uso: grav 100") return end
		State.Gravity = math.clamp(n, 20, 300); workspace.Gravity = State.Gravity; syncAll(); say("gravidade " .. State.Gravity)
	end
	cmds.hora = function(a)
		local n = tonumber(a)
		if not n then say("uso: hora 14") return end
		Lighting.ClockTime = math.clamp(n, 0, 24); State.Clock = math.floor(n); syncAll(); say("hora " .. n)
	end
	cmds.on = function(a) local f = findFeat(a); if f then setFeat(f, true) else say("função não encontrada") end end
	cmds.off = function(a) local f = findFeat(a); if f then setFeat(f, false) else say("função não encontrada") end end
	cmds.toggle = function(a) local f = findFeat(a); if f then setFeat(f, not State[f[2]]) else say("função não encontrada") end end
	cmds.theme = function(a)
		a = a:lower()
		for _, n in ipairs(ThemeNames) do
			if n:lower() == a then applyTheme(n); say("tema " .. n) return end
		end
		say("tema não existe")
	end
	cmds.goal = function(a)
		local n = tonumber(a)
		if not n then say("uso: goal 2550") return end
		State.GoalLevel = math.clamp(math.floor(n), 1, 2550); say("meta de level " .. State.GoalLevel)
	end
	cmds.hop = function() say("procurando servidor..."); G.serverHop() end
	cmds.rejoin = function() TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp) end
	cmds.reset = function() local h = G.hum(); if h then h.Health = 0 end end
	cmds.fruit = function()
		local f = G.findFruit()
		if not f then say("nenhuma fruta no mapa") return end
		State.ManualTravel = true
		G.goTo(f.Handle.CFrame)
		State.ManualTravel = false
		say("fui até " .. f.Name)
	end
	cmds.save = function() G.saveConfig(); say("config salva") end
	cmds.intro = function() G.playIntro() end
	cmds.pos = function(a)
		local r = G.root()
		if a == "" or not r then say("uso: pos nome") return end
		State.Pos[a] = {math.floor(r.Position.X), math.floor(r.Position.Y), math.floor(r.Position.Z)}
		if G.refreshPos then G.refreshPos() end
		say("posição \"" .. a .. "\" salva")
	end
	cmds["goto"] = function(a)
		local p = State.Pos[a]
		if not p then say("posição não existe") return end
		State.ManualTravel = true
		G.goTo(CFrame.new(p[1], p[2] + 4, p[3]))
		State.ManualTravel = false
		say("cheguei em " .. a)
	end
	cmds.clear = function() V.clearConsole() end
	V.run = function(text)
		text = text:gsub("^%s+", ""):gsub("%s+$", "")
		if text == "" then return end
		say("> " .. text)
		local cmd, rest = text:match("^(%S+)%s*(.*)$")
		local fn = cmds[cmd:lower()]
		if not fn then say("comando desconhecido (digite help)") return end
		task.spawn(function()
			local ok, err = pcall(fn, rest)
			if not ok then say("erro: " .. tostring(err)) end
		end)
	end
end)()

------------------------------------------------------------------
-- BLOCO E: páginas novas
------------------------------------------------------------------
;(function()
	if not (G and G.V) then return end
	local V = G.V
	local commas = G.commas

	local function listBox(page)
		local b = new("Frame", {Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = page},
			{new("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})})
		regSearch(b, "", true)
		return b
	end
	local function clearBox(box) for _, c in ipairs(box:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end end
	local function sb(parent, txt, x, w, color)
		local b = mkText({Size = UDim2.fromOffset(w, 26), Position = UDim2.new(1, x, 0.5, -13), Text = txt, TextSize = 12, AutoButtonColor = false, Parent = parent}, true, false, "TextButton")
		b.BackgroundTransparency = 0
		b.BackgroundColor3 = color
		b.TextColor3 = Color3.new(1, 1, 1)
		new("UICorner", {CornerRadius = UDim.new(0, 8), Parent = b})
		return b
	end
	local function StaticRow(page, left, right, color)
		local r = row(page, 32)
		regSearch(r, left .. " " .. right)
		mkText({Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.fromOffset(14, 0), Text = left, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, true)
		local v = mkText({Size = UDim2.new(0.5, -28, 1, 0), Position = UDim2.new(0.5, 14, 0, 0), Text = right, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = r}, true, false)
		v.TextColor3 = color
	end

	------------------------------------------------ MAPA
	local pMap = addPage("Mapa", "◎")
	Section(pMap, "Radar")
	Toggle(pMap, "Mostrar radar (arrastável)", "RadarOn", function() V.applyRadar() end)
	Slider(pMap, "Tamanho do radar", 90, 240, "RadarSize", function() V.applyRadar() end, " px")
	Slider(pMap, "Alcance", 50, 1000, "RadarRange", function() V.applyRadar() end, " m")
	Slider(pMap, "Transparência", 0, 90, "RadarAlpha", function() V.applyRadar() end, "%")
	Toggle(pMap, "Jogadores (vermelho)", "RadarPlayers")
	Toggle(pMap, "Frutas (amarelo)", "RadarFruits")
	Toggle(pMap, "Bosses (roxo)", "RadarBosses")
	Toggle(pMap, "Baús (ciano)", "RadarChests")
	Section(pMap, "Câmera")
	Toggle(pMap, "Zoom infinito", "ZoomInf", function() V.applyZoom() end)
	Slider(pMap, "Distância máxima do zoom", 128, 2000, "ZoomMax", function() V.applyZoom() end, " st")
	Toggle(pMap, "Barras de cinema", "CineBars", function() V.applyCine() end)
	Slider(pMap, "Tamanho das barras", 5, 25, "CineSize", function() V.applyCine() end, "%")
	Toggle(pMap, "Mostrar coordenadas", "CoordsOn", function() V.applyCoords() end)
	Section(pMap, "Teleporte rápido")
	Toggle(pMap, "Click TP (PC: Ctrl + clique)", "ClickTP")
	local npcNames, npcMap, seen = {}, {}, {}
	for lvl = 1, 2500 do
		local e = G.questFor(lvl)
		if e and not seen[e.qn] then
			seen[e.qn] = true
			local label = e.qn .. " (Lv " .. e.min .. ")"
			table.insert(npcNames, label)
			npcMap[label] = e.q
		end
	end
	if #npcNames > 0 then
		if not npcMap[State.QuestNPC] then State.QuestNPC = npcNames[1] end
		Dropdown(pMap, "NPC de quest", npcNames, "QuestNPC")
		Button(pMap, "Ir até o NPC", function()
			local p = npcMap[State.QuestNPC]
			if not p then return end
			State.ManualTravel = true
			G.goTo(CFrame.new(p + Vector3.new(0, 4, 0)))
			State.ManualTravel = false
		end)
	end

	------------------------------------------------ COMANDOS
	local pCmd = addPage("Comandos", "›_")
	Section(pCmd, "Dock rápido (atalhos na tela)")
	Toggle(pCmd, "Mostrar dock (arrastável)", "DockOn", function() V.rebuildDock() end)
	Toggle(pCmd, "Dock na vertical", "DockVert", function() V.rebuildDock() end)
	Slider(pCmd, "Tamanho dos botões", 26, 56, "DockSize", function() V.rebuildDock() end, " px")
	Slider(pCmd, "Transparência", 0, 90, "DockAlpha", function() V.rebuildDock() end, "%")
	Dropdown(pCmd, "Função", G.FeatNames, "DockPick")
	Button(pCmd, "Adicionar ao dock", function()
		for _, n in ipairs(State.DockItems) do if n == State.DockPick then notify("Dock", "Já está no dock.", 2) return end end
		table.insert(State.DockItems, State.DockPick)
		V.rebuildDock()
	end)
	Button(pCmd, "Remover do dock", function()
		for i, n in ipairs(State.DockItems) do if n == State.DockPick then table.remove(State.DockItems, i) break end end
		V.rebuildDock()
	end)
	Button(pCmd, "Limpar dock", function() State.DockItems = {}; V.rebuildDock() end)
	Section(pCmd, "Console de comandos")
	Input(pCmd, "Comando", "ex: help  |  Enter", function(t) V.run(t) end)
	V.out = Label(pCmd, "Digite help para ver os comandos.")
	Button(pCmd, "Limpar console", function() V.clearConsole() end)

	------------------------------------------------ FILTROS
	local pFx = addPage("Filtros", "◐")
	Section(pFx, "Filtros de tela")
	Dropdown(pFx, "Preset", V.FNames, "FPreset", function(n) V.applyFPreset(n) end)
	Toggle(pFx, "Filtros ligados", "FilterOn", function() V.applyFilters() end)
	Slider(pFx, "Brilho", -50, 50, "FBright", function() V.applyFilters() end)
	Slider(pFx, "Contraste", -50, 100, "FContrast", function() V.applyFilters() end)
	Slider(pFx, "Saturação", -100, 100, "FSat", function() V.applyFilters() end)
	Slider(pFx, "Tom: vermelho", 0, 255, "FTR", function() V.applyFilters() end)
	Slider(pFx, "Tom: verde", 0, 255, "FTG", function() V.applyFilters() end)
	Slider(pFx, "Tom: azul", 0, 255, "FTB", function() V.applyFilters() end)
	Slider(pFx, "Bloom (brilho suave)", 0, 100, "FBloom", function() V.applyFilters() end)
	Slider(pFx, "Raios de sol", 0, 100, "FSun", function() V.applyFilters() end)
	Slider(pFx, "Desfoque", 0, 20, "FBlur", function() V.applyFilters() end)
	Slider(pFx, "Vinheta (bordas escuras)", 0, 90, "FVig", function() V.applyFilters() end, "%")
	Section(pFx, "Cosméticos do personagem")
	Dropdown(pFx, "Cor dos efeitos", {"Tema", "Arco-íris", "Branco"}, "CosMode")
	Toggle(pFx, "Aura (contorno brilhante)", "AuraOn", function() V.applyAura() end)
	Slider(pFx, "Opacidade da aura", 0, 100, "AuraFill", nil, "%")
	Toggle(pFx, "Rastro atrás de você", "TrailOn", function() V.applyTrail() end)
	Slider(pFx, "Duração do rastro", 3, 30, "TrailLife", nil, " x0,1s")
	Toggle(pFx, "Brilhos (partículas)", "SparkOn", function() V.applySpark() end)
	Slider(pFx, "Quantidade de brilhos", 5, 80, "SparkRate")

	------------------------------------------------ JOGADORES
	local pPl = addPage("Jogadores", "☺")
	Section(pPl, "Ações")
	Button(pPl, "Parar de espectar", function()
		local h = G.hum()
		if h then cam.CameraSubject = h end
	end)
	Button(pPl, "Ir até o jogador mais próximo", function()
		local r, best, bd = G.root(), nil, nil
		if not r then return end
		for _, p in ipairs(Players:GetPlayers()) do
			local hr = p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
			if hr then
				local d = (hr.Position - r.Position).Magnitude
				if not bd or d < bd then best, bd = hr, d end
			end
		end
		if best then
			State.ManualTravel = true
			G.goTo(best.CFrame * CFrame.new(0, 4, 0))
			State.ManualTravel = false
		else notify("Jogadores", "Ninguém por perto.", 2) end
	end)
	Section(pPl, "Jogadores no servidor")
	local plBox = listBox(pPl)
	local plTok = 0
	local function refreshPlayers()
		clearBox(plBox)
		local list = Players:GetPlayers()
		table.sort(list, function(a, b) return a.DisplayName:lower() < b.DisplayName:lower() end)
		for i, p in ipairs(list) do
			local r = row(plBox, 40)
			r.LayoutOrder = i
			local lv = ""
			pcall(function() lv = "  Lv " .. p.Data.Level.Value end)
			mkText({Size = UDim2.new(1, -150, 1, 0), Position = UDim2.fromOffset(12, 0), Text = p.DisplayName .. lv .. (p == lp and "  (você)" or ""), TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = r}, true)
			if p ~= lp then
				sb(r, "Ver", -136, 40, T.accent).MouseButton1Click:Connect(function()
					local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
					if h then cam.CameraSubject = h; notify("Espectar", "Vendo " .. p.DisplayName, 2) else notify("Espectar", "Sem personagem.", 2) end
				end)
				sb(r, "Ir", -92, 40, T.accent2).MouseButton1Click:Connect(function()
					local hr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
					if hr then
						task.spawn(function()
							State.ManualTravel = true
							G.goTo(hr.CFrame * CFrame.new(0, 4, 0))
							State.ManualTravel = false
						end)
					end
				end)
			end
			sb(r, "⧉", -48, 40, Color3.fromRGB(110, 110, 130)).MouseButton1Click:Connect(function()
				pcall(function() setclipboard(p.Name) end)
				notify("Copiado", p.Name, 1.5)
			end)
		end
	end
	local function schedulePlayers()
		plTok = plTok + 1
		local t = plTok
		task.delay(0.4, function() if t == plTok and alive then pcall(refreshPlayers) end end)
	end
	conn(Players.PlayerAdded:Connect(schedulePlayers))
	conn(Players.PlayerRemoving:Connect(schedulePlayers))
	Button(pPl, "Atualizar lista", refreshPlayers)
	refreshPlayers()

	------------------------------------------------ SERVIDORES
	local pSrv = addPage("Servidores", "☁")
	Section(pSrv, "Navegador de servidores")
	Dropdown(pSrv, "Ordenar por", {"Menos jogadores", "Mais jogadores", "Melhor ping"}, "SrvSort")
	local srvBox
	Button(pSrv, "Buscar servidores", function()
		notify("Servidores", "Buscando...", 2)
		local ok, data = pcall(function()
			return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
		end)
		if not ok or type(data) ~= "table" or not data.data then notify("Servidores", "Falhou (limite de requisições?). Tente em 1 min.", 3) return end
		local list = {}
		for _, s in ipairs(data.data) do if s.id ~= game.JobId then table.insert(list, s) end end
		local mode = State.SrvSort
		table.sort(list, function(a, b)
			if mode == "Mais jogadores" then return (a.playing or 0) > (b.playing or 0)
			elseif mode == "Melhor ping" then return (a.ping or 9999) < (b.ping or 9999) end
			return (a.playing or 0) < (b.playing or 0)
		end)
		clearBox(srvBox)
		for i = 1, math.min(#list, 15) do
			local s = list[i]
			local r = row(srvBox, 40)
			r.LayoutOrder = i
			local info = (s.playing or "?") .. "/" .. (s.maxPlayers or "?") .. " jogadores"
			if s.ping then info = info .. "  •  " .. math.floor(s.ping) .. " ms" end
			if s.fps then info = info .. "  •  " .. math.floor(s.fps) .. " fps" end
			mkText({Size = UDim2.new(1, -90, 1, 0), Position = UDim2.fromOffset(12, 0), Text = info, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd, Parent = r}, true)
			sb(r, "Entrar", -76, 64, T.accent).MouseButton1Click:Connect(function() TPS:TeleportToPlaceInstance(game.PlaceId, s.id, lp) end)
		end
		notify("Servidores", #list .. " servidores encontrados", 2)
	end)
	srvBox = listBox(pSrv)
	Section(pSrv, "Job ID")
	Button(pSrv, "Copiar Job ID deste servidor", function()
		pcall(function() setclipboard(game.JobId) end)
		notify("Copiado", "Job ID na área de transferência", 2)
	end)
	Button(pSrv, "Copiar script de entrada", function()
		pcall(function()
			setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)')
		end)
		notify("Copiado", "Script de entrada copiado", 2)
	end)
	Input(pSrv, "Entrar por Job ID", "cole e Enter", function(id) TPS:TeleportToPlaceInstance(game.PlaceId, id, lp) end)

	------------------------------------------------ WEBHOOK
	local pWh = addPage("Webhook", "✉")
	Section(pWh, "Avisos no Discord")
	Label(pWh, "Cole a URL do seu webhook do Discord. Ela fica salva só neste aparelho e não vai no Exportar config.")
	Input(pWh, "URL do webhook", "cole e Enter", function(u) V.saveWebhookURL(u); notify("Webhook", "URL salva.", 2) end)
	Toggle(pWh, "Enviar avisos", "WebhookOn")
	Toggle(pWh, "Fruta spawnou", "WhFruit")
	Toggle(pWh, "Boss apareceu", "WhBoss")
	Toggle(pWh, "Level up", "WhLevel")
	Slider(pWh, "Resumo automático (0 = desligado)", 0, 120, "WhEvery", nil, " min")
	Button(pWh, "Enviar mensagem de teste", function()
		local was = State.WebhookOn
		State.WebhookOn = true
		local ok = V.webhook("✅ Teste", "Apple Hub v16 conectado!", 5763719)
		State.WebhookOn = was
		notify("Webhook", ok and "Teste enviado!" or "Configure uma URL https:// válida (e use executor com request).", 3)
	end)
	Button(pWh, "Enviar resumo agora", function()
		local was = State.WebhookOn
		State.WebhookOn = true
		V.summary()
		State.WebhookOn = was
	end)

	------------------------------------------------ FRUTAS
	local pFr = addPage("Frutas", "🍎")
	Section(pFr, "Calculadora de fruta")
	local fruits = {
		{"Rocket", 5000, 1}, {"Spin", 7500, 1}, {"Blade", 30000, 1}, {"Spring", 60000, 1}, {"Bomb", 80000, 1}, {"Smoke", 100000, 1}, {"Spike", 180000, 1},
		{"Flame", 250000, 2}, {"Ice", 350000, 2}, {"Sand", 420000, 2}, {"Dark", 500000, 2}, {"Eagle", 550000, 2}, {"Diamond", 600000, 2},
		{"Light", 650000, 3}, {"Rubber", 750000, 3}, {"Ghost", 940000, 3}, {"Magma", 960000, 3},
		{"Quake", 1000000, 4}, {"Buddha", 1200000, 4}, {"Love", 1300000, 4}, {"Creation", 1400000, 4}, {"Spider", 1500000, 4}, {"Sound", 1700000, 4},
		{"Phoenix", 1800000, 4}, {"Portal", 1900000, 4}, {"Rumble", 2100000, 4}, {"Pain", 2300000, 4}, {"Blizzard", 2400000, 4},
		{"Gravity", 2500000, 5}, {"Mammoth", 2700000, 5}, {"T-Rex", 2700000, 5}, {"Dough", 2800000, 5}, {"Shadow", 2900000, 5}, {"Venom", 3000000, 5},
		{"Control", 3200000, 5}, {"Spirit", 3400000, 5}, {"Dragon", 3500000, 5}, {"Leopard", 5000000, 5}, {"Kitsune", 8000000, 5},
	}
	local rar = {{"Comum", Color3.fromRGB(170, 170, 170)}, {"Incomum", Color3.fromRGB(110, 220, 120)}, {"Raro", Color3.fromRGB(90, 160, 255)},
		{"Lendária", Color3.fromRGB(200, 120, 255)}, {"Mítica", Color3.fromRGB(255, 95, 95)}}
	local function target()
		local q = State.TargetFruit:lower()
		for _, f in ipairs(fruits) do if f[1]:lower():find(q, 1, true) then return f end end
	end
	local function fmtETA(h)
		return string.format("%dh %02dmin", math.floor(h), math.floor((h % 1) * 60))
	end
	Input(pFr, "Fruta alvo", "ex: leopard e Enter", function(t) State.TargetFruit = t end)
	InfoRow(pFr, "Fruta", function() local f = target() return f and f[1] or "não encontrada" end)
	InfoRow(pFr, "Preço (Beli)", function() local f = target() return f and commas(f[2]) or "—" end)
	InfoRow(pFr, "Beli atual", function() return commas(G.dataVal("Beli") or 0) end)
	InfoRow(pFr, "Falta", function()
		local f = target()
		return f and commas(math.max(0, f[2] - (G.dataVal("Beli") or 0))) or "—"
	end)
	InfoRow(pFr, "Tempo estimado", function()
		local f = target()
		if not f then return "—" end
		local falta = f[2] - (G.dataVal("Beli") or 0)
		if falta <= 0 then return "já dá pra comprar!" end
		local rate = V.rateNum("Beli")
		return rate > 0 and fmtETA(falta / rate) or "—"
	end)
	Section(pFr, "Guia de frutas (valores aproximados)")
	for _, f in ipairs(fruits) do StaticRow(pFr, f[1], commas(f[2]) .. "  •  " .. rar[f[3]][1], rar[f[3]][2]) end

	------------------------------------------------ MONITOR
	local pMon = addPage("Monitor", "▥")
	Section(pMon, "Desempenho")
	local N = 40
	local function sparkline(page, title)
		local r = row(page, 86)
		regSearch(r, title)
		local tl = mkText({Size = UDim2.new(1, -24, 0, 20), Position = UDim2.fromOffset(12, 4), Text = title, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, true)
		local box = new("Frame", {Size = UDim2.new(1, -24, 0, 48), Position = UDim2.fromOffset(12, 30), BackgroundTransparency = 1, Parent = r})
		local bars = {}
		for i = 1, N do
			local b = new("Frame", {Size = UDim2.new(1 / N, -1, 0, 2), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new((i - 1) / N, 0, 1, 0), BorderSizePixel = 0, BackgroundColor3 = T.accent, Parent = box}, {corner(2)})
			bind(b, "BackgroundColor3", "accent")
			bars[i] = b
		end
		return {title = tl, bars = bars, name = title, hist = {}}
	end
	local spFps, spPing = sparkline(pMon, "FPS"), sparkline(pMon, "Ping")
	local function feed(sp, val, maxv, unit)
		table.insert(sp.hist, val)
		if #sp.hist > N then table.remove(sp.hist, 1) end
		for i, b in ipairs(sp.bars) do
			local v = sp.hist[#sp.hist - N + i]
			b.Size = UDim2.new(1 / N, -1, 0, v and math.max(2, math.floor(math.clamp(v / maxv, 0, 1) * 48)) or 2)
		end
		sp.title.Text = sp.name .. "  •  " .. val .. unit
	end
	G.loop(1, function()
		feed(spFps, fps, 120, " fps")
		feed(spPing, getPing(), 300, " ms")
	end)
	InfoRow(pMon, "Memória do jogo", function() return math.floor(Stats:GetTotalMemoryUsageMb()) .. " MB" end)
	Section(pMon, "Meta de level")
	Input(pMon, "Meta de level", "ex: 2550 e Enter", function(t)
		local n = tonumber(t)
		if n then State.GoalLevel = math.clamp(math.floor(n), 1, 2550); notify("Meta", "Meta: Lv " .. State.GoalLevel, 2) end
	end)
	InfoRow(pMon, "Meta", function() return "Lv " .. State.GoalLevel end)
	InfoRow(pMon, "Level atual", function() return commas(G.dataVal("Level") or 0) end)
	InfoRow(pMon, "Faltam", function() return commas(math.max(0, State.GoalLevel - (G.dataVal("Level") or 0))) end)
	InfoRow(pMon, "Tempo estimado", function()
		local falta = State.GoalLevel - (G.dataVal("Level") or 0)
		if falta <= 0 then return "meta atingida!" end
		local rate = V.rateNum("Level")
		return rate > 0 and fmtETA(falta / rate) or "—"
	end)
	Section(pMon, "Log de notificações")
	local logLabel = Label(pMon, "Nenhuma notificação ainda.")
	G.loop(1, function()
		if #V.log > 0 then logLabel.Text = table.concat(V.log, "\n", 1, math.min(#V.log, 15)) end
	end)
	Button(pMon, "Limpar log", function() V.log = {}; logLabel.Text = "Nenhuma notificação ainda." end)

	------------------------------------------------ CONFIG EXTRA
	local pCfg2 = addPage("v16", "✧")
	Section(pCfg2, "Extras do v16")
	Toggle(pCfg2, "Auto-save da config", "AutoSaveCfg")
	Slider(pCfg2, "Intervalo do auto-save", 30, 600, "AutoSaveEvery", nil, " s")
	Toggle(pCfg2, "Anti-AFK com movimento", "AfkMove")
	Slider(pCfg2, "Mover a cada", 10, 300, "AfkEvery", nil, " s")
	Label(pCfg2, "Dica: no console digite  on radar  /  theme dracula  /  speed 90  /  tp nome")

	-- aplica tudo ao abrir
	V.applyFilters(); V.applyAura(); V.applyTrail(); V.applySpark(); V.applyCine(); V.applyZoom()
	V.applyRadar(); V.rebuildDock(); V.applyCoords()
	layoutTabs()
	notify("Apple Hub v16", "Novidades: Mapa, Dock, Filtros, Webhook, Monitor...", 4)
end)()
-- ===== APPLE HUB v26 — PARTE 4 (cole depois das Partes 1, 2 [v9] e 3 [v16]) =====

------------------------------------------------------------------
-- BLOCO A: estado, temas extras, funções novas
------------------------------------------------------------------
;(function()
	if not (G and G.V and G.V.webhook and addPage) then warn("[AppleHub v26] Cole esta parte DEPOIS das Partes 1 e 2 (v9) e da Parte 3 (v16).") return end
	local Z = {pages = {}}
	G.Z = Z
	local NEW = {
		StealthOn = false, StealthRange = 120, StealthAct = "Pausar farm", StealthFriends = true,
		SniperOn = false, SniperWait = 12, SniperGrab = true, SniperHop = true, ReExec = false,
		LockClock = false, ClockLockVal = 14, CamMode = "Normal", ComboSeq = "Z,X,C", ComboDelay = 500, ComboLoop = false,
		MusicId = "", MusicVol = 50, MusicLoop = true, Notes = "",
		EspOn = false, EspDist = 1500, EspSize = 12, EspHP = true, EspLv = true, EspBox = false, EspTracer = false, EspColor = "Vermelho", EspMax = 25,
		TouchFX = false, TouchStyle = "Faíscas", TouchCount = 10, TouchColor = "Tema",
		GhostOn = false, GhostAfter = 8, GhostLevel = 70,
		BgImage = "", BgAlpha = 40, BgScale = "Crop",
		AutoTheme = false, AutoThemeMin = 5, PaletteKey = "K",
		SchedPick = "Auto Level", SchedMin = 10, SchedAct = "Ligar", Profiles = {},
	}
	for k, v in pairs(NEW) do
		State[k] = v
		Default[k] = type(v) == "table" and {} or v
		table.insert(SAVE_KEYS, k)
	end
	pcall(function()
		if isfile and isfile(CFG_FILE) then
			local d = HttpService:JSONDecode(readfile(CFG_FILE))
			for k, v in pairs(NEW) do
				if d[k] ~= nil and type(d[k]) == type(v) then State[k] = d[k] end
			end
		end
	end)
	local URL_FILE = "AppleHub_v26_url.txt"
	Z.reexecSrc = ""
	pcall(function() if isfile and isfile(URL_FILE) then Z.reexecSrc = readfile(URL_FILE) end end)
	Z.setURL = function(u)
		Z.reexecSrc = u
		pcall(function() writefile(URL_FILE, u) end)
	end
	if State.Title == Default.Title or tostring(State.Title):find("v16", 1, true) then
		State.Title = "Apple Hub v26  •  Blox Fruits"
		titleLabel.Text = State.Title
	end

	-- temas extras
	local extraThemes = {
		{"Aqua", "#061a1a", "#0a2828", "#103c3c", "#e6fffb", "#78b8b0", "#2dd4bf", "#0ea5e9"},
		{"Volcano", "#160805", "#240e08", "#38160d", "#ffefe6", "#b98a78", "#ff5a1f", "#ffc107"},
		{"Orchid", "#160a1f", "#221030", "#341a48", "#fbeaff", "#b48ac8", "#c471ed", "#f64f9c"},
		{"Midori", "#071208", "#0e1f10", "#183018", "#eaffec", "#7fb583", "#4ade80", "#a3e635"},
		{"Steam", "#14171c", "#1d2229", "#2a313a", "#f0f4f8", "#8b97a6", "#5eead4", "#60a5fa"},
		{"Honey", "#1a1405", "#271e08", "#3a2d0f", "#fff8e1", "#bfa66a", "#fbbf24", "#f97316"},
		{"Void", "#000000", "#050507", "#0d0d12", "#e8e8f0", "#6c6c80", "#8b5cf6", "#06b6d4"},
		{"Bubblegum", "#fff0f6", "#ffdbe9", "#ffffff", "#3a1426", "#a0708a", "#ff5fa2", "#a78bfa"},
	}
	Z.extraNames = {}
	for _, e in ipairs(extraThemes) do
		Themes[e[1]] = th(e[2], e[3], e[4], e[5], e[6], e[7], e[8])
		table.insert(ThemeNames, #ThemeNames, e[1])
		table.insert(Z.extraNames, e[1])
	end

	-- novas funções (dock, atalhos, console, paleta, perfis)
	local extra = {{"Modo Furtivo", "StealthOn"}, {"Fruit Sniper", "SniperOn"}, {"ESP+", "EspOn"}, {"Toque Mágico", "TouchFX"},
		{"Modo Fantasma", "GhostOn"}, {"Travar Hora", "LockClock"}, {"Combo Loop", "ComboLoop"}, {"Tema Automático", "AutoTheme"}}
	for _, f in ipairs(extra) do
		table.insert(G.Feats, f)
		table.insert(G.FeatNames, f[1])
		G.FeatMap[f[1]] = f[2]
	end
end)()

------------------------------------------------------------------
-- BLOCO B: paleta de comandos
------------------------------------------------------------------
;(function()
	if not (G and G.Z) then return end
	local Z, V = G.Z, G.V
	local white = Color3.new(1, 1, 1)
	local pal = new("Frame", {Name = "Palette", Size = UDim2.fromOffset(340, 0), AutomaticSize = Enum.AutomaticSize.Y, AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 70), BackgroundColor3 = T.bg, ZIndex = 300, Visible = false, Parent = gui},
		{corner(16), new("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
			new("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})})
	bind(pal, "BackgroundColor3", "bg")
	bind(new("UIStroke", {Thickness = 1.5, Parent = pal}), "Color", "accent")
	local box = new("TextBox", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = T.row, Text = "", PlaceholderText = "Digite: função, aba, tema, preset...", TextSize = 14,
		ClearTextOnFocus = false, TextColor3 = T.text, PlaceholderColor3 = T.sub, ZIndex = 301, LayoutOrder = 0, Parent = pal}, {corner(10)})
	regFont(box, false)
	bind(box, "BackgroundColor3", "row"); bind(box, "TextColor3", "text"); bind(box, "PlaceholderColor3", "sub")

	local resBtns, shownList, entries, sel = {}, {}, {}, 1
	for i = 1, 7 do
		local b = mkText({Size = UDim2.new(1, 0, 0, 30), Text = "", TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 301, LayoutOrder = i, Visible = false, Parent = pal}, false, false, "TextButton")
		b.BackgroundTransparency = 0
		b.BackgroundColor3 = T.row
		new("UICorner", {CornerRadius = UDim.new(0, 9), Parent = b})
		resBtns[i] = b
	end

	local pageList = {"Farm", "Blox", "Auto", "Teleport", "Visual", "Player", "Info", "Estilo", "Painel", "Abas", "Botões", "Partículas", "Intro", "HUD", "Atalhos",
		"Config", "Mapa", "Comandos", "Filtros", "Jogadores", "Servidores", "Webhook", "Frutas", "Monitor", "v16"}
	local function buildEntries()
		local list = {}
		local function add(label, run) table.insert(list, {label = label, key = label:lower(), run = run}) end
		for _, f in ipairs(G.Feats) do
			add("Alternar: " .. f[1], function()
				State[f[2]] = not State[f[2]]
				if G.after[f[2]] then pcall(G.after[f[2]], State[f[2]]) end
				syncAll()
				notify(f[1], State[f[2]] and "Ligado" or "Desligado", 1.5)
			end)
		end
		local all = {}
		for _, p in ipairs(pageList) do all[p] = true end
		for p in pairs(Z.pages) do all[p] = true end
		for p in pairs(all) do
			add("Abrir aba: " .. p, function() if not shown then showMain() end pcall(switchTab, p) end)
		end
		for _, n in ipairs(ThemeNames) do
			add("Tema: " .. n, function() if n == "Custom" then updateCustom() end applyTheme(n) end)
		end
		for _, n in ipairs(PresetOrder) do add("Preset: " .. n, function() applyPreset(n) end) end
		for _, n in ipairs(V.FNames) do add("Filtro: " .. n, function() V.applyFPreset(n) end) end
		add("Ação: Trocar de servidor", function() G.serverHop() end)
		add("Ação: Reentrar no servidor", function() TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp) end)
		add("Ação: Resetar personagem", function() local h = G.hum() if h then h.Health = 0 end end)
		add("Ação: Salvar config", function() G.saveConfig() end)
		add("Ação: Testar intro", function() G.playIntro() end)
		add("Ação: Esconder painel", function() hideMain() end)
		add("Ação: Mostrar painel", function() showMain() end)
		add("Ação: Tema aleatório", function() if Z.randomTheme then Z.randomTheme() end end)
		add("Ação: Copiar Job ID", function() pcall(function() setclipboard(game.JobId) end) notify("Copiado", "Job ID", 1.5) end)
		add("Ação: Ir até a fruta", function()
			local f = G.findFruit()
			if f then State.ManualTravel = true; G.goTo(f.Handle.CFrame); State.ManualTravel = false else notify("Fruta", "Nenhuma no mapa", 2) end
		end)
		return list
	end
	local function render()
		local words = {}
		for w in box.Text:lower():gmatch("%S+") do table.insert(words, w) end
		shownList = {}
		for _, e in ipairs(entries) do
			local ok = true
			for _, w in ipairs(words) do if not e.key:find(w, 1, true) then ok = false break end end
			if ok then
				table.insert(shownList, e)
				if #shownList >= 7 then break end
			end
		end
		sel = math.clamp(sel, 1, math.max(#shownList, 1))
		for i = 1, 7 do
			local b, e = resBtns[i], shownList[i]
			b.Visible = e ~= nil
			if e then
				b.Text = "  " .. e.label
				b.BackgroundColor3 = (i == sel) and T.accent or T.row
				b.TextColor3 = (i == sel) and white or T.text
			end
		end
	end
	local function close() pal.Visible = false end
	local function run(i)
		local e = shownList[i]
		close()
		if e then pcall(e.run) end
	end
	for i, b in ipairs(resBtns) do b.MouseButton1Click:Connect(function() run(i) end) end
	box:GetPropertyChangedSignal("Text"):Connect(function() sel = 1; render() end)
	box.FocusLost:Connect(function(enter)
		if enter then run(sel) else
			task.delay(0.4, function() if not box:IsFocused() then close() end end)
		end
	end)
	Z.openPalette = function()
		entries = buildEntries()
		box.Text = ""
		sel = 1
		pal.Visible = true
		render()
		task.defer(function() pcall(function() box:CaptureFocus() end) end)
	end
	conn(UIS.InputBegan:Connect(function(i, gp)
		if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if pal.Visible then
			if i.KeyCode == Enum.KeyCode.Down then sel = math.min(sel + 1, #shownList); render()
			elseif i.KeyCode == Enum.KeyCode.Up then sel = math.max(sel - 1, 1); render()
			elseif i.KeyCode == Enum.KeyCode.Escape then close() end
			return
		end
		if gp then return end
		if i.KeyCode.Name == State.PaletteKey and (UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl)) then
			Z.openPalette()
		end
	end))
end)()

------------------------------------------------------------------
-- BLOCO C: perfis, agendador, furtivo, sniper
------------------------------------------------------------------
;(function()
	if not (G and G.Z) then return end
	local Z, V = G.Z, G.V

	-- perfis
	local skip = {BlackScreen = true}
	Z.saveProfile = function(name)
		name = tostring(name or ""):match("^%s*(.-)%s*$")
		if name == "" then notify("Perfil", "Digite um nome.", 2) return end
		local p = {}
		for _, f in ipairs(G.Feats) do if not skip[f[2]] then p[f[1]] = State[f[2]] and true or false end end
		State.Profiles[name] = p
		if Z.refreshProfiles then Z.refreshProfiles() end
		notify("Perfil", "\"" .. name .. "\" salvo!", 2)
	end
	Z.applyProfile = function(name)
		local p = State.Profiles[name]
		if not p then return end
		for _, f in ipairs(G.Feats) do
			if not skip[f[2]] and p[f[1]] ~= nil then
				local v = p[f[1]] == true
				if State[f[2]] ~= v then
					State[f[2]] = v
					if G.after[f[2]] then pcall(G.after[f[2]], v) end
				end
			end
		end
		syncAll()
		notify("Perfil", "Aplicado: " .. name, 2)
	end

	-- agendador
	Z.sched, Z.schedLabels = {}, {}
	Z.addSched = function()
		local key = G.FeatMap[State.SchedPick]
		if not key then return end
		table.insert(Z.sched, {name = State.SchedPick, key = key, at = tick() + State.SchedMin * 60, act = State.SchedAct})
		if Z.refreshSched then Z.refreshSched() end
		notify("Agendador", State.SchedPick .. " → " .. State.SchedAct .. " em " .. State.SchedMin .. " min", 2.5)
	end
	G.loop(1, function()
		local changed = false
		for i = #Z.sched, 1, -1 do
			local s = Z.sched[i]
			if tick() >= s.at then
				local v
				if s.act == "Ligar" then v = true elseif s.act == "Desligar" then v = false else v = not State[s.key] end
				State[s.key] = v
				if G.after[s.key] then pcall(G.after[s.key], v) end
				syncAll()
				notify("Agendador", s.name .. (v and " ligado" or " desligado"), 3)
				table.remove(Z.sched, i)
				changed = true
			end
		end
		if changed and Z.refreshSched then Z.refreshSched() end
		for s, lb in pairs(Z.schedLabels) do
			local left = math.max(0, math.floor(s.at - tick()))
			pcall(function() lb.Text = s.name .. " → " .. s.act .. "  •  " .. string.format("%02d:%02d", math.floor(left / 60), left % 60) end)
		end
	end)

	-- modo furtivo
	local FARM = {"AutoLevel", "Farm", "AutoBoss", "AutoElite", "Chest", "FruitGrab"}
	local fcache = {}
	local trig, saved, savedSafe, lastHop = false, nil, nil, 0
	local function isFriend(p)
		if fcache[p.UserId] == nil then
			fcache[p.UserId] = false
			task.spawn(function()
				local ok, r = pcall(function() return lp:IsFriendsWith(p.UserId) end)
				fcache[p.UserId] = ok and r or false
			end)
		end
		return fcache[p.UserId]
	end
	local function nearby()
		local r = G.root()
		if not r then return nil end
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= lp then
				local hr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				if hr and (hr.Position - r.Position).Magnitude <= State.StealthRange then
					if not (State.StealthFriends and isFriend(p)) then return p end
				end
			end
		end
	end
	local function restore()
		if saved then
			for k in pairs(saved) do State[k] = true end
			saved = nil
			syncAll()
		end
		if savedSafe then
			State.SafeMode, State.SafePct = savedSafe[1], savedSafe[2]
			savedSafe = nil
			syncAll()
		end
	end
	G.loop(1, function()
		if not State.StealthOn then
			if trig then trig = false; restore() end
			return
		end
		local p = nearby()
		if p then
			if not trig then
				trig = true
				notify("Furtivo", p.DisplayName .. " está por perto!", 3)
				V.webhook("⚠ Jogador por perto", p.DisplayName .. " a menos de " .. State.StealthRange .. " st", 15158332)
				local act = State.StealthAct
				if act == "Pausar farm" then
					saved = {}
					for _, k in ipairs(FARM) do if State[k] then saved[k] = true; State[k] = false end end
					syncAll()
				elseif act == "Subir (seguro)" then
					savedSafe = {State.SafeMode, State.SafePct}
					State.SafeMode, State.SafePct = true, 101
					syncAll()
				end
			end
			if State.StealthAct == "Trocar servidor" and tick() - lastHop > 30 then lastHop = tick(); G.serverHop() end
		elseif trig then
			trig = false
			notify("Furtivo", "Caminho livre.", 2)
			restore()
		end
	end)

	-- fruit sniper + reexecutar
	local qot = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
	Z.hasQOT = qot ~= nil
	Z.queueReexec = function()
		if not State.ReExec or not qot or Z.reexecSrc == "" then return end
		pcall(qot, 'loadstring(game:HttpGet("' .. Z.reexecSrc .. '"))()')
	end
	conn(lp.OnTeleport:Connect(function(st)
		if st == Enum.TeleportState.Started then Z.queueReexec() end
	end))
	Z.sniperStatus = "desligado"
	local noFruitSince, lastSnHop, grabbing = nil, 0, false
	G.loop(1, function()
		if not State.SniperOn then noFruitSince = nil; Z.sniperStatus = "desligado" return end
		local f = G.findFruit()
		if f then
			noFruitSince = nil
			Z.sniperStatus = "fruta encontrada: " .. f.Name
			if State.SniperGrab and not grabbing then
				grabbing = true
				task.spawn(function()
					State.ManualTravel = true
					pcall(G.goTo, f.Handle.CFrame)
					State.ManualTravel = false
					task.wait(1)
					grabbing = false
				end)
			end
		else
			noFruitSince = noFruitSince or tick()
			local waited = tick() - noFruitSince
			Z.sniperStatus = "sem fruta há " .. math.floor(waited) .. "s"
			if State.SniperHop and waited >= State.SniperWait and tick() - lastSnHop > 25 then
				lastSnHop = tick()
				noFruitSince = nil
				Z.sniperStatus = "trocando de servidor..."
				G.serverHop()
			end
		end
	end)
end)()

------------------------------------------------------------------
-- BLOCO D: ferramentas (lógica)
------------------------------------------------------------------
;(function()
	if not (G and G.Z) then return end
	local Z, V = G.Z, G.V
	-- cronômetro e timer
	local sw = {run = false, t0 = 0, acc = 0}
	Z.swTime = function() return sw.acc + (sw.run and (tick() - sw.t0) or 0) end
	Z.swToggle = function()
		if sw.run then sw.acc = sw.acc + tick() - sw.t0; sw.run = false else sw.t0 = tick(); sw.run = true end
	end
	Z.swReset = function() sw.run = false; sw.acc = 0 end
	local tm = {endAt = nil}
	Z.timerStart = function(min)
		tm.endAt = tick() + min * 60
		notify("Timer", min .. " min iniciado", 2)
	end
	Z.timerCancel = function() tm.endAt = nil end
	Z.timerLeft = function() return tm.endAt and math.max(0, tm.endAt - tick()) or nil end
	G.loop(0.5, function()
		if tm.endAt and tick() >= tm.endAt then
			tm.endAt = nil
			notify("⏰ Timer", "Acabou o tempo!", 6)
			V.webhook("⏰ Timer", "Acabou o tempo!", 15844367)
			pcall(function()
				local s = Instance.new("Sound")
				s.SoundId = "rbxasset://sounds/electronicpingshort.wav"
				s.Volume = 1
				s.Parent = game:GetService("SoundService")
				s:Play()
				game:GetService("Debris"):AddItem(s, 3)
			end)
		end
	end)
	Z.fmtClock = function(s)
		s = math.floor(s or 0)
		return string.format("%02d:%02d:%02d", math.floor(s / 3600), math.floor(s % 3600 / 60), s % 60)
	end

	-- música
	local snd = Instance.new("Sound")
	snd.Name = "AppleHubMusic"
	snd.Parent = game:GetService("SoundService")
	Z.snd = snd
	Z.musicStatus = "parado"
	Z.musicPlay = function()
		local id = tostring(State.MusicId):gsub("%D", "")
		if id == "" then notify("Música", "Defina um ID de áudio.", 2) return end
		snd.SoundId = "rbxassetid://" .. id
		snd.Volume = State.MusicVol / 100
		snd.Looped = State.MusicLoop
		snd:Play()
		task.spawn(function()
			local t0 = tick()
			while not snd.IsLoaded and tick() - t0 < 4 do task.wait(0.2) end
			if not snd.IsLoaded then notify("Música", "Não carregou (ID inválido ou sem permissão).", 3) end
		end)
	end
	Z.musicPause = function() if snd.IsPlaying then snd:Pause() else snd:Resume() end end
	Z.musicStop = function() snd:Stop() end
	G.loop(0.5, function()
		snd.Volume = State.MusicVol / 100
		snd.Looped = State.MusicLoop
		Z.musicStatus = snd.IsPlaying and "tocando" or (snd.IsPaused and "pausado" or "parado")
	end)

	-- combo
	local numMap = {["1"] = "One", ["2"] = "Two", ["3"] = "Three", ["4"] = "Four", ["5"] = "Five"}
	local function pressK(k)
		k = numMap[k] or k
		local ok, kc = pcall(function() return Enum.KeyCode[k] end)
		if not ok or not kc then return false end
		pcall(function()
			VIM:SendKeyEvent(true, kc, false, game)
			task.wait(0.06)
			VIM:SendKeyEvent(false, kc, false, game)
		end)
		return true
	end
	Z.runCombo = function()
		for tok in tostring(State.ComboSeq):gmatch("[^,%s]+") do
			if not alive then return end
			pressK(tok:upper())
			task.wait(math.max(State.ComboDelay, 50) / 1000)
		end
	end
	task.spawn(function()
		while alive do
			task.wait(0.2)
			if State.ComboLoop and not G.safeUp then Z.runCombo() end
		end
	end)

	-- hora travada e câmera
	G.loop(0.5, function() if State.LockClock then Lighting.ClockTime = State.ClockLockVal end end)
	Z.applyCam = function()
		pcall(function() lp.CameraMode = (State.CamMode == "Primeira pessoa") and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic end)
	end

	gui.Destroying:Connect(function()
		pcall(function() snd:Destroy() end)
		pcall(function() lp.CameraMode = Enum.CameraMode.Classic end)
	end)
end)()

------------------------------------------------------------------
-- BLOCO E: efeitos (toque mágico, fantasma, fundo, tema automático)
------------------------------------------------------------------
;(function()
	if not (G and G.Z) then return end
	local Z = G.Z

	-- toque mágico
	local fxLayer = new("Frame", {Name = "TouchFX", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 500, Parent = gui})
	local function fxColor(i)
		local m = State.TouchColor
		if m == "Arco-íris" then return Color3.fromHSV((tick() * 0.5 + i * 0.07) % 1, 0.65, 1)
		elseif m == "Branco" then return Color3.new(1, 1, 1) end
		return (i % 2 == 0) and T.accent or T.accent2
	end
	local function burst(pos)
		if #fxLayer:GetChildren() > 100 then return end
		local st, n = State.TouchStyle, State.TouchCount
		if st == "Ondas" then
			for k = 1, 2 do
				local r = new("Frame", {Size = UDim2.fromOffset(10, 10), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(pos.X, pos.Y), BackgroundTransparency = 1, Parent = fxLayer},
					{corner(500), new("UIStroke", {Color = fxColor(k), Thickness = 2.5})})
				tween(r, 0.6 + k * 0.15, {Size = UDim2.fromOffset(90 * k, 90 * k)}, Enum.EasingStyle.Quad)
				tween(r:FindFirstChildOfClass("UIStroke"), 0.6 + k * 0.15, {Transparency = 1}, Enum.EasingStyle.Quad)
				task.delay(1.2, function() pcall(function() r:Destroy() end) end)
			end
			return
		end
		for i = 1, n do
			local a, d = math.random() * math.pi * 2, 30 + math.random() * 55
			local p, prop
			if st == "Estrelas" or st == "Corações" then
				p = new("TextLabel", {Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(pos.X, pos.Y), BackgroundTransparency = 1,
					Text = (st == "Estrelas") and "✦" or "♥", TextSize = 10 + math.random() * 10, TextColor3 = fxColor(i), Font = Enum.Font.GothamBold, Parent = fxLayer})
				prop = "TextTransparency"
			elseif st == "Confete" then
				p = new("Frame", {Size = UDim2.fromOffset(6, 3), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(pos.X, pos.Y), BackgroundColor3 = fxColor(i), BorderSizePixel = 0, Rotation = math.random(360), Parent = fxLayer})
				prop = "BackgroundTransparency"
			else
				local s = 4 + math.random() * 5
				p = new("Frame", {Size = UDim2.fromOffset(s, s), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(pos.X, pos.Y), BackgroundColor3 = fxColor(i), BorderSizePixel = 0, Parent = fxLayer}, {corner(5)})
				prop = "BackgroundTransparency"
			end
			local tx, ty = pos.X + math.cos(a) * d, pos.Y + math.sin(a) * d
			if st == "Corações" then tx = pos.X + (math.random() - 0.5) * 50; ty = pos.Y - 40 - math.random() * 60 end
			tween(p, 0.8, {Position = UDim2.fromOffset(tx, ty), [prop] = 1}, Enum.EasingStyle.Quad)
			task.delay(0.9, function() pcall(function() p:Destroy() end) end)
		end
	end
	Z.testFX = function() burst(Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)) end
	conn(UIS.InputBegan:Connect(function(i)
		if not State.TouchFX then return end
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			local inset = GuiService:GetGuiInset()
			burst(Vector2.new(i.Position.X + inset.X, i.Position.Y + inset.Y))
		end
	end))

	-- modo fantasma
	local lastIn = tick()
	local function poke() lastIn = tick() end
	main.InputBegan:Connect(poke)
	main.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then poke() end
	end)
	G.loop(0.3, function()
		if not State.GhostOn then return end
		if not shown or main.GroupTransparency >= 0.99 then return end
		local target = (tick() - lastIn > State.GhostAfter) and State.GhostLevel / 100 or 0
		if math.abs(main.GroupTransparency - target) > 0.03 then tween(main, 0.45, {GroupTransparency = target}, Enum.EasingStyle.Quad) end
	end)
	G.after.GhostOn = function(v)
		if not v then
			poke()
			if shown and main.GroupTransparency < 0.99 then tween(main, 0.3, {GroupTransparency = 0}) end
		end
	end

	-- imagem de fundo
	local bg = new("ImageLabel", {Name = "BgImage", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 0, Visible = false, Parent = main})
	Z.applyBg = function()
		local id = tostring(State.BgImage):gsub("%D", "")
		bg.Visible = id ~= ""
		bg.Image = id ~= "" and ("rbxassetid://" .. id) or ""
		bg.ImageTransparency = 1 - State.BgAlpha / 100
		bg.ScaleType = State.BgScale == "Fit" and Enum.ScaleType.Fit or (State.BgScale == "Stretch" and Enum.ScaleType.Stretch or Enum.ScaleType.Crop)
	end

	-- tema automático
	Z.randomTheme = function()
		local names = {}
		for _, n in ipairs(ThemeNames) do if n ~= "Custom" and n ~= State.Theme then table.insert(names, n) end end
		local n = names[math.random(#names)]
		applyTheme(n)
		notify("Tema", n, 1.5)
	end
	local lastAT = tick()
	G.loop(5, function()
		if State.AutoTheme and tick() - lastAT >= State.AutoThemeMin * 60 then lastAT = tick(); Z.randomTheme() end
	end)
end)()

------------------------------------------------------------------
-- BLOCO F: ESP+
------------------------------------------------------------------
;(function()
	if not (G and G.Z) then return end
	local espFolder = new("Folder", {Name = "ESPPlus", Parent = gui})
	local objs, lines = {}, {}
	local hasDraw = false
	pcall(function() hasDraw = Drawing ~= nil and Drawing.new ~= nil end)
	local warned = false

	local function colorFor(ratio, idx)
		local m = State.EspColor
		if m == "Tema" then return T.accent
		elseif m == "Arco-íris" then return Color3.fromHSV((tick() * 0.2 + idx * 0.1) % 1, 0.7, 1)
		elseif m == "Por vida" then return Color3.fromRGB(255, 60, 60):Lerp(Color3.fromRGB(70, 255, 110), ratio) end
		return Color3.fromRGB(255, 85, 85)
	end
	local function make(p)
		local bb = new("BillboardGui", {Size = UDim2.fromOffset(180, 46), AlwaysOnTop = true, StudsOffset = Vector3.new(0, 3.4, 0), Parent = espFolder})
		local nm = new("TextLabel", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, TextStrokeTransparency = 0.4, Font = Enum.Font.GothamBold, Parent = bb})
		local bar = new("Frame", {Size = UDim2.new(0.7, 0, 0, 5), Position = UDim2.new(0.15, 0, 0, 19), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.4, BorderSizePixel = 0, Parent = bb}, {corner(3)})
		local fill = new("Frame", {Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, Parent = bar}, {corner(3)})
		local ds = new("TextLabel", {Size = UDim2.new(1, 0, 0, 14), Position = UDim2.fromOffset(0, 27), BackgroundTransparency = 1, TextStrokeTransparency = 0.5, Font = Enum.Font.Gotham, Parent = bb})
		local o = {bb = bb, nm = nm, bar = bar, fill = fill, ds = ds}
		objs[p] = o
		return o
	end
	local function drop(p)
		local o = objs[p]
		if o then
			pcall(function() o.bb:Destroy() end)
			pcall(function() if o.hl then o.hl:Destroy() end end)
			objs[p] = nil
		end
	end
	G.loop(0.15, function()
		if not State.EspOn then
			for p in pairs(objs) do drop(p) end
			return
		end
		if State.EspTracer and not hasDraw and not warned then
			warned = true
			notify("ESP+", "Seu executor não tem Drawing: tracers indisponíveis.", 3)
		end
		local r = G.root()
		if not r then return end
		local cand = {}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= lp then
				local c = p.Character
				local hr = c and c:FindFirstChild("HumanoidRootPart")
				local h = c and c:FindFirstChildOfClass("Humanoid")
				if hr and h then
					local d = (hr.Position - r.Position).Magnitude
					if d <= State.EspDist then table.insert(cand, {p = p, hr = hr, h = h, d = d}) end
				end
			end
		end
		table.sort(cand, function(a, b) return a.d < b.d end)
		local keep = {}
		for i = 1, math.min(#cand, State.EspMax) do
			local e = cand[i]
			keep[e.p] = true
			local o = objs[e.p] or make(e.p)
			local ratio = math.clamp(e.h.Health / math.max(e.h.MaxHealth, 1), 0, 1)
			local col = colorFor(ratio, i)
			o.hr, o.col = e.hr, col
			o.bb.Adornee = e.hr
			local lv = ""
			if State.EspLv then pcall(function() lv = "  [Lv " .. e.p.Data.Level.Value .. "]" end) end
			o.nm.Text = e.p.DisplayName .. lv
			o.nm.TextSize = State.EspSize
			o.nm.TextColor3 = col
			o.ds.Text = math.floor(e.d) .. " st  •  " .. math.floor(e.h.Health) .. " HP"
			o.ds.TextSize = math.max(State.EspSize - 2, 8)
			o.ds.TextColor3 = Color3.fromRGB(225, 225, 235)
			o.bar.Visible = State.EspHP
			o.fill.Size = UDim2.fromScale(ratio, 1)
			o.fill.BackgroundColor3 = Color3.fromRGB(255, 60, 60):Lerp(Color3.fromRGB(70, 255, 110), ratio)
			if State.EspBox then
				if not o.hl then o.hl = new("Highlight", {FillTransparency = 0.85, OutlineTransparency = 0, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = espFolder}) end
				o.hl.Adornee = e.p.Character
				o.hl.FillColor, o.hl.OutlineColor = col, col
			elseif o.hl then
				pcall(function() o.hl:Destroy() end)
				o.hl = nil
			end
		end
		for p in pairs(objs) do if not keep[p] then drop(p) end end
	end)
	conn(RS.RenderStepped:Connect(function()
		if not State.EspOn or not State.EspTracer or not hasDraw then
			for _, ln in pairs(lines) do pcall(function() ln.Visible = false end) end
			return
		end
		local vp = cam.ViewportSize
		for p, o in pairs(objs) do
			local ln = lines[p]
			if not ln then
				local ok, l = pcall(function()
					local x = Drawing.new("Line")
					x.Thickness = 1.5
					x.Transparency = 1
					return x
				end)
				if ok then ln = l; lines[p] = l end
			end
			if ln and o.hr then
				local pt, on = cam:WorldToViewportPoint(o.hr.Position)
				ln.Visible = on
				if on then
					ln.From = Vector2.new(vp.X / 2, vp.Y)
					ln.To = Vector2.new(pt.X, pt.Y)
					ln.Color = o.col or Color3.fromRGB(255, 85, 85)
				end
			end
		end
		for p, ln in pairs(lines) do
			if not objs[p] then
				pcall(function() ln:Remove() end)
				lines[p] = nil
			end
		end
	end))
	gui.Destroying:Connect(function()
		for _, ln in pairs(lines) do pcall(function() ln:Remove() end) end
	end)
end)()

------------------------------------------------------------------
-- BLOCO G: páginas novas
------------------------------------------------------------------
;(function()
	if not (G and G.Z) then return end
	local Z, V = G.Z, G.V
	local commas = G.commas

	local function newPage(name, icon)
		Z.pages[name] = true
		return addPage(name, icon)
	end
	local function listBox(page)
		local b = new("Frame", {Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = page},
			{new("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})})
		regSearch(b, "", true)
		return b
	end
	local function clearBox(box) for _, c in ipairs(box:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end end
	local function sb(parent, txt, x, w, color)
		local b = mkText({Size = UDim2.fromOffset(w, 26), Position = UDim2.new(1, x, 0.5, -13), Text = txt, TextSize = 12, AutoButtonColor = false, Parent = parent}, true, false, "TextButton")
		b.BackgroundTransparency = 0
		b.BackgroundColor3 = color
		b.TextColor3 = Color3.new(1, 1, 1)
		new("UICorner", {CornerRadius = UDim.new(0, 8), Parent = b})
		return b
	end

	------------------------------------------------ AUTOMAÇÃO
	local pAu = newPage("Automação", "⚡")
	Section(pAu, "Paleta de comandos")
	Button(pAu, "Abrir paleta (Ctrl + tecla)", function() Z.openPalette() end)
	Input(pAu, "Tecla da paleta (com Ctrl)", "ex: K e Enter", function(t)
		local k = t:gsub("%s", ""):upper()
		local ok, kc = pcall(function() return Enum.KeyCode[k] end)
		if ok and kc then State.PaletteKey = k; notify("Paleta", "Ctrl + " .. k, 2) else notify("Paleta", "Tecla inválida.", 2) end
	end)
	Section(pAu, "Modo furtivo (jogador por perto)")
	Toggle(pAu, "Ativar modo furtivo", "StealthOn")
	Slider(pAu, "Distância de alerta", 30, 500, "StealthRange", nil, " st")
	Dropdown(pAu, "Ao detectar", {"Pausar farm", "Subir (seguro)", "Trocar servidor", "Só avisar"}, "StealthAct")
	Toggle(pAu, "Ignorar amigos", "StealthFriends")
	Section(pAu, "Fruit Sniper")
	Toggle(pAu, "Ativar Fruit Sniper", "SniperOn")
	Toggle(pAu, "Ir pegar a fruta automaticamente", "SniperGrab")
	Toggle(pAu, "Trocar de servidor se não tiver fruta", "SniperHop")
	Slider(pAu, "Esperar antes de trocar", 5, 90, "SniperWait", nil, " s")
	local snLabel = Label(pAu, "Status: desligado")
	G.loop(1, function() snLabel.Text = "Status: " .. Z.sniperStatus end)
	Section(pAu, "Reexecutar após trocar de servidor")
	Label(pAu, "Cole abaixo o link RAW do seu script completo (as 4 partes juntas, hospedado no GitHub/Pastebin). O hub volta sozinho depois de cada troca. Ative também o Auto-save na aba v16.")
	Toggle(pAu, "Reexecutar automaticamente", "ReExec")
	Input(pAu, "Link RAW do script", "cole e Enter", function(u) Z.setURL(u); notify("Reexecutar", "Link salvo.", 2) end)
	Label(pAu, Z.hasQOT and "Seu executor suporta reexecução." or "Seu executor NÃO suporta queue_on_teleport.")
	Section(pAu, "Agendador")
	Dropdown(pAu, "Função", G.FeatNames, "SchedPick")
	Dropdown(pAu, "Ação", {"Ligar", "Desligar", "Alternar"}, "SchedAct")
	Slider(pAu, "Daqui a", 1, 180, "SchedMin", nil, " min")
	Button(pAu, "Agendar", function() Z.addSched() end)
	local schedBox = listBox(pAu)
	Z.refreshSched = function()
		clearBox(schedBox)
		table.clear(Z.schedLabels)
		for i, s in ipairs(Z.sched) do
			local r = row(schedBox, 38)
			r.LayoutOrder = i
			local lb = mkText({Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(12, 0), Text = s.name, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = r}, true)
			Z.schedLabels[s] = lb
			sb(r, "✕", -44, 34, Color3.fromRGB(220, 70, 70)).MouseButton1Click:Connect(function()
				for k, v in ipairs(Z.sched) do if v == s then table.remove(Z.sched, k) break end end
				Z.refreshSched()
			end)
		end
	end
	Section(pAu, "Perfis de funções")
	Label(pAu, "Salva quais funções estão ligadas agora. Digite o nome e dê Enter.")
	Input(pAu, "Salvar perfil", "nome e Enter", function(t) Z.saveProfile(t) end)
	local profBox = listBox(pAu)
	Z.refreshProfiles = function()
		clearBox(profBox)
		local names = {}
		for n in pairs(State.Profiles) do table.insert(names, n) end
		table.sort(names)
		for i, n in ipairs(names) do
			local r = row(profBox, 40)
			r.LayoutOrder = i
			mkText({Size = UDim2.new(1, -130, 1, 0), Position = UDim2.fromOffset(12, 0), Text = n, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = r}, true)
			sb(r, "Aplicar", -116, 64, T.accent).MouseButton1Click:Connect(function() Z.applyProfile(n) end)
			sb(r, "✕", -44, 34, Color3.fromRGB(220, 70, 70)).MouseButton1Click:Connect(function() State.Profiles[n] = nil; Z.refreshProfiles() end)
		end
	end
	Z.refreshProfiles()

	------------------------------------------------ FERRAMENTAS
	local pTl = newPage("Ferramentas", "⚒")
	Section(pTl, "Cronômetro")
	InfoRow(pTl, "Cronômetro", function() return Z.fmtClock(Z.swTime()) end)
	Button(pTl, "Iniciar / pausar", function() Z.swToggle() end)
	Button(pTl, "Zerar", function() Z.swReset() end)
	Section(pTl, "Timer")
	Input(pTl, "Minutos", "ex: 5 e Enter", function(t)
		local n = tonumber(t)
		if n and n > 0 then Z.timerStart(n) else notify("Timer", "Número inválido.", 2) end
	end)
	InfoRow(pTl, "Restante", function() local l = Z.timerLeft() return l and Z.fmtClock(l) or "—" end)
	Button(pTl, "Cancelar timer", function() Z.timerCancel() end)
	Section(pTl, "Bloco de notas")
	local nr = row(pTl, 150)
	regSearch(nr, "bloco de notas")
	local nb = mkText({Size = UDim2.new(1, -20, 1, -20), Position = UDim2.fromOffset(10, 10), Text = State.Notes, PlaceholderText = "Escreva aqui... (salva ao sair do campo)",
		TextSize = 13, MultiLine = true, TextWrapped = true, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, false, "text", "TextBox")
	nb.Parent = nr
	nb.FocusLost:Connect(function() State.Notes = nb.Text end)
	Label(pTl, "As notas vão junto com \"Salvar config\" ou com o Auto-save.")
	Section(pTl, "Player de música")
	Input(pTl, "ID do áudio", "só números e Enter", function(t) State.MusicId = t; notify("Música", "ID definido.", 1.5) end)
	Button(pTl, "▶ Tocar", function() Z.musicPlay() end)
	Button(pTl, "⏯ Pausar / continuar", function() Z.musicPause() end)
	Button(pTl, "■ Parar", function() Z.musicStop() end)
	Slider(pTl, "Volume", 0, 100, "MusicVol", nil, "%")
	Toggle(pTl, "Repetir", "MusicLoop")
	InfoRow(pTl, "Estado", function() return Z.musicStatus end)
	Section(pTl, "Combo de teclas")
	Label(pTl, "Sequência separada por vírgula. Ex: 1,Z,X,2,C,V (números 1 a 5 trocam de item).")
	Input(pTl, "Sequência", "ex: Z,X,C e Enter", function(t) State.ComboSeq = t; notify("Combo", t, 2) end)
	InfoRow(pTl, "Atual", function() return State.ComboSeq end)
	Slider(pTl, "Intervalo entre teclas", 50, 2000, "ComboDelay", nil, " ms")
	Button(pTl, "Executar combo agora", function() task.spawn(Z.runCombo) end)
	Toggle(pTl, "Repetir combo sem parar", "ComboLoop")
	Section(pTl, "Ambiente e câmera")
	Toggle(pTl, "Travar hora do dia", "LockClock")
	Slider(pTl, "Hora travada", 0, 24, "ClockLockVal", nil, "h")
	Dropdown(pTl, "Modo da câmera", {"Normal", "Primeira pessoa"}, "CamMode", function() Z.applyCam() end)

	------------------------------------------------ ESP+
	local pEs = newPage("ESP+", "◈")
	Section(pEs, "ESP avançado de jogadores")
	Toggle(pEs, "Ativar ESP+", "EspOn")
	Slider(pEs, "Distância máxima", 100, 5000, "EspDist", nil, " st")
	Slider(pEs, "Máximo de jogadores", 5, 30, "EspMax")
	Slider(pEs, "Tamanho do texto", 9, 20, "EspSize")
	Toggle(pEs, "Barra de vida", "EspHP")
	Toggle(pEs, "Mostrar level", "EspLv")
	Toggle(pEs, "Contorno no personagem", "EspBox")
	Toggle(pEs, "Tracers (linhas, precisa de Drawing)", "EspTracer")
	Dropdown(pEs, "Cor", {"Vermelho", "Tema", "Arco-íris", "Por vida"}, "EspColor")

	------------------------------------------------ EFEITOS
	local pFx2 = newPage("Efeitos", "✺")
	Section(pFx2, "Toque mágico")
	Toggle(pFx2, "Efeito ao tocar/clicar", "TouchFX")
	Dropdown(pFx2, "Estilo", {"Faíscas", "Ondas", "Estrelas", "Corações", "Confete"}, "TouchStyle")
	Dropdown(pFx2, "Cor", {"Tema", "Arco-íris", "Branco"}, "TouchColor")
	Slider(pFx2, "Quantidade", 4, 30, "TouchCount")
	Button(pFx2, "Testar efeito", function() Z.testFX() end)
	Section(pFx2, "Modo fantasma")
	Toggle(pFx2, "Painel fica transparente quando parado", "GhostOn")
	Slider(pFx2, "Esperar", 2, 30, "GhostAfter", nil, " s")
	Slider(pFx2, "Transparência", 20, 90, "GhostLevel", nil, "%")
	Section(pFx2, "Imagem de fundo do painel")
	Label(pFx2, "Use o ID de uma imagem do Roblox (só números).")
	Input(pFx2, "ID da imagem", "só números e Enter", function(t) State.BgImage = t; Z.applyBg() end)
	Slider(pFx2, "Opacidade da imagem", 5, 100, "BgAlpha", function() Z.applyBg() end, "%")
	Dropdown(pFx2, "Ajuste", {"Crop", "Fit", "Stretch"}, "BgScale", function() Z.applyBg() end)
	Button(pFx2, "Remover imagem", function() State.BgImage = ""; Z.applyBg() end)
	Section(pFx2, "Tema")
	Button(pFx2, "Tema aleatório", function() Z.randomTheme() end)
	Toggle(pFx2, "Trocar tema sozinho", "AutoTheme")
	Slider(pFx2, "A cada", 1, 60, "AutoThemeMin", nil, " min")
	Section(pFx2, "Temas extras do v26")
	local g = Grid(pFx2, 134, 58)
	for _, name in ipairs(Z.extraNames) do
		local tt = Themes[name]
		local b = new("TextButton", {BackgroundColor3 = tt.bg, Text = "", AutoButtonColor = false, Parent = g}, {rc(12)})
		new("Frame", {Size = UDim2.new(1, -12, 0, 16), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = Color3.new(1, 1, 1), Parent = b},
			{corner(6), new("UIGradient", {Color = ColorSequence.new(tt.accent, tt.accent2)})})
		new("Frame", {Size = UDim2.new(1, -12, 0, 8), Position = UDim2.fromOffset(6, 27), BackgroundColor3 = tt.row, Parent = b}, {corner(4)})
		new("TextLabel", {Size = UDim2.new(1, 0, 0, 16), Position = UDim2.fromOffset(0, 38), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = tt.text, Parent = b})
		local st = new("UIStroke", {Thickness = 2.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = (State.Theme == name), Parent = b})
		bind(st, "Color", "accent")
		themeStrokes[name] = st
		b.MouseButton1Click:Connect(function() uiSound(); applyTheme(name) end)
	end

	------------------------------------------------ STATS
	local pSt = newPage("Stats", "▦")
	Section(pSt, "Gráficos da sessão")
	local N = 40
	local function spark(page, title)
		local r = row(page, 86)
		regSearch(r, title)
		local tl = mkText({Size = UDim2.new(1, -24, 0, 20), Position = UDim2.fromOffset(12, 4), Text = title, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, true)
		local box = new("Frame", {Size = UDim2.new(1, -24, 0, 48), Position = UDim2.fromOffset(12, 30), BackgroundTransparency = 1, Parent = r})
		local bars = {}
		for i = 1, N do
			local b = new("Frame", {Size = UDim2.new(1 / N, -1, 0, 2), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new((i - 1) / N, 0, 1, 0), BorderSizePixel = 0, BackgroundColor3 = T.accent, Parent = box}, {corner(2)})
			bind(b, "BackgroundColor3", "accent")
			bars[i] = b
		end
		return {tl = tl, bars = bars, name = title, hist = {}}
	end
	local function feed(sp, val, label)
		table.insert(sp.hist, math.max(val, 0))
		if #sp.hist > N then table.remove(sp.hist, 1) end
		local mx = 1
		for _, v in ipairs(sp.hist) do if v > mx then mx = v end end
		for i, b in ipairs(sp.bars) do
			local v = sp.hist[#sp.hist - N + i]
			b.Size = UDim2.new(1 / N, -1, 0, v and math.max(2, math.floor(v / mx * 48)) or 2)
		end
		sp.tl.Text = sp.name .. "  •  " .. label
	end
	local spBeli = spark(pSt, "Beli ganho (acumulado, a cada 30 s)")
	local spLv = spark(pSt, "Levels ganhos (acumulado, a cada 30 s)")
	local st = {sum = 0, n = 0, min = 9999, pSum = 0, pMax = 0, best = 0}
	G.loop(30, function()
		feed(spBeli, G.gain("Beli"), commas(G.gain("Beli")))
		feed(spLv, G.gain("Level"), commas(G.gain("Level")))
	end)
	G.loop(1, function()
		if fps > 0 then
			st.sum = st.sum + fps
			st.n = st.n + 1
			if fps < st.min then st.min = fps end
		end
		local p = getPing()
		st.pSum = st.pSum + p
		if p > st.pMax then st.pMax = p end
		local r = V.rateNum("Beli")
		if r > st.best then st.best = r end
	end)
	Section(pSt, "Médias")
	InfoRow(pSt, "FPS médio", function() return st.n > 0 and tostring(math.floor(st.sum / st.n)) or "—" end)
	InfoRow(pSt, "FPS mínimo", function() return st.n > 0 and tostring(st.min) or "—" end)
	InfoRow(pSt, "Ping médio", function() return st.n > 0 and (math.floor(st.pSum / st.n) .. " ms") or "—" end)
	InfoRow(pSt, "Maior ping", function() return st.pMax .. " ms" end)
	InfoRow(pSt, "Melhor Beli/h", function() return commas(st.best) end)
	InfoRow(pSt, "Memória do jogo", function() return math.floor(Stats:GetTotalMemoryUsageMb()) .. " MB" end)
	Button(pSt, "Resetar sessão (zera ganhos e médias)", function()
		G.base = {}
		startTick = tick()
		st.sum, st.n, st.min, st.pSum, st.pMax, st.best = 0, 0, 9999, 0, 0, 0
		spBeli.hist, spLv.hist = {}, {}
		notify("Stats", "Sessão reiniciada.", 2)
	end)

	------------------------------------------------ comandos novos no console
	local oldRun = V.run
	V.run = function(text)
		local cmd, rest = tostring(text):match("^%s*(%S+)%s*(.*)$")
		if not cmd then return end
		local c, say = cmd:lower(), V.say
		local mine = {palette = true, profile = true, saveprofile = true, music = true, stopmusic = true, timer = true, stopwatch = true}
		if not mine[c] then return oldRun(text) end
		say("> " .. text)
		if c == "palette" then Z.openPalette()
		elseif c == "profile" then
			if State.Profiles[rest] then Z.applyProfile(rest); say("perfil " .. rest) else say("perfil não existe") end
		elseif c == "saveprofile" then Z.saveProfile(rest); say("perfil salvo")
		elseif c == "music" then State.MusicId = rest; Z.musicPlay(); say("tocando " .. rest)
		elseif c == "stopmusic" then Z.musicStop(); say("música parada")
		elseif c == "timer" then
			local n = tonumber(rest)
			if n then Z.timerStart(n); say("timer " .. n .. " min") else say("uso: timer 5") end
		elseif c == "stopwatch" then Z.swToggle(); say("cronômetro: " .. Z.fmtClock(Z.swTime()))
		end
	end

	-- aplicar tudo ao abrir
	Z.applyCam()
	Z.applyBg()
	layoutTabs()
	notify("Apple Hub v26", "Novo: Paleta (Ctrl+K), Furtivo, Sniper, ESP+, Efeitos...", 4)
end)()
-- ===== APPLE HUB v30 — PARTE 5 (cole depois das Partes 1, 2 [v9], 3 [v16] e 4 [v26]) =====

------------------------------------------------------------------
-- BLOCO A: estado, compacto, editor de tema, título animado
------------------------------------------------------------------
;(function()
	if not (G and G.Z and G.Z.openPalette and addPage) then warn("[AppleHub v30] Cole esta parte DEPOIS das Partes 1 e 2 (v9), 3 (v16) e 4 (v26).") return end
	local Y = {pages = {}, progress = {}}
	G.Y = Y
	local NEW = {
		StartTab = "Início", Compact = false, PrevSide = 128, TitleAnim = "Nenhuma",
		TargetHud = false, THScale = 100, THAlpha = 35,
		GoalOn = false, GoalBeli = 1000000, GoalKills = 500,
		ChatLog = false, ChatKeys = "fruit,leopard,trade", ChatAlert = true, ChatMine = true,
		SoundAlert = false, SoundFruit = true, SoundBoss = true, AlertVol = 60,
		MacroLoop = false, MacroSpeed = 100, Macro = {},
		AutoPerf = false, PerfMin = 25,
		PanicKey = "End", PanicOff = true, PanicUnload = false, PanicBtn = true,
		SnakeHi = 0, CustomHex = {},
	}
	for k, v in pairs(NEW) do
		State[k] = v
		Default[k] = type(v) == "table" and {} or v
		table.insert(SAVE_KEYS, k)
	end
	pcall(function()
		if isfile and isfile(CFG_FILE) then
			local d = HttpService:JSONDecode(readfile(CFG_FILE))
			for k, v in pairs(NEW) do
				if d[k] ~= nil and type(d[k]) == type(v) then State[k] = d[k] end
			end
		end
	end)
	local tt = tostring(State.Title)
	if State.Title == Default.Title or tt:find("v26", 1, true) or tt:find("v16", 1, true) then
		State.Title = "Apple Hub v30  •  Blox Fruits"
		titleLabel.Text = State.Title
	end

	local extra = {{"Target HUD", "TargetHud"}, {"Alerta Sonoro", "SoundAlert"}, {"Auto Performance", "AutoPerf"}, {"Chat Log", "ChatLog"},
		{"Modo Compacto", "Compact"}, {"Macro Loop", "MacroLoop"}, {"Metas", "GoalOn"}}
	for _, f in ipairs(extra) do
		table.insert(G.Feats, f)
		table.insert(G.FeatNames, f[1])
		G.FeatMap[f[1]] = f[2]
	end

	-- modo compacto (só ícones)
	local oldLayout = layoutTabs
	layoutTabs = function()
		oldLayout()
		if State.Compact and State.TabIcons then
			for _, b in ipairs(tabHolder:GetChildren()) do
				if b:IsA("TextButton") then b.Text = b.Text:match("^(%S+)") or b.Text end
			end
		end
	end
	Y.applyCompact = function()
		if State.Compact then
			if State.SideW > 70 then State.PrevSide = State.SideW end
			State.SideW, State.TabAlign = 56, "Centro"
		else
			State.SideW, State.TabAlign = math.max(State.PrevSide, 90), "Esquerda"
		end
		applyAppearance(); syncAll()
	end
	G.after.Compact = function() Y.applyCompact() end

	-- tema custom por hex
	Y.applyCustomHex = function()
		for k, hex in pairs(State.CustomHex) do pcall(function() Themes.Custom[k] = Color3.fromHex(hex) end) end
	end
	local oldCustom = updateCustom
	updateCustom = function() oldCustom(); Y.applyCustomHex() end
	Y.applyCustomHex()
	if State.Theme == "Custom" then pcall(applyTheme, "Custom") end

	-- título animado
	G.loop(0.05, function()
		local m = State.TitleAnim
		if m == "Arco-íris" then titleLabel.TextColor3 = Color3.fromHSV((tick() * 0.15) % 1, 0.55, 1)
		elseif m == "Pulso" then titleLabel.TextColor3 = T.sub:Lerp(T.accent, 0.5 + 0.5 * math.sin(tick() * 3)) end
	end)
end)()

------------------------------------------------------------------
-- BLOCO B: Target HUD + kills
------------------------------------------------------------------
;(function()
	if not (G and G.Y) then return end
	local Y = G.Y
	Y.kills = 0
	local th = new("Frame", {Name = "TargetHUD", Size = UDim2.fromOffset(190, 0), AutomaticSize = Enum.AutomaticSize.Y, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 28),
		BackgroundColor3 = T.bg, BackgroundTransparency = State.THAlpha / 100, ZIndex = 32, Visible = false, Parent = gui},
		{corner(12), new("UIPadding", {PaddingTop = UDim.new(0, 7), PaddingBottom = UDim.new(0, 7), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}),
			new("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})})
	bind(th, "BackgroundColor3", "bg")
	bind(new("UIStroke", {Thickness = 1, Transparency = 0.75, Parent = th}), "Color", "accent")
	local ths = new("UIScale", {Scale = State.THScale / 100, Parent = th})
	local nm = mkText({Size = UDim2.new(1, 0, 0, 16), Text = "", TextSize = 13, ZIndex = 33, LayoutOrder = 1, Parent = th}, true)
	local barBG = new("Frame", {Size = UDim2.new(1, 0, 0, 8), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.4, BorderSizePixel = 0, ZIndex = 33, LayoutOrder = 2, Parent = th}, {corner(4)})
	local fill = new("Frame", {Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, ZIndex = 34, Parent = barBG}, {corner(4)})
	local info = mkText({Size = UDim2.new(1, 0, 0, 14), Text = "", TextSize = 11, ZIndex = 33, LayoutOrder = 3, Parent = th}, false, "sub")
	drag(th, th)
	Y.applyTH = function()
		th.BackgroundTransparency = State.THAlpha / 100
		ths.Scale = State.THScale / 100
	end
	local cur, curHum
	G.loop(0.15, function()
		if not (State.TargetHud or G.anyAuto()) then
			th.Visible = false
			cur, curHum = nil, nil
			return
		end
		if cur and curHum and (curHum.Health <= 0 or not cur.Parent) then
			if curHum.Health <= 0 then Y.kills = Y.kills + 1 end
			cur, curHum = nil, nil
		end
		local mr = G.nearestMob()
		local mdl = mr and mr.Parent
		local h = mdl and mdl:FindFirstChildOfClass("Humanoid")
		if mdl and h then cur, curHum = mdl, h end
		if State.TargetHud and mdl and h then
			th.Visible = true
			local ratio = math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1)
			nm.Text = mdl.Name .. (G.BossSet[mdl.Name] and "  [BOSS]" or "")
			fill.Size = UDim2.fromScale(ratio, 1)
			fill.BackgroundColor3 = Color3.fromRGB(255, 60, 60):Lerp(Color3.fromRGB(70, 255, 110), ratio)
			local r = G.root()
			info.Text = math.floor(h.Health) .. " / " .. math.floor(h.MaxHealth) .. (r and ("  •  " .. math.floor((mr.Position - r.Position).Magnitude) .. " st") or "")
		else
			th.Visible = false
		end
	end)
end)()

------------------------------------------------------------------
-- BLOCO C: metas, alertas sonoros, total geral
------------------------------------------------------------------
;(function()
	if not (G and G.Y) then return end
	local Y = G.Y
	Y.goalDone = {}
	Y.ping = function(vol)
		pcall(function()
			local s = Instance.new("Sound")
			s.SoundId = "rbxasset://sounds/electronicpingshort.wav"
			s.Volume = (vol or State.AlertVol) / 100
			s.Parent = game:GetService("SoundService")
			s:Play()
			game:GetService("Debris"):AddItem(s, 3)
		end)
	end
	G.loop(1, function()
		for _, p in ipairs(Y.progress) do
			local c, m = p.cur(), math.max(p.max(), 1)
			local r = math.clamp(c / m, 0, 1)
			p.fill.Size = UDim2.new(r, 0, 1, 0)
			p.tl.Text = p.title .. "  •  " .. G.commas(c) .. " / " .. G.commas(m) .. "  (" .. math.floor(r * 100) .. "%)"
		end
		if not State.GoalOn then return end
		for _, p in ipairs(Y.progress) do
			if p.cur() >= p.max() and not Y.goalDone[p.title] then
				Y.goalDone[p.title] = true
				notify("🎯 Meta atingida!", p.title, 5)
				if State.SoundAlert then Y.ping() end
				G.V.webhook("🎯 Meta atingida", p.title, 5763719)
			end
		end
	end)

	-- alertas sonoros
	local lastF, lastB = nil, {}
	G.loop(2, function()
		if not State.SoundAlert then return end
		if State.SoundFruit then
			local f = G.findFruit()
			if f and f ~= lastF then lastF = f; Y.ping() elseif not f then lastF = nil end
		end
		if State.SoundBoss then
			local folder = workspace:FindFirstChild("Enemies")
			if folder then
				for _, m in ipairs(folder:GetChildren()) do
					if G.BossSet[m.Name] and not lastB[m] then lastB[m] = true; Y.ping() end
				end
				for m in pairs(lastB) do if not m.Parent then lastB[m] = nil end end
			end
		end
	end)

	-- total geral (todas as sessões)
	local LIFE_FILE = "AppleHub_v30_life.json"
	Y.life = {secs = 0, beli = 0, lvls = 0, kills = 0, sessions = 1}
	pcall(function()
		if isfile and isfile(LIFE_FILE) then
			local d = HttpService:JSONDecode(readfile(LIFE_FILE))
			for k in pairs(Y.life) do if type(d[k]) == "number" then Y.life[k] = d[k] end end
			Y.life.sessions = (d.sessions or 0) + 1
		end
	end)
	local last = {beli = 0, lvls = 0, kills = 0}
	local function saveLife() pcall(function() writefile(LIFE_FILE, HttpService:JSONEncode(Y.life)) end) end
	G.loop(30, function()
		local gb, gl, gk = G.gain("Beli"), G.gain("Level"), Y.kills
		Y.life.secs = Y.life.secs + 30
		Y.life.beli = Y.life.beli + math.max(0, gb - last.beli)
		Y.life.lvls = Y.life.lvls + math.max(0, gl - last.lvls)
		Y.life.kills = Y.life.kills + math.max(0, gk - last.kills)
		last.beli, last.lvls, last.kills = gb, gl, gk
		saveLife()
	end)
	gui.Destroying:Connect(saveLife)
end)()

------------------------------------------------------------------
-- BLOCO D: chat log, macros
------------------------------------------------------------------
;(function()
	if not (G and G.Y) then return end
	local Y = G.Y
	Y.chat = {}
	local lastKey, lastT = "", 0
	local function addChat(name, msg)
		if not State.ChatLog then return end
		msg = tostring(msg):gsub("<[^>]+>", "")
		local key = name .. msg
		if key == lastKey and tick() - lastT < 1.5 then return end
		lastKey, lastT = key, tick()
		table.insert(Y.chat, 1, os.date("%H:%M") .. "  " .. name .. ": " .. msg)
		if #Y.chat > 40 then table.remove(Y.chat) end
		local low, hit = msg:lower(), false
		if State.ChatAlert then
			for k in tostring(State.ChatKeys):gmatch("[^,]+") do
				k = k:match("^%s*(.-)%s*$"):lower()
				if k ~= "" and low:find(k, 1, true) then hit = true break end
			end
		end
		if State.ChatMine and name ~= lp.DisplayName then
			if low:find(lp.Name:lower(), 1, true) or low:find(lp.DisplayName:lower(), 1, true) then hit = true end
		end
		if hit then
			notify("💬 " .. name, msg, 4)
			if State.SoundAlert then Y.ping() end
		end
	end
	pcall(function()
		local TCS = game:GetService("TextChatService")
		conn(TCS.MessageReceived:Connect(function(m)
			local src = m.TextSource
			local who = src and Players:GetPlayerByUserId(src.UserId)
			addChat(who and who.DisplayName or "sistema", m.Text or "")
		end))
	end)
	local function hook(p) conn(p.Chatted:Connect(function(msg) addChat(p.DisplayName, msg) end)) end
	for _, p in ipairs(Players:GetPlayers()) do hook(p) end
	conn(Players.PlayerAdded:Connect(hook))

	-- gravador de macros (teclado)
	local rec = {on = false, t0 = 0, list = {}, downs = {}}
	Y.macroRec = function()
		if rec.on then return end
		rec.on, rec.t0, rec.list, rec.downs = true, tick(), {}, {}
		notify("Macro", "Gravando teclas...", 2)
	end
	Y.macroStopRec = function()
		if not rec.on then return end
		rec.on = false
		State.Macro = rec.list
		notify("Macro", #rec.list .. " eventos gravados.", 2.5)
	end
	conn(UIS.InputBegan:Connect(function(i, gp)
		if not rec.on or gp or i.UserInputType ~= Enum.UserInputType.Keyboard or #rec.list >= 600 then return end
		rec.downs[i.KeyCode.Name] = true
		table.insert(rec.list, {t = tick() - rec.t0, k = i.KeyCode.Name})
	end))
	conn(UIS.InputEnded:Connect(function(i)
		if not rec.on or i.UserInputType ~= Enum.UserInputType.Keyboard or #rec.list >= 600 then return end
		if rec.downs[i.KeyCode.Name] then
			rec.downs[i.KeyCode.Name] = nil
			table.insert(rec.list, {t = tick() - rec.t0, k = i.KeyCode.Name, up = true})
		end
	end))
	Y.playing, Y.stopPlay = false, false
	Y.macroPlay = function()
		if Y.playing then return end
		local list = State.Macro
		if #list == 0 then notify("Macro", "Nenhuma macro gravada.", 2) return end
		Y.playing, Y.stopPlay = true, false
		task.spawn(function()
			repeat
				local t0 = tick()
				for _, e in ipairs(list) do
					if not alive or Y.stopPlay then break end
					local w = e.t / (State.MacroSpeed / 100) - (tick() - t0)
					if w > 0 then task.wait(w) end
					local ok, kc = pcall(function() return Enum.KeyCode[e.k] end)
					if ok and kc then pcall(function() VIM:SendKeyEvent(not e.up, kc, false, game) end) end
				end
			until not State.MacroLoop or Y.stopPlay or not alive
			Y.playing, Y.stopPlay = false, false
		end)
	end
	Y.macroStopPlay = function() Y.stopPlay = true end
	Y.macroState = function()
		if rec.on then return "gravando (" .. #rec.list .. ")" end
		if Y.playing then return "reproduzindo" end
		return "parado"
	end
end)()

------------------------------------------------------------------
-- BLOCO E: auto performance + pânico
------------------------------------------------------------------
;(function()
	if not (G and G.Y) then return end
	local Y, V = G.Y, G.V
	local low, level = 0, 0
	G.loop(1, function()
		if not State.AutoPerf then low = 0 return end
		if fps > 0 and fps < State.PerfMin then low = low + 1 else low = 0 end
		if low >= 6 and level < 3 then
			low = 0
			level = level + 1
			if not Y.perfSnap then
				Y.perfSnap = {PCount = State.PCount, AnimGlow = State.AnimGlow, PartOn = State.PartOn, FilterOn = State.FilterOn,
					TouchFX = State.TouchFX, EspTracer = State.EspTracer, RadarOn = State.RadarOn}
			end
			if level == 1 then
				State.PCount = math.max(5, math.floor(State.PCount / 2)); State.AnimGlow = false; scheduleParts()
			elseif level == 2 then
				State.PartOn, State.FilterOn, State.TouchFX, State.EspTracer = false, false, false, false
				scheduleParts(); V.applyFilters()
			else
				G.boostFPS()
			end
			syncAll()
			notify("Auto Performance", "FPS baixo (" .. fps .. "). Nível " .. level .. "/3 aplicado.", 3)
		end
	end)
	Y.perfRestore = function()
		local s = Y.perfSnap
		if not s then notify("Performance", "Nada para restaurar.", 2) return end
		for k, v in pairs(s) do State[k] = v end
		Y.perfSnap, level = nil, 0
		scheduleParts(); V.applyFilters(); V.applyRadar(); applyAppearance(); syncAll()
		notify("Performance", "Efeitos restaurados.", 2)
	end

	-- pânico
	pcall(function() local o = parent:FindFirstChild("AppleHubPanic") if o then o:Destroy() end end)
	local pgui = new("ScreenGui", {Name = "AppleHubPanic", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
	pgui.Parent = parent
	local pb = new("TextButton", {Size = UDim2.fromOffset(30, 30), Position = UDim2.new(0, 8, 1, -46), BackgroundColor3 = Color3.fromRGB(30, 30, 38), BackgroundTransparency = 0.55,
		Text = "⏻", TextSize = 15, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, AutoButtonColor = false, Visible = State.PanicBtn, Parent = pgui}, {corner(15)})
	local pst = drag(pb, pb)
	Y.hidden = false
	local skip = {Compact = true, GoalOn = true, ChatLog = true, AutoPerf = true, SoundAlert = true}
	Y.panic = function()
		if Y.hidden then
			gui.Enabled = true
			Y.hidden = false
			return
		end
		if State.PanicOff then
			State.BlackScreen = false
			for _, f in ipairs(G.Feats) do
				if not skip[f[2]] and type(State[f[2]]) == "boolean" and State[f[2]] then
					State[f[2]] = false
					if G.after[f[2]] then pcall(G.after[f[2]], false) end
				end
			end
			pcall(function() G.Z.musicStop() end)
			syncAll()
		end
		pcall(function() blur.Size = 0 end)
		if State.PanicUnload then
			pcall(function() if getgenv and getgenv().AppleHubUnload then getgenv().AppleHubUnload() end end)
			return
		end
		gui.Enabled = false
		Y.hidden = true
	end
	pb.MouseButton1Click:Connect(function() if not pst.moved then Y.panic() end end)
	Y.applyPanicBtn = function() pb.Visible = State.PanicBtn end
	conn(UIS.InputBegan:Connect(function(i, gp)
		if gp or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if i.KeyCode.Name == State.PanicKey then Y.panic() end
	end))
	gui.Destroying:Connect(function() pcall(function() pgui:Destroy() end) end)
end)()

------------------------------------------------------------------
-- BLOCO F: páginas novas
------------------------------------------------------------------
;(function()
	if not (G and G.Y) then return end
	local Y, Z, V = G.Y, G.Z, G.V
	local commas = G.commas
	local white = Color3.new(1, 1, 1)
	local function newPage(name, icon)
		Y.pages[name] = true
		Z.pages[name] = true
		return addPage(name, icon)
	end
	local function listBox(page)
		local b = new("Frame", {Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = page},
			{new("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})})
		regSearch(b, "", true)
		return b
	end
	local function Progress(page, title, getCur, getMax)
		local r = row(page, 52)
		regSearch(r, title)
		local tl = mkText({Size = UDim2.new(1, -24, 0, 20), Position = UDim2.fromOffset(12, 4), Text = title, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}, true)
		local bar = new("Frame", {Size = UDim2.new(1, -24, 0, 8), Position = UDim2.fromOffset(12, 32), BackgroundColor3 = T.sub, Parent = r}, {corner(4)})
		bind(bar, "BackgroundColor3", offColor)
		local fill = new("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = white, Parent = bar}, {corner(4)})
		bind(new("UIGradient", {Parent = fill}), "Color", gradSeq, true)
		table.insert(Y.progress, {tl = tl, fill = fill, title = title, cur = getCur, max = getMax})
	end

	------------------------------------------------ INÍCIO
	local pHome = newPage("Início", "⌂")
	Section(pHome, "Resumo")
	InfoRow(pHome, "Level", function() local v = G.dataVal("Level") return v and commas(v) or "—" end)
	InfoRow(pHome, "Beli", function() local v = G.dataVal("Beli") return v and commas(v) or "—" end)
	InfoRow(pHome, "Beli por hora", function() return G.rate("Beli") end)
	InfoRow(pHome, "Kills (sessão)", function() return commas(Y.kills) end)
	InfoRow(pHome, "Funções ligadas", function()
		local n = 0
		for _, f in ipairs(G.Feats) do if State[f[2]] == true then n = n + 1 end end
		return tostring(n)
	end)
	InfoRow(pHome, "Tempo de sessão", function() return Z.fmtClock(tick() - startTick) end)
	Section(pHome, "Atalhos rápidos (toque para ligar/desligar)")
	local quick = {"Auto Level", "Auto Farm", "Auto Boss", "Auto Baús", "Auto Frutas", "Bring Mobs", "Modo Seguro", "Auto Skills", "Voar", "Noclip",
		"ESP Jogadores", "Radar", "Modo Furtivo", "Fruit Sniper", "Tela Preta", "HUD"}
	local grid = Grid(pHome, 134, 38)
	local qbtns = {}
	for _, name in ipairs(quick) do
		local key = G.FeatMap[name]
		if key then
			local b = new("TextButton", {BackgroundColor3 = T.row, Text = name, TextSize = 12, TextColor3 = T.text, AutoButtonColor = false, Parent = grid}, {rc(11)})
			regFont(b, true)
			b.MouseButton1Click:Connect(function()
				uiSound()
				State[key] = not State[key]
				if G.after[key] then pcall(G.after[key], State[key]) end
				syncAll()
			end)
			table.insert(qbtns, {b, key})
		end
	end
	G.loop(0.3, function()
		for _, e in ipairs(qbtns) do
			local on = State[e[2]]
			e[1].BackgroundColor3 = on and T.accent or T.row
			e[1].TextColor3 = on and white or T.text
		end
	end)
	Section(pHome, "Ações")
	Button(pHome, "⏻ PÂNICO (esconde tudo e desliga as funções)", function() Y.panic() end)
	Button(pHome, "Trocar de servidor", function() G.serverHop() end)
	Button(pHome, "Abrir paleta de comandos", function() Z.openPalette() end)
	Section(pHome, "Total geral (todas as sessões)")
	InfoRow(pHome, "Sessões", function() return commas(Y.life.sessions) end)
	InfoRow(pHome, "Tempo total", function() return Z.fmtClock(Y.life.secs) end)
	InfoRow(pHome, "Beli total ganho", function() return commas(Y.life.beli) end)
	InfoRow(pHome, "Levels totais", function() return commas(Y.life.lvls) end)
	InfoRow(pHome, "Kills totais", function() return commas(Y.life.kills) end)

	------------------------------------------------ ALVO & METAS
	local pGoal = newPage("Metas", "◎")
	Section(pGoal, "Target HUD")
	Toggle(pGoal, "Mostrar alvo atual (arrastável)", "TargetHud")
	Slider(pGoal, "Tamanho", 60, 160, "THScale", function() Y.applyTH() end, "%")
	Slider(pGoal, "Transparência", 0, 90, "THAlpha", function() Y.applyTH() end, "%")
	Section(pGoal, "Kills")
	InfoRow(pGoal, "Kills (sessão)", function() return commas(Y.kills) end)
	InfoRow(pGoal, "Kills por hora", function()
		local el = tick() - startTick
		return el < 20 and "—" or commas(Y.kills / (el / 3600))
	end)
	Button(pGoal, "Zerar kills", function() Y.kills = 0 end)
	Section(pGoal, "Metas da sessão")
	Toggle(pGoal, "Avisar ao atingir (notificação + webhook)", "GoalOn")
	Input(pGoal, "Meta de level", "ex: 2550 e Enter", function(t)
		local n = tonumber(t)
		if n then State.GoalLevel = math.clamp(math.floor(n), 1, 2550) end
	end)
	Input(pGoal, "Meta de Beli (ganho)", "ex: 1000000 e Enter", function(t)
		local n = tonumber(t)
		if n and n > 0 then State.GoalBeli = math.floor(n) end
	end)
	Input(pGoal, "Meta de kills", "ex: 500 e Enter", function(t)
		local n = tonumber(t)
		if n and n > 0 then State.GoalKills = math.floor(n) end
	end)
	Progress(pGoal, "Level", function() return G.dataVal("Level") or 0 end, function() return State.GoalLevel end)
	Progress(pGoal, "Beli ganho", function() return math.max(0, G.gain("Beli")) end, function() return State.GoalBeli end)
	Progress(pGoal, "Kills", function() return Y.kills end, function() return State.GoalKills end)
	Button(pGoal, "Reiniciar avisos de meta", function() Y.goalDone = {}; notify("Metas", "Avisos reiniciados.", 2) end)

	------------------------------------------------ CHAT
	local pChat = newPage("Chat", "✎")
	Section(pChat, "Chat Log (só leitura)")
	Toggle(pChat, "Registrar mensagens do chat", "ChatLog")
	Toggle(pChat, "Alertar por palavra-chave", "ChatAlert")
	Toggle(pChat, "Alertar quando disserem meu nome", "ChatMine")
	Input(pChat, "Palavras-chave", "ex: fruit,trade e Enter", function(t) State.ChatKeys = t; notify("Chat", "Palavras: " .. t, 2) end)
	InfoRow(pChat, "Palavras atuais", function() return State.ChatKeys end)
	local chatLabel = Label(pChat, "Nenhuma mensagem ainda. Ligue o Chat Log.")
	G.loop(1, function()
		if #Y.chat > 0 then chatLabel.Text = table.concat(Y.chat, "\n", 1, math.min(#Y.chat, 14)) end
	end)
	Button(pChat, "Limpar log", function() Y.chat = {}; chatLabel.Text = "Nenhuma mensagem ainda." end)
	Button(pChat, "Copiar log", function()
		pcall(function() setclipboard(table.concat(Y.chat, "\n")) end)
		notify("Chat", "Log copiado.", 2)
	end)

	------------------------------------------------ MACRO
	local pMac = newPage("Macro", "⏺")
	Section(pMac, "Gravador de macros (teclado — PC)")
	Label(pMac, "Grave uma sequência de teclas e reproduza depois. No celular, use o Combo da aba Ferramentas.")
	Button(pMac, "● Gravar", function() Y.macroRec() end)
	Button(pMac, "■ Parar gravação", function() Y.macroStopRec() end)
	Button(pMac, "▶ Reproduzir", function() Y.macroPlay() end)
	Button(pMac, "■ Parar reprodução", function() Y.macroStopPlay() end)
	Toggle(pMac, "Repetir sem parar", "MacroLoop")
	Slider(pMac, "Velocidade", 25, 300, "MacroSpeed", nil, "%")
	InfoRow(pMac, "Estado", function() return Y.macroState() end)
	InfoRow(pMac, "Eventos gravados", function() return tostring(#State.Macro) end)
	Button(pMac, "Copiar macro", function()
		pcall(function() setclipboard(HttpService:JSONEncode(State.Macro)) end)
		notify("Macro", "Macro copiada.", 2)
	end)
	Input(pMac, "Importar macro", "cole o texto e Enter", function(t)
		local ok, d = pcall(function() return HttpService:JSONDecode(t) end)
		if ok and type(d) == "table" then State.Macro = d; notify("Macro", "Importada: " .. #d .. " eventos.", 2.5)
		else notify("Macro", "Texto inválido.", 2) end
	end)
	Button(pMac, "Apagar macro", function() State.Macro = {}; notify("Macro", "Apagada.", 2) end)

	------------------------------------------------ EDITOR DE TEMA
	local pEd = newPage("Editor", "✐")
	Section(pEd, "Editor de tema (cores em hex)")
	Label(pEd, "Edite as cores do tema Custom, ex: #1e90ff. Ficam salvas junto com a config. Obs: com cores hex definidas, os sliders de cor personalizada não mudam mais o destaque (use \"Limpar\").")
	local hexKeys = {{"Fundo", "bg"}, {"Barra lateral", "side"}, {"Cards", "row"}, {"Texto", "text"}, {"Texto fraco", "sub"}, {"Destaque 1", "accent"}, {"Destaque 2", "accent2"}}
	local function setHex(key, t)
		t = t:gsub("%s", "")
		if not t:match("^#?%x%x%x%x%x%x$") then notify("Tema", "Use o formato #RRGGBB", 2) return end
		if t:sub(1, 1) ~= "#" then t = "#" .. t end
		State.CustomHex[key] = t
		Themes.Custom[key] = Color3.fromHex(t)
		applyTheme("Custom")
	end
	Button(pEd, "Começar a partir do tema atual", function()
		for k, v in pairs(T) do
			Themes.Custom[k] = v
			State.CustomHex[k] = "#" .. v:ToHex()
		end
		applyTheme("Custom")
		notify("Editor", "Tema atual copiado para o Custom.", 2)
	end)
	for _, e in ipairs(hexKeys) do
		Input(pEd, e[1], "#RRGGBB e Enter", function(t) setHex(e[2], t) end)
		InfoRow(pEd, e[1] .. " (atual)", function()
			local c = Themes.Custom[e[2]]
			return c and ("#" .. c:ToHex()) or "—"
		end)
	end
	Button(pEd, "Aplicar tema Custom", function() Y.applyCustomHex(); applyTheme("Custom") end)
	Button(pEd, "Copiar tema (hex)", function()
		pcall(function() setclipboard(HttpService:JSONEncode(State.CustomHex)) end)
		notify("Editor", "Tema copiado.", 2)
	end)
	Input(pEd, "Importar tema", "cole o texto e Enter", function(t)
		local ok, d = pcall(function() return HttpService:JSONDecode(t) end)
		if not (ok and type(d) == "table") then notify("Editor", "Texto inválido.", 2) return end
		for _, e in ipairs(hexKeys) do
			local h = d[e[2]]
			if type(h) == "string" and h:match("^#%x%x%x%x%x%x$") then State.CustomHex[e[2]] = h; Themes.Custom[e[2]] = Color3.fromHex(h) end
		end
		applyTheme("Custom")
		notify("Editor", "Tema importado.", 2)
	end)
	Button(pEd, "Limpar cores hex", function() State.CustomHex = {}; notify("Editor", "Cores hex removidas (reabra o Custom).", 2.5) end)

	------------------------------------------------ SNAKE
	local pSn = newPage("Snake", "❖")
	Section(pSn, "Mini-jogo para o AFK")
	local sl = Label(pSn, "Pontos: 0   Recorde: " .. State.SnakeHi)
	local N, CS = 13, 18
	local board = row(pSn, N * CS + 20)
	local holder = new("Frame", {Size = UDim2.fromOffset(N * CS, N * CS), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, Parent = board})
	local cells = {}
	for y = 1, N do
		cells[y] = {}
		for x = 1, N do
			cells[y][x] = new("Frame", {Size = UDim2.fromOffset(CS - 2, CS - 2), Position = UDim2.fromOffset((x - 1) * CS, (y - 1) * CS), BackgroundColor3 = T.row, BorderSizePixel = 0, Parent = holder}, {corner(4)})
		end
	end
	local snake, dir, ndir, food, score, running = {{7, 7}, {6, 7}, {5, 7}}, {1, 0}, {1, 0}, {10, 7}, 0, false
	local function spawnFood()
		local occ, free = {}, {}
		for _, s in ipairs(snake) do occ[s[2] * 100 + s[1]] = true end
		for y = 1, N do for x = 1, N do if not occ[y * 100 + x] then table.insert(free, {x, y}) end end end
		food = free[math.random(#free)] or {1, 1}
	end
	local function draw()
		for y = 1, N do for x = 1, N do cells[y][x].BackgroundColor3 = T.row end end
		cells[food[2]][food[1]].BackgroundColor3 = Color3.fromRGB(255, 85, 85)
		for i, s in ipairs(snake) do cells[s[2]][s[1]].BackgroundColor3 = (i == 1) and T.accent2 or T.accent end
		sl.Text = "Pontos: " .. score .. "   Recorde: " .. State.SnakeHi
	end
	local function reset()
		snake = {{7, 7}, {6, 7}, {5, 7}}
		dir, ndir, score, running = {1, 0}, {1, 0}, 0, true
		spawnFood()
		draw()
	end
	local function setDir(dx, dy) if dx ~= -dir[1] or dy ~= -dir[2] then ndir = {dx, dy} end end
	local function step()
		dir = ndir
		local h = snake[1]
		local nx, ny = (h[1] - 1 + dir[1]) % N + 1, (h[2] - 1 + dir[2]) % N + 1
		local eat = (nx == food[1] and ny == food[2])
		for i = 1, #snake - (eat and 0 or 1) do
			if snake[i][1] == nx and snake[i][2] == ny then
				running = false
				notify("Snake", "Fim de jogo! Pontos: " .. score, 2.5)
				draw()
				return
			end
		end
		table.insert(snake, 1, {nx, ny})
		if eat then
			score = score + 10
			if score > State.SnakeHi then State.SnakeHi = score end
			spawnFood()
		else
			table.remove(snake)
		end
		draw()
	end
	draw()
	local pad = row(pSn, 100)
	local function pbtn(txt, x, y, dx, dy)
		local b = mkText({Size = UDim2.fromOffset(46, 38), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, x, 0.5, y), Text = txt, TextSize = 18, AutoButtonColor = false, Parent = pad}, true, false, "TextButton")
		b.BackgroundTransparency = 0
		b.BackgroundColor3 = T.accent
		b.TextColor3 = white
		new("UICorner", {CornerRadius = UDim.new(0, 10), Parent = b})
		b.MouseButton1Click:Connect(function() setDir(dx, dy) end)
	end
	pbtn("▲", 0, -26, 0, -1)
	pbtn("▼", 0, 26, 0, 1)
	pbtn("◀", -52, 0, -1, 0)
	pbtn("▶", 52, 0, 1, 0)
	Button(pSn, "▶ Novo jogo", reset)
	Label(pSn, "No PC também funcionam as setas ou WASD enquanto esta aba estiver aberta.")
	task.spawn(function()
		while alive do
			task.wait(0.15)
			if running and shown and pSn.Parent and pSn.Parent.Visible then pcall(step) end
		end
	end)
	conn(UIS.InputBegan:Connect(function(i, gp)
		if gp or not running or not (pSn.Parent and pSn.Parent.Visible) then return end
		local k = i.KeyCode
		if k == Enum.KeyCode.Up or k == Enum.KeyCode.W then setDir(0, -1)
		elseif k == Enum.KeyCode.Down or k == Enum.KeyCode.S then setDir(0, 1)
		elseif k == Enum.KeyCode.Left or k == Enum.KeyCode.A then setDir(-1, 0)
		elseif k == Enum.KeyCode.Right or k == Enum.KeyCode.D then setDir(1, 0) end
	end))

	------------------------------------------------ AJUSTES v30
	local pSet = newPage("v30", "✧")
	Section(pSet, "Layout")
	Dropdown(pSet, "Abrir na aba", {"Início", "Farm", "Blox", "Mapa", "Comandos", "Automação", "Ferramentas", "Monitor", "Estilo"}, "StartTab")
	Toggle(pSet, "Modo compacto (só ícones nas abas)", "Compact", function() Y.applyCompact() end)
	Dropdown(pSet, "Título animado", {"Nenhuma", "Arco-íris", "Pulso"}, "TitleAnim", function(v)
		if v == "Nenhuma" then titleLabel.TextColor3 = T.sub end
	end)
	Section(pSet, "Auto Performance")
	Label(pSet, "Se o FPS ficar baixo por 6 segundos, reduz efeitos em até 3 níveis (partículas, filtros, otimização do mapa).")
	Toggle(pSet, "Reduzir efeitos automaticamente", "AutoPerf")
	Slider(pSet, "FPS mínimo aceitável", 10, 60, "PerfMin", nil, " fps")
	Button(pSet, "Restaurar efeitos", function() Y.perfRestore() end)
	Section(pSet, "Pânico")
	Label(pSet, "Esconde todo o hub na hora e desliga as funções. Toque de novo (ou a tecla) para voltar.")
	Input(pSet, "Tecla de pânico", "ex: End e Enter", function(t)
		local k = t:gsub("%s", "")
		local ok, kc = pcall(function() return Enum.KeyCode[k] end)
		if ok and kc then State.PanicKey = k; notify("Pânico", "Tecla: " .. k, 2) else notify("Pânico", "Tecla inválida.", 2) end
	end)
	InfoRow(pSet, "Tecla atual", function() return State.PanicKey end)
	Toggle(pSet, "Desligar todas as funções ao acionar", "PanicOff")
	Toggle(pSet, "Descarregar o hub por completo", "PanicUnload")
	Toggle(pSet, "Mostrar botão ⏻ na tela (arrastável)", "PanicBtn", function() Y.applyPanicBtn() end)
	Section(pSet, "Alertas sonoros")
	Toggle(pSet, "Tocar som nos alertas", "SoundAlert")
	Toggle(pSet, "Fruta spawnou", "SoundFruit")
	Toggle(pSet, "Boss apareceu", "SoundBoss")
	Slider(pSet, "Volume do alerta", 5, 100, "AlertVol", nil, "%")
	Button(pSet, "Testar som", function() Y.ping() end)
	Label(pSet, "Dica: use Ctrl+K (paleta) ou o console: panic, compact, kills, macro rec/stop/play.")

	-- comandos novos no console
	local oldRun = V.run
	V.run = function(text)
		local cmd, rest = tostring(text):match("^%s*(%S+)%s*(.*)$")
		if not cmd then return end
		local c, say = cmd:lower(), V.say
		local mine = {panic = true, compact = true, kills = true, macro = true}
		if not mine[c] then return oldRun(text) end
		say("> " .. text)
		if c == "panic" then Y.panic()
		elseif c == "compact" then State.Compact = not State.Compact; Y.applyCompact(); say("compacto: " .. tostring(State.Compact))
		elseif c == "kills" then say("kills: " .. Y.kills)
		elseif c == "macro" then
			local a = rest:lower()
			if a == "rec" then Y.macroRec()
			elseif a == "stop" then Y.macroStopRec(); Y.macroStopPlay()
			elseif a == "play" then Y.macroPlay()
			elseif a == "clear" then State.Macro = {}
			else say("uso: macro rec | stop | play | clear") end
		end
	end

	-- aplicar tudo ao abrir
	Y.applyTH()
	Y.applyPanicBtn()
	layoutTabs()
	if State.StartTab ~= "Farm" then pcall(switchTab, State.StartTab) end
	notify("Apple Hub v30", "Novo: Início, Metas, Chat, Macro, Editor, Snake e Pânico!", 4)
end)()
