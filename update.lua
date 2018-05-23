function update(char)
	local byte = string.byte(char)
	if byte == 27 then
		io.read(1)
		local arrow = io.read(1)
		if arrow == "A" then
			if cursor.y > 1 then
				cursor.move(0, -1)
			end
		elseif arrow == "B" then
			if cursor.y < #buffer.getLines() then
				cursor.move(0, 1)
			end
		elseif arrow == "C" then
			cursor.move(1, 0)
		elseif arrow == "D" then
			cursor.move(-1, 0)
		end
	elseif byte == 24 then
		running = false
	else
		buffer.writeString(char, cursor.y, cursor.x)
		cursor.move(1, 0)
	end

end

return update
