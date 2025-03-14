local harmoni = BaseMicrogame:extend("harmoni")
local notes
local lanes
local receptors

function harmoni:preload()
    self.directions = "Hit the Notes!"


end

function harmoni:update(dt)
    self.musicTime = self.musicTime+1000*dt


end

function harmoni:onLoad()
    self.musicTime = -50
    self.timer = microgameHandler.microgameTime

    notes = {}
    lanes = {}
    receptors = {}

    for i = 1,4 do
        table.insert(receptors, {down = false})
    end

    for i = 1,3 do
        local noteGap = self.timer*1000/3
        local lane = love.math.random(1,#lanes)
        table.insert(notes, {lane = lane, noteTime = noteGap*i-50})
    end

    
end

function harmoni:draw()

    for index, Note in ipairs(notes) do
        love.graphics.circle("fill", self.laneX[Note.lane], Note.noteTime-self.musicTime)
    end


end


return harmoni