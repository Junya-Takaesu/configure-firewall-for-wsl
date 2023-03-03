# Configure Windows firewall rules to allow access to running services on WSL instances

## The Youtube video

https://www.youtube.com/watch?v=yCK3easuYm4&t=763s

- contents of the video
  - connect to wsl ubuntu instance via remote desktop(xrdp)
  - allowing communication for the port of xrdp
  - set up firewall rule for it
  - workaround script to fix ephemeral ip address of wsl by recreating firewall rule everytime the windows boots.

## Script originates from a github issue comment

https://github.com/microsoft/WSL/issues/4150#issuecomment-504209723

## Commands

### netsh interface portproxy show v4tov4

```
netsh interface portproxy show v4tov4
```

```
❯ netsh interface portproxy show v4tov4

Listen on ipv4:             Connect to ipv4:

Address         Port        Address         Port
--------------- ----------  --------------- ----------
0.0.0.0         22          wsl ip address  22
```

### reset all portproxy

```
sudo netsh int portproxy reset all
```
- *sudo is not available by default. Install it using scoop onto Powershell terminal.

