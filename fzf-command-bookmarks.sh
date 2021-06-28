#!/usr/bin/env bash

hash fzf 2> /dev/null || echo "[fzf-command-bookmarks] fzf binary not found!"
hash highlight 2> /dev/null || echo "[fzf-command-bookmarks] highlight binary not found!"

export FZF_COMMAND_BOOKMARKS_FILE="${HOME}/.fzf_command_bookmarks.txt"
export FZF_COMMAND_BOOKMARKS_ADD="\C-k"
export FZF_COMMAND_BOOKMARKS_SHOW="\C-@"


# Readline magic helper for bash
# Found here: https://github.com/junegunn/fzf/wiki/examples#with-write-to-terminal-capabilities
function __ehc() {
	if [[ -n $1 ]]; then
		bind '"\er": redraw-current-line'
		bind '"\e^": magic-space'
		READLINE_LINE=${READLINE_LINE:+${READLINE_LINE:0:READLINE_POINT}}${1}${READLINE_LINE:+${READLINE_LINE:READLINE_POINT}}
		READLINE_POINT=$(( READLINE_POINT + ${#1} ))
	else
		bind '"\er":'
		bind '"\e^":'
	fi
}

function _fzf_command_bookmark_show() {
	local result=$(cat $FZF_COMMAND_BOOKMARKS_FILE | \
		fzf --delimiter "##" --print0 --height 40% --header Bookmarks --with-nth -1 \
		--preview 'echo -e {-1}; echo; echo -E {..-2} | highlight -S bash -O ansi' \
		--preview-window=wrap --tac | sed 's/\(.*\)##.*/\1/')

	if [ -z "$ZSH_VERSION" ]; then
		__ehc "$result"
	else
		LBUFFER="$LBUFFER$result"
		zle reset-prompt
	fi
}

function _fzf_command_bookmark_add() {
	local CMD="$1"
	local TITLE="$2"
	local REPLY

	if [ -z "$CMD" ]; then
		if [ -z "$ZSH_VERSION" ]; then
			echo -en "\nCommand to add: "
			read -er CMD
		else
			autoload -Uz read-from-minibuffer
			read-from-minibuffer "Command to add: " $LBUFFER $RBUFFER
			CMD="$REPLY"
		fi
	fi

	if [ -z "$TITLE" ]; then
		if [ -z "$ZSH_VERSION" ]; then
			echo -n "Command title: "
			read -er TITLE
		else
			zle -I
			read -r "TITLE?Command title: " < /dev/tty
		fi
	fi

	echo -E "${CMD}##${TITLE}" >> $FZF_COMMAND_BOOKMARKS_FILE
}


if hash bind 2> /dev/null; then
	bind -x "\"$FZF_COMMAND_BOOKMARKS_ADD\":_fzf_command_bookmark_add"
	bind -x "\"$FZF_COMMAND_BOOKMARKS_SHOW\":_fzf_command_bookmark_show"
else
	zle -N fzf-command-bookmark-add-widget _fzf_command_bookmark_add
	zle -N fzf-command-bookmark-show-widget _fzf_command_bookmark_show

	bindkey "$FZF_COMMAND_BOOKMARKS_ADD" fzf-command-bookmark-add-widget
	bindkey "$FZF_COMMAND_BOOKMARKS_SHOW" fzf-command-bookmark-show-widget
fi
