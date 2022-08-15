local class = require "lib.middleclass"

local Entity = require "obj.entity"

-- boilerplate for other entities ig
local PlayerSpawnpoint = class("PlayerSpawnPoint", Entity)

function PlayerSpawnpoint:initialize(entity, world, entitiesTable)
    Entity.initialize(self, entity, world, entitiesTable)
    self.spawnID = entity.props.SpawnID
end

function PlayerSpawnpoint:update()
    Entity.destroy(self)
end

return PlayerSpawnpoint