local class = require "lib.middleclass"

local Entity = require("obj.entity")

-- Entity capable of movement (npcs, player...)
local Actor = class("Actor", Entity)

function Actor:initialize(entity, world, entitiesTable)
    Entity.initialize(self, entity, world, entitiesTable)

    self.running = false
    self.runSpeed = 0
    self.runSpeedCap = 0
    self.friction = 1.3

    self.jumpForce = 0
    self.fallSpeed = 8
    self.gravityVelocity = 0

    self.grounded = false

    self.vx = 0
    self.vy = 0
end

function Actor:filter(other)
    local cg = other.collisionGroups

    for i = 1, #cg do
        if      cg[i] == "Map"      then return "slide"
        elseif  cg[i] == "Particle" then return "cross"
        end
    end
end

function Actor:applyGravity()
    self.gravityVelocity = self.gravityVelocity + self.fallSpeed

    if self.vy < 0 then
        self.vy = self.vy + self.fallSpeed
    end
end

function Actor:applyFriction()
    self.vx = self.vx / self.friction

    if math.abs(self.vx) < 1 then
        self.vx = 0
    end
end

function Actor:checkGround(colNormalY)
    if colNormalY < 0 then
        self.grounded = true

        -- if hitting the ground midjump, stop the jump
        if self.vy > -self.jumpForce then
            self.vy = 0
        end
    end

    -- if hitting the ceiling midjump, stop the jump
    if colNormalY > 0 then
        self.vy = 0
    end
end

function Actor:onCollide(col)
   -- Actors can define their own checks and logic 
end

function Actor:move(dt)
    if not self.running then
        self:applyFriction()
    end

    if not self.grounded then
        self:applyGravity()
    else
        self.gravityVelocity = 1 -- if set to zero, grounded state will flicker
    end

    local goalX = self.x + self.vx * dt
    local goalY = self.y + (self.vy + self.gravityVelocity) * dt

    local actualX, actualY, cols, len = self.world:move(self, goalX, goalY, self.filter)

    self.grounded = false

    for i = 1, len do
        self:checkGround(cols[i].normal.y)
        self:onCollide(cols[i])
    end

    self.x, self.y = actualX, actualY
end

function Actor:update(dt)
    if not self.destroyed then
        Entity.update(self, dt)
        self:move(dt)
    end
end

return Actor