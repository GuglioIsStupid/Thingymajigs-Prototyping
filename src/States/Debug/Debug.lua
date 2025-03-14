local Debug = {}
local currentMicrogame = nil

function Debug:enter()
    microgameList = {}
    selectedMicrogame = 1
    for index, Microgame in ipairs(microgameHandler.microgames) do
        print(Microgame._NAME)
        table.insert(microgameList, {name = Microgame._NAME, directions = Microgame.directions, reference = Microgame})
    end
end

function Debug:update(dt)
    if currentMicrogame then
        currentMicrogame:update(dt)
    end
end

function Debug:mousepressed(x, y, button)
    if currentMicrogame then
        currentMicrogame:mousepressed(x, y, button)
    end
end

function Debug:keypressed(key)
    if key == "w" then
        selectedMicrogame = selectedMicrogame-1
    elseif key == "s" then
        selectedMicrogame = selectedMicrogame+1
    elseif key == "return" then
        currentMicrogame = microgameList[selectedMicrogame].reference
        currentMicrogame:onLoad()
        currentMicrogame:start()
    elseif key == "escape" then
        currentMicrogame = nil
    else
        if currentMicrogame then
            currentMicrogame:keypressed(key)
        end
    end
    if selectedMicrogame < 1 then
        selectedMicrogame = #microgameList
    elseif selectedMicrogame > #microgameList then
        selectedMicrogame = 1
    end
end

function Debug:draw()
    if not currentMicrogame then
        love.graphics.printf("Debug Menu \n pweease dont look here if you are a regular player :pleading_face:", 500, 50, 1000, "left", 0, 1.5)
        for index, Microgame in ipairs(microgameList) do
            local width, height = 300, 20
            local x, y = 100, height

            if index == selectedMicrogame then  love.graphics.setColor(0,1,1) else love.graphics.setColor(1,1,1) end
            love.graphics.rectangle("line", x, y*index, width, height)
            love.graphics.print(Microgame.name .. "   " .. Microgame.directions, x, y*index+5)
            
        end
    else
        currentMicrogame:draw()

        love.graphics.setColor(0,0,0)
        for x = -1, 1 do
            for y = -1, 1 do
                love.graphics.print("Press [ESCAPE] to exit the microgame", 5 + x, 5 + y)
            end
        end
        love.graphics.setColor(1,1,1)
        love.graphics.print("Press [ESCAPE] to exit the microgame", 5, 5)
    end
    love.graphics.setColor(1,1,1)
end

return Debug