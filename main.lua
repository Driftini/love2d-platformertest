local class = require "lib.middleclass"
local bump = require "lib.bump"

local Player = require "obj.player"

local world = bump.newWorld()
local blocks = {}

local function addBlock(x,y,w,h)
    local block = {x=x,y=y,w=w,h=h}
    blocks[#blocks+1] = block
    world:add(block, x,y,w,h)
end

local function drawBlocks()
    for _,block in ipairs(blocks) do
        love.graphics.rectangle("fill", block.x, block.y, block.w, block.h)
    end
end

function love.load()
    player = Player:new(world, 100, 100)

    addBlock(50, 400, 700, 16)

    addBlock(50, 300, 128, 16)
    addBlock(630, 300, 128, 16)

    addBlock(622, 200, 32, 16)
    addBlock(720, 150, 32, 16)

    addBlock(200, 100, 328, 16)
    addBlock(200, 40, 228, 16)
    addBlock(200, 40, 16, 64)

    addBlock(260, 250, 256, 16)

end

function love.keypressed(key, scancode, isRepeat)
    player:keypressed(key, isRepeat)
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    love.graphics.print("FPS: " .. love.timer.getFPS(), 4, 4)
    drawBlocks()
    player:draw()

    local sizeX, sizeY = love.graphics.getDimensions()
    love.graphics.print(sizeX .. "x" .. sizeY, 4, 16)
end