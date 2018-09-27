#!/bin/bash

# get os version (source: https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script)

if [ -f /etc/os-release ]; then
	# freedesktop.org and systemd
	. /etc/os-release
	OS=$NAME
elif type lsb_release >/dev/null 2>&1; then
	# linuxbase.org
	OS=$(lsb_release -si)
	VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
	# For some versions of Debian/Ubuntu without lsb_release command
	. /etc/lsb-release
	OS=$DISTRIB_ID
elif [ -f /etc/debian_version ]; then
	# Older Debian/Ubuntu/etc.
	OS=Debian
elif [ -f /etc/SuSe-release ]; then
	# Older SuSE/etc.
	OS=SuSe
elif [ -f /etc/redhat-release ]; then
	# Older Red Hat, CentOS, etc.
	OS=redhat
else
	# Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
	OS=$(uname -s)
fi

if [ "$OS" = "Debian GNU/Linux" -o "$OS" = "Debian" -o "$OS" = "Ubuntu" -o "$OS" = "Elementy OS" ]; then # check compatibility
	sudo echo > /dev/null
	sudo apt update
	sudo apt install lua5.3 luarocks -y
	sudo luarocks install lua-term
	oldDir=`pwd`
	cd /tmp
	git clone https://github.com/BEN1JEN/lua-nano
	cd lua-nano
	chmod +x main.lua
	sudo cp main.lua /usr/bin/lano
	sudo mkdir /usr/local/lib/lua/5.3/
	sudo cp -r libs /usr/local/lib/lua/5.3/
	#cd ..
	#rm -rf lua-nano
	#cd "$oldDir"
	#echo "installation complete"
fi
