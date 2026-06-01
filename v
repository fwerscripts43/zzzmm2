local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Remove existing GUI if present
for _, gui in pairs(Players.LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
    if gui.Name == "MM2_Helper_GUI" then
        gui:Destroy()
    end
end

-- ============================
-- THEME CONFIG
-- ============================
local THEME = {
    bg         = Color3.fromRGB(10, 10, 15),
    surface    = Color3.fromRGB(18, 18, 26),
    surfaceAlt = Color3.fromRGB(24, 24, 36),
    text       = Color3.fromRGB(220, 220, 240),
    textDim    = Color3.fromRGB(120, 120, 150),
    accent     = Color3.fromRGB(255, 60, 100),
    murder     = Color3.fromRGB(220, 30, 60),
    sheriff    = Color3.fromRGB(30, 120, 255),
    noclip     = Color3.fromRGB(0, 200, 180),
    success    = Color3.fromRGB(40, 200, 80),
}

-- ============================
-- RGB RAINBOW HELPER
-- ============================
local function getRainbowColor(t)
    -- Returns a Color3 cycling through hue over time
    return Color3.fromHSV((t % 5) / 5, 1, 1)
end

-- ============================
-- CREATE GUI
-- ============================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2_Helper_GUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Outer RGB border frame (slightly larger, sits behind mainFrame)
local rgbBorder = Instance.new("Frame")
rgbBorder.Size = UDim2.new(0, 316, 0, 494)
rgbBorder.Position = UDim2.new(0.5, -158, 0.2, -8)
rgbBorder.BackgroundColor3 = Color3.fromRGB(255, 0, 128)
rgbBorder.BorderSizePixel = 0
rgbBorder.Active = true
rgbBorder.Draggable = true
rgbBorder.ZIndex = 1
rgbBorder.Parent = screenGui

local rgbBorderCorner = Instance.new("UICorner")
rgbBorderCorner.CornerRadius = UDim.new(0, 13)
rgbBorderCorner.Parent = rgbBorder

-- Inner gradient overlay (top-to-bottom dark fade for the border glow effect)
local rgbGrad = Instance.new("UIGradient")
rgbGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 128, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255)),
})
rgbGrad.Rotation = 45
rgbGrad.Parent = rgbBorder

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 308, 0, 486)
mainFrame.Position = UDim2.new(0, 4, 0, 4)
mainFrame.BackgroundColor3 = THEME.bg
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 2
mainFrame.Parent = rgbBorder

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Inner subtle border
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(40, 40, 60)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- ============================
-- HEADER BAR
-- ============================
local headerBar = Instance.new("Frame")
headerBar.Size = UDim2.new(1, 0, 0, 48)
headerBar.BackgroundColor3 = THEME.surface
headerBar.BorderSizePixel = 0
headerBar.ZIndex = 3
headerBar.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = headerBar

-- Bottom fill to square off the bottom edge of header
local headerFill = Instance.new("Frame")
headerFill.Size = UDim2.new(1, 0, 0, 10)
headerFill.Position = UDim2.new(0, 0, 1, -10)
headerFill.BackgroundColor3 = THEME.surface
headerFill.BorderSizePixel = 0
headerFill.ZIndex = 3
headerFill.Parent = headerBar

-- Accent dot left
local accentDot = Instance.new("Frame")
accentDot.Size = UDim2.new(0, 6, 0, 6)
accentDot.Position = UDim2.new(0, 16, 0.5, -3)
accentDot.BackgroundColor3 = THEME.accent
accentDot.BorderSizePixel = 0
accentDot.ZIndex = 4
accentDot.Parent = headerBar
Instance.new("UICorner").Parent = accentDot

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 30, 0, 0)
title.BackgroundTransparency = 1
title.Text = "mm2 i made with chatpgt lol"
title.TextColor3 = THEME.text
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 4
title.Parent = headerBar

-- Version badge
local versionBadge = Instance.new("TextLabel")
versionBadge.Size = UDim2.new(0, 40, 0, 18)
versionBadge.Position = UDim2.new(1, -50, 0.5, -9)
versionBadge.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
versionBadge.Text = "v2.3"
versionBadge.TextColor3 = THEME.textDim
versionBadge.TextScaled = true
versionBadge.Font = Enum.Font.GothamBold
versionBadge.ZIndex = 4
versionBadge.Parent = headerBar
local vBadgeCorner = Instance.new("UICorner")
vBadgeCorner.CornerRadius = UDim.new(0, 5)
vBadgeCorner.Parent = versionBadge

-- Thin separator under header
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, -24, 0, 1)
separator.Position = UDim2.new(0, 12, 0, 48)
separator.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
separator.BorderSizePixel = 0
separator.ZIndex = 3
separator.Parent = mainFrame

