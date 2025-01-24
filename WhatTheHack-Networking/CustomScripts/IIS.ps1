import-module servermanager
add-windowsfeature web-server -includeallsubfeature
set-content -path "C:\inetpub\wwwroot\Default.html" -Value "This is the server $($env:computername)!"
Enable-NetFirewallRule -name FPS-ICMP4-ERQ-In 