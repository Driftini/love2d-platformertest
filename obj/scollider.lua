local class = require "lib.middleclass"

local Entity = require "obj.entity"

-- Static collider.
local SCollider = class("SCollider", Entity)

function SCollider:initialize(entity, world)
    Entity.initialize(self, entity, world)
end

function SCollider:draw()
    --local r, g, b, a = love.graphics.getColor()
    --love.graphics.setColor(1, 0, 1, 1)
    --Entity.draw(self)
    --love.graphics.setColor(r, g, b, a)
end

return SCollider