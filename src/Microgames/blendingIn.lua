local blendingIn = {}

function blendingIn:start()
    self.directions = "Click Homer!"
    self.ok = false
    self.mouseX, self.mouseY = love.mouse.getPosition()
    self.assetsFolder = "Assets/Microgames/blendingIn/"
    self.background = love.graphics.newImage(self.assetsFolder .. "bg.png")
    self.homie = love.graphics.newImage(self.assetsFolder .. "homie.png")
    self.homer = love.graphics.newImage(self.assetsFolder .. "homer.png")
    self.homerLaugh = love.audio.newSource(self.assetsFolder .. "homerLaugh.mp3", "static")
    self.homieGrrr = love.audio.newSource(self.assetsFolder .. "GRRR.mp3", "static")

    self.homiePositions = {
        {180,163},
        {392,165},
        {650,150},
        {954,118}
    }

    self.homerPosition = love.math.random(1,#self.homiePositions)
end

function blendingIn:update(dt)

end

function blendingIn:checkForCompletion()
    return self.ok
end

function blendingIn:draw()
    love.graphics.draw(self.background)
    for i = 1,#self.homiePositions do
        x,y = self.homiePositions[i][1],self.homiePositions[i][2]
        if i ~= self.homerPosition then
            love.graphics.draw(self.homie, x, y)
        else
            love.graphics.draw(self.homer, x, y)
        end
    end
end

function blendingIn:clickHomer()
    self.homerLaugh:play()
    self.ok = true
end

function blendingIn:clickNotHomer()
    self.homieGrrr:play()
    self.ok = false
end

function blendingIn:mousepressed(x,y,button)
    if button == 1 then
        if x >= self.homiePositions[self.homerPosition][1] and x <= self.homiePositions[self.homerPosition][1] + self.homer:getWidth() then
            if y >= self.homiePositions[self.homerPosition][2] and y <= self.homiePositions[self.homerPosition][2] + self.homer:getHeight() then
                self:clickHomer()
                return
            end
        end
    end

    self:clickNotHomer()
end

function blendingIn:fail()
    return nil
end

return blendingIn