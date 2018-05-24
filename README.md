# lua-nano
nano writen in lua.

### _WARNING: WIP_
this project is only in the preveiw stages as indecated by the 'p' before the version.

### how to use
currently lua nano only has 2 keyboard shortcuts:
* ^O writes the current buffer to a file
* ^X closes the editor **_WITHOUT_** saving

other than that the editor uses standered up/down/left/right to move the cursor and typeing works fine. However currently lua nano does not support the enter key.

### downloading
There is no easy way of getting a release currently.
You can run it if you have lua5.1 installed and the luarocks pakage `lua-term`. Then, in the projects directory, simply type `./main.lua` to open the editor or `./main.lua file.txt` to open a spicific file.
