#!/bin/bash

# dirs=("cat" "dog" "mouse" "frog")
dirs=("./resources/.config/awesome")

for str in ${dirs[@]}; do
	config_files=$(find $str -type f)
	for cfg_file in $config_files; do
		echo $cfg_file
	done
done

ln -f ~/.config/awesome/rc.lua ./resources/.config/awesome/rc.lua