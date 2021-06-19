love.load = function()
    love.graphics.setBackgroundColor(1, 1, 1)
end

love.draw = function()
    for y = 1, 160 do
        for x = 1, 120 do
            local cellSize = 5
            local cellDrawSize = cellSize - 1
            love.graphics.setColor(.86, .86, .86)

            love.graphics.rectangle('fill',
                (y - 1) * cellSize,
                (x - 1) * cellSize,
                cellDrawSize,
                cellDrawSize    
            )
        end
    end
end