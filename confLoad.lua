local conf = {}
local cNames = {
	red = colours.red .. "",
	yellow = colours.yellow .. "",
	green = colours.green .. "",
	cyan = colours.cyan .. "",
	blue = colours.blue .. "",
	magenta = colours.magenta .. "",
	white = colours.white .. "",
	black = colours.black .. "",
	regular = colours.reset .. "",
	light = colours.bright .. "",
	dark = colours.dim .. ""
}

local t = require "config"

function conf.getColours()
	local c = {}
	for k, colour in pairs(t.colours) do
		local b = string.match(colour, "%a* (%a*)")
		local h = string.match(colour, "%a*")
		if b then
			c[k] = colours.reset .. cNames[b] .. cNames[h]
		else
			c[k] = colours.reset .. cNames[h]
		end
	end
	return c
end

function conf.getKey(btn)
	return string.byte(t["keys"][btn])-64
end

return conf
