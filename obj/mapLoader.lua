local class = require "lib.middleclass"
local bump = require "lib.bump"
local ldtk = require "lib.ldtk"

local Actor = require "obj.actor"
local Player = require "obj.player"

local MapLoader = class("mapLoader")

function MapLoader:initialize()
    self.world = {} -- bump world
    self.tiles = {} -- static colliders

    self.objects = {} -- objects
end

-- Colliding objects
local world = bump.newWorld()
local blocks = {}

-- All objects
local objects = {}

-- object class
local object = class("object")

function object:initialize(e)
    self.x, self.y = e.x, e.y
    self.w, self.h = e.width, e.height
    self.visible = e.visible
end

function object:draw()
    if self.visible then
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    end
end

local function addBlock(x, y, w, h)
    local block = { x = x, y = y, w = w, h = h }
    blocks[#blocks + 1] = block
    world:add(block, x, y, w, h)
end

local function drawBlocks()
    for _, block in ipairs(blocks) do
        love.graphics.rectangle("fill", block.x, block.y, block.w, block.h)
    end
end

function MapLoader:load(map)
    ldtk:load("ldtk/levels/" .. map .. ".ldtk")
    ldtk:setFlipped(false)

    function ldtk.entity(entity)
        -- placeholder
        if entity.identifier == "Collider" then
            local newCollider = object:new(entity)
            table.insert(objects, newCollider)

            addBlock(entity.x, entity.y, entity.width, entity.height)
        else if entity.identifier == "Player_Spawn" then
                local newEntity = object:new(entity)
                table.insert(objects, newEntity)
            else
                local newEntity = object:new(entity)
                table.insert(objects, newEntity)
            end

            function ldtk.layer(layer)
                table.insert(objects, layer)
            end

            function ldtk.onLevelLoad(levelData)
                ldtk.removeCache()

                objects = {}
                love.graphics.setBackgroundColor(levelData.bgColor)
            end

            function ldtk.onLevelCreated(levelData)
            end
        end
    end

    ldtk:goTo(1)
end

function MapLoader:draw()
    local len = #objects

    for i = 1, len, 1 do
        objects[i]:draw() --drawing every object in order
    end
end

return MapLoader
