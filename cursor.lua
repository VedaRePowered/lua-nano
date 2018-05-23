local cursor = {}
cursor.x = 1
cursor.y = 1

function cursor.move(x, y)
	cursor.x = cursor.x + x
	cursor.y = cursor.y + y
end

function cursor.jump(x, y)
	cursor.x = x
	cursor.y = y
end

return cursor
