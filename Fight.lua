local love = require "love"

function Fight_mod(sonic, game)
	return {
		sonic = sonic,
		game = game,
		x_def = 240,
		y_def = love.graphics.getHeight() / 2.5,
		width_def = love.graphics.getWidth() - 500,
		height_def = love.graphics.getHeight() / 3,

		draw_rectangle = function(self)
			love.graphics.rectangle("line", 50 , love.graphics.getHeight() / 2.5, love.graphics.getWidth() - 100, love.graphics.getHeight() / 4)
		end,
		draw_rectangle_defense = function(self)
			love.graphics.rectangle("line", self.x_def , self.y_def , self.width_def, self.height_def)
		end,
		sonic_bubble = function(self, text)
			text = text or "..."
			love.graphics.push()
			love.graphics.scale(0.2)
			love.graphics.draw(sonic.sprite.bubble_sprite, sonic.x + 1500, sonic.y + 300)
			love.graphics.pop()
			love.graphics.setColor(0,0,0)
			love.graphics.print(text, sonic.x + 100, sonic.y)
			love.graphics.setColor(1,1,1)
			end,
	
		change_phase = function(self, state)
			game.phase["atk"] = state == "atk"
			game.phase["atk_phase"] = state == "atk_phase"
			game.phase["defense"] = state == "defense"
			game.phase["dead_sonic"] = state == "dead_sonic"
			game.phase["end_phase"] = state == "end_phase"
		end,

		sonic_print = function(self, i_frame)
			i_frame = math.floor(i_frame)
			love.graphics.draw(sonic.sprite.img_sprite, Quads[i_frame], sonic.x, sonic.y)
		end,

		damage = function(self, timer)
			timer = timer or 2
			self:draw_rectangle()
			local atk_image = love.graphics.newImage("img/sprite/mort_sonic.png")
			love.graphics.draw(atk_image, sonic.x - 120, sonic.y - 140)
			if timer >= 1 and timer < 3 then
				self:sonic_bubble("fumier")
			end
		end,

		ft_atk_phase = function(self, x_bar, y_bar_top, y_bar_down)
			x_bar = x_bar or 50
			y_bar_top = y_bar_top or 200
			y_bar_down = y_bar_down or 325
			local atk_bar = love.graphics.newImage("img/sprite/undertale-attack-bar.png")
			love.graphics.draw(atk_bar, 50 , love.graphics.getHeight() / 2.5)
			self.draw_rectangle()
			-- love.graphics.rectangle("line", 50 , love.graphics.getHeight() / 2.5, love.graphics.getWidth() - 100, love.graphics.getHeight() / 4)
			love.graphics.line(x_bar, y_bar_top, x_bar, y_bar_down)
			if (love.keyboard.isDown("z") or love.keyboard.isDown("w") or love.keyboard.isDown("space")) and x_bar > 70 then
				self:change_phase("dead_sonic")
			end
		end,

		fight_button_print = function(self, fight_frame)
			fight_frame = fight_frame or 1
			local fight_button = love.graphics.newImage("img/sprite/quad_fight.png")
			love.graphics.push()
			love.graphics.scale(0.4)
			love.graphics.draw(fight_button, Quads_fight[fight_frame], love.graphics.getWidth() / 2 + 240, love.graphics.getHeight() * 1.9)
			love.graphics.pop()
		end,

		ft_atk = function(self, fight_frame)
			love.graphics.rectangle("line", 50 , love.graphics.getHeight() / 2.5, love.graphics.getWidth() - 100, love.graphics.getHeight() / 3)
			if ((love.keyboard.isDown("z") or love.keyboard.isDown("w") or love.keyboard.isDown("space")) and fight_frame == 2)  then
				self:change_phase("atk_phase")
			end
		end,
		fight_scenario = function(self, timer_fight)
			timer_fight = timer_fight or 1
			if timer_fight < 2 then
				self:sonic_bubble("gl bg")
			elseif timer_fight >= 2 and timer_fight < 10 then
				-- self:atk_one()
			end
		end
	}
end

return Fight_mod