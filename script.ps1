# Firefox Install
choco install firefox -y

# Telegram Alert Setup
$BOT_TOKEN = "8469309529:AAH1kdLYjtwee39EAgULMJa64Db_xRnWpYw"
$CHAT_ID = "1361241039"

# System Info Capture
$computerName = $env:COMPUTERNAME
$userName = $env:USERNAME
$time = Get-Date -Format "dd-MM-yyyy HH:mm:ss"

# Send Telegram Alert
$message = "🚨 Laptop Accessed!`n`n💻 Computer: $computerName`n👤 User: $userName`n⏰ Time: $time"
Invoke-WebRequest -Uri "https://api.telegram.org/bot$BOT_TOKEN/sendMessage?chat_id=$CHAT_ID&text=$message" -UseBasicParsing

# Create Log File
"$time - $computerName - $userName" | Out-File -FilePath "$env:USERPROFILE\access_log.txt" -Append

# Add to Startup
Copy-Item "$PSCommandPath" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\script.ps1"
