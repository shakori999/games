love.load = function()
	bar = require('entities/bar')
	triangle = require('entities/triangle')
	world = require('world')
	messg = require('entities/text')

	paused = false

	key_map = {
		escape = function()
			love.event.quit()
		end,
		space = function()
			paused = not paused
		end
	}

end

love.update = function(dt)
	if not paused then
		world:update(dt)
	end
end

love.draw = function()
	love.graphics.polygon('line', triangle.body:getWorldPoints(triangle.shape:getPoints()))
	love.graphics.polygon('line', bar.body:getWorldPoints(bar.shape:getPoints()))
	love.graphics.print(text, 0,0)
	love.graphics.print(messg, 100, 100)
end

love.keypressed = function(pressed_key)
	if key_map[pressed_key] then
		key_map[pressed_key]()
	end
end

love.focus = function(f)
	if f then
		print('window is focused.')
		text = ("Focused")
		paused = false 
	else
		print("Window is not focused.")
		text = "UNFOCUSED"
		paused = true
	end
end