-- ============================
-- BUTTON FACTORY
-- ============================
local function makeButton(text, yPos, bgColor, iconChar)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -24, 0, 44)
    container.Position = UDim2.new(0, 12, 0, yPos)
    container.BackgroundColor3 = THEME.surfaceAlt
    container.BorderSizePixel = 0
    container.ZIndex = 3
    container.Parent = mainFrame

    local contCorner = Instance.new("UICorner")
    contCorner.CornerRadius = UDim.new(0, 8)
    contCorner.Parent = container

    local contStroke = Instance.new("UIStroke")
    contStroke.Color = bgColor
    contStroke.Thickness = 1.5
    contStroke.Transparency = 0.5
    contStroke.Parent = container

    -- Left color bar
    local colorBar = Instance.new("Frame")
    colorBar.Size = UDim2.new(0, 3, 0.7, 0)
    colorBar.Position = UDim2.new(0, 8, 0.15, 0)
    colorBar.BackgroundColor3 = bgColor
    colorBar.BorderSizePixel = 0
    colorBar.ZIndex = 4
    colorBar.Parent = container
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Parent = colorBar

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = (iconChar and (iconChar .. "  ") or "") .. text
    btn.TextColor3 = THEME.text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 4
    btn.Parent = container

    -- Padding via TextLabel trick
    btn.TextXAlignment = Enum.TextXAlignment.Left
    -- We'll set padding via position
    local textPad = Instance.new("UIPadding")
    textPad.PaddingLeft = UDim.new(0, 20)
    textPad.Parent = btn

    -- Hover / press feedback
    btn.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(30, 30, 46)}):Play()
        TweenService:Create(contStroke, TweenInfo.new(0.12), {Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.12), {BackgroundColor3 = THEME.surfaceAlt}):Play()
        TweenService:Create(contStroke, TweenInfo.new(0.12), {Transparency = 0.5}):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.06), {BackgroundColor3 = bgColor}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.12), {BackgroundColor3 = THEME.surfaceAlt}):Play()
    end)

    return btn, container, contStroke
end

-- ============================
-- BUTTONS
-- ============================
local toggleAimBtn, aimContainer, aimStroke = makeButton("ENABLE AUTO AIM", 60, THEME.accent, "◎")
local findMurderBtn, murderContainer, murderStroke = makeButton("FIND MURDERER", 114, THEME.murder, "🔪")
local findSheriffBtn, sheriffContainer, sheriffStroke = makeButton("FIND SHERIFF", 168, THEME.sheriff, "🔫")
local viewBothBtn, viewBothContainer, viewBothStroke = makeButton("VIEW BOTH", 222, Color3.fromRGB(180, 80, 255), "👁")
local findAllBtn, findAllContainer, findAllStroke   = makeButton("FIND ALL", 276, Color3.fromRGB(255, 160, 0), "⬡")
local noclipJumpBtn, noclipContainer, noclipStroke  = makeButton("NOCLIP / INF JUMP", 330, THEME.noclip, "⚡")

-- ============================
-- RESULT LABEL
-- ============================
local resultContainer = Instance.new("Frame")
resultContainer.Size = UDim2.new(1, -24, 0, 68)
resultContainer.Position = UDim2.new(0, 12, 0, 384)
resultContainer.BackgroundColor3 = THEME.surface
resultContainer.BorderSizePixel = 0
resultContainer.ZIndex = 3
resultContainer.Parent = mainFrame

local resultContCorner = Instance.new("UICorner")
resultContCorner.CornerRadius = UDim.new(0, 8)
resultContCorner.Parent = resultContainer

local resultStroke = Instance.new("UIStroke")
resultStroke.Color = Color3.fromRGB(40, 40, 65)
resultStroke.Thickness = 1
resultStroke.Parent = resultContainer

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, -16, 1, 0)
resultLabel.Position = UDim2.new(0, 8, 0, 0)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = "Results will appear here..."
resultLabel.TextColor3 = THEME.textDim
resultLabel.TextScaled = true
resultLabel.TextWrapped = true
resultLabel.Font = Enum.Font.Gotham
resultLabel.ZIndex = 4
resultLabel.Parent = resultContainer

-- ============================
-- PLAYER LIST (AUTO AIM)
-- ============================
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -24, 0, 0)
scrollingFrame.Position = UDim2.new(0, 12, 0, 462)
scrollingFrame.BackgroundColor3 = THEME.surface
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = THEME.accent
scrollingFrame.Visible = false
scrollingFrame.ZIndex = 3
scrollingFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollingFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollingFrame

local listPad = Instance.new("UIPadding")
listPad.PaddingLeft = UDim.new(0, 6)
listPad.PaddingRight = UDim.new(0, 6)
listPad.PaddingTop = UDim.new(0, 6)
listPad.Parent = scrollingFrame

