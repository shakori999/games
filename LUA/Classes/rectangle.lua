--turn this Object.extend(Object)
Rectangle = Shape:extend()

-- turns this Rectangle.new(self)
function Rectangle:new(x, y, width, height)
    Rectangle.super.new(self, x, y)
    self.width = width
    self.height = height
end
-- turn this Rectangle.update(self, dt)
--[[
function Rectangle:update(dt)
    self.x = self.x + self.speed * dt
end
--]]

-- turn this Rectangle.draw(self)
function Rectangle:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

