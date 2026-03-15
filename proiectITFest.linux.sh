#!/bin/sh
printf '\033c\033]0;%s\a' proiectITFest
base_path="$(dirname "$(realpath "$0")")"
"$base_path/proiectITFest.linux.x86_64" "$@"
