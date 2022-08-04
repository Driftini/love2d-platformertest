local class = require "lib.middleclass"

local Entity = require "obj.Entity"

local identifier = "Placeholder"

-- boilerplate for other entities ig
local Placeholder = class(identifier, Entity)

function Placeholder:initialize(entity, world, entitiesTable)
    self.noCollisions = true
    Entity.initialize(self, entity, world, entitiesTable)
    self.identifier = identifier

    self.deathCountdown = 3
end

function Placeholder:update(dt)
    self.deathCountdown = self.deathCountdown - dt

    if self.deathCountdown <= 0 then
        Entity.destroy(self)
    end
end

return Placeholder