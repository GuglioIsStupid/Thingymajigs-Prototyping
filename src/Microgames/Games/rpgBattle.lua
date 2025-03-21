local rpgBattle = BaseMicrogame:extend("rpgBattle")

function rpgBattle:start()
    self.ok = false
    self.state = "player"

end

function rpgBattle:onLoad()

    local playerHP = 7
    local playerDefense = 0
    self.player = {
        baseHP = playerHP,
        baseDefense = playerDefense,
        hp = playerHP,
        defense = playerDefense,
    }

    self.player.attacks = {
        {name = "Jump", damage = 2, crit = 40, desc = "Base Damage: 2, Crit Damage Increase: 1, Crit Percent: 40"},
        {name = "Strike", damage = 2, crit = 10, desc = "Base Damage: 2, Crit Damage Increase: 4, Crit Percent: 10"},
        {name = "Hammer", damage = 3, crit = 40, desc = "Base Damage: 3, Crit Damage Increase: 1, Crit Percent: 40"},
    }




end

function rpgBattle:preload()
    self.directions = "Win the Battle!"
    self.isBossMicrogame = true
    self.state = "setup"
    self.player = {}
    self.player.inventory = {}
    self.player.attacks = {}

    self.testEnemy = {
        HP = 10,
        Attack = 2,
    }
end

function rpgBattle:update(dt)

    if self.state == "setup" then
        
    elseif self.state == "player" then
        
    elseif self.state == "enemy" then

    end

end

function rpgBattle:checkForCompletion()
    return self.ok
end

function rpgBattle:draw()

    local screenCenter = {}
    screenCenter.x, screenCenter.y = love.graphics.getWidth()/2, love.graphics.getHeight()/2

    -- player stats
    love.graphics.rectangle("fill", screenCenter.x - 300, 650, screenCenter.x + 300, 50)
end

function rpgBattle:keypressed(key) 
    print("are")
    self.ok = true
end

function rpgBattle:mousepressed(button)
end

function rpgBattle:fail()
    return nil
end

return rpgBattle