local harmoni = BaseMicrogame:extend("harmoni")

function harmoni:preload()
    self.directions = "Hit the Notes!"
    self.images = loadImagesFromDir("Assets/Microgames/harmoni") -- lmao the real harmoni skin in its entirety

    self.noteImages = {
        self.images["NoteLeft"],
        self.images["NoteDown"],
        self.images["NoteUp"],
        self.images["NoteRight"],
    }

    self.receptorImages = {
        self.images["ReceptorLeft"],
        self.images["ReceptorDown"],
        self.images["ReceptorUp"],
        self.images["ReceptorRight"],
        self.images["ReceptorPressedLeft"],
        self.images["ReceptorPressedDown"],
        self.images["ReceptorPressedUp"],
        self.images["ReceptorPressedRight"],
    }


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
        local y,x = Note.noteTime-self.musicTime, self.laneX[Note.lane]
        love.graphics.draw(self.noteImages[Note.lane], x,y)
        --love.graphics.circle("fill", self.laneX[Note.lane], x,y,25)
    end
    for index, Receptor in ipairs(self.receptors) do
        love.graphics.circle("line", self.laneX[index], 0, 25)
    end


end


return harmoni