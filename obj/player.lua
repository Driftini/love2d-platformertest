local class = require "lib.middleclass"

local Actor = require "obj.actor"

local identifier = "Player"

local Player = class(identifier, Actor)

function Player:initialize(entity, world, entitiesTable)
    Actor.initialize(self, entity, world, entitiesTable)
    self.identifier = identifier

    self.w = 8
    self.h = 16

    self.runSpeed = 15
    self.runSpeedCap = 150

    self.jumpForce = 400

    self.keyEvents = true
end

function Player:checkInput() -- for continuous inputs
    self.running = false

    if love.keyboard.isDown("a") then
        -- Brake if already running
        if self.vx > 0 then
            Actor.applyFriction(self)
        end

        self.vx = self.vx - self.runSpeed

        -- Apply speed cap
        if self.vx < -self.runSpeedCap then
            self.vx = -self.runSpeedCap
        end

        self.running = true
    end
    if love.keyboard.isDown("d") then
        -- Brake if already running
        if self.vx < 0 then
            Actor.applyFriction(self)
        end

        self.vx = self.vx + self.runSpeed

        -- Apply speed cap
        if self.vx > self.runSpeedCap then
            self.vx = self.runSpeedCap
        end

        self.running = true
    end
end

function Player:keypressed(key, isRepeat) -- for non-continuous inputs
    if not isRepeat then
        if key == "w" then
            self:jump()
        end
    end
end

function Player:jump()
    if self.grounded then
        self.vy = self.vy - self.jumpForce
    end
end

function Player:update(dt)
    Actor.update(self, dt)
    self:checkInput()
end

function Player:draw()
    Actor.draw(self)

    -- if self.grounded then
    --     love.graphics.print("grounded", self.x, self.y - 40)
    -- end

    -- love.graphics.print("x " .. self.x, self.x, self.y - 28)
    -- love.graphics.print("y " .. self.y, self.x, self.y - 16)
end

return Player