status = {} -- status namespace
currentStatus = "Welcome to lua nano!" -- reset current status on startup

function status.get() -- get current status
	return "[" .. currentStatus .. "]"
end

function status.set(new) -- set status message
	currentStatus = new
end

return status -- return namespace
