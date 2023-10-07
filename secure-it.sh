#!/bin/bash

# Update and upgrade packages
sudo apt-get update
sudo apt-get upgrade -y

# Install essential security tools
sudo apt-get install -y fail2ban ufw

# Configure firewall (UFW)
sudo ufw allow OpenSSH
sudo ufw enable

# Set up Fail2Ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Disable root login
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo service ssh restart

# Create a new user with sudo privileges
read -p "Enter a new username: " new_user
sudo adduser $new_user
sudo usermod -aG sudo $new_user

# Set up SSH key authentication
sudo mkdir -p /home/$new_user/.ssh
sudo chmod 700 /home/$new_user/.ssh
sudo cp ~/.ssh/authorized_keys /home/$new_user/.ssh/
sudo chmod 600 /home/$new_user/.ssh/authorized_keys
sudo chown -R $new_user:$new_user /home/$new_user/.ssh

# Disable password authentication
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo service ssh restart

# Enable automatic security updates
sudo apt-get install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Install and configure a firewall (e.g., UFW)
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw enable

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
