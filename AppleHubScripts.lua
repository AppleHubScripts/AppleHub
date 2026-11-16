-- Apple Panel v5 (Luau) | Delta mobile/PC
-- Intro customizável, botões customizáveis, abas customizáveis, partículas avançadas,
-- presets de estilo completos, auroras animadas, bolha com pulso, efeitos de câmera e mais.

local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TPS = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local CS = game:GetService("CollectionService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local startTick, startBeli = tick(), nil

local parent = (gethui and gethui()) or game:GetService("CoreGui")
for _, n in ipairs({ "ApplePanel", "ApplePanelIntro" }) do
	pcall(function() local o = parent:FindFirstChild(n) if o then o:Destroy() end end)
end
for _, n in ipairs({ "ApplePanelBlur", "ApplePanelIntroBlur", "ApplePanelCC", "ApplePanelBloom" }) do
	pcall(function() local o = Lighting:FindFirstChild(n) if o then o:Destroy() end end)
end

---------------------------------------------------------------- TEMAS
local function th(bg, side, row, text, sub, a1, a2)
	local f = Color3.fromHex
	return { bg = f(bg), side = f(side), row = f(row), text = f(text), sub = f(sub), a1 = f(a1), a2 = f(a2) }
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
	Matrix = th("#020a04", "#06150a", "#0c2614", "#d6ffe0", "#5fa575", "#00ff6a", "#00b34a"),
	Galaxy = th("#070514", "#0e0a26", "#1a1440", "#efeaff", "#8f86c4", "#9d4edd", "#3a86ff"),
	AMOLED = th("#000000", "#0a0a0a", "#161616", "#ffffff", "#8a8a8a", "#0a84ff", "#64d2ff"),
	Cyber = th("#0d0221", "#170338", "#261047", "#f0e6ff", "#9a86c9", "#ff2a6d", "#05d9e8"),
	Lava = th("#1a0a05", "#2a0f07", "#40170b", "#fff0e6", "#c28a70", "#ff4500", "#ffb300"),
}
Themes.Custom = {}
for k, v in pairs(Themes.Midnight) do Themes.Custom[k] = v end
local ThemeNames = { "Midnight", "Ocean", "Sunset", "Aurora", "Sakura", "Gold", "Graphite", "Claro", "Dracula", "Matrix", "Galaxy", "AMOLED", "Cyber", "Lava", "Custom" }

---------------------------------------------------------------- ESTADO + CONFIG
local S = {
	Theme = "Midnight", Opacity = 6, Corner = 16, Glow = 12, GlowSpin = false, Rainbow = false, Borders = true,
	Blur = false, BlurSize = 14, Transition = "Deslizar", Easing = "Quint", TransTime = 400, Font = "Gotham",
	Title = "Apple Panel", Key = "RightShift", AutoRejoin = false, W = 540, H = 340, Shine = true,
	BorderGlow = false, BorderSpin = true, Notifs = true, ShowFPS = true, PlayerAlerts = false, Aurora = false,
	-- partículas
	PEnabled = true, PType = "Neve", PCount = 35, PSpeed = 50, PSize = 50, PWind = 0, PAlpha = 25, PColor = "Automática",
	PSpin = true, PFront = false, PInvert = false, PSway = 100, PGlyph = "✦", PR = 255, PG = 255, PB = 255,
	-- botões
	BtnStyle = "Gradiente", BtnH = 40, BtnCorner = 13, BtnText = 13, BtnRipple = true,
	-- abas
	TabStyle = "Pílula", TabH = 32, TabText = 13, TabIcons = true, TabAlign = "Esquerda", SideW = 128,
	-- bolha
	BubbleSize = 52, BubbleChar = "A", BubblePulse = true,
	-- intro
	IntroOn = true, IntroStyle = "Cinema", IntroTitle = "APPLE HUB", IntroSub = "Blox Fruits Edition", IntroLogo = "A",
	IntroTime = 4, IntroRings = 3, IntroBurst = 40, IntroBlur = true, IntroBG = 92, IntroRainbow = false, IntroBar = true, IntroSkip = true,
	-- waypoints
	WP1 = "", WP2 = "", WP3 = "", WPSlot = "1",
}
local CFG = "ApplePanel_v5.json"
pcall(function()
	if isfile and isfile(CFG) then
		local d = HttpService:JSONDecode(readfile(CFG))
		for k, v in pairs(d) do
			if k ~= "Custom" and (k == "Scale" or type(S[k]) == type(v)) then S[k] = v end
		end
		if type(d.Custom) == "table" then
			for k, v in pairs(d.Custom) do pcall(function() Themes.Custom[k] = Color3.fromHex(v) end) end
		end
	end
end)
if not S.Scale then
	local vp = cam.ViewportSize
	S.Scale = math.clamp(math.floor(math.min(vp.X / (S.W + 40), vp.Y / (S.H + 40)) * 100), 55, 100)
end
local T = Themes[S.Theme] or Themes.Midnight
local WHITE = Color3.new(1, 1, 1)

---------------------------------------------------------------- HELPERS
local conns, alive, shown = {}, true, true
local function conn(c) table.insert(conns, c) return c end
local function new(class, props, par)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	if par then o.Parent = par end
	return o
end
local function round(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local corners = {}
local function rc(o, base)
	local c = new("UICorner", { CornerRadius = UDim.new(0, math.floor(base * S.Corner / 16 + 0.5)) }, o)
	table.insert(corners, { c, base })
	return c
end
local function setCorners()
	for _, e in ipairs(corners) do pcall(function() e[1].CornerRadius = UDim.new(0, math.floor(e[2] * S.Corner / 16 + 0.5)) end) end
end
local function tw(o, t, p, style)
	pcall(function() TS:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p):Play() end)
end
local function ease()
	local ok, e = pcall(function() return Enum.EasingStyle[S.Easing] end)
	return (ok and e) or Enum.EasingStyle.Quint
end
local function isPress(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end
local function isMove(i) return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch end

local binders, fast = {}, {}
local function bind(obj, prop, fn, isFast)
	local function f(d)
		local v = fn()
		if d and d > 0 and typeof(v) ~= "ColorSequence" then tw(obj, d, { [prop] = v })
		else pcall(function() obj[prop] = v end) end
	end
	table.insert(binders, f)
	if isFast then table.insert(fast, f) end
	f(0)
	return f
end
local themeStrokes = {}
local function applyTheme(n)
	if not Themes[n] then return end
	T, S.Theme = Themes[n], n
	for _, f in ipairs(binders) do f(0.35) end
	for k, s in pairs(themeStrokes) do s.Enabled = (k == n) end
end
local function grad(o)
	local g = new("UIGradient", {}, o)
	bind(g, "Color", function() return ColorSequence.new(T.a1, T.a2) end, true)
	return g
end
local strokes = {}
local function glass(o, tr)
	local s = new("UIStroke", { Thickness = 1, Transparency = tr or 0.9, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = S.Borders }, o)
	bind(s, "Color", function() return T.text end)
	table.insert(strokes, s)
	return s
end

local FontList = { "Gotham", "SourceSans", "Arial", "Roboto", "Ubuntu", "Nunito", "Oswald", "Jura", "FredokaOne", "Merriweather", "Code", "SciFi", "Arcade", "Cartoon" }
local BoldMap = { Gotham = "GothamBold", SourceSans = "SourceSansBold", Arial = "ArialBold" }
local function getFont(n, bold)
	local ok, f = pcall(function() return Enum.Font[(bold and BoldMap[n]) or n] end)
	return (ok and f) or Enum.Font.Gotham
end
local fontObjs = {}
local function setFont(n)
	S.Font = n
	for _, e in ipairs(fontObjs) do pcall(function() e[1].Font = getFont(n, e[2]) end) end
end
local function txt(p, bold, key)
	local cls = p.Class
	p.Class = nil
	p.BackgroundTransparency = 1
	local o = new(cls or "TextLabel", p)
	o.Font = getFont(S.Font, bold)
	table.insert(fontObjs, { o, bold })
	if key ~= false then bind(o, "TextColor3", function() return T[key or "text"] end, key == "a1") end
	return o
end

local reg = {} -- setters de controles ligados ao estado (usado pelos presets)

---------------------------------------------------------------- JANELA
local gui = new("ScreenGui", { Name = "ApplePanel", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, parent)
local main = new("CanvasGroup", {
	Size = UDim2.fromOffset(S.W, S.H), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
	BackgroundTransparency = S.Opacity / 100, BorderSizePixel = 0, GroupTransparency = 1,
}, gui)
rc(main, 22)
bind(main, "BackgroundColor3", function() return T.bg end)
glass(main, 0.82)
local uscale = new("UIScale", { Scale = S.Scale / 100 * 0.88 }, main)

local bStroke = new("UIStroke", { Thickness = 2, Color = WHITE, Transparency = 0.1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = S.BorderGlow }, main)
local bG = new("UIGradient", {}, bStroke)
bind(bG, "Color", function()
	return ColorSequence.new({ ColorSequenceKeypoint.new(0, T.a1), ColorSequenceKeypoint.new(0.5, T.a2), ColorSequenceKeypoint.new(1, T.a1) })
end, true)

local glow = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BackgroundTransparency = 1 - S.Glow / 100, BorderSizePixel = 0, ZIndex = 0 }, main)
local glowG = grad(glow)
glowG.Rotation = 35

-- auroras animadas
local aur = {}
for i = 1, 3 do
	local f = new("Frame", { Size = UDim2.fromOffset(250, 250), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 0.86, BorderSizePixel = 0, ZIndex = 0, Visible = S.Aurora }, main)
	round(f, 125)
	bind(f, "BackgroundColor3", function() return (i == 2) and T.a2 or T.a1 end, true)
	aur[i] = f
end
conn(RS.Heartbeat:Connect(function()
	if not (S.Aurora and shown) then return end
	local t = os.clock()
	for i, f in ipairs(aur) do
		f.Position = UDim2.new(0.5 + 0.38 * math.sin(t * 0.35 + i * 2.1), 0, 0.5 + 0.32 * math.cos(t * 0.3 + i * 1.7), 0)
		f.BackgroundTransparency = 0.84 + 0.05 * math.sin(t * 0.8 + i)
	end
end))

local pLayer = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = S.PFront and 9 or 1, ClipsDescendants = true }, main)

local shine = new("Frame", { Size = UDim2.new(1, 0, 0, 130), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 1, Visible = S.Shine }, main)
new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.88), NumberSequenceKeypoint.new(1, 1) }) }, shine)
bind(shine, "BackgroundColor3", function() return T.a1:Lerp(WHITE, 0.45) end, true)

local topLine = new("Frame", { Size = UDim2.new(1, 0, 0, 3), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 5 }, main)
grad(topLine)

local blur = new("BlurEffect", { Name = "ApplePanelBlur", Size = 0 }, Lighting)
local function updateBlur() tw(blur, 0.4, { Size = (S.Blur and shown) and S.BlurSize or 0 }) end
local function showMain()
	shown = true; main.Visible = true
	tw(main, 0.4, { GroupTransparency = 0 })
	tw(uscale, 0.5, { Scale = S.Scale / 100 }, Enum.EasingStyle.Back)
	updateBlur()
end

