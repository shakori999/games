function love.load()
    -- First require classic, since we use it to create our classes.
    Object = require "classic"
    -- Second require Entity, since it's the base class for our other classes.
    require "entity"
    require "player"
    require "wall"
    require "box"

    player = Player(100, 100)
    box = Box(400, 150)

    objects = {}
    table.insert(objects, player)
    table.insert(objects, box)

    walls = {}

    map = {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1},
        {1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    }

    for i, v in ipairs(map) do 
        for j, w in ipairs(v) do
            if w == 1 then
                table.insert(walls, Wall ((j - 1 ) * 50, (i - 1) * 50))
            end
        end
    end
end

function love.update(dt)
    for i, v in ipairs(objects) do
        v:update(dt)
    end

    for i, v in ipairs(walls) do
        v:update(dt)
    end

    local loop = true
    local limit = 0
    
    while loop do
        -- Set loop to false , if no collision happend it will stay false
        loop = false

        limit = limit + 1
        if limit > 100 then
            -- Still not done at loop 100
            -- Break it because we're probably stuck in an endless loop.
            break
        end

        for i = 1, #objects - 1 do
            for j = i + 1, #objects do
                local collision = objects[i]:resolveCollision(objects[j])
                if collision then
                    loop = true
                end
            end
        end

        for i, wall in ipairs(walls) do
            for j, object in ipairs(objects) do
                local collision =  object:resolveCollision(wall)
                if collision then
                    loop = true
                end
            end
        end
    end
end
function love.draw()
    -- Draw all the objects
    for i, v in ipairs(objects) do
        v:draw()
    end

    for i, v in ipairs(walls) do
        v:draw()
    end
end

function love.keypressed(key)
    -- Let the player jump when the up-key is pressed
    if key == "up" then
        player:jump()
    end
end
