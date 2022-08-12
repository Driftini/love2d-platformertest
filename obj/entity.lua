local class = require "lib.middleclass"

-- Generic class for LDtk entities. Can collide
local Entity = class("Entity")

function Entity:initialize(entity, world, entitiesTable)
    self.world = world
    self.entitiesTable = entitiesTable

    self.x, self.y = entity.x, entity.y
    self.w, self.h = entity.width, entity.height
    self.visible = entity.visible
    self.order = entity.order -- rendering order

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
    self.destroyed = true -- makes the entity suitable for removal by the MapLoader
end

function Entity:update(dt)
    if not self.destroyed then
        if self.currentAnim then
            self.currentAnim:update(dt)
        end
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