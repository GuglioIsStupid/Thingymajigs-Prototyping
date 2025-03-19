local Game = {}

function Game:enter()

end

function Game:update(dt)
    microgameHandler:update(dt)
end

function Game:mousepressed(x, y, button)
    microgameHandler:mousepressed(x, y, button)
end

function Game:mousereleased(x, y, button)
    if microgameHandler.mousereleased then 
        microgameHandler:mousereleased(x, y, button)
    end
end

function Game:keypressed(key)
    microgameHandler:keypressed(key)
end

function Game:draw()
    microgameHandler:draw()
end

return Game