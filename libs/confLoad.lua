local conf = {} -- conf namespace
-- names of colours
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
	dark = colours.dim .. "",
	reverse = colours.reverse .. "",
	dim = colours.dim .. "",
	bright = colours.bright .. ""
}
-- names of colours, yet inverted
local inverseCNames = {
	red = colours.onred .. "",
	yellow = colours.onyellow .. "",
	green = colours.ongreen .. "",
	cyan = colours.oncyan .. "",
	blue = colours.onblue .. "",
	magenta = colours.onmagenta .. "",
	white = colours.onwhite .. "",
	black = colours.onblack .. "",
}

-- grab config file
local t = require "libs.config"

-- get current colours from config file
function conf.getColours()
	local c = {} -- return variable
	for k, colour in pairs(t.colours) do
		-- log("\ncolourizing:") -- debug
		-- log({"k: ", k}) -- debug
		local h, b, o, h2, r = string.match(colour, "^(%a*) *(%a*) *(%a*) *(%a*) *(%a*)") -- seperate the colour string
		c[k] = colours.reset .. cNames[h] -- initalyze the colour with a reset, then the first hue
		-- log({"variables: \n  h: ", h, "\n  b: ", b, "\n  o: ", o, "\n  h2: ", h2, "\n  r: ", r}, "DBG") -- debug
		if o == "on" then -- test if there is a bg colour
			c[k] = c[k] .. inverseCNames[h2] -- set bg colour to the inverse colour hue2
			if r and cNames[r] then -- potentially swap colours
				--log(r) -- debug
				c[k] = c[k] .. cNames[r]
			end
		elseif o and cNames[o] then -- potentially swap colours
			c[k] = c[k] .. cNames[o]
		end
		if b and b ~= "" then -- finally append  brightness
			c[k] = c[k] .. cNames[b]
		end
	end
	return c -- return colours
end

function conf.getKey(btn) -- get a ctrl or alt-key combo
	return string.byte(t["keys"][btn])-64
end

return conf -- return namespace
