local class = require "lib.middleclass"
local bump = require "lib.bump"
local ldtk = require "lib.ldtk"

local Entity = require "obj.scollider"
local Actor = require "obj.actor"
local Player = require "obj.player"
local SCollider = require "obj.scollider"
local CloudSpawner = require "obj.cloudSpawner"
local RainSpawner = require "obj.rainSpawner"

local MapLoader = class("mapLoader")

function MapLoader:initialize()
    self.world = bump.newWorld() -- Colliding entities
    self.entities = {} -- All entities
    self.layers = {}
end

function MapLoader:load(map)
    local loadTime, finishTime

    ldtk:load("ldtk/levels/" .. map .. ".ldtk")
    ldtk:setFlipped(false)

    function ldtk.entity(entity)
        -- TODO: use a switch or separate class
        if entity.identifier == "SCollider" then
            SCollider:new(entity, self.world, self.entities)
        elseif entity.identifier == "Player" then
            Player:new(entity, self.world, self.entities)
        elseif entity.identifier == "CloudSpawner" then
            CloudSpawner:new(entity, self.world, self.entities)
        elseif entity.identifier == "RainSpawner" then
            RainSpawner:new(entity, self.world, self.entities)
        else
            Entity:new(entity, self.world, self.entities)
        end
    end

    function ldtk.layer(layer)
        table.insert(self.layers, layer)
    end

    function ldtk.onLevelLoad(levelData)
        print("[MAPLOADER] Loading map " .. levelData.identifier .. "...")
        loadTime = love.timer.getTime()

        ldtk.removeCache()

        self.entities = {}
        self.layers = {}
        self.world = bump.newWorld()
        love.graphics.setBackgroundColor(levelData.bgColor)
    end

    function ldtk.onLevelCreated(levelData)
        finishTime = love.timer.getTime()
        print("[MAPLOADER] Map " ..
            levelData.identifier .. " finished loading in " .. (finishTime - loadTime) * 1000 .. "ms.")
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
    local i = 1

    -- For loops won't work with a changing length
    while i <= #self.entities do
        if self.entities[i].destroyed then
            table.remove(self.entities, i)
        else
            self.entities[i]:update(dt)
        end

        i = i + 1
    end
end

function MapLoader:draw()
    table.sort(self.entities, function(a,b) return a.order < b.order end)
    table.sort(self.layers, function(a,b) return a.order < b.order end)

    for i = 1, #self.entities do
        self.entities[i]:draw()
    end

    for i = 1, #self.layers do
        self.layers[i]:draw()
    end
end

return MapLoader