-- notificações
local nHolder = new("Frame", { Size = UDim2.new(0, 250, 1, -20), Position = UDim2.new(1, -260, 0, 10), BackgroundTransparency = 1 }, gui)
new("UIListLayout", { VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Right }, nHolder)
local function notify(title, msg, dur, force)
	if not S.Notifs and not force then return end
	local f = new("CanvasGroup", { Size = UDim2.new(1, 0, 0, 52), GroupTransparency = 1 }, nHolder)
	rc(f, 14)
	bind(f, "BackgroundColor3", function() return T.row end)
	local bar = new("Frame", { Size = UDim2.new(0, 4, 1, 0), BorderSizePixel = 0 }, f)
	bind(bar, "BackgroundColor3", function() return T.a1 end, true)
	txt({ Size = UDim2.new(1, -20, 0, 20), Position = UDim2.fromOffset(14, 6), Text = title, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = f }, true)
	txt({ Size = UDim2.new(1, -20, 0, 20), Position = UDim2.fromOffset(14, 26), Text = msg, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f }, false, "sub")
	tw(f, 0.35, { GroupTransparency = 0 })
	task.delay(dur or 3, function() tw(f, 0.35, { GroupTransparency = 1 }); task.wait(0.4); pcall(function() f:Destroy() end) end)
end

local function drag(handle, target)
	local st, dragging, start, origin = { moved = false }, false
	handle.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging, start, origin, st.moved = true, i.Position, target.Position, false
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	conn(UIS.InputChanged:Connect(function(i)
		if dragging and isMove(i) then
			local d = i.Position - start
			if d.Magnitude > 6 then st.moved = true end
			target.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
		end
	end))
	return st
end

-- barra superior
local top = new("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, ZIndex = 3 }, main)
drag(top, main)
local function dot(x, color)
	local b = new("TextButton", { Size = UDim2.fromOffset(13, 13), Position = UDim2.fromOffset(x, 15), BackgroundColor3 = color, Text = "", AutoButtonColor = false }, top)
	round(b, 7)
	return b
end
local red = dot(16, Color3.fromRGB(255, 95, 87))
local yellow = dot(36, Color3.fromRGB(254, 188, 46))
dot(56, Color3.fromRGB(40, 200, 64))
local titleLbl = txt({ Size = UDim2.new(1, 0, 1, 0), Text = S.Title, TextSize = 13, TextColor3 = WHITE, Parent = top }, true, false)
grad(titleLbl)
local fpsLbl = txt({ Size = UDim2.fromOffset(130, 40), Position = UDim2.new(1, -142, 0, 0), Text = "-- FPS", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, Visible = S.ShowFPS, Parent = top }, true, "a1")

-- bolha
local bubble = new("TextButton", { Size = UDim2.fromOffset(S.BubbleSize, S.BubbleSize), Position = UDim2.new(0, 16, 0.4, 0), BackgroundColor3 = WHITE, Text = "", Visible = false, AutoButtonColor = false }, gui)
local bubC = round(bubble, 26)
grad(bubble)
new("UIStroke", { Thickness = 2, Color = WHITE, Transparency = 0.6, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, bubble)
local bubTxt = txt({ Size = UDim2.fromScale(1, 1), Text = S.BubbleChar, TextSize = 24, TextColor3 = WHITE, Parent = bubble }, true, false)
local pulse = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = S.BubblePulse }, bubble)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, pulse)
local pst = new("UIStroke", { Thickness = 2, Transparency = 0.2 }, pulse)
bind(pst, "Color", function() return T.a1 end, true)
do
	local ti = TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1)
	TS:Create(pulse, ti, { Size = UDim2.fromScale(1.8, 1.8) }):Play()
	TS:Create(pst, ti, { Transparency = 1 }):Play()
end
local function applyBubble()
	bubble.Size = UDim2.fromOffset(S.BubbleSize, S.BubbleSize)
	bubC.CornerRadius = UDim.new(0, S.BubbleSize / 2)
	bubTxt.Text = S.BubbleChar
	bubTxt.TextSize = math.floor(S.BubbleSize * 0.46)
	pulse.Visible = S.BubblePulse
end
local bst = drag(bubble, bubble)
local function hideMain()
	shown = false
	tw(main, 0.25, { GroupTransparency = 1 }); tw(uscale, 0.25, { Scale = S.Scale / 100 * 0.9 })
	updateBlur()
	task.delay(0.27, function() if not shown then main.Visible = false; bubble.Visible = true end end)
end
local function toggleMain() if shown then hideMain() else bubble.Visible = false; showMain() end end
yellow.MouseButton1Click:Connect(hideMain)
bubble.MouseButton1Click:Connect(function() if not bst.moved then toggleMain() end end)
conn(UIS.InputBegan:Connect(function(i, gp) if not gp and i.KeyCode.Name == S.Key then toggleMain() end end))

---------------------------------------------------------------- EXPLOSÃO DE PARTÍCULAS (usada na intro e nos botões)
local function burst(par, n, colorFn, power, origin)
	origin = origin or UDim2.fromScale(0.5, 0.5)
	for _ = 1, n do
		local a = math.random() * math.pi * 2
		local d = (60 + math.random() * 150) * (power or 1)
		local s = math.random(3, 8)
		local f = new("Frame", { Size = UDim2.fromOffset(s, s), AnchorPoint = Vector2.new(0.5, 0.5), Position = origin, BackgroundColor3 = colorFn(), BorderSizePixel = 0, ZIndex = 50 }, par)
		round(f, s)
		local t = 0.7 + math.random() * 0.9
		tw(f, t, {
			Position = UDim2.new(origin.X.Scale, origin.X.Offset + math.cos(a) * d, origin.Y.Scale, origin.Y.Offset + math.sin(a) * d),
			BackgroundTransparency = 1, Size = UDim2.fromOffset(1, 1),
		})
		task.delay(t + 0.05, function() pcall(function() f:Destroy() end) end)
	end
end
local function themeColor() return (math.random() < 0.5) and T.a1 or T.a2 end

---------------------------------------------------------------- INTRO
local introGui, introBlur
local function introColor()
	if S.IntroRainbow then return Color3.fromHSV(math.random(), 0.6, 1) end
	return themeColor()