local function slideScrollingFrame(show)
    scrollingFrame.Visible = true
    local targetH = show and 170 or 0
    local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(scrollingFrame, tweenInfo, {
        Size = UDim2.new(1, -24, 0, targetH)
    }):Play()
    -- Also expand main frame height
    TweenService:Create(mainFrame, tweenInfo, {
        Size = UDim2.new(0, 308, 0, show and 642 or 486)
    }):Play()
    TweenService:Create(rgbBorder, tweenInfo, {
        Size = UDim2.new(0, 316, 0, show and 650 or 494)
    }):Play()
    if not show then
        task.delay(0.36, function() scrollingFrame.Visible = false end)
    end
end

-- ============================
-- AIM LOGIC
-- ============================
local aimEnabled = false
local target = nil

local function toggleAim()
    aimEnabled = not aimEnabled
    if aimEnabled then
        toggleAimBtn.Text = "◎  DISABLE AUTO AIM"
        TweenService:Create(aimContainer:FindFirstChildOfClass("UIStroke") or aimStroke, TweenInfo.new(0.2), {
            Color = THEME.success, Transparency = 0
        }):Play()
        slideScrollingFrame(true)
    else
        toggleAimBtn.Text = "◎  ENABLE AUTO AIM"
        TweenService:Create(aimStroke, TweenInfo.new(0.2), {
            Color = THEME.accent, Transparency = 0.5
        }):Play()
        slideScrollingFrame(false)
        target = nil
    end
end

toggleAimBtn.MouseButton1Click:Connect(toggleAim)

local function createPlayerButton(plr)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Font = Enum.Font.Gotham
    btn.ZIndex = 4
    btn.Parent = scrollingFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(40, 40, 60)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    -- Avatar thumbnail
    local thumb = Instance.new("ImageLabel")
    thumb.Size = UDim2.new(0, 28, 0, 28)
    thumb.Position = UDim2.new(0, 6, 0.5, -14)
    thumb.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    thumb.BorderSizePixel = 0
    thumb.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=100&h=100"
    thumb.ZIndex = 5
    thumb.Parent = btn

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 4)
    thumbCorner.Parent = thumb

    -- Name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -50, 1, 0)
    nameLabel.Position = UDim2.new(0, 42, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.DisplayName
    nameLabel.TextColor3 = THEME.text
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 5
    nameLabel.Parent = btn

    btn.MouseButton1Click:Connect(function()
        target = plr
        for _, v in pairs(scrollingFrame:GetChildren()) do
            if v:IsA("TextButton") then
                local s = v:FindFirstChildOfClass("UIStroke")
                if s then
                    s.Color = (v == btn) and THEME.accent or Color3.fromRGB(40, 40, 60)
                    s.Thickness = (v == btn) and 1.5 or 1
                end
                TweenService:Create(v, TweenInfo.new(0.1), {
                    BackgroundColor3 = (v == btn) and Color3.fromRGB(35, 20, 40) or Color3.fromRGB(22, 22, 34)
                }):Play()
            end
        end
        resultLabel.Text = "◎ Targeting: " .. plr.DisplayName
        resultLabel.TextColor3 = THEME.accent
    end)

    btn.MouseEnter:Connect(function()
        if target ~= plr then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28, 28, 42)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if target ~= plr then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(22, 22, 34)}):Play()
        end
    end)
end

local function updatePlayerList()
    for _, v in pairs(scrollingFrame:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then createPlayerButton(plr) end
    end
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 14)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- ============================
-- HIGHLIGHT LOGIC
-- ============================
local function outlinePlayer(plr, outline, color)
    if not plr.Character then return end
    if outline then
        if not plr.Character:FindFirstChild("OutlineHighlight") then
            local hl = Instance.new("Highlight")
            hl.Name = "OutlineHighlight"
            hl.Adornee = plr.Character
            hl.FillColor = color or Color3.new(1, 0, 0)
            hl.FillTransparency = 0.7
            hl.OutlineColor = color or Color3.new(1, 1, 1)
            hl.OutlineTransparency = 0
            hl.Parent = plr.Character
        end
    else
        local hl = plr.Character:FindFirstChild("OutlineHighlight")
        if hl then hl:Destroy() end
    end
end

