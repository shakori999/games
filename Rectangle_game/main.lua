function love.load()
    listOfRectangles = {}
end

function createRect()
    local rect = {}
    rect.x = 100
    rect.y = 100
    rect.width = 70
    rect.height = 90
    rect.speed = 100
    --move = true
    --fruits = {"apple", "banana","pear"}
    table.insert(listOfRectangles, rect)
end


function love.update(dt)
    --[[
   if love.keyboard.isDown("right") then
        rect.x = rect.x + 100 * dt
    else
        rect.x = rect.x - 100 * dt
    end
    if love.keyboard.isDown("down") then
        rect.y = rect.y + 100 * dt
    else
        rect.y = rect.y - 100 * dt
    end
    --]]
    --------------------------------------------------
   for i,v in ipairs(listOfRectangles) do
       v.x = v.x + v.speed * dt
   end
end


function love.draw(dt)
    --[[
    love.graphics.rectangle("line", rect.x, rect.y, rect.width, rect.height)
    for i, v in ipairs(fruits) do
        love.graphics.print(v, 100, 100 + 50 * i)
    end
    --]]
    ----------------------------------------------------------------
    for i,v in ipairs(listOfRectangles) do
        love.graphics.rectangle("line", v.x, v.y, v.width, v.height)
    end
end


function love.keypressed(key)
    if key == "space" then
        createRect()
    end
end


require("example")
print(test)
