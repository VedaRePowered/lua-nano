local word = {} -- word namespace
local nonWordCharacters = "\"\'\\/:;,.<>[]{}-_+=)(*&^%$#@!~`| " -- define non-word characters, shuld be a setting eventually

function word.isWordChar(c) -- check if a character if a word, or non-word character
	local r = true -- default to true
	for i = 1, string.len(nonWordCharacters) do -- go through all non-word characters
		if c == string.sub(nonWordCharacters, i, i) then -- test if current char in non-word characters is the input char
			r = false -- if so, we know that the char is not a word character
		end
	end
	return r -- return if the acharacter is
end

function word.isFunctionName(func) -- check if some text is the name of a function
	local done = false -- loop stoper
	local half = false -- have we gotten to a (
	local isF = true -- is the input a function return variable
	local i = 1 -- position in string
	while not done do
		local y = string.sub(func, i, i) -- get a character of the function
		if i > string.len(func) then -- stop if we've reached the end
			done = true
			isF = false
		end
		if y == "(" then -- mark that we're in parameters now
			half = true
		elseif y == ")" and half then -- if we're in perameters, and the current char is a ), stop
			done = true
		else -- make sure the function name is only word-characters
			if not half then -- don't check perameters
				isF = isF and word.isWordChar(y) -- set to false if the function name is not a word
			end
		end
		i = i + 1 -- goto next character
	end
	return isF -- return weather it is a function
end

function word.getFirst(str) -- get first word in a string

	local r = "" -- return variable
	local i = 1 -- position in string
	local y = "a" -- value of that position
	while word.isWordChar(y) do -- keep going until we hit a non-word character
		y = string.sub(str, i, i) -- get the current character
		if word.isWordChar(y) then -- if it is a word character,
			r = r .. y -- then append it to the return variable
		end
		i = i + 1 -- goto next character
	end

	return r -- return first word

end

return word -- return namespace
