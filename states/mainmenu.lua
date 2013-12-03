local menu = {} -- TODO ANIMATIONS and SHADERS and cleanup dont forget clean up
local WhatGameText =
		[[In GraviNULL2D, the player will be put in a Zero Gravity situation with no means to move around besides grappling onto numerious floating mines.
		Apart from grappling, the player can also absorb a mine and launch a super-charged version of it towards his enemies.]]

local ControlsText =
		[[All you need to play this game is your mouse! Use the right mouse button to grapple and move, and use the left mouse button to absorb and shoot mines.
		Pressing the middle mouse button will toggles the color of your charged mines: red deals massive damage and blue acts as a weak homing misile.]]

local GamemodesText =
		[[As of yet, the only game mode available is vanilla deathmatch. However, GraviNULL is a very unrestrictive game when it comes to gamemodes.
		There is no limit to what we can add... Be it team deathmatches, capture the flag, races, puzzle games, co-op, or even... Super Smash ;)
		Stay tuned!]]

local Bugtext = [[Report it on our github webpage
				http://github.com/bekey/gravinull2d/
				
				or email us at bekey@blazkosi.com
				
				
				Copyright (c) 2014 - Alpha 0.0.1]]
function menu:enter() 
	self.width, self.height = love.graphics.getWidth(), love.graphics.getHeight()
	self.ratio = self.height / 600
	self.font1 = self.height < 1024 and fonts["silkscreen16"] or fonts["silkscreen24"]
	self.font2 = self.height < 1024 and fonts["silkscreen8"] or fonts["silkscreen16"]
end

function menu:draw()
	love.graphics.setColor(255, 255, 255)
	
	
	self:renderImage(images["mainmenu/background"], "resize-y", "center")
	
	self:renderImage(images["mainmenu/eye_big"], 0, "center", "top", 0, 208)

	self:renderImage(images["mainmenu/eye_small"], 0, "center", "top", 80, 299)
	self:renderImage(images["mainmenu/eye_small"], 0, "center", "top", -80, 299)
	
	self:renderImage(images["mainmenu/wall_left"], "resize-y", "left")
	self:renderImage(images["mainmenu/wall_right"], "resize-y", "right")
	self:renderImage(images["mainmenu/logo"], "resize-x", "center", "top", 0, 15)
	
	
	for j=0, 1 do
		for i=0, 1 do
			local quad = love.graphics.newQuad(i*148, j*30, 148, 30, images["mainmenu/item_all"]:getWidth(), images["mainmenu/item_all"]:getHeight())
			if i == 1 and j == 1 then
				self:renderImage(images["mainmenu/item_decal"], 0, "center", "top", 0, 360 + 48 * i + 48 * j * 2 )
				i = 2
			end
			self:renderQuad(images["mainmenu/item_all"], quad, 0, "center", "top", 0, 360 + 48 * i + 48 * j * 2 )
		end
	end
	
	local WhatGameTitle =  self.height >= 600 and "What is this game?" or "Wat's dis game?"
	local y = self.width / 800
	self:renderText(WhatGameTitle, WhatGameText, "left", 5, y * 90)
	self:renderText("The controls?", ControlsText, "left", 5, y * 190 + self.font2:getHeight())
	self:renderText("Gamemodes?", GamemodesText, "left", 5, y * 320 + self.font2:getHeight())
	
	self:renderText("Found a bug?", Bugtext, "right", 0, y * 90)
end

function menu:renderImage(image, resize, horizontal, vertical, xOff, yOff)
	local scale = self.ratio
	local yOff = yOff or 0
	local xOff = xOff or 0
	local x =  0 + xOff * scale
	local y =  0 + yOff * scale
	
	if resize == "resize-y" then
		scale = self.height / image:getHeight()
	elseif resize == "resize-x" then
		scale = self.width / image:getWidth()
	end
	
	if horizontal == "center" then
		x = x + (self.width - image:getWidth() * scale) / 2 
	elseif horizontal == "right" then
		x = x + self.width - image:getWidth() * scale
	elseif horizontal == "left" then
		x = 0
	else
		x = 0
	end
	
	love.graphics.draw(image, x, y, 0, scale)
end

function menu:renderQuad(image, quad, resize, horizontal, vertical, xOff, yOff)
	local ax, ay, w, h = quad:getViewport( )
	local scale = self.ratio
	local yOff = yOff or 0
	local xOff = xOff or 0
	local x =  0 + xOff * scale
	local y =  0 + yOff * scale
	
	if resize == "resize-y" then
		scale = self.height / w
	elseif resize == "resize-x" then
		scale = self.width / h
	end
	
	if horizontal == "center" then
		x = x + (self.width - w * scale) / 2 
	elseif horizontal == "right" then
		x = x + self.width - h * scale
	elseif horizontal == "left" then
		x = 0
	else
		x = 0
	end
	
	love.graphics.drawq(image, quad, x, y, 0, scale)
end

function menu:renderText(header, text, alignment, xOff, yOff, l)
	local x = 0
	header, text = header or "", text or ""
	alignment = alignment or "left"
	xOff, yOff = xOff or 0, yOff or 0
	l = l or math.floor((self.height / 600) * 195)
	if alignment == "right" then
		x = self.width - l
	end
	
	love.graphics.setFont(self.font1)
	love.graphics.setColor(153, 229, 80)
	love.graphics.print(header, x + xOff, yOff)
	love.graphics.setFont(self.font2)
	love.graphics.setColor(203, 219, 252)
	love.graphics.printf(text, x + xOff, yOff + self.font2:getHeight() * 1.7, l)
end

return menu