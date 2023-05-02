local love = require "love"

function Button(text, func, x, y, color_r, color_g, color_b)
	return {
		color_r = color_r or 1,
		color_g = color_g or 1,
		color_b = color_b or 1,
		text = text or "No text",
		func = func or function() print("This button has no func") end,
		x = x or 0,
		y = y or 0,

		launch_button = function(self)
				self.func()
			end,
		
		change_color = function (self, _color_r, _color_g, _color_b)
			self.color_r = _color_r
			self.color_g = _color_g
			self.color_b = _color_b
		end,

		draw = function (self)
			love.graphics.setColor(self.color_r, self.color_g, self.color_b)
			local font = love.graphics.newFont(18)
			love.graphics.setFont(font)
			love.graphics.print(self.text, self.x, self.y)
		end
	}
end

return Button