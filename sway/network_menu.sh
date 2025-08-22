#!/bin/bash

# Список действий
CHOICE=$(echo -e "Wi-Fi GUI\nWi-Fi TUI\nBluetooth" | wofi --dmenu --prompt "Network")

case $CHOICE in
    "Wi-Fi GUI")
        swaymsg exec nm-connection-editor
        ;;
    "Wi-Fi TUI")
        swaymsg exec alalacritty -e nmtui
        ;;
    "Bluetooth")
        swaymsg exec blueman-manager
        ;;
esac

