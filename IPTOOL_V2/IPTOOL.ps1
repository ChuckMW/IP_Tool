# Get the current IP address and subnet mask of the computer
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.PrefixLength -eq 24}).IPAddress
$subnetMask = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.PrefixLength -eq 24}).PrefixLength

# Get the base address by removing the last octet
$baseAddress = $ipAddress -replace '\.\d+$', '.'

# Generate a log file name based on the current date and time (format: PingLog_yyyyMMdd_HHmmss.txt)
$logFileName = "PingLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$logFile = Join-Path -Path $PSScriptRoot -ChildPath $logFileName

# Initialize log file with a header
$logHeader = "Ping Test Started at $(Get-Date)"
$logHeader | Out-File -FilePath $logFile -Append

# Display the current ARP table
$arpTable = Get-NetNeighbor
$arpHeader = "Current ARP Table at $(Get-Date)"
$arpHeader | Out-File -FilePath $logFile -Append
$arpTable | Out-File -FilePath $logFile -Append

# Loop through all possible IP addresses in the subnet (1 to 254 for a typical Class C subnet)
for ($i = 1; $i -lt 255; $i++) {
    $currentIP = $baseAddress + $i
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    Write-Host "Pinging $currentIP..."
    
    # Ping the current IP and get detailed result
    $pingResult = Test-Connection -ComputerName $currentIP -Count 1 -ErrorAction SilentlyContinue
    
    if ($pingResult) {
        # Get the MAC address from the ARP cache if the IP is reachable
        $macAddress = (Get-NetNeighbor -IPAddress $currentIP).LinkLayerAddress
        $logMessage = "$timestamp - $currentIP is up | ResponseTime: $($pingResult.ResponseTime) ms | TTL: $($pingResult.TimeToLive) | MAC Address: $macAddress"
        Write-Host "$currentIP is up | ResponseTime: $($pingResult.ResponseTime) ms | TTL: $($pingResult.TimeToLive) | MAC Address: $macAddress"
    } else {
        # Log if the IP is unreachable
        $logMessage = "$timestamp - $currentIP is down"
        Write-Host "$currentIP is down"
    }

    # Append the result to the log file
    $logMessage | Out-File -FilePath $logFile -Append
}

# Display the updated ARP table
$updatedArpTable = Get-NetNeighbor
$arpFooter = "Updated ARP Table after Ping Test at $(Get-Date)"
$arpFooter | Out-File -FilePath $logFile -Append
$updatedArpTable | Out-File -FilePath $logFile -Append

# Log completion
$logCompletion = "Ping Test Completed at $(Get-Date)"
$logCompletion | Out-File -FilePath $logFile -Append
