#!/bin/bash

# Update and upgrade Ubuntu
    sudo apt update
    sudo apt -y upgrade
    sudo apt -y dist-upgrade
    sudo apt -y autoremove

    sleep 0.5
    
    # Again
    sudo apt -y autoclean
    sudo apt -y clean
    sudo apt update
    sudo apt -y upgrade
    sudo apt -y dist-upgrade
    sudo apt -y autoremove

# System utilities
sudo apt -y install apt-utils bash-completion busybox ca-certificates cron curl gnupg2 locales lsb-release nano preload screen software-properties-common ufw unzip vim wget xxd zip

# Install UFW and configure firewall 
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh 
sudo ufw enable

# Install fail2ban to block brute force attacks
sudo apt install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Require key-based SSH authentication 
sudo sed -i 's/^PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
# sudo systemctl reload sshd

# Disable root login
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl reload sshd

# Add new user and give sudo privileges
# Ask for username 
read -p "Enter new username: " new_user  

# Add user account
sudo useradd -m $new_user

# Set password 
sudo passwd $new_user

# Add to sudo group
sudo usermod -aG sudo $new_user

# Verify user was created
id $username

sleep 2

# Set up SSH key authentication
sudo mkdir -p /home/$new_user/.ssh
sudo chmod 700 /home/$new_user/.ssh
sudo cp ~/.ssh/authorized_keys /home/$new_user/.ssh/
sudo chmod 600 /home/$new_user/.ssh/authorized_keys
sudo chown -R $new_user:$new_user /home/$new_user/.ssh

# Enable automatic security updates
sudo apt-get install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Set password policies
sudo apt install libpam-pwquality -y
sudo pam-auth-update --enable pwquality

# Install and configure auditd for logging
sudo apt install auditd -y
sudo sed -i 's/max_log_file =.*/max_log_file = 10/' /etc/audit/auditd.conf
sudo systemctl enable auditd
sudo systemctl restart auditd

# Security hardening 
sudo apt remove --purge exim4 -y # Remove unneeded services
sudo ufw deny incoming 
sudo ufw limit ssh # Limit SSH connection attempts

# Regular scanning and patching
sudo apt install unzip wget -y
wget https://downloads.cisofy.com/lynis/lynis-latest.zip
unzip lynis-latest.zip
cd lynis
./lynis audit system

# Ongoing monitoring 
sudo apt install netdata -y # Install netdata
# Sandbox applications with AppArmor, configure seccomp

# Configure system logs for security auditing
sudo nano /etc/rsyslog.conf

# Add the following lines to the end of the file:
# $ModLoad imudp
# $UDPServerRun 514
# $FileCreateMode 0640
# $DirCreateMode 0755
# $PrivDropToUser syslog
# $PrivDropToGroup syslog
# $InputUDPServerBindRuleset remote
# $UDPServerAddress 0.0.0.0
# $UDPServerRun 514

# Restart the syslog service
sudo service rsyslog restart

# Regularly monitor and review logs

# Enable and configure an intrusion detection system (e.g., Fail2Ban)

# Regularly update and patch the server

# Regularly backup critical data

# Configure additional security measures based on your specific needs

echo "Server secured successfully!"
