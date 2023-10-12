# auto-secure
A lightweight security script fortifying your Linux Server

in # Configure system logs for security auditing
sudo nano /etc/rsyslog.conf
part do the following:
```
# Add the following lines to the end of the file:
$ModLoad imudp
$UDPServerRun 514
$FileCreateMode 0640
$DirCreateMode 0755
$PrivDropToUser syslog
$PrivDropToGroup syslog
$InputUDPServerBindRuleset remote
$UDPServerAddress 0.0.0.0
$UDPServerRun 514
```
