local word = {}
local nonWordCharacters = "\"\'\\/:;,.<>[]{}-_+=)(*&^%$#@!~`| "

function word.isWordChar(c)
	local r = true
	for i = 1, string.len(nonWordCharacters) do
		if c == string.sub(nonWordCharacters, i, i) then
			r = false
		end
	end
	return r
end

function word.isFunctionName(func)
	local done = false
	local half = false
	local isF = true
	local i = 1
	while not done do
		local y = string.sub(func, i, i)
		if i > string.len(func) then
			done = true
			isF = false
		end
		if y == "(" then
			half = true
		elseif y == ")" and half then
			done = true
		else
			if not half then
				isF = isF and word.isWordChar(y)
			end
		end
		i = i + 1
	end
	return isF
end

function word.getFirst(str)

	local r = ""
	local i = 1
	local y = "a"
	while word.isWordChar(y) do
		y = string.sub(str, i, i)
		if word.isWordChar(y) then
			r = r .. y
		end
		i = i + 1
	end

	return r

end

return word
