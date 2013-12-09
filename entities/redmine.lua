--=============================================--
--  .----..----..----. .-. .-..----..----. 
-- { {__  | {_  | {}  }| | | || {_  | {}  }
-- .-._} }| {__ | .-. \\ \_/ /| {__ | .-. \
-- `----' `----'`-' `-' `---' `----'`-' `-'
--=============================================--
-- Redmin.lua
--=============================================--
local redmine = Entities.Derive("mine") or {}

function redmine:load(owner)	
	self.MODE = "RED"
	self.CHARGE = 60
	self.OWNER = owner or nil
	self.GRABBABLE = false
	self:loadBody()
end

function redmine:update(dt)
	self.x, self.y = self.body:getPosition()
	if self.CHARGE <= 0 then
		self.CHARGE = 0
		self.OWNER = nil
		self.MODE = "NEUTRAL"
	else
		self.TIMER = self.TIMER + dt
		if self.TIMER > 3 then
			self.CHARGE = self.CHARGE - dt * 10
		elseif self.TIMER > 0.3 then
			self.GRABBABLE = true
		end
	end
end

return redmine;