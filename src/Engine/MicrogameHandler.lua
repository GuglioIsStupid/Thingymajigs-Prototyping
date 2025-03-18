local MicrogameHandler = MiniClass:extend()

function MicrogameHandler:new()
    MiniClass.new(self)
    self.microgames, self.microgameRandomBag = {}, {}
    self.bossgames, self.bossRandomBag = {}, {}
    self.currentMicrogame, self.lastMicrogame, self.microgameTransition = nil, nil, nil
    self.microgameTransitionTimer, self.microGameTransitionTime = 0, 1
    self.currentSpeed, self.completedMicrogames, self.currentZoom = 1, 0, 1
    self.speedIncreaseInterval, self.bpm = 2, 120
    self.microgameBeatTime, self.microgameTime = 0, 0
    self.beatTimeMax = 60 / self.bpm
    self.beat = 0
    self.microgameTimeDecreaseInterval, self.wasCompleted = 4, false
    self.displayDirections, self.displayMicrogame, self.firstGame = false, true, true
    self._scaleTween = nil
    self.loadBossGame = false
    
    self.basemicrogameTransition = {
        update = function(_, parent, dt) parent.microgameTransitionTimer = parent.microgameTransitionTimer + dt end,
        draw = function() end,
        isComplete = function(_, parent) return parent.microgameTransitionTimer >= parent.microGameTransitionTime end
    }
    return self
end

function MicrogameHandler:addMicrogame(microgame)
    if microgame.preload then microgame:preload() end
    table.insert(self.microgames, microgame)
end

function MicrogameHandler:addBossGame(microgame)
    if microgame.preload then microgame:preload() end
    table.insert(self.bossgames, microgame)
end

function MicrogameHandler:update(dt)
    if #self.microgameRandomBag == 0 then
        for i = 1, #self.microgames do table.insert(self.microgameRandomBag, i) end
    end
    if #self.bossRandomBag == 0 then
        for i = 1, #self.bossgames do table.insert(self.bossRandomBag, i) end
    end

    if self.microgameTransition then
        self.microgameTransition:update(self, dt)
        if self.microgameTransition:isComplete(self) and not self._scaleTween then
            if self.firstGame then
                self.currentMicrogame = self:_getNextMicrogame()
                self.currentMicrogame:onLoad()
            end
            self:_startMicrogameTransition()
        end
    else
        if self.currentMicrogame then
            if self.currentMicrogame.update then self.currentMicrogame:update(dt) end
            if not self.currentMicrogame.isBossMicrogame and self.currentMicrogame:checkForCompletion() and self.beat >= 5 then
                self:_handleMicrogameCompletion()
            elseif not self.currentMicrogame.isBossMicrogame and self.beat >= 5 then
                self:_handleMicrogameFailure()
            elseif self.currentMicrogame.isBossMicrogame then
                if self.currentMicrogame:checkForCompletion() or self.currentMicrogame:checkForFailure() then
                    self:_handleMicrogameCompletion()
                end
            else
                self:_handleBeatTime(dt)
            end
        else
            self.microgameTransition = self.basemicrogameTransition
        end
    end
end

function MicrogameHandler:draw()
    love.graphics.push()
    love.graphics.translate(640, 360)
    love.graphics.scale(self.currentZoom)
    love.graphics.translate(-640, -360)
    if self.currentMicrogame and self.displayMicrogame then self.currentMicrogame:draw() end
    love.graphics.pop()
    
    if self.microgameTransition and self.displayMicrogame then self.microgameTransition:draw() end
    if self.currentMicrogame and self.displayDirections then self:_drawDirections() end

    -- display beat and bpm with outlined text on right side
    love.graphics.setColor(0, 0, 0)
    for x = -1, 1, 2 do
        for y = -1, 1, 2 do
            love.graphics.printf(
                "Beat: " .. math.floor(self.beat) .. "\nBPM: " .. self.bpm,
                x-5, 5 + y, 
                Resolution.Width, "right"
            )
        end
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        "Beat: " .. math.floor(self.beat) .. "\nBPM: " .. self.bpm,
        -5, 5, 
        Resolution.Width, "right"
    )
end

