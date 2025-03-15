function loadImagesFromDir(directory)
    local function scanshit(directory)
        local files = love.filesystem.getDirectoryItems(directory)
        for i = 1,#files do
            if love.filesystem.getInfo(directory .. "/" .. files[i], "directory") then
                scanshit(directory)
            elseif love.filesystem.getInfo(directory .. "/" .. files[i], "file") then -- idk why i put this cuz if its not a dir it has to be a file
                if files[i]:match("%.png") then
                    self[]
                end
            end
        end
    end

end