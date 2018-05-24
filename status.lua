status = {}
currentStatus = "Welcome to lua nano!"

function status.get()
	return "[" .. currentStatus .. "]"
end

function status.set(new)
	currentStatus = new
end

return status
