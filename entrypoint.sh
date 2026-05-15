#!/bin/bash
set -e

USERNAME=""
UID_VAL=1000
GID_VAL=1000
ADD_SUDO=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user)  USERNAME="$2";   shift 2 ;;
    --uid)   UID_VAL="$2";    shift 2 ;;
    --gid)   GID_VAL="$2";    shift 2 ;;
    --sudo)  ADD_SUDO="$2";   shift 2 ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
done

if [[ -z "$USERNAME" ]]; then
  echo "Error: --user is required"
  exit 1
fi

# Create group if it doesn't exist
if ! getent group "$GID_VAL" > /dev/null 2>&1; then
  groupadd -g "$GID_VAL" "$USERNAME"
fi

# Create user if it doesn't exist
if ! id "$USERNAME" > /dev/null 2>&1; then
  useradd -m -d "/home/$USERNAME" -s /bin/bash -u "$UID_VAL" -g "$GID_VAL" "$USERNAME"
else
  mkdir -p "/home/$USERNAME"
fi

chown "$UID_VAL:$GID_VAL" "/home/$USERNAME"

if [[ "$ADD_SUDO" == "true" ]]; then
  usermod -aG sudo "$USERNAME"
  SUDOERS_FILE="/etc/sudoers.d/${USERNAME//[^a-zA-Z0-9_-]/_}"
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > "$SUDOERS_FILE"
  chmod 440 "$SUDOERS_FILE"
fi

exec /usr/sbin/sshd -De
