#!/bin/sh
# PROTOTYPE: copies the proto-* layouts into Herdr and shows the first. `./install.sh remove` deletes them.
set -e
dir="${HERDR_APP_HOME:-$HOME/.config/herdr-app}/layouts"
cd "$(dirname "$0")"
if [ "$1" = remove ]; then
  herdr-app do layout.switch '{"name":"dehottdog"}' >/dev/null
  for f in proto-*.json; do rm -f "$dir/$f" "$dir/${f%.json}.error"; done
  exit 0
fi
cp proto-*.json "$dir/"
herdr-app do layout.switch '{"name":"proto-cockpit"}'
