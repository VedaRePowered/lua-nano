local syntax = {} -- syntax namespace
local l = {} -- array for listing words and their colours
local c = conf.getColours() -- config-deined colours

-- colours for words
l["wordColours"] = {
	--if = c.flow,
	--for = c.flow,
	--while = c.flow,
	--in = c.flow,
	--then = c.flow,
	--do = c.flow,
	--else = c.flow,
	--end = c.flow,
	--function = c.func,
	string = c.keyword,
	table = c.keyword,
	io = c.keyword,
	math = c.keyword,
	os = c.keyword,
	sub = c.keyword,
	len = c.keyword,
	find = c.keyword,
	upper = c.keyword,
	lower = c.keyword,
	match = c.keyword,
	insert = c.keyword,
	remove = c.keyword,
	ipairs = c.keyword,
	pairs = c.keyword,
	read = c.keyword,
	write = c.keyword,
	input = c.keyword,
	output = c.keyword,
	flush = c.keyword,
	random = c.keyword,
	randomseed = c.keyword,
	floor = c.keyword,
	celing = c.keyword,
	huge = c.keyword,
	pi = c.keyword,
	sin = c.keyword,
	cos = c.keyword,
	tan = c.keyword,
	asin = c.keyword,
	acos = c.keyword,
	atan = c.keyword,
	atan2 = c.keyword,
	time = c.keyword,
	date = c.keyword,
	clock = c.keyword,
	execute = c.keyword,
	print = c.keyword,
	--local = c.modify,
	--retrun = c.modify,
	--require = c.modify,
	--or = c.logic,
	--and = c.logic,
	--not = c.logic
}

-- colours for words that need to be defined this way
l["wordColours"]["if"] = c.flow
l["wordColours"]["for"] = c.flow
l["wordColours"]["while"] = c.flow
l["wordColours"]["in"] = c.flow
l["wordColours"]["then"] = c.flow
l["wordColours"]["do"] = c.flow
l["wordColours"]["else"] = c.flow
l["wordColours"]["elseif"] = c.flow
l["wordColours"]["end"] = c.flow
l["wordColours"]["goto"] = c.flow
l["wordColours"]["break"] = c.flow
l["wordColours"]["repeat"] = c.flow
l["wordColours"]["until"] = c.flow

l["wordColours"]["local"] = c.modify
l["wordColours"]["return"] = c.modify
l["wordColours"]["require"] = c.modify

l["wordColours"]["or"] = c.logic
l["wordColours"]["and"] = c.logic
l["wordColours"]["not"] = c.logic

l["wordColours"]["doFile"] = c.keyword
l["wordColours"]["function"] = c.func


-- colours for symbols
l["symbolColours"] = {}
l["symbolColours"]["("] = c.bracket
l["symbolColours"][")"] = c.bracket
l["symbolColours"]["["] = c.bracket
l["symbolColours"]["]"] = c.bracket
l["symbolColours"]["{"] = c.bracket
l["symbolColours"]["}"] = c.bracket
l["symbolColours"]["+"] = c.math
l["symbolColours"]["*"] = c.math
l["symbolColours"]["/"] = c.math
l["symbolColours"]["^"] = c.math
l["symbolColours"]["%"] = c.math
l["symbolColours"][","] = c.keywords
l["symbolColours"]["#"] = c.variable
l["symbolColours"]["."] = c.keywords
l["symbolColours"]["="] = c.logic
l["symbolColours"][">"] = c.logic
l["symbolColours"]["<"] = c.logic
l["symbolColours"]["~"] = c.logic
l["symbolColours"]["1"] = c.number
l["symbolColours"]["2"] = c.number
l["symbolColours"]["3"] = c.number
l["symbolColours"]["4"] = c.number
l["symbolColours"]["5"] = c.number
l["symbolColours"]["6"] = c.number
l["symbolColours"]["7"] = c.number
l["symbolColours"]["8"] = c.number
l["symbolColours"]["9"] = c.number
l["symbolColours"]["0"] = c.number

