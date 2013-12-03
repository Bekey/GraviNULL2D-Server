local Dimensions = {
	{800, 600}, -- 4:3
	{854, 480}, -- 16:9
	{1280, 800},-- 16:10
	{1280, 1024} -- 5:4
}
local Dimension = Dimensions[2]
function love.conf(t)
    t.modules.joystick = false   -- Enable the joystick module (boolean)
    t.modules.audio = false      -- Enable the audio module (boolean)
    t.modules.keyboard = true   -- Enable the keyboard module (boolean)
    t.modules.event = true      -- Enable the event module (boolean)
    t.modules.image = true      -- Enable the image module (boolean)
    t.modules.graphics = true   -- Enable the graphics module (boolean)
    t.modules.timer = true      -- Enable the timer module (boolean)
    t.modules.mouse = true      -- Enable the mouse module (boolean)
    t.modules.sound = false      -- Enable the sound module (boolean)
	t.modules.thread = false
    t.modules.physics = true    -- Enable the physics module (boolean)
    t.console = false           -- Attach a console (boolean, Windows only)
    t.title = "GraviNULL2D"        -- The title of the window the game is in (string) 
    t.author = "Bekey"        -- The author of the game (string)
    t.screen.fullscreen = false -- Enable fullscreen (boolean)
    t.screen.vsync = true       -- Enable vertical sync (boolean)
    t.screen.fsaa = 0           -- The number of FSAA-buffers (number)
    t.screen.height = Dimension[2]       -- The window height (number)
    t.screen.width = Dimension[1]        -- The window width (number)
end