local function findPlayerWithItem(itemType)
    local foundPlayer = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then outlinePlayer(p, false) end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hasItem = false
            for _, item in pairs(plr.Backpack:GetChildren()) do
                if item.Name:lower():find(itemType:lower()) then hasItem = true break end
            end
            if not hasItem then
                for _, item in pairs(plr.Character:GetChildren()) do
                    if item:IsA("Tool") and item.Name:lower():find(itemType:lower()) then hasItem = true break end
                end
            end
            if hasItem then
                foundPlayer = plr
                break
            end
        end
    end
    if foundPlayer then
        if itemType == "Knife" then
            resultLabel.TextColor3 = THEME.murder
            resultLabel.Text = "🔪 " .. foundPlayer.DisplayName .. " is the MURDERER"
            outlinePlayer(foundPlayer, true, THEME.murder)
        else
            resultLabel.TextColor3 = THEME.sheriff
            resultLabel.Text = "🔫 " .. foundPlayer.DisplayName .. " is the SHERIFF"
            outlinePlayer(foundPlayer, true, THEME.sheriff)
        end
    else
        resultLabel.TextColor3 = THEME.textDim
        resultLabel.Text = itemType == "Knife" and "No murderer found." or "No sheriff found."
    end
end

findMurderBtn.MouseButton1Click:Connect(function()
    resultLabel.TextColor3 = THEME.murder
    resultLabel.Text = "Scanning for Murderer..."
    findPlayerWithItem("Knife")
end)

findSheriffBtn.MouseButton1Click:Connect(function()
    resultLabel.TextColor3 = THEME.sheriff
    resultLabel.Text = "Scanning for Sheriff..."
    findPlayerWithItem("Gun")
end)

-- ============================
-- BILLBOARD LABEL HELPER
-- ============================
local function clearBillboards()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            local bb = plr.Character:FindFirstChild("MM2_RoleLabel")
            if bb then bb:Destroy() end
        end
    end
end

local function addBillboard(plr, labelText, labelColor)
    if not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "MM2_RoleLabel"
    bb.Size = UDim2.new(0, 120, 0, 34)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = hrp
    bb.Parent = plr.Character

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    bg.BackgroundTransparency = 0.25
    bg.BorderSizePixel = 0
    bg.Parent = bb

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 6)
    bgCorner.Parent = bg

    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = labelColor
    bgStroke.Thickness = 1.5
    bgStroke.Parent = bg

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = labelColor
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = bg
end

-- ============================
-- VIEW BOTH LOGIC
-- ============================
local viewBothActive = false

viewBothBtn.MouseButton1Click:Connect(function()
    viewBothActive = not viewBothActive

    -- Always clear previous highlights and labels first
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then outlinePlayer(p, false) end
    end
    clearBillboards()

    if not viewBothActive then
        viewBothBtn.Text = "👁  VIEW BOTH"
        TweenService:Create(viewBothStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(180, 80, 255), Transparency = 0.5
        }):Play()
        resultLabel.TextColor3 = THEME.textDim
        resultLabel.Text = "View Both  OFF"
        return
    end

    viewBothBtn.Text = "👁  HIDE BOTH"
    TweenService:Create(viewBothStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(220, 140, 255), Transparency = 0
    }):Play()

    local foundMurderer = nil
    local foundSheriff  = nil

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hasKnife = false
            local hasGun   = false

            for _, item in pairs(plr.Backpack:GetChildren()) do
                if item.Name:lower():find("knife") then hasKnife = true end
                if item.Name:lower():find("gun")   then hasGun   = true end
            end
            for _, item in pairs(plr.Character:GetChildren()) do
                if item:IsA("Tool") then
                    if item.Name:lower():find("knife") then hasKnife = true end
                    if item.Name:lower():find("gun")   then hasGun   = true end
                end
            end

            if hasKnife and not foundMurderer then
                foundMurderer = plr
            end
            if hasGun and not foundSheriff then
                foundSheriff = plr
            end
        end
    end

    local lines = {}

    if foundMurderer then
        outlinePlayer(foundMurderer, true, THEME.murder)
        addBillboard(foundMurderer, "⚔ MURDERER", THEME.murder)
        table.insert(lines, "🔪 " .. foundMurderer.DisplayName .. " = MURDERER")
    else
        table.insert(lines, "🔪 No murderer found")
    end

    if foundSheriff then
        outlinePlayer(foundSheriff, true, THEME.sheriff)
        addBillboard(foundSheriff, "🛡 SHERIFF", THEME.sheriff)
        table.insert(lines, "🔫 " .. foundSheriff.DisplayName .. " = SHERIFF")
    else
        table.insert(lines, "🔫 No sheriff found")
    end

    resultLabel.TextColor3 = THEME.text
    resultLabel.Text = table.concat(lines, "\n")
end)

-- ============================
-- FIND ALL — SIDE PANEL
-- ============================
local PANEL_W = 220
local PANEL_H = 260
local findAllPanelOpen = false

-- Side panel outer RGB border
local sidePanelBorder = Instance.new("Frame")
sidePanelBorder.Size = UDim2.new(0, PANEL_W + 8, 0, PANEL_H + 8)
sidePanelBorder.BackgroundColor3 = Color3.fromRGB(255, 160, 0)
sidePanelBorder.BorderSizePixel = 0
sidePanelBorder.ZIndex = 1
sidePanelBorder.Visible = false
sidePanelBorder.Parent = screenGui