function MicrogameHandler:keypressed(key)
    if not self.microgameTransition and self.currentMicrogame and self.currentMicrogame.keypressed then
        self.currentMicrogame:keypressed(key)
    end
end

function MicrogameHandler:mousepressed(x, y, button)
    if not self.microgameTransition and self.currentMicrogame and self.currentMicrogame.mousepressed then
        self.currentMicrogame:mousepressed(x, y, button)
    end
end

function MicrogameHandler:_getNextMicrogame()
    self.beat = 0
    repeat
        if self.loadBossGame then
            self.currentMicrogame = self.bossgames[table.remove(self.bossRandomBag, love.math.random(1, #self.bossRandomBag))]
            print(self.currentMicrogame._NAME)
            self.loadBossGame = false
        else
            self.currentMicrogame = self.microgames[table.remove(self.microgameRandomBag, love.math.random(1, #self.microgameRandomBag))]
        end
    until self.currentMicrogame ~= self.lastMicrogame
    if not self.currentMicrogame then
        -- reset bag, try again
        for i = 1, #self.microgames do table.insert(self.microgameRandomBag, i) end
        return self:_getNextMicrogame()
    end
    self.lastMicrogame = self.currentMicrogame
    return self.currentMicrogame
end

function MicrogameHandler:_startMicrogameTransition()
    self._scaleTween = TweenManager:tween(self, {currentZoom = 0.5}, 0.5 / self.currentSpeed, {
        ease = "bounceOut", 
        onComplete = function()
            if not self.firstGame then
                self.currentMicrogame = self:_getNextMicrogame()
                if self.currentMicrogame.onLoad then self.currentMicrogame:onLoad() end
            end
            self:_finalizeTransition()
        end
    })
end

function MicrogameHandler:_finalizeTransition()
    if self.currentMicrogame and self.currentMicrogame.close then self.currentMicrogame:close() end
    self.displayDirections = true
    Timer.after(1 / self.currentSpeed, function()
        self.displayDirections = false
        self._scaleTween = TweenManager:tween(self, {currentZoom = 1}, 0.5 / self.currentSpeed, {
            ease = "bounceOut", 
            onComplete = function()
                self.microgameTransition = nil
                self.microgameTransitionTimer = 0
                self.firstGame = false
                if self.currentMicrogame.start then self.currentMicrogame:start() end
                self._scaleTween = nil
            end
        })
    end)
end

function MicrogameHandler:_handleMicrogameCompletion()
    self.completedMicrogames = self.completedMicrogames + 1
    if self.currentMicrogame.finish then self.currentMicrogame:finish() end
    self:_increaseSpeedIfNeeded()
    self.wasCompleted = true
    self.microgameTransition = self.basemicrogameTransition
    self.microgameTransitionTimer = 0
end

function MicrogameHandler:_handleMicrogameFailure()
    if self.currentMicrogame.fail then self.microgameTransition = self.currentMicrogame:fail() end
    if self.currentMicrogame.finish then self.currentMicrogame:finish() end
    self.wasCompleted = false
    self.microgameTransition = self.basemicrogameTransition
    self.microgameTransitionTimer = 0
end

function MicrogameHandler:_handleBeatTime(dt)
    self.microgameTime = self.microgameTime + dt
    if self.microgameTime >= self.beatTimeMax then
        self.beat = self.beat + 1
        self.microgameTime = 0
        self:_handleOnBeat()
        print("Beat " .. self.beat)
    end
end

function MicrogameHandler:_handleOnBeat()
    if self.currentMicrogame.onBeat then self.currentMicrogame:onBeat() end
end

function MicrogameHandler:_increaseSpeedIfNeeded()
    if self.completedMicrogames % self.speedIncreaseInterval == 0 then
        self.currentSpeed = self.currentSpeed + 0.25
        self.loadBossGame = true
        print("Speed increased to " .. self.currentSpeed, self.loadBossGame)
    end
end

function MicrogameHandler:_drawDirections()
    love.graphics.setColor(0, 0, 0)
    for x = -1, 1, 2 do
        for y = -1, 1, 2 do
            love.graphics.print(self.currentMicrogame.directions, 5 + x, 5 + y)
        end
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.currentMicrogame.directions, 5, 5)
end

return MicrogameHandler