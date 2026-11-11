#!/usr/bin/zsh
# Herdr equivalent of ~/.config/tmux/tmux-session-dispensary.sh.
set -eu
setopt pipefail

if (( $# > 1 )); then
  print -u2 -- "Usage: $0 [project-directory]"
  exit 2
fi

if (( $# == 1 )); then
  selected=$1
else
  projects=$(fd . "$HOME/Projects" --type=directory --max-depth=1 --full-path)
  [[ -n $projects ]] || exit 0
  selected=$(print -r -- "$projects" | sed "s|^$HOME/||" | sk --margin 10%) || exit 0
  [[ -n $selected ]] || exit 0
  selected="$HOME/$selected"
fi

if [[ ! -d $selected ]]; then
  print -u2 -- "Project directory does not exist: $selected"
  exit 1
fi

selected=${selected:A}
selected_name=${selected:t}
selected_name=${selected_name//./_}

# Custom popups supply HERDR_BIN_PATH and HERDR_SOCKET_PATH. Keep that
# session context so the picker also works in named/remote Herdr sessions.
herdr_bin=${HERDR_BIN_PATH:-herdr}
workspaces=$("$herdr_bin" workspace list)
workspace_id=$(jq -r --arg label "$selected_name" \
  'first(.result.workspaces[] | select(.label == $label) | .workspace_id) // empty' \
  <<< "$workspaces")

if [[ -n $workspace_id ]]; then
  "$herdr_bin" workspace focus "$workspace_id" > /dev/null
else
  "$herdr_bin" workspace create --cwd "$selected" --label "$selected_name" --focus > /dev/null
fi
