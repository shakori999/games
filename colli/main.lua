function love.load()
    -- First require classic, since we use it to create our classes.
    Object = require "classic"
    -- Second require Entity, since it's the base class for our other classes.
    require "entity"
    require "player"
    require "wall"

    player = Player(100, 100)
    wall = Wall(200, 100)
end

function love.update(dt)
    player:update(dt)
    wall:update(dt)
    player:resolveCollision(wall)
end

function love.draw()
    player:draw()
    wall:draw()
end