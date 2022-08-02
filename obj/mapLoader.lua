local class = require "lib.middleclass"
local bump = require "lib.bump"
local ldtk = require "lib.ldtk"

local Entity = require "obj.scollider"
local Actor = require "obj.actor"
local Player = require "obj.player"
local SCollider = require "obj.scollider"

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
local entities = {}

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
            local newCollider = SCollider:new(entity, world)
            table.insert(entities, newCollider)
        else if entity.identifier == "Player_Spawn" then
                local newPlayer = Player:new(entity, world)
                table.insert(entities, newPlayer)
            else
                local newEntity = Entity:new(entity, world)
                table.insert(entities, newEntity)
            end

            function ldtk.layer(layer)
                table.insert(entities, layer)
            end

            function ldtk.onLevelLoad(levelData)
                ldtk.removeCache()

                entities = {}
                world = bump.newWorld()
                love.graphics.setBackgroundColor(levelData.bgColor)
            end

            function ldtk.onLevelCreated(levelData)
            end
        end
    end

    ldtk:goTo(1)
end

function MapLoader:keypressed(key, isRepeat)
    local len = #entities

    for i = 1, len do
        if entities[i].keyEvents then
            entities[i]:keypressed(key, isRepeat)
        end
    end
end

function MapLoader:update(dt)
    local len = #entities

    for i = 1, len do
        if entities[i].order == nil then -- check if not a layer
            entities[i]:update(dt)
        end
    end
end

function MapLoader:draw()
    local len = #entities

    for i = 1, len, 1 do
        entities[i]:draw() -- drawing every object in order
    end
end

return MapLoader
