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

function MapTrigger:filter(other)
	local cg = other.collisionGroups

	for i = 1, #cg do
		if      cg[i] == "Player"      then return "cross"
		end
	end
end

function MapTrigger:onCollide(col)
	for i = 1, #col.other.collisionGroups do
		if col.other.collisionGroups[i] == "Player" then
			self.triggered = true
		end
	end
end

return MapTrigger