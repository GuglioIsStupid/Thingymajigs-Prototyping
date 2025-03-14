local Debug = {}

function Debug:enter()
    microgameList = {}
    selectedMicrogame = 1
    for index, Microgame in ipairs(microgameHandler.microgames) do
        print(Microgame._NAME)
        table.insert(microgameList, {name = Microgame._NAME, directions = Microgame.directions, index = index})
    end
end

function Debug:update(dt)

end

function Debug:keypressed(key)
    if key == "w" then
        selectedMicrogame = selectedMicrogame-1
    elseif key == "s" then
        selectedMicrogame = selectedMicrogame+1
    elseif key == "return" then end
    if selectedMicrogame < 1 then selectedMicrogame = #microgameList elseif selectedMicrogame > #microgameList then selectedMicrogame = 1 end
end

function Debug:draw()
    love.graphics.printf("Debug Menu \n pweease dont look here if you are a regular player :pleading_face:", 500, 50, 1000, "left", 0, 1.5)
    for index, Microgame in ipairs(microgameList) do
        local width, height = 300, 20
        local x, y = 100, height

        if index == selectedMicrogame then  love.graphics.setColor(0,1,1) else love.graphics.setColor(1,1,1) end
        love.graphics.rectangle("line", x, y*index, width, height)
        love.graphics.print(Microgame.name .. "   " .. Microgame.directions, x, y*index+5)
        
    end
    love.graphics.setColor(1,1,1)
end

return Debug