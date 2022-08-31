require "lib.tesound"
local MapLoader = require "obj.mapLoader"

local ml

G_CANVAS = love.graphics.newCanvas(640, 360)

-- Need to add gamestates

function love.load()
	print("Game started.")
	--player = Player:new(world, 100, 100)

	if arg[#arg] == "-debug" then require("mobdebug").start() end

	-- Graphics configuration
	love.window.setMode(1280, 720)
	love.graphics.setDefaultFilter('nearest', 'nearest')
	G_CANVAS:setFilter('nearest', 'nearest')
	love.graphics.setLineStyle('rough')

	ml = MapLoader:new()

	ml:loadProject("debug")
	ml:loadLevel("Level_Landing", "Center")
end

function love.keypressed(key, scancode, isRepeat)
	ml:keypressed(key)
end

function love.update(dt)
	TEsound.cleanup()

	-- For delta time-related debugging
	if love.keyboard.isDown("z") then
		dt = dt / 5
	end

	ml:update(dt)
end

function love.draw()
	-- draw to canvas
	love.graphics.setCanvas(G_CANVAS)
	love.graphics.clear()

	ml:draw()

	-- bring back normal graphics and draw THE canvas
	love.graphics.setCanvas()

	love.graphics.scale(3)

	love.graphics.draw(G_CANVAS)

	love.graphics.scale(0.3)

	local sizeX, sizeY = love.graphics.getDimensions()
	local debugHUD =
	"FPS: " .. love.timer.getFPS() .. "\n" ..
	"Resolution:" .. sizeX .. "x" .. sizeY .. "\n" ..
	"Entity count: " .. #ml.entities

	love.graphics.print(debugHUD, 4, 4)
end