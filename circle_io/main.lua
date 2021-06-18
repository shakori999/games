function love.load()
    lume = require "lume"
    shakeDuration = 0
    shakeWait = 0
    shakeOffset = {x = 0, y = 0}

    -- load a canvas
    screenCanvas = love.graphics.newCanvas(400, 600)

    -- Create a player object with an x, y and size
    player = {
        x = 100,
        y = 100,
        size = 25,
        image = love.graphics.newImage("images/face.png")
    }

    player2 = {
        x = 300,
        y = 100,
        size = 25,
        image = love.graphics.newImage("images/face.png")
    }
    coins = {}

    score = 0
    score2 = 0

    if love.filesystem.getInfo("savedata.txt") then
        file = love.filesystem.read("savedata.txt")
        data = lume.deserialize(file)

        --Apply the player info
        player.x = data.player.x
        player.y = data.player.y
        player.size = data.player.size

        --Applay the player2 info
        player2.x = data.player2.x
        player2.y = data.player2.y
        player2.size = data.player2.size

        for i,v in ipairs(data.coins) do
            coins[i] = {
                x = v.x,
                y = v.y,
                size = 10,
                image = love.graphics.newImage("images/dollar.png")
            }
        end
    else
        --Only execute this if you don't have a save file
        for i = 1, 25 do
            table.insert(coins,
                {
                    --Give it a random position with math.random
                    x = love.math.random(50, 650),
                    y = love.math.random(50, 450),
                    size = 10,
                    image = love.graphics.newImage("images/dollar.png")
                }
            )
        end
    end

end

function love.update(dt)
    --Make it moveable with keyboard
    if love.keyboard.isDown("left") then
        player.x = player.x - 200 * dt
    elseif love.keyboard.isDown("right") then
        player.x = player.x + 200 * dt
    end

    --Note how I start a new if-statement instead of contuing the elseif
    --I do this because else you wouldn't be able to move diagonally.

    if love.keyboard.isDown("up") then
        player.y = player.y - 200 * dt
    elseif love.keyboard.isDown("down") then
        player.y = player.y + 200 * dt
    end



    --Make it moveable with keyboard
    if love.keyboard.isDown("a") then
        player2.x = player2.x - 200 * dt
    elseif love.keyboard.isDown("d") then
        player2.x = player2.x + 200 * dt
    end

    --Note how I start a new if-statement instead of contuing the elseif
    --I do this because else you wouldn't be able to move diagonally.

    if love.keyboard.isDown("w") then
        player2.y = player2.y - 200 * dt
    elseif love.keyboard.isDown("s") then
        player2.y = player2.y + 200 * dt
    end


    --Start at the end until 1, with steps of -1
    for i = #coins , 1, -1 do
        --Use coins[i] instead of v
        if checkCollision(player, coins[i]) then
            table.remove(coins, i)
            player.size = player.size + 1
            score = score + 1
            shakeDuration = 0.3
        elseif checkCollision(player2, coins[i]) then
            table.remove(coins, i)
            player2.size = player2.size + 1
            score2 = score2 + 1
            shakeDuration = 0.3
        end

    end

    if shakeDuration > 0 then
        shakeDuration = shakeDuration - dt
        if shakeWait > 0 then
            shakeWait = shakeWait - dt
        else
            shakeOffset.x = love.math.random(-5, 5)
            shakeOffset.y = love.math.random(-5, 5)
            shakeWait = 0.05
        end
    end

end

function love.draw()
    love.graphics.setCanvas(screenCanvas)
        love.graphics.clear()
        drawGame(player)
    love.graphics.setCanvas()

    --Draw the canvas
    love.graphics.draw(screenCanvas)

    love.graphics.setCanvas(screenCanvas)
        love.graphics.clear()
        drawGame(player2)
    love.graphics.setCanvas()
    love.graphics.draw(screenCanvas, 400)

    -- Add a line to separate the screens
    love.graphics.line(400, 0, 400, 600)

    love.graphics.print("player 1 - " .. score, 20, 10)
    love.graphics.print("player 2 - " .. score2, 20, 30)
end

function checkCollision(p1, p2) 
    -- Calculating distance in 1 line
    -- Subtract the x's and y's, square the difference
    -- Sum the squares and find the root of the sum.
    local distance = math.sqrt((p1.x - p2.x)^2 + (p1.y - p2.y)^2)
    -- Return whether the distance is lower than the sum of the sizes.
    return distance < p1.size + p2.size
end

function saveGame()
    data = {}
    data.player = {
        x = player.x,
        y = player.y,
        size = player.size
    }

    data.coins = {}
    for i,v in ipairs(coins) do
        --In this case data.coins[i] = value is the same as table.insert(data.coins, value)
        data.coins[i] = {x = v.x, y = v.y}
    end

    serialized = lume.serialize(data)
    --The filetype actually doesn't matter, and can even be omitted.
    love.filesystem.write("savedata.txt", serialized)
end

function love.keypressed(key)
    if key == "f1" then
        saveGame()
    elseif key == "f2" then
        love.filesystem.remove("savedata.txt")
        love.event.quit("restart")
    elseif key == "q" then
        love.event.quit()
    end
end

function drawGame(focus)
     -- Make a copy of the current state and push it onto the stack.
    love.graphics.push()        
        -- make the camera moves with the player
        -- -player.x, -player.y to get the player in the upper-left corner
        -- + 400 , +300. to move the player to the center
        love.graphics.translate(-focus.x + 200 , -focus.y + 300)

        if shakeDuration > 0 then
            -- Translate with a random number between -5 and 5.
            -- This second translate will be done based on the previous translate.
            -- So it will not reset the previous translate
            love.graphics.translate(shakeOffset.x, shakeOffset.y)
        end

        -- The players and coins are going to be circles
        love.graphics.circle("line", player.x, player.y, player.size)

        --Set the origin of the face to the center of the image
        love.graphics.draw(player.image,
                            player.x,
                            player.y,
                            0,
                            1,
                            1,
                            player.image:getWidth() / 2,
                            player.image:getHeight() / 2
                        )
                        
        -- The players2 and coins are going to be circles
        love.graphics.circle("line", player2.x, player2.y, player2.size)

        --Set the origin of the face to the center of the image
        love.graphics.draw(player2.image,
                            player2.x,
                            player2.y,
                            0,
                            1,
                            1,
                            player2.image:getWidth() / 2,
                            player2.image:getHeight() / 2
                        )

        for i, v in ipairs(coins) do
            love.graphics.circle("line", v.x, v.y, v.size)
            love.graphics.draw(v.image,
                v.x,
                v.y,
                0,
                1,
                1,
                v.image:getWidth() / 2,
                v.image:getHeight() / 2
                )
        end
    -- Pull the copy of the state of the stack and apply it.

    love.graphics.pop() 
end