local class = require "lib.middleclass"
local anim8 = require "lib.anim8"

local Entity = require "obj.entity"

-- boilerplate for other entities ig
local Placeholder = class("Placeholder", Entity)

function Placeholder:initialize(entity, world, entitiesTable)
    Entity.initialize(self, entity, world, entitiesTable)
    table.insert(self.collisionGroups, "Placeholder")

    --self.spritesheet = love.graphics.newImage("assets/placeholder.png")
    --local grid = anim8.newGrid(32, 32, self.spritesheet:getWidth(), self.spritesheet:getHeight(), 2, 2, 0)
end

return Placeholder