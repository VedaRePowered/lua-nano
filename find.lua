local find = {}
local found = {}
local instance = 1

function find.regularFindFunction(line, text, y, x)
	local r = nil
	if string.sub(line, 1, string.len(text)) == text then
		r = {x, y, text}
	end
	return r
end

function find.advancedFindFunction(line, text, y, x)
	local r = nil
	local mat = table.pack(string.match(line, "^(" .. text .. ")"))
	if mat[1] then
		r = {x, y, mat[1]}
		table.remove(mat, 1)
		table.insert(r, mat)
	end
	return r
end

function find.regularReplaceFunction(replace, y, x, mat, old)
	buffer.writeString(replace, y, x)
end

function find.advancedReplaceFunction(replace, y, x, mat)
	local err, func = pcall(load("function a(mat) return " .. replace .. "end return a"))
	if err then
		local err, str = pcall(func, mat)
		if err then
			buffer.writeString(str, y, x)
		else
			if not str then str = "nil" end
			status.set("lua RUN error in replace: " .. str)
			draw.status()
			getKey()
		end
	else
		if not str then str = "nil" end
		status.set("lua LOAD error in replace: " .. str)
		draw.status()
		getKey()
	end
end

function find.find(text, findFunction)
	found = {}
	instance = 1
	status.set("Searching...")
	for n, l in ipairs(buffer.getLines()) do
		for i = 1, string.len(l) do
			found[#found+1] = findFunction(string.sub(l, i, string.len(l)), text, n, i)
		end
	end
	find.jump()
	status.set("Found " .. #found .. " occurences")
	draw.drawAll()
end

function find.replace(text, replace, findFunction, replaceFunction)
	local replaced = {}
	find.find(text, findFunction)
	for i = 1, #found do
		draw.currentLine()
		io.write(colours.reverse .. found[instance][3] .. colours.reset)
		status.set("Replace instance #" .. instance .. "? [y/N]")
		draw.status()
		if string.lower(getKey()) == "y" then
			replaced[#replaced+1] = instance
		end
		find.next()
	end

	local xOffset = 0
	local lastY = -1
	for _, ins in ipairs(replaced) do
		x, y, str = table.unpack(found[ins])
		if lastY ~= y then
			xOffset = 0
		end
		lastY = y
		cursor.jump(x+string.len(str)+xOffset, y)
		buffer.erase(string.len(str))
		cursor.jump(x+xOffset, y)
		replaceFunction(replace, y, x+xOffset, found[4])
		xOffset = xOffset + (string.len(replace)-string.len(str))
	end

	status.set("Replaced " .. #replaced .. " occurences")
	draw.drawAll()
end

function find.jump()
	if found[instance] then
		cursor.jump(found[instance][1], found[instance][2])
	end
end

function find.next()
	instance = instance + 1
	if instance > #found then
		instance = 1
	end
	status.set("Went to instance #" .. instance)
	find.jump()
end

return find
