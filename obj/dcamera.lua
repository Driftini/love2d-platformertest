local class = require "lib.middleclass"

local DCamera = class("DCamera")

function DCamera:initialize(resW, resH, x, y, w, h)
    self.resW, self.resH = resW, resH

    self:setScene(x, y, w, h)
    self.updateLag = 20
end

function DCamera:getVisibleRect()
    return -self.floatX, -self.floatY, self.winW, self.winH
end

function DCamera:setScene(x, y, w, h)
    self.sceneW, self.sceneH = w, h

    self.goalX, self.goalY = self.resW, self.resH
    self.floatX, self.floatY = self.goalX, self.goalY -- used for calculations
    self.x, self.y = self.floatX, self.floatY -- used for rendering

    self.goalZoom = 1
    self.zoom = self.goalZoom
end

function DCamera:targetPosition(x, y)
    self.goalX, self.goalY = self.resW / 3 - x, self.resH / 3 - y
    --self:instantPosition(x, y)
end

function DCamera:instantPosition(x, y)
    self:targetPosition(x, y)
    self.floatX, self.floatY = self.goalX, self.goalY
end

function DCamera:targetZoom(zoom)
    self.goalZoom = zoom
end

function DCamera:instantZoom(zoom)
    self:targetZoom(zoom)
    self.zoom = self.goalZoom

end

function DCamera:constrain()
    if -self.floatX < 0 then self.x = 0 end
    if -self.floatY < 0 then self.y = 0 end

    if -self.floatX + self.resW / 1.5 > self.sceneW then self.x = self.resW / 1.5 - self.sceneW end
    if -self.floatY + self.resH / 1.5 > self.sceneH then self.y = self.resH / 1.5 - self.sceneH end
end

function DCamera:update()
    self.floatX = self.floatX + (self.goalX - self.floatX) / self.updateLag
    self.floatY = self.floatY + (self.goalY - self.floatY) / self.updateLag

    self.x = math.floor(self.floatX)
    self.y = math.floor(self.floatY)

    -- self.zoom = self.zoom + (self.goalZoom - self.zoom) / self.updateLag
end

function DCamera:draw(drawFunction)
    self.winW, self.winH = love.graphics.getDimensions()

    self:constrain()
    love.graphics.setScissor(0, 0, self.winW, self.winH)

    love.graphics.push()

    love.graphics.translate(self.x, self.y)
    -- love.graphics.scale(self.zoom)

    drawFunction()

    love.graphics.pop()
end

return DCamera