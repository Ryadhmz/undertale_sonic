local love = require "love"
local button = require "Button"

local game = {
	state = {
		menu = true,
		running = false,
		ended = false,
	}
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

function love.load()
	love.graphics.setBackgroundColor(0, 0, 0) -- bg noir --
	buttons.menu_state.start_game = button("Play", startNewGame, 50, 50)
	buttons.menu_state.exit = button("Exit", love.event.quit, 50, 50)

end

function love.update(dt)

end

function love.draw()

end