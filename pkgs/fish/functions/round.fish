function round
	argparse -n 'round' -i 'p/precision=!_validate_int' -- $argv
	or return 1;

	set -l value (string trim -- $argv)
	if [ -z $value ]
		echoerr 'round: no input'
		return 1
	end

	set -l precision 1
    if set -q _flag_precision
		set precision (math "10 ^ $_flag_precision")
	end

	set value (math "$value * $precision")
	echo (math "round($value) / $precision")
end
