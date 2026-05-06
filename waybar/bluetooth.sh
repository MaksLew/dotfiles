#!/bin/sh

devices=$(bluetoothctl devices Connected 2>/dev/null) || exit 1
[ -n "$devices" ] || exit 1

names=$(printf '%s\n' "$devices" | sed -E 's/^Device[[:space:]]+([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}[[:space:]]+//')
[ -n "$names" ] || exit 1

first=$(printf '%s\n' "$names" | sed -n '1p')
count=$(printf '%s\n' "$names" | sed '/^$/d' | wc -l)

if [ "$count" -gt 1 ]; then
  printf '󰂯 %s +%s' "$first" "$((count - 1))"
else
  printf '󰂯 %s' "$first"
fi
