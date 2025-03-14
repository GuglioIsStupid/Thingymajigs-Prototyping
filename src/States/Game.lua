local Game = {}

function Game:enter()

end

function Game:update(dt)
    microgameHandler:update(dt)
end

function Game:draw()
    microgameHandler:draw()
end

return Game