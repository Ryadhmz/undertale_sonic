---@diagnostic disable: undefined-global
local love = require "love"
local button = require "Button"

local game = {
	state = {
		opening = false,
		menu = false,
		running = true,
		ended = false,
	},
}

local buttons = {
	id_button = 0, -- 0 : play, 1 : exit --
	menu_state = {}
}

local sonic = {
	x = love.graphics.getWidth() / 2 - 30,
	y = 100,
	sprite = {
		img_sprite = love.graphics.newImage("img/sprite/sonic_sprite.png"),
		SPRITE_WIDTH = 280,
		SPRITE_HEIGHT = 90,
		QUAD_WIDTH = 280 / 7,
		QUAD_HEIGHT = 90,
		bubble_sprite = love.graphics.newImage("img/sprite/bubble.png")
	},
	animation = {
		idle = true,
		frame = 1,
		max_frames = 7,
		speed = 30,
		timer = 0,1
	}
}

local fight_buttons = {
	sprite = love.graphics.newImage("img/sprite/fight_button.png")
}

Quads = {}

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
		love.graphics.setColor(1, 0, 0)
		love.graphics.print("Dr.Eggman", 265, love.graphics.getHeight() / 2 - 50)
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

	-- running --
	for i = 1, 7 do
		Quads[i] = love.graphics.newQuad(sonic.sprite.QUAD_WIDTH * (i - 1), 0, sonic.sprite.QUAD_WIDTH, sonic.sprite.QUAD_HEIGHT, sonic.sprite.SPRITE_WIDTH, sonic.sprite.SPRITE_HEIGHT)
	end
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
	if game.state.running == true then
		love.graphics.draw(sonic.sprite.img_sprite, Quads[1], sonic.x, sonic.y)
		love.graphics.rectangle("line", 50 , love.graphics.getHeight() / 2.5, love.graphics.getWidth() - 100, love.graphics.getHeight() / 2.5) -- atk --
		love.graphics.rectangle("line", 240 , love.graphics.getHeight() / 2.25, love.graphics.getWidth() - 500, love.graphics.getHeight() / 3) -- defense --
		love.graphics.push()
		love.graphics.scale(0.3)
		love.graphics.draw(fight_buttons.sprite, love.graphics.getWidth() / 2 + 420, love.graphics.getHeight() * 2.4)
		love.graphics.pop()
		love.graphics.push()
		love.graphics.scale(0.2)
		love.graphics.draw(sonic.sprite.bubble_sprite, sonic.x + 1500, sonic.y + 300)
		love.graphics.pop()
	end
end