#!/bin/sh

cache_base="${XDG_RUNTIME_DIR:-/tmp}"
cache_dir="$cache_base/waybar-weather"
cache_file="$cache_dir/temp"
lock_dir="$cache_dir/lock"
url="https://wttr.in/Zielona%20G%C3%B3ra,Poland?format=%t"
ttl=900

if ! mkdir -p "$cache_dir" 2>/dev/null; then
  cache_dir="/tmp/waybar-weather-$UID"
  cache_file="$cache_dir/temp"
  lock_dir="$cache_dir/lock"
  mkdir -p "$cache_dir" 2>/dev/null || {
    printf '%s' "--"
    exit 0
  }
fi

cache_age() {
  now=$(date +%s)
  modified=$(stat -c %Y "$cache_file" 2>/dev/null || printf 0)
  printf '%s' "$((now - modified))"
}

print_cache() {
  if [ -s "$cache_file" ]; then
    cat "$cache_file"
  else
    printf '%s' "--"
  fi
}

if [ -s "$cache_file" ] && [ "$(cache_age)" -lt "$ttl" ]; then
  print_cache
  exit 0
fi

if mkdir "$lock_dir" 2>/dev/null; then
  trap 'rmdir "$lock_dir"' EXIT HUP INT TERM
  raw=$(curl -fsSL --max-time 5 "$url" 2>/dev/null)
  temp=$(printf '%s' "$raw" | tr -d '+[:space:]')
  if [ -n "$temp" ]; then
    printf '%s' "$temp" > "$cache_file"
  fi
  print_cache
else
  i=0
  while [ "$i" -lt 6 ] && [ ! -s "$cache_file" ]; do
    sleep 1
    i=$((i + 1))
  done
  print_cache
fi
