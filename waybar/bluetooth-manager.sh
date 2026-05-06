#!/bin/sh

if command -v blueman-manager >/dev/null 2>&1; then
  exec blueman-manager
elif command -v blueberry >/dev/null 2>&1; then
  exec blueberry
elif command -v overskride >/dev/null 2>&1; then
  exec overskride
elif command -v gnome-control-center >/dev/null 2>&1; then
  exec gnome-control-center bluetooth
elif command -v systemsettings >/dev/null 2>&1; then
  exec systemsettings kcm_bluetooth
elif command -v ghostty >/dev/null 2>&1; then
  exec ghostty -e bluetoothctl
else
  exec bluetoothctl
fi
