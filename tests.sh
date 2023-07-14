#!/usr/bin/env bash
# Make sure the current directory is the location of this script to simplify matters
cd "$(dirname "$(readlink -f "$0")")" || { echo "Error: Failed to cd to script directory" >&2; exit 1; };

# To run Luacheck:
# 
# luacheck . --ignore 631 61[124] 412 21[123] --globals minetest worldedit worldeditadditions worldeditadditions_commands worldeditadditions_core vector assert bit it describe bonemeal  --codes -j "$(nproc)" --quiet --exclude-files .luarocks/*

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

# Display a url in the terminal.
# See https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda
# $1 - The url to link to.
# $2 - The display text to show.
display_url() {
	local URL_START='\e]8;;';
	#shellcheck disable=SC1003
	local URL_DISPLAY_TEXT='\e\\';
	#shellcheck disable=SC1003
	local URL_END='\e]8;;\e\\';
	
	url="$1";
	display_text="$2";
	
	if [[ -z "$display_text" ]]; then
		display_text="${url}";
	fi
	
	echo -e "${URL_START}${url}${URL_DISPLAY_TEXT}${display_text}${URL_END}";
}

###############################################################################

check_command luarocks;

luarocks_root="${PWD}/.luarocks";

# Setup the lua module path
if [[ "${OSTYPE}" == *"msys"* ]]; then
	PATH="$(luarocks --tree "${luarocks_root}" path --lr-bin):${PATH}";
	LUA_PATH="$(luarocks --tree "${luarocks_root}" path --lr-path);init.lua;./?.lua;${LUA_PATH}";
	LUA_CPATH="$(luarocks --tree "${luarocks_root}" path --lr-cpath);./?.so;${LUA_CPATH}";
else
	eval "$(luarocks --tree "${luarocks_root}" path)";
fi

export PATH LUA_PATH LUA_CPATH;

mode="${1}"; if [[ "$#" -gt 0 ]]; then shift; fi

run_setup() {
	log_msg "Installing busted";
	
	luarocks --tree "${luarocks_root}" install busted;
	if [[ "${OSTYPE}" != *"msys"* ]]; then
		luarocks --tree "${luarocks_root}" install luacov;
		luarocks --tree "${luarocks_root}" install cluacov;
		luarocks --tree "${luarocks_root}" install luacov-html;
	fi
}

run_syntax_check() {
	find . -type f -name '*.lua' -not -path '*luarocks*' -not -path '*.git/*' -print0 | xargs -0 -n1 -P "$(nproc)" luac -p;
}

run_test() {
	if [[ -r "luacov.stats.out" ]]; then rm "luacov.stats.out"; fi
	if [[ -r "luacov.report.out" ]]; then rm "luacov.report.out"; fi
	if [[ -d "luacov-html" ]]; then rm -r "luacov-html"; fi
	
	busted_path=".luarocks/bin/busted";
	if [[ ! -r "${busted_path}" ]]; then
		busted_path=".luarocks/bin/busted.bat";
	fi
	if [[ ! -r "${busted_path}" ]]; then
		echo "Error: Failed to find busted at .luarocks/bin/busted or .luarocks/bin/busted.bat" >&2;
		exit 1;
	fi
	
	if [[ "${OSTYPE}" == *"msys"* ]]; then
		"${busted_path}" --no-auto-insulate --pattern ".test.lua" .tests;
	else
		"${busted_path}" --coverage --no-auto-insulate --pattern ".test.lua" .tests;
		
		
		# If it doesn't begin with a dot, then Minetest *will* complain
		if [[ -d "luacov-html" ]]; then
			mv "luacov-html" ".luacov-html";
		fi
		
		# Remove, but only if empty
		if [[ -s "luacov.report.out" ]]; then :
		else rm "luacov.report.out"; fi
		
		echo -e "Output written to $(display_url "file://$PWD/luacov-html/index.html" "./luacov-html/index.html")";
	fi
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
	
	* )
		echo -e "Usage:
	path/to/run.sh setup	# Setup to run the tests
	path/to/run.sh run		# Run the tests" >&2;
		;;
esac
