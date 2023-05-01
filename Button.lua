local love = require "love"

function Button(text, func, x, y)
	return {
		text = text or "No text",
		func = func or function() print("This button has no func") end,
		x = 0,
		y = 0,

		launch_button = function (self)
				self.func()
			end,

		draw = function (self, color_r, color_g, color_b)
			love.graphics.setColor(color_r, color_g, color_b)
			love.graphics.print(self.text, self.x, self.y)
			love.graphics.setColor(0, 0, 0)
		end
	}
end

return Button