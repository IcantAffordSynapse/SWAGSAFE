---
-- Elements Handler
---

local module = {}
local ts = game:GetService("TweenService")

function module:load(elements, king)
    local sects = {}

    local currentTab

    function sects:Section(title, ico)
        local newtab = elements.sectionbtn:Clone()
        newtab.header.Text = title
        newtab.ico.Image = ico
        newtab.Parent = king.tabs

        local newsect = elements.sectioncanvas:Clone()
        newsect.Parent = king.sections

        newtab.MouseButton1Click:Connect(function()
            if currentTab == newsect then return end

            if currentTab then
                ts:Create(
                    currentTab,
                    TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {
                        GroupTransparency = 1
                    }
                ):Play()
                currentTab:TweenPosition(UDim2.new(0.5,0,0.6,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15)
            end

            ts:Create(
                newsect,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    GroupTransparency = 0
                }
            ):Play()
            newsect:TweenPosition(UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15)
            currentTab = newsect
        end)

        local scrollingFrame = newsect.ScrollingFrame

        local function tweenElement(which, isIn)
            ts:Create(
                which,
                TweenInfo.new(
                    0.05
                ),
                {
                    BackgroundColor3 = isIn and Color3.fromRGB(39, 39, 39) or Color3.fromRGB(21, 21, 21)
                }
            ):Play()
        end

        local instances = {}

        function instances:Label(title)
            local newlabel = elements.LabelElement:Clone()
            newlabel.header.Text = title
            newlabel.Parent = scrollingFrame
        end

        function instances:Button(title, cb)
            local newbutton = elements.ButtonElement:Clone()
            local btn = newbutton.btn
            btn.header.Text = title

            btn.MouseEnter:Connect(function() tweenElement(btn, true) end)
            btn.MouseLeave:Connect(function() tweenElement(btn, false) end)
            btn.MouseButton1Click:Connect(cb)

            newbutton.Parent = scrollingFrame
        end

        function instances:Toggle(title, default, cb)
            local newtoggle = elements.ToggleElement:Clone()
            local btn = newtoggle.btn
            btn.header.Text = title

            local statusIndicator = btn.toggleStatus

            local isTog = default
            statusIndicator.BackgroundColor3 = isTog and Color3.fromRGB(141, 255, 128) or Color3.fromRGB(255, 92, 92)
            task.defer(cb, isTog)

            btn.MouseEnter:Connect(function() tweenElement(btn, true) end)
            btn.MouseLeave:Connect(function() tweenElement(btn, false) end)

            btn.MouseButton1Click:Connect(function()
                isTog = not isTog
                statusIndicator.BackgroundColor3 = isTog and Color3.fromRGB(141, 255, 128) or Color3.fromRGB(255, 92, 92)
                cb(isTog)
            end)

            newtoggle.Parent = scrollingFrame
        end

        return instances
    end

    function sects:AddLog(logname, color)
        local newlog = elements.consolelog:Clone()
        newlog.header.Text = logname
        newlog.header.TextColor3 = color or Color3.fromRGB(255,255,255)

        newlog.Parent = king.logsframe.ScrollingFrame
    end

    return sects
end

return module