end
local function playIntro(done)
	if introGui then pcall(function() introGui:Destroy() end) end
	if introBlur then pcall(function() introBlur:Destroy() end) end
	local ig = new("ScreenGui", { Name = "ApplePanelIntro", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, parent)
	introGui = ig
	local vp = cam.ViewportSize
	local sc = math.clamp(math.min(vp.X / 700, vp.Y / 420), 0.55, 1.3)
	local root = new("CanvasGroup", {
		Size = UDim2.fromScale(1, 1), BackgroundColor3 = T.bg:Lerp(Color3.new(0, 0, 0), 0.55),
		BackgroundTransparency = 1 - S.IntroBG / 100, BorderSizePixel = 0, GroupTransparency = 1,
	}, ig)
	local stage = new("Frame", { Size = UDim2.fromOffset(700, 420), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1 }, root)
	local ui = new("UIScale", { Scale = sc }, stage)
	local skipped = false
	local hit = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 100 }, root)
	hit.MouseButton1Click:Connect(function() if S.IntroSkip then skipped = true end end)
	local function wait2(t)
		local e = os.clock() + t
		while os.clock() < e and not skipped and alive do task.wait(0.03) end
	end
	local D, style = math.max(S.IntroTime, 1.5), S.IntroStyle
	if S.IntroBlur then
		introBlur = new("BlurEffect", { Name = "ApplePanelIntroBlur", Size = 0 }, Lighting)
		tw(introBlur, 0.6, { Size = 20 })
	end
	tw(root, 0.4, { GroupTransparency = 0 })

	-- brilho atrás do logo
	local halo = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -50), Size = UDim2.fromOffset(190, 190), BackgroundColor3 = T.a1, BackgroundTransparency = 0.8, BorderSizePixel = 0 }, stage)
	round(halo, 100)
	TS:Create(halo, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundTransparency = 0.92, Size = UDim2.fromOffset(230, 230) }):Play()

	-- logo
	local logo = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -50), Size = UDim2.fromOffset(0, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0 }, stage)
	new("UICorner", { CornerRadius = UDim.new(0.3, 0) }, logo)
	local lg = new("UIGradient", { Color = ColorSequence.new(T.a1, T.a2), Rotation = 45 }, logo)
	if style == "Neon" then new("UIStroke", { Thickness = 3, Color = T.a1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, logo) end
	new("TextLabel", { Size = UDim2.fromScale(0.7, 0.7), Position = UDim2.fromScale(0.15, 0.15), BackgroundTransparency = 1, Text = S.IntroLogo, Font = Enum.Font.GothamBlack, TextScaled = true, TextColor3 = WHITE }, logo)

	-- título (letra por letra)
	local title = new("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.5, 20), Size = UDim2.fromOffset(0, 42), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1 }, stage)
	new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 3) }, title)
	local chars = {}
	pcall(function() for _, cp in utf8.codes(S.IntroTitle) do chars[#chars + 1] = utf8.char(cp) end end)
	local letters = {}
	for i, ch in ipairs(chars) do
		local sp = (ch == " ")
		local l = new("TextLabel", {
			Size = UDim2.fromOffset(sp and 12 or 0, 42), AutomaticSize = sp and Enum.AutomaticSize.None or Enum.AutomaticSize.X,
			BackgroundTransparency = 1, Text = ch, Font = Enum.Font.GothamBlack, TextSize = 46, TextTransparency = 1,
			TextColor3 = T.a1:Lerp(T.a2, (i - 1) / math.max(#chars - 1, 1)), LayoutOrder = i,
		}, title)
		letters[i] = l
	end
	local function showLetter(l, ch, i)
		if ch == " " then return end
		task.delay((i - 1) * 0.07, function()
			if skipped then l.Text = ch; l.TextTransparency = 0; l.TextSize = 34; return end
			if style == "Glitch" then
				for _ = 1, 7 do l.TextTransparency = 0; l.Text = string.char(math.random(33, 90)); task.wait(0.03) end
				l.Text = ch
			end
			tw(l, 0.5, { TextTransparency = 0, TextSize = 34 }, Enum.EasingStyle.Back)
			if style == "Neon" then
				l.TextStrokeColor3 = l.TextColor3
				tw(l, 0.6, { TextStrokeTransparency = 0.55 })
				task.delay(0.5, function() for _ = 1, 4 do l.TextTransparency = 0.5; task.wait(0.05); l.TextTransparency = 0; task.wait(0.07) end end)
			end
		end)
	end

	-- subtítulo, barra e dica
	local sub = new("TextLabel", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.5, 70), Size = UDim2.fromOffset(500, 22), BackgroundTransparency = 1, Text = S.IntroSub, Font = Enum.Font.GothamMedium, TextSize = 15, TextColor3 = T.text, TextTransparency = 1 }, stage)
	local track = new("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.5, 120), Size = UDim2.fromOffset(240, 4), BackgroundColor3 = T.row, BorderSizePixel = 0, Visible = S.IntroBar }, stage)
	round(track, 2)
	local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0 }, track)
	round(fill, 2)
	new("UIGradient", { Color = ColorSequence.new(T.a1, T.a2) }, fill)
	local pct = new("TextLabel", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.5, 130), Size = UDim2.fromOffset(100, 16), BackgroundTransparency = 1, Text = "0%", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = T.sub, Visible = S.IntroBar }, stage)
	if S.IntroSkip then
		new("TextLabel", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -8), Size = UDim2.fromOffset(300, 16), BackgroundTransparency = 1, Text = "toque para pular", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = T.sub, TextTransparency = 0.4 }, stage)
	end

	local t0 = os.clock()
	local rot = RS.Heartbeat:Connect(function(dt)
		lg.Rotation = (lg.Rotation + 90 * dt) % 360
		logo.Position = UDim2.new(0.5, 0, 0.5, -50 + math.sin(os.clock() * 2) * 4)
		local a = math.clamp((os.clock() - t0) / D, 0, 1)
		fill.Size = UDim2.fromScale(a, 1)
		pct.Text = math.floor(a * 100) .. "%"
	end)

	local function ring(delay, maxs)
		task.delay(delay, function()
			local r = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -50), Size = UDim2.fromOffset(40, 40), BackgroundTransparency = 1 }, stage)
			new("UICorner", { CornerRadius = UDim.new(1, 0) }, r)
			local st = new("UIStroke", { Thickness = 3, Color = introColor(), Transparency = 0.1 }, r)
			tw(r, 1.4, { Size = UDim2.fromOffset(maxs, maxs) })
			tw(st, 1.4, { Transparency = 1, Thickness = 0.5 })
			task.delay(1.5, function() pcall(function() r:Destroy() end) end)
		end)
	end

	task.spawn(function()
		wait2(0.15)
		tw(logo, 0.7, { Size = UDim2.fromOffset(104, 104) }, Enum.EasingStyle.Back)
		if style ~= "Minimal" then for i = 1, S.IntroRings do ring(i * 0.14, 480 + i * 110) end end
		if style == "Glitch" then
			task.spawn(function()
				for _ = 1, 10 do
					if skipped then break end
					local f = new("Frame", { Size = UDim2.fromScale(1, math.random(2, 12) / 100), Position = UDim2.fromScale(0, math.random()), BackgroundColor3 = introColor(), BackgroundTransparency = 0.6, BorderSizePixel = 0 }, root)
					task.delay(0.08, function() pcall(function() f:Destroy() end) end)
					task.wait(0.12)
				end
			end)
		end
		wait2(0.45)
		if style ~= "Minimal" and not skipped then burst(stage, S.IntroBurst, introColor, 1) end
		for i, l in ipairs(letters) do showLetter(l, chars[i], i) end
		wait2(#letters * 0.07 + 0.3)
		tw(sub, 0.6, { TextTransparency = 0.25 })
		wait2(math.max(0, t0 + D - os.clock()))
		if not skipped and style ~= "Minimal" then burst(stage, math.floor(S.IntroBurst * 1.6), introColor, 1.7) end
		tw(root, 0.6, { GroupTransparency = 1 })
		tw(ui, 0.6, { Scale = sc * 1.08 })
		if introBlur then tw(introBlur, 0.6, { Size = 0 }) end
		task.wait(0.65)
		pcall(function() rot:Disconnect() end)
		pcall(function() if introBlur then introBlur:Destroy(); introBlur = nil end end)
		pcall(function() ig:Destroy() end)
		if alive and done then done() end
	end)
end

---------------------------------------------------------------- PARTÍCULAS
local PTypes = {
	["Neve"] = { fall = 1, spd = 28, size = { 3, 7 }, sway = 14, col = WHITE, shape = "dot" },
	["Chuva"] = { fall = 1, spd = 260, size = { 1, 2 }, sway = 0, col = Color3.fromRGB(150, 200, 255), shape = "line" },
	["Pétalas"] = { fall = 1, spd = 34, size = { 6, 10 }, sway = 26, col = Color3.fromRGB(255, 150, 200), shape = "petal", spin = true },
	["Estrelas"] = { fall = 1, spd = 20, size = { 3, 6 }, sway = 6, col = Color3.fromRGB(255, 235, 150), shape = "diamond", twinkle = true },
	["Confete"] = { fall = 1, spd = 60, size = { 5, 9 }, sway = 18, col = nil, shape = "rect", spin = true },
	["Bolhas"] = { fall = -1, spd = 30, size = { 6, 14 }, sway = 12, col = Color3.fromRGB(190, 230, 255), shape = "bubble" },
	["Brasas"] = { fall = -1, spd = 45, size = { 2, 5 }, sway = 16, col = Color3.fromRGB(255, 140, 40), shape = "dot", flicker = true },
	["Matrix"] = { fall = 1, spd = 110, size = { 10, 14 }, sway = 0, col = Color3.fromRGB(0, 255, 106), shape = "text" },
	["Flocos"] = { fall = 1, spd = 26, size = { 9, 15 }, sway = 16, col = WHITE, shape = "glyph", glyph = "❄", spin = true },
	["Corações"] = { fall = -1, spd = 34, size = { 9, 16 }, sway = 14, col = Color3.fromRGB(255, 90, 130), shape = "glyph", glyph = "♥" },
	["Símbolo"] = { fall = 1, spd = 30, size = { 9, 16 }, sway = 12, col = nil, shape = "glyph", spin = true },
}
local PTypeNames = { "Neve", "Chuva", "Pétalas", "Estrelas", "Confete", "Bolhas", "Brasas", "Matrix", "Flocos", "Corações", "Símbolo" }
local PColorNames = { "Automática", "Tema", "Branco", "Arco-íris", "Aleatória", "Fixa" }
if not PTypes[S.PType] then S.PType = "Neve" end

local particles, MCH = {}, "01$#%&XZ"
local function isText(shape) return shape == "text" or shape == "glyph" end
local function buildFrame(shape)
	if isText(shape) then
		return new("TextLabel", { BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "0", TextSize = 12, Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5) }, pLayer)
	end
	local f = new("Frame", { BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = WHITE }, pLayer)
	if shape == "dot" or shape == "bubble" or shape == "petal" then new("UICorner", { CornerRadius = UDim.new(1, 0) }, f) end
	if shape == "bubble" then new("UIStroke", { Thickness = 1, Transparency = 0.4, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, f) end
	return f
end
local function sizeFrame(p, def)
	local s = p.size
	if def.shape == "line" then p.f.Size = UDim2.fromOffset(math.max(1, s), s * 9)
	elseif def.shape == "petal" then p.f.Size = UDim2.fromOffset(s * 1.5, s * 0.9)
	elseif def.shape == "rect" then p.f.Size = UDim2.fromOffset(s, s * 0.55)
	elseif isText(def.shape) then p.f.TextSize = math.floor(s); p.f.Size = UDim2.fromOffset(s, s)
	else p.f.Size = UDim2.fromOffset(s, s) end
end
local function fallDir(def) return def.fall * (S.PInvert and -1 or 1) end
local function resetP(p, initial)
	local def = PTypes[S.PType]
	local sc = S.PSize / 50
	p.size = (math.random() * (def.size[2] - def.size[1]) + def.size[1]) * sc
	p.v = def.spd * (0.7 + math.random() * 0.6)
	local lo, hi = 0, S.W
	if S.PWind > 20 then lo = -S.W * 0.4 elseif S.PWind < -20 then hi = S.W * 1.4 end
	p.x = lo + math.random() * (hi - lo)
	if initial then p.y = math.random() * S.H else p.y = fallDir(def) > 0 and -20 or S.H + 20 end
	p.h, p.phase, p.rot, p.vr = math.random(), math.random() * 6.28, math.random() * 360, (math.random() - 0.5) * 260
	if def.shape == "text" then local i = math.random(1, #MCH); p.f.Text = MCH:sub(i, i) end
	if def.shape == "glyph" then p.f.Text = def.glyph or S.PGlyph end
	sizeFrame(p, def)
end
local function makeParticle()
	local def = PTypes[S.PType]
	local p = { f = buildFrame(def.shape) }
	if def.shape == "bubble" then p.stroke = p.f:FindFirstChildOfClass("UIStroke") end
	resetP(p, true)
	table.insert(particles, p)
end
local function rebuildParticles()
	for _, p in ipairs(particles) do pcall(function() p.f:Destroy() end) end
	particles = {}
	if S.PEnabled then for _ = 1, S.PCount do makeParticle() end end
end
local function adjustCount(n)
	if not S.PEnabled then return end
	while #particles < n do makeParticle() end
	while #particles > n do local p = table.remove(particles); pcall(function() p.f:Destroy() end) end
end
local function setAlpha(p, a)
	if p.f:IsA("TextLabel") then p.f.TextTransparency = a
	elseif p.stroke then p.f.BackgroundTransparency = math.min(1, a + 0.6); p.stroke.Transparency = a
	else p.f.BackgroundTransparency = a end
end
local phue = 0
local function pcolor(p, def)
	local m = S.PColor
	if m == "Branco" then return WHITE
	elseif m == "Fixa" then return Color3.fromRGB(S.PR, S.PG, S.PB)
	elseif m == "Tema" then return (p.h < 0.5) and T.a1 or T.a2
	elseif m == "Arco-íris" then return Color3.fromHSV((phue + p.h * 0.5) % 1, 0.6, 1)
	elseif m == "Aleatória" then return Color3.fromHSV(p.h, 0.55, 1) end
	return def.col or Color3.fromHSV(p.h, 0.55, 1)
end
conn(RS.Heartbeat:Connect(function(dt)
	if not (S.PEnabled and shown and main.Visible) then return end
	dt = math.min(dt, 0.05)
	phue = (phue + dt * 0.1) % 1
	local def = PTypes[S.PType]
	if not def then return end
	local fd, spdM, wind = fallDir(def), S.PSpeed / 50, S.PWind * 0.9
	local swayAmt = def.sway * S.PSway / 100
	for _, p in ipairs(particles) do
		p.y += fd * p.v * spdM * dt
		p.phase += dt * (0.8 + p.v / 80)
		local sway = swayAmt > 0 and math.cos(p.phase) * swayAmt or 0
		p.x += (wind * spdM + sway) * dt
		if (fd > 0 and p.y > S.H + 24) or (fd < 0 and p.y < -24) or p.x < -S.W * 0.5 or p.x > S.W * 1.5 then resetP(p, false) end
		p.f.Position = UDim2.fromOffset(p.x, p.y)
		if def.shape == "line" then p.f.Rotation = -wind * 0.1
		elseif def.spin and S.PSpin then p.rot += p.vr * dt; p.f.Rotation = p.rot
		elseif def.shape == "diamond" then p.f.Rotation = 45 end
		local a = S.PAlpha / 100
		if def.twinkle then a = math.clamp(a + 0.35 * (1 + math.sin(p.phase * 3)) / 2, 0, 1)
		elseif def.flicker then a = math.clamp(a + 0.25 * (1 + math.sin(p.phase * 5)) / 2, 0, 1) end
		setAlpha(p, a)
		local c = pcolor(p, def)
		if p.f:IsA("TextLabel") then p.f.TextColor3 = c else p.f.BackgroundColor3 = c; if p.stroke then p.stroke.Color = c end end
	end
end))

---------------------------------------------------------------- BOTÕES (estilos)
local btns = {}
local function styleBtn(e)
	local st = S.BtnStyle
	e.c.CornerRadius = UDim.new(0, S.BtnCorner)
	e.b.Size = UDim2.new(1, -4, 0, S.BtnH)
	e.l.TextSize = S.BtnText
	e.g.Enabled, e.s.Enabled, e.gs.Enabled = false, false, false
	e.b.BackgroundTransparency = 0
	e.b.BackgroundColor3 = WHITE
	e.gs.Color = ColorSequence.new(T.a1, T.a2)
	if st == "Sólido" then e.b.BackgroundColor3 = T.a1; e.l.TextColor3 = WHITE
	elseif st == "Vidro" then
		e.b.BackgroundColor3 = T.row; e.b.BackgroundTransparency = 0.3
		e.s.Enabled = true; e.s.Color = T.a1; e.s.Thickness = 1; e.s.Transparency = 0.4; e.l.TextColor3 = T.text
	elseif st == "Contorno" then
		e.b.BackgroundTransparency = 1
		e.s.Enabled = true; e.s.Color = T.a1; e.s.Thickness = 2; e.s.Transparency = 0; e.l.TextColor3 = T.a1
	elseif st == "Neon" then
		e.b.BackgroundColor3 = T.bg
		e.s.Enabled = true; e.s.Color = WHITE; e.gs.Enabled = true; e.s.Thickness = 2; e.s.Transparency = 0; e.l.TextColor3 = T.a1
	else e.g.Enabled = true; e.l.TextColor3 = WHITE end
end
local function restyleBtns() for _, e in ipairs(btns) do styleBtn(e) end end
table.insert(binders, function() restyleBtns() end)

---------------------------------------------------------------- SIDEBAR / ABAS
local tabY, tabIdx, tabBtns, tabIcon, pages, current, count = {}, {}, {}, {}, {}, nil, 0
local side = new("ScrollingFrame", { Size = UDim2.new(0, S.SideW, 1, -50), Position = UDim2.fromOffset(8, 42), BackgroundTransparency = 0.25, BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(), ScrollingDirection = Enum.ScrollingDirection.Y }, main)
rc(side, 16)
bind(side, "BackgroundColor3", function() return T.side end)
glass(side, 0.92)
local indicator = new("Frame", { Size = UDim2.new(1, -12, 0, S.TabH), Position = UDim2.fromOffset(6, 8), BackgroundColor3 = WHITE, BorderSizePixel = 0 }, side)
local indC = new("UICorner", {}, indicator)
local indG = grad(indicator)
local indS = new("UIStroke", { Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = false }, indicator)
local content = new("Frame", { Size = UDim2.new(1, -(S.SideW + 22), 1, -50), Position = UDim2.fromOffset(S.SideW + 16, 42), BackgroundTransparency = 1, ClipsDescendants = true }, main)

local TRANS = { "Deslizar", "Subir", "Fade", "Zoom", "Pop", "Nenhuma" }
local EASES = { "Quint", "Back", "Elastic", "Bounce", "Sine", "Quad", "Cubic", "Exponential", "Linear" }
local function P(x, y) return UDim2.new(0.5, x, 0.5, y) end
local function selColor() return (S.TabStyle == "Pílula") and WHITE or T.a1 end
local function refreshTabs()
	for n, b in pairs(tabBtns) do tw(b, 0.25, { TextColor3 = (n == current) and selColor() or T.sub }) end
end
local function indPos(n)
	local y = tabY[n] or 8
	if S.TabStyle == "Linha" then return UDim2.fromOffset(2, y + 5) end
	return UDim2.fromOffset(6, y)
end
local function styleIndicator()
	if not current then return end
	local st, h = S.TabStyle, S.TabH
	indG.Enabled, indS.Enabled = false, false
	indicator.BackgroundTransparency, indicator.BackgroundColor3 = 0, WHITE
	indC.CornerRadius = UDim.new(0, math.floor(h / 3))
	if st == "Linha" then
		indicator.Size = UDim2.fromOffset(4, h - 10); indC.CornerRadius = UDim.new(0, 2); indG.Enabled = true
	elseif st == "Contorno" then
		indicator.Size = UDim2.new(1, -12, 0, h); indicator.BackgroundTransparency = 1; indS.Enabled = true; indS.Color = T.a1
	elseif st == "Brilho" then
		indicator.Size = UDim2.new(1, -12, 0, h); indicator.BackgroundTransparency = 0.65; indG.Enabled = true; indS.Enabled = true; indS.Color = T.a1
	else
		indicator.Size = UDim2.new(1, -12, 0, h); indG.Enabled = true
	end
	indicator.Position = indPos(current)
end
local function layoutTabs()
	local h = S.TabH
	side.Size = UDim2.new(0, S.SideW, 1, -50)
	content.Size = UDim2.new(1, -(S.SideW + 22), 1, -50)
	content.Position = UDim2.fromOffset(S.SideW + 16, 42)
	for name, i in pairs(tabIdx) do
		tabY[name] = 8 + (i - 1) * (h + 3)
		local b = tabBtns[name]
		b.Size = UDim2.new(1, -12, 0, h)
		b.Position = UDim2.fromOffset(6, tabY[name])
		b.TextSize = S.TabText
		b.TextXAlignment = (S.TabAlign == "Centro") and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
		b.Text = (S.TabIcons and (tabIcon[name] .. "  ") or "") .. name
	end
	side.CanvasSize = UDim2.new(0, 0, 0, 16 + count * (h + 3))
	styleIndicator()
	refreshTabs()
end
table.insert(binders, function() styleIndicator(); refreshTabs() end)

local function switchTab(name)
	if current == name then return end
	local old = current
	current = name
	refreshTabs()
	local tt, es, kind = math.max(S.TransTime, 50) / 1000, ease(), S.Transition
	local dir = (old and tabIdx[name] < tabIdx[old]) and -1 or 1
	if old then tw(indicator, tt, { Position = indPos(name) }, es) else styleIndicator() end
	if old then
		local o = pages[old]
		if kind == "Nenhuma" then o.g.Visible = false
		else
			local goal = { GroupTransparency = 1 }
			if kind == "Deslizar" then goal.Position = P(-28 * dir, 0) elseif kind == "Subir" then goal.Position = P(0, -28 * dir) end
			tw(o.g, tt * 0.5, goal, Enum.EasingStyle.Quad)
			if kind == "Zoom" or kind == "Pop" then tw(o.s, tt * 0.5, { Scale = 1.06 }, Enum.EasingStyle.Quad) end
			task.delay(tt * 0.5 + 0.03, function() if current ~= old then o.g.Visible = false end end)
		end
	end
	local p = pages[name]
	p.g.Position, p.s.Scale = P(0, 0), 1
	if kind == "Deslizar" then p.g.Position = P(30 * dir, 0)
	elseif kind == "Subir" then p.g.Position = P(0, 30 * dir)
	elseif kind == "Zoom" then p.s.Scale = 0.9
	elseif kind == "Pop" then p.s.Scale = 0.72 end
	p.g.GroupTransparency = (kind == "Nenhuma") and 0 or 1
	p.g.Visible = true
	if kind ~= "Nenhuma" then
		task.delay(tt * 0.2, function()
			if current == name then tw(p.g, tt, { GroupTransparency = 0, Position = P(0, 0) }, es); tw(p.s, tt, { Scale = 1 }, es) end
		end)
	end
end

local infoRows = {}
local Lib = {}
function Lib:Tab(name, icon)
	count += 1
	tabIdx[name], tabIcon[name], tabY[name] = count, icon, 8 + (count - 1) * (S.TabH + 3)
	local g = new("CanvasGroup", { Size = UDim2.fromScale(1, 1), AnchorPoint = Vector2.new(0.5, 0.5), Position = P(0, 0), BackgroundTransparency = 1, GroupTransparency = 1, Visible = false }, content)
	local s = new("UIScale", {}, g)
	local page = new("ScrollingFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new() }, g)
	new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, page)
	new("UIPadding", { PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 12) }, page)
	bind(page, "ScrollBarImageColor3", function() return T.a1 end, true)
	pages[name] = { g = g, s = s }
	local btn = txt({ Class = "TextButton", Size = UDim2.new(1, -12, 0, S.TabH), Position = UDim2.fromOffset(6, tabY[name]), Text = icon .. "  " .. name, TextSize = S.TabText, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = T.sub, ZIndex = 2, AutoButtonColor = false, Parent = side }, true, false)
	new("UIPadding", { PaddingLeft = UDim.new(0, 12) }, btn)
	tabBtns[name] = btn
	btn.MouseButton1Click:Connect(function() switchTab(name) end)

	local C = {}
	local function off() return T.row:Lerp(T.sub, 0.4) end
	local function row(h)
		local r = new("Frame", { Size = UDim2.new(1, -4, 0, h), BackgroundTransparency = 0.2 }, page)
		rc(r, 13)
		bind(r, "BackgroundColor3", function() return T.row end)
		glass(r, 0.93)
		return r
	end
	local function label(r, text, y)
		return txt({ Size = UDim2.new(1, -80, 0, 18), Position = UDim2.fromOffset(14, y), Text = text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = r })
	end

	function C:Section(text)
		txt({ Size = UDim2.new(1, -4, 0, 22), Text = string.upper(text), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = page }, true, "a1")
	end
	function C:Label(text)
		return txt({ Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = text, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = page }, false, "sub")
	end
	function C:Info(nm, fn)
		local r = row(34)
		txt({ Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.fromOffset(14, 0), Text = nm, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = r }, false, "sub")
		local v = txt({ Size = UDim2.new(0.6, -28, 1, 0), Position = UDim2.new(0.4, 14, 0, 0), Text = "...", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, Parent = r }, true)
		table.insert(infoRows, { v, fn })
	end

	function C:Toggle(text, def, cb)
		local r = row(42)
		label(r, text, 12)
		local sw = new("TextButton", { Size = UDim2.fromOffset(46, 26), Position = UDim2.new(1, -60, 0.5, -13), Text = "", AutoButtonColor = false }, r)
		round(sw, 13)
		local knob = new("Frame", { Size = UDim2.fromOffset(22, 22), Position = UDim2.fromOffset(2, 2), BackgroundColor3 = WHITE }, sw)
		round(knob, 11)
		local state = def or false
		local refresh = bind(sw, "BackgroundColor3", function() return state and T.a1 or off() end, true)
		local function set(v, fire)
			state = v
			refresh(0.25)
			tw(knob, 0.3, { Position = v and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2) }, Enum.EasingStyle.Back)
			if fire and cb then task.spawn(function() local ok, e = pcall(cb, v); if not ok then notify("Erro", tostring(e), 3, true) end end) end
		end
		set(state, false)
		if state and cb then task.spawn(cb, true) end
		sw.MouseButton1Click:Connect(function() set(not state, true) end)
		return function(v) set(v, true) end
	end

	function C:Slider(text, min, max, def, cb, suffix)
		suffix = suffix or ""
		def = math.clamp(math.floor(def + 0.5), min, max)
		local r = row(58)
		label(r, text, 6)
		local vl = txt({ Size = UDim2.new(0, 70, 0, 18), Position = UDim2.new(1, -84, 0, 6), Text = def .. suffix, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = r }, true, "a1")
		local bar = new("Frame", { Size = UDim2.new(1, -28, 0, 8), Position = UDim2.fromOffset(14, 40) }, r)
		round(bar, 4)
		bind(bar, "BackgroundColor3", off)
		local fill = new("Frame", { Size = UDim2.new((def - min) / (max - min), 0, 1, 0), BackgroundColor3 = WHITE }, bar)
		round(fill, 4)
		grad(fill)
		round(new("Frame", { Size = UDim2.fromOffset(18, 18), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = WHITE }, fill), 9)
		local hit = new("TextButton", { Size = UDim2.new(1, 0, 0, 30), Position = UDim2.fromOffset(0, -11), BackgroundTransparency = 1, Text = "" }, bar)
		local function setv(v, fire)
			v = math.clamp(math.floor(v + 0.5), min, max)
			fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
			vl.Text = v .. suffix
			if fire ~= false and cb then pcall(cb, v) end
		end
		local sliding = false
		local function fromX(x) setv(min + (max - min) * math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)) end
		hit.InputBegan:Connect(function(i) if isPress(i) then sliding = true; page.ScrollingEnabled = false; fromX(i.Position.X) end end)
		conn(UIS.InputChanged:Connect(function(i) if sliding and isMove(i) then fromX(i.Position.X) end end))
		conn(UIS.InputEnded:Connect(function(i) if sliding and isPress(i) then sliding = false; page.ScrollingEnabled = true end end))
		return setv
	end

	function C:Button(text, cb)
		local b = new("TextButton", { BackgroundColor3 = WHITE, Text = "", AutoButtonColor = false, ClipsDescendants = true }, page)
		local c = new("UICorner", {}, b)
		local g = grad(b)
		local st = new("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, b)
		local gs = new("UIGradient", {}, st)
		local l = txt({ Size = UDim2.fromScale(1, 1), Text = text, TextSize = 13, TextColor3 = WHITE, Parent = b }, true, false)
		local bs = new("UIScale", {}, b)
		local e = { b = b, g = g, s = st, gs = gs, l = l, c = c }
		table.insert(btns, e)
		styleBtn(e)
		b.InputBegan:Connect(function(i)
			if S.BtnRipple and isPress(i) then
				local x = (i.Position.X - b.AbsolutePosition.X) / math.max(uscale.Scale, 0.1)
				local rp = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, x, 0.5, 0), Size = UDim2.fromOffset(4, 4), BackgroundColor3 = WHITE, BackgroundTransparency = 0.7, BorderSizePixel = 0, ZIndex = 5 }, b)
				new("UICorner", { CornerRadius = UDim.new(1, 0) }, rp)
				tw(rp, 0.5, { Size = UDim2.fromOffset(S.BtnH * 6, S.BtnH * 6), BackgroundTransparency = 1 })
				task.delay(0.55, function() pcall(function() rp:Destroy() end) end)
			end
		end)
		b.MouseButton1Click:Connect(function()
			bs.Scale = 0.96; tw(bs, 0.3, { Scale = 1 }, Enum.EasingStyle.Back)
			task.spawn(function() local ok, er = pcall(cb); if not ok then notify("Erro", tostring(er), 3, true) end end)
		end)
	end

	function C:Input(text, placeholder, cb)
		local r = row(42)
		label(r, text, 12)
		local box = txt({ Class = "TextBox", Size = UDim2.new(0.55, -20, 0, 28), Position = UDim2.new(0.45, 6, 0.5, -14), Text = "", PlaceholderText = placeholder, TextSize = 13, ClearTextOnFocus = false, Parent = r }, false)
		box.BackgroundTransparency = 0.3
		bind(box, "BackgroundColor3", function() return T.side end)
		rc(box, 8)
		box.FocusLost:Connect(function(enter) if enter and box.Text ~= "" then pcall(cb, box.Text); box.Text = "" end end)
	end

	function C:Dropdown(text, opts, def, cb)
		local r = row(42)
		r.ClipsDescendants = true
		local head = new("TextButton", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Text = "" }, r)
		label(r, text, 12)
		local val = txt({ Size = UDim2.new(0.5, -40, 0, 42), Position = UDim2.fromScale(0.5, 0), Text = def, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = r }, true, "a1")
		local arrow = txt({ Size = UDim2.fromOffset(20, 42), Position = UDim2.new(1, -30, 0, 0), Text = "▾", TextSize = 15, Parent = r }, true, "sub")
		local list = new("Frame", { Size = UDim2.new(1, -16, 0, #opts * 32), Position = UDim2.fromOffset(8, 46), BackgroundTransparency = 1 }, r)
		new("UIListLayout", { Padding = UDim.new(0, 3) }, list)
		local open = false
		local function setOpen(v)
			open = v
			tw(r, 0.35, { Size = UDim2.new(1, -4, 0, v and (50 + #opts * 32) or 42) })
			tw(arrow, 0.35, { Rotation = v and 180 or 0 })
		end
		for _, o in ipairs(opts) do
			local b = txt({ Class = "TextButton", Size = UDim2.new(1, 0, 0, 29), Text = o, TextSize = 13, AutoButtonColor = false, Parent = list }, false)
			b.BackgroundTransparency = 0.35
			bind(b, "BackgroundColor3", function() return T.side end)
			rc(b, 8)
			b.MouseButton1Click:Connect(function() val.Text = o; setOpen(false); if cb then pcall(cb, o) end end)
		end
		head.MouseButton1Click:Connect(function() setOpen(not open) end)
		return function(o) val.Text = o; if cb then pcall(cb, o) end end
	end

	-- versões ligadas ao estado S (salvam e entram nos presets)
	function C:SToggle(text, key, cb) reg[key] = C:Toggle(text, S[key], function(v) S[key] = v; if cb then cb(v) end end) end
	function C:SSlider(text, min, max, key, cb, suffix)
		local setv = C:Slider(text, min, max, S[key], function(v) S[key] = v; if cb then cb(v) end end, suffix)
		reg[key] = function(v) setv(v, true) end
	end
	function C:SDrop(text, opts, key, cb) reg[key] = C:Dropdown(text, opts, S[key], function(o) S[key] = o; if cb then cb(o) end end) end
	function C:SInput(text, key, cb) C:Input(text, tostring(S[key]) .. "  (Enter)", function(t) S[key] = t; if cb then cb(t) end end) end

	local function grid(w, h)
		local g2 = new("Frame", { Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 }, page)
		new("UIGridLayout", { CellSize = UDim2.fromOffset(w, h), CellPadding = UDim2.fromOffset(8, 8) }, g2)
		return g2
	end
	function C:ThemeGrid()
		local g2 = grid(112, 56)
		for _, nm in ipairs(ThemeNames) do
			local t = Themes[nm]
			local isC = (nm == "Custom")
			local b = new("TextButton", { BackgroundColor3 = t.bg, Text = "", AutoButtonColor = false }, g2)
			rc(b, 12)
			local strip = new("Frame", { Size = UDim2.new(1, -12, 0, 16), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = WHITE }, b)
			round(strip, 6)
			local sg = new("UIGradient", { Color = ColorSequence.new(t.a1, t.a2) }, strip)
			local bar2 = new("Frame", { Size = UDim2.new(1, -12, 0, 7), Position = UDim2.fromOffset(6, 27), BackgroundColor3 = t.row }, b)
			round(bar2, 4)
			local lb = new("TextLabel", { Size = UDim2.new(1, 0, 0, 16), Position = UDim2.fromOffset(0, 37), BackgroundTransparency = 1, Text = nm, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = t.text }, b)
			if isC then
				bind(b, "BackgroundColor3", function() return Themes.Custom.bg end)
				bind(sg, "Color", function() return ColorSequence.new(Themes.Custom.a1, Themes.Custom.a2) end, true)
				bind(bar2, "BackgroundColor3", function() return Themes.Custom.row end)
				bind(lb, "TextColor3", function() return Themes.Custom.text end)
			end
			local st = new("UIStroke", { Thickness = 2.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = (S.Theme == nm) }, b)
			bind(st, "Color", function() return T.a1 end, true)
			themeStrokes[nm] = st
			b.MouseButton1Click:Connect(function() applyTheme(nm) end)
		end
	end
	function C:FontGrid()
		local g2, sts = grid(112, 36), {}
		for _, nm in ipairs(FontList) do
			local b = new("TextButton", { BackgroundTransparency = 0.2, Text = "Aa " .. nm, TextSize = 12, AutoButtonColor = false, TextTruncate = Enum.TextTruncate.AtEnd, Font = getFont(nm, false) }, g2)
			rc(b, 11)
			bind(b, "BackgroundColor3", function() return T.row end)
			bind(b, "TextColor3", function() return T.text end)
			local st = new("UIStroke", { Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Enabled = (S.Font == nm) }, b)
			bind(st, "Color", function() return T.a1 end, true)
			sts[nm] = st
			b.MouseButton1Click:Connect(function() for k, s2 in pairs(sts) do s2.Enabled = (k == nm) end setFont(nm) end)
		end
	end
	return C
end

---------------------------------------------------------------- LÓGICA DO JOGO
local G = { SpeedOn = false, Speed = 50, JumpOn = false, Jump = 80, Fly = false, FlySpeed = 60, Noclip = false, InfJump = false,
	ESPP = false, ESPF = false, ESPC = false, ESPM = false, FruitNotify = false, Fullbright = false, NoFog = false, Traveling = false, Travel = 250 }
local function root() local c = lp.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function hum() local c = lp.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function dataVal(n) local ok, v = pcall(function() return lp.Data[n].Value end) return ok and v or nil end
local function commas(n)
	local s = tostring(math.floor(tonumber(n) or 0))
	return (s:reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", ""))
end
local function getPing() local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end) return ok and math.floor(v) or 0 end
local function loop(interval, fn) task.spawn(function() while alive do task.wait(interval) pcall(fn) end end) end

local function goTo(cf)
	local r = root()
	if not r then return end
	local d = (cf.Position - r.Position).Magnitude
	if d < 60 then r.CFrame = cf return end
	G.Traveling = true
	local tween = TS:Create(r, TweenInfo.new(d / math.max(G.Travel, 50), Enum.EasingStyle.Linear), { CFrame = cf })
	tween:Play()
	tween.Completed:Wait()
	G.Traveling = false
end

local function isFruit(v) return (v:IsA("Tool") or v:IsA("Model")) and v.Name:lower():find("fruit") and v:FindFirstChild("Handle") end
local function nearestFruit()
	local r, best, bd = root(), nil, nil
	for _, v in ipairs(workspace:GetChildren()) do
		if isFruit(v) then
			local d = r and (v.Handle.Position - r.Position).Magnitude or 0
			if not bd or d < bd then best, bd = v, d end
		end
	end
	return best
end
local function nearestChest()
	local r, best, bd = root(), nil, nil
	for _, c in ipairs(CS:GetTagged("_ChestTagged")) do
		if c.Parent then
			local p = c:GetPivot().Position
			local d = r and (p - r.Position).Magnitude or 0
			if not bd or d < bd then best, bd = p, d end
		end
	end
	return best
end
local seenFruit = setmetatable({}, { __mode = "k" })
loop(2, function()
	if not G.FruitNotify then return end
	for _, v in ipairs(workspace:GetChildren()) do
		if isFruit(v) and not seenFruit[v] then seenFruit[v] = true; notify("Fruta apareceu!", v.Name, 5) end
	end
end)

local espFolder = new("Folder", { Name = "ESP" }, gui)
local esp = {}
local function sync(kind, on, targets)
	esp[kind] = esp[kind] or {}
	local cache, seen = esp[kind], {}
	if on then
		for _, t in ipairs(targets()) do
			seen[t.inst] = true
			local e = cache[t.inst]
			if not e then
				local hl = new("Highlight", { Adornee = t.inst, FillTransparency = 0.65, OutlineTransparency = 0, FillColor = t.color, OutlineColor = t.color, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop }, espFolder)
				local bb = new("BillboardGui", { Adornee = t.part, Size = UDim2.fromOffset(150, 26), AlwaysOnTop = true, StudsOffset = Vector3.new(0, 3, 0) }, espFolder)
				local lb = new("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, TextColor3 = t.color, TextStrokeTransparency = 0.4, TextSize = 13, Font = Enum.Font.GothamBold }, bb)
				e = { hl, bb, lb }
				cache[t.inst] = e
			end
			e[3].Text = t.text
		end
	end
	for inst, e in pairs(cache) do
		if not seen[inst] or not inst.Parent then pcall(function() e[1]:Destroy(); e[2]:Destroy() end); cache[inst] = nil end
	end
end
local function dist(p) local r = root() return r and math.floor((p - r.Position).Magnitude) or 0 end
loop(0.5, function()
	sync("p", G.ESPP, function()
		local l = {}
		for _, p in ipairs(Players:GetPlayers()) do
			local c = p.Character
			local hr, h = c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
			if p ~= lp and hr and h then table.insert(l, { inst = c, part = hr, color = Color3.fromRGB(255, 85, 85), text = p.DisplayName .. " [" .. dist(hr.Position) .. "m] " .. math.floor(h.Health) .. "HP" }) end
		end
		return l
	end)
	sync("f", G.ESPF, function()
		local l = {}
		for _, v in ipairs(workspace:GetChildren()) do
			if isFruit(v) then table.insert(l, { inst = v, part = v.Handle, color = Color3.fromRGB(255, 196, 60), text = v.Name .. " [" .. dist(v.Handle.Position) .. "m]" }) end
		end
		return l
	end)
	sync("c", G.ESPC, function()
		local l = {}
		for _, c in ipairs(CS:GetTagged("_ChestTagged")) do
			if c.Parent then
				local part = c:IsA("BasePart") and c or c:FindFirstChildWhichIsA("BasePart", true)
				if part then table.insert(l, { inst = c, part = part, color = Color3.fromRGB(90, 220, 255), text = "Baú [" .. dist(part.Position) .. "m]" }) end
			end
		end
		return l
	end)
	sync("m", G.ESPM, function()
		local l, folder = {}, workspace:FindFirstChild("Enemies")
		if folder then
			for _, m in ipairs(folder:GetChildren()) do
				local hr, h = m:FindFirstChild("HumanoidRootPart"), m:FindFirstChildOfClass("Humanoid")
				if hr and h and h.Health > 0 and dist(hr.Position) < 500 then
					table.insert(l, { inst = m, part = hr, color = Color3.fromRGB(255, 150, 60), text = m.Name .. " " .. math.floor(h.Health) .. "HP" })
				end
			end
		end
		return l
	end)
end)

-- ambiente
local orig = { B = Lighting.Brightness, Fog = Lighting.FogEnd, Sh = Lighting.GlobalShadows, A = Lighting.Ambient, O = Lighting.OutdoorAmbient }
local function applyLight()
	if G.Fullbright then
		Lighting.Brightness, Lighting.GlobalShadows = 2, false
		Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200), Color3.fromRGB(200, 200, 200)
	else
		Lighting.Brightness, Lighting.GlobalShadows, Lighting.Ambient, Lighting.OutdoorAmbient = orig.B, orig.Sh, orig.A, orig.O
	end
	Lighting.FogEnd = G.NoFog and 1e6 or orig.Fog
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
local waterOrig
local function applyWater(on)
	pcall(function()
		local w = workspace.Map["WaterBase-Plane"]
		waterOrig = waterOrig or w.Size
		w.Size = on and Vector3.new(1000, 112, 1000) or waterOrig
	end)
end
local cc = new("ColorCorrectionEffect", { Name = "ApplePanelCC" }, Lighting)
local bloom = new("BloomEffect", { Name = "ApplePanelBloom", Intensity = 0, Size = 24, Threshold = 0.9 }, Lighting)

-- movimento
local flyBV
conn(RS.Heartbeat:Connect(function()
	local c, h, r = lp.Character, hum(), root()
	if not (c and h and r) then return end
	if G.SpeedOn then h.WalkSpeed = G.Speed end
	if G.JumpOn then h.UseJumpPower = true; h.JumpPower = G.Jump end
	if G.Fly then
		if not flyBV or flyBV.Parent ~= r then
			if flyBV then flyBV:Destroy() end
			flyBV = new("BodyVelocity", { MaxForce = Vector3.new(1e9, 1e9, 1e9) }, r)
		end
		local md, look = h.MoveDirection, cam.CFrame.LookVector
		local vel = md * G.FlySpeed
		if md.Magnitude > 0 then vel = vel + Vector3.new(0, look.Y * G.FlySpeed, 0) end
		flyBV.Velocity = vel
	elseif flyBV then flyBV:Destroy(); flyBV = nil end
end))
conn(RS.Stepped:Connect(function()
	if (G.Noclip or G.Traveling) and lp.Character then
		for _, p in ipairs(lp.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
	end
end))
conn(UIS.JumpRequest:Connect(function() if G.InfJump then local h = hum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end))
conn(lp.Idled:Connect(function() VU:CaptureController(); VU:ClickButton1(Vector2.new()) end))
conn(GuiService.ErrorMessageChanged:Connect(function()
	if S.AutoRejoin then task.wait(2); pcall(function() TPS:Teleport(game.PlaceId, lp) end) end
end))
conn(Players.PlayerAdded:Connect(function(p) if S.PlayerAlerts then notify("Jogador entrou", p.DisplayName, 3) end end))
conn(Players.PlayerRemoving:Connect(function(p) if S.PlayerAlerts then notify("Jogador saiu", p.DisplayName, 3) end end))

local function serverHop()
	notify("Server Hop", "Procurando servidor...", 3)
	local ok, data = pcall(function()
		return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
	end)
	if ok and data and data.data then
		for _, s in ipairs(data.data) do
			if s.id ~= game.JobId and s.playing < s.maxPlayers - 1 then TPS:TeleportToPlaceInstance(game.PlaceId, s.id, lp) return end
		end
	end
	notify("Server Hop", "Nenhum servidor encontrado.", 3)
end
local function findPlayer(name)
	name = name:lower()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Name:lower():find(name, 1, true) or p.DisplayName:lower():find(name, 1, true) then return p end
	end
end
local function wpGet(slot)
	local x, y, z = tostring(S["WP" .. slot]):match("^(%-?[%d%.]+),(%-?[%d%.]+),(%-?[%d%.]+)$")
	if x then return Vector3.new(tonumber(x), tonumber(y), tonumber(z)) end
end
local function saveCfg()
	local d = { Custom = {} }
	for k, v in pairs(S) do local t = type(v) if t == "string" or t == "number" or t == "boolean" then d[k] = v end end
	for k, v in pairs(Themes.Custom) do d.Custom[k] = v:ToHex() end
	local ok = pcall(function() writefile(CFG, HttpService:JSONEncode(d)) end)
	notify("Config", ok and "Salvo! Carrega ao reexecutar." or "Seu executor não permite salvar.", 3, true)
end
local function unload()
	alive = false
	G.Fly, G.Fullbright, G.NoFog = false, false, false
	pcall(applyLight)
	pcall(applyWater, false)
	pcall(function() workspace.Gravity = 196.2 end)
	pcall(function() local h = hum() if h then cam.CameraSubject = h end end)
	pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true); StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true) end)
	if flyBV then pcall(function() flyBV:Destroy() end) end
	for _, o in ipairs({ blur, cc, bloom, introBlur, introGui }) do pcall(function() o:Destroy() end) end
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	pcall(function() gui:Destroy() end)
end
red.MouseButton1Click:Connect(unload)

---------------------------------------------------------------- PRESETS
local STYLE_PRESETS = {
	["Apple Clássico"] = { Theme = "Midnight", Corner = 20, Glow = 12, Opacity = 6, Shine = true, BorderGlow = false, Aurora = false, BtnStyle = "Gradiente", BtnCorner = 13, TabStyle = "Pílula", PEnabled = true, PType = "Neve", PCount = 30, PColor = "Branco", PAlpha = 20, PSpeed = 45, PWind = 5 },
	["Neon Gamer"] = { Theme = "Cyber", Corner = 12, Glow = 24, Opacity = 10, BorderGlow = true, BorderSpin = true, GlowSpin = true, Aurora = true, BtnStyle = "Neon", BtnCorner = 10, TabStyle = "Contorno", PEnabled = true, PType = "Estrelas", PCount = 60, PColor = "Arco-íris", PAlpha = 10, IntroStyle = "Neon" },
	["Sakura Zen"] = { Theme = "Sakura", Corner = 24, Glow = 16, Opacity = 8, Aurora = true, BorderGlow = false, BtnStyle = "Vidro", BtnCorner = 20, TabStyle = "Brilho", PEnabled = true, PType = "Pétalas", PCount = 40, PColor = "Automática", PAlpha = 20, PWind = 25 },
	["Hacker"] = { Theme = "Matrix", Corner = 6, Glow = 10, Opacity = 4, Aurora = false, BorderGlow = true, BtnStyle = "Contorno", BtnCorner = 4, TabStyle = "Linha", PEnabled = true, PType = "Matrix", PCount = 55, PColor = "Automática", PAlpha = 20, PSpeed = 70, Font = "Code", IntroStyle = "Glitch" },
	["Cristal"] = { Theme = "Claro", Corner = 26, Glow = 8, Opacity = 18, Aurora = true, BtnStyle = "Vidro", BtnCorner = 22, TabStyle = "Brilho", PEnabled = true, PType = "Bolhas", PCount = 30, PColor = "Automática", PAlpha = 30 },
	["Vulcão"] = { Theme = "Lava", Corner = 14, Glow = 20, Opacity = 6, Aurora = true, BorderGlow = true, BtnStyle = "Sólido", BtnCorner = 12, TabStyle = "Pílula", PEnabled = true, PType = "Brasas", PCount = 50, PColor = "Automática", PAlpha = 15, PSpeed = 60 },
	["Galáxia"] = { Theme = "Galaxy", Corner = 18, Glow = 22, Opacity = 8, Aurora = true, GlowSpin = true, BtnStyle = "Gradiente", TabStyle = "Brilho", PEnabled = true, PType = "Estrelas", PCount = 70, PColor = "Branco", PAlpha = 10, PSpeed = 30 },
}
local StylePresetNames = { "Apple Clássico", "Neon Gamer", "Sakura Zen", "Hacker", "Cristal", "Vulcão", "Galáxia" }
local function applyStylePreset(nm)
	local p = STYLE_PRESETS[nm]
	if not p then return end
	for k, v in pairs(p) do
		if k == "Theme" then applyTheme(v)
		elseif k == "Font" then setFont(v)
		elseif reg[k] then reg[k](v)
		else S[k] = v end
	end
	notify("Estilo", nm .. " aplicado ✦", 2.5, true)
end
local PPresets = {
	["Nevasca"] = { PType = "Neve", PCount = 60, PSpeed = 45, PSize = 50, PWind = 10, PAlpha = 15, PColor = "Branco" },
	["Tempestade"] = { PType = "Chuva", PCount = 90, PSpeed = 80, PSize = 40, PWind = -30, PAlpha = 40, PColor = "Automática" },
	["Sakura"] = { PType = "Pétalas", PCount = 40, PSpeed = 40, PSize = 60, PWind = 25, PAlpha = 20, PColor = "Automática" },
	["Galáxia"] = { PType = "Estrelas", PCount = 70, PSpeed = 30, PSize = 45, PWind = 0, PAlpha = 10, PColor = "Arco-íris" },
	["Fogueira"] = { PType = "Brasas", PCount = 50, PSpeed = 60, PSize = 50, PWind = 8, PAlpha = 15, PColor = "Automática" },
	["Festa"] = { PType = "Confete", PCount = 60, PSpeed = 70, PSize = 60, PWind = 0, PAlpha = 10, PColor = "Aleatória" },
	["Oceano"] = { PType = "Bolhas", PCount = 35, PSpeed = 45, PSize = 60, PWind = 0, PAlpha = 30, PColor = "Automática" },
	["Hacker"] = { PType = "Matrix", PCount = 55, PSpeed = 70, PSize = 50, PWind = 0, PAlpha = 20, PColor = "Automática" },
	["Amor"] = { PType = "Corações", PCount = 35, PSpeed = 45, PSize = 70, PWind = 0, PAlpha = 15, PColor = "Automática" },
	["Inverno"] = { PType = "Flocos", PCount = 45, PSpeed = 35, PSize = 60, PWind = 15, PAlpha = 15, PColor = "Branco" },
}
local PPresetNames = { "Nevasca", "Tempestade", "Sakura", "Galáxia", "Fogueira", "Festa", "Oceano", "Hacker", "Amor", "Inverno" }
local function applyPPreset(nm)
	local p = PPresets[nm]
	if not p then return end
	if reg.PEnabled then reg.PEnabled(true) end
	for k, v in pairs(p) do if reg[k] then reg[k](v) else S[k] = v end end
end

---------------------------------------------------------------- PÁGINAS
local tPlayer = Lib:Tab("Jogador", "☻")
local tFruit = Lib:Tab("Blox Fruits", "🍎")
local tVis = Lib:Tab("Visual", "◉")
local tPart = Lib:Tab("Partículas", "✧")
local tStyle = Lib:Tab("Estilo", "✿")
local tUI = Lib:Tab("Botões e Abas", "▣")
local tIntro = Lib:Tab("Intro", "▶")
local tInfo = Lib:Tab("Info", "ⓘ")
local tCfg = Lib:Tab("Config", "✦")

-- Jogador
tPlayer:Section("Movimento")
tPlayer:Toggle("Velocidade personalizada", false, function(v) G.SpeedOn = v; if not v then local h = hum() if h then h.WalkSpeed = 16 end end end)
tPlayer:Slider("Velocidade", 16, 200, G.Speed, function(v) G.Speed = v end)
tPlayer:Toggle("Pulo personalizado", false, function(v) G.JumpOn = v; if not v then local h = hum() if h then h.JumpPower = 50 end end end)
tPlayer:Slider("Força do pulo", 50, 300, G.Jump, function(v) G.Jump = v end)
tPlayer:Toggle("Voar", false, function(v) G.Fly = v end)
tPlayer:Slider("Velocidade do voo", 20, 200, G.FlySpeed, function(v) G.FlySpeed = v end)
tPlayer:Toggle("Noclip", false, function(v) G.Noclip = v end)
tPlayer:Toggle("Pulo infinito", false, function(v) G.InfJump = v end)
tPlayer:Slider("Gravidade", 20, 300, 196, function(v) workspace.Gravity = v end)

-- Blox Fruits
tFruit:Section("Frutas")
tFruit:Toggle("Avisar quando aparecer fruta", false, function(v) G.FruitNotify = v end)
tFruit:Toggle("ESP de frutas", false, function(v) G.ESPF = v end)
tFruit:Button("Ir até a fruta mais próxima", function()
	local f = nearestFruit()
	if f then notify("Fruta", f.Name, 2.5); goTo(f.Handle.CFrame + Vector3.new(0, 3, 0)) else notify("Fruta", "Nenhuma fruta no mapa", 2.5) end
end)
tFruit:Section("Baús")
tFruit:Toggle("ESP de baús", false, function(v) G.ESPC = v end)
tFruit:Button("Ir até o baú mais próximo", function()
	local p = nearestChest()
	if p then goTo(CFrame.new(p + Vector3.new(0, 3, 0))) else notify("Baú", "Nenhum baú encontrado", 2.5) end
end)
tFruit:Section("Jogadores e mobs")
tFruit:Toggle("ESP de jogadores", false, function(v) G.ESPP = v end)
tFruit:Toggle("ESP de mobs (HP)", false, function(v) G.ESPM = v end)
tFruit:SToggle("Avisar entrada/saída de jogadores", "PlayerAlerts")
tFruit:Input("Observar jogador", "nome + Enter", function(t)
	local p = findPlayer(t)
	if p and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then cam.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid"); notify("Observando", p.DisplayName, 2.5)
	else notify("Observar", "Jogador não encontrado", 2.5) end
end)
tFruit:Input("Teleportar até jogador", "nome + Enter", function(t)
	local p, r = findPlayer(t), root()
	local hr = p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
	if hr and r then goTo(hr.CFrame + Vector3.new(0, 4, 0)) else notify("Teleporte", "Jogador não encontrado", 2.5) end
end)
tFruit:Button("Parar de observar", function() local h = hum() if h then cam.CameraSubject = h end end)
tFruit:Section("Waypoints (suas posições)")
tFruit:SDrop("Slot", { "1", "2", "3" }, "WPSlot")
tFruit:Button("Salvar posição atual no slot", function()
	local r = root()
	if r then
		local p = r.Position
		S["WP" .. S.WPSlot] = string.format("%.1f,%.1f,%.1f", p.X, p.Y, p.Z)
		notify("Waypoint", "Slot " .. S.WPSlot .. " salvo (use Salvar config p/ manter)", 3)
	end
end)
tFruit:Button("Ir para o slot", function()
	local v = wpGet(S.WPSlot)
	if v then goTo(CFrame.new(v + Vector3.new(0, 3, 0))) else notify("Waypoint", "Slot vazio", 2.5) end
end)
tFruit:Section("Mapa")
tFruit:Toggle("Andar na água", false, applyWater)
tFruit:Slider("Velocidade de viagem", 100, 600, G.Travel, function(v) G.Travel = v end, " st/s")
tFruit:Section("Servidor")
tFruit:Button("Server Hop", serverHop)
tFruit:Button("Reentrar no servidor", function() TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp) end)
tFruit:Button("Copiar ID do servidor", function()
	local ok = pcall(function() setclipboard(game.JobId) end)
	notify("Servidor", ok and "ID copiado!" or "Executor sem setclipboard", 2.5)
end)
tFruit:Input("Entrar por ID", "cole o ID + Enter", function(t) TPS:TeleportToPlaceInstance(game.PlaceId, t, lp) end)
tFruit:Button("Resetar personagem", function() local h = hum() if h then h.Health = 0 end end)
tFruit:SToggle("Reconectar automaticamente se cair", "AutoRejoin")

-- Visual
tVis:Section("Ambiente")
tVis:Toggle("Fullbright (claridade)", false, function(v) G.Fullbright = v; applyLight() end)
tVis:Toggle("Remover neblina", false, function(v) G.NoFog = v; applyLight() end)
tVis:Slider("Campo de visão", 30, 120, 70, function(v) cam.FieldOfView = v end)
tVis:Slider("Hora do dia", 0, 24, 14, function(v) Lighting.ClockTime = v end, "h")
tVis:Slider("Zoom máximo da câmera", 20, 500, 128, function(v) lp.CameraMaxZoomDistance = v end)
tVis:Button("Modo desempenho (menos lag)", boostFPS)
tVis:Section("Cores do jogo")
tVis:Slider("Saturação", -100, 100, 0, function(v) cc.Saturation = v / 100 end)
tVis:Slider("Contraste", -100, 100, 0, function(v) cc.Contrast = v / 100 end)
tVis:Slider("Brilho", -50, 50, 0, function(v) cc.Brightness = v / 100 end)
tVis:Slider("Bloom (brilho suave)", 0, 100, 0, function(v) bloom.Intensity = v / 40 end)
tVis:Section("Interface do jogo")
tVis:Toggle("Ocultar lista de jogadores", false, function(v) pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, not v) end) end)
tVis:Toggle("Ocultar chat", false, function(v) pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, not v) end) end)

