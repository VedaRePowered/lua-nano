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
	dark = colours.dim .. "",
	reverse = colours.reverse .. "",
	dim = colours.dim .. "",
	bright = colours.bright .. ""
}

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

local t = require "config"

function conf.getColours()
	local c = {}
	for k, colour in pairs(t.colours) do
		-- log("\ncolourizing:")
		-- log({"k: ", k})
		local h, b, o, h2, r = string.match(colour, "^(%a*) *(%a*) *(%a*) *(%a*) *(%a*)")
		c[k] = colours.reset .. cNames[h]
		-- log({"variables: \n  h: ", h, "\n  b: ", b, "\n  o: ", o, "\n  h2: ", h2, "\n  r: ", r}, "DBG")
		if o == "on" then
			c[k] = c[k] .. inverseCNames[h2]
			if r and cNames[r] then
				log(r)
				c[k] = c[k] .. cNames[r]
			end
		elseif o and cNames[o] then
			c[k] = c[k] .. cNames[o]
		end
		if b and b ~= "" then
			c[k] = c[k] .. cNames[b]
		end
	end
	return c
end

function conf.getKey(btn)
	return string.byte(t["keys"][btn])-64
end

return conf
