local Button = MiniClass:extend("Button")

function Button:new(x, y, width, height, text, onClick, image)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.onClick = onClick
    self.hovered = false
    self.down = false
    self.scale = 1
    self.image = image
    if self.image then
        self.width, self.height = self.image:getDimensions()
    end
end

function Button:mousepressed(x, y, button)
    local w, h = self.width * self.scale, self.height * self.scale
    if x >= self.x and x <= self.x + w and y >= self.y and y <= self.y + h then
        self.down = true
    end
end

function Button:mousereleased(x, y, button)
    local w, h = self.width * self.scale, self.height * self.scale
    if x >= self.x and x <= self.x + w and y >= self.y and y <= self.y + h then
        if self.onClick then
            self.onClick()
        end
    end
    self.down = false
end

function Button:mousemoved(x, y)
    local w, h = self.width * self.scale, self.height * self.scale
    if x >= self.x and x <= self.x + w and y >= self.y and y <= self.y + h then
        self.hovered = true
    else
        self.hovered = false
    end
end

function Button:getWidth()
    return self.width * self.scale
end

function Button:getHeight()
    return self.height * self.scale
end

function Button:draw()
    if self.image then
        if self.down then
            love.graphics.setColor(0.6, 0.6, 0.6)
        elseif self.hovered then
            love.graphics.setColor(0.8, 0.8, 0.8)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
    else
        local w, h = self.width * self.scale, self.height * self.scale
        if self.down then
            love.graphics.setColor(0.6, 0.6, 0.6)
        elseif self.hovered
            then love.graphics.setColor(0.8, 0.8, 0.8)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.rectangle("fill", self.x, self.y, w, h)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(self.text, self.x + w / 2 - love.graphics.getFont():getWidth(self.text) / 2, self.y + h / 2 - love.graphics.getFont():getHeight() / 2)
        love.graphics.setColor(1, 1, 1)
    end
end

return Button