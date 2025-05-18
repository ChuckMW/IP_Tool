# IP_Tool


# IP Ping Test and ARP Table Logger

This PowerShell script performs a network scan by pinging all IP addresses in the local subnet and logs the results, including the ARP table before and after the test. It checks for reachable IP addresses, their response times, TTL, and MAC addresses. The results are saved in a log file with a timestamped name.

## Features
- Retrieves the current IP address and subnet mask.
- Generates a log file with the current date and time.
- Logs the current ARP table before and after the test.
- Pings all IP addresses in the subnet (1-254) and logs the results.
- Logs MAC addresses, response time, TTL, and IP reachability status.
- Saves the log results in a text file for later analysis.

## Requirements
- PowerShell (tested on Windows)
- Admin privileges (for accessing ARP table and network interfaces)

## Usage
1. **Download the script** and save it as `PingTest.ps1` (or any name you prefer).
2. **Open PowerShell** and navigate to the directory where the script is saved.
3. **Run the script** by executing the following command:
   ```powershell
   .\PingTest.ps1



##Example Output

Ping Test Started at 2025-05-17 12:30:45

Current ARP Table at 2025-05-17 12:30:45
Interface  Address                LinkLayerAddress  State
---------  -------                ----------------  -----
Ethernet0  192.168.1.1            00-14-22-01-23-45  Reachable

2025-05-17 12:31:00 - 192.168.1.1 is up | ResponseTime: 1 ms | TTL: 128 | MAC Address: 00-14-22-01-23-45
2025-05-17 12:31:01 - 192.168.1.2 is down
...

Updated ARP Table after Ping Test at 2025-05-17 12:35:00
Interface  Address                LinkLayerAddress  State
---------  -------                ----------------  -----
Ethernet0  192.168.1.1            00-14-22-01-23-45  Reachable
Ethernet0  192.168.1.3            00-14-22-01-23-46  Reachable

Ping Test Completed at 2025-05-17 12:35:00




##Notes
The script assumes a subnet mask of /24 (Class C) and will only scan IP addresses from 1 to 254.

It uses the Test-Connection cmdlet to perform a single ping to each IP address.

The script saves the results in a .txt file, making it easy to review after the test.

If there are network issues or unreachable IPs, they will be logged as "down."

The ARP table is retrieved both before and after the ping test to compare changes in the local network.
