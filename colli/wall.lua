Wall = Entity:extend()

function Wall:new(x, y)
    Wall.super.new(self, x, y, "images/wall.png")
    -- Give the wall a strength of 100
    self.strength = 100
    self.weight = 0
end