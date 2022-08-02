local class = require "lib.middleclass"

-- Generic class for LDtk entities. Can collide
local Entity = class("Entity")

function Entity:initialize(entity, world, entitiesTable)
    self.world = world
    self.entitiesTable = entitiesTable
    self.x, self.y = entity.x, entity.y
    self.w, self.h = entity.width, entity.height
    self.visible = entity.visible

    print("Initializing entity...")
    print(self.entitiesTable)

    table.insert(self.entitiesTable, self)
    self.world:add(self, self.x, self.y, self.w, self.h)

    print("... entity initialized.\n---")
end

function Entity:destroy()
    -- makes the entity suitable for removal by the MapLoader
    self.destroyed = true

    self.world:remove(self)
end

function Entity:update()
end

function Entity:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Entity