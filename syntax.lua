local syntax = {}
local l = {}
local c = conf.getColours()

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
l["symbolColours"][","] = c.variable
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

function syntax.write(text)
	local fileType = string.match(buffer.getName(), ".-%.(%a*)$")
	if fileType == "lua" then
		i = 1
		while i <= string.len(text) do
			local y = string.sub(text, i, i)
			local colour = l["symbolColours"][y]
			if colour then
				io.write(colour)
				io.write(y)
				i = i + 1
			else
				local hWord = string.match(text, "^[_a-zA-Z][_a-zA-Z1-9]*", i)
				local hString = string.match(text, "^[\"\'].-[\"\']", i)
				local hComment = string.match(text, "^%-%-.*", i)
				local hFunction = string.match(text, "^(%a[_%.a-zA-Z1-9]*)%(.-%)", i)
				local hVariable = string.match(text, "^(%a[_%.a-zA-Z1-9]*) -[,=%+%-*/^%%%.%)}]", i)
				hVariable = string.match(text, "^(%a[_%.a-zA-Z1-9]*) -$", i) or hVariable
				hVariable = string.match(text, "^(%a[_%.a-zA-Z1-9]*) - in ", i) or hVariable
				if string.sub(text, i, i+1) == ".." then
					io.write(colours.bright .. colours.cyan .. "..")
					i = i + 2
				elseif hWord then
					if l["wordColours"][hWord] then
						io.write(l["wordColours"][hWord], hWord)
						i = i + string.len(hWord)
					elseif hFunction then
						io.write(c.func2, hFunction)
						i = i + string.len(hFunction)
					elseif hVariable then
						io.write(c.variable, hVariable)
						i = i + string.len(hVariable)
					else
						io.write(c.regular, hWord)
						i = i + string.len(hWord)
					end
				elseif hString then
					io.write(c.string, hString)
					i = i + string.len(hString)
				elseif hComment then
					io.write(c.comment, hComment)
					i = i + string.len(hComment)
				else
					io.write(c.regular)
					if y == "-" then
						io.write(c.math)
					end
					io.write(y)
					i = i + 1
				end
			end
		end
		io.write(c.regular)
	elseif fileType == "md" then
		local reg = c.regular
		if string.match(text, "^#+ ") then
			reg = c.heading
		end
		local i = 1
		while i <= string.len(text) do
			local bold = string.match(text, "^%*%*..-%*%*", i)
			local italic = string.match(text, "^_..-_", i)
			local boldItalic = string.match(text, "^%*%*_..-_%*%*", i) or string.match(text, "^_%*%*..-%*%*_", i)
			local link1, link2 = string.match(text, "^%((.-)%)%[(.-)%]", i)
			local bullet = string.match(text, "^%* ", i) or string.match(text, "^%d+%. ", i)

			if bullet then
				io.write(c.bullet, bullet)
				i = i + string.len(bullet)
			elseif link1 and link2 then
				io.write(reg, "(")
				syntax.write(link1)
				io.write(reg, ")[", c.link, colours.underscore .. "", link2, reg, "]")
				i = i + 4 + string.len(link1) + string.len(link2)
			elseif boldItalic then
				io.write(c.boldItalic, boldItalic)
				i = i + string.len(boldItalic)
			elseif bold then
				io.write(c.bold, bold)
				i = i + string.len(bold)
			elseif italic then
				io.write(c.italic, italic)
				i = i + string.len(italic)
			else
				io.write(reg .. string.sub(text, i, i))
				i = i + 1
			end
		end
	else
		io.write(c.regular, text)
	end
end

return syntax
