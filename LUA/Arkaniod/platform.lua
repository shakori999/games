-- platform 
local platform= {}
platform.position_x = 500
platform.position_y = 550
platform.speed_x = 500
platform.width = 70
platform.height = 20

platform.update = function(dt)
    if love.keyboard.isDown("right") then
        platform.position_x = platform.position_x + (platform.speed_x * dt)
    end
    if love.keyboard.isDown("left") then
        platform.position_x = platform.position_x - (platform.speed_x * dt)
    end
end

platform.draw = function()
    love.graphics.rectangle("line",
                        platform.position_x,
                        platform.position_y,
                        platform.width,
                        platform.height)
end

platform.bounce_from_wall = function( shift_platform_x)
    platform.position_x = platform.position_x + shift_platform_x
end

return platform