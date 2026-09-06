--[[
    ============================================================
             NANESK HUB - FULL PLAYERS TAB & OPTIMIZED SOURCE
    ============================================================
]]

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local InsertService = game:GetService("InsertService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")

--// PLAYER
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// CLEAN OLD GUI
if PlayerGui:FindFirstChild("NaneskHub") then
    PlayerGui.NaneskHub:Destroy()
end

--// ASSETS & CONFIG
local LOGO_DECAL_ID = "78375229609878"
local BACKGROUND_ID = "rbxassetid://118061923730244"

--// LIGHTWEIGHT BLUE & THEMES CONFIG
local THEMES = {
    ["Nebula Blue"]    = {Bg = Color3.fromRGB(15, 20, 28),  Card = Color3.fromRGB(45, 50, 65),  Accent = Color3.fromRGB(0, 150, 255), Text = Color3.fromRGB(240, 245, 255)},
    ["Nitro Frost"]    = {Bg = Color3.fromRGB(12, 24, 34),  Card = Color3.fromRGB(45, 60, 75),  Accent = Color3.fromRGB(0, 210, 255), Text = Color3.fromRGB(240, 250, 255)},
    ["Circuit Rush"]   = {Bg = Color3.fromRGB(18, 22, 20),  Card = Color3.fromRGB(45, 55, 50),  Accent = Color3.fromRGB(0, 230, 118), Text = Color3.fromRGB(240, 255, 245)},
    ["Kinetic Energy"] = {Bg = Color3.fromRGB(25, 20, 14),  Card = Color3.fromRGB(60, 50, 42),  Accent = Color3.fromRGB(255, 150, 0), Text = Color3.fromRGB(255, 248, 240)},
    ["Inferno Blast"]  = {Bg = Color3.fromRGB(28, 14, 16),  Card = Color3.fromRGB(65, 45, 48),  Accent = Color3.fromRGB(255, 55, 70),  Text = Color3.fromRGB(255, 240, 242)},
    ["Hyper Plum"]     = {Bg = Color3.fromRGB(22, 14, 28),  Card = Color3.fromRGB(55, 42, 65),  Accent = Color3.fromRGB(180, 70, 255), Text = Color3.fromRGB(250, 240, 255)},
    ["Quantum Pulse"]  = {Bg = Color3.fromRGB(10, 25, 28),  Card = Color3.fromRGB(40, 60, 65),  Accent = Color3.fromRGB(0, 230, 180), Text = Color3.fromRGB(240, 255, 252)},
    ["Cosmic Dust"]    = {Bg = Color3.fromRGB(220, 225, 240), Card = Color3.fromRGB(180, 190, 210), Accent = Color3.fromRGB(70, 80, 210),   Text = Color3.fromRGB(25, 30, 45)},
    ["Polar Freeze"]   = {Bg = Color3.fromRGB(215, 235, 250), Card = Color3.fromRGB(175, 205, 225), Accent = Color3.fromRGB(0, 130, 220),   Text = Color3.fromRGB(15, 35, 55)},
    ["Super Charge"]   = {Bg = Color3.fromRGB(245, 238, 210), Card = Color3.fromRGB(210, 200, 170), Accent = Color3.fromRGB(220, 130, 0),   Text = Color3.fromRGB(45, 30, 10)},
    ["Electric Lime"]  = {Bg = Color3.fromRGB(220, 242, 215), Card = Color3.fromRGB(180, 210, 175), Accent = Color3.fromRGB(35, 165, 55),   Text = Color3.fromRGB(15, 40, 20)},
    ["Lava Glow"]      = {Bg = Color3.fromRGB(248, 222, 218), Card = Color3.fromRGB(215, 180, 175), Accent = Color3.fromRGB(225, 55, 25),   Text = Color3.fromRGB(50, 15, 10)},
    ["Star Burst"]     = {Bg = Color3.fromRGB(248, 225, 242), Card = Color3.fromRGB(215, 180, 205), Accent = Color3.fromRGB(205, 40, 130),  Text = Color3.fromRGB(50, 10, 35)},
    ["Pixel Pop"]      = {Bg = Color3.fromRGB(228, 228, 238), Card = Color3.fromRGB(190, 190, 210), Accent = Color3.fromRGB(100, 45, 200),  Text = Color3.fromRGB(30, 20, 45)},
}

local CurrentTheme = THEMES["Nebula Blue"]
local TargetScale = 1.0

--// SECURITY & PROTECTION VARIABLES
local AntiAFKEnabled = true
local AntiFlingEnabled = false
local AntiKickEnabled = true
local AntiVirusEnabled = true

Player.Idled:Connect(function()
    if AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.zero)
    end
end)

local oldKick
pcall(function()
    if hookmetamethod then
        oldKick = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if AntiKickEnabled and self == Player and (method == "Kick" or method == "kick") then
                warn("[Nanesk Hub Security]: Intercepted kick attempt.")
                return nil
            end
            return oldKick(self, ...)
        end)
    end
end)

RunService.Stepped:Connect(function()
    if AntiFlingEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= Player and otherPlayer.Character then
                for _, part in ipairs(otherPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Velocity = Vector3.zero
                        part.RotVelocity = Vector3.zero
                    end
                end
            end
        end
    end
end)

local function executeSafe(code)
    if AntiVirusEnabled then
        local dangerousKeywords = {"setclipboard", "writefile", "delfile", "appendfile", "rmdir"}
        for _, word in ipairs(dangerousKeywords) do
            if string.find(string.lower(code), word) then
                warn("[Nanesk Hub Anti-Virus]: Flagged function (" .. word .. ").")
            end
        end
    end

    local success, err = pcall(function()
        local func = loadstring(code)
        if func then func() else error("Syntax Error") end
    end)
    if not success then
        warn("[Nanesk Hub Protection]: Failed to run script: " .. tostring(err))
    end
end

-- ====================================================================
-- GAME INFO & API MODULES
-- ====================================================================
local function getGameInformation()
    local success, result = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    
    if success and result then
        return {
            Name = result.Name or "Unknown Game",
            Creator = (result.Creator and result.Creator.Name) or "Unknown",
            ID = tostring(game.PlaceId),
            Icon = "rbxassetid://" .. tostring(result.IconImageAssetId or 0)
        }
    else
        return {
            Name = "Unknown Game",
            Creator = "Unknown",
            ID = tostring(game.PlaceId),
            Icon = "rbxassetid://0"
        }
    end
end

local NguonHienTai = "ScriptBlox"

local function fetchScriptBlox(searchQuery)
    local encodedQuery = HttpService:UrlEncode(searchQuery)
    local url = "https://scriptblox.com/api/script/search?q=" .. encodedQuery .. "&mode=free&page=1"
    local success, response = pcall(function() return game:HttpGet(url) end)
    if success and response then
        local jsonSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
        if jsonSuccess and data and data.result and data.result.scripts then
            return data.result.scripts
        end
    end
    return nil
end

local function fetchRscripts(searchQuery)
    local encodedQuery = HttpService:UrlEncode(searchQuery)
    local url = "https://rscripts.net/api/v2/scripts?q=" .. encodedQuery .. "&page=1&limit=15"
    local success, response = pcall(function() return game:HttpGet(url) end)
    if success and response then
        local jsonSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
        if jsonSuccess and data and data.scripts then
            return data.scripts
        end
    end
    return nil
end

--// GUI HELPERS
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NaneskHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local function CreateCorner(Parent, Radius)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, Radius)
    Corner.Parent = Parent
    return Corner
