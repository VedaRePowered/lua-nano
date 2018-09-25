list = { -- create a list
    -- fill it here
    a = "hello",
    b = "goodbye",
    c = "other",
    d = "foo",
    e = "bar",
    f = "baz",
    hi = "ben",
    bye = "joe"
}

function say(words) -- make a function for bob to say a word
    print("Bob says: " .. words) -- print bob says: followed by the words
end -- close the function

print("Hello world!") -- write hello world to the console

for i = 1, 10 do -- loop 10 times incrementing i each time
    print(i) -- print i, whitch will go from 1 to 10
end -- close the loop

for k, v in pairs(list) do -- loop thrugh all the items in the list
    say(k .. " is " .. v) -- say what each item is
end -- close the loop
