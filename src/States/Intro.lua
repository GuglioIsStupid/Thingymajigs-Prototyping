local Intro = {}

local fade = {f = 0}
local section = 1

local background

function Intro:enter()
    background = love.graphics.newImage("Assets/Menus/Splash/TEMP.png")
    TweenManager:tween(fade, {f = 1}, 1, {ease = "quadOut", onComplete = function()
        Timer.after(2, function()
            TweenManager:tween(fade, {f = 0}, 1, {ease = "quadOut", onComplete = function()
                SwitchState("menu")
            end})
        end)
    end})
end

function Intro:update(dt)
end

function Intro:draw()
    love.graphics.setColor(1, 1, 1, fade.f)
    love.graphics.draw(background)
    love.graphics.setColor(1, 1, 1)
end

function Intro:exit()
end

return Intro