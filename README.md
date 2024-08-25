# 🌟 Auto-Reboot Script for OpenWrt 🌟
# 📅 Introduction
This repository contains a cron job setup script for OpenWrt that automates the process of checking connected devices and rebooting the router if necessary. By doing this, the script helps to clear the router's memory and cache, leading to improved performance. 🚀

# 🛠️ Cron Job Setup
To set up the cron job, add the following line to your cron configuration:
```
0 6 * * * /bin/sh -c 'wget -q -O /tmp/check_and_reboot.sh https://raw.githubusercontent.com/ramsinchaabian/openwrt/main/check_and_reboot.sh && chmod +x /tmp/check_and_reboot.sh && ash /tmp/check_and_reboot.sh'
```
### 📋 What This Cron Job Does

- **Time**: Runs every day at 6:00 AM.
- **Actions**:
  - Downloads the script from the specified URL.
  - Sets the script as executable.
  - Executes the script.

# 📜 The Script: `check_and_reboot.sh`
Here's what the script does:
```
#!/bin/sh

# Initialize a counter for connected devices
device_count=0

# List all wireless network interfaces
for interface in iwinfo | grep ESSID | cut -f 1 -s -d" "
do
  # For each interface, get MAC addresses of connected stations/clients
  maclist=iwinfo $interface assoclist | grep dBm | cut -f 1 -s -d" "
  
  # For each MAC address in that list...
  for mac in $maclist
  do
    # If a DHCP lease has been given out by dnsmasq, save it.
    ip="UNKN"
    host=""
    ip=cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep -i $mac | cut -f 2 -s -d" "
    host=cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep -i $mac | cut -f 3 -s -d" "
    
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
```
# 🛠️ Script Breakdown
1. Initialize Counter: Starts a counter to keep track of connected devices.
2. List Interfaces: Identifies all wireless interfaces.
3. Get MAC Addresses: Retrieves MAC addresses of connected devices.
4. Log Device Information: Logs information about each connected device.
5. Reboot Condition: Reboots the router if no devices are found, otherwise logs the number of connected devices.

# 🚀 Benefits
- Improved Performance: Clears memory and cache to enhance router performance.
- Automation: Ensures routine checks and maintenance without manual intervention.
- Logging: Provides detailed logs for monitoring and troubleshooting.
  
# 🤝 Contributing
Feel free to contribute by opening issues or submitting pull requests. Your feedback and improvements are welcome!

# 📑 License
This project is licensed under the [MIT License](./LICENSE).

Happy router managing! 🖥️✨


