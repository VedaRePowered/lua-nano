function getKey()
	os.execute("stty cbreak </dev/tty >/dev/tty 2>&1") 
	local key = io.read(1) 
	os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
	return key
end
local byte = string.byte(getKey())
if byte == 27 then
	byte = string.byte(io.read(1))
end

print(byte)
