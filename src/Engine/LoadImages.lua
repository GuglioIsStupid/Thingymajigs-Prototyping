IMAGES = {}

function recursiveEnumerate(folder, file)
    local lfs = love.filesystem
    local filesTable = lfs.getDirectoryItems(folder)
    local files = {}
    for i, v in ipairs(filesTable) do
        local file = folder.."/"..v
        if lfs.getInfo(file).type == "file" then
            table.insert(files, file)
        elseif lfs.getInfo(file).type == "directory" then
            for i, f in ipairs(recursiveEnumerate(file)) do
                table.insert(files, f)
            end
        end
    end
    return files
end

function loadImagesFromDir(dir)
    local files = recursiveEnumerate(dir)
    local images = {}
    for _, file in ipairs(files) do
        local filename = file:match(".+/(.+)")
        local ext = filename:match(".+%.(.+)")
        local name = filename:match("(.+)%..+")
        if ext == "png" or ext == "jpg" or ext == "jpeg" then
            print("Loading image: "..name)
            images[name] = love.graphics.newImage(file)
        end
    end
    return images
end
