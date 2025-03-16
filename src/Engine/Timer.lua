local Timer = {}

Timer._currentTimers = {}

function Timer.after(duration, callback, repeatCount)
    repeatCount = repeatCount or 0
    duration = duration or 0 -- in seconds
    callback = callback or function() end
    -- if repeatCount is -1, repeat forever
    local timer = {
        duration = duration,
        callback = callback,
        repeatCount = repeatCount,
        time = 0,
        repeatIndex = 0
    }
    table.insert(Timer._currentTimers, timer)
    return timer
end

function Timer.cancel(ref)
    if not ref then return end
    for i = #Timer._currentTimers, 1, -1 do
        if Timer._currentTimers[i] == ref then
            table.remove(Timer._currentTimers, i)
        end
    end
end

function Timer.update(dt)
    for i = #Timer._currentTimers, 1, -1 do
        local timer = Timer._currentTimers[i]
        timer.time = timer.time + dt
        if timer.time >= timer.duration then
            timer.callback()
            timer.time = 0
            timer.repeatIndex = timer.repeatIndex + 1
            if timer.repeatCount ~= -1 and timer.repeatIndex >= timer.repeatCount then
                table.remove(Timer._currentTimers, i)
            end
        end
    end
end

return Timer
