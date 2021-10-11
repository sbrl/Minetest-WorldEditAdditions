#!/usr/bin/env bash
set -e;

# current_branch="$(git rev-parse --abbrev-ref HEAD)";
is_main="$(git branch --contains HEAD | awk '/HEAD/ { next } /main/ { print $1 }')";

if [[ "${1}" == "ci" ]] && [[ ! -z "${is_main}" ]]; then
	echo "Skipping build, because this commit does not appear to be on the 'main' branch, and we only deploy commits on the 'main' branch.";
fi

#  ██████ ██     ██████  ██    ██ ██ ██      ██████
# ██      ██     ██   ██ ██    ██ ██ ██      ██   ██
# ██      ██     ██████  ██    ██ ██ ██      ██   ██
# ██      ██     ██   ██ ██    ██ ██ ██      ██   ██
#  ██████ ██     ██████   ██████  ██ ███████ ██████

# This script's purpose is to execute CI build tasks for WorlEditAdditions.
# 
# Currently this involves building the website & uploading it to the web
# server (though the upload obviously requires an SSH key).
# 
# You do NOT need to run this script to use WorldEditAdditions - only to build
# the website.

# If you try and submit malware to this file, you WILL receive a PERMANENT BAN,
# and I WILL report you to all the places I possibly can.

deploy_ssh_user="ci";
deploy_ssh_host="starbeamrainbowlabs.com";
deploy_ssh_port="2403";

deploy_root_dir="WorldEditAdditions";

# Make sure $WORKSPACE is set to ensure compatilibity with a regular shell
# This is important until we get our CI server back up and running
WORKSPACE="${WORKSPACE:-$PWD}";

###############################################################################

log_msg() {
	echo "[ $SECONDS ] >>> $*" >&2;
}

# $1 - Command name to check for
check_command() {
	set +e;
	command -v "$1" >/dev/null 2>&1; exit_code="$?";
	if [[ "${exit_code}" -ne 0 ]]; then
		log_msg "Error: Couldn't locate $1. Make sure it's installed and in your path.";
	fi
	set -e;
}

###############################################################################

log_msg "WorldEditAdditions build script starting";
log_msg "You do NOT need to run this script to use WorldEditAdditions - this script is for my Continuous Integration server to build and deploy the website :-)";

check_command node;
check_command npm;
check_command npx;
check_command cat;
check_command sftp;
check_command lftp;

if [[ -z "${SSH_KEY_PATH}" ]]; then
	echo "Error: SSH_KEY_PATH environment variable is not set.";
	exit 1;
fi

temp_dir="$(mktemp --tmpdir -d "WorldEditAdditions-XXXXXXX")";
on_exit() {
	rm -rf "${temp_dir}";
}
trap on_exit EXIT;

###############################################################################


cd "./.docs" || { echo "Failed to cd into ./.docs"; exit 1; };

# ██████  ██    ██ ██ ██      ██████
# ██   ██ ██    ██ ██ ██      ██   ██
# ██████  ██    ██ ██ ██      ██   ██
# ██   ██ ██    ██ ██ ██      ██   ██
# ██████   ██████  ██ ███████ ██████

log_msg "Installing website dependencies";

npm install;

log_msg "Building website";

npm run build;

if [[ ! -d "_site" ]]; then
	log_msg "Error: No website build output generated (eh?)";
	exit 1;
fi


#  █████  ██████   ██████ ██   ██ ██ ██    ██ ███████
# ██   ██ ██   ██ ██      ██   ██ ██ ██    ██ ██
# ███████ ██████  ██      ███████ ██ ██    ██ █████
# ██   ██ ██   ██ ██      ██   ██ ██  ██  ██  ██
# ██   ██ ██   ██  ██████ ██   ██ ██   ████   ███████

if [[ ! -z "${ARCHIVE}" ]]; then
	log_msg "Archiving content";
	check_command tar;
	check_command gzip;
	
	cd "_site" || { echo "Failed to cd into _site"; exit 1; };
	
	tar -caf "${ARCHIVE}/WorldEditAdditions-website.tar.gz" .;
	
	log_msg "Archived to ${ARCHIVE}/WorldEditAdditions-website.tar.gz:";
	ls -lh "${ARCHIVE}/WorldEditAdditions-website.tar.gz";
	
	cd ".." || { echo "Failed to parent directory again"; exit 1; };
fi


# ██    ██ ██████  ██       ██████   █████  ██████
# ██    ██ ██   ██ ██      ██    ██ ██   ██ ██   ██
# ██    ██ ██████  ██      ██    ██ ███████ ██   ██
# ██    ██ ██      ██      ██    ██ ██   ██ ██   ██
#  ██████  ██      ███████  ██████  ██   ██ ██████

log_msg "Acquiring upload lock";
# Acquire an exclusive project-wide lock so that we only upload stuff one-at-a-time
exec 9<"${WORKSPACE}";
flock --exclusive 9;

log_msg "Deploying to server";

# Actions:
# [sftp] 1. Connect to remote server
# [sftp] 2. Upload new files
# [lftp] 4. Swap in new directory
# [lftp] 5. Delete old directory

sftp -i "${SSH_KEY_PATH}" -P "${deploy_ssh_port}" -o PasswordAuthentication=no "${deploy_ssh_user}@${deploy_ssh_host}" << SFTPCOMMANDS
mkdir ${deploy_root_dir}/www-new
put -r _site/* ${deploy_root_dir}/www-new
bye
SFTPCOMMANDS

lftp_commands_filename="${temp_dir}/commands.lftp";

(
	echo "set sftp:connect-program 'ssh -x -i ${SSH_KEY_PATH}'";
	# We have an extra : before the @ here to avoid the password prompt
	echo "connect sftp://${deploy_ssh_user}:@${deploy_ssh_host}:${deploy_ssh_port}";
	
	echo "mv \"${deploy_root_dir}/www\" \"${deploy_root_dir}/www-old\"";
	echo "mv \"${deploy_root_dir}/www-new\" \"${deploy_root_dir}/www\"";
	echo "rm -r \"${deploy_root_dir}/www-old\"";
	echo "bye";
) >"${lftp_commands_filename}";


lftp --version;
cat "${lftp_commands_filename}";
lftp -f "${lftp_commands_filename}";
exit_code=$?

log_msg "Releasing lock";
exec 9>&- # Close file descriptor 9 and release the lock


log_msg "Complete!";
