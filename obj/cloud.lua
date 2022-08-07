local class = require "lib.middleclass"

local Actor = require "obj.actor"

local identifier = "Cloud"

-- boilerplate for other entities ig
local Cloud = class(identifier, Actor)

function Cloud:initialize(entity, world, entitiesTable)
    Actor.initialize(self, entity, world, entitiesTable)
    self.identifier = identifier

    self.fallSpeed = 0
    self.friction = 1

    self.vx = entity.props.Speed

    if entity.props.Direction == "Left" then
        self.vx = self.vx * -1 -- Invert direction
    end
end

function Cloud:filter(other) -- override default collision filter
    return "cross"
end

function Cloud:draw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0.5, 0.8, 0.8, 1)
    Actor.draw(self)
    love.graphics.setColor(r, g, b, a)
end

return Cloud