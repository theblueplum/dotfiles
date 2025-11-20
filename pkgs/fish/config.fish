set fish_greeting '( .-.)'

fish_vi_key_bindings

alias cls='clear; and echo $fish_greeting';
alias ...='cd ../..';

set -l directory (status dirname)

[ -f "$directory/prompt.fish" ]; and source "$directory/prompt.fish"
[ -f "$directory/alias.fish" ]; and source "$directory/alias.fish"

if not set -qx SSH_AUTH_SOCK
	set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end
