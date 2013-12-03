--=============================================--
--  .----..----..----. .-. .-..----..----. 
-- { {__  | {_  | {}  }| | | || {_  | {}  }
-- .-._} }| {__ | .-. \\ \_/ /| {__ | .-. \
-- `----' `----'`-' `-' `---' `----'`-' `-'
--=============================================--

--	Libraries - libraries.txt for more info
--=============================================--
ATL 	= 	require("libs.AdvTiledLoader")
class 	= 	require("libs.hump.class")
Vector 	= 	require("libs.hump.vector")
Timer 	= 	require("libs.hump.timer")
			require("libs.LUBE")
local serialize = require("libs.ser")

--	App files
--=============================================--
Console = require("console")
Entities = 	require("entities")
local Collision = require("collision")

--	Temporary globals
--=============================================--
ATL.Loader.path = 'maps/'
map = ATL.Loader.load("desert.tmx")
love.graphics.setDefaultImageFilter( "nearest", "nearest" )
love.physics.setMeter(32)
world = love.physics.newWorld(0, 0, true)
world:setCallbacks(Collision.beginContact, Collision.endContact, Collision.preSolve, Collision.postSolve)

H = 0
function onConnect(ip)
	Console:input(string.format("Connecting... %s", ip))
	a = 1
end
function onReceive(data, ip)
	Console:input(string.format("Receiving data from %s = { %s }", ip, data), ip)
end
function onDisconnect(ip)
	Console:input(string.format("Bye lost soul, %s", ip))
end

-- love.load()
--=============================================--
function love.load()
	Console:input(string.format("Loading map... %s", map.name))
	Entities:loadAll()

	server = lube.udpServer()
	server.handshake = "DEA PRO MIHI, AUDITE MEUS DICO. PATEFACIO PRODIGIUM PRO NOS TOTUS."
	server.callbacks = {
		recv = onReceive,
		connect = onConnect,
		disconnect = onDisconnect
	}
	Console:input(string.format("Starting server... %s", server.handshake))
	server:listen(18112)
end

function love.update(dt)
	server:update(dt)
	world:update(dt)
	Timer.update(dt)
	local t = Entities:update(dt)
	H = H + dt
	if H > 0.1 then
		server:send(serialize(t))
	end
end

function love.draw()
	Console:draw()
end

function love.keypressed(key)
	if key == "a" then
		local mine = Entities.objects[4]
		mine.body:applyLinearImpulse(30,30)
		Console:input(string.format("Object %s given random velocity.", mine.type))
	end
end
