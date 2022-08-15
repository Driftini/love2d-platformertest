local class = require "lib.middleclass"

local Entity = require "obj.entity"

-- Trigger to switch maps on player contact
local MapTrigger = class("MapTrigger", Entity)

function MapTrigger:initialize(entity, world, entitiesTable)
    Entity.initialize(self, entity, world, entitiesTable)

    self.destination = {
        map = entity.props.DestinationMap,
        spawnpoint = entity.props.DestinationSpawnpoint
    }
end

function MapTrigger:onCollide(col)
    if col.other.collisionGroups == "Player" then
        self.triggered = true
    end
end

return MapTrigger