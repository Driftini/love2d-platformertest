local class = require "lib.middleclass"
local utils = require "utils"

-- Generic class for LDtk entities. Can collide
local Entity = class("Entity")

function Entity:initialize(entity, world, entitiesTable)
	self.world = world
	self.entitiesTable = entitiesTable

	if not self.x and not self.y then
		self.x, self.y = entity.x, entity.y
	end

	if not self.w and not self.h then
		self.w, self.h = entity.width, entity.height
	end

	if not self.order then
		self.order = entity.order -- Rendering order
	end

	self.visible = entity.visible

	self.collisionGroups = {}

	self.spritesheet = nil
	self.animations = {}
	self.currentAnim = nil
	self.flipped = false

	self.destroyed = false

	table.insert(self.entitiesTable, self)

	self.world:add(self, self.x, self.y, self.w, self.h)
end

function Entity:destroy()
	self.world:remove(self)

	self.visible = false
	self.destroyed = true -- Makes the entity suitable for removal by the MapLoader
end

function Entity:filter(other)
	local cg = other.collisionGroups

	for i = 1, #cg do
		if      cg[i] == "Map"      then return "slide"
		elseif  cg[i] == "Particle" then return "cross"
		end
	end
end

function Entity:onCollide(col)
	-- Entities can define their own checks and logic
end

function Entity:check()
	local actualX, actualY, cols, len = self.world:check(self, self.x, self.y, self.filter)

	for i = 1, len do
		self:onCollide(cols[i])
	end
end

function Entity:update(dt)
	if self.grounded == nil then -- if not an actor
		self:check()
	end

	if self.currentAnim then
		self.currentAnim:update(dt)
	end
end

function Entity:draw()
	if self.visible then
		if self.currentAnim then
			if self.flipped then self.currentAnim:flipH() end
			self.currentAnim:draw(self.spritesheet, self.x, self.y)
			if self.flipped then self.currentAnim:flipH() end -- flip back to normal
		end

		--love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	end
end

return Entity