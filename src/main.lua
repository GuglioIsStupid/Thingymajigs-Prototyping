require("Engine")
require("Microgames")

function love.load()
    microgameHandler = MicrogameHandler:new()
   -- microgameHandler:addMicrogame(testMicrogame)
    microgameHandler:addMicrogame(blendingIn)

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

function love.mousepressed(x,y,button)
    microgameHandler:mousepressed(x,y,button)
end