local rpgBattle = BaseMicrogame:extend("rpgBattle")

function rpgBattle:start()
    self:startBattle()
end

function rpgBattle:preload()
    self.directions = "Win the Battle!"
end

function rpgBattle:onLoad()
    self.superMark = {
        name = "Mark",
        health = 6,
        maxHealth = 6,
        attacks = {
            {name = "Jump", damage = 2, canHitAirEnemy = true, desc = "A regular Jump. Deals 2 damage. Don't jump on spiked enemies, that probably would hurt."},
            {name = "Hammer", damage = 3, canHitAirEnemy = false, desc = "You hit your enemy with a fucking hammer. What the fuck is wrong with you? Deals 3 damage, can't reach flying enemies."},
        },
        x = 0,
        y = 0,
        width = 40,
        height = 70,

        draw = function(self)

            love.graphics.rectangle("fill", self.x, self.y-100, self.width*(self.health/self.maxHealth), 10)
            love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
            love.graphics.print(self.name, self.x, self.y)
        end,
    }

    self.gomber = {
        name = "Gomber",
        health = 4,
        maxHealth = 4,
        air = false,
        attacks = {
            {name = "Headbonk", damage = 3}
        },
        x = 0,
        y = 0,
        width = 40,
        height = 40,
        tattle = "That's a Gomber. Attack is 3, defense is 0, and health is 4. Any attack should kill it in about 2 hits.",

        draw = function(self)
            love.graphics.rectangle("fill", self.x, self.y-100, self.width*(self.health/self.maxHealth), 10)

            love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
            love.graphics.print(self.name, self.x, self.y)
        end,
    }

    self.flyingGomber = {
        name = "Flying Gomber",
        health = 5,
        maxHealth = 5,
        air = true, 
        attacks = {
            {name = "Swoop", damage =  4}
        },
        x = 0,
        y = 0,
        width = 40,
        height = 40,
        tattle = "That's a Flying Gomber. It can fly. (fucking obviously). Attack is 4, defense is 0, and health is 5. Your Hammer won't reach it, so use your Jump instead.",

        draw = function(self)
            love.graphics.rectangle("fill", self.x, self.y-100, self.width*(self.health/self.maxHealth), 10)

            love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
            love.graphics.print(self.name, self.x, self.y)
        end,
    }
    


end


function rpgBattle:startBattle()
    self.playersTurn = true
    self.doingAttack = false
    self.superMark.x, self.superMark.y = 200, 600
    self.enemiesInBattle = {
        self.gomber,
        self.flyingGomber
    }

    for index, Enemy in ipairs(self.enemiesInBattle) do
        Enemy.x = (love.graphics.getWidth()-200 + (60*(index-1)))
        Enemy.y = 600
        if Enemy.air then Enemy.y = Enemy.y - 200 end
    end

end

function rpgBattle:update(dt)
end

function rpgBattle:drawAttacksBox()
    
    local x = 200
    local y = 200
    for index, Attack in ipairs(self.superMark.attacks) do
        if self.selectedAttack == index then love.graphics.setColor(0,1,1) else love.graphics.setColor(1,1,1) end
        local test = tostring(Attack.name .. "  |  " .. Attack.desc)

        love.graphics.rectangle("line", x,y+25*(index-1),#test*6.6,25)
        love.graphics.print(Attack.name .. "  |  " .. Attack.desc, x+25,y+25*(index-1)+5)
    end
end

function rpgBattle:checkForCompletion()
    return self.ok
end

function rpgBattle:draw()

    self.superMark:draw()
    for index, Enemy in ipairs(self.enemiesInBattle) do
        Enemy:draw()
    end

    if self.playersTurn and not self.doingAttack then self:drawAttacksBox() end

end

function rpgBattle:keypressed(key)
    self.ok = true
end

function rpgBattle:mousepressed(button)
end


return rpgBattle