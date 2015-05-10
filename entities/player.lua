--=============================================--
--  .----..----..----. .-. .-..----..----. 
-- { {__  | {_  | {}  }| | | || {_  | {}  }
-- .-._} }| {__ | .-. \\ \_/ /| {__ | .-. \
-- `----' `----'`-' `-' `---' `----'`-' `-'
--=============================================--
-- Player.lua
--=============================================--
local player = Entities.Derive("amy")
local Raycast = require("entities.raycast")

function player:update(dt)
	self.x, self.y = self.body:getPosition()
	
	if self.isGrappling then
		if self.Grappled then -- Is the player self.Grappled to an entity?
			self:Grapple(self.Grappled)
		end
	elseif self.isHolding then -- Does it need anything here?
	end
	
	if self.isGrabbing then -- Pressing left mouse button
		if not self.isHolding and self.canGrab then
			local x, y = cam:mousepos()
			local hitList = self:InsideCone(self:getViewCone(x, y, 200, 10))
			if hitList then
				local Grabbing = Raycast:ShootRaycast(self.x, self.y, hitList) -- Return the nearest grabeable entity
				if Grabbing then
					self:Grab(Grabbing)
				end
			end
		elseif self.canShoot then
			local x, y = cam:mousepos()
			local angle = math.atan2(y-self.y, x-self.x)
			self:Shoot(angle)
		end
	end
end

function player:mousepressed(x, y, button)
	-- GRAPPLING - - If the player is not holding and the right mouse is pressed: 
	if not self.isHolding and not self.isGrappling and button == "r" then
		local hitList = self:InsideCone( self:getViewCone( x, y, 1024, 5 ) )
		if hitList then
			local Grappling = Raycast:ShootRaycast(self.x, self.y, hitList)
			if Grappling then
				self.isGrappling = true
				self.Grappled = Grappling
			end
		end
	end
	-- GRABBING - - If the player is not holding, can grab and left mouse is pressed:
	if not self.isHolding and self.canGrab and button == "l" then
		self.isGrabbing = true
	end
	-- Shooting - - If the player is holding, can shoot and left mouse is pressed:
	if self.isHolding  and self.canShoot and button == "l" then
		local angle = math.atan2(y-self.y, x-self.x)
		self:Shoot(angle)
	end
	-- SWITCHING - - If the player is holding and middle mouse is pressed
	if self.isHolding and self.canChangeMode and button == "m" then
		-- TODO: Add mode animation, timer, sound
		if self.shootingMode == "RED" then
			self.shootingMode = "BLUE"
		else
			self.shootingMode = "RED"
		end
	end
end

function player:mousereleased(x, y, button)
	if button == "r" then
		self.isGrappling = false
		self.Grappled = nil
	elseif button == "l" then
		self.isGrabbing = false
	end
end


return player