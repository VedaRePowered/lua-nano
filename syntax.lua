local syntax = {}
local c = {
	flow = colours.bright .. colours.green,
	func = colours.magenta .. "",
	bracket = colours.dim .. colours.yellow,
	logic = colours.yellow .. "",
	math = colours.bright .. colours.yellow,
	comment = colours.bright .. colours.black,
	keyword = colours.green .. "",
	modify = colours.bright .. colours.blue,
	string = colours.blue .. "",
	number = colours.cyan .. "",
	variable = colours.dim .. colours.red,
	regular = colours.reset .. ""
}

local wordColours = {
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
	match = c.keyword,
	insert = c.keyword,
	remove = c.keyword,
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

wordColours["if"] = c.flow
wordColours["for"] = c.flow
wordColours["while"] = c.flow
wordColours["in"] = c.flow
wordColours["then"] = c.flow
wordColours["do"] = c.flow
wordColours["else"] = c.flow
wordColours["end"] = c.flow

wordColours["local"] = c.modify
wordColours["return"] = c.modify
wordColours["require"] = c.modify

wordColours["or"] = c.logic
wordColours["and"] = c.logic
wordColours["not"] = c.logic

wordColours["doFile"] = c.keyword
wordColours["function"] = c.func

local symbolColours = {}
symbolColours["("] = c.bracket
symbolColours[")"] = c.bracket
symbolColours["["] = c.bracket
symbolColours["]"] = c.bracket
symbolColours["{"] = c.bracket
symbolColours["}"] = c.bracket
symbolColours["+"] = c.math
symbolColours["*"] = c.math
symbolColours["/"] = c.math
symbolColours["^"] = c.math
symbolColours["%"] = c.math
symbolColours[","] = c.variable
symbolColours["#"] = c.variable
symbolColours["."] = c.keywords
symbolColours["="] = c.logic
symbolColours[">"] = c.logic
symbolColours["<"] = c.logic
symbolColours["~"] = c.logic
symbolColours["1"] = c.number
symbolColours["2"] = c.number
symbolColours["3"] = c.number
symbolColours["4"] = c.number
symbolColours["5"] = c.number
symbolColours["6"] = c.number
symbolColours["7"] = c.number
symbolColours["8"] = c.number
symbolColours["9"] = c.number
symbolColours["0"] = c.number

function syntax.write(text)
	i = 1
	while i <= string.len(text) do
		local str = string.sub(text, i, string.len(text))
		local y = string.sub(text, i, i)
		local colour = symbolColours[y]
		if colour then
			io.write(colour)
			io.write(y)
			i = i + 1
		else
			--print(str)
			local wordF, wordT = string.find(str, "^[_a-zA-Z][_a-zA-Z1-9]*")
			local stringF, stringT = string.find(str, "^[\"\'].*[\"\']")
			local commentF, commentT = string.find(str, "^%-%-.*")
			local functionF, functionT = string.find(str, "^[_a-zA-Z][_a-zA-Z1-9]*%(.*%)")
			if wordF then
				local hWord = string.sub(str, wordF, wordT)
				io.write(c.regular)
				if wordColours[hWord] then
					io.write(wordColours[hWord])
				end
				io.write(hWord)
				i = i + string.len(hWord)
			elseif stringF then
				local hString = string.sub(str, stringF, stringT)
				io.write(c.string, hString)
				i = i + string.len(hString)
			elseif commentF then
				local hComment = string.sub(str, commentF, commentT)
				io.write(c.comment, hComment)
				i = i + string.len(hComment)
			elseif functionF then
				local hFunction = string.sub(str, functionF, functionT)
				io.write(c.func, hFunction)
				i = i + string.len(hFunction)
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
end

return syntax
