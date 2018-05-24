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
			local line = buffer.getLines(cursor.y)[1]
			if string.sub(line, cursor.x, cursor.x+3) == "    " then
				cursor.move(4, 0)
			else
				cursor.move(1, 0)
			end
		elseif arrow == "D" then
			local line = buffer.getLines(cursor.y)[1]
			if string.sub(line, cursor.x-4, cursor.x-1) == "    " then
				cursor.move(-4, 0)
			else
				cursor.move(-1, 0)
			end
		end
	elseif byte == 24 then
		running = false
	elseif byte == 127 then
		local line = buffer.getLines(cursor.y)[1]
		if cursor.x > 1 then
			if string.sub(line, cursor.x-4, cursor.x-1) == "    " then
				buffer.erase(4)
				cursor.move(-4, 0)
			else
				buffer.erase()
				cursor.move(-1, 0)
			end
		end
	elseif byte == 15 then
		draw.save()
		buffer.write()
	elseif byte == 9 then
		buffer.writeString("    ", cursor.y, cursor.x)
		cursor.move(4, 0)
	else
		buffer.writeString(char, cursor.y, cursor.x)
		cursor.move(1, 0)
	end

	local tmpLen = 1+string.len(buffer.getLines(cursor.y)[1])
	if cursor.x > tmpLen then
		cursor.jump(tmpLen, cursor.y)
	end
	if cursor.x < 1 then
		cursor.jump(1, cursor.y)
	end

end

return update