end

local function CreateStroke(Parent, Color, Thickness)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color
    Stroke.Thickness = Thickness
    Stroke.Parent = Parent
    return Stroke
end

local function Tween(Object, Time, Properties, EasingStyle, EasingDirection)
    local Style = EasingStyle or Enum.EasingStyle.Quint
    local Direction = EasingDirection or Enum.EasingDirection.Out
    local T = TweenService:Create(Object, TweenInfo.new(Time, Style, Direction), Properties)
    T:Play()
    return T
end

--// MAIN HUB FRAME
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0.68, 0, 0.72, 0)
Main.BackgroundColor3 = CurrentTheme.Bg
Main.BorderSizePixel = 0
CreateCorner(Main, 14)
local MainStroke = CreateStroke(Main, CurrentTheme.Accent, 1.5)

local HubBackground = Instance.new("ImageLabel")
HubBackground.Parent = Main
HubBackground.Size = UDim2.new(1, 0, 1, 0)
HubBackground.BackgroundTransparency = 1
HubBackground.Image = BACKGROUND_ID
HubBackground.ImageTransparency = 0.45
HubBackground.ScaleType = Enum.ScaleType.Crop
CreateCorner(HubBackground, 14)

local HubOverlay = Instance.new("Frame")
HubOverlay.Parent = Main
HubOverlay.Size = UDim2.new(1, 0, 1, 0)
HubOverlay.BackgroundColor3 = CurrentTheme.Accent
HubOverlay.BackgroundTransparency = 0.75
CreateCorner(HubOverlay, 14)

local MainScale = Instance.new("UIScale")
MainScale.Scale = TargetScale
MainScale.Parent = Main

--// HEADER
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = Main
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 55)

local LogoFrame = Instance.new("Frame")
LogoFrame.Parent = Header
LogoFrame.Position = UDim2.new(0, 12, 0, 8)
LogoFrame.Size = UDim2.new(0, 40, 0, 40)
LogoFrame.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
LogoFrame.ClipsDescendants = true
CreateCorner(LogoFrame, 10)

local LogoFallbackText = Instance.new("TextLabel")
LogoFallbackText.Parent = LogoFrame
LogoFallbackText.Size = UDim2.new(1, 0, 1, 0)
LogoFallbackText.BackgroundTransparency = 1
LogoFallbackText.Text = "N"
LogoFallbackText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoFallbackText.Font = Enum.Font.GothamBold
LogoFallbackText.TextSize = 22

local LogoImg = Instance.new("ImageLabel")
LogoImg.Parent = LogoFrame
LogoImg.Size = UDim2.new(1, 0, 1, 0)
LogoImg.BackgroundTransparency = 1

task.spawn(function()
    local success, model = pcall(function() return InsertService:LoadAsset(LOGO_DECAL_ID) end)
    if success and model then
        local decal = model:FindFirstChildOfClass("Decal")
        if decal then LogoImg.Image = decal.Texture end
        model:Destroy()
    else
        LogoImg.Image = "rbxthumb://type=Asset&id=" .. LOGO_DECAL_ID .. "&w=420&h=420"
    end
end)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 60, 0, 8)
Title.Size = UDim2.new(0, 200, 0, 20)
Title.Text = "Nanesk Hub"
Title.TextColor3 = CurrentTheme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Parent = Header
StatsLabel.BackgroundTransparency = 1
StatsLabel.Position = UDim2.new(0, 60, 0, 28)
StatsLabel.Size = UDim2.new(0, 300, 0, 16)
StatsLabel.Text = "Ping: -- ms | FPS: -- | library friendly"
StatsLabel.TextColor3 = CurrentTheme.Text
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextSize = 11
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Header
CloseButton.AnchorPoint = Vector2.new(1, 0)
CloseButton.Position = UDim2.new(1, -12, 0, 10)
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.BackgroundColor3 = CurrentTheme.Card
CloseButton.BackgroundTransparency = 0.75
CloseButton.Text = "🔲"
CloseButton.TextColor3 = CurrentTheme.Text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 12
CreateCorner(CloseButton, 8)

--// SIDEBAR & TAB REGISTER
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = Main
Sidebar.BackgroundTransparency = 1
Sidebar.Position = UDim2.new(0, 12, 0, 55)
Sidebar.Size = UDim2.new(0, 115, 1, -65)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.Padding = UDim.new(0, 8)

local TabButtons = {}
local DynamicElements = {}

local function RegisterDynamicElement(Element, StyleType)
    table.insert(DynamicElements, {Instance = Element, Style = StyleType})
end

local function CreateTabBtn(Name, DisplayText)
    local Button = Instance.new("TextButton")
    Button.Name = Name
    Button.Parent = Sidebar
    Button.Size = UDim2.new(1, 0, 0, 34)
    Button.BackgroundColor3 = CurrentTheme.Card
    Button.BackgroundTransparency = 0.75
    Button.Text = DisplayText
    Button.TextColor3 = CurrentTheme.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    CreateCorner(Button, 8)
    TabButtons[Name] = Button
    return Button
end

local GamesTabBtn = CreateTabBtn("Games", "Games 📱")
local LibraryTabBtn = CreateTabBtn("Library", "Library📖")
local PlayersTabBtn = CreateTabBtn("Players", "Players👤")
local SettingsTabBtn = CreateTabBtn("Settings", "Settings ⚙️")

--// CONTENT CONTAINER
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = Main
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 135, 0, 55)
ContentContainer.Size = UDim2.new(1, -147, 1, -65)

--// RIGHT SLIDING INFO DRAWER
local InfoDrawer = Instance.new("Frame")
InfoDrawer.Parent = Main
InfoDrawer.Size = UDim2.new(0, 175, 0, 180)
InfoDrawer.Position = UDim2.new(1, -10, 0, 55)
InfoDrawer.BackgroundColor3 = CurrentTheme.Card
InfoDrawer.BackgroundTransparency = 0.25
InfoDrawer.Visible = false
InfoDrawer.ZIndex = 10
CreateCorner(InfoDrawer, 10)
local DrawerStroke = CreateStroke(InfoDrawer, CurrentTheme.Accent, 1.5)
RegisterDynamicElement(InfoDrawer, "Card")

local DrawerTitle = Instance.new("TextLabel")
DrawerTitle.Parent = InfoDrawer
DrawerTitle.Position = UDim2.new(0, 10, 0, 8)
DrawerTitle.Size = UDim2.new(1, -20, 0, 22)
DrawerTitle.BackgroundTransparency = 1
DrawerTitle.Text = "ℹ️ Information"
DrawerTitle.TextColor3 = CurrentTheme.Accent
DrawerTitle.Font = Enum.Font.GothamBold
DrawerTitle.TextSize = 12
DrawerTitle.TextXAlignment = Enum.TextXAlignment.Left
RegisterDynamicElement(DrawerTitle, "AccentText")

