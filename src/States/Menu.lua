local Menu = {}

local CURRENT_PROMPT = "NONE"

function Menu:enter()
    self.agoriBTN = Button(0, 0, 100, 50, "Agori", function()
        CURRENT_PROMPT = "AGORI_CONFIRM"
    end, love.graphics.newImage("Assets/UI/AGORI_BTN.png"))
    self.agoriBTN.scale = 0.5

    self.agoriBTN.x = Resolution.Width - self.agoriBTN:getWidth()-25
    self.agoriBTN.y = Resolution.Height - self.agoriBTN:getHeight()-25

    self.prompts = {}
    self.prompts.agoriConfirm = {
        text = "This button leads to the AGORI website. Are you sure you want\nto continue?",
        yesBtn = Button(Resolution.Width/2-200, Resolution.Height/2-100+150, 100, 50, "Yes", function()
            CURRENT_PROMPT = "NONE"
            love.system.openURL("https://agori.dev")
        end),

        noBtn = Button(Resolution.Width/2+100, Resolution.Height/2-100+150, 100, 50, "No", function()
            CURRENT_PROMPT = "NONE"
        end)
    }
    
    --[[ self.logo = {
        image = love.graphics.newImage("Assets/Menus/awesomesauce.png"),
        frames = {},
        currentFrame = 1,
        fps = 12,
        timer = 0,
        fw = 720,
        fh = 720,
    }

    local rows, cols = self.logo.image:getHeight()/self.logo.fh, self.logo.image:getWidth()/self.logo.fw
    for i = 1, rows do
        for j = 1, cols do
            table.insert(self.logo.frames, love.graphics.newQuad((j-1)*self.logo.fw, (i-1)*self.logo.fh, self.logo.fw, self.logo.fh, self.logo.image:getDimensions()))
        end
    end

    self.menuMusic = love.audio.newSource("Assets/Menus/awesomesauce.mp3", "stream")
    self.menuMusic:setLooping(true)
    self.menuMusic:play() ]]
end

function Menu:update(dt)
    --[[ self.logo.currentFrame = self.logo.currentFrame + self.logo.fps * dt
    if self.logo.currentFrame >= #self.logo.frames+1 then
        self.logo.currentFrame = 1
    end ]]
end

function Menu:mousepressed(x, y, button)
    if CURRENT_PROMPT == "NONE" then
        self.agoriBTN:mousepressed(x, y, button)
    elseif CURRENT_PROMPT == "AGORI_CONFIRM" then
        self.prompts.agoriConfirm.yesBtn:mousepressed(x, y, button)
        self.prompts.agoriConfirm.noBtn:mousepressed(x, y, button)
    end
end

function Menu:mousereleased(x, y, button)
    if CURRENT_PROMPT == "NONE" then
        self.agoriBTN:mousereleased(x, y, button)
    elseif CURRENT_PROMPT == "AGORI_CONFIRM" then
        self.prompts.agoriConfirm.yesBtn:mousereleased(x, y, button)
        self.prompts.agoriConfirm.noBtn:mousereleased(x, y, button)
    end
end

function Menu:mousemoved(x, y)
    if CURRENT_PROMPT == "NONE" then
        self.agoriBTN:mousemoved(x, y)
    elseif CURRENT_PROMPT == "AGORI_CONFIRM" then
        self.prompts.agoriConfirm.yesBtn:mousemoved(x, y)
        self.prompts.agoriConfirm.noBtn:mousemoved(x, y)
    end
end

function Menu:draw()
    self.agoriBTN:draw()

    --[[ love.graphics.draw(self.logo.image, self.logo.frames[math.floor(self.logo.currentFrame)], Resolution.Width/2-self.logo.fw/2, Resolution.Height/2-self.logo.fh/2) ]]

    if CURRENT_PROMPT == "AGORI_CONFIRM" then
        love.graphics.rectangle("fill", Resolution.Width/2-200, Resolution.Height/2-100, 400, 200)
        love.graphics.setColor(0, 0, 0)
        
        love.graphics.print(self.prompts.agoriConfirm.text, Resolution.Width/2-200+10, Resolution.Height/2-100+10)
        love.graphics.setColor(1, 1, 1)

        self.prompts.agoriConfirm.yesBtn:draw()
        self.prompts.agoriConfirm.noBtn:draw()
        
    end
end

function Menu:exit()
end

return Menu