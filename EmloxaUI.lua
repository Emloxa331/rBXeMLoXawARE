-- =========================================================================
-- EMLOXA WARE ULTRA PREMIUM UI v2.0
-- FULL ANIMATED | GLASS MORPHISM | PARTICLE EFFECTS | SMOOTH AS BUTTER
-- =========================================================================

local EmloxaLibrary = {}

-- ══════════════════════════════════════════════════════════════════════
-- SERVICES & CORE
-- ══════════════════════════════════════════════════════════════════════
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ══════════════════════════════════════════════════════════════════════
-- ANIMATION PRESETS
-- ══════════════════════════════════════════════════════════════════════
local Animations = {
    Fast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Elastic = TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.45, Enum.EasingStyle.Spring, Enum.EasingDirection.Out),
}

-- ══════════════════════════════════════════════════════════════════════
-- ULTRA PREMIUM THEMES
-- ══════════════════════════════════════════════════════════════════════
local Themes = {
    ["Midnight Aurora"] = {
        Primary = Color3.fromRGB(138, 43, 226),
        Secondary = Color3.fromRGB(75, 0, 130),
        Background = Color3.fromRGB(10, 10, 20),
        Surface = Color3.fromRGB(20, 20, 35),
        SurfaceLight = Color3.fromRGB(30, 30, 50),
        Accent = Color3.fromRGB(255, 105, 180),
        Success = Color3.fromRGB(0, 255, 127),
        Warning = Color3.fromRGB(255, 215, 0),
        Error = Color3.fromRGB(255, 69, 58),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(160, 160, 180),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    ["Neon Dreams"] = {
        Primary = Color3.fromRGB(0, 255, 255),
        Secondary = Color3.fromRGB(255, 0, 255),
        Background = Color3.fromRGB(5, 5, 15),
        Surface = Color3.fromRGB(15, 15, 25),
        SurfaceLight = Color3.fromRGB(25, 25, 40),
        Accent = Color3.fromRGB(255, 20, 147),
        Success = Color3.fromRGB(50, 255, 150),
        Warning = Color3.fromRGB(255, 200, 0),
        Error = Color3.fromRGB(255, 50, 80),
        Text = Color3.fromRGB(240, 255, 255),
        TextMuted = Color3.fromRGB(120, 200, 200),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    ["Sunset Blaze"] = {
        Primary = Color3.fromRGB(255, 140, 0),
        Secondary = Color3.fromRGB(255, 69, 0),
        Background = Color3.fromRGB(18, 10, 8),
        Surface = Color3.fromRGB(28, 18, 15),
        SurfaceLight = Color3.fromRGB(40, 28, 22),
        Accent = Color3.fromRGB(255, 99, 71),
        Success = Color3.fromRGB(144, 238, 144),
        Warning = Color3.fromRGB(255, 215, 0),
        Error = Color3.fromRGB(220, 20, 60),
        Text = Color3.fromRGB(255, 245, 230),
        TextMuted = Color3.fromRGB(200, 170, 150),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    ["Ocean Deep"] = {
        Primary = Color3.fromRGB(0, 150, 255),
        Secondary = Color3.fromRGB(0, 100, 200),
        Background = Color3.fromRGB(8, 15, 25),
        Surface = Color3.fromRGB(15, 25, 40),
        SurfaceLight = Color3.fromRGB(25, 40, 60),
        Accent = Color3.fromRGB(64, 224, 208),
        Success = Color3.fromRGB(72, 209, 204),
        Warning = Color3.fromRGB(255, 228, 181),
        Error = Color3.fromRGB(255, 99, 71),
        Text = Color3.fromRGB(230, 245, 255),
        TextMuted = Color3.fromRGB(150, 180, 200),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    ["Forest Mystic"] = {
        Primary = Color3.fromRGB(50, 205, 50),
        Secondary = Color3.fromRGB(34, 139, 34),
        Background = Color3.fromRGB(10, 15, 10),
        Surface = Color3.fromRGB(18, 28, 18),
        SurfaceLight = Color3.fromRGB(28, 42, 28),
        Accent = Color3.fromRGB(154, 205, 50),
        Success = Color3.fromRGB(124, 252, 0),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(220, 20, 60),
        Text = Color3.fromRGB(240, 255, 240),
        TextMuted = Color3.fromRGB(144, 238, 144),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
}

local CurrentTheme = Themes["Midnight Aurora"]
local ThemeObjects = setmetatable({}, {__mode = "k"})

-- ══════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ══════════════════════════════════════════════════════════════════════

local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    return instance
end

local function Corner(parent, radius)
    return CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 12),
        Parent = parent
    })
end

local function Stroke(parent, color, thickness, transparency)
    return CreateInstance("UIStroke", {
        Color = color or CurrentTheme.Primary,
        Thickness = thickness or 2,
        Transparency = transparency or 0,
        Parent = parent
    })
end

local function Gradient(parent, colors, rotation)
    return CreateInstance("UIGradient", {
        Color = ColorSequence.new(colors or {
            ColorSequenceKeypoint.new(0, CurrentTheme.Primary),
            ColorSequenceKeypoint.new(1, CurrentTheme.Secondary)
        }),
        Rotation = rotation or 45,
        Parent = parent
    })
end

local function Shadow(parent, size, offset, transparency, color)
    return CreateInstance("ImageLabel", {
        Image = "rbxassetid://5554236805",
        ImageColor3 = color or Color3.new(0, 0, 0),
        ImageTransparency = transparency or 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = size or UDim2.new(1, 30, 1, 30),
        Position = offset and UDim2.new(0, offset, 0, offset) or UDim2.new(0, -15, 0, -15),
        BackgroundTransparency = 1,
        ZIndex = -1,
        Parent = parent
    })
end

local function Blur(parent, size)
    local blur = CreateInstance("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageTransparency = 0.95,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, size or 100, 0, size or 100),
        Parent = parent
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = blur
    })
    
    return blur
end

local function Ripple(button, color)
    button.ClipsDescendants = true
    
    button.MouseButton1Down:Connect(function()
        local ripple = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = color or CurrentTheme.Primary,
            BackgroundTransparency = 0.5,
            ZIndex = 999,
            Parent = button
        })
        
        Corner(ripple, 1000)
        
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        
        TweenService:Create(ripple, Animations.Medium, {
            Size = UDim2.new(0, size, 0, size),
            BackgroundTransparency = 1
        }):Play()
        
        task.delay(0.5, function()
            ripple:Destroy()
        end)
    end)
