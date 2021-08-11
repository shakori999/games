-- ball
local ball = {}
ball.position_x = 200
ball.position_y = 500
ball.speed_x = 700
ball.speed_y = 700
ball.radius = 10

ball.update = function(dt)
    ball.position_x = ball.position_x + ball.speed_x * dt 
    ball.position_y = ball.position_y + ball.speed_y * dt 
end

ball.draw = function()
    local segments_in_circle = 16
    love.graphics.circle("line",
                        ball.position_x,
                        ball.position_y,
                        ball.radius,
                        segments_in_circle)
end

ball.rebound = function(shift_ball_x, shift_ball_y)
    local min_shift = math.min( math.abs(shift_ball_x),
                                math.abs(shift_ball_y))
    if math.abs( shift_ball_x) == min_shift then
        shift_ball_y = 0
    else
        shift_ball_x = 0
    end
    ball.position_x = ball.position_x + shift_ball_x
    ball.position_y = ball.position_y + shift_ball_y

    if shift_ball_x ~= 0 then
        ball.speed_x = -ball.speed_x 
    end
    if shift_ball_y ~= 0 then
        ball.speed_y = -ball.speed_y 
    end
end

ball.reposition = function()
    ball.position_x = 200
    ball.position_y = 500
end

return ball