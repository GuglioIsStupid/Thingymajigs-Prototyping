local harmoni = BaseMicrogame:extend("harmoni")

function harmoni:preload()
    self.directions = "Hit the Notes!"


end

function harmoni:update(dt)
    self.musicTime = self.musicTime+1000*dt


end

function harmoni:onLoad()
    self.musicTime = -50
    self.timer = microgameHandler.microgameTime
    self.gameScreenMiddle = love.graphics.getWidth()/2
    self.laneWidth = 30
    self.laneX = {
        self.gameScreenMiddle - (self.laneWidth*1.5),
        self.gameScreenMiddle - (self.laneWidth*0.5),
        self.gameScreenMiddle + (self.laneWidth*0.5),
        self.gameScreenMiddle + (self.laneWidth*1.5),
    }

    self.notes = {}
    self.receptors = {}

    for i = 1,4 do
        table.insert(self.receptors, {down = false})
    end

    for i = 1,3 do
        local noteGap = self.timer*1000/3
        local lane = love.math.random(1,#self.laneX)
        table.insert(self.notes, {lane = lane, noteTime = noteGap*i-50})
    end

    
    
end

function harmoni:draw()

    for index, Note in ipairs(self.notes) do
        love.graphics.circle("fill", self.laneX[Note.lane], Note.noteTime-self.musicTime, 25)
    end
    for index, Receptor in ipairs(self.receptors) do
        love.graphics.circle("line", self.laneX[index], 0, 25)
    end


end


return harmoni