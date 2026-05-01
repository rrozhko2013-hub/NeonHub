local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Очистка старых версий
if game:GetService("CoreGui"):FindFirstChild("NeonHub") then
    game:GetService("CoreGui").NeonHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- ОКНО ВВОДА КЛЮЧА
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = ScreenGui
KeyFrame.Size = UDim2.new(0, 250, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyCorner = Instance.new("UICorner", KeyFrame)
local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color = Color3.fromRGB(0, 255, 255)
KeyStroke.Thickness = 2

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Text = "NEON HUB: ACCESS"
KeyTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 18

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 35)
KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
KeyInput.PlaceholderText = "Введите любой ключ..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", KeyInput)

local CheckBtn = Instance.new("TextButton", KeyFrame)
CheckBtn.Size = UDim2.new(0.8, 0, 0, 35)
CheckBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
CheckBtn.Text = "АКТИВИРОВАТЬ"
CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
CheckBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
CheckBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CheckBtn)

--- ФУНКЦИЯ ЗАПУСКА ХАБА ---
local function StartHub()
    KeyFrame:Destroy() 

    -- ПЛАВАЮЩАЯ ИКОНКА "N"
    local OpenIcon = Instance.new("TextButton", ScreenGui)
    OpenIcon.Size = UDim2.new(0, 45, 0, 45)
    OpenIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
    OpenIcon.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    OpenIcon.Text = "N"
    OpenIcon.Font = Enum.Font.GothamBold
    OpenIcon.TextSize = 22
    OpenIcon.Draggable = true
    Instance.new("UICorner", OpenIcon).CornerRadius = UDim.new(1, 0)

    -- ГЛАВНОЕ ОКНО
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 220, 0, 260)
    MainFrame.Position = UDim2.new(0.5, -110, 0.5, -130)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.Visible = false
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local HubStroke = Instance.new("UIStroke", MainFrame)
    HubStroke.Color = Color3.fromRGB(0, 255, 255)
    HubStroke.Thickness = 2

    OpenIcon.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- ЗАГОЛОВОК
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.Text = "NEON HUB"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(0, 0, 0)
    Title.BackgroundTransparency = 1

    local function AddButton(name, pos, callback)
        local btn = Instance.new("TextButton", MainFrame)
        btn.Size = UDim2.new(0.85, 0, 0, 38)
        btn.Position = pos
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        btn.TextColor3 = Color3.fromRGB(0, 255, 255)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    AddButton("ESP (ВХ)", UDim2.new(0.075, 0, 0.25, 0), function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Color3.fromRGB(0, 255, 255)
            end
        end
    end)

    local aimActive = false
    local aimBtn = AddButton("AIM: OFF", UDim2.new(0.075, 0, 0.45, 0), function()
        aimActive = not aimActive
    end)

    RunService.RenderStepped:Connect(function()
        aimBtn.Text = aimActive and "AIM: ON" or "AIM: OFF"
        if aimActive then
            local target = nil
            local maxDist = 1000
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if onScreen then
                        local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if mag < maxDist then target = p.Character.Head maxDist = mag end
                    end
                end
            end
            if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
        end
    end)

    AddButton("УДАЛИТЬ ХАБ", UDim2.new(0.075, 0, 0.75, 0), function()
        ScreenGui:Destroy()
    end)
end

-- ЛОЖНАЯ ПРОВЕРКА КЛЮЧА
CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text ~= "" then -- Если введено хоть что-то
        CheckBtn.Text = "КЛЮЧ ПРИНЯТ!"
        CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        wait(0.7)
        StartHub()
    else
        CheckBtn.Text = "ВВЕДИТЕ ЧТО-НИБУДЬ"
        wait(1)
        CheckBtn.Text = "АКТИВИРОВАТЬ"
    end
end)
