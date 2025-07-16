local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew",true))()

local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")
local WorkspaceService = game:GetService("Workspace")
local Camera = WorkspaceService.CurrentCamera
local LocalPlayer = PlayersService.LocalPlayer

local PlayerESP = {
    Objects = {},
    Connections = {}
}

function PlayerESP:CreateDrawing(Type, Properties)
    local Drawing = Drawing.new(Type)
    for Property, Value in pairs(Properties) do
        Drawing[Property] = Value
    end
    return Drawing
end

function PlayerESP:CreateRainbow(Time)
    return Color3.new(
        math.sin(Time * 2) * 0.5 + 0.5,
        math.sin(Time * 2 + 2) * 0.5 + 0.5,
        math.sin(Time * 2 + 4) * 0.5 + 0.5
    )
end

function PlayerESP:CreateESPObject()
    return {
        Line = self:CreateDrawing("Line", {Visible = false, Thickness = 2, Transparency = 0.8}),
        Text = self:CreateDrawing("Text", {Visible = false, Center = true, Outline = true, Size = 16, Font = 2})
    }
end

function PlayerESP:HideESP(ESPData)
    ESPData.Line.Visible = false
    ESPData.Text.Visible = false
    return self
end

function PlayerESP:CleanESP(Player)
    if self.Objects[Player] then
        for _, Drawing in pairs(self.Objects[Player]) do
            Drawing:Remove()
        end
        self.Objects[Player] = nil
    end
    return self
end

function PlayerESP:GetHumanoidRootPart()
    local Character = LocalPlayer.Character
    return Character and Character:FindFirstChild("HumanoidRootPart")
end

function PlayerESP:GetPlayerHRP(Player)
    local Character = Player.Character
    return Character and Character:FindFirstChild("HumanoidRootPart")
end

function PlayerESP:RenderESP()
    if LocalPlayer.Name ~= "Enemy" then return self end
    
    local CurrentTime = tick()
    local MyHRP = self:GetHumanoidRootPart()
    if not MyHRP then return self end

    local MyScreen, MyVisible = Camera:WorldToViewportPoint(MyHRP.Position)
    if not MyVisible then return self end

    local MyPoint = Vector2.new(MyScreen.X, MyScreen.Y)
    local AllPlayers = PlayersService:GetPlayers()

    for Player in pairs(self.Objects) do
        local Found = false
        for _, CurrentPlayer in pairs(AllPlayers) do
            if CurrentPlayer == Player and CurrentPlayer ~= LocalPlayer then
                Found = true
                break
            end
        end
        if not Found then
            self:CleanESP(Player)
        end
    end

    for _, Player in pairs(AllPlayers) do
        if Player ~= LocalPlayer then
            local PlayerHRP = self:GetPlayerHRP(Player)
            if PlayerHRP then
                local Success, PlayerScreen, PlayerVisible = pcall(function()
                    return Camera:WorldToViewportPoint(PlayerHRP.Position)
                end)

                if Success and PlayerVisible then
                    local ESPData = self.Objects[Player] or self:CreateESPObject()
                    self.Objects[Player] = ESPData

                    local RainbowColor = self:CreateRainbow(CurrentTime)
                    local PlayerPoint = Vector2.new(PlayerScreen.X, PlayerScreen.Y)

                    ESPData.Line.Visible = true
                    ESPData.Line.From = MyPoint
                    ESPData.Line.To = PlayerPoint
                    ESPData.Line.Color = RainbowColor

                    ESPData.Text.Visible = true
                    ESPData.Text.Text = Player.Name
                    ESPData.Text.Position = Vector2.new(PlayerScreen.X, PlayerScreen.Y - 20)
                    ESPData.Text.Color = RainbowColor
                else
                    if self.Objects[Player] then
                        self:HideESP(self.Objects[Player])
                    end
                end
            else
                if self.Objects[Player] then
                    self:HideESP(self.Objects[Player])
                end
            end
        end
    end

    return self
end

function PlayerESP:Connect()
    self.Connections.Render = RunService.RenderStepped:Connect(function()
        self:RenderESP()
    end)
    self.Connections.PlayerRemoving = PlayersService.PlayerRemoving:Connect(function(Player)
        self:CleanESP(Player)
    end)
    return self
end

function PlayerESP:Disconnect()
    for _, Connection in pairs(self.Connections) do
        Connection:Disconnect()
    end
    for Player in pairs(self.Objects) do
        self:CleanESP(Player)
    end
    return self
end

function PlayerESP:Init()
    return self:Connect()
end

getgenv().PlayerESP = PlayerESP

local tab = library:CreateWindow("MicaHub")

local folder = tab:AddFolder("Wall Hack")

folder:AddToggle({
	text = "Wall Items",
	flag = "toggle",
	callback = function(v)
	end
})

folder:AddToggle({
	text = "Wall Players",
	flag = "toggle",
	callback = function(v)
	end
})

folder:AddToggle({
	text = "Wall Traps",
	flag = "toggle",
	callback = function(v)
	end
})

tab:AddLabel({
	text = "GitHub: Mkklz",
	type = "label"
})

library:Init()