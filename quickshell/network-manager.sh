#!/bin/sh

if command -v kcmshell6 >/dev/null 2>&1; then
  exec kcmshell6 kcm_networkmanagement
elif command -v systemsettings >/dev/null 2>&1; then
  exec systemsettings kcm_networkmanagement
elif command -v nm-connection-editor >/dev/null 2>&1; then
  exec nm-connection-editor
elif command -v plasmawindowed >/dev/null 2>&1; then
  exec plasmawindowed org.kde.plasma.networkmanagement
elif command -v ghostty >/dev/null 2>&1; then
  exec ghostty -e nmtui
elif command -v konsole >/dev/null 2>&1; then
  exec konsole -e nmtui
else
  exec nmtui
fi
