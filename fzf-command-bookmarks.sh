#!/usr/bin/env bash

hash fzf 2> /dev/null || echo "[fzf-command-bookmarks] fzf binary not found!"
hash highlight 2> /dev/null || echo "[fzf-command-bookmarks] highlight binary not found!"

export FZF_COMMAND_BOOKMARKS_FILE="${HOME}/.fzf_command_bookmarks.txt"
export FZF_COMMAND_BOOKMARKS_ADD="\C-k"
export FZF_COMMAND_BOOKMARKS_SHOW="\C-@"


function _fzf_command_bookmark_show() {
	cat $FZF_COMMAND_BOOKMARKS_FILE | \
		fzf --delimiter "##" --print0 --height 40% --header Bookmarks --with-nth 2\
		--preview 'echo -e {2}; echo; echo {1} | highlight -S bash -O ansi' \
		--preview-window=wrap --tac
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

	echo -e "${CMD}##${TITLE}" >> $FZF_COMMAND_BOOKMARKS_FILE
}


if hash bind 2> /dev/null; then
	bind -x "\"$FZF_COMMAND_BOOKMARKS_ADD\":_fzf_command_bookmark_add"
	bind -x "\"$FZF_COMMAND_BOOKMARKS_SHOW\":_fzf_command_bookmark_show"
else
	zle -N fzf-command-bookmark-add _fzf_command_bookmark_add
	zle -N fzf-command-bookmark-show _fzf_command_bookmark_show

	bindkey "$FZF_COMMAND_BOOKMARKS_ADD" fzf-command-bookmark-add
	bindkey "$FZF_COMMAND_BOOKMARKS_SHOW" fzf-command-bookmark-show
fi
