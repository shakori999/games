Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "images/player.png")
    self.strength = 10

    self.canjump = false
end

function Player:update(dt)
    -- It's important that we do this before changing the position
    player.super.update(self, dt)

    if love.keyboard.isDown("left") then
        self.x = self.x - 200 * dt
    elseif love.keyboard.isDown("right") then
        self.x = self.x + 200 * dt
    end

    if self.last.y ~= self.y then
        self.canjump = false
    end

end

function Player:jump()
    if self.canjump then
        self.gravity = -300
        self.canjump = false
    end
end

function Player:collide(e, direction)
    player.super.collide(self, e, direction)
    if direction == "bottom" then
        self.canjump = true
    end
end
