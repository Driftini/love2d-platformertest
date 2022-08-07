local class = require "lib.middleclass"

local identifier = "Entity"

-- Generic class for LDtk entities. Can collide
local Entity = class(identifier)

function Entity:initialize(entity, world, entitiesTable, additionalCGroups)
    self.identifier = identifier

    self.world = world
    self.entitiesTable = entitiesTable

    self.x, self.y = entity.x, entity.y
    self.w, self.h = entity.width, entity.height
    self.visible = entity.visible

    self.collisionGroups = {}

    self.destroyed = false

    table.insert(self.entitiesTable, self)

    self.world:add(self, self.x, self.y, self.w, self.h)
end

function Entity:destroy()
    self.world:remove(self)

    self.visible = false
    self.destroyed = true -- makes the entity suitable for removal by the MapLoader
end

function Entity:update()
end

function Entity:draw()
    if self.visible then
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    end
end

return Entity