local sidePanelBorderCorner = Instance.new("UICorner")
sidePanelBorderCorner.CornerRadius = UDim.new(0, 13)
sidePanelBorderCorner.Parent = sidePanelBorder

local sidePanelRgbGrad = Instance.new("UIGradient")
sidePanelRgbGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 160, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 80, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 80)),
})
sidePanelRgbGrad.Rotation = 45
sidePanelRgbGrad.Parent = sidePanelBorder

-- Side panel inner frame
local sidePanel = Instance.new("Frame")
sidePanel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
sidePanel.Position = UDim2.new(0, 4, 0, 4)
sidePanel.BackgroundColor3 = THEME.bg
sidePanel.BorderSizePixel = 0
sidePanel.ZIndex = 2
sidePanel.Parent = sidePanelBorder

local sidePanelCorner = Instance.new("UICorner")
sidePanelCorner.CornerRadius = UDim.new(0, 10)
sidePanelCorner.Parent = sidePanel

local sidePanelStroke = Instance.new("UIStroke")
sidePanelStroke.Color = Color3.fromRGB(40, 40, 60)
sidePanelStroke.Thickness = 1
sidePanelStroke.Parent = sidePanel

-- Side panel header bar
local spHeader = Instance.new("Frame")
spHeader.Size = UDim2.new(1, 0, 0, 44)
spHeader.BackgroundColor3 = THEME.surface
spHeader.BorderSizePixel = 0
spHeader.ZIndex = 3
spHeader.Parent = sidePanel

local spHeaderCorner = Instance.new("UICorner")
spHeaderCorner.CornerRadius = UDim.new(0, 10)
spHeaderCorner.Parent = spHeader

local spHeaderFill = Instance.new("Frame")
spHeaderFill.Size = UDim2.new(1, 0, 0, 10)
spHeaderFill.Position = UDim2.new(0, 0, 1, -10)
spHeaderFill.BackgroundColor3 = THEME.surface
spHeaderFill.BorderSizePixel = 0
spHeaderFill.ZIndex = 3
spHeaderFill.Parent = spHeader

-- Orange accent dot
local spDot = Instance.new("Frame")
spDot.Size = UDim2.new(0, 6, 0, 6)
spDot.Position = UDim2.new(0, 12, 0.5, -3)
spDot.BackgroundColor3 = Color3.fromRGB(255, 160, 0)
spDot.BorderSizePixel = 0
spDot.ZIndex = 4
spDot.Parent = spHeader
Instance.new("UICorner").Parent = spDot

-- "MURDERER MODE" title
local spTitle = Instance.new("TextLabel")
spTitle.Size = UDim2.new(1, -26, 1, 0)
spTitle.Position = UDim2.new(0, 26, 0, 0)
spTitle.BackgroundTransparency = 1
spTitle.Text = "MURDERER MODE"
spTitle.TextColor3 = Color3.fromRGB(255, 160, 0)
spTitle.TextScaled = true
spTitle.Font = Enum.Font.GothamBold
spTitle.TextXAlignment = Enum.TextXAlignment.Left
spTitle.ZIndex = 4
spTitle.Parent = spHeader

-- Separator
local spSep = Instance.new("Frame")
spSep.Size = UDim2.new(1, -20, 0, 1)
spSep.Position = UDim2.new(0, 10, 0, 44)
spSep.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
spSep.BorderSizePixel = 0
spSep.ZIndex = 3
spSep.Parent = sidePanel

