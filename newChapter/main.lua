local number = 0

love.draw = function()
    number = number + 1
    local rectangle = {100, 200, 100, 100, 200, 200, 200, 100}
    love.graphics.polygon("line", rectangle)
end
