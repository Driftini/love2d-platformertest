local class = require "lib.middleclass"

local Entity = require "obj.entity"

local identifier = "Placeholder"

-- boilerplate for other entities ig
local Placeholder = class(identifier, Entity)

function Placeholder:initialize(entity, world, entitiesTable)
    Entity.initialize(self, entity, world, entitiesTable)
    self.identifier = identifier
    table.insert(self.collisionGroups, "Placeholder")
end

return Placeholder