print("Loading Herkle Hub -- Booga Booga Reborn (Fixed Copy + Smaller Waypoints + Improved ESP)")
print("-----------------------------------------")

-- Загрузка Fluent Renewed (с обработкой ошибок)
local Library
local success, err = pcall(function()
    Library = loadstring(game:HttpGetAsync("https://github.com/1dontgiveaf/Fluent-Renewed/releases/download/v1.0/Fluent.luau"))()
end)
if not success then
    warn("Fluent failed to load: " .. tostring(err) .. ". Try updating your exploit or check internet.")
    return
end

local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/1dontgiveaf/Fluent-Renewed/refs/heads/main/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/1dontgiveaf/Fluent-Renewed/refs/heads/main/Addons/InterfaceManager.luau"))()

local Window = Library:CreateWindow{
    Title = "Herkle Hub -- Booga Booga Reborn",
    SubTitle = "by herkle berlington (Fixed Copy/Waypoints/ESP)",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 500),  -- Полный размер без обрезки
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
}

local Tabs = {
    Waypoints = Window:AddTab({ Title = "Waypoints", Icon = "map-pin" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" }), Main = Window:AddTab({ Title = "Main", Icon = "menu" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "axe" }),
    Map = Window:AddTab({ Title = "Map", Icon = "trees" }),
    Pickup = Window:AddTab({ Title = "Pickup", Icon = "backpack" }),
}
local rs = game:GetService("ReplicatedStorage")
local packets = require(rs.Modules.Packets)
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local runs = game:GetService("RunService")
local httpservice = game:GetService("HttpService")
local Players = game:GetService("Players")
local localiservice = game:GetService("LocalizationService")
local marketservice = game:GetService("MarketplaceService")
local rbxservice = game:GetService("RbxAnalyticsService")
local placestructure
local tspmo = game:GetService("TweenService")
local itemslist = {
"Adurite", "Berry", "Bloodfruit", "Bluefruit", "Coin", "Essence", "Hide", "Ice Cube", "Iron", "Jelly", "Leaves", "Log", "Steel", "Stone", "Wood", "Gold", "Raw Gold", "Crystal Chunk", "Raw Emerald", "Pink Diamond", "Raw Adurite", "Raw Iron", "Coal"}
local Options = Library.Options
local plr = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

--Main Tab
local msatoggle = Tabs.Main:CreateToggle("msatoggle", { Title = "No Mountain Slip", Default = false })
-- Combat Tab
local killauratoggle = Tabs.Combat:CreateToggle("killauratoggle", { Title = "Kill Aura", Default = false })
local killaurarangeslider = Tabs.Combat:CreateSlider("killaurarange", { Title = "Range", Min = 1, Max = 9, Rounding = 1, Default = 5 })
local katargetcountdropdown = Tabs.Combat:CreateDropdown("katargetcountdropdown", { Title = "Max Targets", Values = { "1", "2", "3", "4", "5", "6" }, Default = "1" })
local kaswingcooldownslider = Tabs.Combat:CreateSlider("kaswingcooldownslider", { Title = "Attack Cooldown (s)", Min = 0.01, Max = 1.01, Rounding = 2, Default = 0.1 })
--Map Tab
local resourceauratoggle = Tabs.Map:CreateToggle("resourceauratoggle", { Title = "Resource Aura", Default = false })
local resourceaurarange = Tabs.Map:CreateSlider("resourceaurarange", { Title = "Range", Min = 1, Max = 20, Rounding = 1, Default = 20 })
local resourcetargetdropdown = Tabs.Map:CreateDropdown("resourcetargetdropdown", { Title = "Max Targets", Values = { "1", "2", "3", "4", "5", "6" }, Default = "1" })
local resourcecooldownslider = Tabs.Map:CreateSlider("resourcecooldownslider", { Title = "Swing Cooldown (s)", Min = 0.01, Max = 1.01, Rounding = 2, Default = 0.1 })
--Pickup Tab
local autopickuptoggle = Tabs.Pickup:CreateToggle("autopickuptoggle", { Title = "Auto Pickup", Default = false })
local chestpickuptoggle = Tabs.Pickup:CreateToggle("chestpickuptoggle", { Title = "Auto Pickup From Chests", Default = false })
local pickuprangeslider = Tabs.Pickup:CreateSlider("pickuprange", { Title = "Pickup Range", Min = 1, Max = 35, Rounding = 1, Default = 20 })
local itemdropdown = Tabs.Pickup:CreateDropdown("itemdropdown", {Title = "Items", Values = {"Berry", "Bloodfruit", "Bluefruit", "Lemon", "Strawberry", "Gold", "Raw Gold", "Crystal Chunk", "Coin", "Coins", "Coin2", "Coin Stack", "Essence", "Emerald", "Raw Emerald", "Pink Diamond", "Raw Pink Diamond", "Void Shard","Jelly", "Magnetite", "Raw Magnetite", "Adurite", "Raw Adurite", "Ice Cube", "Stone", "Iron", "Raw Iron", "Steel", "Hide", "Leaves", "Log", "Wood", "Pie"}, Multi = true, Default = { Leaves = true, Log = true }})
local droptoggle = Tabs.Pickup:AddToggle("droptoggle", { Title = "Auto Drop", Default = false })
local dropdropdown = Tabs.Pickup:AddDropdown("dropdropdown", {Title = "Select Item to Drop", Values = { "Bloodfruit", "Jelly", "Bluefruit", "Log", "Leaves", "Wood" }, Default = "Bloodfruit"})
local droptogglemanual = Tabs.Pickup:AddToggle("droptogglemanual", { Title = "Auto Drop Custom", Default = false })
local droptextbox = Tabs.Pickup:AddInput("droptextbox", { Title = "Custom Item", Default = "Bloodfruit", Numeric = false, Finished = false })

-- end of tabs element
local function onplradded(newChar)
    char = newChar
    root = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")

    updws()
    updhh()
end

plr.CharacterAdded:Connect(onplradded)

local slopecon
local function updmsa()
    if slopecon then slopecon:Disconnect() end

    if Options.msatoggle.Value then
        slopecon = game:GetService("RunService").RenderStepped:Connect(function()
            if hum then
                hum.MaxSlopeAngle = 90
            end
        end)
    else
        if hum then
            hum.MaxSlopeAngle = 46
        end
    end
end

Options.msatoggle:OnChanged(updmsa)

local function getlayout(itemname)
    local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
    if not inventory then
        return nil
    end
    for _, child in ipairs(inventory:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemname then
            return child.LayoutOrder
        end
    end
    return nil
end

local function swingtool(tspmogngicl)
    if packets.SwingTool and packets.SwingTool.send then
        packets.SwingTool.send(tspmogngicl)
    end
end

local function pickup(entityid)
    if packets.Pickup and packets.Pickup.send then
        packets.Pickup.send(entityid)
    end
end

local function drop(itemname)
    local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
    if not inventory then return end

    for _, child in ipairs(inventory:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemname then
            if packets and packets.DropBagItem and packets.DropBagItem.send then
                packets.DropBagItem.send(child.LayoutOrder)
            end
        end
    end
end

local selecteditems = {}
itemdropdown:OnChanged(function(Value)
    selecteditems = {} 
    for item, State in pairs(Value) do
        if State then
            table.insert(selecteditems, item)
        end
    end
end)

task.spawn(function()
    while true do
        if not Options.killauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.killaurarange.Value) or 20
        local targetCount = tonumber(Options.katargetcountdropdown.Value) or 1
        local cooldown = tonumber(Options.kaswingcooldownslider.Value) or 0.1
        local targets = {}

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= plr then
                local playerfolder = workspace.Players:FindFirstChild(player.Name)
                if playerfolder then
                    local rootpart = playerfolder:FindFirstChild("HumanoidRootPart")
                    local entityid = playerfolder:GetAttribute("EntityID")

                    if rootpart and entityid then
                        local dist = (rootpart.Position - root.Position).Magnitude
                        if dist <= range then
                            table.insert(targets, { eid = entityid, dist = dist })
                        end
                    end
                end
            end
        end

        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end

        task.wait(cooldown)
    end
end)

task.spawn(function()
    while true do
        if not Options.resourceauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.resourceaurarange.Value) or 20
        local targetCount = tonumber(Options.resourcetargetdropdown.Value) or 1
        local cooldown = tonumber(Options.resourcecooldownslider.Value) or 0.1
        local targets = {}
        local allresources = {}

        for _, r in pairs(workspace.Resources:GetChildren()) do
            table.insert(allresources, r)
        end
        for _, r in pairs(workspace:GetChildren()) do
            if r:IsA("Model") and r.Name == "Gold Node" then
                table.insert(allresources, r)
            end
        end

        for _, res in pairs(allresources) do
            if res:IsA("Model") and res:GetAttribute("EntityID") then
                local eid = res:GetAttribute("EntityID")
                local ppart = res.PrimaryPart or res:FindFirstChildWhichIsA("BasePart")
                if ppart then
                    local dist = (ppart.Position - root.Position).Magnitude
                    if dist <= range then
                        table.insert(targets, { eid = eid, dist = dist })
                    end
                end
            end
        end

        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end
task.wait(cooldown)
    end
end)

task.spawn(function()
    while true do
        if not Options.critterauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.critterrangeslider.Value) or 20
        local targetCount = tonumber(Options.crittertargetdropdown.Value) or 1
        local cooldown = tonumber(Options.crittercooldownslider.Value) or 0.1
        local targets = {}

        for _, critter in pairs(workspace.Critters:GetChildren()) do
            if critter:IsA("Model") and critter:GetAttribute("EntityID") then
                local eid = critter:GetAttribute("EntityID")
                local ppart = critter.PrimaryPart or critter:FindFirstChildWhichIsA("BasePart")

                if ppart then
                    local dist = (ppart.Position - root.Position).Magnitude
                    if dist <= range then
                        table.insert(targets, { eid = eid, dist = dist })
                    end
                end
            end
        end

        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end

        task.wait(cooldown)
    end
end)



task.spawn(function()
    while true do
        local range = tonumber(Options.pickuprange.Value) or 35

        if Options.autopickuptoggle.Value then
            for _, item in ipairs(workspace.Items:GetChildren()) do
                if item:IsA("BasePart") or item:IsA("MeshPart") then
                    local selecteditem = item.Name
                    local entityid = item:GetAttribute("EntityID")

                    if entityid and table.find(selecteditems, selecteditem) then
                        local dist = (item.Position - root.Position).Magnitude
                        if dist <= range then
                            pickup(entityid)
                        end
                    end
                end
            end
        end

        if Options.chestpickuptoggle.Value then
            for _, chest in ipairs(workspace.Deployables:GetChildren()) do
                if chest:IsA("Model") and chest:FindFirstChild("Contents") then
                    for _, item in ipairs(chest.Contents:GetChildren()) do
                        if item:IsA("BasePart") or item:IsA("MeshPart") then
                            local selecteditem = item.Name
                            local entityid = item:GetAttribute("EntityID")

                            if entityid and table.find(selecteditems, selecteditem) then
                                local dist = (chest.PrimaryPart.Position - root.Position).Magnitude
                                if dist <= range then
                                    pickup(entityid)
                                end
                            end
                        end
                    end
                end
            end
        end

        task.wait(0.01)
    end
end)

local debounce = 0
local cd = 0 -- i genuinely dont know why it breaks now, but turn this up to 0.3 - 0.2 to stop it from dropping other items
runs.Heartbeat:Connect(function()
    if Options.droptoggle.Value then
        if tick() - debounce >= cd then
            local selectedItem = Options.dropdropdown.Value
            drop(selectedItem)
            debounce = tick()
        end
    end
end)

runs.Heartbeat:Connect(function()
    if Options.droptogglemanual.Value then
        if tick() - debounce >= cd then
            local itemname = Options.droptextbox.Value
            drop(itemname)
            debounce = tick()
        end
    end
end)

-- Waypoint system (улучшенный для ходьбы)
local waypoints = {}
local autoWalkEnabled = false
local currentWaypointIndex = 1
local walkSpeed = 16  -- Стандартная скорость Humanoid
local delayBetweenPoints = 1
local lastWaypointTime = 0
local autoWalkConnection = nil
local isMovingToWaypoint = false  -- Флаг для отслеживания движения к waypoint

local function vectorToTable(pos)
    return {X = pos.X, Y = pos.Y, Z = pos.Z}
end

local function tableToVector(posTable)
    if posTable and posTable.X and posTable.Y and posTable.Z then
        return Vector3.new(posTable.X, posTable.Y, posTable.Z)
    end
    return nil
end

local function loadSavedWaypoints()
    local savedWaypoints = {}
    if isfile and isfile("waypoints.json") then
        local successRead, dataStr = pcall(readfile, "waypoints.json")
        if successRead then
            local successDecode, data = pcall(HttpService.JSONDecode, HttpService, dataStr)
            if successDecode then
                savedWaypoints = data or {}
                -- Конверт старого формата если нужно
                for key, positions in pairs(savedWaypoints) do
                    local newPositions = {}
                    for _, posTable in ipairs(positions) do
                        local pos = tableToVector(posTable)
                        if pos then table.insert(newPositions, pos) end
                    end
                    savedWaypoints[key] = newPositions
                end
            else
                warn("JSON decode failed for waypoints.json")
            end
        end
    end
    return savedWaypoints
end

local function saveWaypointData(savedWaypoints)
    if writefile then
        local serializableData = {}
        for key, positions in pairs(savedWaypoints) do
            serializableData[key] = {}
            for _, pos in ipairs(positions) do
                table.insert(serializableData[key], vectorToTable(pos))
            end
        end
        pcall(writefile, "waypoints.json", HttpService:JSONEncode(serializableData))
    end
end

local savedWaypoints = loadSavedWaypoints()

local function clearWaypoints()
    autoWalkEnabled = false
    isMovingToWaypoint = false
    if autoWalkConnection then autoWalkConnection:Disconnect() autoWalkConnection = nil end
    for _, wp in ipairs(waypoints) do
        if wp.part then pcall(function() wp.part:Destroy() end) end
    end
    waypoints = {}
    currentWaypointIndex = 1
    print("Cleared all waypoints.")
end

local function addWaypoint(position)
    if not position then return end
    local part = Instance.new("Part")
    part.Name = "WaypointPart"
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.new(1, 1, 1)  -- Уменьшил размер (поменьше)
    part.Position = Vector3.new(position.X, position.Y + 1, position.Z)  -- Понизил (ближе к земле)
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.ForceField
    part.Color = Color3.fromRGB(255, 0, 0)
    part.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 50, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)  -- Немного выше для номера
    billboard.Adornee = part
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = tostring(#waypoints + 1)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 24
    label.Parent = billboard

    table.insert(waypoints, {part = part, position = position})
    print("Added waypoint #" .. #waypoints .. " at " .. tostring(position))
end

local function removeLastWaypoint()
    if #waypoints > 0 then
        local last = table.remove(waypoints)
        if last.part then last.part:Destroy() end
        -- Обновить номера
        for i, wp in ipairs(waypoints) do
            if wp.part and wp.part:FindFirstChild("BillboardGui") then
                wp.part.BillboardGui.TextLabel.Text = tostring(i)
            end
        end
        if currentWaypointIndex > #waypoints then currentWaypointIndex = 1 end
        print("Removed last waypoint. Total: " .. #waypoints)
    end
end

local function stopAutoWalk()
    autoWalkEnabled = false
    currentWaypointIndex = 1
    isMovingToWaypoint = false
    if autoWalkConnection then autoWalkConnection:Disconnect() autoWalkConnection = nil end
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:MoveTo(char.HumanoidRootPart.Position)  -- Остановить на месте
            humanoid.WalkSpeed = 16  -- Вернуть стандартную скорость
        end
    end
    print("Stopped auto walk.")
end

local function startAutoWalk()
    if #waypoints == 0 then 
        return 
    end
    stopAutoWalk()
    autoWalkEnabled = true
    currentWaypointIndex = 1
    lastWaypointTime = tick()
    isMovingToWaypoint = false

    print("Starting auto walk to " .. #waypoints .. " waypoints.")

    autoWalkConnection = RunService.Heartbeat:Connect(function()
        if not autoWalkEnabled then return end
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then 
            print("Character/Humanoid not found, retrying...")
            return 
        end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        humanoid.WalkSpeed = walkSpeed

        if currentWaypointIndex > #waypoints then
            currentWaypointIndex = 1
            isMovingToWaypoint = false
            return
        end

        if not isMovingToWaypoint then
            local targetPos = waypoints[currentWaypointIndex].position
            humanoid:MoveTo(targetPos)
            isMovingToWaypoint = true
            humanoid.MoveToFinished:Once(function(reached)
                isMovingToWaypoint = false
                if reached then
                    local now = tick()
                    if (now - lastWaypointTime) >= delayBetweenPoints then
                        lastWaypointTime = now
                        currentWaypointIndex = currentWaypointIndex + 1
                        print("Reached waypoint " .. (currentWaypointIndex - 1) .. "! Moving to next.")
                    end
                end
                -- Если не достиг, флаг сбросится, и в следующем Heartbeat попробует снова
            end)
        end
    end)
end

-- ESP System (улучшенный: обводка вокруг персонажа вместо квадрата, исправленное расстояние)
local espEnabled = false
local espRange = 1000  -- Default range
local espConnections = {}
local espDrawings = {}
local showNames = true
local showBoxes = true
local showHealth = true
local showDistance = true
local boxColor = Color3.new(1, 0, 0)  -- Красный
local nameColor = Color3.new(1, 0, 0)  -- Красный
local boxThickness = 2

local function clearESP()
    for _, conn in pairs(espConnections) do
        conn:Disconnect()
    end
    espConnections = {}
    for _, drawing in pairs(espDrawings) do
        drawing:Remove()
    end
    espDrawings = {}
    -- Очистить BillboardGui
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= plr and player.Character then
            local char = player.Character
            local espName = char:FindFirstChild("ESP_Name")
            if espName then espName:Destroy() end
        end
    end
end

local function createESP(player)
    if player == plr or not player.Character then return end
    
    local char = player.Character
    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoidRootPart or not humanoid then return end
    
    -- BillboardGui для имени (красный, меньший размер, с HP и дистанцией)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name"
    billboard.Adornee = humanoidRootPart
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = nameColor
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 8  -- В 2 раза меньше
    nameLabel.Parent = billboard
    
    -- Обводка вокруг персонажа (используем несколько линий для контура bounding box, чтобы выглядело как обводка вокруг тела)
    local lines = {}
    for i = 1, 12 do  -- 12 линий для полного контура (верх, низ, стороны)
        local line = Drawing.new("Line")
        line.Thickness = boxThickness
        line.Color = boxColor
        line.Visible = false
        table.insert(espDrawings, line)
        table.insert(lines, line)
    end
    
    -- Обновление в RenderStepped
    local conn = RunService.RenderStepped:Connect(function()
        if not espEnabled or not char or not humanoidRootPart or not humanoid then
            for _, line in ipairs(lines) do line.Visible = false end
            billboard.Enabled = false
            return
        end
        
        local camera = workspace.CurrentCamera
        local plrPos = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart.Position or camera.CFrame.Position
        local distance = (plrPos - humanoidRootPart.Position).Magnitude  -- Расстояние от игрока до цели
        if distance > espRange then
            for _, line in ipairs(lines) do line.Visible = false end
            billboard.Enabled = false
            return
        end
        
        billboard.Enabled = showNames
        if showNames then
            local text = player.Name
            if showHealth then
                text = text .. " [" .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. "]"
            end
            if showDistance then
                text = text .. " [" .. math.floor(distance) .. "m]"
            end
            nameLabel.Text = text
            nameLabel.TextColor3 = nameColor
        end
        
        -- Обновить обводку (контур вокруг bounding box персонажа)
        if showBoxes then
            local rootPos = humanoidRootPart.Position
            local size = char:GetExtentsSize()
            local cf = CFrame.new(rootPos) * CFrame.Angles(0, camera.CFrame.LookVector:Dot(Vector3.new(0, 0, 1)) > 0 and math.pi or 0, 0)
            local corners = {
                cf * Vector3.new(-size.X/2, size.Y/2, -size.Z/2),  -- Верх лево перед
                cf * Vector3.new(size.X/2, size.Y/2, -size.Z/2),   -- Верх право перед
                cf * Vector3.new(size.X/2, -size.Y/2, -size.Z/2),  -- Низ право перед
                cf * Vector3.new(-size.X/2, -size.Y/2, -size.Z/2), -- Низ лево перед
                cf * Vector3.new(-size.X/2, size.Y/2, size.Z/2),   -- Верх лево зад
                cf * Vector3.new(size.X/2, size.Y/2, size.Z/2),    -- Верх право зад
                cf * Vector3.new(size.X/2, -size.Y/2, size.Z/2),   -- Низ право зад
                cf * Vector3.new(-size.X/2, -size.Y/2, size.Z/2)   -- Низ лево зад
            }
            
            local screenCorners = {}
            for _, corner in ipairs(corners) do
                local screenPos, onScreen = camera:WorldToViewportPoint(corner)
                if onScreen then
table.insert(screenCorners, screenPos)
                end
            end
            
            if #screenCorners >= 8 then
                -- Соединить углы линиями для контура
                local connections = {
                    {1,2}, {2,3}, {3,4}, {4,1},  -- Передний квадрат
                    {5,6}, {6,7}, {7,8}, {8,5},  -- Задний квадрат
                    {1,5}, {2,6}, {3,7}, {4,8}   -- Соединения сторон
                }
                for i, conn in ipairs(connections) do
                    local line = lines[i]
                    if line then
                        line.From = Vector2.new(screenCorners[conn[1]].X, screenCorners[conn[1]].Y)
                        line.To = Vector2.new(screenCorners[conn[2]].X, screenCorners[conn[2]].Y)
                        line.Color = boxColor
                        line.Thickness = boxThickness
                        line.Visible = true
                    end
                end
                -- Скрыть лишние линии
                for i = #connections + 1, #lines do
                    lines[i].Visible = false
                end
            else
                for _, line in ipairs(lines) do line.Visible = false end
            end
        else
            for _, line in ipairs(lines) do line.Visible = false end
        end
    end)
    
    table.insert(espConnections, conn)
end

local function updateESP()
    clearESP()
    if not espEnabled then return end
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= plr then
            createESP(player)
        end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        createESP(player)
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    -- Очистка автоматически через clearESP при обновлении
end)

-- UI (все секции)
local WaypointsTab = Tabs.Waypoints

-- Секция Management
local ManagementSection = WaypointsTab:AddSection("Waypoint Management")
ManagementSection:AddButton({
    Title = "Add Waypoint (Current Pos)",
    Callback = function()
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            addWaypoint(char.HumanoidRootPart.Position)
        end
    end
})
ManagementSection:AddButton({
    Title = "Remove Last",
    Callback = removeLastWaypoint
})
ManagementSection:AddButton({
    Title = "Clear All",
    Callback = clearWaypoints
})

-- Секция Auto Walk
local AutoSection = WaypointsTab:AddSection("Auto Walk")
local autoToggle = AutoSection:AddToggle("AutoToggle", {
    Title = "Enable Auto Walk",
    Default = false,
    Callback = function(value)
        if value then startAutoWalk() else stopAutoWalk() end
    end
})
AutoSection:AddSlider("SpeedSlider", {
    Title = "Walk Speed",
    Default = 16,
    Min = 8,
    Max = 50,
    Callback = function(value) walkSpeed = value end
})
AutoSection:AddSlider("DelaySlider", {
    Title = "Delay Between Points (sec)",
    Default = 1,
    Min = 0,
    Max = 5,
    Callback = function(value) delayBetweenPoints = value end
})

-- Секция Save/Load
local SaveSection = WaypointsTab:AddSection("Save/Load")
SaveSection:AddButton({
    Title = "Save as Gold 1",
    Callback = function()
        savedWaypoints["gold 1"] = {}
        for _, wp in ipairs(waypoints) do
            table.insert(savedWaypoints["gold 1"], wp.position)
        end
        saveWaypointData(savedWaypoints)
    end
})
SaveSection:AddButton({
    Title = "Load Gold 1",
    Callback = function()
        clearWaypoints()
        if savedWaypoints["gold 1"] then
            for _, pos in ipairs(savedWaypoints["gold 1"]) do
                addWaypoint(pos)
            end
        end
    end
})
SaveSection:AddButton({
    Title = "Save as Gold 2",
    Callback = function()
        savedWaypoints["gold 2"] = {}
        for _, wp in ipairs(waypoints) do
            table.insert(savedWaypoints["gold 2"], wp.position)
        end
        saveWaypointData(savedWaypoints)
    end
})
SaveSection:AddButton({
    Title = "Load Gold 2",
    Callback = function()
        clearWaypoints()
        if savedWaypoints["gold 2"] then
            for _, pos in ipairs(savedWaypoints["gold 2"]) do
                addWaypoint(pos)
            end
        end
    end
})

-- Секция Copy/Paste (исправленный, без Set ошибки)
local CopySection = WaypointsTab:AddSection("Copy/Paste (JSON)")
local textBoxValue = ""  -- Храним значение вручную
local textBox = CopySection:AddInput("WaypointText", {
    Title = "Waypoint JSON",
    Default = "",
    TextDisappear = false,  -- Постоянный ввод
    PlaceholderText = "Paste JSON here...",
    Callback = function(value)
        textBoxValue = value  -- Сохраняем для кнопки Load
    end
})
CopySection:AddButton({
    Title = "Copy to Clipboard",
    Callback = function()
        local data = {}
        for _, wp in ipairs(waypoints) do
            table.insert(data, vectorToTable(wp.position))
        end
        local jsonSuccess, json = pcall(HttpService.JSONEncode, HttpService, data)
        if jsonSuccess then
            textBoxValue = json  -- Обновляем переменную (не трогаем textbox напрямую)
            if setclipboard then
                setclipboard(json)
                print("JSON copied to clipboard: " .. json)  -- Для отладки, если clipboard не работает
            else
                print("Clipboard not supported. JSON: " .. json .. " (copy from console)")
            end
        end
    end
})
CopySection:AddButton({
    Title = "Load from Textbox",
    Callback = function()
        local input = textBoxValue
        if input ~= "" then
            local jsonSuccess, data = pcall(HttpService.JSONDecode, HttpService, input)
            if jsonSuccess and type(data) == "table" then
                clearWaypoints()
                local loadedCount = 0
                for _, posTable in ipairs(data) do
                    local pos = tableToVector(posTable)
                    if pos then
                        addWaypoint(pos)
                        loadedCount = loadedCount + 1
                    end
                end
                print("Loaded " .. loadedCount .. " waypoints from JSON.")
            else
                warn("Invalid JSON format.")
            end
        else
            warn("Textbox is empty.")
        end
    end
})

-- Misc Tab
local MiscTab = Tabs.Misc

-- Секция ESP (максимально улучшенная)
local ESPSection = MiscTab:AddSection("ESP")
ESPSection:AddToggle("ESPToggle", {
    Title = "Enable ESP",
    Default = false,
    Callback = function(value)
        espEnabled = value
        updateESP()
    end
})
ESPSection:AddSlider("ESPRangeSlider", {
    Title = "ESP Range",
    Default = 1000,
    Min = 100,
    Max = 5000,
    Callback = function(value)
        espRange = value
        updateESP()
    end
})
ESPSection:AddToggle("ShowNamesToggle", {
    Title = "Show Names",
    Default = true,
    Callback = function(value)
        showNames = value
        updateESP()
    end
})
ESPSection:AddToggle("ShowBoxesToggle", {
    Title = "Show Boxes",
    Default = true,
    Callback = function(value)
        showBoxes = value
        updateESP()
    end
})
ESPSection:AddToggle("ShowHealthToggle", {
    Title = "Show Health",
    Default = true,
    Callback = function(value)
        showHealth = value
        updateESP()
    end
})
ESPSection:AddToggle("ShowDistanceToggle", {
    Title = "Show Distance",
    Default = true,
    Callback = function(value)
        showDistance = value
        updateESP()
    end
})
ESPSection:AddSlider("BoxThicknessSlider", {
    Title = "Box Thickness",
    Default = 2,
    Min = 1,
    Max = 10,
    Callback = function(value)
        boxThickness = value
        updateESP()
    end
})

-- Инициализация SaveManager и InterfaceManager
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("HerkleHub")
SaveManager:SetFolder("HerkleHub/BoogaBoogaReborn")

InterfaceManager:BuildInterfaceSection(MiscTab)
SaveManager:BuildConfigSection(MiscTab)

print("Herkle Hub loaded successfully!")
