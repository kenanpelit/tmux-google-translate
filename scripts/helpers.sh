#!/usr/bin/env bash

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value=$(tmux show-option -gqv "$option")

  if [[ -z "$option_value" ]]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

cmd_exists() {
  local cmd="$1"

  if type "$cmd" >/dev/null 2>&1; then
    return 0
  else
    [[ -x "${ANTIBODY_HOME}/soimort-translate-shell/translate" ]] && return 0
  fi

  return 1
}

cmd_path() {
  local cmd="trans"

  if type "$cmd" >/dev/null 2>&1; then
    echo "$cmd"
  else
    cmd="${ANTIBODY_HOME}/soimort-translate-shell/translate"

    [[ -x "$cmd" ]] && echo "$cmd"
  fi
}

# Ensures a message is displayed for 5 seconds in tmux prompt.
# Does not override the 'display-time' tmux option.
display_msg() {
  local message="$1"

  # display_duration defaults to 5 seconds, if not passed as an argument
  if [ "$#" -eq 2 ]; then
    local display_duration="$2"
  else
    local display_duration="5000"
  fi

  # saves user-set 'display-time' option
  local saved_display_time=$(get_tmux_option "display-time" "750")

  # sets message display time to 5 seconds
  tmux set-option -gq display-time "$display_duration"

  # displays message
  tmux display-message "$message"

  # restores original 'display-time' value
  tmux set-option -gq display-time "$saved_display_time"
}

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=sh sw=2 ts=2 et
