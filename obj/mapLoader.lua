local class = require "lib.middleclass"
local bump = require "lib.bump"
local ldtk = require "lib.ldtk"
local gamera = require "lib.gamera"
local utils = require "utils"

local Player = require "obj.player"
local PlayerSpawnpoint = require "obj.playerSpawnpoint"
local SCollider = require "obj.scollider"
local MapTrigger = require "obj.mapTrigger"
local CloudSpawner = require "obj.cloudSpawner"
local RainSpawner = require "obj.rainSpawner"

local MapLoader = class("MapLoader")

function MapLoader:initialize()
	self.world = bump.newWorld() -- Colliding entities
	self.entities = {} -- All entities (should be merged with bump world probably)
	self.layers = {} -- Tile layers
	self.camera = gamera.new(0, 0, 1, 1)
end

function MapLoader:entitySwitch(e)
	local switch = {
		["PlayerSpawnpoint"]    = PlayerSpawnpoint,
		["SCollider"]           = SCollider,
		["MapTrigger"]          = MapTrigger,
		["CloudSpawner"]        = CloudSpawner,
		["RainSpawner"]         = RainSpawner,
	}

	return switch[e.identifier]:new(e, self.world, self.entities)
end

function MapLoader:loadProject(project)
	ldtk:load("ldtk/levels/" .. project .. ".ldtk")
end

function MapLoader:loadLevel(level, playerSpawnpointID)
	local loadTime, finishTime

	function ldtk.entity(entity)
		self:entitySwitch(entity)
	end

	function ldtk.layer(layer)
		table.insert(self.layers, layer)
	end

	function ldtk.onLevelLoad(levelData)
		print("[MAPLOADER] Loading map " .. levelData.identifier .. "...")
		loadTime = love.timer.getTime()

		ldtk.removeCache()

		self.entities = {}
		self.layers = {}
		self.world = bump.newWorld()
		love.graphics.setBackgroundColor(levelData.bgColor)

		self.camera:setWorld(0, 0, levelData.width, levelData.height)
		self.camera:setScale(3)
	end

	function ldtk.onLevelCreated(levelData)
		finishTime = love.timer.getTime()
		print("[MAPLOADER] Map " ..
			levelData.identifier .. " finished loading in " .. (finishTime - loadTime) * 1000 .. "ms.")

		if playerSpawnpointID then
			for i = 1, #self.entities do
				if self.entities[i].spawnID == playerSpawnpointID then
					local playerEntity = utils.blankEntity()

					playerEntity.x, playerEntity.y = self.entities[i].x, self.entities[i].y

					Player:new(playerEntity, self.world, self.entities)
					return
				end
			end
		end
	end

	ldtk:level(level)
end

function MapLoader:keypressed(key)
	for i = 1, #self.entities do
		if self.entities[i].keyEvents then
			self.entities[i]:keypressed(key)
		end
	end
end

-- need to add a "switching" bool or something

function MapLoader:update(dt)
	local destination -- For map switching

	local i = 1

	-- For loops won't work with a changing length
	while i <= #self.entities do
		if self.entities[i].destroyed then
			table.remove(self.entities, i)
		else
			self.entities[i]:update(dt)

			if self.entities[i].triggered then -- triggered MapTrigger
				destination = self.entities[i].destination
			end

			if self.entities[i].spotlight then
				local camX, camY = utils.getRectCenter(self.entities[i].x, self.entities[i].y, self.entities[i].w, self.entities[i].h)

				self.camera:setPosition(camX, camY)
			end
		end

		i = i + 1
	end

	if destination then
		for i = 1, #self.entities do
			if self.entities[i].name == "Player" then
				-- DATA.player = self.entities[i].stats
			end
		end

		self:loadLevel(destination.map, destination.spawnpoint)
	end
end

function MapLoader:draw()
	self.camera:draw(
		function()
			local visibleEntities = self.world:queryRect(self.camera:getVisible())

			print("# entities: " .. self.world:countItems(), "	# drawn: " .. #visibleEntities)

			table.sort(visibleEntities, function(a,b) return a.order < b.order end)
			table.sort(self.layers, function(a,b) return a.order < b.order end)

			for i = 1, #visibleEntities do
				visibleEntities[i]:draw()
			end

			for i = 1, #self.layers do
				self.layers[i]:draw()
			end
		end
	)
end

return MapLoader
