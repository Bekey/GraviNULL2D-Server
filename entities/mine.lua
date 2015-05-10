--=============================================--
--  .----..----..----. .-. .-..----..----. 
-- { {__  | {_  | {}  }| | | || {_  | {}  }
-- .-._} }| {__ | .-. \\ \_/ /| {__ | .-. \
-- `----' `----'`-' `-' `---' `----'`-' `-'
--=============================================--
-- Mine.lua
--=============================================--
local mine = Entities.Derive("base") or {}
mine.RADIUS = 8
mine.TIMER = 0

function mine:load()	
	self.MODE = "NEUTRAL"
	self.CHARGE = 0
	self.OWNER = nil
	self.TARGET = nil
	self.GRABBABLE = true
	
	
	self:loadBody()
end

function mine:loadBody()
	self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	local shape = love.physics.newCircleShape(self.RADIUS)
	
	self.fixture = love.physics.newFixture(self.body, shape)
	self.fixture:setRestitution(0.2)
	self.fixture:setUserData(self)
end

function mine:update(dt)
	self.x, self.y = self.body:getPosition()
end

function mine:Die()
	self.fixture:setUserData(nil)
	self.body:destroy()
end

return mine;