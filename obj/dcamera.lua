local class = require "lib.middleclass"

local DCamera = class("DCamera")

function DCamera:initialize(resX, resY, x, y, w, h)
    self.resX, self.resY = resX, resY

    self:setScene(x, y, w, h)
    self.updateLag = 10
end

function DCamera:getVisibleRect()
    return self.x, self.y
end

function DCamera:clamp()
    -- todo
end

function DCamera:setScene(x, y, w, h)
    self.goalX, self.goalY = self.resX, self.resY
	self.x, self.y = self.goalX, self.goalY
    self.sceneW, self.sceneH = w, h
    self.goalZoom = 1
    self.zoom = self.goalZoom
end

function DCamera:targetPosition(x, y)
    self.goalX, self.goalY = self.resX / 3 - x, self.resY / 3 - y
    self.x, self.y = self.goalX, self.goalY
end

function DCamera:targetZoom(zoom)
    self.goalZoom = zoom
    self.zoom = self.goalZoom
end

function DCamera:update(dt)
    -- todo
end

function DCamera:draw(drawFunction)
    --love.graphics.setScissor()

    love.graphics.push()

    love.graphics.scale(self.zoom)
    love.graphics.translate(self.x, self.y)

    drawFunction()

    love.graphics.pop()
end

return DCamera