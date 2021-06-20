love.load = function()
    arenaWidth = 800
    arenaHeight = 600

    shipX = arenaWidth / 2
    shipY = arenaHeight / 2
    shipAngle = 0
    shipSpeedX = 0
    shipspeedY = 0
    shipRadius = 30
    speed = 100

    bullets = {}
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
    shipX = (shipX + shipSpeedX * dt) % arenaWidth
    shipY = (shipY + shipspeedY * dt) % arenaHeight

    for bulletIndex, bullet in ipairs(bullets) do
        local bulletspeed = 500
        bullet.x = (bullet.x + math.cos(bullet.angle) * bulletspeed * dt) % arenaWidth
        bullet.y = (bullet.y + math.sin(bullet.angle) * bulletspeed * dt) % arenaWidth
    end
        
end

love.draw = function()
    for y = -1, 1 do
        for x = -1, 1 do
            love.graphics.origin()
            love.graphics.translate(x * arenaWidth, y * arenaHeight)

            love.graphics.setColor(0, 0, 1)
            love.graphics.circle('fill', shipX , shipY , shipRadius)

            local shipCircleDistance = 20
            love.graphics.setColor(0, 1, 1)
            love.graphics.circle("fill",
                shipX + math.cos(shipAngle) * shipCircleDistance,
                shipY + math.sin(shipAngle) * shipCircleDistance,
                5 
            )
            for bulletIndex, bullet in ipairs(bullets) do
                love.graphics.setColor(0, 1, 0)
                love.graphics.circle('fill', bullet.x, bullet.y, 5)
            end
        end
    end
end

love.keypressed = function(key)
    if key == 's' then
        table.insert(bullets, {
            x = shipX + math.cos(shipAngle) * shipRadius ,
            y = shipY + math.sin(shipAngle) * shipRadius,
            angle = shipAngle,
        })
    end
end
