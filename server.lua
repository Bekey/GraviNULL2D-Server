local server = {}

function server:load()
	self.connection = lube.udpServer()
	self.port = 18112
	
	self.SEQUENCE = 0
	self.sync = {}
	self.kill = {}
	self.create = {}
	self.chat = {}

	self.connection.handshake = "DEA PRO MIHI, AUDITE MEUS DICO. PATEFACIO PRODIGIUM PRO NOS TOTUS."
	self.connection:setPing(true, 6, "Bored now...\n")

	self.clients = {}
	self.numClients = 0
	self.options = {}
	self.map = {}
	self.map.name = "maps/desert.tmx"
	self.t = 0
	
	self:start(self.port)
end

function server:start(port)	
	Console:input(string.format("Starting server... %s", self.connection.handshake))
	self.connection:listen(port)
	
	self.connection.callbacks.recv = function(d, id) self:recv(d, id) end
	self.connection.callbacks.connect = function(id) self:connect(id) end
	self.connection.callbacks.disconnect = function(id) self:disconnect(id) end
end

function server:update(dt)
	self.t = self.t + dt
	self.connection:update(dt)
	world:update(dt)
	Timer.update(dt)
	Entities:update(dt)
	
	if self.t > 0.1 then
		self.t = 0
		self:syncAll()
		
		local t = { self.SEQUENCE, ["SYNC"] = self.sync, ["CREATE"] = self.create, ["KILL"] = self.kill, ["CHAT"] = self.chat }
		
		self:send(Serialize(t))
		
		self.sync = {}
		self.create = {}
		self.kill = {}
		self.chat = {}
	end
	love.graphics.setCaption(string.format("GraviNULL2D Server - %d clients connected @ %d FPS", self.numClients,love.timer.getFPS()))
end

function server:send(data, clientId)
	if clientId then
		self.connection:send(data, clientId)
		Console:input(string.format("Sent data to %s", clientId))
		self.SEQUENCE = self.SEQUENCE + 1
	else
		self.connection:send(data)
		self.SEQUENCE = self.SEQUENCE + 1
	end
end

function server:syncAll(clientId)
	if clientId then
		local t = { self.SEQUENCE, ["SYNC"] = Entities.packEntities() }
		local data = Serialize(t)
		self:send(data, clientId)
	else
		local t = Entities.packEntities()
		self.sync = t
		return t
	end
end

function server:Kill(id)
	if id then
		table.insert(self.kill, id) 
	end
end

function server:Create(id, type, x, y, params)
	if id then
		local t = {id, type, x, y, params}
		table.insert(self.create, t)
	end
end

function server:newClient(clientId)
	self:createClient(clientId)
	self:syncAll(clientId)
	--self.recvcommands.CHAT(self, "CHAT", chat, clientId, id)

	self.numClients = self.numClients + 1
	Console:input(string.format("%s has connected", clientId))
end

function server:createClient(clientId)
	local player = Entities.Spawn("amy", 231, 212)
	local data = Serialize({
		self.SEQUENCE,
		["CREATE"] = {player.id, "player", player.x, player.y}
	})
	self:send(data, clientId)
	
	self:Create(player.id, player.type, player.x, player.y)
end

function server:connect(clientId)
	Console:input(string.format("Connecting... %s", clientId))
	self:newClient(clientId)
end

function server:disconnect(clientId)
	Console:input(string.format("Bye lost soul, %s", clientId))
	self.numClients = self.numClients - 1
end

function server:recv(data, clientId)
	Console:input(string.format("Receiving data from %s = { %s }", clientId, data))
	local t = loadstring(data)()
	--if t[1] > Sequence then
		--Sequence = t[1]
	for k, v in pairs(t) do
		--if type(v) ~= "number" then
		if k == "GRAB" then
			local amy = Entities.objects[v[1]]
			if amy then
				local ball = Entities.objects[v[2]]
				if ball then
					self:Kill(ball.id)
					amy:Grab(ball)
					self:syncAll()
				end
			end
		elseif k == "GRAPPLE" then
			local amy = Entities.objects[v[1]]
			if amy then
				local ball = Entities.objects[v[2]]
				if ball then
					amy:Grapple(ball)
					self:syncAll()
				end
			end
		elseif k == "UNGRAPPLE" then
			local amy = Entities.objects[v[1]]
			if amy then
				amy.Grappling = nil
				amy.isGrappling = false
				self:syncAll()
			end
		elseif k =="SHOOT" then
			local amy = Entities.objects[v[1]]
			if amy then
				local ball = Entities.objects[v[2]]
				if ball then
					self:Kill(ball.id)
					amy:Grab(ball)
					self:syncAll()
				end
			end
		end
	end
	--end
end

return server