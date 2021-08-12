local ball = require "ball"
local platform = require "platform"
local bricks = require "bricks"
local walls = require "walls"
local collisions = require "collisions"
local levels = require "levels"


-- the main functions
love.load= function()
    bricks.construct_level(levels.sequence[levels.current_level])
    walls.construct_walls()
end

love.update = function(dt)
    ball.update(dt)
    platform.update(dt)
    bricks.update(dt)
    walls.update(dt)
    collisions.resolve_collisions(ball, platform, walls, bricks)
    levels.switch_to_next_level( bricks , ball)

end


love.draw = function()  
    ball.draw()
    platform.draw()
    bricks.draw()
    walls.draw()
    if levels.gamefinished then
        love.graphics.printf("congratulations!\n" , 300, 250,200,"center")
    end

end

love.keyreleased = function(key, code)
    if key == 'escape' then
        love.event.quit()
    end
end

love.quit = function()
    print("thanks for playing! come back soon")
end