-- Partículas
tPart:Section("Partículas caindo no painel")
tPart:SToggle("Ativar partículas", "PEnabled", function() rebuildParticles() end)
tPart:Dropdown("Preset rápido", PPresetNames, "—", applyPPreset)
tPart:SDrop("Tipo", PTypeNames, "PType", function() rebuildParticles() end)
tPart:SSlider("Quantidade", 0, 120, "PCount", function(v) adjustCount(v) end)
tPart:SSlider("Velocidade", 10, 300, "PSpeed", nil, "%")
tPart:SSlider("Tamanho", 10, 200, "PSize", function() rebuildParticles() end, "%")
tPart:SSlider("Vento (esq ← → dir)", -100, 100, "PWind")
tPart:SSlider("Balanço lateral", 0, 300, "PSway", nil, "%")
tPart:SSlider("Transparência", 0, 95, "PAlpha", nil, "%")
tPart:SToggle("Inverter direção (cair ↔ subir)", "PInvert", function() rebuildParticles() end)
tPart:SToggle("Girar partículas", "PSpin")
tPart:SToggle("Na frente do conteúdo", "PFront", function(v) pLayer.ZIndex = v and 9 or 1 end)
tPart:Section("Cor")
tPart:SDrop("Modo de cor", PColorNames, "PColor")
tPart:SSlider("Cor fixa — vermelho", 0, 255, "PR")
tPart:SSlider("Cor fixa — verde", 0, 255, "PG")
tPart:SSlider("Cor fixa — azul", 0, 255, "PB")
tPart:Section("Símbolo personalizado")
tPart:SInput("Símbolo (tipo 'Símbolo')", "PGlyph", function() if S.PType == "Símbolo" then rebuildParticles() end end)
tPart:Button("Explosão de partículas ✦", function() burst(main, 50, themeColor, 1.3) end)

