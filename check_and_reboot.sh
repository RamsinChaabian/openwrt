#!/bin/sh

# Initialize a counter for connected devices
device_count=0

# List all wireless network interfaces
for interface in `iwinfo | grep ESSID | cut -f 1 -s -d" "`
do
  # For each interface, get MAC addresses of connected stations/clients
  maclist=`iwinfo $interface assoclist | grep dBm | cut -f 1 -s -d" "`
  
  # For each MAC address in that list...
  for mac in $maclist
  do
    # If a DHCP lease has been given out by dnsmasq, save it.
    ip="UNKN"
    host=""
    ip=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep -i $mac | cut -f 2 -s -d" "`
    host=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep -i $mac | cut -f 3 -s -d" "`
    
    # Increment device count and write to System Log
    device_count=$((device_count + 1))
    logger -t wifi_clients "$ip\t$host\t$mac"
  done
done

# Check if any devices were found and write the result to System Log
if [ $device_count -eq 0 ]; then
  logger -t wifi_clients "Device not found. Rebooting router..."
  reboot
else
  logger -t wifi_clients "Number of devices connected: $device_count"
fi
