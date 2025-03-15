---@diagnostic disable: redundant-parameter
local utf8 = require("utf8")

local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

function love.errorhandler(msg)
    if discordIPC then
        discordIPC:close()
    end
    
	msg = tostring(msg)

	error_printer(msg, 2)

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end

	love.graphics.reset()
	local font = love.graphics.setNewFont(14)

	love.graphics.setColor(1, 1, 1)

	local trace = debug.traceback()

	love.graphics.origin()

	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
    ---@diagnostic disable-next-line: cast-local-type
	sanitizedmsg = table.concat(sanitizedmsg)

	local err = {}

	table.insert(err, "Error\n")
	table.insert(err, sanitizedmsg)

	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end

	table.insert(err, "\n")

	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end

	local p = table.concat(err, "\n")

	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")

	local function draw()
		if not love.graphics.isActive() then return end
		local pos = 70
		love.graphics.clear(0.4, 0.4, 0.4)
		love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.present()
	end

	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
		p = p .. "\nCopied to clipboard!"
	end

	if love.system then
		p = p .. "\n\nPress Ctrl+C or tap to copy this error"
	end

	return function()
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
			elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
				copyToClipboard()
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				if love.system then
					buttons[3] = "Copy to clipboard"
				end
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return 1
				elseif pressed == 3 then
					copyToClipboard()
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end
end

local threadEvent = love.thread.newThread("Engine/Backend/Threads/EventThread.lua")

local channel_event = love.thread.getChannel("thread.event")
local channel_active = love.thread.getChannel("thread.event.active")


love._framerate = 165

love._currentFPS = 0
love._currentTPS = 0

love._drawDT = 0

local _
local _, _, flags = love.window.getMode()
love._framerate = flags.refreshrate or 60

function love.run()
    local love = love
    local arg = arg
    
    local g_origin, g_clear, g_present = love.graphics.origin, love.graphics.clear, love.graphics.present
    local g_active, g_getBGColour = love.graphics.isActive, love.graphics.getBackgroundColor
    local e_pump, e_poll, t = love.event.pump, love.event.poll, {}
    local t_step = love.timer.step
    local t_getTime = love.timer.getTime
    local a, b
    local dt = 0
    local love_load, love_update, love_draw = love.load, love.update, love.draw
    local love_quit, a_parseGameArguments = love.quit, love.arg.parseGameArguments
    local collectgarbage = collectgarbage
    local love_handlers = love.handlers
    local math = math
    local math_min, math_max = math.min, math.max
    local unpack = unpack

    local channel_active_clear = channel_active.clear
    local channel_active_push = channel_active.push
    local channel_event_pop = channel_event.pop
    local channel_event_demand = channel_event.demand

	love_load(a_parseGameArguments(arg), arg)

	t_step()
    t_step()
    collectgarbage()

    ---@diagnostic disable-next-line: redefined-local
    local function event(name, a, ...)
        if name == "quit" and not love_quit() then
            channel_active_clear(channel_active)
            channel_active_clear(channel_active)
            channel_active_push(channel_active, 0)

            return a or 0, ...
        end

        return love_handlers[name](a, ...)
    end

    local drawTmr = 999999
    local lastDraw = 0
    local draws = 0
    local fpsTimer = 0.0

	return function()
		if threadEvent:isRunning() then
            channel_active_clear(channel_active)
            channel_active_push(channel_active, 1)
            a = channel_event_pop()

            while a do
                b = channel_event_demand()
                for i =  1, b do
                    t[i] = channel_event_demand()
                end
                _, a, b = b, event(a, unpack(t, 1, b))
                if a then
                    e_pump()
                    return a, b
                end
                a = channel_event_pop()
            end
        end

        e_pump()

        ---@diagnostic disable-next-line: redefined-local
        for name, a, b, c, d, e, f in e_poll() do
           a, b = event(name, a, b, c, d, e, f)
           if a then return a, b end
        end

        local cap = love._framerate
        local capDT = 1 / cap

        -- Cap the minimum delta time to 1/30 (30 FPS)
        dt = math_min(t_step(), math_max(capDT, 1 / 30))

        love_update(dt)
        drawTmr = drawTmr + dt
        
        if drawTmr >= capDT then
            if g_active() then
                g_origin()
                g_clear(g_getBGColour())

                love_draw(love._drawDT or 0)

                g_present()

                love._drawDT = t_getTime() - lastDraw
                draws = draws + 1

                fpsTimer = fpsTimer + love._drawDT

                if fpsTimer > 1 then
                    love._currentFPS = draws
                    love._draws = draws
                    fpsTimer = fpsTimer % 1
                    draws = 0
                end
                lastDraw = t_getTime()
            end
            drawTmr = drawTmr % capDT
        end

        collectgarbage("step")
    end
end

local o_timer_getFPS = love.timer.getFPS
function love.timer.getFPS()
    return o_timer_getFPS()
end

function love.timer.getDrawFPS()
    -- use love._drawDT instead of love._currentFPS
    return love._currentFPS
end