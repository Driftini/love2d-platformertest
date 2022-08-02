local class = require "lib.middleclass"

-- Generic class for LDtk entities. Can collide
local Entity = class("Entity")

function Entity:initialize(entity, world, entitiesTable)
    self.world = world
    self.entitiesTable = entitiesTable
    self.x, self.y = entity.x, entity.y
    self.w, self.h = entity.width, entity.height
    self.visible = entity.visible

    table.insert(self.entitiesTable, self)

    if not self.noCollisions then
        self.world:add(self, self.x, self.y, self.w, self.h)
    end
end

function Entity:destroy()
    -- makes the entity suitable for removal by the MapLoader
    self.destroyed = true

    if not self.noCollisions then
        self.world:remove(self)
    end
end

function Entity:update()
end

function Entity:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Entity