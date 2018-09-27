# lua-nano
nano writen in lua.

### _WARNING: WIP_
this project is only in the preveiw stages as indecated by the 'p' before the version.

### how to use
currently lua nano only has 6 keyboard shortcuts:
* ^O writes the current buffer to a file
* ^X closes the editor **_WITHOUT_** saving
* ^F finds text (no regex)
* ^N goes to next instance of found text
* ^G replaces text
* alt-f finds text (with regex)

other than that the editor uses standered up/down/left/right to move the cursor and typeing works fine.

### downloading
There is no easy way of getting a release currently.
You can run it if you have lua5.3 installed and the luarocks pakage `lua-term`. Then, in the projects directory, simply type `./main.lua` to open the editor or `./main.lua file.txt` to open a spicific file.
#### basic debian instlation instructions (with sudo installed):
1. `sudo apt install lua5.3 luarocks`
2. `sudo luarocks install lua-term`
3. `cd /tmp`
4. `git clone https://github.com/BEN1JEN/lua-nano`
5. `cd lua-nano`
6. `chmod +x main.lua`
7. `sudo cp main.lua /usr/bin/lano`
8. `sudo cp -r libs /usr/local/lib/lua/5.3/`
#### other install info:
* Both lua5.3 and luarocks shuld be in most package managers (eg. yum, pacman, rpm, etc...)
* The install.sh script shuld work as long as you have sudo install and are running a debian-based distrobution.
* Currently windows is not, and will not be supported, as the windows command prompt is simply terrible.
### requirements:

* lua 5.3
* lua-term
* linux command shell
