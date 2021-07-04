local world = require('world')

local triangle = {}
triangle.body = love.physics.newBody(world, 200, 200, 'dynamic')
triangle.body.setMass(triangle.body ,32)
triangle.shape = love.physics.newPolygonShape(100, 100, 200, 100, 200,200)
triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape)
triangle.fixture:setRestitution(0.95)

return triangle
