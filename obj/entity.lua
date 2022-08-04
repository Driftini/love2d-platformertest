local class = require "lib.middleclass"

local identifier = "Entity"

-- Generic class for LDtk entities. Can collide
local Entity = class(identifier)

function Entity:initialize(entity, world, entitiesTable)
    self.identifier = identifier

    self.world = world
    self.entitiesTable = entitiesTable
    self.x, self.y = entity.x, entity.y
    self.w, self.h = entity.width, entity.height
    self.visible = entity.visible

    self.destroyed = false

    table.insert(self.entitiesTable, self)

    if not self.noCollisions then
        self.world:add(self, self.x, self.y, self.w, self.h)
    end
end

function Entity:destroy()
    if not self.noCollisions then
        self.world:remove(self)
    end

    self.visible = false
    -- makes the entity suitable for removal by the MapLoader
    self.destroyed = true
end

function Entity:update()
end

function Entity:draw()
    if self.visible then
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    end
end

return Entity