--=============================================--
--  .----..----..----. .-. .-..----..----. 
-- { {__  | {_  | {}  }| | | || {_  | {}  }
-- .-._} }| {__ | .-. \\ \_/ /| {__ | .-. \
-- `----' `----'`-' `-' `---' `----'`-' `-'
--=============================================--
-- Amy.lua
--=============================================--
local Amy = Entities.Derive("base") or {}
local Raycast = require("entities.raycast")

function Amy:load()
	self:loadBody()
	
	self.Health = self.Health or 100
	
	self.Score = 0

	self.Grappled = false
	self.Grabbed = false

	self.canGrapple = true
	self.canShoot = true
	self.canGrab = true
	self.canChangeMode = true
end

function Amy:loadBody()
	self.r_body = 0
	self.w_body = 64
	self.h_body = 25

	self.body = love.physics.newBody(world, self.x,self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w_body, self.h_body)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(self)
	self.body:setFixedRotation(true)
end

function Amy:Hurt(Object)
	local score = 0
	if Object.CHARGE > self.Health then
		score = math.abs(math.floor(self.Health/10)) + 3
	else
		score = math.abs(math.floor(Object.CHARGE/10))
	end
	self.Health = self.Health - Object.CHARGE
	Object.OWNER.Score = Object.OWNER.Score + score
	
	if self.Health <= 0 then
		
	end
end

function Amy:update(dt)
	self.x, self.y = self.body:getPosition()
	if not self.Grabbed and self.Grappled then -- Is the player self.Grappled to an entity?
		self:Grapple(self.Grappled.x, self.Grappled.y)
	elseif self.Grabbed then
	-- Does it need anything here? TODO: YES! aniamtion and shit
	end
	
	if self.Health <= 0 then
	end
end


function Amy:Grapple(x, y)
	local delta = Vector(0,0)
	delta.x = x - self.x
	delta.y = y - self.y
	delta:normalized()
	self.body:applyForce(delta.x*(1.2+delta:len()/2048), delta.y*(1.2+delta:len()/2048))
end

function Amy:Shoot(angle) 
	local delta = Vector(0, 0)
	local ox, oy = 50*math.cos(angle)+self.x, 50*math.sin(angle)+self.y--TODO: Improve
	local projectile
	
	if self.Grabbed == "RED" then
		projectile = Entities.Spawn("redmine", ox, oy, self)
	elseif self.Grabbed == "BLUE" then
		projectile = Entities.Spawn("bluemine", ox, oy, self)
		self.canChangeMode = false
		Timer.add(5, function() self.canChangeMode = true end)
	end 
	
	delta.x = ox - self.x
	delta.y = oy - self.y
	delta:normalized()

	projectile.body:applyLinearImpulse(delta.x*2, delta.y*2)
	self.body:applyLinearImpulse(-delta.x, -delta.y)
	
	self.Grabbed = nil
	self.canShoot = false
	self.canGrab = false
	
	Timer.add(1, function() self.canGrab = true end)
	--return projectile
end

function Amy:Grab(Object)
	if Object and (Object.type == "mine" or Object.type == "bluemine" or Object.type == "redmine") then
		if not Raycast:isObstructed(self.x, self.y, Object) then
			self.Grabbed = "RED"
			self.Grappled = nil

			self.canGrab = false
			self.canShoot = false
			Timer.add(0.75, function() self.canShoot = true end)
			return Entities.Destroy(Object.id)
		end
	end
end

return Amy;