local InfoListContainer = Instance.new("Frame")
InfoListContainer.Parent = InfoDrawer
InfoListContainer.Position = UDim2.new(0, 10, 0, 34)
InfoListContainer.Size = UDim2.new(1, -20, 1, -42)
InfoListContainer.BackgroundTransparency = 1

local InfoContainerLayout = Instance.new("UIListLayout")
InfoContainerLayout.Parent = InfoListContainer
InfoContainerLayout.Padding = UDim.new(0, 6)

local function CreateInfoLine(LabelName)
    local Line = Instance.new("TextLabel")
    Line.Parent = InfoListContainer
    Line.Size = UDim2.new(1, 0, 0, 20)
    Line.BackgroundTransparency = 1
    Line.Text = LabelName .. ": --"
    Line.TextColor3 = CurrentTheme.Text
    Line.Font = Enum.Font.Gotham
    Line.TextSize = 10
    Line.TextXAlignment = Enum.TextXAlignment.Left
    RegisterDynamicElement(Line, "Text")
    return Line
end

local StatusLine = CreateInfoLine("Status")
local KeyLine = CreateInfoLine("Key")
local SupportLine = CreateInfoLine("Support")
local NoteLine = CreateInfoLine("Note")

local CurrentInfoScript = nil
local DrawerOpen = false

local function ToggleInfoDrawer(ScriptName, InfoData)
    if DrawerOpen and CurrentInfoScript == ScriptName then
        DrawerOpen = false
        Tween(InfoDrawer, 0.3, {Position = UDim2.new(1, -10, 0, 55)})
        task.wait(0.3)
        if not DrawerOpen then InfoDrawer.Visible = false end
    else
        CurrentInfoScript = ScriptName
        DrawerTitle.Text = "ℹ️ " .. string.sub(ScriptName, 1, 16)
        StatusLine.Text = "Status: " .. (InfoData.Status or "Working 🟢")
        KeyLine.Text = "Key: " .. (InfoData.Key or "Free / No Key 🔓")
        SupportLine.Text = "Support: " .. (InfoData.Support or "PC & Mobile 📱")
        NoteLine.Text = "Note: " .. (InfoData.Note or "Safe to execute")

        InfoDrawer.Visible = true
        DrawerOpen = true
        Tween(InfoDrawer, 0.35, {Position = UDim2.new(1, 12, 0, 55)}, Enum.EasingStyle.Back)
    end
end

--==============================================================
-- 1. GAMES PAGE
--==============================================================
local GamesPage = Instance.new("Frame")
GamesPage.Name = "GamesPage"
GamesPage.Parent = ContentContainer
GamesPage.BackgroundTransparency = 1
GamesPage.Size = UDim2.new(1, 0, 1, 0)
GamesPage.Visible = true

local GameInfoPanel = Instance.new("Frame")
GameInfoPanel.Parent = GamesPage
GameInfoPanel.Size = UDim2.new(1, -6, 0, 130)
GameInfoPanel.BackgroundColor3 = CurrentTheme.Card
GameInfoPanel.BackgroundTransparency = 0.65
CreateCorner(GameInfoPanel, 10)
local InfoPanelStroke = CreateStroke(GameInfoPanel, CurrentTheme.Accent, 1.2)
RegisterDynamicElement(GameInfoPanel, "Card")

local KhungAnhGame = Instance.new("ImageLabel")
KhungAnhGame.Parent = GameInfoPanel
KhungAnhGame.Position = UDim2.new(0, 12, 0, 12)
KhungAnhGame.Size = UDim2.new(0, 106, 0, 106)
KhungAnhGame.BackgroundColor3 = CurrentTheme.Bg
KhungAnhGame.BackgroundTransparency = 0.3
KhungAnhGame.ScaleType = Enum.ScaleType.Fit
KhungAnhGame.Image = "rbxassetid://0"
CreateCorner(KhungAnhGame, 10)
local IconStroke = CreateStroke(KhungAnhGame, CurrentTheme.Accent, 1)

local TextContainer = Instance.new("Frame")
TextContainer.Parent = GameInfoPanel
TextContainer.Position = UDim2.new(0, 130, 0, 12)
TextContainer.Size = UDim2.new(1, -142, 1, -24)
TextContainer.BackgroundTransparency = 1

local TextLayout = Instance.new("UIListLayout")
TextLayout.Parent = TextContainer
TextLayout.Padding = UDim.new(0, 8)

local TenGameLabel = Instance.new("TextLabel")
TenGameLabel.Parent = TextContainer
TenGameLabel.Size = UDim2.new(1, 0, 0, 26)
TenGameLabel.BackgroundTransparency = 1
TenGameLabel.Text = "🎮 Game: Loading..."
TenGameLabel.TextColor3 = CurrentTheme.Accent
TenGameLabel.Font = Enum.Font.GothamBold
TenGameLabel.TextSize = 13
TenGameLabel.TextXAlignment = Enum.TextXAlignment.Left
RegisterDynamicElement(TenGameLabel, "AccentText")

local TacGiaLabel = Instance.new("TextLabel")
TacGiaLabel.Parent = TextContainer
TacGiaLabel.Size = UDim2.new(1, 0, 0, 22)
TacGiaLabel.BackgroundTransparency = 1
TacGiaLabel.Text = "👑 Developer: Loading..."
TacGiaLabel.TextColor3 = CurrentTheme.Text
TacGiaLabel.Font = Enum.Font.Gotham
TacGiaLabel.TextSize = 12
TacGiaLabel.TextXAlignment = Enum.TextXAlignment.Left
RegisterDynamicElement(TacGiaLabel, "Text")

local IdGameLabel = Instance.new("TextLabel")
IdGameLabel.Parent = TextContainer
IdGameLabel.Size = UDim2.new(1, 0, 0, 22)
IdGameLabel.BackgroundTransparency = 1
IdGameLabel.Text = "🆔 Place ID: Loading..."
IdGameLabel.TextColor3 = CurrentTheme.Text
IdGameLabel.Font = Enum.Font.Gotham
IdGameLabel.TextSize = 11
IdGameLabel.TextXAlignment = Enum.TextXAlignment.Left
RegisterDynamicElement(IdGameLabel, "Text")

task.spawn(function()
    local gameInfo = getGameInformation()
    TenGameLabel.Text = "🎮 Game: " .. gameInfo.Name
    TacGiaLabel.Text = "👑 Developer: " .. gameInfo.Creator
    IdGameLabel.Text = "🆔 Place ID: " .. gameInfo.ID
    KhungAnhGame.Image = gameInfo.Icon
end)

--==============================================================
-- 2. LIBRARY TAB
--==============================================================
local LibraryPage = Instance.new("Frame")
LibraryPage.Name = "LibraryPage"
LibraryPage.Parent = ContentContainer
LibraryPage.BackgroundTransparency = 1
LibraryPage.Size = UDim2.new(1, 0, 1, 0)
LibraryPage.Visible = false