-- Helper to make a side-panel button
local function makeSidePanelButton(labelText, yPos, color, icon)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, -20, 0, 40)
    cont.Position = UDim2.new(0, 10, 0, yPos)
    cont.BackgroundColor3 = THEME.surfaceAlt
    cont.BorderSizePixel = 0
    cont.ZIndex = 3
    cont.Parent = sidePanel

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = cont

    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = 1.5
    s.Transparency = 0.5
    s.Parent = cont

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 0.7, 0)
    bar.Position = UDim2.new(0, 7, 0.15, 0)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.ZIndex = 4
    bar.Parent = cont
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 2)
    bc.Parent = bar

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = (icon and (icon .. "  ") or "") .. labelText
    btn.TextColor3 = THEME.text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 4
    btn.Parent = cont

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 18)
    pad.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(cont, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(30,30,46)}):Play()
        TweenService:Create(s, TweenInfo.new(0.12), {Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(cont, TweenInfo.new(0.12), {BackgroundColor3 = THEME.surfaceAlt}):Play()
        TweenService:Create(s, TweenInfo.new(0.12), {Transparency = 0.5}):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(cont, TweenInfo.new(0.06), {BackgroundColor3 = color}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(cont, TweenInfo.new(0.12), {BackgroundColor3 = THEME.surfaceAlt}):Play()
    end)

    return btn, cont, s
end

local seeAllBtn,  seeAllCont,  seeAllStroke  = makeSidePanelButton("SEE ALL",  56,  Color3.fromRGB(255, 200, 50),  "◈")
local invisBtn,   invisCont,   invisStroke   = makeSidePanelButton("INVIS",    108, Color3.fromRGB(160, 80, 255),  "◌")

-- Status label inside side panel
local spStatus = Instance.new("TextLabel")
spStatus.Size = UDim2.new(1, -20, 0, 50)
spStatus.Position = UDim2.new(0, 10, 0, 160)
spStatus.BackgroundColor3 = THEME.surface
spStatus.BorderSizePixel = 0
spStatus.Text = "Press SEE ALL or INVIS"
spStatus.TextColor3 = THEME.textDim
spStatus.TextScaled = true
spStatus.TextWrapped = true
spStatus.Font = Enum.Font.Gotham
spStatus.ZIndex = 3
spStatus.Parent = sidePanel

local spStatusCorner = Instance.new("UICorner")
spStatusCorner.CornerRadius = UDim.new(0, 8)
spStatusCorner.Parent = spStatus

local spStatusStroke = Instance.new("UIStroke")
spStatusStroke.Color = Color3.fromRGB(40, 40, 65)
spStatusStroke.Thickness = 1
spStatusStroke.Parent = spStatus

-- Position side panel to the right of main GUI, start off-screen (shifted left behind main frame)
local function updateSidePanelAnchor()
    -- Align vertically with the top of rgbBorder; place just to its right
    local mainAbsPos = rgbBorder.AbsolutePosition
    local mainAbsSize = rgbBorder.AbsoluteSize
    sidePanelBorder.Position = UDim2.new(0, mainAbsPos.X + mainAbsSize.X + 10, 0, mainAbsPos.Y)
end

local function toggleFindAllPanel()
    findAllPanelOpen = not findAllPanelOpen
    local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    if findAllPanelOpen then
        updateSidePanelAnchor()
        sidePanelBorder.Visible = true
        -- Slide in from left (behind main panel) to correct position
        local mainAbsPos  = rgbBorder.AbsolutePosition
        local mainAbsSize = rgbBorder.AbsoluteSize
        local targetX = mainAbsPos.X + mainAbsSize.X + 10
        local targetY = mainAbsPos.Y
        sidePanelBorder.Position = UDim2.new(0, mainAbsPos.X + mainAbsSize.X - 20, 0, targetY)
        TweenService:Create(sidePanelBorder, tweenInfo, {
            Position = UDim2.new(0, targetX, 0, targetY)
        }):Play()
        findAllBtn.Text = "⬡  CLOSE PANEL"
        TweenService:Create(findAllStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
    else
        local mainAbsPos  = rgbBorder.AbsolutePosition
        local mainAbsSize = rgbBorder.AbsoluteSize
        TweenService:Create(sidePanelBorder, tweenInfo, {
            Position = UDim2.new(0, mainAbsPos.X + mainAbsSize.X - 20, 0, mainAbsPos.Y)
        }):Play()
        task.delay(0.36, function() sidePanelBorder.Visible = false end)
        findAllBtn.Text = "⬡  FIND ALL"
        TweenService:Create(findAllStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
    end
end

findAllBtn.MouseButton1Click:Connect(toggleFindAllPanel)

-- ============================
-- SEE ALL LOGIC
-- ============================
local seeAllActive = false

seeAllBtn.MouseButton1Click:Connect(function()
    seeAllActive = not seeAllActive

    -- Clear all existing highlights first
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then outlinePlayer(p, false) end
    end

    if not seeAllActive then
        seeAllBtn.Text = "◈  SEE ALL"
        TweenService:Create(seeAllStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
        spStatus.Text = "SEE ALL  OFF"
        spStatus.TextColor3 = THEME.textDim
        return
    end

    seeAllBtn.Text = "◈  HIDE ALL"
    TweenService:Create(seeAllStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()

    local innocentColor = Color3.fromRGB(80, 220, 120)
    local count = 0

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hasKnife = false
            for _, item in pairs(plr.Backpack:GetChildren()) do
                if item.Name:lower():find("knife") then hasKnife = true break end
            end
            if not hasKnife then
                for _, item in pairs(plr.Character:GetChildren()) do
                    if item:IsA("Tool") and item.Name:lower():find("knife") then hasKnife = true break end
                end
            end
            if not hasKnife then
                outlinePlayer(plr, true, innocentColor)
                count = count + 1
            end
        end
    end

    spStatus.TextColor3 = Color3.fromRGB(80, 220, 120)
    spStatus.Text = "Outlined " .. count .. " innocent player" .. (count == 1 and "" or "s")
end)

-- ============================
-- INVIS LOGIC
-- ============================
local invisActive   = false
local INVIS_DEPTH   = 500       -- studs below map surface
local LEVITATE_Y    = -498      -- levitate slightly above absolute bottom (feels like floating)
local invisSurface  = nil       -- stores the Y world position of the surface when activated
local invisCamCF    = nil       -- stores camera CFrame at activation moment
local invisSinking  = false     -- true while tween is in progress
local invisRising   = false

-- Forces all descendant BaseParts to CanCollide = false
local function forceNoclipChar(char)
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end

-- Restore CanCollide to default (only non-HRP parts)
local function restoreCollision(char)
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = p.Name ~= "HumanoidRootPart"
        end
    end
end

local function applyInvis(char)
    if not char then return end
    local hrp      = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    -- Freeze humanoid in place (no falling physics fighting the tween)
    humanoid.PlatformStand = true

    -- Snapshot the surface Y so we know where to return later
    invisSurface = hrp.Position.Y

    -- Snapshot the exact camera CFrame so we can lock it during the sink
    invisCamCF = camera.CFrame

    -- Zero out any leftover CameraOffset
    humanoid.CameraOffset = Vector3.new(0, 0, 0)

    -- Noclip every part so the character phases through the floor cleanly
    forceNoclipChar(char)

    -- Tween the HRP straight down
    invisSinking = true
    local targetCF = CFrame.new(
        hrp.Position.X,
        hrp.Position.Y - INVIS_DEPTH,
        hrp.Position.Z
    ) * (hrp.CFrame - hrp.CFrame.Position)  -- preserve rotation

    local sinkTween = TweenService:Create(hrp, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        CFrame = targetCF
    })
    sinkTween:Play()
    sinkTween.Completed:Connect(function()
        invisSinking = false
        -- Once underground, unfreeze so WASD movement works normally at the underground Y
        humanoid.PlatformStand = false
        -- Set WalkSpeed override target Y: levitate the HRP at a fixed underground Y
        -- (handled in Stepped below)
    end)
end

local function removeInvis(char)
    if not char then return end
    local hrp      = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    -- Freeze again for the rise
    humanoid.PlatformStand = true
    invisRising = true
    invisCamCF  = camera.CFrame  -- re-lock camera during rise too

    -- Tween back up to original surface Y
    local surfaceY = invisSurface or (hrp.Position.Y + INVIS_DEPTH)
    local targetCF = CFrame.new(
        hrp.Position.X,
        surfaceY,
        hrp.Position.Z
    ) * (hrp.CFrame - hrp.CFrame.Position)

    local riseTween = TweenService:Create(hrp, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        CFrame = targetCF
    })
    riseTween:Play()
    riseTween.Completed:Connect(function()
        invisRising  = false
        invisCamCF   = nil
        invisSurface = nil
        humanoid.PlatformStand = false
        restoreCollision(char)
        -- Restore camera to normal script control
        camera.CameraType = Enum.CameraType.Custom
    end)
end

invisBtn.MouseButton1Click:Connect(function()
    invisActive = not invisActive
    local char = player.Character

    if invisActive then
        invisBtn.Text = "◌  SHOW SELF"
        TweenService:Create(invisStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
        spStatus.Text = "Under map\nWalk normally"
        spStatus.TextColor3 = Color3.fromRGB(160, 80, 255)
        applyInvis(char)
    else
        invisBtn.Text = "◌  INVIS"
        TweenService:Create(invisStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
        spStatus.Text = "Surfacing..."
        spStatus.TextColor3 = THEME.textDim
        removeInvis(char)
    end
end)

-- Re-apply on respawn
player.CharacterAdded:Connect(function(char)
    if invisActive then
        task.wait(1)
        applyInvis(char)
    end
end)

-- ============================
-- INVIS: per-frame systems
-- ============================
-- RenderStepped: lock camera to the snapped world CFrame during sink/rise,
-- then once underground switch to an offset that follows the HRP's XZ but
-- stays at the original surface Y so the view never changes.
RunService.RenderStepped:Connect(function()
    if not invisActive and not invisSinking and not invisRising then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if invisSinking or invisRising then
        -- Hard-lock camera to the snapshot — nothing moves on screen
        if invisCamCF then
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = invisCamCF
        end
    elseif invisActive then
        -- Underground & stable: keep camera at surface-level XZ above HRP
        -- so the player's view tracks their WASD movement normally
        local hrpPos    = hrp.Position
        local surfaceY  = invisSurface or (hrpPos.Y + INVIS_DEPTH)
        local camOffset = Vector3.new(hrpPos.X, surfaceY + 1.5, hrpPos.Z)

        -- Preserve the look direction from before (only shift position, not angle)
        local prevCam   = camera.CFrame
        local lookDir   = prevCam.LookVector

        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(camOffset, camOffset + lookDir)
    end
end)

-- Keep side panel anchored when main panel is dragged
rgbBorder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    if findAllPanelOpen then
        updateSidePanelAnchor()
        local mainAbsPos  = rgbBorder.AbsolutePosition
        local mainAbsSize = rgbBorder.AbsoluteSize
        sidePanelBorder.Position = UDim2.new(0, mainAbsPos.X + mainAbsSize.X + 10, 0, mainAbsPos.Y)
    end
end)

-- Animate side panel RGB gradient in Heartbeat (same loop as main border)
-- (handled inside the existing Heartbeat below)

-- ============================
-- AUTO AIM
-- ============================
local function aimAtTarget()
    if not aimEnabled or not target or not target.Character then return end
    local head = target.Character:FindFirstChild("Head")
    if head then
        camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
    end
end
RunService.RenderStepped:Connect(aimAtTarget)

-- ============================
-- NOCLIP / INF JUMP
-- ============================
local noclip = false
local infiniteJump = false

local function toggleNoclipAndJump()
    noclip = not noclip
    infiniteJump = not infiniteJump
    if noclip then
        resultLabel.TextColor3 = THEME.noclip
        resultLabel.Text = "⚡ Noclip & Inf Jump  ON"
        TweenService:Create(noclipStroke, TweenInfo.new(0.2), {
            Color = THEME.noclip, Transparency = 0
        }):Play()
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    else
        resultLabel.TextColor3 = THEME.textDim
        resultLabel.Text = "⚡ Noclip & Inf Jump  OFF"
        TweenService:Create(noclipStroke, TweenInfo.new(0.2), {
            Color = THEME.noclip, Transparency = 0.5
        }):Play()
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end

noclipJumpBtn.MouseButton1Click:Connect(toggleNoclipAndJump)

RunService.Stepped:Connect(function(_, dt)
    local char = player.Character

    -- Regular noclip button
    if noclip and char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- Invis: keep all parts noclipping AND levitate the HRP at a steady underground Y
    if invisActive and not invisSinking and not invisRising and char then
        -- Force noclip every frame so Roblox can't re-enable it
        forceNoclipChar(char)

        local hrp      = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if hrp and humanoid then
            -- Levitate: pin the Y position to exactly (surface - INVIS_DEPTH + 3)
            -- so the avatar floats just above the "floor" of the underground void.
            -- X and Z are left alone so WASD movement works freely.
            local targetY = (invisSurface or hrp.Position.Y) - INVIS_DEPTH + 3
            local pos     = hrp.Position
            local diff    = targetY - pos.Y

            -- Smooth spring: nudge toward target Y without snapping
            if math.abs(diff) > 0.05 then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, diff * math.min(dt * 20, 1), 0)
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJump then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ============================
-- RGB BORDER ANIMATION
-- ============================
local gradAngle = 0

RunService.Heartbeat:Connect(function(dt)
    gradAngle = (gradAngle + dt * 60) % 360
    local t = tick()

    -- Animate the RGB gradient rotation
    rgbGrad.Rotation = gradAngle

    -- Shift the gradient colors over time for full rainbow cycle
    local c1 = Color3.fromHSV((t * 0.15) % 1, 1, 1)
    local c2 = Color3.fromHSV((t * 0.15 + 0.33) % 1, 1, 1)
    local c3 = Color3.fromHSV((t * 0.15 + 0.66) % 1, 1, 1)

    rgbGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(0.5, c2),
        ColorSequenceKeypoint.new(1, c3),
    })

    -- Animate side panel RGB border gradient too
    sidePanelRgbGrad.Rotation = (gradAngle + 90) % 360
    sidePanelRgbGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c2),
        ColorSequenceKeypoint.new(0.5, c3),
        ColorSequenceKeypoint.new(1, c1),
    })

    -- Pulse side panel dot
    spDot.BackgroundColor3 = Color3.fromHSV((t * 0.2 + 0.08) % 1, 1, 0.9)
    spDot.Size = UDim2.new(0, 5 + pulse * 2, 0, 5 + pulse * 2)
    spDot.Position = UDim2.new(0, 12 - pulse, 0.5, -3 - pulse)
    local pulse = math.sin(t * 4) * 0.5 + 0.5
    accentDot.BackgroundColor3 = Color3.fromHSV((t * 0.2) % 1, 1, 0.8 + pulse * 0.2)
    accentDot.Size = UDim2.new(0, 5 + pulse * 2, 0, 5 + pulse * 2)
    accentDot.Position = UDim2.new(0, 16 - pulse, 0.5, -3 - pulse)
end)

print("MM2 Helper v2.3 Loaded — RGB Edition")
