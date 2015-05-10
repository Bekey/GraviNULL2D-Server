local Dimensions = {
	{800, 600}, -- 4:3
	{854, 480}, -- 16:9
	{1280, 800},-- 16:10
	{1280, 1024} -- 5:4
}
local Dimension = Dimensions[2]

function love.conf(t)
    t.identity = "gravinull2d"			-- The name of the save directory (string)
    t.version = "0.9.0"					-- The LÖVE version this game was made for (string)
    t.console = false					-- Attach a console (boolean, Windows only)
    
    t.window.title = "GN2D Server"		-- The window title (string)
    t.window.icon = nil					-- Filepath to an image to use as the window's icon (string)
    t.window.width = Dimension[1]		-- The window width (number)
    t.window.height = Dimension[2]		-- The window height (number)
    t.window.borderless = false			-- Remove all border visuals from the window (boolean)
    t.window.resizable = true			-- Let the window be user-resizable (boolean)
    t.window.minwidth = 800				-- Minimum window width if the window is resizable (number)
    t.window.minheight = 480			-- Minimum window height if the window is resizable (number)
    t.window.fullscreen = false			-- Enable fullscreen (boolean)
    t.window.fullscreentype = "normal"	-- Standard fullscreen or desktop fullscreen mode (string)
    t.window.vsync = true				-- Enable vertical sync (boolean)
    t.window.fsaa = 0					-- The number of samples to use with multi-sampled antialiasing (number)
    t.window.display = 1				-- Index of the monitor to show the window in (number)

    t.modules.audio = false				-- Enable the audio module (boolean)
    t.modules.event = true				-- Enable the event module (boolean)
    t.modules.graphics = true			-- Enable the graphics module (boolean)
    t.modules.image = true				-- Enable the image module (boolean)
    t.modules.joystick = false			-- Enable the joystick module (boolean)
    t.modules.keyboard = true			-- Enable the keyboard module (boolean)
    t.modules.math = true				-- Enable the math module (boolean)
    t.modules.mouse = true				-- Enable the mouse module (boolean)
    t.modules.physics = true			-- Enable the physics module (boolean)
    t.modules.sound = false				-- Enable the sound module (boolean)
    t.modules.system = true				-- Enable the system module (boolean)
    t.modules.timer = true				-- Enable the timer module (boolean)
    t.modules.window = true				-- Enable the window module (boolean)
end
