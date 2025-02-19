local MicrogameHandler = MiniClass:extend()

function MicrogameHandler:new()
    MiniClass.new(self)
    self.microgames = {}
    self.microgameRandomBag = {}
    self.currentMicrogame = nil
    self.microgameTransition = nil
    self.microGameTransitionTimer = 0
    self.microGameTransitionTime = 1
    self.currentSpeed = 1
    self.completedMicrogames = 0
    self.currentZoom = 1
    -- Every 5 microgames, the speed will increase by 0.25
    self.speedIncreaseInterval = 5
    
    self.microgameTimeSeconds = 5
    self.microgameTime = self.microgameTimeSeconds
    self.microgameTimeDecrease = 0.1
    self.microgameTimeMinimum = 1
    self.microgameTimeDecreaseInterval = 5

    self.wasCompleted = false

    self.displayDirections = false
    self.basemicrogameTransition = {}
    self.basemicrogameTransition.update = function(_, parent, dt) 
        parent.microgameTransitionTimer = (parent.microgameTransitionTimer or 0) + dt
    end
    self.basemicrogameTransition.draw = function() end
    self.basemicrogameTransition.isComplete = function(self, parent)
        return parent.microgameTransitionTimer >= parent.microGameTransitionTime
    end

    self._scaleTween = nil
    self.displayMicrogame = true
    self.firstGame = true
    self.lastMicrogame = nil
    return self
end

function MicrogameHandler:addMicrogame(microgame)
    if microgame.preload then
        microgame:preload()
    end
    table.insert(self.microgames, microgame)
end

function MicrogameHandler:update(dt)
    if #self.microgameRandomBag == 0 then
        for i = 1, #self.microgames do
            table.insert(self.microgameRandomBag, i)
        end
    end

    if self.currentMicrogame then
        print(self.currentMicrogame.directions)
    end

    if self.microgameTransition then
        self.microgameTransition:update(self, dt)
        if self.microgameTransition:isComplete(self) and not self._scaleTween then
            if self.firstGame then
                self.currentMicrogame = self.microgames[table.remove(self.microgameRandomBag, love.math.random(1, #self.microgameRandomBag))]
                if self.lastMicrogame then
                    while self.currentMicrogame == self.lastMicrogame do
                        local last = self.currentMicrogame
                        self.currentMicrogame = self.microgames[table.remove(self.microgameRandomBag, love.math.random(1, #self.microgameRandomBag))]
                        table.insert(self.microgameRandomBag, last)
                    end
                end
                self.lastMicrogame = self.currentMicrogame
                self.currentMicrogame:onLoad()
            end
            self._scaleTween = TweenManager:tween(self, {currentZoom = 0.5}, 0.5 / self.currentSpeed, {ease = "bounceOut", onComplete = function()
                if not self.firstGame then
                    self.currentMicrogame = self.microgames[table.remove(self.microgameRandomBag, love.math.random(1, #self.microgameRandomBag))]
                    if self.lastMicrogame then
                        while self.currentMicrogame == self.lastMicrogame do
                            local last = self.currentMicrogame
                            self.currentMicrogame = self.microgames[table.remove(self.microgameRandomBag, love.math.random(1, #self.microgameRandomBag))]
                            table.insert(self.microgameRandomBag, last)
                        end
                    end
                    self.lastMicrogame = self.currentMicrogame
                    if not self.currentMicrogame then
                        -- wtf??
                        -- reset bag and pull
                        self.microgameRandomBag = {}
                        for i = 1, #self.microgames do
                            table.insert(self.microgameRandomBag, i)
                        end
                        self.currentMicrogame = self.microgames[table.remove(self.microgameRandomBag, love.math.random(1, #self.microgameRandomBag))]
                        while self.currentMicrogame == self.lastMicrogame do
                            local last = self.currentMicrogame
                            self.currentMicrogame = self.microgames[table.remove(self.microgameRandomBag, love.math.random(1, #self.microgameRandomBag))]
                            table.insert(self.microgameRandomBag, last)
                        end
                    end
                    self.currentMicrogame:onLoad()
                end
                if self.currentMicrogame and self.currentMicrogame.close then
                    self.currentMicrogame:close()
                end
                self.displayDirections = true
                Timer.after(1 / self.currentSpeed, function()
                    self.displayDirections = false
                    self._scaleTween = TweenManager:tween(self, {currentZoom = 1}, 0.5 / self.currentSpeed, {ease = "bounceOut", onComplete = function()
                        self.microgameTransition = nil
                        self.microgameTransitionTimer = 0
                        self.currentMicrogame:start()

                        self._scaleTween = nil
                        self.microgameTime = self.microgameTimeSeconds
                        self.firstGame = false
                    end})
                end)
            end})
        end
    else
        if self.currentMicrogame then
            self.currentMicrogame:update(dt)
            if self.currentMicrogame:checkForCompletion() and self.microgameTime <= 0 then
                self.completedMicrogames = self.completedMicrogames + 1
                if self.currentMicrogame.finish then
                    self.currentMicrogame:finish()
                end
                self.microgameTime = self.microgameTimeSeconds
                if self.completedMicrogames % self.speedIncreaseInterval == 0 then
                    self.currentSpeed = self.currentSpeed + 0.25
                end
                if self.completedMicrogames % self.microgameTimeDecreaseInterval == 0 then
                    self.microgameTime = math.max(self.microgameTime - self.microgameTimeDecrease, self.microgameTimeMinimum)
                end
                self.wasCompleted = true

                -- transition to next
                self.microgameTransition = self.basemicrogameTransition
                self.microgameTransitionTimer = 0
            elseif self.microgameTime <= 0 then
                self.microgameTransition = self.currentMicrogame:fail()
                if self.currentMicrogame.finish then
                    self.currentMicrogame:finish()
                end
                self.microgameTime = self.microgameTimeSeconds

                -- transition to next
                self.microgameTransition = self.basemicrogameTransition
                self.microgameTransitionTimer = 0
                self.wasCompleted = false
            else
                self.microgameTime = self.microgameTime - dt
            end
        else
            -- transition
            self.microgameTransition = self.basemicrogameTransition
        end
    end
end

function MicrogameHandler:draw()
    love.graphics.push()
    love.graphics.translate(1280/2, 720/2)
    love.graphics.scale(self.currentZoom, self.currentZoom)
    love.graphics.translate(-1280/2, -720/2)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
    if self.currentMicrogame and self.displayMicrogame then
        self.currentMicrogame:draw()
    end
    love.graphics.pop()

    if self.microgameTransition and self.displayMicrogame then
        self.microgameTransition:draw()
    end

    if self.currentMicrogame and self.displayDirections then
        love.graphics.setColor(0, 0, 0)
        for x = -1, 1, 2 do
            for y = -1, 1, 2 do
                love.graphics.print(self.currentMicrogame.directions, 5 + x, 5 + y)
            end
        end
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(self.currentMicrogame.directions, 5, 5)
    end
end

function MicrogameHandler:keypressed(key)
    if self.microgameTransition then
        return
    end
    if self.currentMicrogame then
        self.currentMicrogame:keypressed(key)
    end
end

function MicrogameHandler:mousepressed(x,y,button)
    if self.microgameTransition then
        return
    end
    if self.currentMicrogame then
        self.currentMicrogame:mousepressed(x,y,button)
    end
end

return MicrogameHandler