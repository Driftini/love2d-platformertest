local mapLoader = require "obj.MapLoader"

function love.load()
    --player = Player:new(world, 100, 100)

    -- Graphics configuration
    love.window.setMode(1280, 720)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    mapLoader:load("debug")
end

function love.keypressed(key, scancode, isRepeat)
    --player:keypressed(key, isRepeat)
end

function love.update(dt)
    --player:update(dt)
end

function love.draw()
    love.graphics.scale(2, 2)

    mapLoader:draw()

    love.graphics.scale(0.5, 0.5)

    local sizeX, sizeY = love.graphics.getDimensions()
    love.graphics.print("FPS: " .. love.timer.getFPS(), 4, 4)
    love.graphics.print(sizeX .. "x" .. sizeY, 4, 16)
    --drawBlocks()
    --player:draw()

    
end