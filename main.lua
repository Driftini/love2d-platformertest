local mapLoader = require "obj.MapLoader"

function love.load()
    print("Game started.")
    --player = Player:new(world, 100, 100)

    if arg[#arg] == "-debug" then require("mobdebug").start() end

    -- Graphics configuration
    love.window.setMode(1280, 720)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    mapLoader:new()

    mapLoader:load("debug")
end

function love.keypressed(key, scancode, isRepeat)
    mapLoader:keypressed(key, isRepeat)
end

function love.update(dt)
    -- lag simulation
    if love.keyboard.isDown("z") then
        dt = dt / 5
    end

    mapLoader:update(dt)
end

function love.draw()
    love.graphics.scale(2)

    mapLoader:draw()

    love.graphics.scale(0.5)

    local sizeX, sizeY = love.graphics.getDimensions()
    local debugHUD =
    "FPS: " .. love.timer.getFPS() .. "\n" ..
    "Resolution:" .. sizeX .. "x" .. sizeY .. "\n" ..
    "Colliding entity count: " .. mapLoader.world:countItems() .. "\n" ..
    "Entity count: " .. #mapLoader.entities

    love.graphics.print(debugHUD, 4, 4)
end