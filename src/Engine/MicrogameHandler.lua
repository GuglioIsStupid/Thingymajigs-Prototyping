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
    -- Every 5 microgames, the speed will increase by 0.5
    self.speedIncreaseInterval = 5
    
    self.microgameTimeSeconds = 5
    self.microgameTime = self.microgameTimeSeconds
    self.microgameTimeDecrease = 0.1
    self.microgameTimeMinimum = 1
    self.microgameTimeDecreaseInterval = 5

    self.wasCompleted = false

    self.basemicrogameTransition = {}
    self.basemicrogameTransition.update = function(_, parent, dt) 
        parent.microgameTransitionTimer = (parent.microgameTransitionTimer or 0) + dt
    end
    self.basemicrogameTransition.draw = function() love.graphics.print("Transitioning to next microgame | Last microgame was: " .. (self.wasCompleted and "completed" or "failed"), 100, 100) end
    self.basemicrogameTransition.isComplete = function(self, parent)
        return parent.microgameTransitionTimer >= parent.microGameTransitionTime
    end
    
    return self
end

function MicrogameHandler:addMicrogame(microgame)
    table.insert(self.microgames, microgame)
end

-- each microgame has a function called "checkForCompletion"
-- this function will check if the microgame has been completed
-- if it has, it will return true
-- if it hasn't, it will return false

function MicrogameHandler:update(dt)
    if #self.microgameRandomBag == 0 then
        for i = 1, #self.microgames do
            table.insert(self.microgameRandomBag, i)
        end
    end
    if self.microgameTransition then
        self.microgameTransition:update(self, dt)
        if self.microgameTransition:isComplete(self) then
            self.microgameTransition = nil
            if not self.currentMicrogame then
                self.currentMicrogame = self.microgames[table.remove(self.microgameRandomBag, love.math.random(1, #self.microgameRandomBag))]
                self.currentMicrogame:start()
            end
            self.currentMicrogame:start()

            -- reset time stuff
            self.microgameTime = self.microgameTimeSeconds
        end
    else
        if self.currentMicrogame then
            self.currentMicrogame:update(dt)
            if self.currentMicrogame:checkForCompletion() and self.microgameTime <= 0 then
                self.completedMicrogames = self.completedMicrogames + 1
                self.currentMicrogame = nil
                self.microgameTime = self.microgameTimeSeconds
                if self.completedMicrogames % self.speedIncreaseInterval == 0 then
                    self.currentSpeed = self.currentSpeed + 0.5
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
                self.currentMicrogame = nil
                self.microgameTime = self.microgameTimeSeconds

                -- transition to next
                self.microgameTransition = self.basemicrogameTransition
                self.microgameTransitionTimer = 0
                self.wasCompleted = false
            else
                self.microgameTime = self.microgameTime - dt
            end
        else
            self.currentMicrogame = self.microgames[table.remove(self.microgameRandomBag, love.math.random(1, #self.microgameRandomBag))]
            -- transition
            self.microgameTransition = self.basemicrogameTransition
        end
    end
end

function MicrogameHandler:draw()
    if self.microgameTransition then
        self.microgameTransition:draw()
    else
        if self.currentMicrogame then
            self.currentMicrogame:draw()
        end
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