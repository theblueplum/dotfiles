function fish_mode_prompt; end

function fish_prompt
    set -l command_status $status;

	set -l duration '';
	begin
		[ $CMD_DURATION -gt 700 ]; and set -l seconds \
			"$(round -p 2 (math $CMD_DURATION / 1000 % 60))s";
		[ $CMD_DURATION -gt 60000 ]; and set -l minutes \
			"$(round (math $CMD_DURATION / 60000))m";
		
		[ $CMD_DURATION -gt 700 ]; and set duration (string join '' -- \
			 (set_color normal) \
			 'took ' \
			 (set_color yellow) \
			 (string join ' ' -- $minutes $seconds) \
		);
	end

    set -l mode
	begin
		function color_and_wrap -a color char
			string join '' -- (set_color --bold $color) "[$char]"
			functions -e color_and_wrap
		end

		set -l indicator \
			(switch $fish_bind_mode
				case default;     color_and_wrap red 'N'
				case insert;      color_and_wrap cyan 'I'
				case replace_one; color_and_wrap green 'R'
				case visual;      color_and_wrap brmagenta 'V'
				case '*';         color_and_wrap red '?'
			end) 
		set mode (string join '' -- $indicator (set_color normal) ' ')
	end

	set -l nix_shell
	begin
		set -l packages (string split ' ' -- $FISH_NIX_PACKAGES)

		if [ -n "$IN_NIX_SHELL" ]
			set nix_shell "$(set_color brblue)  "
			
			set -ql packages[1]; and set nix_shell "$nix_shell($packages[1]";
			set -ql packages[2]; and set nix_shell "$nix_shell, $packages[2]";
			set -ql packages[3]; and not set -ql packages[4]; and set nix_shell "$nix_shell, $packages[3]";

			set -ql packages[4]; and set nix_shell "$nix_shell, +$(math (count $packages) - 2) more"

			set -ql packages[1]; set nix_shell "$nix_shell) "
		end
	end

	set -l cursor_color (set_color green)
    [ $command_status -ne 0 ]; and set -l cursor_color (set_color red)

    set -l pwd (string join '' -- \
		$cursor_color \
		(prompt_pwd -D 2 -d 1) \
		(set_color normal) \
	);

	[ (fish_vcs_prompt) ]; and set -l git (string join '' -- \
		(set_color yellow) \
		' 󰘬 ' \
		(string sub -s 3 -e -1 -- (fish_vcs_prompt)) \
		' ' \
	);

	[ $command_status -ne 0 ]; and set -l last_status "[$command_status]";

	[ -n $duration ]; and echo $duration
    string join '' -- $mode $nix_shell $pwd $git $cursor_color $last_status '|> '
end