local LibrarySourceFrame = Instance.new("Frame")
LibrarySourceFrame.Parent = LibraryPage
LibrarySourceFrame.Size = UDim2.new(1, -6, 0, 32)
LibrarySourceFrame.BackgroundTransparency = 1

local Nutz_ScriptBlox_Cua_Bro = Instance.new("TextButton")
Nutz_ScriptBlox_Cua_Bro.Parent = LibrarySourceFrame
Nutz_ScriptBlox_Cua_Bro.Size = UDim2.new(0.48, 0, 1, 0)
Nutz_ScriptBlox_Cua_Bro.Text = "🌐 ScriptBlox"
Nutz_ScriptBlox_Cua_Bro.Font = Enum.Font.GothamBold
Nutz_ScriptBlox_Cua_Bro.TextSize = 12
CreateCorner(Nutz_ScriptBlox_Cua_Bro, 8)

local Nutz_Rscripts_Cua_Bro = Instance.new("TextButton")
Nutz_Rscripts_Cua_Bro.Parent = LibrarySourceFrame
Nutz_Rscripts_Cua_Bro.Position = UDim2.new(0.52, 0, 0, 0)
Nutz_Rscripts_Cua_Bro.Size = UDim2.new(0.48, 0, 1, 0)
Nutz_Rscripts_Cua_Bro.Text = "⚡ Rscripts"
Nutz_Rscripts_Cua_Bro.Font = Enum.Font.GothamBold
Nutz_Rscripts_Cua_Bro.TextSize = 12
CreateCorner(Nutz_Rscripts_Cua_Bro, 8)

local LibrarySearchFrame = Instance.new("Frame")
LibrarySearchFrame.Parent = LibraryPage
LibrarySearchFrame.Position = UDim2.new(0, 0, 0, 38)
LibrarySearchFrame.Size = UDim2.new(1, -6, 0, 32)
LibrarySearchFrame.BackgroundColor3 = CurrentTheme.Card
LibrarySearchFrame.BackgroundTransparency = 0.75
CreateCorner(LibrarySearchFrame, 8)
RegisterDynamicElement(LibrarySearchFrame, "Card")

local LibrarySearchIcon = Instance.new("TextLabel")
LibrarySearchIcon.Parent = LibrarySearchFrame
LibrarySearchIcon.Size = UDim2.new(0, 30, 1, 0)
LibrarySearchIcon.BackgroundTransparency = 1
LibrarySearchIcon.Text = "📖"
LibrarySearchIcon.TextSize = 12

local O_TextBox_Search_Cua_Bro = Instance.new("TextBox")
O_TextBox_Search_Cua_Bro.Parent = LibrarySearchFrame
O_TextBox_Search_Cua_Bro.Position = UDim2.new(0, 30, 0, 0)
O_TextBox_Search_Cua_Bro.Size = UDim2.new(1, -35, 1, 0)
O_TextBox_Search_Cua_Bro.BackgroundTransparency = 1
O_TextBox_Search_Cua_Bro.PlaceholderText = "Search ScriptBlox API (Press Enter)..."
O_TextBox_Search_Cua_Bro.Text = ""
O_TextBox_Search_Cua_Bro.TextColor3 = CurrentTheme.Text
O_TextBox_Search_Cua_Bro.Font = Enum.Font.Gotham
O_TextBox_Search_Cua_Bro.TextSize = 12
O_TextBox_Search_Cua_Bro.TextXAlignment = Enum.TextXAlignment.Left
RegisterDynamicElement(O_TextBox_Search_Cua_Bro, "Text")

local LibraryScroll = Instance.new("ScrollingFrame")
LibraryScroll.Parent = LibraryPage
LibraryScroll.Position = UDim2.new(0, 0, 0, 76)
LibraryScroll.Size = UDim2.new(1, 0, 1, -76)
LibraryScroll.BackgroundTransparency = 1
LibraryScroll.ScrollBarThickness = 3
LibraryScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
LibraryScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local LibraryGrid = Instance.new("Frame")
LibraryGrid.Parent = LibraryScroll
LibraryGrid.Size = UDim2.new(1, -6, 0, 0)
LibraryGrid.BackgroundTransparency = 1

local LibraryGridLayout = Instance.new("UIGridLayout")
LibraryGridLayout.Parent = LibraryGrid
LibraryGridLayout.CellSize = UDim2.new(0.48, 0, 0, 34)
LibraryGridLayout.CellPadding = UDim2.new(0.04, 0, 0, 6)

LibraryGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    LibraryGrid.Size = UDim2.new(1, -6, 0, LibraryGridLayout.AbsoluteContentSize.Y)
end)

local function UpdateSourceButtonsUI()
    local isSB = (NguonHienTai == "ScriptBlox")
    
    Nutz_ScriptBlox_Cua_Bro.BackgroundColor3 = isSB and Color3.fromRGB(52, 152, 219) or Color3.fromRGB(41, 128, 185)
    Nutz_ScriptBlox_Cua_Bro.BackgroundTransparency = isSB and 0.2 or 0.8
    Nutz_ScriptBlox_Cua_Bro.TextColor3 = isSB and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 200, 220)

    Nutz_Rscripts_Cua_Bro.BackgroundColor3 = not isSB and Color3.fromRGB(52, 152, 219) or Color3.fromRGB(41, 128, 185)
    Nutz_Rscripts_Cua_Bro.BackgroundTransparency = not isSB and 0.2 or 0.8
    Nutz_Rscripts_Cua_Bro.TextColor3 = not isSB and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 200, 220)

    O_TextBox_Search_Cua_Bro.PlaceholderText = "Search " .. NguonHienTai .. " API (Press Enter)..."
end

Nutz_ScriptBlox_Cua_Bro.MouseButton1Click:Connect(function()
    NguonHienTai = "ScriptBlox"
    UpdateSourceButtonsUI()
end)

Nutz_Rscripts_Cua_Bro.MouseButton1Click:Connect(function()
    NguonHienTai = "Rscripts"
    UpdateSourceButtonsUI()
end)

UpdateSourceButtonsUI()

