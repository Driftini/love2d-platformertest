local class = require "lib.middleclass"

local Entity = require "obj.entity"

-- Static collider.
local SCollider = class("SCollider", Entity)

function SCollider:initialize(entity, world, entitiesTable)
	Entity.initialize(self, entity, world, entitiesTable)
	self.visible = false
	table.insert(self.collisionGroups, "Map")
end

function SCollider:update()
	-- skip normal entity update method
end

function SCollider:draw()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(0.8, 0.5, 0.8, 1)
	Entity.draw(self)
	love.graphics.setColor(r, g, b, a)
end

return SCollider