local game = {}

function game:init()
	self.map = {
		width = map.width * map.tileWidth,
		height = map.height * map.tileHeight
	}
	self.width, self.height = love.graphics.getWidth(), love.graphics.getHeight()
	
	cam = Camera(0, 0)
	cam:zoom(1) --TODO: Set scale based on resolution and aspect ratio
	cam:setBounds(self.width/2, self.height/2, self.map.width - self.width/2, self.map.height - self.height/2) -- TODO: Works correctly when scaled?
	
	Entities:loadAll()
end

function game:update(dt)
	world:update(dt)
	Entities:update(dt)
	Timer.update(dt)
	cam:lookAt(	math.floor(player:getX()),
				math.floor(player:getY()))
end

function game:draw()
	love.graphics.setColor(255, 255, 255)
	cam:attach()
	
	local dx, dy = cam.x - self.width/2, cam.y - self.height/2
	map:setDrawRange(dx, dy,self.width,self.height)
	map:draw()

	Entities:draw()

	cam:detach()
end

function game:keypressed(key, unicode)
	map:callback("keypressed", key, unicode)
	if key == 'f4' then
		local x,y = cam:mousepos()
		Entities.Spawn("player", x, y)
	elseif key == 'f1' then
		DEBUG = not DEBUG
	end
end

function game:mousepressed(x, y, button)
	local x, y = cam:mousepos()
	Entities:mousepressed(x,y,button)
end

function game:mousereleased(x, y, button)
	local x, y = cam:mousepos()
	Entities:mousereleased(x,y,button)
end

return game