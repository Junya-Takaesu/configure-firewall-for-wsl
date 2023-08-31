$ports = @(22, 80);
$commaSeparatedPorts = $ports -join ",";
$firewallRuleName = 'WSL 2 Firewall Unlock';
Invoke-Expression "New-NetFireWallRule -DisplayName '$firewallRuleName' -Direction Outbound -LocalPort $commaSeparatedPorts -Action Allow -Protocol TCP";
Invoke-Expression "New-NetFireWallRule -DisplayName '$firewallRuleName' -Direction Inbound -LocalPort $commaSeparatedPorts -Action Allow -Protocol TCP";