-- Estilo
tStyle:Section("Estilos prontos")
tStyle:Dropdown("Aplicar estilo completo", StylePresetNames, "—", applyStylePreset)
tStyle:Section("Temas")
tStyle:ThemeGrid()

tStyle:Section("Editor de cores (tema Custom)")
local ed = { key = "a1", r = 10, g = 132, b = 255 }
local keyMap = { ["Fundo"] = "bg", ["Barra lateral"] = "side", ["Cards"] = "row", ["Texto"] = "text", ["Texto secundário"] = "sub", ["Destaque 1"] = "a1", ["Destaque 2"] = "a2" }
local keyNames = { "Fundo", "Barra lateral", "Cards", "Texto", "Texto secundário", "Destaque 1", "Destaque 2" }
local rS, gS, bS
local function loadEditor()
	local c = Themes.Custom[ed.key]
	ed.r, ed.g, ed.b = math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)
	rS(ed.r, false); gS(ed.g, false); bS(ed.b, false)
end
local function editorChanged()
	Themes.Custom[ed.key] = Color3.fromRGB(ed.r, ed.g, ed.b)
	if S.Theme ~= "Custom" then applyTheme("Custom") else for _, f in ipairs(binders) do f(0) end end
end
tStyle:Button("Copiar tema atual para o Custom", function()
	for k, v in pairs(T) do Themes.Custom[k] = v end
	applyTheme("Custom")
	loadEditor()
end)
tStyle:Dropdown("Editar cor de", keyNames, "Destaque 1", function(o) ed.key = keyMap[o]; loadEditor() end)
rS = tStyle:Slider("Vermelho", 0, 255, ed.r, function(v) ed.r = v; editorChanged() end)
gS = tStyle:Slider("Verde", 0, 255, ed.g, function(v) ed.g = v; editorChanged() end)
bS = tStyle:Slider("Azul", 0, 255, ed.b, function(v) ed.b = v; editorChanged() end)
tStyle:Input("Cor em HEX", "ex: #ff5599 + Enter", function(t)
	local ok, c = pcall(Color3.fromHex, t)
	if not ok then notify("Editor", "HEX inválido", 2.5, true) return end
	Themes.Custom[ed.key] = c
	if S.Theme ~= "Custom" then applyTheme("Custom") else for _, f in ipairs(binders) do f(0) end end
	loadEditor()
end)
tStyle:Toggle("Destaque arco-íris animado", S.Rainbow, function(v)
	S.Rainbow = v
	if v then for k, val in pairs(T) do Themes.Custom[k] = val end applyTheme("Custom") end
end)

