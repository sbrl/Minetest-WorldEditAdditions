#!/usr/bin/env bash
# Make sure the current directory is the location of this script to simplify matters
cd "$(dirname "$(readlink -f "$0")")" || { echo "Error: Failed to cd to script directory" >&2; exit 1; };

# To run Luacheck:
# 
# luacheck . --ignore 631 61[124] 412 21[123] --globals minetest worldedit worldeditadditions worldeditadditions_commands worldeditadditions_core vector assert bit it describe bonemeal  --codes -j "$(nproc)" --quiet --exclude-files .luarocks/*
# 
# This is a work-in-progress, as it currently throws an *enormous* number of warnings.

###############################################################################

log_msg() {
	echo "[ $SECONDS ] >>> $*" >&2;
}

# $1 - Command name to check for
check_command() {
	set +e;
	which $1 >/dev/null 2>&1; exit_code=$?
	if [[ "${exit_code}" -ne 0 ]]; then
		log_msg "Error: Couldn't locate $1. Make sure it's installed and in your path.";
	fi
	set -e;
}

###############################################################################

check_command luarocks;

luarocks_root="${PWD}/.luarocks";

# Setup the lua module path
eval "$(luarocks --tree "${luarocks_root}" path)";

mode="${1}"; if [[ "$#" -gt 0 ]]; then shift; fi

run_setup() {
	log_msg "Installing busted";
	
	luarocks --tree "${luarocks_root}" install busted;
}

run_syntax_check() {
	find . -type f -name '*.lua' -not -path '*luarocks*' -not -path '*.git/*' -print0 | xargs -0 -n1 -P "$(nproc)" luac -p;
}

run_test() {
	.luarocks/bin/busted --no-auto-insulate --pattern ".test.lua" .tests;
}

case "${mode}" in
	setup )
		run_setup;
		;;
	
	run )
		if [[ ! -d "${luarocks_root}" ]]; then
			run_setup;
		fi
		run_syntax_check;
		run_test;
		;;
	
	busted )
		.luarocks/bin/busted "${@}";
		;;
	
	* )
		echo -e "Usage:
	path/to/run.sh setup	# Setup to run the tests
	path/to/run.sh run		# Run the tests" >&2;
		;;
esac
