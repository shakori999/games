Entity = Object:extend()

function Entity:new(x, y, image_path)
    self.x = x
    self.y = y
    self.image = love.graphics.newImage(image_path)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.last = {}
    self.last.x = self.x
    self.last.y = self.y

    -- Defualt value to the variable
    self.strength = 0
    -- Temp means temporary
    self.tempstrength = 0

    -- Add the gravity and weight properties
    self.gravity = 0
    self.weight = 400
end

function Entity:update(dt)
    self.last.x = self.x
    self.last.y = self.y

    self.tempstrength = self.strength

    -- Increase the gravity using the weight
    self.gravity = self.gravity + self.weight * dt

    -- Increase the y-position
    self.y = self.y + self.gravity * dt

end

function Entity:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Entity:checkCollision(e)
    -- e will be the other entity with which we check if there is collision.

    return self.x + self.width > e.x
    and self.x < e.x + e.width
    and self.y + self.height > e.y
    and self.y < e.y + e.height
end

function Entity:wasVerticallyAligned(e)
    return self.last.y < e.last.y + e.height and self.last.y + self.height > e.last.y
end

function Entity:wasHorizontallyAlligned(e)
    return self.last.x < e.last.x + e.width and self.last.x + self.width > e.last.x
end


function Entity:resolveCollision(e)
    if self.tempstrength > e.tempstrength then
        -- We need to return the value
        return e:resolveCollision(self)
    end

    if self:checkCollision(e) then
        self.tempstrength = e.tempstrength
        if self:wasVerticallyAligned(e) then
            if self.x + self.width / 2 < e.x + e.width / 2 then
                -- Pushback = the right side of the player - the left side of the wall
                self:collide(e, "right")
            else
                -- Pushback = the right side of the wall - the left side of the player
                self:collide(e, "left")
            end
        elseif self:wasHorizontallyAlligned(e) then
            if self.y + self.height / 2 < e.y + e.height / 2 then
                -- Pushback = the bottom side of the player - the top side of the wall
                self:collide(e, "bottom")
            else
                --Pushback = the bottom side of the wall - the top side of the player
                self:collide(e, "top")
            end
        end
        -- There was collision! After we've resolved the collision return true
        return true
    end
    -- There was no collision, return false
    -- if you don't return anything is still fine bc return's value of nothing is nil
    return false
end

-- When the entity collides with something with his right side
function Entity:collide(e, direction)
    if direction == "right" then
        local pushback = self.x + self.width - e.x
        self.x = self.x - pushback
    elseif direction == "left" then
        local pushback = e.x + e.width - self.x
        self.x = self.x + pushback
    elseif direction == "bottom" then
        local pushback = self.y + self.height - e.y
        self.y = self.y - pushback
        self.gravity = 0
    elseif direction == "top" then
        local pushback = e.y + e.height - self.y
        self.y = self.y + pushback
    end
end