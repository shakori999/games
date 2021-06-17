function love.load()
    --Load the image
    image = love.graphics.newImage("images/tileset.png")

    -- We need the full image width and height for creating the quads
    local image_width = image:getWidth()
    local image_height = image:getHeight()

    -- if you don't know the width and height of each tile we can use the 
    -- number of rows and columns in the tileset
    -- Our tileset has 2 rows and 3 columns
    -- But you need to subtract 2 to make up for the empty pixels we included to prevent bleeding
    width = (image_width / 3 ) - 2
    height = (image_height / 2) - 2

    -- Create the quads
    quads = {}

    for i = 0, 1 do
        for j = 0, 2 do
            --The only reason this code is split up in multiple lines
            --is so that it fits the page
            table.insert(quads, love.graphics.newQuad(1 + j * (width + 2),
                    1 + i * (height + 2),
                    width, height, image_width, image_height))
        end
    end

    tilemap = {
        {1, 6, 6, 2, 1, 6, 6, 2},
        {3, 0, 0, 4, 5, 0, 0, 3},
        {3, 0, 0, 0, 0, 0, 0, 3},
        {4, 2, 0, 0, 0, 0, 1, 5},
        {1, 5, 0, 0, 0, 0, 4, 2},
        {3, 0, 0, 0, 0, 0, 0, 3},
        {3, 0, 0, 1, 2, 0, 0, 3},
        {4, 6, 6, 5, 4, 6, 6, 5}
    }

    --Create our player
    player = {
        image = love.graphics.newImage("images/player.png"),
        tile_x = 2,
        tile_y = 2
    }
end


function love.upload(dt)

end

function love.draw()
    --let's do it without ipairs first.

    -- for i = 1 till the number of values in tilemap
    --[[
    for i = 1, #tilemap do 
        -- For j till the number of values in this row
        for j = 1 , #tilemap[i] do
            --If the value on row i, column j equals 1
            if tilemap[i][j] == 1 then
                --Draw the rectangle.
                --Use i and j to position the rectangle.
                --j for x , i for y
                love.graphics.rectangle("line", j * 25, i * 25 , 25, 25)
            end
        end
    end
    --]]
    for i, row in ipairs(tilemap) do
        for j, tile in ipairs(row) do
            if tile ~= 0 then
                --Draw the image with the correct quad
                love.graphics.draw(image, quads[tile], j * width, i * height)
            end
        end
    end

    --Draw the player and multiple its tile position with the tile width and height
    love.graphics.draw(player.image, player.tile_x * width, player.tile_y * height)
end

function love.keypressed(key)
    local x = player.tile_x
    local y = player.tile_y

    if key == "left" then
        x = x - 1
    elseif key == "right" then
        x = x + 1
    elseif key == "up" then
        y = y - 1
    elseif key == "down" then
        y = y + 1
    end

    if isEmpty(x, y) then

        player.tile_x = x
        player.tile_y = y
    end
end

function isEmpty(x, y)
    return tilemap[y][x] == 0
end
