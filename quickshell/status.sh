#!/bin/sh

read_cpu() {
  read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
  used=$((user + nice + system + irq + softirq + steal))
  total=$((used + idle + iowait))
}

read_cpu
old_used=$used
old_total=$total
sleep 0.2
read_cpu
delta=$((total - old_total))
[ "$delta" -gt 0 ] && cpu=$(((used - old_used) * 100 / delta)) || cpu=0

memory=$(awk '/^MemTotal:/ {total=$2} /^MemAvailable:/ {printf "%.1f", (total-$2)/1048576}' /proc/meminfo)
temp=$(awk '{printf "%d", $1/1000}' /sys/class/thermal/thermal_zone0/temp 2>/dev/null || printf -- '--')
network=$(nmcli -t -f TYPE,STATE,CONNECTION device status 2>/dev/null | awk -F: '
  $2 == "connected" && $1 == "wifi" { print " " $3 " "; found=1; exit }
  $2 == "connected" && $1 == "ethernet" { print $3 " 󰊗 "; found=1; exit }
  END { if (!found) print "No connection " }
')

printf 'cpu=%s\nmemory=%s\ntemperature=%s\nnetwork=%s\n' "$cpu" "$memory" "$temp" "$network"