end

local function Particles(parent)
    local particles = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 0,
        Parent = parent
    })
    
    for i = 1, 20 do
        local particle = CreateInstance("Frame", {
            Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4)),
            Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0),
            BackgroundColor3 = CurrentTheme.Primary,
            BackgroundTransparency = math.random(30, 70) / 100,
            BorderSizePixel = 0,
            ZIndex = 0,
            Parent = particles
        })
        
        Corner(particle, 100)
        
        local function animate()
            local randomX = math.random(-50, 50)
            local randomY = math.random(-50, 50)
            
            TweenService:Create(particle, TweenInfo.new(
                math.random(3, 6),
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.InOut,
                -1,
                true
            ), {
                Position = particle.Position + UDim2.new(0, randomX, 0, randomY)
            }):Play()
        end
        
        task.spawn(animate)
    end
    
    return particles
end

local function RegisterTheme(object, properties)
    ThemeObjects[object] = properties
end

local function ApplyTheme(theme)
    CurrentTheme = theme
    
    for object, properties in pairs(ThemeObjects) do
        if object and object.Parent then
            for property, themeKey in pairs(properties) do
                if theme[themeKey] then
                    TweenService:Create(object, Animations.Medium, {
                        [property] = theme[themeKey]
                    }):Play()
                end
            end
        else
            ThemeObjects[object] = nil
        end
    end
end

-- ══════════════════════════════════════════════════════════════════════
-- MAIN WINDOW CREATION
-- ══════════════════════════════════════════════════════════════════════

