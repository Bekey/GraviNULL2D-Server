--=============================================--
--  .----..----..----. .-. .-..----..----. 
-- { {__  | {_  | {}  }| | | || {_  | {}  }
-- .-._} }| {__ | .-. \\ \_/ /| {__ | .-. \
-- `----' `----'`-' `-' `---' `----'`-' `-'
--=============================================--
-- Mine.lua
--=============================================--
local mine = Entities.Derive("base") or {}

function mine:load(mode, charge, owner, target)	
	self.Mode = mode or "NEUTRAL"
	self.Charge = charge or 0
	self.Owner = owner or nil
	self.Target = target or nil
	
	self:loadBody()
end

function mine:loadBody()
	self.radius = 8
	self.angle = 0
	
	self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	local shape = love.physics.newCircleShape(self.radius)
	self.fixture = love.physics.newFixture(self.body, shape)
	self.fixture:setRestitution(0.2)
	self.fixture:setUserData(self)
end

function mine:update(dt)
	self.x, self.y = self.body:getPosition()
	
	if self.Charge <= 0 then
		self.Charge = 0
		self.Owner = nil
		self.Mode = "NEUTRAL"
	end
	
	if self.Mode == "BLUE" then
		--GET NEAREST PLAYER..
	elseif self.Mode == "RED" and self.Charge < 60 then
		self.Charge = self.Charge - dt * 10
	end
end

function mine:Die()
	Entities.Spawn("FlashEffect", self.x-8, self.y-8)
	self.fixture:setUserData(nil)
	self.body:destroy()
end

return mine;