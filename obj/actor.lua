local class = require "lib.middleclass"

local Actor = class("Actor")

function Actor:initialize(world, x, y, w, h)
    self.world = world
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.running = false
    self.runSpeed = 0
    self.runSpeedCap = 0
    self.friction = 1.3

    self.jumpForce = 0
    self.fallSpeed = 10
    self.gravityVelocity = 0

    self.grounded = false

    self.vx = 0
    self.vy = 0

    self.world:add(self, x, y, w, h)
end

function Actor:destroy()
    self.world:remove(self)
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

        if self.vy > -self.jumpForce then -- if hitting the ground midjump, stop the jump
            self.vy = 0
        end
    end

    if colNormalY > 0 then -- if hitting the ceiling midjump, stop the jump
        self.vy = 0
    end
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

    local actualX, actualY, cols, len = self.world:move(self, goalX, goalY)

    self.grounded = false

    for i = 1, len do
        self:checkGround(cols[i].normal.y)
    end

    self.x, self.y = actualX, actualY
end

function Actor:update(dt)
    self:move(dt)
end

function Actor:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Actor