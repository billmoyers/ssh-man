#!/bin/bash

keyfiles() {
	find "$HOME/.ssh/" -name '*.pub' | sort | grep -v revoke | while read f; do echo -n "$f "; ssh-keygen -lf "$f"; done | grep "$PATTERN" | awk '{print $1}' | sort | uniq
}

completion_tokens() {
	cur="$1"
	for f in $(keyfiles); do
		echo "$f"
		echo "$f" | sed -e "s/[^a-zA-Z0-9_]/\n/g"
		ssh-keygen -lf "$f" | awk '{print $3}' | sed -e "s/[^a-zA-Z0-9_]/\n/g"
	done | sort | uniq | grep "^$cur"
}

_ssh-man() {
	local cur
	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	case "$cur" in
		*)
			COMPREPLY=($(completion_tokens "$cur"))
			;;
	esac
	return 0
}

complete -F _ssh-man ssh-man

export SSH_MAN_PS1='\[\033[00;32m\][ssh:`ssh-man --ids`]\[\033[00m\]'
