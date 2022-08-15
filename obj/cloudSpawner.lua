local class = require "lib.middleclass"

local Entity = require "obj.entity"
local Cloud = require "obj.cloud"

-- Spawn clouds
local CloudSpawner = class("CloudSpawner", Entity)

function CloudSpawner:initialize(entity, world, entitiesTable)
    Entity.initialize(self, entity, world, entitiesTable)
    self.visible = false

    self.cloudDirection = entity.props.Direction
    self.cloudVariant = entity.props.Variant
    self.cloudSpeed = entity.props.Speed
    self.spawnDelay = entity.props.SpawnDelay -- Delay between cloud spawns, nextSpawn gets reset to this

    self.spawnCountdown = nil -- Seconds until next cloud is spawned
end

function CloudSpawner:spawnCloud()
    local cloudEntity = BlankEntity()

    cloudEntity.x, cloudEntity.y = self.x, self.y
    cloudEntity.props = {
        Direction = self.cloudDirection,
        Variant = self.cloudVariant,
        Speed = self.cloudSpeed
    }

    Cloud:new(cloudEntity, self.world, self.entitiesTable)
end

function CloudSpawner:update(dt)
    if self.spawnCountdown == nil then
        self.spawnCountdown = self.spawnDelay
    else
        self.spawnCountdown = self.spawnCountdown - dt

        if self.spawnCountdown <= 0 then
            self.spawnCountdown = self.spawnDelay
            self:spawnCloud()
        end
    end
end

return CloudSpawner