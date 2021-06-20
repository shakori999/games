love.load = function()
    shipX = 800 / 2
    shipY = 600 / 2
    shipAngle = 0
    shipSpeedX = 0
    shipspeedY = 0
    speed = 100

end

love.update = function(dt)
    local turnSpeed = 10
    if love.keyboard.isDown('right') then
        shipAngle = shipAngle + turnSpeed * dt
    elseif love.keyboard.isDown('left') then
        shipAngle = shipAngle - turnSpeed * dt
    end
    shipAngle = shipAngle % (2 * math.pi)

    if love.keyboard.isDown('up') then
        shipSpeedX = shipSpeedX + math.cos(shipAngle) * speed * dt
        shipspeedY = shipspeedY + math.sin(shipAngle) * speed * dt
    elseif love.keyboard.isDown('down') then
        shipSpeedX = shipSpeedX - math.cos(shipAngle) * speed * dt
        shipspeedY = shipspeedY - math.sin(shipAngle) * speed * dt
    end

    shipX = shipX + shipSpeedX * dt
    shipY = shipY + shipspeedY * dt
end

love.draw = function()
    love.graphics.setColor(0, 0, 1)
    love.graphics.circle('fill', shipX , shipY , 30)

    local shipCircleDistance = 20
    love.graphics.setColor(0, 1, 1)
    love.graphics.circle("fill",
        shipX + math.cos(shipAngle) * shipCircleDistance,
        shipY + math.sin(shipAngle) * shipCircleDistance,
        5 
    )
    love.graphics.print(shipAngle)
end