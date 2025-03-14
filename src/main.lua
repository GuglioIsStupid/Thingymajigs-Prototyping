
require("Engine")
require("Microgames")

local obj = {
    y = 200,
    x = 200
}

function love.load()
    microgameHandler = MicrogameHandler:new()
   -- microgameHandler:addMicrogame(testMicrogame)
    microgameHandler:addMicrogame(blendingIn)
    microgameHandler:addMicrogame(findHim)

    Timer.after(1, function ()
        print("1 second has passed")
    end, -1)

    --[[ TweenManager:tween(obj, {y = 400}, 1) ]]
    local function doTweenShit()
        TweenManager:tween(obj, {y = 400}, 1 / microgameHandler.currentSpeed, {type = TweenType.PINGPONG, ease = "bounceOut"})
    end

    doTweenShit()
end

function love.update(dt)
    print(love.timer.getTime())
    Timer.update(dt)
    TweenManager:update(dt)
    microgameHandler:update(dt)
end

function love.draw()
    microgameHandler:draw()

    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", obj.x, obj.y, 50, 50)
    love.graphics.setColor(1,1,1)
end

function love.keypressed(key)
    microgameHandler:keypressed(key)
end

function love.mousepressed(x,y,button)
    microgameHandler:mousepressed(x,y,button)
end