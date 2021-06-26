#!/usr/bin/env bash
# Make sure the current directory is the location of this script to simplify matters
cd "$(dirname "$(readlink -f "$0")")" || { echo "Error: Failed to cd to script directory" >&2; exit 1; };

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

mode="${1}"; shift;

run_setup() {
	log_msg "Installing busted";
	
	luarocks --tree "${luarocks_root}" install busted;
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
