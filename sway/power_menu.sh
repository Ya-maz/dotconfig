#!/bin/bash

CHOICE=$(echo -e "Выключить\nПерезагрузка\nСон\nВыход" | wofi --show dmenu --prompt "Power")

case "$CHOICE" in
    "Выключить")
        systemctl poweroff
        ;;
    "Перезагрузка")
        systemctl reboot
        ;;
    "Сон")
        systemctl suspend
        ;;
    "Выход")
        swaymsg exit
        ;;
esac

