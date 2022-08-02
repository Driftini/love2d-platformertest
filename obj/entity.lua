local class = require "lib.middleclass"

-- Generic class for LDtk entities. Can collide
local Entity = class("Entity")

function Entity:initialize(entity, world)
    self.world = world
    self.x, self.y = entity.x, entity.y
    self.w, self.h = entity.width, entity.height
    self.visible = entity.visible

    self.world:add(self, self.x, self.y, self.w, self.h)
end

function Entity:destroy()
    self.world:remove(self)
end

function Entity:update()
end

function Entity:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Entity