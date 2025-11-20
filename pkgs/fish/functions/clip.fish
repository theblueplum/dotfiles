function clip
    if not command -q xclip
		echoerr "clip: 'xclip' is not available on this system"
		return 1
	end

	if not tty -s
		set -l stdin
		read stdin -z
	end

	if set -ql stdin
		echo "$stdin" | xclip -selection clipboard
		echo "copied into clipboard (stdin)"
		return 0
	end

	if [ -n "$(string trim -- $argv)" ]
		echo "$argv" | xclip -selection clipboard
		echo "copied into clipboard"
		return 0
	end

	xclip -selection clipboard -o
end

