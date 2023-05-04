local love = require "love"

function Enemy_Circle(level)
        local dice = math.random(1, 4)
        local _x, _y
        local _radius = 20

        if dice == 1 then
                _x = math.random(_radius, love.graphics.getWidth())
                _y = - _radius * 4
        elseif dice == 2 then
                _x = - _radius * 4
                _y = math.random(_radius, love.graphics.getHeight())
        elseif dice == 3 then
                _x = math.random(_radius, love.graphics.getWidth())
                _y = love.graphics.getHeight() + _radius * 4
        else
                _x = love.graphics.getWidth() + _radius * 4
                _y = math.random(_radius, love.graphics.getHeight())
        end

        return {
                level = level or 1,
                radius = _radius,
                x = _x,
                y = _y,

                move = function (self, player_x, player_y)
                        if player_x - self.x > 0 then
                                self.x = self.x + self.level
                        elseif player_x - self.x < 0 then
                                self.x = self.x - self.level
                        end
                        if player_y - self.y > 0 then
                                self.y = self.y + self.level
                        elseif player_y - self.y < 0 then
                                self.y = self.y - self.level
                        end
                end,

                checkCircleTouched = function (player, enemy_x, enemy_y, enemy_radius)
			return math.sqrt((enemy_x - player.x_egg) ^ 2 + (enemy_y - player.y_egg) ^ 2) <= player.radius_egg + enemy_radius
		end,

                draw = function (self)
                        love.graphics.setColor(0, 0, 1)
                        love.graphics.circle("fill", self.x, self.y, self.radius)
                        love.graphics.setColor(1, 1, 1) -- white --
                end

        }
end

return Enemy_Circle