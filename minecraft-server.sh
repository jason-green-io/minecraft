#!/bin/bash
cd /minecraft

tmux new -s minecraft -d
tmux neww -t minecraft:7 '/minecraft/minecraft-start.sh'
tmux neww -t minecraft:6 '/minecraft/minecraft-twistd.sh'
tmux neww -t minecraft:5 'murmur -ini /minecraft/config/murmur.ini -fg'
tmux neww -t minecraft:8 '/minecraft/minecraft-notify.sh'
tmux neww -t minecraft:9 '/minecraft/minecraft-playeractivity.py'
tmux neww -t minecraft:4 '/minecraft/minecraft-slack.sh'