O_TextBox_Search_Cua_Bro.FocusLost:Connect(function(enterPressed)
    if enterPressed and O_TextBox_Search_Cua_Bro.Text ~= "" then
        local tuKhoa = O_TextBox_Search_Cua_Bro.Text
        local danhSachScript = (NguonHienTai == "ScriptBlox") and fetchScriptBlox(tuKhoa) or fetchRscripts(tuKhoa)

        for _, child in ipairs(LibraryGrid:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end

        if not danhSachScript or #danhSachScript == 0 then
            local emptyMsg = Instance.new("TextLabel")
            emptyMsg.Parent = LibraryGrid
            emptyMsg.Size = UDim2.new(1, 0, 0, 30)
            emptyMsg.BackgroundTransparency = 1
            emptyMsg.Text = "No scripts found on " .. NguonHienTai
            emptyMsg.TextColor3 = CurrentTheme.Text
            emptyMsg.Font = Enum.Font.Gotham
            emptyMsg.TextSize = 12
            return
        end

        for _, item in ipairs(danhSachScript) do
            local title = item.title or item.name or "Script"
            local scriptCode = item.script or item.rawScript or item.downloadUrl or ""
            local isKey = (NguonHienTai == "ScriptBlox") and item.isKeySystem or (item.key or item.hasKey or false)
            local views = tostring(item.views or "0")
            local gameName = "Universal"
            if item.game then
                gameName = type(item.game) == "table" and (item.game.name or "Universal") or tostring(item.game)
            end

            local Card = Instance.new("Frame")
            Card.Parent = LibraryGrid
            Card.BackgroundColor3 = CurrentTheme.Card
            Card.BackgroundTransparency = 0.75
            CreateCorner(Card, 6)
            RegisterDynamicElement(Card, "Card")

            local NameLabel = Instance.new("TextLabel")
            NameLabel.Parent = Card
            NameLabel.Position = UDim2.new(0, 8, 0, 0)
            NameLabel.Size = UDim2.new(1, -65, 1, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Text = title
            NameLabel.TextColor3 = CurrentTheme.Text
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.TextSize = 10
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            RegisterDynamicElement(NameLabel, "Text")

            local PlayBtn = Instance.new("TextButton")
            PlayBtn.Parent = Card
            PlayBtn.AnchorPoint = Vector2.new(1, 0.5)
            PlayBtn.Position = UDim2.new(1, -6, 0.5, 0)
            PlayBtn.Size = UDim2.new(0, 24, 0, 24)
            PlayBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            PlayBtn.BackgroundTransparency = 0.1
            PlayBtn.Text = "▶️"
            PlayBtn.TextSize = 10
            CreateCorner(PlayBtn, 4)

            PlayBtn.MouseButton1Click:Connect(function()
                if scriptCode and scriptCode ~= "" then
                    executeSafe(scriptCode)
                elseif item.slug then
                    executeSafe("loadstring(game:HttpGet('https://raw.githubusercontent.com/ScriptBlox/ScriptBlox/main/" .. item.slug .. "'))()")
                end
            end)

            local InfoBtn = Instance.new("TextButton")
            InfoBtn.Parent = Card
            InfoBtn.AnchorPoint = Vector2.new(1, 0.5)
            InfoBtn.Position = UDim2.new(1, -34, 0.5, 0)
            InfoBtn.Size = UDim2.new(0, 24, 0, 24)
            InfoBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            InfoBtn.BackgroundTransparency = 0.2
            InfoBtn.Text = "?"
            InfoBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
            InfoBtn.Font = Enum.Font.GothamBold
            InfoBtn.TextSize = 12
            CreateCorner(InfoBtn, 4)

            InfoBtn.MouseButton1Click:Connect(function()
                ToggleInfoDrawer(title, {
                    Status = NguonHienTai .. " 🌐",
                    Key = isKey and "Required 🔒" or "Free / No Key 🔓",
                    Support = string.sub(gameName, 1, 15),
                    Note = "Views: " .. views
                })
            end)
        end
    end
end)

--==============================================================
-- 3. PLAYERS TAB
--==============================================================
local PlayersPage = Instance.new("ScrollingFrame")
PlayersPage.Name = "PlayersPage"
PlayersPage.Parent = ContentContainer
PlayersPage.BackgroundTransparency = 1
PlayersPage.Size = UDim2.new(1, 0, 1, 0)
PlayersPage.BorderSizePixel = 0
PlayersPage.ScrollBarThickness = 3
PlayersPage.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayersPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayersPage.Visible = false

local PlayersLayout = Instance.new("UIListLayout")
PlayersLayout.Parent = PlayersPage
PlayersLayout.Padding = UDim.new(0, 8)

local function CreatePlayerScriptCard(TitleText, SubText, ActionCallback)
    local Card = Instance.new("Frame")
    Card.Parent = PlayersPage
    Card.Size = UDim2.new(1, -6, 0, 36)
    Card.BackgroundColor3 = CurrentTheme.Card
    Card.BackgroundTransparency = 0.75
    CreateCorner(Card, 8)
    RegisterDynamicElement(Card, "Card")

    local Label = Instance.new("TextLabel")
    Label.Parent = Card
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = TitleText .. (SubText ~= "" and (" (" .. SubText .. ")") or "")
    Label.TextColor3 = CurrentTheme.Text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    RegisterDynamicElement(Label, "Text")

    local ActionBtn = Instance.new("TextButton")
    ActionBtn.Parent = Card
    ActionBtn.AnchorPoint = Vector2.new(1, 0.5)
    ActionBtn.Position = UDim2.new(1, -8, 0.5, 0)
    ActionBtn.Size = UDim2.new(0, 65, 0, 24)
    ActionBtn.BackgroundColor3 = CurrentTheme.Accent
    ActionBtn.BackgroundTransparency = 0.25
    ActionBtn.Text = "Execute"
    ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActionBtn.Font = Enum.Font.GothamBold
    ActionBtn.TextSize = 10
    CreateCorner(ActionBtn, 6)
    RegisterDynamicElement(ActionBtn, "AccentBtn")

    ActionBtn.MouseButton1Click:Connect(ActionCallback)
    return Card
end

local function CreatePlayerInputCard(TitleText, PlaceholderText, ButtonText, Callback)
    local Card = Instance.new("Frame")
    Card.Parent = PlayersPage
    Card.Size = UDim2.new(1, -6, 0, 36)
    Card.BackgroundColor3 = CurrentTheme.Card
    Card.BackgroundTransparency = 0.75
    CreateCorner(Card, 8)
    RegisterDynamicElement(Card, "Card")

    local Label = Instance.new("TextLabel")
    Label.Parent = Card
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0.32, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = TitleText
    Label.TextColor3 = CurrentTheme.Text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    RegisterDynamicElement(Label, "Text")

    local InputBox = Instance.new("TextBox")
    InputBox.Parent = Card
    InputBox.Position = UDim2.new(0.33, 0, 0.15, 0)
    InputBox.Size = UDim2.new(0.42, 0, 0.7, 0)
    InputBox.BackgroundColor3 = CurrentTheme.Bg
    InputBox.BackgroundTransparency = 0.4
    InputBox.PlaceholderText = PlaceholderText
    InputBox.Text = ""
    InputBox.TextColor3 = CurrentTheme.Text
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextSize = 11
    CreateCorner(InputBox, 6)

    local ApplyBtn = Instance.new("TextButton")
    ApplyBtn.Parent = Card
    ApplyBtn.AnchorPoint = Vector2.new(1, 0.5)
    ApplyBtn.Position = UDim2.new(1, -6, 0.5, 0)
    ApplyBtn.Size = UDim2.new(0, 55, 0, 24)
    ApplyBtn.BackgroundColor3 = CurrentTheme.Accent
    ApplyBtn.BackgroundTransparency = 0.25
    ApplyBtn.Text = ButtonText
    ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ApplyBtn.Font = Enum.Font.GothamBold
    ApplyBtn.TextSize = 10
    CreateCorner(ApplyBtn, 6)
    RegisterDynamicElement(ApplyBtn, "AccentBtn")

    ApplyBtn.MouseButton1Click:Connect(function()
        Callback(InputBox.Text)
    end)
end

local function CreatePlayerToggleCard(TitleText, Callback)
    local Card = Instance.new("Frame")
    Card.Parent = PlayersPage
    Card.Size = UDim2.new(1, -6, 0, 36)
    Card.BackgroundColor3 = CurrentTheme.Card
    Card.BackgroundTransparency = 0.75
    CreateCorner(Card, 8)
    RegisterDynamicElement(Card, "Card")

    local Label = Instance.new("TextLabel")
    Label.Parent = Card
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = TitleText
    Label.TextColor3 = CurrentTheme.Text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    RegisterDynamicElement(Label, "Text")

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = Card
    ToggleBtn.AnchorPoint = Vector2.new(1, 0.5)
    ToggleBtn.Position = UDim2.new(1, -8, 0.5, 0)
    ToggleBtn.Size = UDim2.new(0, 50, 0, 24)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleBtn.Text = "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 10
    CreateCorner(ToggleBtn, 12)

    local state = false
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.Text = state and "ON" or "OFF"
        ToggleBtn.BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(60, 60, 70)
        Callback(state)
    end)
end

-- 1. Speed (0 - 1000000000)
CreatePlayerInputCard("⚡ Speed", "0 - 1000000000", "Set", function(val)
    local num = tonumber(val)
    if num and num >= 0 and num <= 1000000000 then
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = num
        end
    end
end)

-- 2. JumpPower (0 - 1000000000)
CreatePlayerInputCard("🦘 JumpPower", "0 - 1000000000", "Set", function(val)
    local num = tonumber(val)
    if num and num >= 0 and num <= 1000000000 then
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.UseJumpPower = true
            Player.Character.Humanoid.JumpPower = num
        end
    end
end)

-- 3. Fullbright
local fullbrightConn = nil
local origBrightness, origClock, origFog, origShadows = Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd, Lighting.GlobalShadows

CreatePlayerToggleCard("💡 Fullbright", function(state)
    if state then
        fullbrightConn = RunService.RenderStepped:Connect(function()
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 1000000
            Lighting.GlobalShadows = false
        end)
    else
        if fullbrightConn then fullbrightConn:Disconnect() fullbrightConn = nil end
        Lighting.Brightness = origBrightness
        Lighting.ClockTime = origClock
        Lighting.FogEnd = origFog
        Lighting.GlobalShadows = origShadows
    end
end)

-- 4. ESP (Name + Hitbox)
local espEnabled = false
local espFolder = Instance.new("Folder", ScreenGui)
espFolder.Name = "ESPFolder"

local function UpdateESP()
    espFolder:ClearAllChildren()
    if not espEnabled then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
            local bb = Instance.new("BillboardGui")
            bb.Adornee = p.Character.Head
            bb.Size = UDim2.new(0, 100, 0, 30)
            bb.StudsOffset = Vector3.new(0, 2, 0)
            bb.AlwaysOnTop = true
            bb.Parent = espFolder

            local txt = Instance.new("TextLabel")
            txt.Parent = bb
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = p.Name
            txt.TextColor3 = Color3.fromRGB(0, 230, 255)
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 11

            local hl = Instance.new("Highlight")
            hl.Adornee = p.Character
            hl.FillColor = Color3.fromRGB(0, 150, 255)
            hl.FillTransparency = 0.5
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Parent = espFolder
        end
    end
end

CreatePlayerToggleCard("👁️ ESP (Name & Hitbox)", function(state)
    espEnabled = state
    UpdateESP()
end)

Players.PlayerAdded:Connect(function() if espEnabled then UpdateESP() end end)
Players.PlayerRemoving:Connect(function() if espEnabled then UpdateESP() end end)

-- 5. ESP Teamer (Server Team Logic)
local teamerESPEnabled = false
local teamerFolder = Instance.new("Folder", ScreenGui)
teamerFolder.Name = "TeamerFolder"

local function UpdateTeamerESP()
    teamerFolder:ClearAllChildren()
    if not teamerESPEnabled then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("Head") then
            local isTeamerWithLocal = (p.Team and Player.Team and p.Team == Player.Team)
            local teamColor = isTeamerWithLocal and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
            local teamInfo = p.Team and p.Team.Name or "No Team"

            local bb = Instance.new("BillboardGui")
            bb.Adornee = p.Character.Head
            bb.Size = UDim2.new(0, 120, 0, 35)
            bb.StudsOffset = Vector3.new(0, 3.2, 0)
            bb.AlwaysOnTop = true
            bb.Parent = teamerFolder

            local txt = Instance.new("TextLabel")
            txt.Parent = bb
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = "👥 Team: " .. teamInfo .. "\n" .. (isTeamerWithLocal and "[ALLY]" or "[HOSTILE]")
            txt.TextColor3 = teamColor
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 10
        end
    end
end

CreatePlayerToggleCard("🛡️ ESP Teamer (Server Team Logic)", function(state)
    teamerESPEnabled = state
    UpdateTeamerESP()
end)

-- 6. Fake Skin (Client-Side Character Cloning)
CreatePlayerInputCard("🎭 Fake Skin", "Username in server", "Copy", function(targetName)
    if not targetName or targetName == "" then return end

    local myChar = Player.Character
    if not myChar then return end

    -- Tìm người chơi mục tiêu trong server (theo Name hoặc DisplayName)
    local targetPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if string.lower(p.Name) == string.lower(targetName) or string.lower(p.DisplayName) == string.lower(targetName) then
            targetPlayer = p
            break
        end
    end

    if not targetPlayer or not targetPlayer.Character then
        warn("[Nanesk Hub Fake Skin]: Target player or character not found in workspace.")
        return
    end

    local targetChar = targetPlayer.Character

    -- 1. Xóa các phụ kiện và quần áo cũ trên Client của bản thân
    for _, child in ipairs(myChar:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Clothing") or child:IsA("ShirtGraphic") or child:IsA("BodyColors") then
            child:Destroy()
        end
    end

    -- 2. Xóa mặt cũ nếu có
    local myHead = myChar:FindFirstChild("Head")
    if myHead then
        for _, child in ipairs(myHead:GetChildren()) do
            if child:IsA("Decal") then
                child:Destroy()
            end
        end
    end

    -- 3. Clone các item từ Target Character sang My Character
    for _, item in ipairs(targetChar:GetChildren()) do
        if item:IsA("Clothing") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") then
            local clonedItem = item:Clone()
            clonedItem.Parent = myChar
        elseif item:IsA("Accessory") then
            local clonedAcc = item:Clone()
            clonedAcc.Parent = myChar
        end
    end

    -- 4. Clone khuôn mặt (Decal) trên Head
    local targetHead = targetChar:FindFirstChild("Head")
    if targetHead and myHead then
        for _, child in ipairs(targetHead:GetChildren()) do
            if child:IsA("Decal") then
                local clonedFace = child:Clone()
                clonedFace.Parent = myHead
            end
        end
    end

    -- 5. Đồng bộ màu da nếu không dùng BodyColors
    for _, targetPart in ipairs(targetChar:GetChildren()) do
        if targetPart:IsA("BasePart") then
            local myPart = myChar:FindFirstChild(targetPart.Name)
            if myPart and myPart:IsA("BasePart") then
                myPart.Color = targetPart.Color
            end
        end
    end
end)

-- 7. Fake Animation Emote
CreatePlayerScriptCard("💃 Fake Animation Emote", "70+ Emotes", function()
    executeSafe("loadstring(game:HttpGet('https://raw.githubusercontent.com/GiangScript/Emote/main/Emote.lua'))()")
end)

--==============================================================
-- 4. SETTINGS PAGE
--==============================================================
local SettingsPage = Instance.new("ScrollingFrame")
SettingsPage.Name = "SettingsPage"
SettingsPage.Parent = ContentContainer
SettingsPage.BackgroundTransparency = 1
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BorderSizePixel = 0
SettingsPage.ScrollBarThickness = 3
SettingsPage.CanvasSize = UDim2.new(0, 0, 0, 0)
SettingsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsPage.Visible = false

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Parent = SettingsPage
SettingsLayout.Padding = UDim.new(0, 12)

local function CreateSectionTitle(Text)
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = SettingsPage
    TitleLabel.Size = UDim2.new(1, 0, 0, 18)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Text
    TitleLabel.TextColor3 = CurrentTheme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    RegisterDynamicElement(TitleLabel, "Text")
    return TitleLabel
end

local function CreateSecurityToggle(Name, DefaultState, Callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = SettingsPage
    ToggleFrame.Size = UDim2.new(1, -6, 0, 36)
    ToggleFrame.BackgroundColor3 = CurrentTheme.Card
    ToggleFrame.BackgroundTransparency = 0.75
    CreateCorner(ToggleFrame, 8)
    RegisterDynamicElement(ToggleFrame, "Card")

    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.TextColor3 = CurrentTheme.Text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    RegisterDynamicElement(Label, "Text")

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = ToggleFrame
    ToggleBtn.AnchorPoint = Vector2.new(1, 0.5)
    ToggleBtn.Position = UDim2.new(1, -8, 0.5, 0)
    ToggleBtn.Size = UDim2.new(0, 50, 0, 24)
    ToggleBtn.BackgroundColor3 = DefaultState and CurrentTheme.Accent or Color3.fromRGB(60, 60, 70)
    ToggleBtn.Text = DefaultState and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 10
    CreateCorner(ToggleBtn, 12)

    local state = DefaultState
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.Text = state and "ON" or "OFF"
        ToggleBtn.BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(60, 60, 70)
        Callback(state)
    end)
end

CreateSectionTitle("Security & Protections")
CreateSecurityToggle("Anti-AFK 💤", AntiAFKEnabled, function(s) AntiAFKEnabled = s end)
CreateSecurityToggle("Anti-Fling 🛡️", AntiFlingEnabled, function(s) AntiFlingEnabled = s end)
CreateSecurityToggle("Anti-Kick 🚫", AntiKickEnabled, function(s) AntiKickEnabled = s end)
CreateSecurityToggle("Anti-Virus Script ☣️", AntiVirusEnabled, function(s) AntiVirusEnabled = s end)

CreateSectionTitle("Hub Scale & Size")
local SizeGrid = Instance.new("Frame")
SizeGrid.Parent = SettingsPage
SizeGrid.Size = UDim2.new(1, -6, 0, 72)
SizeGrid.BackgroundTransparency = 1

local SizeGridLayout = Instance.new("UIGridLayout")
SizeGridLayout.Parent = SizeGrid
SizeGridLayout.CellSize = UDim2.new(0.31, 0, 0, 32)
SizeGridLayout.CellPadding = UDim2.new(0.03, 0, 0, 6)

local SizeOptions = {
    {"Mini", 0.65}, {"Small", 0.8}, {"Normal", 1.0},
    {"Medium", 1.15}, {"Big", 1.3}, {"Ultra", 1.45}
}

for _, Data in ipairs(SizeOptions) do
    local Btn = Instance.new("TextButton")
    Btn.Name = Data[1]
    Btn.Parent = SizeGrid
    Btn.BackgroundColor3 = (Data[1] == "Normal") and CurrentTheme.Accent or CurrentTheme.Card
    Btn.BackgroundTransparency = (Data[1] == "Normal") and 0.25 or 0.75
    Btn.Text = Data[1]
    Btn.TextColor3 = CurrentTheme.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    CreateCorner(Btn, 6)
    RegisterDynamicElement(Btn, (Data[1] == "Normal") and "AccentBtn" or "CardBtn")

    Btn.MouseButton1Click:Connect(function()
        TargetScale = Data[2]
        Tween(MainScale, 0.25, {Scale = TargetScale})
        for _, Child in ipairs(SizeGrid:GetChildren()) do
            if Child:IsA("TextButton") then
                Child.BackgroundColor3 = (Child.Name == Data[1]) and CurrentTheme.Accent or CurrentTheme.Card
                Child.BackgroundTransparency = (Child.Name == Data[1]) and 0.25 or 0.75
            end
        end
    end)
end

--==============================================================
-- DYNAMIC THEMES & TAB SWITCHING
--==============================================================
local CurrentTab = "Games"

local function ApplyTheme(ThemeData)
    CurrentTheme = ThemeData
    Main.BackgroundColor3 = ThemeData.Bg
    HubOverlay.BackgroundColor3 = ThemeData.Accent
    MainStroke.Color = ThemeData.Accent
    Title.TextColor3 = ThemeData.Accent
    StatsLabel.TextColor3 = ThemeData.Text

    GamesTabBtn.BackgroundColor3 = (CurrentTab == "Games") and ThemeData.Accent or ThemeData.Card
    GamesTabBtn.BackgroundTransparency = (CurrentTab == "Games") and 0.25 or 0.75

    LibraryTabBtn.BackgroundColor3 = (CurrentTab == "Library") and ThemeData.Accent or ThemeData.Card
    LibraryTabBtn.BackgroundTransparency = (CurrentTab == "Library") and 0.25 or 0.75

    PlayersTabBtn.BackgroundColor3 = (CurrentTab == "Players") and ThemeData.Accent or ThemeData.Card
    PlayersTabBtn.BackgroundTransparency = (CurrentTab == "Players") and 0.25 or 0.75

    SettingsTabBtn.BackgroundColor3 = (CurrentTab == "Settings") and ThemeData.Accent or ThemeData.Card
    SettingsTabBtn.BackgroundTransparency = (CurrentTab == "Settings") and 0.25 or 0.75

    InfoPanelStroke.Color = ThemeData.Accent
    IconStroke.Color = ThemeData.Accent
    DrawerStroke.Color = ThemeData.Accent
    DrawerTitle.TextColor3 = ThemeData.Accent

    for _, Item in ipairs(DynamicElements) do
        if Item.Instance and Item.Instance.Parent then
            if Item.Style == "Text" then Item.Instance.TextColor3 = ThemeData.Text
            elseif Item.Style == "AccentText" then Item.Instance.TextColor3 = ThemeData.Accent
            elseif Item.Style == "Card" or Item.Style == "CardBtn" then
                Item.Instance.BackgroundColor3 = ThemeData.Card
                Item.Instance.BackgroundTransparency = 0.75
            elseif Item.Style == "Accent" or Item.Style == "AccentBtn" then
                Item.Instance.BackgroundColor3 = ThemeData.Accent
                Item.Instance.BackgroundTransparency = 0.25
            end
        end
    end
end

local function CreateThemeSection(SectionName, List)
    CreateSectionTitle(SectionName)
    local Grid = Instance.new("Frame")
    Grid.Parent = SettingsPage
    Grid.Size = UDim2.new(1, -6, 0, math.ceil(#List / 2) * 36)
    Grid.BackgroundTransparency = 1

    local Layout = Instance.new("UIGridLayout")
    Layout.Parent = Grid
    Layout.CellSize = UDim2.new(0.48, 0, 0, 30)
    Layout.CellPadding = UDim2.new(0.04, 0, 0, 6)

    for _, ThemeName in ipairs(List) do
        local Data = THEMES[ThemeName]
        local Btn = Instance.new("TextButton")
        Btn.Parent = Grid
        Btn.BackgroundColor3 = Data.Card
        Btn.BackgroundTransparency = 0.75
        Btn.Text = ThemeName
        Btn.TextColor3 = Data.Text
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 10
        CreateCorner(Btn, 6)
        CreateStroke(Btn, Data.Accent, 1)

        Btn.MouseButton1Click:Connect(function() ApplyTheme(THEMES[ThemeName]) end)
    end
end

CreateThemeSection("Dark Themes", {"Nebula Blue", "Nitro Frost", "Circuit Rush", "Kinetic Energy", "Inferno Blast", "Hyper Plum", "Quantum Pulse"})
CreateThemeSection("Light Themes", {"Cosmic Dust", "Polar Freeze", "Super Charge", "Electric Lime", "Lava Glow", "Star Burst", "Pixel Pop"})

local function RefreshTabs()
    GamesTabBtn.BackgroundColor3 = (CurrentTab == "Games") and CurrentTheme.Accent or CurrentTheme.Card
    GamesTabBtn.BackgroundTransparency = (CurrentTab == "Games") and 0.25 or 0.75

    LibraryTabBtn.BackgroundColor3 = (CurrentTab == "Library") and CurrentTheme.Accent or CurrentTheme.Card
    LibraryTabBtn.BackgroundTransparency = (CurrentTab == "Library") and 0.25 or 0.75

    PlayersTabBtn.BackgroundColor3 = (CurrentTab == "Players") and CurrentTheme.Accent or CurrentTheme.Card
    PlayersTabBtn.BackgroundTransparency = (CurrentTab == "Players") and 0.25 or 0.75

    SettingsTabBtn.BackgroundColor3 = (CurrentTab == "Settings") and CurrentTheme.Accent or CurrentTheme.Card
    SettingsTabBtn.BackgroundTransparency = (CurrentTab == "Settings") and 0.25 or 0.75

    GamesPage.Visible = (CurrentTab == "Games")
    LibraryPage.Visible = (CurrentTab == "Library")
    PlayersPage.Visible = (CurrentTab == "Players")
    SettingsPage.Visible = (CurrentTab == "Settings")
end

GamesTabBtn.MouseButton1Click:Connect(function() CurrentTab = "Games"; RefreshTabs() end)
LibraryTabBtn.MouseButton1Click:Connect(function() CurrentTab = "Library"; RefreshTabs() end)
PlayersTabBtn.MouseButton1Click:Connect(function() CurrentTab = "Players"; RefreshTabs() end)
SettingsTabBtn.MouseButton1Click:Connect(function() CurrentTab = "Settings"; RefreshTabs() end)

--==============================================================
-- DRAGGABLE & FPS
--==============================================================
local FPS, FrameCount, LastTime = 0, 0, tick()
RunService.RenderStepped:Connect(function()
    FrameCount += 1
    if tick() - LastTime >= 1 then FPS = FrameCount; FrameCount = 0; LastTime = tick() end
end)

task.spawn(function()
    while task.wait(0.5) do
        local Ping = 0
        pcall(function() Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        StatsLabel.Text = "Ping: " .. Ping .. " ms | FPS: " .. FPS .. " | library friendly"
    end
end)

local MainDragging, MainDragStart, MainStartPosition = false, nil, nil
Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        MainDragging = true
        MainDragStart = Input.Position
        MainStartPosition = Main.Position
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then MainDragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if MainDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - MainDragStart
        Main.Position = UDim2.new(MainStartPosition.X.Scale, MainStartPosition.X.Offset + Delta.X, MainStartPosition.Y.Scale, MainStartPosition.Y.Offset + Delta.Y)
    end
end)

--==============================================================
-- FLOATING TOGGLE BUTTON
--==============================================================
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Parent = ScreenGui
FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingButton.Position = UDim2.new(0.9, 0, 0.25, 0)
FloatingButton.Size = UDim2.new(0, 42, 0, 42)
FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
FloatingButton.Visible = false
CreateCorner(FloatingButton, 12)
CreateStroke(FloatingButton, Color3.fromRGB(0, 140, 255), 1.5)

local FloatText = Instance.new("TextLabel")
FloatText.Parent = FloatingButton
FloatText.Size = UDim2.new(1, 0, 1, 0)
FloatText.BackgroundTransparency = 1
FloatText.Text = "N"
FloatText.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatText.Font = Enum.Font.GothamBold
FloatText.TextSize = 22

local FloatDragging, FloatDragStart, FloatStartPosition = false, nil, nil
local DraggedDistance = 0

FloatingButton.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        FloatDragging = true
        FloatDragStart = Input.Position
        FloatStartPosition = FloatingButton.Position
        DraggedDistance = 0
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then FloatDragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if FloatDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - FloatDragStart
        DraggedDistance = Delta.Magnitude
        FloatingButton.Position = UDim2.new(FloatStartPosition.X.Scale, FloatStartPosition.X.Offset + Delta.X, FloatStartPosition.Y.Scale, FloatStartPosition.Y.Offset + Delta.Y)
    end
end)

local isAnimating = false

CloseButton.MouseButton1Click:Connect(function()
    if isAnimating then return end
    isAnimating = true
    if DrawerOpen then InfoDrawer.Visible = false; DrawerOpen = false end
    Tween(MainScale, 0.3, {Scale = 0.75})
    local SlideTween = Tween(Main, 0.3, {Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset, 0.6, 0)})
    SlideTween.Completed:Connect(function()
        Main.Visible = false
        FloatingButton.Visible = true
        isAnimating = false
    end)
end)

FloatingButton.MouseButton1Click:Connect(function()
    if DraggedDistance < 10 then
        if isAnimating then return end
        isAnimating = true
        FloatingButton.Visible = false
        Main.Visible = true
        Tween(MainScale, 0.35, {Scale = TargetScale})
        local SlideTween = Tween(Main, 0.35, {Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset, 0.5, 0)})
        SlideTween.Completed:Connect(function() isAnimating = false end)
    end
end)
 
