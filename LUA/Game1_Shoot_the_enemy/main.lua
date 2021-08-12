--[[
function love.load()
    Object = require "classic"
    require "player"
    require "enemy"
    require "bullet"

    player = Player()
    enemy = Enemy()
    listOfBullets = {}
end

function love.update(dt)
    player:update(dt)
    enemy:update(dt)
    
    for i,v in ipairs(listOfBullets) do
        v:update(dt)
    end
end

function love.draw()
    player:draw()
    enemy:draw()

    for i,v in ipairs(listOfBullets) do
        v:draw()
    end
end

--]]
function love.load()
    Object = require "classic"
    require "player"
    require "enemy"
    require "bullet"

    player = Player()
    enemy = Enemy()
    listOfBullets = {}
end

function love.update(dt)
    player:update(dt)
    enemy:update(dt)

    for i,v in ipairs(listOfBullets) do
        v:update(dt)
        --Each bullets checks if there is collision with the enemy
        v:checkCollision(enemy)
        --if the bullet has the property dead and it's true then..
        if v.dead then
            -- Remove it from the list
            table.remove(listOfBullets, 1)
        end
    end
end

function love.draw()
    player:draw()
    enemy:draw()

    for i,v in ipairs(listOfBullets) do
        v:draw()
    end
end
function love.keypressed(key)
    player:keyPressed(key)
end


