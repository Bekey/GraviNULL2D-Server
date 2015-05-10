--=============================================--
--  .----..----..----. .-. .-..----..----. 
-- { {__  | {_  | {}  }| | | || {_  | {}  }
-- .-._} }| {__ | .-. \\ \_/ /| {__ | .-. \
-- `----' `----'`-' `-' `---' `----'`-' `-'
--=============================================--
--	Entities.lua
--=============================================--
local entities = {}
entities.objects = {}
entities.walls = {}
entities.path = "entities/"

local register = {}
local id = 0

function entities:loadAll()
	register["amy"] = 			love.filesystem.load( entities.path .. "amy.lua" )
	register["player"] = 		love.filesystem.load( entities.path .. "amy.lua" )
	register["mine"] = 			love.filesystem.load( entities.path .. "mine.lua" )
	register["redmine"] = 		love.filesystem.load( entities.path .. "redmine.lua" )
	register["bluemine"] = 		love.filesystem.load( entities.path .. "bluemine.lua" )
	--register["FlashEffect"] = 	love.filesystem.load( entities.path .. "effects/flash.lua" )

	self:LoadLevel()
	self:LoadObjects()
end

function entities:LoadObjects()
	local layer = map("Objects")
	for i = 1, #layer.objects do
	local obj = layer.objects[i]
		self.Spawn(obj.name, obj.x, obj.y)
	end
	layer:toCustomLayer() --TODO: Not break when love.load is called twice
end

function entities:LoadLevel() --TODO: Optimize using: http://love2d.org/forums/viewtopic.php?f=4&t=54654&p=131862#p132045 & http://www.love2d.org/wiki/TileMerging
	local layer = map("Ground")
	self.walls = {}
	for x, y, tile in layer:iterate() do
		if tile.properties.obstacle then
			self:makeObstacle(x, y, tile)
		end
	end
end

function entities:makeObstacle(x, y, tile)
	local wall = self.walls[#self.walls+1]
	local w, h, xOffset, yOffset
	
	w = tile.properties.width or map.tileWidth
	h = tile.properties.height or map.tileHeight
	xOffset = tile.properties.xOffset or 0
	yOffset = tile.properties.yOffset or 0
	
	local body = love.physics.newBody(world, x*map.tileWidth+xOffset+w/2, y*map.tileHeight+yOffset+h/2)
	local shape = love.physics.newRectangleShape(w, h)
	
	wall = love.physics.newFixture(body, shape)
	wall:setMask(16)
	wall:setUserData("wall")
end

function entities.Derive(name)
	return love.filesystem.load( entities.path .. name .. ".lua" )()
end

function entities.Spawn(name, x, y, params)
	if register[name] then
		id = id + 1
		
		local entity = register[name]()
		entity.id = id
		entity.type = name
		entity:setPos(x, y) --TODO: Validate if it exists, or move into :load()
		entity:load(params)
		entities.objects[id] = entity
		
		return entities.objects[id]
	else
		Console:input(string.format("Entity %s does not exist!", name))
	end
end

function entities.Destroy(id)
	if entities.objects[id] then
		if entities.objects[id].Die then
			entities.objects[id]:Die()
		end
		entities.objects[id] = nil
	end
end

function entities:update(dt)
	for _, entity in pairs(entities.objects) do
		if entity.update then
			entity:update(dt)
		end
	end
end

function entities.packEntities()
	local t = {}
	local function round(a)
		if type(a) == 'number' then
			return a--tonumber(string.format("%.2f", a))
		else
			return a
		end
	end
	for _, entity in pairs(entities.objects) do
		if entity.update then
			local vx, vy
			local eid = entity.id
			local type = entity.type
			local x, y = round(entity.x), round(entity.y)
			if entity.body then
				vx, vy = entity.body:getLinearVelocity()
			end
			local a,b,c,d
			if type == "mine" or type == "redmine" or type == "bluemine" then
				a = entity.OWNER and entity.OWNER.id or nil
				b = entity.MODE ~= "NEUTRAL" and entity.MODE or nil
				c = entity.MODE == "RED" and round(entity.CHARGE) or nil
				d = entity.TARGET or nil
			elseif type == "amy" or type == "player" then
				a = round(entity.Health) or 0
				b = entity.Score or 0
				if entity.Grappled then c = entity.Grappled.id else c = nil end
				if entity.Grabbed then d = entity.Grabbed else d = nil end
			end
			local data = { eid, type, x, y, round(vx), round(vy), a, b, c, d }
			table.insert(t, data)
			--Console:input(Serialize(data))
		end
	end
	return t
end

return entities