local base = {}

function base:setPos( x, y )
	base.x = x
	base.y = y
end

function base:getPos()
	return base.x, base.y;
end

function base:getPosition()
	return base.x, base.y
end

function base:getX()
	return base.x
end

function base:getY()
	return base.y
end

function base:load()
end

return base;