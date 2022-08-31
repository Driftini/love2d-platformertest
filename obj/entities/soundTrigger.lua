local class = require "lib.middleclass"

local Entity = require "obj.entities.entity"

-- Trigger to play debug sounds
local SoundTrigger = class("SoundTrigger", Entity)

function SoundTrigger:initialize(entity, world, entitiesTable)
	Entity.initialize(self, entity, world, entitiesTable)

    self.soundList = {
        "res/sounds/rnd1.wav",
        "res/sounds/rnd2.wav",
        "res/sounds/rnd3.wav",
        "res/sounds/rnd4.wav",
        "res/sounds/rnd5.wav",
        "res/sounds/rnd6.wav",
    }

    self.wasTriggered = false
    self.sound = entity.props.Sound
end

function SoundTrigger:filter(other)
	local cg = other.collisionGroups

	for i = 1, #cg do
		if      cg[i] == "Player"      then return "cross"
		end
	end
end

function SoundTrigger:onCollide(col)
	for i = 1, #col.other.collisionGroups do
		if col.other.collisionGroups[i] == "Player" then
			self.triggered = true
		end
	end
end

function SoundTrigger:update(dt)
    self.wasTriggered = self.triggered
    self.triggered = false

    Entity.update(self, dt)

    if self.triggered and not self.wasTriggered then
        TEsound.play(self.soundList, "static")
    end
end

function SoundTrigger:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.print("Sound\ntrigger", self.x + 3, self.y, 0)
end

return SoundTrigger