local love = require "love"

function Opening()
	return {
	draw = function()
		local opening_img = love.graphics.newImage("img/opening/undertale_opening.png")
		Sounds.zehaha:play()
		love.graphics.draw(opening_img, 0, 0)
		for i in 10000 do
		print("")
		end
		Sounds.zehaha:stop()
	end
}
end

return Opening