local class = require "lib.middleclass"
local anim8 = require "lib.anim8"

local Actor = require "obj.actor"

local Player = class("Player", Actor)

function Player:initialize(entity, world, entitiesTable)
    self.w, self.h = 32, 32

    Actor.initialize(self, entity, world, entitiesTable)
    table.insert(self.collisionGroups, "Player")

    self.spritesheet = love.graphics.newImage("assets/player.png")
    local grid = anim8.newGrid(32, 32, self.spritesheet:getWidth(), self.spritesheet:getHeight(), 2, 2, 0)
    self.animations.idle = anim8.newAnimation(grid(1, 1), 1)
    self.animations.run = anim8.newAnimation(grid("2-5", 1), {0.12, 0.1, 0.12, 0.1})

    self.currentAnim = self.animations.idle

    self.runSpeed = 700
    self.runSpeedCap = 150

    self.jumpForce = 370

    self.keyEvents = true
end

function Player:checkInput(dt) -- for continuous inputs
    self.running = false

    if love.keyboard.isDown("a") then
        -- Brake if already running
        if self.vx > 0 then
            Actor.applyFriction(self, dt)
        end

        self.vx = self.vx - self.runSpeed * dt

        -- Apply speed cap
        if self.vx < -self.runSpeedCap then
            self.vx = -self.runSpeedCap
        end

        self.running = true
        self.flipped = true
    end
    if love.keyboard.isDown("d") then
        -- Brake if already running
        if self.vx < 0 then
            Actor.applyFriction(self, dt)
        end

        self.vx = self.vx + self.runSpeed * dt

        -- Apply speed cap
        if self.vx > self.runSpeedCap then
            self.vx = self.runSpeedCap
        end

        self.running = true
        self.flipped = false
    end
end

function Player:keypressed(key) -- for non-continuous inputs
    if key == "w" then
        self:jump()
    end
end

function Player:jump()
    if self.grounded then
        self.vy = self.vy - self.jumpForce
    end
end

function Player:update(dt)
    Actor.update(self, dt)
    self:checkInput(dt)

    if self.running then
        self.currentAnim = self.animations.run
    else
        self.currentAnim = self.animations.idle
    end
end

function Player:draw()
    Actor.draw(self)

    -- if self.grounded then
    --     love.graphics.print("grounded", self.x, self.y - 40)
    -- end

    -- love.graphics.print("grav " .. self.gravityVelocity, self.x, self.y - 40)
    -- love.graphics.print("vx " .. self.vx, self.x, self.y - 28)
    -- love.graphics.print("vy " .. self.vy, self.x, self.y - 16)
end

return Player