tStyle:Section("Painel")
tStyle:SSlider("Transparência", 0, 60, "Opacity", function(v) main.BackgroundTransparency = v / 100 end, "%")
tStyle:SSlider("Tamanho", 55, 120, "Scale", function(v) tw(uscale, 0.25, { Scale = v / 100 }) end, "%")
tStyle:SSlider("Largura", 460, 760, "W", function() main.Size = UDim2.fromOffset(S.W, S.H) end)
tStyle:SSlider("Altura", 300, 480, "H", function() main.Size = UDim2.fromOffset(S.W, S.H) end)
tStyle:SSlider("Arredondamento", 0, 32, "Corner", function() setCorners() end)
tStyle:SSlider("Brilho do fundo", 0, 50, "Glow", function(v) glow.BackgroundTransparency = 1 - v / 100 end, "%")
tStyle:SToggle("Brilho giratório", "GlowSpin")
tStyle:SToggle("Auroras animadas no fundo", "Aurora", function(v) for _, f in ipairs(aur) do f.Visible = v end end)
tStyle:SToggle("Reflexo de vidro no topo", "Shine", function(v) shine.Visible = v end)
tStyle:SToggle("Borda gradiente", "BorderGlow", function(v) bStroke.Enabled = v end)
tStyle:SToggle("Borda gradiente girando", "BorderSpin")
tStyle:SToggle("Bordas de vidro", "Borders", function(v) for _, s in ipairs(strokes) do s.Enabled = v end end)
tStyle:SToggle("Desfocar o jogo atrás do painel", "Blur", function() updateBlur() end)
tStyle:SSlider("Intensidade do desfoque", 2, 30, "BlurSize", function() updateBlur() end)
tStyle:SToggle("Mostrar FPS e ping no topo", "ShowFPS", function(v) fpsLbl.Visible = v end)
tStyle:SToggle("Notificações", "Notifs")
tStyle:Input("Nome do painel", "digite e dê Enter", function(t) S.Title = t; titleLbl.Text = t end)
tStyle:SDrop("Tecla de atalho (PC)", { "RightShift", "RightControl", "Insert", "K", "M" }, "Key")
tStyle:Section("Transição entre abas")
tStyle:SDrop("Tipo", TRANS, "Transition")
tStyle:SDrop("Suavização", EASES, "Easing")
tStyle:SSlider("Duração", 100, 1000, "TransTime", nil, " ms")
tStyle:Section("Fonte do painel")
tStyle:FontGrid()

