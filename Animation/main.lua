function love.load()
    image = love.graphics.newImage("images/jump_2.png")
    local width = image:getWidth()
    local height = image:getHeight()
    frames = {}

    local frame_width = 117
    local frame_hight = 233
    maxFrames = 5
    for i=0,1 do
        -- I changed i to j in the inner for-loop
        for j=0,2 do
            --Meaning you also need to change it here
            table.insert(frames, love.graphics.newQuad(j * frame_width, i * frame_hight, frame_width, frame_hight, width, height))
            if #frames == maxFrames then
                break
            end
        end
    end
        

    -- I use a long name to avoid confusion with the variable named frames
    currentFrame = 1
end

function love.update(dt)
    currentFrame = currentFrame + 10 * dt

    if currentFrame >= 6 then
        currentFrame = 1
    end
end

function love.draw()
    love.graphics.draw(image, frames[math.floor(currentFrame)], 100, 100)
end

