local class = require "lib.middleclass"

-- Generic class for LDtk entities. Can collide
local Entity = class("Entity")

function Entity:initialize(entity, world, entitiesTable, additionalCGroups)
    self.world = world
    self.entitiesTable = entitiesTable

    self.x, self.y = entity.x, entity.y
    self.w, self.h = entity.width, entity.height
    self.visible = entity.visible

    self.collisionGroups = {}

    self.spritesheet = nil
    self.animations = {}
    self.currentAnim = nil

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
        if self.currentAnim then
            self.currentAnim:draw(self.spritesheet, self.x, self.y)
        end

        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    end
end

return Entity