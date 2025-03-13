#!/usr/bin/env bash
set -e

# Adjust /dev/kvm permissions if present.
if [ -e /dev/kvm ]; then
  echo "Found /dev/kvm device, adjusting permissions..."
  sudo chown root:kvm /dev/kvm || true
  sudo chmod 660 /dev/kvm || true
fi

echo "Starting supervisord with custom config..."
exec supervisord -n -c /usr/local/etc/supervisord.conf
