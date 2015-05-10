local raycast = {}

function raycast:ShootRaycast(x, y, hitList)
	self.x = x
	self.y = y
	self.inSight = {}
	local function getNearest(a, b)
		local x, y = self.x, self.y
		local dist1, dist2 =
			(a.x-x)*(a.x-x)+(a.y-y)*(a.y-y),
			(b.x-x)*(b.x-x)+(b.y-y)*(b.y-y)
		return dist1 < dist2
	end
	
	for _, v in pairs(hitList) do
		if self:isObstructed(self.x, self.y, v) then
			self.inSight = {}
		else
			table.insert(self.inSight, v)
		end
	end
	table.sort(self.inSight, getNearest)
	return self.inSight[1]
end

function raycast:isObstructed(x, y, Object)
	self.x = x
	self.y = y
	local Obs = false
	local function Raycast(fixture, x, y, xn, yn, fraction)
		local entity = fixture:getUserData()
		if entity == "wall" then
			Obs = true
			return 0
		end
		return 1
	end
	world:rayCast(self.x, self.y, Object.x, Object.y, Raycast)
	return Obs
end

return raycast