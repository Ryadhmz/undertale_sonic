local love = require "love"
local button = require "Button"

local game = {
	state = {
		menu = true,
		running = false,
		ended = false,	
	},
}

local buttons = {
	id_button = 0, -- 0 : play, 1 : exit --
	menu_state = {}
}

local function changeGameState(state)
	game.state["menu"] = state == "menu"
	game.state["running"] = state == "running"
	game.state["ended"] = state == "ended"
end

local function startNewGame()
	changeGameState("running")
end

local function printmenu()
	love.graphics.setColor(128 / 225, 128 / 225, 128 / 225) -- gris -- 
		love.graphics.print("Follow me on Github : ryadhmz", 175, love.graphics.getHeight() - 30)
		love.graphics.setColor(1, 1, 1)
		love.graphics.push()
		love.graphics.scale(1.25, 1.25)
		love.graphics.draw(Egmann_ruine, 175, 50)
		love.graphics.pop()
		love.graphics.push()
		love.graphics.scale(2)
		love.graphics.draw(Ruine, 82, -125)
		love.graphics.pop()
		buttons.menu_state.start_game:draw()
		buttons.menu_state.exit:draw()
		love.graphics.setColor(240 / 255, 128 / 255, 128 / 255)
		love.graphics.print("Dr.Robotnik", 265, love.graphics.getHeight() / 2 - 50)
end

function love.load()
	love.graphics.setBackgroundColor(0, 0, 0) -- bg noir --
	Egmann_ruine = love.graphics.newImage("img/egmann_ruine.png")
	Ruine = love.graphics.newImage("img/porte_ruine.png")
	buttons.menu_state.start_game = button("Play", startNewGame, 160, love.graphics.getHeight() / 2)
	buttons.menu_state.exit = button("Exit", love.event.quit, love.graphics.getWidth() - 200, love.graphics.getHeight() / 2)

end

function love.update(dt)
	if game.state["menu"] == true then
		if love.keyboard.isDown("right") then
			buttons.menu_state.exit:change_color(1, 1, 0) -- yellow --
			buttons.menu_state.start_game:change_color(1, 1, 1) -- white --
		elseif love.keyboard.isDown("left") then
			buttons.menu_state.exit:change_color(1, 1, 1)
			buttons.menu_state.start_game:change_color(1, 1, 0)
		end
	end
end

function love.draw()
	if game.state.menu == true then
		printmenu()
	end
end