-- Botões e Abas
tUI:Section("Botões")
tUI:SDrop("Estilo do botão", { "Gradiente", "Sólido", "Vidro", "Contorno", "Neon" }, "BtnStyle", function() restyleBtns() end)
tUI:SSlider("Altura do botão", 30, 60, "BtnH", function() restyleBtns() end)
tUI:SSlider("Arredondamento do botão", 0, 30, "BtnCorner", function() restyleBtns() end)
tUI:SSlider("Tamanho do texto", 10, 20, "BtnText", function() restyleBtns() end)
tUI:SToggle("Efeito de onda ao tocar", "BtnRipple")
tUI:Button("Testar botão ✦", function() burst(main, 30, themeColor, 1); notify("Botão", "Estilo: " .. S.BtnStyle, 2, true) end)
tUI:Section("Abas (barra lateral)")
tUI:SDrop("Estilo da aba", { "Pílula", "Linha", "Contorno", "Brilho" }, "TabStyle", function() layoutTabs() end)
tUI:SSlider("Altura da aba", 26, 46, "TabH", function() layoutTabs() end)
tUI:SSlider("Tamanho do texto da aba", 10, 17, "TabText", function() layoutTabs() end)
tUI:SSlider("Largura da barra lateral", 90, 190, "SideW", function() layoutTabs() end)
tUI:SToggle("Mostrar ícones", "TabIcons", function() layoutTabs() end)
tUI:SDrop("Alinhamento", { "Esquerda", "Centro" }, "TabAlign", function() layoutTabs() end)
tUI:Section("Botão flutuante (bolha)")
tUI:SSlider("Tamanho da bolha", 36, 90, "BubbleSize", function() applyBubble() end)
tUI:SToggle("Pulso animado", "BubblePulse", function() applyBubble() end)
tUI:SInput("Letra/emoji da bolha", "BubbleChar", function() applyBubble() end)

