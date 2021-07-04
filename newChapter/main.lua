love.load = function()
	world = love.physics.newWorld(0, 100)
	triangle = {}
	triangle.body = love.physics.newBody(world, 200, 200, 'dynamic')
	triangle.body:setMass(32)
	triangle.shape = love.physics.newPolygonShape(100, 100, 200, 100, 200, 200)
	triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape)

	bar = {}
	bar.body = love.physics.newBody(world, 200, 450, 'static')
	bar.shape = love.physics.newPolygonShape(0, 0, 0, 20, 400, 20, 400, 0)
	bar.fixture = love.physics.newFixture(bar.body, bar.shape)
	
	key_map = {
		escape = function()
			love.event.quit()
		end
	}
end

love.update = function(dt)
	world:update(dt)
end

love.draw = function()
	love.graphics.polygon('line', triangle.body:getWorldPoints(triangle.shape:getPoints()))
	love.graphics.polygon('line', bar.body:getWorldPoints(bar.shape:getPoints()))
end

love.keypressed = function(pressed_key)
	if key_map[pressed_key] then
		key_map[pressed_key]()
	end
end
