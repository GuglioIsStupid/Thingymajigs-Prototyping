
require("Engine")
require("Microgames")

local state = ""

STATES = {
    intro = require("States.Intro"),
    menu = require("States.Menu"),
}

function SwitchState(newState)
    assert(STATES[newState], "State " .. newState .. " does not exist")
    if STATES[state] and STATES[state].exit then STATES[state]:exit() end
    state = newState
    if STATES[state].enter then STATES[state]:enter() end
end

function StateCallback(state, callback, ...)
    if STATES[state][callback] then
        STATES[state][callback](STATES[state], ...)
    end
end

function love.load()
    microgameHandler = MicrogameHandler:new()
   -- microgameHandler:addMicrogame(testMicrogame)
    microgameHandler:addMicrogame(blendingIn)
    microgameHandler:addMicrogame(findHim)

    --[[ Timer.after(1, function ()
        print("1 second has passed")
    end, -1)

    local function doTweenShit()
        TweenManager:tween(obj, {y = 400}, 1 / microgameHandler.currentSpeed, {type = TweenType.PINGPONG, ease = "bounceOut"})
    end

    doTweenShit() ]]

    SwitchState("intro")
end

function love.update(dt)
    Timer.update(dt)
    TweenManager:update(dt)
    --[[ print(love.timer.getTime())
    Timer.update(dt)
    TweenManager:update(dt)
    microgameHandler:update(dt) ]]
    StateCallback(state, "update", dt)
end

function love.draw()
   --[[  microgameHandler:draw()

    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", obj.x, obj.y, 50, 50)
    love.graphics.setColor(1,1,1) ]]

    StateCallback(state, "draw")
end

function love.keypressed(key)
   --[[  microgameHandler:keypressed(key) ]]
end

function love.mousepressed(x,y,button)
   --[[  microgameHandler:mousepressed(x,y,button) ]]
end

function love.quit()
end