#!/bin/sh
# Вставка буфера обмена Windows в tmux одним куском (bracketed paste).
# -Raw: не разбивать на строки; tr -d '\r': убрать CR из CRLF,
# иначе переводы строк Windows ломают продолжения команд ("\").
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -Command 'Get-Clipboard -Raw' \
	| tr -d '\r' | tmux load-buffer -