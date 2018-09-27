local cursor = {} -- cursor namespace
-- keep track of the absolute cursor x and y
cursor.x = 1
cursor.y = 1

function cursor.move(x, y) -- function to move the cursor
	cursor.x = cursor.x + x
	cursor.y = cursor.y + y
end

function cursor.jump(x, y) -- function to teleport the cursor
	cursor.x = x
	cursor.y = y
end

return cursor -- return namespace
