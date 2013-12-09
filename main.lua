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
Serialize = require("libs.ser")

--	App files
--=============================================--
Console = require("console")
Server = require("server")
Entities = 	require("entities")
local Collision = require("collision")

--	Temporary globals
--=============================================--
ATL.Loader.path = 'maps/'
map = ATL.Loader.load("desert.tmx")
love.graphics.setDefaultFilter( "nearest", "nearest" )
love.physics.setMeter(32)
world = love.physics.newWorld(0, 0, true)
world:setCallbacks(Collision.beginContact, Collision.endContact, Collision.preSolve, Collision.postSolve)

-- love.load()
--=============================================--
function love.load()
	Console:input(string.format("Loading map... %s", map.name))
	Entities:loadAll()
	Server:load()
end

function love.update(dt)
	Server:update(dt)
end

function love.draw()
	Console:draw()
end

function love.keypressed(key)
	if key == "a" then
		local mine = Entities.objects[math.random(2,6)]
		mine.body:applyLinearImpulse(math.random(-20,20),math.random(-20,20))
		Console:input(string.format("Object %s given random velocity.", mine.type))
	end
end
