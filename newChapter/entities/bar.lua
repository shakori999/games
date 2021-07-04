local world = require('world')

local bar = {}
bar.body = love.physics.newBody(world, 200, 450, 'static')
bar.shape = love.physics.newPolygonShape(0,0,0, 20, 400, 20, 400, 0)
bar.fixture = love.physics.newFixture(bar.body, bar.shape)

return bar
