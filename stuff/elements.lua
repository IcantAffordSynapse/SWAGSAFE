---
-- Elements Handler
---

local module = {}
local ts = game:GetService("TweenService")

function module:load(elements, king)
    local sects = {}

    local currentTab

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

    function sects:Section(title, ico)
        local newtab = elements.sectionbtn:Clone()
        newtab.header.Text = title
        newtab.ico.Image = ico
        newtab.Parent = king.tabs

        local newsect = elements.sectioncanvas:Clone()
        newsect.Parent = king.sections

        newtab.MouseEnter:Connect(function() tweenElement(newtab, true) end)
        newtab.MouseLeave:Connect(function() tweenElement(newtab, false) end)
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
                currentTab.Interactable = false
            end

            ts:Create(
                newsect,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    GroupTransparency = 0
                }
            ):Play()
            newsect.Interactable = true
            newsect:TweenPosition(UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15)
            currentTab = newsect
        end)

        local scrollingFrame = newsect.ScrollingFrame

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

        function instances:Warning(title)
            local newwarning = elements.WarningElement:Clone()
            newwarning.header.Text = "↑ ⚠ " .. title .. " ↑"
            newwarning.Parent = scrollingFrame
        end

        function instances:Executor(details, cb)
            local newexec = elements.ExecElement:Clone()
            local btn = newexec.btn

            btn.ico.Image = details.img
            btn.title.Text = details.title

            btn.isup.Text = details.working and "Working" or "Not working"
            btn.isup.TextColor3 = details.working and Color3.fromRGB(141, 255, 128) or Color3.fromRGB(255, 52, 52)

            btn.details.Text = btn.details.Text:format(
                details.price,
                details.device,
                details.sunc
            )

            btn.MouseEnter:Connect(function() tweenElement(btn, true) end)
            btn.MouseLeave:Connect(function() tweenElement(btn, false) end)

            btn.MouseButton1Click:Connect(cb)

            newexec.Parent = scrollingFrame
        end

        function instances:Credit(user, role)
            local newcred = elements.CreditElement:Clone()
            newcred.usr.Text = user
            newcred.role.Text = role

            newcred.Parent = scrollingFrame
        end

        return instances
    end

    function sects:AddLog(logname, color)
        local when = os.date("%H:%M:%S")
        local newlog = elements.consolelog:Clone()
        newlog.header.Text = string.format("[%s]: %s", when, logname)
        newlog.header.TextColor3 = color or Color3.fromRGB(255,255,255)

        table.insert(getgenv().savedLogs, {
            Time = when,
            Message = logname
        })

        newlog.Parent = king.logsframe.ScrollingFrame

        task.defer(function()
            local scrollingFrame = king.logsframe.ScrollingFrame
            scrollingFrame.CanvasPosition = Vector2.new(
                0,
                scrollingFrame.AbsoluteCanvasSize.Y
            )
        end)
    end

    return sects
end

return module
