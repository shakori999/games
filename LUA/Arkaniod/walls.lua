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

return walls