-- Intro
tIntro:Section("Intro de abertura")
tIntro:SToggle("Ativar intro ao executar", "IntroOn")
tIntro:Button("▶ Testar intro agora", function() playIntro() end)
tIntro:SDrop("Estilo", { "Cinema", "Neon", "Glitch", "Minimal" }, "IntroStyle")
tIntro:SInput("Título", "IntroTitle")
tIntro:SInput("Subtítulo", "IntroSub")
tIntro:SInput("Logo (letra ou emoji)", "IntroLogo")
tIntro:SSlider("Duração", 2, 10, "IntroTime", nil, " s")
tIntro:SSlider("Anéis de onda", 0, 6, "IntroRings")
tIntro:SSlider("Partículas da explosão", 0, 100, "IntroBurst")
tIntro:SSlider("Escuridão do fundo", 0, 100, "IntroBG", nil, "%")
tIntro:SToggle("Desfocar o jogo na intro", "IntroBlur")
tIntro:SToggle("Cores arco-íris na intro", "IntroRainbow")
tIntro:SToggle("Barra de progresso", "IntroBar")
tIntro:SToggle("Tocar para pular", "IntroSkip")

-- Info
tInfo:Section("Conta")
tInfo:Info("Usuário", function() return lp.DisplayName .. " (@" .. lp.Name .. ")" end)
tInfo:Info("ID", function() return tostring(lp.UserId) end)
tInfo:Info("Idade da conta", function() return lp.AccountAge .. " dias" end)
tInfo:Section("Blox Fruits")
tInfo:Info("Mar atual", function()
	local id = game.PlaceId
	return id == 2753915549 and "Primeiro Mar" or id == 4442272183 and "Segundo Mar" or id == 7449423635 and "Terceiro Mar" or "Desconhecido"
end)
tInfo:Info("Level", function() local v = dataVal("Level") return v and commas(v) or "—" end)
tInfo:Info("Beli", function() local v = dataVal("Beli") return v and commas(v) or "—" end)
tInfo:Info("Beli na sessão", function()
	local v = dataVal("Beli")
	startBeli = startBeli or v
	return (v and startBeli) and ((v - startBeli >= 0 and "+" or "") .. commas(v - startBeli)) or "—"
end)
tInfo:Info("Fragmentos", function() local v = dataVal("Fragments") return v and commas(v) or "—" end)
tInfo:Info("Fruta equipada", function() local v = dataVal("DevilFruit") return (v and v ~= "") and tostring(v) or "—" end)
tInfo:Section("Sessão")
tInfo:Info("Posição", function() local r = root() return r and string.format("%d, %d, %d", r.Position.X, r.Position.Y, r.Position.Z) or "—" end)
tInfo:Info("Jogadores", function() return #Players:GetPlayers() .. "/" .. Players.MaxPlayers end)
tInfo:Info("Jogador mais próximo", function()
	local best, bd
	for _, p in ipairs(Players:GetPlayers()) do
		local hr = p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		if hr then local d = dist(hr.Position); if not bd or d < bd then best, bd = p, d end end
	end
	return best and (best.DisplayName .. " (" .. bd .. "m)") or "—"
end)
tInfo:Info("Ping", function() return getPing() .. " ms" end)
tInfo:Info("Tempo de sessão", function() local s = tick() - startTick return string.format("%02d:%02d:%02d", s // 3600, s % 3600 // 60, s % 60) end)
tInfo:Info("Executor", function() local ok, n = pcall(identifyexecutor) return ok and tostring(n) or "Desconhecido" end)
tInfo:Info("Dispositivo", function() return (UIS.TouchEnabled and not UIS.KeyboardEnabled) and "Celular / Tablet" or "PC" end)

-- Config
tCfg:Section("Configuração")
tCfg:Button("Salvar aparência e ajustes", saveCfg)
tCfg:Button("Apagar config salva", function()
	local ok = pcall(function() if isfile(CFG) then delfile(CFG) end end)
	notify("Config", ok and "Config apagada." or "Não foi possível apagar.", 3, true)
end)
tCfg:Slider("Limite de FPS", 30, 360, 60, function(v) pcall(function() setfpscap(v) end) end)
tCfg:Label("Anti-AFK sempre ligado. No celular, minimize pela bolinha amarela e reabra tocando na bolha.")
tCfg:Button("Fechar e descarregar painel", unload)

---------------------------------------------------------------- LOOPS DA INTERFACE
local frames = 0
conn(RS.RenderStepped:Connect(function() frames += 1 end))
loop(1, function()
	fpsLbl.Text = frames .. " FPS  •  " .. getPing() .. " ms"
	frames = 0
	for _, r in ipairs(infoRows) do
		local ok, v = pcall(r[2])
		r[1].Text = ok and tostring(v) or "—"
	end
end)
local hue = 0
task.spawn(function()
	while alive do
		task.wait(0.05)
		if S.GlowSpin then glowG.Rotation = (glowG.Rotation + 2) % 360 end
		if S.BorderGlow and S.BorderSpin then bG.Rotation = (bG.Rotation + 3) % 360 end
		if S.Rainbow then
			hue = (hue + 0.008) % 1
			Themes.Custom.a1 = Color3.fromHSV(hue, 0.7, 1)
			Themes.Custom.a2 = Color3.fromHSV((hue + 0.12) % 1, 0.7, 1)
			if T == Themes.Custom then for _, f in ipairs(fast) do f(0) end end
		end
	end
end)

---------------------------------------------------------------- ABERTURA
applyTheme(S.Theme)
loadEditor()
setFont(S.Font)
setCorners()
applyBubble()
layoutTabs()
rebuildParticles()
switchTab("Jogador")
styleIndicator()
for _, f in ipairs(aur) do f.Visible = S.Aurora end
if S.IntroOn then
	playIntro(function() showMain(); notify("Apple Panel v5", "Carregado! Bom jogo ✦", 3) end)
else
	showMain()
	task.delay(0.7, function() notify("Apple Panel v5", "Carregado! Bom jogo ✦", 3) end)
end
