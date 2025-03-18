
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
    Height = 720,
    _canvas = nil,
    _offset = {x = 0, y = 0},
    _scale = 1,
    convertMouse = function(x, y)
        return (x - Resolution._offset.x) / Resolution._scale, (y - Resolution._offset.y) / Resolution._scale
    end
}

Resolution._canvas = love.graphics.newCanvas(Resolution.Width, Resolution.Height)

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

    for i, microgame in ipairs(MICROGAMES) do
        microgameHandler:addMicrogame(microgame)
    end
    for i, microgame in ipairs(BOSSGAMES) do
        microgameHandler:addBossGame(microgame)
    end

    --[[ Timer.after(1, function ()
        print("1 second has passed")
    end, -1)

    local function doTweenShit()
        TweenManager:tween(obj, {y = 400}, 1 / microgameHandler.currentSpeed, {type = TweenType.PINGPONG, ease = "bounceOut"})
    end]]

    SwitchState("game")

    --if discordIPC then discordIPC:initID("<PUT_ID_HERE_WHEN_WE_HAVE_ONE>") end
end

function love.update(dt)
    Timer.update(dt)
    TweenManager:update(dt)

    StateCallback(state, "update", dt)
end

function love.resize(w, h)
    Resolution._scale = math.min(w / Resolution.Width, h / Resolution.Height)
    Resolution._offset.x = (w - Resolution.Width * Resolution._scale) / 2
    Resolution._offset.y = (h - Resolution.Height * Resolution._scale) / 2
end

function love.draw(dt)

    love.graphics.setCanvas(Resolution._canvas)
    love.graphics.clear()

    StateCallback(state, "draw", dt)

    love.graphics.setCanvas()

    love.graphics.draw(Resolution._canvas, Resolution._offset.x, Resolution._offset.y, 0, Resolution._scale, Resolution._scale)

    PRINT_DEBUG()
end

function love.keypressed(key)
    StateCallback(state, "keypressed", key)

    if key == "8" then
        SwitchState("debug")
    end
end

function love.mousepressed(x,y,button)
   local nx, ny = Resolution.convertMouse(x, y)

    StateCallback(state, "mousepressed", nx, ny, button)
end

function love.mousereleased(x,y,button)
    local nx, ny = Resolution.convertMouse(x, y)

    StateCallback(state, "mousereleased", nx, ny, button)
end

function love.mousemoved(x,y,dx,dy)
    local nx, ny = Resolution.convertMouse(x, y)

    StateCallback(state, "mousemoved", nx, ny, dx, dy)
end

function love.quit()
    if discordIPC then discordIPC:close() end
end