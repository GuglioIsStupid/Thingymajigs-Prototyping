local erase = BaseMicrogame:extend("erase")

function erase:start()
    self.ok = false
end

function erase:preload()
    print("COCK")
    self.directions = "Identify the Object!"
end

function erase:onLoad()
    self.pointCount = 2000
    self.rows, self.columns = 50,50
    self.spotWidth, self.spotHeight = love.graphics.getWidth()/self.columns, love.graphics.getHeight()/self.rows
    self.points = {}

    for i = 1,self.rows do
        local y = i*self.spotHeight
        for j = 1,self.columns do
            local x = j*self.spotWidth
            table.insert(self.points, {visible = true, x = x, y = y})
        end
    end
end



function erase:update(dt)
end

function erase:checkForCompletion()
    return self.ok
end

function erase:draw()
    love.graphics.print("This is a test microgame", 100, 100)
    love.graphics.print("Press any key to complete", 100, 120)
    for index, Point in ipairs(self.points) do
        love.graphics.circle("fill", Point.x, Point.y)
    end
end

function erase:keypressed(key) 
    print("are")
    self.ok = true
end

function erase:mousepressed(button)
end

function erase:fail()
    return nil
end

return erase