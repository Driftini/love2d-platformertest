local class = require "lib.middleclass"
local anim8 = require "lib.anim8"

local Actor = require "obj.entities.actor"

local Player = class("Player", Actor)

function Player:initialize(entity, world, entitiesTable)
	self.w, self.h = 32, 32

	Actor.initialize(self, entity, world, entitiesTable)
	table.insert(self.collisionGroups, "Player")

	self.spritesheet = love.graphics.newImage("res/sprites/player.png")
	local grid = anim8.newGrid(32, 32, self.spritesheet:getWidth(), self.spritesheet:getHeight(), 2, 2, 0)
	self.animations.idle = anim8.newAnimation(grid(1, 1), 1)
	self.animations.run = anim8.newAnimation(grid("2-5", 1), {0.12, 0.1, 0.12, 0.1})
	self.animations.jump = anim8.newAnimation(grid(1, 2), 1)
	self.animations.fall = anim8.newAnimation(grid(2, 2), 1)

	self.currentAnim = self.animations.idle

	self.runSpeed = 700
	self.runSpeedCap = 150

	self.jumpForce = 370

	self.keyEvents = true
	self.spotlight = true

	self.wasGrounded = false
	self.canStepSound = true
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
		TEsound.play("res/sounds/jump.wav", "static")
		self.vy = self.vy - self.jumpForce
	end
end

function Player:update(dt)
	self.wasGrounded = self.grounded
	Actor.update(self, dt)
	self:checkInput(dt)

	if self.grounded and not self.wasGrounded then
		TEsound.play("res/sounds/land.wav", "static")
	end

	if self.grounded and self.running then
		self.currentAnim = self.animations.run

		if self.grounded and (self.currentAnim.position == 1 or self.currentAnim.position == 3) and self.canStepSound then
			self.canStepSound = false
			TEsound.play("res/sounds/step.wav", "static", {}, 1, 1, function() self.canStepSound = true end)
		end
	elseif not self.grounded then
		if self.vy < self.jumpForce / -2 then
			self.currentAnim = self.animations.jump
		else
			self.currentAnim = self.animations.fall
		end
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