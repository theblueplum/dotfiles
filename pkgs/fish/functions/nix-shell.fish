function nix-shell
	set -l _argv (string split ' ' -- $argv);

	if contains -- '-q' $_argv; or contains -- '--query' $_argv
		for pkg in (string split ' ' -- $FISH_NIX_PACKAGES)
			echo $pkg
		end
		return 0;
	end
	
	function package_flag -a arg
		contains -- '-p' $arg
		or contains -- '--packages' $arg
	end

	if not command -q nix-shell; or not package_flag $argv
		command nix-shell --run fish $argv;
		return $status;
	end

	set -l packages
	set -l reading_packages 0
	for arg in $_argv
		if [ $reading_packages -ne 0 ]
			if string match -r '^-'
				set reading_packages 0
			else
				not contains -- $arg (string split ' ' -- $FISH_NIX_PACKAGES); 
				and set packages $packages $arg
			end
		else
			package_flag $arg; and set reading_packages 1
		end
	end

	set -l prev_packages $FISH_NIX_PACKAGES;
	set -x FISH_NIX_PACKAGES $prev_packages $packages;

	command nix-shell --run fish $argv;
	set -l nix_status $status;

	set -x FISH_NIX_PACKAGES $prev_packages;

	return $nix_status
end
