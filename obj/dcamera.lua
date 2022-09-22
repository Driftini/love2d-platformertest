local class = require "lib.middleclass"

local DCamera = class("DCamera")

function DCamera:initialize(resX, resY, x, y, w, h)
    self.resX, self.resY = resX, resY

    self:setScene(x, y, w, h)
    self.updateLag = 10
end

function DCamera:getVisibleRect()
    return -self.x, -self.y, self.winW, self.winH
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
    --self:instantPosition(x, y)
end

function DCamera:instantPosition(x, y)
    self:targetPosition(x, y)
    self.x, self.y = self.goalX, self.goalY
end

function DCamera:targetZoom(zoom)
    self.goalZoom = zoom
end

function DCamera:instantZoom(zoom)
    self:targetZoom(zoom)
    self.zoom = self.goalZoom

end

function DCamera:constrain()
    -- todo
end

function DCamera:update(dt)
    self.x = (self.x + self.goalX) / 2
    self.y = (self.y + self.goalY) / 2

    self.zoom = (self.zoom + self.goalZoom) / 2
end

function DCamera:draw(drawFunction)
    self.winW, self.winH = love.graphics.getDimensions()

    self:constrain()
    love.graphics.setScissor(0, 0, self.winW, self.winH)

    love.graphics.push()

    love.graphics.scale(self.zoom)
    love.graphics.translate(self.x, self.y)

    drawFunction()

    love.graphics.pop()
end

return DCamera