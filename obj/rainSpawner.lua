local class = require "lib.middleclass"

local Entity = require "obj.entity"
local Raindrop = require "obj.raindrop"

-- Spawns rain
local RainSpawner = class("CloudSpawner", Entity)

function RainSpawner:initialize(entity, world, entitiesTable)
	Entity.initialize(self, entity, world, entitiesTable)
	self.visible = false

	self.rainDirection = entity.props.Direction
	self.spawnDelay = entity.props.SpawnDelay -- Delay between raindrop spawns, spawnCountdown gets reset to this
	self.rainCount = entity.props.Count -- Raindrops spawned every time spawnCountdown hits zero

	self.spawnCountdown = nil -- Milliseconds until next group of raindrops is spawned
end

function RainSpawner:spawnRain()
	local raindropEntity = BlankEntity()

	raindropEntity.x, raindropEntity.y = math.random(self.x, self.x + self.w), math.random(self.y, self.y + self.h)
	raindropEntity.props.Direction = self.rainDirection

	Raindrop:new(raindropEntity, self.world, self.entitiesTable)
end

function RainSpawner:update(dt)
	if self.spawnCountdown == nil then
		self.spawnCountdown = self.spawnDelay
	else
		self.spawnCountdown = self.spawnCountdown - (dt * 1000)

		if self.spawnCountdown <= 0 then
			self.spawnCountdown = self.spawnDelay
			for i = 1, self.rainCount do
				self:spawnRain()
			end
		end
	end
end

return RainSpawner