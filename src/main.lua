
require("Engine")
require("Microgames")

local state = ""
local discordIPC_OK
discordIPC_OK, discordIPC = pcall(require, "Lib.discordIPC")
if not discordIPC_OK then discordIPC = nil end
if type(discordIPC) ~= "table" then discordIPC = nil end

STATES = {
    intro = require("States.Intro"),
    menu = require("States.Menu"),
    game = require("States.Game"),
    debug = require("States.Debug.Debug"),
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

Resolution = {
    Width = 1280,
    Height = 720
}

local function PRINT_DEBUG()
    local str = "UPS: " .. love.timer.getFPS() .. " | DPS: " .. love.timer.getDrawFPS() .. "\n"
    local stats = love.graphics.getStats()
    str = str .. "Memory: " .. string.format("%.2f", collectgarbage("count")/1024) .. "MB\n"
    str = str .. "Graphics Memory: " .. string.format("%.2f", stats.texturememory / 1024 / 1024) .. "MB\n"
    str = str .. "Draw Calls: " .. stats.drawcalls .. " (" .. stats.drawcallsbatched .. " batched)\n"
    str = str .. "Canvas Switches: " .. stats.canvasswitches .. "\n"
    str = str .. "Shader Switches: " .. stats.shaderswitches .. "\n"
    str = str .. "Images: " .. stats.images .. "\n"
    str = str .. "Canvases: " .. stats.canvases .. "\n"
    str = str .. "Fonts: " .. stats.fonts .. "\n"

    love.graphics.setColor(0, 0, 0)
    for x = -1, 1, 2 do
        for y = -1, 1, 2 do
            love.graphics.print(str, 5 + x, 5 + y)
        end
    end

    love.graphics.setColor(1, 1, 1)

    love.graphics.print(str, 5, 5)
end

function IPCActivity(activity)
    if discordIPC then
        discordIPC.activity = activity

        discordIPC:sendActivity()
    end
end

function love.load()
    microgameHandler = MicrogameHandler:new()


    microgameHandler:addMicrogame(testMicrogame)
    microgameHandler:addMicrogame(blendingIn)
    microgameHandler:addMicrogame(findHim)
    microgameHandler:addMicrogame(catchMicrogame)
    microgameHandler:addMicrogame(harmoni)

    --[[ Timer.after(1, function ()
        print("1 second has passed")
    end, -1)

    local function doTweenShit()
        TweenManager:tween(obj, {y = 400}, 1 / microgameHandler.currentSpeed, {type = TweenType.PINGPONG, ease = "bounceOut"})
    end

    doTweenShit() ]]

    SwitchState("game")

    --if discordIPC then discordIPC:initID("<PUT_ID_HERE_WHEN_WE_HAVE_ONE>") end
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

function love.draw(dt)
   --[[  microgameHandler:draw()

    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", obj.x, obj.y, 50, 50)
    love.graphics.setColor(1,1,1) ]]

    StateCallback(state, "draw", dt)

    PRINT_DEBUG()
end

function love.keypressed(key)
   --[[  microgameHandler:keypressed(key) ]]

    StateCallback(state, "keypressed", key)

   if key == "8" then
    SwitchState("debug")
   end
end

function love.mousepressed(x,y,button)
   --[[  microgameHandler:mousepressed(x,y,button) ]]

    StateCallback(state, "mousepressed", x, y, button)
end

function love.mousereleased(x,y,button)
   --[[  microgameHandler:mousereleased(x,y,button) ]]

    StateCallback(state, "mousereleased", x, y, button)
end

function love.mousemoved(x,y)
   --[[  microgameHandler:mousemoved(x,y) ]]

    StateCallback(state, "mousemoved", x, y)
end

function love.quit()
    if discordIPC then discordIPC:close() end
end