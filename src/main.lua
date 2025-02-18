require("Engine")
require("Microgames")

function love.load()
    microgameHandler = MicrogameHandler:new()
    microgameHandler:addMicrogame(testMicrogame)
end

function love.update(dt)
    microgameHandler:update(dt)
end

function love.draw()
    microgameHandler:draw()
end

function love.keypressed(key)
    microgameHandler:keypressed(key)
end