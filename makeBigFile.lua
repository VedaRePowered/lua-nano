math.randomseed(os.time())
for i = 1, 128 do
	print(i .. ": ", math.random(1000000000, 9999999999))
end
