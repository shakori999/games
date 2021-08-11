
-- ball

local ball = {}
ball.position_x = 300
ball.position_y = 300
ball.speed_x = 300
ball.speed_y = 300
ball.radius = 10

ball.update = function(dt)
    ball.position_x = ball.position_x + ball.speed_x * dt 
    ball.position_y = ball.position_y + ball.speed_y * dt 
end

ball.draw = function()
    local segments_in_circle = 16
    love.graphics.circle("line",
                        ball.position_x,
                        ball.position_y,
                        ball.radius,
                        segments_in_circle)
end

ball.rebound = function(shift_ball_x, shift_ball_y)
    local min_shift = math.min( math.abs(shift_ball_x),
                                math.abs(shift_ball_y))
    if math.abs( shift_ball_x) == min_shift then
        shift_ball_y = 0
    else
        shift_ball_x = 0
    end
    ball.position_x = ball.position_x + shift_ball_x
    ball.position_y = ball.position_y + shift_ball_y

    if shift_ball_x ~= 0 then
        ball.speed_x = -ball.speed_x 
    end
    if shift_ball_y ~= 0 then
        ball.speed_y = -ball.speed_y 
    end
end

ball.reposition = function()
    ball.position_x = 200
    ball.position_y = 500
end

-- platform 

local platform= {}
platform.position_x = 400
platform.position_y = 550
platform.speed_x = 300
platform.width = 70
platform.height = 20

platform.update = function(dt)
    if love.keyboard.isDown("right") then
        platform.position_x = platform.position_x + platform.speed_x * dt
    end
    if love.keyboard.isDown("left") then
        platform.position_x = platform.position_x - platform.speed_x * dt
    end
end

platform.draw = function()
    love.graphics.rectangle("line",
                        platform.position_x,
                        platform.position_y,
                        platform.width,
                        platform.height)
end

platform.bounce_from_wall = function( shift_platform_x, shift_platform_y)
    platform.position_x = platform.position_x + shift_platform_x
end

-- bricks
local bricks = {}
bricks.rows = 5
bricks.columns = 11
bricks.top_left_postion_x = 70
bricks.top_left_postion_y = 50
bricks.horizontal_distance = 10
bricks.vertical_distance = 15
bricks.current_level_bricks = {}
bricks.brick_width = 50
bricks.brick_height = 30


bricks.new_brick = function(position_x, position_y, width, height)
    return (
        {
            position_x = position_x,
            position_y = position_y,
            width = width or bricks.brick_width,
            height = height or bricks.brick_height 
        }
    )
end

bricks.draw_brick = function(single_brick)
    love.graphics.rectangle('line',
                            single_brick.position_x,
                            single_brick.position_y,
                            single_brick.width,
                            single_brick.height)
end

bricks.update_brick = function( single_brick)
end

bricks.add_to_current_level_bricks = function( brick)
    table.insert( bricks.current_level_bricks, brick)
end

bricks.draw = function()
    for _, brick in pairs(bricks.current_level_bricks) do
        bricks.draw_brick(brick)
    end
end

bricks.update = function(dt)
    if #bricks.current_level_bricks == 0 then
        bricks.no_more_bricks = true
    else
        for _, brick in pairs(bricks.current_level_bricks) do
            bricks.update_brick(brick)
        end
    end
end

-- bricks.construct_level = function(level_bricks_arrangement)
--     bricks.no_more_bricks = false 
--     for row_index, row in ipairs(level_bricks_arrangement) do
--         for col_index, bricktype in ipairs (row) do
--             if bricktype ~= 0 then
--                 local new_brick_position_x = bricks.top_left_postion_x + (col_index - 1)*
--                     (bricks.brick_width + bricks.horizontal_distance)
--                 local new_brick_position_y = bricks.top_left_postion_y + (row_index - 1)*
--                     (bricks.brick_width + bricks.vertical_distance)
--                 local new_brick = bricks.new_brick(new_brick_position_x, new_brick_position_y)
--                 table.insert( bricks.current_level_bricks, new_brick)
--             end
--         end
--     end
-- end 
            

bricks.brick_hit_by_ball = function(i, brick, shift_ball_x, shift_ball_y)
    table.remove( bricks.current_level_bricks, i)
end

-- Walls
walls = {}
walls.thickness = 20
walls.current_level_walls = {}

walls.new_wall = function(position_x, position_y, width, height)
    return(
        {
            position_x = position_x,
            position_y = position_y,
            width = width,
            height = height
        }
    )
end

walls.construct_walls = function()
    local left_wall = walls.new_wall(
        0,
        0,
        walls.thickness,
        love.graphics.getHeight()
    )
    local right_wall = walls.new_wall(
        love.graphics.getWidth() - walls.thickness,
        0,
        walls.thickness,
        love.graphics.getHeight()
    )
    local top_wall = walls.new_wall(
        0,
        0,
        love.graphics.getWidth(),
        walls.thickness
    )
    local bottom_wall = walls.new_wall(
        0,
        love.graphics.getHeight() - walls.thickness,
        love.graphics.getWidth(),
        walls.thickness
    )
    walls.current_level_walls["left"] = left_wall
    walls.current_level_walls["right"] = right_wall 
    walls.current_level_walls["top"] = top_wall 
    walls.current_level_walls["bottom"] = bottom_wall
end

walls.update_wall = function(single_wall)
end

walls.update = function(dt)
    for _, wall in pairs(walls.current_level_walls)do
        walls.update_wall( wall)
    end
