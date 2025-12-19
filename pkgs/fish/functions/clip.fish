function clip
	if not command -q xclip
		echoerr "clip: xclip is not available on this system"
		return 1
	end

	if not tty -s
		read -zl stdin
		echo $stdin | xclip -selection clipboard
		return $status
	end

	if string length -qV -- (string trim -- $argv)
		echo $argv | xclip -selection clipboard
		return $status
	end

	xclip -selection clipboard -o
end
