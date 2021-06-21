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

    asteroids = {
        {
            x = 100,
            y = 100,
        },
        {
            x = arenaWidth - 100,
            y = 100,
        },
        {
            x = arenaWidth / 2,
            y = arenaHeight - 100,
        },
    }
    for asteroidsIndex, asteroid in ipairs(asteroids) do
        asteroid.angle = love.math.random() * (2 math.pi)
    end
end

love.update = function(dt)
    local turnSpeed = 10
    if love.keyboard.isDown('right') then
        shipAngle = shipAngle + turnSpeed * dt
    end

    if love.keyboard.isDown('left') then
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

    for bulletIndex = #bullets, 1, -1 do
        local bullet = bullets[bulletIndex]

        bullet.timeLeft = bullet.timeLeft - dt

        if bullet.timeLeft <= 0 then
            table.remove(bullets, bulletIndex)
        else
            local bulletspeed = 500
            bullet.x = (bullet.x + math.cos(bullet.angle) * bulletspeed * dt) % arenaWidth
            bullet.y = (bullet.y + math.sin(bullet.angle) * bulletspeed * dt) % arenaWidth
        end
    end

    for asteroidsIndex, asteroid in ipairs(asteroids) do
        local asteroidSpeed = 20
        asteroid.x = (asteroid.x + math.cos(asteroid.angle) * asteroidSpeed * dt) % arenaWidth
        asteroid.y = (asteroid.y + math.sin(asteroid.angle) * asteroidSpeed * dt) % arenaHeight
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
            
            for asteroidsIndex, asteroid in ipairs(asteroids) do
                love.graphics.setColor(1, 1, 0)
                love.graphics.circle('fill', asteroid.x, asteroid.y , 80)
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
            timeLeft = 2,
        })
    end
end
