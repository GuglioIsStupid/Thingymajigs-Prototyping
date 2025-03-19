local rpgBattle = BaseMicrogame:extend("rpgBattle")

function rpgBattle:start()
    self:startBattle()
end

function rpgBattle:preload()
    self.isBossMicrogame = true
    self.directions = "Win the Battle!"
    self.enemiesInBattle = {}
end

function rpgBattle:onLoad()
    print("testW")
    self.selectedAttack = 1
    self.superMark = {
        name = "Mark",
        health = 6,
        maxHealth = 6,
        attacks = {
            {
                name = "Jump",
                damage = 2, 
                canHitAirEnemy = true,
                desc = "A regular Jump. Deals 2 damage. Don't jump on spiked enemies, that would probably hurt.",
                animation = function(attack, character, target)
                    TweenManager:tween(character, {y = target.y-30}, 0.6, {ease = "quadOut", onComplete = function()
                        TweenManager:tween(character, {y = character.standY+30}, 0.6, {ease = "quadIn", onComplete = function() self:finishAttack(attack, character, target)end})
                    end})
                end,
            },

            {name = "Hammer", damage = 3, canHitAirEnemy = false, desc = "You hit your enemy with a fucking hammer. What the fuck is wrong with you? Deals 3 damage, can't reach flying enemies."},
        },
        x = 0,
        y = 0,
        standX = 0,
        standY = 0,
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
            {name = "Headbonk", damage = 3, animation = function(attack, character, target)
                TweenManager:tween(character, {y = target.y-30}, 0.6, {ease = "quadOut", onComplete = function()
                    TweenManager:tween(character, {y = character.standY+30}, 0.6, {ease = "quadIn", onComplete = function() self:finishAttack(attack, character, target)end})
                end})
            end,}
        },
        x = 0,
        y = 0,
        standX = 0,
        standY = 0,
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
        standX = 0,
        standY = 0,
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
    self.superMark.standX, self.superMark.standY = self.superMark.x, self.superMark.y
    self.enemiesInBattle = {
        self.gomber,
      --  self.flyingGomber
    }

    for index, Enemy in ipairs(self.enemiesInBattle) do
        Enemy.x = (love.graphics.getWidth()-200 + (60*(index-1)))
        Enemy.y = 600
        if Enemy.air then Enemy.y = Enemy.y - 200 end
        Enemy.standX, Enemy.standY = Enemy.x, Enemy.Y
    end

end

function rpgBattle:finishAttack(attack, attacker, target)
    target.health = target.health - attack.damage
    Timer.after(0.5, function()
        TweenManager:tween(attacker, {x = attacker.standX}, 1, {ease = "linear", onComplete = function() self.playersTurn = not self.playersTurn; self.doingAttack = false end})
        
    end)
end

function rpgBattle:update(dt)
    if not self.playersTurn and not self.doingAttack then -- enemy needs to attack
        self:doAttack(self.enemiesInBattle[1].attacks[love.math.random(1,#self.enemiesInBattle[1].attacks)], self.enemiesInBattle[1], self.superMark)
    end
end

function rpgBattle:drawAttacksBox()
    local x = 200
    local y = 200
    for index, Attack in ipairs(self.superMark.attacks) do
        love.graphics.setColor(1,1,1)
        if self.selectedAttack == index then love.graphics.setColor(0,1,1) end 
        local test = tostring(Attack.name .. "  |  " .. Attack.desc)

        love.graphics.rectangle("line", x,y+25*(index-1),#test*6.6,25)
        love.graphics.print(Attack.name .. "  |  " .. Attack.desc, x+25,y+25*(index-1)+5)
        love.graphics.setColor(1,1,1)
    end
    
end

function rpgBattle:doAttack(attack, attacker, target)

    print(attacker.name .. " uses " .. attack.name .. " on " .. target.name)
    self.doingAttack = true
   -- TweenManager:tween(obj, {y = 400}, 1 / microgameHandler.currentSpeed, {type = TweenType.PINGPONG, ease = "bounceOut"})

   -- Timer.tween(1, attacker, {x = target.x-20}, "linear")

   local targetX = self.playersTurn and target.x-40 or target.x+40
    TweenManager:tween(attacker, {x = targetX}, 1, {ease = "linear", onComplete = function() self:attackAnimation(attacker, attack, target) end})
end

function rpgBattle:attackAnimation(attacker, attack, target)
    attack.animation(attack, attacker, target)
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
    print("WHY")
    if key == "return" then print("coc") end
    if self.playersTurn and not self.doingAttack then
        if key == "w" or key == "up" then
            self.selectedAttack = self.selectedAttack - 1
        elseif key == "s" or key == "down" then
            self.selectedAttack = self.selectedAttack + 1
        elseif key == "return" then
            print(":WHAT")
            self:doAttack(self.superMark.attacks[self.selectedAttack], self.superMark, self.enemiesInBattle[1])
        end
    end
end

function rpgBattle:mousepressed(button)
end


return rpgBattle