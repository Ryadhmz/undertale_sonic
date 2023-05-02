local love = require "love"
local button = require "Button"
-- local opening = require "Opening"

local game = {
	state = {
		opening = true,
		menu = false,
		running = false,
		ended = false,
	},
}

local buttons = {
	id_button = 0, -- 0 : play, 1 : exit --
	menu_state = {}
}

local opening_i = 0

local function changeGameState(state)
	game.state["opening"] = state == "opening"
	game.state["menu"] = state == "menu"
	game.state["running"] = state == "running"
	game.state["ended"] = state == "ended"
end

local function opening()
	local opening_img = love.graphics.newImage("img/opening/undertale_opening.png")
	Sounds.zehaha:play()
	love.graphics.push()
	love.graphics.scale(0.6)
	love.graphics.draw(opening_img, 20, -220)
	love.graphics.pop()
end

local function startNewGame()
	changeGameState("running")
end

local function printmenu()
	love.graphics.setColor(128 / 225, 128 / 225, 128 / 225) -- gris -- 
		love.graphics.print("Follow me on Github : Ryadhmz", 175, love.graphics.getHeight() - 30)
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

local function animMenu()
	Sounds.rain:play()
	if love.keyboard.isDown("right") then
		buttons.menu_state.exit:change_color(1, 1, 0) -- yellow --
		buttons.menu_state.start_game:change_color(1, 1, 1) -- white --
		if buttons.id_button == 0 then
			buttons.id_button = 1
		end
	elseif love.keyboard.isDown("left") then
		buttons.menu_state.exit:change_color(1, 1, 1)
		buttons.menu_state.start_game:change_color(1, 1, 0)
		if buttons.id_button == 1 then
			buttons.id_button = 0
		end
	elseif love.keyboard.isDown("w") or love.keyboard.isDown("z") or love.keyboard.isDown("space") then
		Sounds.rain:stop()
		if buttons.id_button == 0 then
			buttons.menu_state.start_game:launch_button()
		else
			buttons.menu_state.exit:launch_button()
	end
end
end

function love.load()
	Sounds = {}
	Sounds.zehaha = love.audio.newSource("sounds/zehaha.mp3", "static")
	Sounds.rain = love.audio.newSource("sounds/rain.mp3", "stream")
	love.graphics.setBackgroundColor(0, 0, 0) -- bg noir --
	Egmann_ruine = love.graphics.newImage("img/menu/egmann_ruine.png")
	Ruine = love.graphics.newImage("img/menu/porte_ruine.png")
	buttons.menu_state.start_game = button("Play", startNewGame, 160, love.graphics.getHeight() / 2, 1, 1, 0)
	buttons.menu_state.exit = button("Exit", love.event.quit, love.graphics.getWidth() - 200, love.graphics.getHeight() / 2)
end

function love.update(dt)
	if game.state["opening"] == true then 
		opening_i = opening_i + dt
		if opening_i >= 4.7 then
			Sounds.zehaha:stop()
			changeGameState("menu")
		end
	end
	if game.state["menu"] == true then
		animMenu()
	end
end

function love.draw()
	if game.state.menu == true then
		printmenu()
	end
	if game.state.opening == true then
		opening()
	end
end