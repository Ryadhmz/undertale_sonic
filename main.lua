---@diagnostic disable: undefined-global, lowercase-global
local love = require "love"
local button = require "Button"
local Fight_mod = require "Fight"
local Enemy_Circle = require "Enemy_Circle"


math.randomseed(os.time())

local frame_second = 1 / 60

local accumulator = 0.0

local game = {
	state = {
		opening = true,
		menu = false,
		running = false,
		ended = false,
		game_over = false
	},
	phase = {
		defense = false,
		atk = false,
		atk_phase = false,
		dead_sonic = false,
		nb_phase = 0,
	}
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

local i_frame = 2

local fight = {}

local enemies = {
	Enemy_Circle(1, 250, 250),
	Enemy_Circle(1, 450, 350)
}

Quads = {}

Quads_fight = {}

local opening_i = 0

local x_bar = 60

rectangle_x_limit = 600

local timer_damage = 0

timer_fight = 0

local function changeGameState(state)
	game.state["opening"] = state == "opening"
	game.state["menu"] = state == "menu"
	game.state["running"] = state == "running"
	game.state["ended"] = state == "ended"
	game.state["game_over"] = state == "game_over"
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
	fight.go:change_phase("defense")
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
		love.graphics.setColor(1, 1, 1)
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
	for i = 1, 2 do
		Quads_fight[i] = love.graphics.newQuad(924 / 2 * (i - 1), 0, 924 / 2, 177, 924, 177)
	end
	fight.go = Fight_mod(sonic, game)
	local fight_frame = 2
	i_frame = 2
end

function love.update(dt)
	accumulator = dt
	if game.state["opening"] == true then 
		opening_i = opening_i + accumulator
		if opening_i >= 4.7 then
			Sounds.zehaha:stop()
			changeGameState("menu")
		end
	end
	if game.state["menu"] == true then
		animMenu()
	end
	if game.phase.defense == true then
		fight_frame = 1
	elseif game.phase.atk == true or game.phase.atk_phase == true  then
		fight_frame = 2
	end
	if game.phase.atk_phase == true then
		x_bar = x_bar + accumulator * 140
	end
	if game.phase.dead_sonic == true then
		timer_damage = timer_damage + accumulator
	end
	if game.phase.defense == true then
		timer_fight = timer_fight + accumulator
	else
		timer_fight = 0
	end
	if game.state.running == true then
		if game.phase.dead_sonic == true then
			i_frame = 2
		else
			if math.abs(i_frame) < 7 then
				i_frame = i_frame + accumulator / 2.5
			else
				i_frame = 2
		end
	end
		if game.phase.nb_phase == 1 then
			for i = 1, #enemies do
				if enemies[i].checkCircleTouched(fight.go, enemies[i].x, enemies[i].y, enemies[i].radius) == false then
					enemies[i]:move(fight.go.x_egg, fight.go.y_egg)
				else
					changeGameState("game_over")
				end
			end
		end
	end
	if game.state.game_over == true then
		if love.keyboard.isDown("w") or love.keyboard.isDown("z") or love.keyboard.isDown("space") then
			love.event.quit()
		end
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
		local hp = love.graphics.newImage("img/sprite/hp_1.1.png")
		love.graphics.push()
		love.graphics.scale(1.5)
		love.graphics.draw(hp, 285 , love.graphics.getHeight() / 2.4)
		love.graphics.pop()
		fight.go:sonic_print(i_frame)
		fight.go:fight_button_print(fight_frame)
		if game.phase.nb_phase == 1 then
			for i = 1, #enemies do
				enemies[i]:draw()
			end
		end

		if game.phase.atk == true then
			fight.go:ft_atk(fight_frame)
		end
		if game.phase.atk_phase == true then
			fight.go:ft_atk_phase(x_bar)
			if x_bar > rectangle_x_limit then
				fight.go:change_phase("defense")
				x_bar = 50
			end
		end
		if game.phase.defense == true then
			fight.go:draw_rectangle_defense()
			fight.go:fight_scenario(timer_fight)
		end
		if game.phase.dead_sonic == true then
			fight.go:damage(timer_damage)
			if timer_damage > 3 then
				changeGameState("ended")
			end
		end
	end
	if game.state.ended == true then
		local end_image = love.graphics.newImage("img/end.jpg")
			love.graphics.draw(end_image, 80, -40)
			if timer_damage > 7 then
				love.event.quit()
			end
	end
	if game.state.game_over == true then
		local game_over_image = love.graphics.newImage("img/game_over.png")
		love.graphics.draw(game_over_image, 110, 140)
	end
end