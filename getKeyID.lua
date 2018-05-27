function getKey()
	os.execute("stty cbreak </dev/tty >/dev/tty 2>&1") 
	local key = io.read(1) 
	os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
	return key
end

print(string.byte(getKey()))
