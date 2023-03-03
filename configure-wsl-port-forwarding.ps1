
$wsl_addr = bash.exe -c "ifconfig eth0 | grep 'inet '"
$found = $wsl_addr -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if ( $found ) {
  $wsl_addr = $matches[0];
}
else {
  Write-Output "The Script Exited, the ip address of WSL 2 cannot be found";
  exit;
}

#[Ports]

#All the ports you want to forward separated by coma
$ports = @(22);


#[Static ip]
#You can change the addr to your ip config to listen to a specific address
$addr = '0.0.0.0';
$ports_a = $ports -join ",";


#Remove Firewall Exception Rules
Invoke-Expression "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' ";

#adding Exception Rules for inbound and outbound Rules
Invoke-Expression "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_a -Action Allow -Protocol TCP";
Invoke-Expression "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_a -Action Allow -Protocol TCP";

for ( $i = 0; $i -lt $ports.length; $i++ ) {
  $port = $ports[$i];
  Invoke-Expression "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";
  Invoke-Expression "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$wsl_addr";
}

