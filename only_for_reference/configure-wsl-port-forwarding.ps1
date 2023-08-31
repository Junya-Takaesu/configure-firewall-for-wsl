# Latest script is saved on this repository
# git@github.com:Junya-Takaesu/configure-firewall-for-wsl.git
# or
# https://github.com/Junya-Takaesu/configure-firewall-for-wsl
$wsl_addr = bash.exe -c "ifconfig eth0 | grep 'inet '"
$found = $wsl_addr -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if ( $found ) {
  $wsl_addr = $matches[0];
}
else {
  Write-Output "The Script Exited, the ip address of WSL 2 cannot be found";
  exit;
}

#[Allowed Ports]
$ports = @(22, 80);

#[Static ip]
#You can change the addr to your ip config to listen to a specific address
$addr = '0.0.0.0';
$commaSeparatedPorts = $ports -join ",";

$firewallRuleName = 'WSL 2 Firewall Unlock';

# Remove Firewall Exception Rules
# netsh advfirewall firewall delete rule name="WSL 2 Firewall Unlock"
Invoke-Expression "Remove-NetFireWallRule -ErrorAction SilentlyContinue -DisplayName '$firewallRuleName'";

# Remove Proxy Rules
# netsh advfirewall firewall show rule name=all dir=in | Select-String -Pattern "(LocalPort:\s*22)" -Context 9,4
# netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr

# Adding Exception Rules for inbound and outbound Rules
Invoke-Expression "New-NetFireWallRule -DisplayName '$firewallRuleName' -Direction Outbound -LocalPort $commaSeparatedPorts -Action Allow -Protocol TCP";
Invoke-Expression "New-NetFireWallRule -DisplayName '$firewallRuleName' -Direction Inbound -LocalPort $commaSeparatedPorts -Action Allow -Protocol TCP";

# Configure portforward to wsl IP address.
for ( $i = 0; $i -lt $ports.length; $i++ ) {
  $port = $ports[$i];
  Invoke-Expression "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";
  Invoke-Expression "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$wsl_addr";
}

