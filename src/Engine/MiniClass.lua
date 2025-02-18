local MiniClass = {}

function MiniClass:new()
    local newObject = {}
    setmetatable(newObject, self)
    return newObject
end

function MiniClass:extend()
    local newClass = {}
    for k, v in pairs(self) do
        newClass[k] = v
    end
    newClass.__index = newClass
    newClass.super = self
    return newClass
end

setmetatable(MiniClass, {__call = MiniClass.new})

return MiniClass