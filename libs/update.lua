function update(char) -- update function
	local byte = string.byte(char) -- get the ASCII byte for the charecter just pressed
	if byte == 27 then -- if its 27, meaning a ctrl+key
		local byte = string.byte(io.read(1)) -- get the next byte in stin buffer
		if byte == 91 then -- if it's a 91, the [ key, it's an arrow
			local arrow = io.read(1) -- read in the direction
			if arrow == "A" then -- up
				if cursor.y > 1 then -- if the cursor isn't at the begining of the file
					cursor.move(0, -1) -- move the cursor
				end
			elseif arrow == "B" then -- down
				if cursor.y < #buffer.getLines() then -- if the cursor isn't at the end of the file
					cursor.move(0, 1) -- move the cursor
				end
			elseif arrow == "C" then -- right
				local line = buffer.getLines(cursor.y)[1] -- get the current line
				if cursor.x <= string.len(line) then -- make sure the cursor isn't at the end of the line
					if string.sub(line, cursor.x, cursor.x+3) == "    " then -- jump over tabs
						cursor.move(4, 0) -- if it is a tab, go four characters
					else
						cursor.move(1, 0) -- otherwise go one character
					end
				else -- otherwise goto the next line at the start
					if buffer.getLines(cursor.y+1)[1] then -- make sure the cursor isn't at the end of the file
						cursor.jump(1, cursor.y+1) -- move the cursor
					end
				end
			elseif arrow == "D" then -- left
				local line = buffer.getLines(cursor.y)[1] -- get the current line
				if cursor.x > 1 then -- make sure the cursor isn't at the start of the line
					if string.sub(line, cursor.x-4, cursor.x-1) == "    " then -- check if there's a tab before the cursor
						cursor.move(-4, 0) -- go back four characters for a tab,
					else
						cursor.move(-1, 0) -- and one by default
					end
				else -- otherwise go up a line
					if buffer.getLines(cursor.y-1)[1] then -- make sure the cursor isn't at the top of the file
						cursor.jump(string.len(buffer.getLines(cursor.y-1)[1])+1, cursor.y-1) -- move up and to the end
					end
				end
			end
		else
			controllCombos(byte-64) -- if it's not an arrow, do the correct keyboard shortcut
		end
	elseif byte == 127 then -- backspace key
		local line = buffer.getLines(cursor.y)[1] -- get the current line
		if cursor.x > 1 then -- if the cursor is past the start of the line
			if string.sub(line, cursor.x-4, cursor.x-1) == "    " then -- special case for tabs
				buffer.erase(4) -- erase the whole tab
				cursor.move(-4, 0) -- move back to the start of the tab
			else -- if it's not a tab
				buffer.erase() -- erase one character
				cursor.move(-1, 0) -- move back to the start of said charecter
			end
		elseif cursor.y > 1 then -- if the cursor is at the start of the line, and past the start of the file
			local ncx = string.len(buffer.getLines(cursor.y-1)[1])+1 -- get the length of the line above the current line
			buffer.eraseLine() -- delete the current line
			term.cursor.jump(30, 50) -- um... idk
			cursor.jump(ncx, cursor.y-1) -- goto the end of the above line
			draw.drawAll() -- redraw everything?
		end
	elseif byte == 9 then -- tab key
		buffer.writeString("    ", cursor.y, cursor.x) -- write the tab character
		cursor.move(4, 0) -- move the cursor to the end of the tab
	elseif byte == 10 then -- enter key
		buffer.newLine() -- make a new line, chopping the current line where the cursor is
		cursor.jump(1, cursor.y+1) -- jump to the begining of the new line
		draw.drawAll() -- redraw everything
	else -- any other key
		if controllCombos(byte) then -- check if the key isn't being used by control combos
			buffer.writeString(char, cursor.y, cursor.x) -- write the charecter
			cursor.move(1, 0) -- move to the end of the new charecter
		end
	end

	local tmpLen = 1+string.len(buffer.getLines(cursor.y)[1]) -- temparary length of current line
	-- limit the cursor
	if cursor.x > tmpLen then
		cursor.jump(tmpLen, cursor.y)
	end
	if cursor.x < 1 then
		cursor.jump(1, cursor.y)
	end

end

-- keyboard shortcuts
function controllCombos(byte)
	local r = false -- return variable, is true if the key is not bound
	if byte == conf.getKey("refresh") then -- refreash the screen
		draw.drawAll()
	elseif byte == conf.getKey("close") then -- close the editor
		running = false
	elseif byte == conf.getKey("save") then -- save the current buffer
		if not draw.save() then
			buffer.write()
		else
			status.set("Canceled save.")
		end
	elseif byte == conf.getKey("find") then -- find in the current buffer
		local text = draw.find()
		find.find(text, find.regularFindFunction)
		draw.drawAll()
	elseif byte == conf.getKey("replace") then -- replace in the current buffer
		local text, replace = draw.replace()
		find.replace(text, replace, find.regularFindFunction, find.regularReplaceFunction)
	elseif byte == conf.getKey("advFind") then -- advanced find
		local text = draw.find()
		find.find(text, find.advancedFindFunction)
		draw.drawAll()
	elseif byte == conf.getKey("advReplace") then -- advanved replace
		local text, replace = draw.replace()
		find.replace(text, replace, find.advancedFindFunction, find.advancedReplaceFunction)
	elseif byte == conf.getKey("next") then -- goto next found instance
		find.next()
	else
		r = true -- otherwise return true for key not used
	end
	return r -- return the return variable
end

return update -- return the main update function
