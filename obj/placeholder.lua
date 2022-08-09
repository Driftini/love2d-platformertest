local class = require "lib.middleclass"
local anim8 = require "lib.anim8"

local Entity = require "obj.entity"

-- boilerplate for other entities ig
local Placeholder = class("Placeholder", Entity)

function Placeholder:initialize(entity, world, entitiesTable)
    Entity.initialize(self, entity, world, entitiesTable)
    table.insert(self.collisionGroups, "Placeholder")
end

return Placeholder