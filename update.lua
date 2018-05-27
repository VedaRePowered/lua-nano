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
			if cursor.x <= string.len(line) then
				if string.sub(line, cursor.x, cursor.x+3) == "    " then
					cursor.move(4, 0)
				else
					cursor.move(1, 0)
				end
			else
				if buffer.getLines(cursor.y+1)[1] then
					cursor.jump(1, cursor.y+1)
				end
			end
		elseif arrow == "D" then
			local line = buffer.getLines(cursor.y)[1]
			if cursor.x > 1 then
				if string.sub(line, cursor.x-4, cursor.x-1) == "    " then
					cursor.move(-4, 0)
				else
					cursor.move(-1, 0)
				end
			else
				if buffer.getLines(cursor.y-1)[1] then
					cursor.jump(string.len(buffer.getLines(cursor.y-1)[1])+1, cursor.y-1)
				end
			end
		end
	elseif byte == conf.getKey("close") then
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
		elseif cursor.y > 1 then
			local ncx = string.len(buffer.getLines(cursor.y-1)[1])+1
			buffer.eraseLine()
			term.cursor.jump(30, 50)
			cursor.jump(ncx, cursor.y-1)
			draw.drawAll()
		end
	elseif byte == conf.getKey("save") then
		if not draw.save() then
			buffer.write()
		else
			status.set("Canceled save.")
		end
	elseif byte == 9 then
		buffer.writeString("    ", cursor.y, cursor.x)
		cursor.move(4, 0)
	elseif byte == 10 then
		buffer.newLine()
		cursor.jump(1, cursor.y+1)
		draw.drawAll()
	elseif byte == conf.getKey("refresh") then
		draw.drawAll()
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