-- function to write some text to the screen, with the correct colours
function syntax.write(text)
	local fileType = string.match(buffer.getName(), ".-%.(%a*)$") -- get the current buffer's file type with a regex
	if fileType == "lua" then -- syntax highlighting for lua code
		i = 1 -- iterator for input string
		while i <= string.len(text) do -- go through the entire string
			local y = string.sub(text, i, i) -- get current character
			local colour = l["symbolColours"][y] -- get the colour for this character, if it's a symbol
			if colour then -- if it is a symbol
				io.write(colour) -- switch to the right colour
				io.write(y) -- write the symbol
				i = i + 1 -- next character
			else -- if it's not a symbol
				local hWord = string.match(text, "^[_a-zA-Z][_a-zA-Z1-9]*", i) -- next word in string
				local hString = string.match(text, "^[\"\'].-[\"\']", i) -- next " or ' surrounded string
				local hComment = string.match(text, "^%-%-.*", i) -- next --comment
				local hFunction = string.match(text, "^(%a[_%.a-zA-Z1-9]*)%(.-%)", i) -- next function()
				local hVariable = string.match(text, "^(%a[_%.a-zA-Z1-9]*) -[,=%+%-*/^%%%.%)}]", i) -- next variable
				hVariable = string.match(text, "^(%a[_%.a-zA-Z1-9]*) -$", i) or hVariable -- next variable at end of line
				hVariable = string.match(text, "^(%a[_%.a-zA-Z1-9]*) - in ", i) or hVariable -- next variable if for loop
				if string.sub(text, i, i+1) == ".." then -- check for the lua concatination opporator
					io.write(colours.bright .. colours.cyan .. "..") -- bright cyan for concat
					i = i + 2 -- charecter after the concat
				elseif hWord then -- if it's a word
					if l["wordColours"][hWord] then -- get the right colour for that word
						io.write(l["wordColours"][hWord], hWord)
						i = i + string.len(hWord)
					elseif hFunction then -- if it's also a function, colour it as such
						io.write(c.func2, hFunction)
						i = i + string.len(hFunction)
					elseif hVariable then -- if it's also a variable, colour it as such
						io.write(c.variable, hVariable)
						i = i + string.len(hVariable)
					else -- otherwise use regular the colour
						io.write(c.regular, hWord)
						i = i + string.len(hWord)
					end
				elseif hString then -- if it is a string use string colouring
					io.write(c.string, hString)
					i = i + string.len(hString)
				elseif hComment then -- if it is a comment use comment colouring
					io.write(c.comment, hComment)
					i = i + string.len(hComment)
				else -- otherwize use default colours
					io.write(c.regular)
					if y == "-" then
						io.write(c.math)
					end
					io.write(y)
					i = i + 1
				end
			end
		end
		io.write(c.regular) -- reset colours afterwords
	elseif fileType == "md" then -- markdown files
		local reg = c.regular -- if not bold, italic, list index or link, this is the reqular colour
		if string.match(text, "^#+ ") then -- update regular colour for headings
			reg = c.heading
		end
		local i = 1 -- charecter iterator
		while i <= string.len(text) do
			local bold = string.match(text, "^%*%*..-%*%*", i) -- bold text
			local italic = string.match(text, "^_..-_", i) -- italic text
			local boldItalic = string.match(text, "^%*%*_..-_%*%*", i) or string.match(text, "^_%*%*..-%*%*_", i) -- bold and italic text (*_text_* or _*text*_)
			local link1, link2 = string.match(text, "^%((.-)%)%[(.-)%]", i) -- links
			local bullet = string.match(text, "^%* ", i) or string.match(text, "^%d+%. ", i) -- list indexes

			if bullet then -- if list index use c.bullet
				io.write(c.bullet, bullet)
				i = i + string.len(bullet)
			elseif link1 and link2 then -- if a link use c.link for the link itself, not the name
				io.write(reg, "(")
				syntax.write(link1)
				io.write(reg, ")[", c.link, colours.underscore .. "", link2, reg, "]")
				i = i + 4 + string.len(link1) + string.len(link2)
			elseif boldItalic then -- bold and italic text
				io.write(c.boldItalic, boldItalic)
				i = i + string.len(boldItalic)
			elseif bold then -- bold text
				io.write(c.bold, bold)
				i = i + string.len(bold)
			elseif italic then -- italic text
				io.write(c.italic, italic)
				i = i + string.len(italic)
			else -- otherwise use regular
				io.write(reg .. string.sub(text, i, i))
				i = i + 1
			end
		end
	else -- if file type not recognized
		io.write(c.regular, text) -- use regular text
	end
end

return syntax -- return namespace
