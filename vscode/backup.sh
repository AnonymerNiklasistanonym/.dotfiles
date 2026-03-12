#!/usr/bin/env sh

code --list-extensions > extensions.txt
cp ~/.config/"Code - OSS"/User/keybindings.json keybindings.json
cp ~/.config/"Code - OSS"/User/settings.json settings.json
