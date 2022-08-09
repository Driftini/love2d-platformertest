local class = require "lib.middleclass"
local anim8 = require "lib.anim8"

local Actor = require "obj.actor"

-- boilerplate for other entities ig
local Cloud = class("Cloud", Actor)

function Cloud:initialize(entity, world, entitiesTable)
    Actor.initialize(self, entity, world, entitiesTable)
    self.spritesheet = love.graphics.newImage("assets/cloud.png")

    self.fallSpeed = 0
    self.friction = 1

    self.vx = entity.props.Speed

    if entity.props.Direction == "Left" then
        self.vx = self.vx * -1 -- Invert direction
    end

    Cloud.chooseSprite(self)
end

function Cloud:chooseSprite()
    local rnd = math.random(1,3)

    local grid = anim8.newGrid(146, 60, self.spritesheet:getWidth(), self.spritesheet:getHeight(), 0, 0, 3)

    self.animations.spawn = anim8.newAnimation( grid(rnd, 1), 1, "pauseOnEnd")

    self.currentAnim = self.animations.spawn
end

function Cloud:filter() -- override default collision filter
    return "cross"
end

function Cloud:draw()
    Actor.draw(self)
end

return Cloud