function EmloxaLibrary:CreateWindow(title)
    local Window = {}
    
    -- Main ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "EmloxaUltraPremium",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })
    
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer.PlayerGui
    end
    
    -- ══════════════════════════════════════════════════════════════════
    -- LOADING SCREEN (EPIC ANIMATION)
    -- ══════════════════════════════════════════════════════════════════
    
    local LoadingScreen = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = CurrentTheme.Background,
        BorderSizePixel = 0,
        ZIndex = 10000,
        Parent = ScreenGui
    })
    
    Gradient(LoadingScreen, {
        ColorSequenceKeypoint.new(0, CurrentTheme.Background),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.Surface),
        ColorSequenceKeypoint.new(1, CurrentTheme.Background)
    }, 135)
    
    Particles(LoadingScreen)
    
    -- Logo Container
    local LogoContainer = CreateInstance("Frame", {
        Size = UDim2.new(0, 200, 0, 200),
        Position = UDim2.new(0.5, -100, 0.4, -100),
        BackgroundTransparency = 1,
        Parent = LoadingScreen
    })
    
    -- Animated Logo Ring
    local LogoRing = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = LogoContainer
    })
    
    for i = 1, 3 do
        local ring = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Parent = LogoRing
        })
        
        local ringStroke = Stroke(ring, CurrentTheme.Primary, 3, 0.5)
        Corner(ring, 100)
        
        TweenService:Create(ring, TweenInfo.new(
            2 + i * 0.5,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            -1
        ), {
            Rotation = 360
        }):Play()
        
        TweenService:Create(ring, TweenInfo.new(
            1.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {
            Size = UDim2.new(1.2, 0, 1.2, 0)
        }):Play()
    end
    
    -- Logo Text
    local LogoText = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "E",
        Font = Enum.Font.GothamBlack,
        TextSize = 100,
        TextColor3 = CurrentTheme.Primary,
        Parent = LogoContainer
    })
    
    -- Rainbow effect on logo
    task.spawn(function()
        while LoadingScreen.Parent do
            LogoText.TextColor3 = Color3.fromHSV((tick() * 0.5) % 1, 1, 1)
            task.wait()
        end
    end)
    
    -- Loading Text
    local LoadingText = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0.65, 0),
        BackgroundTransparency = 1,
        Text = "EMLOXA WARE",
        Font = Enum.Font.GothamBlack,
        TextSize = 36,
        TextColor3 = CurrentTheme.Text,
        Parent = LoadingScreen
    })
    
    -- Loading Dots
    local LoadingDots = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0.72, 0),
        BackgroundTransparency = 1,
        Text = "Loading",
        Font = Enum.Font.GothamSemibold,
        TextSize = 18,
        TextColor3 = CurrentTheme.TextMuted,
        Parent = LoadingScreen
    })
    
    task.spawn(function()
        local dots = 0
        while LoadingScreen.Parent do
            dots = (dots % 3) + 1
            LoadingDots.Text = "Loading" .. string.rep(".", dots)
            task.wait(0.5)
        end
    end)
    
    -- Progress Bar
    local ProgressBarBg = CreateInstance("Frame", {
        Size = UDim2.new(0, 400, 0, 6),
        Position = UDim2.new(0.5, -200, 0.8, 0),
        BackgroundColor3 = CurrentTheme.Surface,
        BorderSizePixel = 0,
        Parent = LoadingScreen
    })
    Corner(ProgressBarBg, 3)
    
    local ProgressBar = CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = CurrentTheme.Primary,
        BorderSizePixel = 0,
        Parent = ProgressBarBg
    })
    Corner(ProgressBar, 3)
    Gradient(ProgressBar, {
        ColorSequenceKeypoint.new(0, CurrentTheme.Primary),
        ColorSequenceKeypoint.new(1, CurrentTheme.Accent)
    }, 0)
    
    -- Animate progress
    TweenService:Create(ProgressBar, TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()
    
    -- Remove loading screen after 2.5 seconds
    task.delay(2.5, function()
        TweenService:Create(LoadingScreen, Animations.Medium, {
            BackgroundTransparency = 1
        }):Play()
        
        for _, child in ipairs(LoadingScreen:GetDescendants()) do
            if child:IsA("TextLabel") then
                TweenService:Create(child, Animations.Fast, {
                    TextTransparency = 1
                }):Play()
            elseif child:IsA("Frame") or child:IsA("ImageLabel") then
                TweenService:Create(child, Animations.Fast, {
                    BackgroundTransparency = 1,
                    ImageTransparency = 1
                }):Play()
            elseif child:IsA("UIStroke") then
                TweenService:Create(child, Animations.Fast, {
                    Transparency = 1
                }):Play()
            end
        end
        
        task.wait(0.5)
        LoadingScreen:Destroy()
    end)
    
    -- ══════════════════════════════════════════════════════════════════
    -- MAIN WINDOW
    -- ══════════════════════════════════════════════════════════════════
    
    local MainWindow = CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = CurrentTheme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
        Parent = ScreenGui
    })
    
    Corner(MainWindow, 20)
    Stroke(MainWindow, CurrentTheme.Primary, 2)
    Shadow(MainWindow, UDim2.new(1, 60, 1, 60), -30, 0.7)
    Blur(MainWindow, 100)
    
    RegisterTheme(MainWindow, {
        BackgroundColor3 = "Background"
    })
    
    -- Glass morphism effect
    local GlassMorph = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = CurrentTheme.Surface,
        BackgroundTransparency = 0.95,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = MainWindow
    })
    Corner(GlassMorph, 20)
    
    -- Animate window opening
    task.delay(2.5, function()
        TweenService:Create(MainWindow, Animations.Bounce, {
            Size = UDim2.new(0, 750, 0, 520)
        }):Play()
    end)
    
    -- ══════════════════════════════════════════════════════════════════
    -- TOP BAR (ULTRA ANIMATED)
    -- ══════════════════════════════════════════════════════════════════
    
    local TopBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = CurrentTheme.Surface,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = MainWindow
    })
    
    Corner(TopBar, 20)
    Stroke(TopBar, CurrentTheme.Primary, 1, 0.5)
    
    local TopBarCover = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = CurrentTheme.Surface,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = TopBar
    })
    
    RegisterTheme(TopBar, {BackgroundColor3 = "Surface"})
    RegisterTheme(TopBarCover, {BackgroundColor3 = "Surface"})
    
    -- Animated Gradient on Top Bar
    local TopBarGradient = Gradient(TopBar, {
        ColorSequenceKeypoint.new(0, CurrentTheme.Primary),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.Secondary),
        ColorSequenceKeypoint.new(1, CurrentTheme.Primary)
    }, 0)
    
    task.spawn(function()
        while TopBar.Parent do
            TweenService:Create(TopBarGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {
                Rotation = TopBarGradient.Rotation + 360
            }):Play()
            task.wait(3)
        end
    end)
    
    -- Logo Icon
    local LogoIcon = CreateInstance("Frame", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 15, 0.5, -20),
        BackgroundColor3 = CurrentTheme.Primary,
        BorderSizePixel = 0,
        Parent = TopBar
    })
    Corner(LogoIcon, 10)
    Stroke(LogoIcon, Color3.new(1, 1, 1), 2)
    
    local LogoLetter = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "E",
        Font = Enum.Font.GothamBlack,
        TextSize = 24,
        TextColor3 = Color3.new(1, 1, 1),
        Parent = LogoIcon
    })
    
    -- Pulsing animation on logo
    task.spawn(function()
        while LogoIcon.Parent do
            TweenService:Create(LogoIcon, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Size = UDim2.new(0, 44, 0, 44)
            }):Play()
            task.wait(2)
        end
    end)
    
    -- Title Text
    local TitleText = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 400, 1, 0),
        Position = UDim2.new(0, 65, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        TextColor3 = CurrentTheme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    RegisterTheme(TitleText, {TextColor3 = "Text"})
    
    -- Rainbow title effect
    task.spawn(function()
        while TitleText.Parent do
            TitleText.TextColor3 = Color3.fromHSV((tick() * 0.3) % 1, 0.8, 1)
            task.wait()
        end
    end)
    
    -- Credits Badge
    local CreditsBadge = CreateInstance("Frame", {
        Size = UDim2.new(0, 140, 0, 30),
        Position = UDim2.new(1, -280, 0.5, -15),
        BackgroundColor3 = CurrentTheme.Surface,
        BorderSizePixel = 0,
        Parent = TopBar
    })
    Corner(CreditsBadge, 15)
    Stroke(CreditsBadge, CurrentTheme.Accent, 1.5)
    
    local CreditsText = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "by Emloxa",
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        TextColor3 = CurrentTheme.Accent,
        Parent = CreditsBadge
    })
    
    RegisterTheme(CreditsText, {TextColor3 = "Accent"})
    
    -- Window Controls
    local ControlsContainer = CreateInstance("Frame", {
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(1, -130, 0, 0),
        BackgroundTransparency = 1,
        Parent = TopBar
    })
    
    local function CreateControlButton(text, position, color, hoverColor)
        local button = CreateInstance("TextButton", {
            Size = UDim2.new(0, 38, 0, 38),
            Position = position,
            BackgroundColor3 = CurrentTheme.SurfaceLight,
            Text = text,
            Font = Enum.Font.GothamBlack,
            TextSize = 18,
            TextColor3 = color,
            AutoButtonColor = false,
            Parent = ControlsContainer
        })
        
        Corner(button, 10)
        Stroke(button, color, 1.5, 0.5)
        Ripple(button, color)
        
        RegisterTheme(button, {BackgroundColor3 = "SurfaceLight"})
        
        button.MouseEnter:Connect(function()
            TweenService:Create(button, Animations.Fast, {
                BackgroundColor3 = hoverColor,
                TextColor3 = Color3.new(1, 1, 1),
                Size = UDim2.new(0, 42, 0, 42)
            }):Play()
            
            TweenService:Create(button:FindFirstChildOfClass("UIStroke"), Animations.Fast, {
                Transparency = 0
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, Animations.Fast, {
                BackgroundColor3 = CurrentTheme.SurfaceLight,
                TextColor3 = color,
                Size = UDim2.new(0, 38, 0, 38)
            }):Play()
            
            TweenService:Create(button:FindFirstChildOfClass("UIStroke"), Animations.Fast, {
                Transparency = 0.5
            }):Play()
        end)
        
        return button
    end
    
    local MinimizeButton = CreateControlButton("─", UDim2.new(0, 0, 0.5, -19), CurrentTheme.Warning, CurrentTheme.Warning)
    local CloseButton = CreateControlButton("✕", UDim2.new(0, 52, 0.5, -19), CurrentTheme.Error, CurrentTheme.Error)
    
    local isMinimized = false
    
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        TweenService:Create(MainWindow, Animations.Bounce, {
            Size = isMinimized and UDim2.new(0, 750, 0, 60) or UDim2.new(0, 750, 0, 520)
        }):Play()
        
        MinimizeButton.Text = isMinimized and "+" or "─"
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainWindow, Animations.Bounce, {
            Size = UDim2.new(0, 0, 0, 0),
            Rotation = 90
        }):Play()
        
        task.wait(0.6)
        ScreenGui:Destroy()
    end)
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainWindow.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            
            TweenService:Create(MainWindow, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }):Play()
        end
    end)
    
    -- ══════════════════════════════════════════════════════════════════
    -- TAB SYSTEM (ULTRA SMOOTH)
    -- ══════════════════════════════════════════════════════════════════
    
    local TabContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -40, 0, 50),
        Position = UDim2.new(0, 20, 0, 70),
        BackgroundTransparency = 1,
        Parent = MainWindow
    })
    
    local TabList = CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = TabContainer
    })
    
    local PageContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -40, 1, -140),
        Position = UDim2.new(0, 20, 0, 130),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = MainWindow
    })
    
    local Tabs = {}
    local Pages = {}
    
    function Window:CreateTab(tabName)
        local Tab = {}
        
        -- Tab Button
        local TabButton = CreateInstance("TextButton", {
            Size = UDim2.new(0, 140, 1, 0),
            BackgroundColor3 = CurrentTheme.Surface,
            BackgroundTransparency = 0.7,
            Text = "",
            AutoButtonColor = false,
            Parent = TabContainer
        })
        
        Corner(TabButton, 12)
        Ripple(TabButton, CurrentTheme.Primary)
        RegisterTheme(TabButton, {BackgroundColor3 = "Surface"})
        
        local TabIcon = CreateInstance("Frame", {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0, 10, 0.5, -15),
            BackgroundColor3 = CurrentTheme.Primary,
            BackgroundTransparency = 0.3,
            Parent = TabButton
        })
        Corner(TabIcon, 8)
        RegisterTheme(TabIcon, {BackgroundColor3 = "Primary"})
        
        local TabLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 45, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = CurrentTheme.TextMuted,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        RegisterTheme(TabLabel, {TextColor3 = "TextMuted"})
        
        local TabIndicator = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 0, 3),
            Position = UDim2.new(0.5, 0, 1, -3),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = CurrentTheme.Primary,
            BorderSizePixel = 0,
            Parent = TabButton
        })
        Corner(TabIndicator, 2)
        RegisterTheme(TabIndicator, {BackgroundColor3 = "Primary"})
        
        -- Page
        local Page = CreateInstance("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 6,
            ScrollBarImageColor3 = CurrentTheme.Primary,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = PageContainer
        })
        
        RegisterTheme(Page, {ScrollBarImageColor3 = "Primary"})
        
        local PageList = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12),
            Parent = Page
        })
        
        CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            Parent = Page
        })
        
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, page in ipairs(Pages) do
                page.Visible = false
            end
            
            for _, tab in ipairs(Tabs) do
                local tabLabel = tab.Button:FindFirstChild("TextLabel")
                local tabIcon = tab.Button:FindFirstChild("Frame")
                local tabIndicator = tab.Indicator
                
                TweenService:Create(tabLabel, Animations.Fast, {
                    TextColor3 = CurrentTheme.TextMuted
                }):Play()
                
                TweenService:Create(tab.Button, Animations.Fast, {
                    BackgroundTransparency = 0.7
                }):Play()
                
                TweenService:Create(tabIcon, Animations.Fast, {
                    BackgroundTransparency = 0.3
                }):Play()
                
                TweenService:Create(tabIndicator, Animations.Smooth, {
                    Size = UDim2.new(0, 0, 0, 3)
                }):Play()
            end
            
            Page.Visible = true
            
            TweenService:Create(TabLabel, Animations.Fast, {
                TextColor3 = CurrentTheme.Text
            }):Play()
            
            TweenService:Create(TabButton, Animations.Fast, {
                BackgroundTransparency = 0
            }):Play()
            
            TweenService:Create(TabIcon, Animations.Fast, {
                BackgroundTransparency = 0
            }):Play()
            
            TweenService:Create(TabIndicator, Animations.Smooth, {
                Size = UDim2.new(1, 0, 0, 3)
            }):Play()
        end)
        
        table.insert(Tabs, {
            Button = TabButton,
            Indicator = TabIndicator
        })
        table.insert(Pages, Page)
        
        if #Tabs == 1 then
            TabButton.MouseButton1Click()
        end
        
        -- ══════════════════════════════════════════════════════════════
        -- UI ELEMENTS
        -- ══════════════════════════════════════════════════════════════
        
        function Tab:CreateButton(name, callback)
            local ButtonFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = CurrentTheme.SurfaceLight,
                BorderSizePixel = 0,
                Parent = Page
            })
            
            Corner(ButtonFrame, 12)
            Stroke(ButtonFrame, CurrentTheme.Primary, 1.5, 0.7)
            Gradient(ButtonFrame, {
                ColorSequenceKeypoint.new(0, CurrentTheme.Surface),
                ColorSequenceKeypoint.new(1, CurrentTheme.SurfaceLight)
            }, 45)
            
            RegisterTheme(ButtonFrame, {BackgroundColor3 = "SurfaceLight"})
            
            local Button = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = name,
                Font = Enum.Font.GothamBold,
                TextSize = 15,
                TextColor3 = CurrentTheme.Text,
                Parent = ButtonFrame
            })
            
            Ripple(Button, CurrentTheme.Primary)
            RegisterTheme(Button, {TextColor3 = "Text"})
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, Animations.Fast, {
                    BackgroundColor3 = CurrentTheme.Primary,
                    Size = UDim2.new(1, 0, 0, 48)
                }):Play()
                
                TweenService:Create(Button, Animations.Fast, {
                    TextColor3 = Color3.new(1, 1, 1)
                }):Play()
                
                TweenService:Create(ButtonFrame:FindFirstChildOfClass("UIStroke"), Animations.Fast, {
                    Transparency = 0
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, Animations.Fast, {
                    BackgroundColor3 = CurrentTheme.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 45)
                }):Play()
                
                TweenService:Create(Button, Animations.Fast, {
                    TextColor3 = CurrentTheme.Text
                }):Play()
                
                TweenService:Create(ButtonFrame:FindFirstChildOfClass("UIStroke"), Animations.Fast, {
                    Transparency = 0.7
                }):Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {
                    Size = UDim2.new(0.98, 0, 0, 42)
                }):Play()
                
                task.wait(0.1)
                
                TweenService:Create(ButtonFrame, Animations.Bounce, {
                    Size = UDim2.new(1, 0, 0, 45)
                }):Play()
                
                callback()
            end)
        end
        
        function Tab:CreateToggle(name, default, callback)
            local ToggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = CurrentTheme.SurfaceLight,
                BorderSizePixel = 0,
                Parent = Page
            })
            
            Corner(ToggleFrame, 12)
            Stroke(ToggleFrame, CurrentTheme.Primary, 1.5, 0.7)
            RegisterTheme(ToggleFrame, {BackgroundColor3 = "SurfaceLight"})
            
            local Label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            RegisterTheme(Label, {TextColor3 = "Text"})
            
            local ToggleButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 55, 0, 30),
                Position = UDim2.new(1, -65, 0.5, -15),
                BackgroundColor3 = CurrentTheme.Surface,
                Text = "",
                AutoButtonColor = false,
                Parent = ToggleFrame
            })
            
            Corner(ToggleButton, 15)
            RegisterTheme(ToggleButton, {BackgroundColor3 = "Surface"})
            
            local ToggleCircle = CreateInstance("Frame", {
                Size = UDim2.new(0, 24, 0, 24),
                Position = UDim2.new(0, 3, 0.5, -12),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                Parent = ToggleButton
            })
            
            Corner(ToggleCircle, 12)
            Shadow(ToggleCircle, UDim2.new(1, 10, 1, 10), -5, 0.4)
            
            local toggled = default or false
            
            local function UpdateToggle(instant)
                local animInfo = instant and TweenInfo.new(0) or Animations.Smooth
                
                if toggled then
                    TweenService:Create(ToggleButton, animInfo, {
                        BackgroundColor3 = CurrentTheme.Success
                    }):Play()
                    
                    TweenService:Create(ToggleCircle, animInfo, {
                        Position = UDim2.new(1, -27, 0.5, -12)
                    }):Play()
                else
                    TweenService:Create(ToggleButton, animInfo, {
                        BackgroundColor3 = CurrentTheme.Surface
                    }):Play()
                    
                    TweenService:Create(ToggleCircle, animInfo, {
                        Position = UDim2.new(0, 3, 0.5, -12)
                    }):Play()
                end
            end
            
            UpdateToggle(true)
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
                callback(toggled)
            end)
            
            ToggleButton.MouseEnter:Connect(function()
                TweenService:Create(ToggleCircle, Animations.Fast, {
                    Size = UDim2.new(0, 28, 0, 28)
                }):Play()
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                TweenService:Create(ToggleCircle, Animations.Fast, {
                    Size = UDim2.new(0, 24, 0, 24)
                }):Play()
            end)
        end
        
        function Tab:CreateSlider(name, min, max, default, callback)
            local SliderFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 70),
                BackgroundColor3 = CurrentTheme.SurfaceLight,
                BorderSizePixel = 0,
                Parent = Page
            })
            
            Corner(SliderFrame, 12)
            Stroke(SliderFrame, CurrentTheme.Primary, 1.5, 0.7)
            RegisterTheme(SliderFrame, {BackgroundColor3 = "SurfaceLight"})
            
            local Label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -80, 0, 30),
                Position = UDim2.new(0, 15, 0, 8),
                BackgroundTransparency = 1,
                Text = name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            RegisterTheme(Label, {TextColor3 = "Text"})
            
            local ValueLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 60, 0, 30),
                Position = UDim2.new(1, -70, 0, 8),
                BackgroundTransparency = 1,
                Text = tostring(default),
                Font = Enum.Font.GothamBlack,
                TextSize = 15,
                TextColor3 = CurrentTheme.Primary,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame
            })
            
            RegisterTheme(ValueLabel, {TextColor3 = "Primary"})
            
            local SliderTrack = CreateInstance("Frame", {
                Size = UDim2.new(1, -30, 0, 8),
                Position = UDim2.new(0, 15, 1, -25),
                BackgroundColor3 = CurrentTheme.Surface,
                BorderSizePixel = 0,
                Parent = SliderFrame
            })
            
            Corner(SliderTrack, 4)
            RegisterTheme(SliderTrack, {BackgroundColor3 = "Surface"})
            
            local SliderFill = CreateInstance("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = CurrentTheme.Primary,
                BorderSizePixel = 0,
                Parent = SliderTrack
            })
            
            Corner(SliderFill, 4)
            Gradient(SliderFill, {
                ColorSequenceKeypoint.new(0, CurrentTheme.Primary),
                ColorSequenceKeypoint.new(1, CurrentTheme.Accent)
            }, 0)
            
            local SliderKnob = CreateInstance("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, -9, 0.5, -9),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = SliderFill
            })
            
            Corner(SliderKnob, 9)
            Shadow(SliderKnob, UDim2.new(1, 12, 1, 12), -6, 0.5)
            
            local dragging = false
            local value = default
            
            local function UpdateSlider(val, instant)
                value = math.clamp(val, min, max)
                local percent = (value - min) / (max - min)
                
                local animInfo = instant and TweenInfo.new(0) or Animations.Fast
                
                TweenService:Create(SliderFill, animInfo, {
                    Size = UDim2.new(percent, 0, 1, 0)
                }):Play()
                
                ValueLabel.Text = tostring(math.floor(value))
                callback(value)
            end
            
            UpdateSlider(default, true)
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    
                    TweenService:Create(SliderKnob, Animations.Fast, {
                        Size = UDim2.new(0, 24, 0, 24)
                    }):Play()
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    
                    TweenService:Create(SliderKnob, Animations.Fast, {
                        Size = UDim2.new(0, 18, 0, 18)
                    }):Play()
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local percent = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local newValue = min + ((max - min) * percent)
                    UpdateSlider(newValue)
                end
            end)
        end
        
        function Tab:CreateDropdown(name, options, default, callback)
            local DropdownFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = CurrentTheme.SurfaceLight,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = Page
            })
            
            Corner(DropdownFrame, 12)
            Stroke(DropdownFrame, CurrentTheme.Primary, 1.5, 0.7)
            RegisterTheme(DropdownFrame, {BackgroundColor3 = "SurfaceLight"})
            
            local Label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -40, 0, 50),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = name .. ": " .. tostring(default),
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownFrame
            })
            
            RegisterTheme(Label, {TextColor3 = "Text"})
            
            local Arrow = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 30, 0, 50),
                Position = UDim2.new(1, -40, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = CurrentTheme.Primary,
                Parent = DropdownFrame
            })
            
            RegisterTheme(Arrow, {TextColor3 = "Primary"})
            
            local DropdownButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundTransparency = 1,
                Text = "",
                Parent = DropdownFrame
            })
            
            Ripple(DropdownButton, CurrentTheme.Primary)
            
            local OptionsContainer = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 50),
                BackgroundTransparency = 1,
                Parent = DropdownFrame
            })
            
            local OptionsLayout = CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3),
                Parent = OptionsContainer
            })
            
            local expanded = false
            local selected = default
            
            for _, option in ipairs(options) do
                local OptionButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = CurrentTheme.Surface,
                    Text = option,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = CurrentTheme.TextMuted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false,
                    Parent = OptionsContainer
                })
                
                CreateInstance("UIPadding", {
                    PaddingLeft = UDim.new(0, 15),
                    Parent = OptionButton
                })
                
                Corner(OptionButton, 8)
                Ripple(OptionButton, CurrentTheme.Primary)
                RegisterTheme(OptionButton, {
                    BackgroundColor3 = "Surface",
                    TextColor3 = "TextMuted"
                })
                
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, Animations.Fast, {
                        BackgroundColor3 = CurrentTheme.Primary,
                        TextColor3 = Color3.new(1, 1, 1)
                    }):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, Animations.Fast, {
                        BackgroundColor3 = CurrentTheme.Surface,
                        TextColor3 = CurrentTheme.TextMuted
                    }):Play()
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    Label.Text = name .. ": " .. option
                    
                    expanded = false
                    
                    TweenService:Create(DropdownFrame, Animations.Smooth, {
                        Size = UDim2.new(1, 0, 0, 50)
                    }):Play()
                    
                    TweenService:Create(Arrow, Animations.Fast, {
                        Rotation = 0
                    }):Play()
                    
                    callback(option)
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                
                local targetSize = expanded and (50 + #options * 38) or 50
                
                TweenService:Create(DropdownFrame, Animations.Smooth, {
                    Size = UDim2.new(1, 0, 0, targetSize)
                }):Play()
                
                TweenService:Create(Arrow, Animations.Fast, {
                    Rotation = expanded and 180 or 0
                }):Play()
            end)
        end
        
        function Tab:CreateTextbox(name, placeholder, callback)
            local TextboxFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = CurrentTheme.SurfaceLight,
                BorderSizePixel = 0,
                Parent = Page
            })
            
            Corner(TextboxFrame, 12)
            Stroke(TextboxFrame, CurrentTheme.Primary, 1.5, 0.7)
            RegisterTheme(TextboxFrame, {BackgroundColor3 = "SurfaceLight"})
            
            local Label = CreateInstance("TextLabel", {
                Size = UDim2.new(0.4, 0, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TextboxFrame
            })
            
            RegisterTheme(Label, {TextColor3 = "Text"})
            
            local InputFrame = CreateInstance("Frame", {
                Size = UDim2.new(0.55, 0, 0, 35),
                Position = UDim2.new(1, -15, 0.5, -17.5),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = CurrentTheme.Surface,
                BorderSizePixel = 0,
                Parent = TextboxFrame
            })
            
            Corner(InputFrame, 8)
            RegisterTheme(InputFrame, {BackgroundColor3 = "Surface"})
            
            local Textbox = CreateInstance("TextBox", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = "",
                PlaceholderText = placeholder,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                Parent = InputFrame
            })
            
            RegisterTheme(Textbox, {TextColor3 = "Text"})
            
            Textbox.Focused:Connect(function()
                TweenService:Create(InputFrame, Animations.Fast, {
                    BackgroundColor3 = CurrentTheme.Primary
                }):Play()
                
                TweenService:Create(Textbox, Animations.Fast, {
                    TextColor3 = Color3.new(1, 1, 1)
                }):Play()
            end)
            
            Textbox.FocusLost:Connect(function()
                TweenService:Create(InputFrame, Animations.Fast, {
                    BackgroundColor3 = CurrentTheme.Surface
                }):Play()
                
                TweenService:Create(Textbox, Animations.Fast, {
                    TextColor3 = CurrentTheme.Text
                }):Play()
                
                callback(Textbox.Text)
            end)
        end
        
        function Tab:CreateLabel(text)
            local LabelFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                Parent = Page
            })
            
            local Label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = CurrentTheme.TextMuted,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = LabelFrame
            })
            
            RegisterTheme(Label, {TextColor3 = "TextMuted"})
        end
        
        function Tab:CreateDivider()
            local Divider = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 2),
                BackgroundColor3 = CurrentTheme.Primary,
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
                Parent = Page
            })
            
            Corner(Divider, 1)
            RegisterTheme(Divider, {BackgroundColor3 = "Primary"})
        end
        
        return Tab
    end
    
    -- ══════════════════════════════════════════════════════════════════
    -- NOTIFICATIONS
    -- ══════════════════════════════════════════════════════════════════
    
    function Window:Notify(title, message, duration, type)
        duration = duration or 3
        type = type or "Info"
        
        local typeColors = {
            Success = CurrentTheme.Success,
            Warning = CurrentTheme.Warning,
            Error = CurrentTheme.Error,
            Info = CurrentTheme.Primary
        }
        
        local color = typeColors[type] or CurrentTheme.Primary
        
        local NotifFrame = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 0, 80),
            Position = UDim2.new(1, 20, 1, -100),
            BackgroundColor3 = CurrentTheme.Surface,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            Parent = ScreenGui
        })
        
        Corner(NotifFrame, 12)
        Stroke(NotifFrame, color, 2)
        Shadow(NotifFrame, UDim2.new(1, 30, 1, 30), -15, 0.6)
        Blur(NotifFrame, 80)
        
        local IconFrame = CreateInstance("Frame", {
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(0, 15, 0.5, -25),
            BackgroundColor3 = color,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            Parent = NotifFrame
        })
        
        Corner(IconFrame, 25)
        
        local Icon = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = type == "Success" and "✓" or type == "Warning" and "⚠" or type == "Error" and "✕" or "ℹ",
            Font = Enum.Font.GothamBlack,
            TextSize = 24,
            TextColor3 = Color3.new(1, 1, 1),
            Parent = IconFrame
        })
        
        local TitleLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -90, 0, 25),
            Position = UDim2.new(0, 75, 0, 15),
            BackgroundTransparency = 1,
            Text = title,
            Font = Enum.Font.GothamBlack,
            TextSize = 15,
            TextColor3 = color,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = NotifFrame
        })
        
        local MessageLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -90, 0, 35),
            Position = UDim2.new(0, 75, 0, 40),
            BackgroundTransparency = 1,
            Text = message,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = CurrentTheme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = NotifFrame
        })
        
        RegisterTheme(MessageLabel, {TextColor3 = "Text"})
        
        -- Animate in
        TweenService:Create(NotifFrame, Animations.Bounce, {
            Size = UDim2.new(0, 350, 0, 80),
            Position = UDim2.new(1, -370, 1, -100)
        }):Play()
        
        -- Auto close
        task.delay(duration, function()
            TweenService:Create(NotifFrame, Animations.Smooth, {
                Position = UDim2.new(1, 20, 1, -100),
                Size = UDim2.new(0, 0, 0, 80)
            }):Play()
            
            task.wait(0.5)
            NotifFrame:Destroy()
        end)
    end
    
    -- ══════════════════════════════════════════════════════════════════
    -- DISCORD PROMPT
    -- ══════════════════════════════════════════════════════════════════
    
    function Window:ShowDiscordPrompt()
        task.delay(3, function()
            local PromptFrame = CreateInstance("Frame", {
                Size = UDim2.new(0, 0, 0, 160),
                Position = UDim2.new(1, 20, 1, -180),
                BackgroundColor3 = CurrentTheme.Surface,
                BackgroundTransparency = 0.1,
                BorderSizePixel = 0,
                Parent = ScreenGui
            })
            
            Corner(PromptFrame, 16)
            Stroke(PromptFrame, CurrentTheme.Accent, 2)
            Shadow(PromptFrame, UDim2.new(1, 40, 1, 40), -20, 0.7)
            Blur(PromptFrame, 100)
            Particles(PromptFrame)
            
            local DiscordIcon = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 50, 0, 50),
                Position = UDim2.new(0, 20, 0, 20),
                BackgroundColor3 = Color3.fromRGB(88, 101, 242),
                Text = "D",
                Font = Enum.Font.GothamBlack,
                TextSize = 28,
                TextColor3 = Color3.new(1, 1, 1),
                Parent = PromptFrame
            })
            
            Corner(DiscordIcon, 12)
            
            local Title = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -90, 0, 25),
                Position = UDim2.new(0, 80, 0, 25),
                BackgroundTransparency = 1,
                Text = "Join Our Discord!",
                Font = Enum.Font.GothamBlack,
                TextSize = 16,
                TextColor3 = CurrentTheme.Accent,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = PromptFrame
            })
            
            RegisterTheme(Title, {TextColor3 = "Accent"})
            
            local Message = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -40, 0, 40),
                Position = UDim2.new(0, 20, 0, 60),
                BackgroundTransparency = 1,
                Text = "Get updates, support, and exclusive scripts!",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = CurrentTheme.TextMuted,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = PromptFrame
            })
            
            RegisterTheme(Message, {TextColor3 = "TextMuted"})
            
            local JoinButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 150, 0, 35),
                Position = UDim2.new(0, 20, 1, -50),
                BackgroundColor3 = CurrentTheme.Success,
                Text = "Copy Invite",
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Color3.new(1, 1, 1),
                AutoButtonColor = false,
                Parent = PromptFrame
            })
            
            Corner(JoinButton, 10)
            Ripple(JoinButton, Color3.new(1, 1, 1))
            
            local CloseButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 150, 0, 35),
                Position = UDim2.new(1, -170, 1, -50),
                BackgroundColor3 = CurrentTheme.SurfaceLight,
                Text = "No Thanks",
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = CurrentTheme.TextMuted,
                AutoButtonColor = false,
                Parent = PromptFrame
            })
            
            Corner(CloseButton, 10)
            Ripple(CloseButton, CurrentTheme.Primary)
            RegisterTheme(CloseButton, {
                BackgroundColor3 = "SurfaceLight",
                TextColor3 = "TextMuted"
            })
            
            TweenService:Create(PromptFrame, Animations.Bounce, {
                Size = UDim2.new(0, 380, 0, 160),
                Position = UDim2.new(1, -400, 1, -180)
            }):Play()
            
            JoinButton.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard("https://discord.gg/yourinvite")
                    JoinButton.Text = "Copied!"
                    JoinButton.BackgroundColor3 = CurrentTheme.Primary
                    
                    task.wait(1)
                    
                    TweenService:Create(PromptFrame, Animations.Smooth, {
                        Position = UDim2.new(1, 20, 1, -180),
                        Size = UDim2.new(0, 0, 0, 160)
                    }):Play()
                    
                    task.wait(0.5)
                    PromptFrame:Destroy()
                end
            end)
            
            CloseButton.MouseButton1Click:Connect(function()
                TweenService:Create(PromptFrame, Animations.Smooth, {
                    Position = UDim2.new(1, 20, 1, -180),
                    Size = UDim2.new(0, 0, 0, 160)
                }):Play()
                
                task.wait(0.5)
                PromptFrame:Destroy()
            end)
            
            JoinButton.MouseEnter:Connect(function()
                TweenService:Create(JoinButton, Animations.Fast, {
                    Size = UDim2.new(0, 155, 0, 38)
                }):Play()
            end)
            
            JoinButton.MouseLeave:Connect(function()
                TweenService:Create(JoinButton, Animations.Fast, {
                    Size = UDim2.new(0, 150, 0, 35)
                }):Play()
            end)
            
            CloseButton.MouseEnter:Connect(function()
                TweenService:Create(CloseButton, Animations.Fast, {
                    BackgroundColor3 = CurrentTheme.Primary,
                    TextColor3 = Color3.new(1, 1, 1)
                }):Play()
            end)
            
            CloseButton.MouseLeave:Connect(function()
                TweenService:Create(CloseButton, Animations.Fast, {
                    BackgroundColor3 = CurrentTheme.SurfaceLight,
                    TextColor3 = CurrentTheme.TextMuted
                }):Play()
            end)
        end)
    end
    
    -- ══════════════════════════════════════════════════════════════════
    -- THEME MANAGER
    -- ══════════════════════════════════════════════════════════════════
    
    function Window:SetTheme(themeName)
        local theme = Themes[themeName]
        if theme then
            ApplyTheme(theme)
        end
    end
    
    function Window:GetThemes()
        local themeList = {}
        for name, _ in pairs(Themes) do
            table.insert(themeList, name)
        end
        return themeList
    end
    
    return Window
end

return EmloxaLibrary
