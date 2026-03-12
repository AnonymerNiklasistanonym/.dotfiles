#!/usr/bin/env sh

code --list-extensions > extensions.txt
cp ~/.config/"Code - OSS"/User/keybindings.json vscode/keybinds.json
cp ~/.config/"Code - OSS"/User/settings.json vscode/settings.json
