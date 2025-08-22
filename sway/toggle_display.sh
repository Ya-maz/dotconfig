#!/bin/sh

# Настройки
INTERNAL="eDP-1"
EXTERNAL="DP-1"
STATE_FILE="$HOME/.config/sway/display_state"

# Проверка, что мы в сессии Sway
if [ -z "$SWAYSOCK" ]; then
    exit 1
fi

# Инициализация файла состояния
if [ ! -f "$STATE_FILE" ]; then
    echo 0 > "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")

# Переключение режимов
case "$STATE" in
    0)
        # Только внешний монитор
        swaymsg output "$INTERNAL" disable
        swaymsg output "$EXTERNAL" enable resolution 1920x1200 position 0 0
        NEXT=1
        ;;
    1)
        # Оба монитора: внешний слева, ноутбук справа
        swaymsg output "$INTERNAL" enable resolution 1920x1080 position 1920 0
        swaymsg output "$EXTERNAL" enable resolution 1920x1200 position 0 0
        NEXT=0
        ;;
    *)
        # На случай ошибки — включаем оба
        swaymsg output "$INTERNAL" enable resolution 1920x1080 position 1920 0
        swaymsg output "$EXTERNAL" enable resolution 1920x1200 position 0 0
        echo 1 > "$STATE_FILE"
        exit 0
        ;;
esac

# Сохраняем следующее состояние
echo "$NEXT" > "$STATE_FILE"