end

walls.draw = function()
    for _,wall in pairs(walls.current_level_walls) do
        walls.draw_wall(wall)
    end
end

walls.draw_wall = function(single_wall)
    love.graphics.rectangle("line", single_wall.position_x,
                                single_wall.position_y,
                                single_wall.width,
                                single_wall.height)
end

--levels
local levels = {}
levels.sequence = {}
levels.current_level = 1
levels.gamefinished = false
levels.sequence[1] = {
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1 },
   { 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1 },
   { 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0 },
   { 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0 },
   { 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

levels.sequence[2] = {
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1 },
   { 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0 },
   { 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0 },
   { 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0 },
   { 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

-- levels.switch_to_next_level = function(bricks)
--     if bricks.no_more_bricks then
--         if levels.current_level < #levels.sequence then
--             level.current_level = levels.current_level + 1
--             bricks.construct_level( levels.sequence[levels.current_level])
--             ball.reposition()
--         else
--             levels.gamefinished = true
--         end
--     end
-- end

-- collosions
local collisions = {}

collisions.resolve_collisions = function()
    collisions.ball_platform_collision(ball, platform) 
    collisions.ball_walls_collision(ball, walls) 
    collisions.ball_bricks_collision(ball, bricks) 
    collisions.platform_walls_collision(platform, walls) 
end
collisions.check_rectangles_overlap = function(a, b)
    local overlap = false
    local shift_b_x, shift_b_y = 0,0
    if not (a.x + a.width < b.x or b.x + b.width < a.x or
            a.y + a.height < b.y or b.y + b.height < a.y) then
        overlap = true
        if ( a.x + a.width / 2) < (b.x + b.width / 2) then
            shift_b_x = (a.x + a.width) - b.x
        else
            shift_b_x = a.x - (b.x + b.width)
        end
        if ( a.y + a.height / 2) < (b.y + b.height / 2) then
            shift_b_y = (a.y + a.height) - b.y 
        else
            shift_b_y = a.y - (b.y + b.height)
        end
    end
    return overlap, shift_b_x, shift_b_y
end 

collisions.ball_platform_collision = function(ball, platform)
    local overlap, shift_ball_x, shift_ball_y
    local a = {
        x = platform.position_x,
        y = platform.position_y,
        width = platform.width,
        height = platform.height
    }
    local b = {
        x = ball.position_x - ball.radius,
        y = ball.position_y - ball.radius,
        width = 2 * ball.radius,
        height = 2 * ball.radius
    }
    overlap, shift_b_x, shift_b_y = 
        collisions.check_rectangles_overlap(a, b)
    if overlap then
        ball.rebound( shift_b_x, shift_b_y)
    end
end

collisions.ball_walls_collision = function(ball, walls)
    local overlap, shift_ball_x, shift_ball_y
    local b = {
        x = ball.position_x - ball.radius,
        y = ball.position_y - ball.radius,
        width = 2 * ball.radius,
        height = 2 * ball.radius
    }
    for i,wall in pairs( walls.current_level_walls) do
        local a = {
            x = wall.position_x,
            y = wall.position_y,
            width = wall.width,
            height = wall.height
            }
        overlap, shift_ball_x, shift_ball_y = 
            collisions.check_rectangles_overlap(a, b)
        if overlap then
            ball.rebound(shift_ball_x, shift_ball_y)
        end
    end
end

collisions.platform_walls_collision = function(platform, walls)
    local overlap, shift_platform_x, shift_platform_y
    local a = {
        x = platform.position_x,
        y = platform.position_y,
        width = platform.width,
        height = platform.height
    }
    for i,wall in pairs(walls.current_level_walls)do

        local b = {
            x = wall.position_x , 
            y = wall.position_y ,
            width = wall.width,
            height = wall.height
            }
        overlap, shift_platform_x, shift_platform_y = 
            collisions.check_rectangles_overlap(a, b)
        if overlap then
            platform.bounce_from_wall( shift_platform_x, shift_platform_y)
        end
    end
end

collisions.ball_bricks_collision= function(ball, bricks)
    local overlap , shift_ball_x, shift_ball_y
    local b = {
        x = ball.position_x - ball.radius,
        y = ball.position_y - ball.radius,
        width = 2 * ball.radius,
        height = 2 * ball.radius
    }
    for i,brick in pairs( bricks.current_level_bricks) do
        local a = {
            x = brick.position_x,
            y = brick.position_y,
            width = brick.width,
            height = brick.height
            }
        overlap, shift_ball_x, shift_ball_y = 
            collisions.check_rectangles_overlap(a, b)
        if overlap then
            ball.rebound(shift_ball_x, shift_ball_y)
            bricks.brick_hit_by_ball(i, brick, shift_ball_x, shift_ball_y)
        end
    end
end

-- the main functions
love.load= function()
    bricks.construct_level()
    walls.construct_walls()
end

love.update = function(dt)
    ball.update(dt)
    platform.update(dt)
    bricks.update(dt)
    walls.update(dt)
    collisions.resolve_collisions()
    -- levels.switch_to_next_level( bricks )

end


love.draw = function()  
    ball.draw()
    platform.draw()
    bricks.draw()
    walls.draw()
    -- if levels.gamefinished then
    --     love.graphics.printf("congratulations!\n" , 300, 250,200,"center")
    -- end

end

love.keyreleased = function(key, code)
    if key == 'escape' then
        love.event.quit()
    end
end

love.quit = function()
    print("thanks for playing! come back soon")
end