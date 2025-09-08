#!/bin/bash

# Создаем новую сессию tmux
tmux new-session -d -s intech

# Разделить первое окно на два панела (вертикольно)
tmux split-window -v -t intech:1
tmux split-window -v -t intech:1
tmux rename-window -t intech:1 'run+vpn'

# Перейти в первую директорию и выполнить команду
tmux send-keys -t intech:1.1 'cd /home/almaz/javascript/react_projects/intech/portal-ui' C-m
tmux send-keys -t intech:1.1 'export NODE_OPTIONS="--max-old-space-size=4096"' C-m

tmux send-keys -t intech:1.2 'cd /home/almaz/javascript/react_projects/intech/portal-ui-components' C-m

tmux send-keys -t intech:1.3 'cd /home/almaz/Documents/jobs/intech/openvpn_config/yahinar/nov8_2024_worked' C-m
tmux send-keys -t intech:1.3 'sudo openvpn --config config.ovpn' C-m

# Создаем новое окно и переходим во вторую директорию
tmux new-window -t intech:2
tmux send-keys -t intech:2 'cd /home/almaz/javascript/react_projects/intech/portal-ui' C-m
tmux send-keys -t intech:2 'git branch' C-m
tmux rename-window -t intech:2 'app'

tmux new-window -t intech:3
tmux send-keys -t intech:3 'cd /home/almaz/javascript/react_projects/intech/portal-ui-components' C-m
tmux send-keys -t intech:3 'git branch' C-m
tmux rename-window -t intech:3 'monorep'

tmux new-window -t intech:4
tmux send-keys -t intech:4 'cd /home/almaz/notes' C-m
tmux send-keys -t intech:4 'nn index.md' C-m
tmux rename-window -t intech:4 'note'

tmux new-window -t intech:5
tmux split-window -v -t intech:5
tmux rename-window -t intech:5 'music'

tmux send-keys -t intech:5.1 'cmus' C-m

tmux send-keys -t intech:5.2 'cava' C-m

tmux new-window -t intech:6
tmux send-keys -t intech:6 'btop' C-m
tmux rename-window -t intech:6 'btop'

tmux new-window -t intech:7
tmux rename-window -t intech:7 'freeuse'

# Подключаемся к сессии
tmux attach-session -t intech
