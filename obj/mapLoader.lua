local class = require "lib.middleclass"
local bump = require "lib.bump"
local ldtk = require "lib.ldtk"

local Entity = require "obj.scollider"
local Actor = require "obj.actor"
local Player = require "obj.player"
local SCollider = require "obj.scollider"

local MapLoader = class("mapLoader")

function MapLoader:initialize()
    self.world = bump.newWorld() -- Colliding entities
    self.entities = {} -- All entities

    print("MapLoader initialized.")
    print(self.entities)
    print("---")
end

function MapLoader:load(map)
    ldtk:load("ldtk/levels/" .. map .. ".ldtk")
    ldtk:setFlipped(false)

    function ldtk.entity(entity)
        -- TODO: use a switch or separate class
        if entity.identifier == "Collider" then
            SCollider:new(entity, self.world, self.entities)
        else if entity.identifier == "Player_Spawn" then
                Player:new(entity, self.world, self.entities)
            else
                Entity:new(entity, self.world, self.entities)
            end
        end
    end

    function ldtk.layer(layer)
        table.insert(self.entities, layer)
    end

    function ldtk.onLevelLoad(levelData)
        ldtk.removeCache()

        self.entities = {}
        self.world = bump.newWorld()
        love.graphics.setBackgroundColor(levelData.bgColor)
    end

    function ldtk.onLevelCreated(levelData)
    end

    ldtk:goTo(1)
end

function MapLoader:keypressed(key, isRepeat)
    for i = 1, #self.entities do
        if self.entities[i].keyEvents then
            self.entities[i]:keypressed(key, isRepeat)
        end
    end
end

function MapLoader:update(dt)
    -- If there are X more entities than colliders,
    -- check if there are entities marked for removal
    if #self.entities > (self.world:countItems() + 20) then
        for i = 1, #self.entities do
            if self.entities[i].destroyed then
                table.remove(self.entities, i)
            end
        end
    end

    -- Then update the entities
    for i = 1, #self.entities do
        if self.entities[i].order == nil then -- Check if not a layer
            self.entities[i]:update(dt)
        end
    end
end

function MapLoader:draw()
    local len = #self.entities

    for i = 1, len, 1 do
        self.entities[i]:draw() -- Draw every object in order
    end
end

return MapLoader
