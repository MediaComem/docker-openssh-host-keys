#!/bin/bash
set -e

COLOR_BOLD=1
COLOR_RED=31
COLOR_GREEN=32
COLOR_YELLOW=33

# Logs a message to standard error and exits.
fail() {
  >&2 echo_color "$COLOR_RED" "$@"
  exit 1
}

# Recursively deletes a directory if it exists.
clean_up_dir() {
  local dir="$1"
  test -n "$dir" && test -d "$dir" && rm -fr "$dir"
}

# Logs a colorized message.
echo_color() {
  local color="$1"
  shift
  local message="$@"

  if is_interactive; then
    echo -e "\033[${color}m${message}\033[0m"
  else
    echo "$message"
  fi
}

# Indicates whether the terminal is interactive.
is_interactive() {
  test "${-#*i}" != "$-" || test -t 0 || test -n "$PS1"
}

# Default arguments.
owner="${SSH_HOST_KEYS_OWNER:-root}"
group="${SSH_HOST_KEYS_GROUP:-root}"
mode="${SSH_HOST_KEYS_MODE:-644}"
dir_mode="$SSH_HOST_KEYS_DIRECTORY_MODE"
target_dir=/target

# Make sure target directory is empty.
test "$(ls -1 -A "$target_dir"|wc -l)" -eq 0 || fail "Target directory $target_dir is not empty"

# Make sure to clean up the SSH directory when exiting.
trap "clean_up_dir /etc/ssh" EXIT

# Generate SSH host keys.
echo
echo "Generating SSH host keys"
mkdir -p /etc/ssh
ssh-keygen -A

# Set ownership of SSH host keys.
chown_arg="${owner}:${group}"
echo
echo "Setting ownership of SSH host keys to $(echo_color "$COLOR_BOLD" "$chown_arg")"
pushd "/etc/ssh" >/dev/null
chown "$chown_arg" *
popd >/dev/null

# Set permissions of SSH host keys.
echo
echo "Setting permissions of SSH host keys to $(echo_color "$COLOR_BOLD" "$mode")"
pushd "/etc/ssh" >/dev/null
chmod "$mode" *
popd >/dev/null
ls -la /etc/ssh

# Copy SSH host keys to target directory.
echo
echo "Copying SSH host keys to target directory $(echo_color "$COLOR_YELLOW" "$target_dir")"
pushd "/etc/ssh" >/dev/null
mv * "$target_dir/"
popd >/dev/null
ls -la /target

# Set ownership and permissions of target directory.
chown "$owner:$group" /target
test -n "$dir_mode" && chmod "$dir_mode" /target

echo
echo_color "$COLOR_GREEN" "Done"

echo
