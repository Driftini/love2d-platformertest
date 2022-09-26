local utils = {}

utils.blankEntity = function()
	return {
		x = 0,
		y = 0,
		width = 1,
		height = 1,
		visible = true,
		order = 0,
		props = {}
	}
end

utils.getRectCenter = function(x, y, w, h)
	local centerX = x + w / 2
	local centerY = y + h / 2

	return centerX, centerY
end

return utils