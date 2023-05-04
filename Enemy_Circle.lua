local love = require "love"

function Enemy_Circle(level, x, y, radius)
        local dice = math.random(1, 4)
        local _x, _y
        local _radius = radius or 20

        _x = x or 50
        _y = y or 50

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