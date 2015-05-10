--=============================================--
--  .----..----..----. .-. .-..----..----. 
-- { {__  | {_  | {}  }| | | || {_  | {}  }
-- .-._} }| {__ | .-. \\ \_/ /| {__ | .-. \
-- `----' `----'`-' `-' `---' `----'`-' `-'
--=============================================--
--	Console.lua
--=============================================--
local console = {}
console.lineheight = 15
console.currline = 15
console.lines = {
}

function console:draw()
	self:output()
end

function console:output()
	while #self.lines > 30 do
		table.remove(self.lines,1)
	end
	for i,v in ipairs(self.lines) do
		love.graphics.print( v, 15, self.lineheight+self.currline*(i-1) )
	end
end

function console:input(txt)
	table.insert(self.lines, txt)
end

return console