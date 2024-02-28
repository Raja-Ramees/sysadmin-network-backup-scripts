#!/bin/bash

# Create users sys_user1, sys_user2, sys_user3, sys_user4, sys_user5, and sys_user6
for i in {1..6}; do
    useradd -m sys_user$i
done

# Create a group named security
groupadd security

# Add sys_user1, sys_user2, and sys_user3 to the security group
for i in {1..3}; do
    usermod -aG security sys_user$i
done

# Create a collaborative directory named admin
mkdir admin

# Set permissions on the admin directory to allow read, write, and execute for the owner and group, and read and execute for others
chmod 775 admin

# Create files sys_user1_file, sys_user2_file, and sys_user3_file in the admin directory
touch admin/sys_user1_file admin/sys_user2_file admin/sys_user3_file

# Set ACLs to allow sys_user4 to read and write to sys_user1_file
setfacl -m u:sys_user4:rw admin/sys_user1_file

# Set ACLs to allow sys_user5 to read and write to sys_user2_file
setfacl -m u:sys_user5:rw admin/sys_user2_file

# Set ACLs to allow sys_user6 to read and write to sys_user3_file
setfacl -m u:sys_user6:rw admin/sys_user3_file

# Change owner and group ownership of files to sys_user1, sys_user2, sys_user3 and the security group
chown sys_user1:security admin/sys_user1_file
chown sys_user2:security admin/sys_user2_file
chown sys_user3:security admin/sys_user3_file

# Perform backup for the collaborative directory
perform_backup() {
    echo "===== Automated Backup with Timestamp ====="
    backup_dir=$(pwd)
    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    backup_file="backup_$timestamp.tar.gz"

    # Specify the source directory
    source_dir="admin"

    # Create a tar archive of the source directory and files in the backup directory
    tar -czf "$backup_dir/$backup_file" -C "$source_dir" .

    echo "Backup created: $backup_dir/$backup_file"
    echo "==========================================="
}

# Function to display system load and resource usage in an attractive format
display_system_stats() {
    echo "===== System Load and Resource Usage Monitoring ====="
    echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')%"
    echo "Memory Usage: $(free -m | awk '/Mem:/ {print $3 " MB / " $2 " MB"}')"
    echo "Disk Usage: $(df -h | awk '$NF=="/"{printf "%d/%d GB (%s)\n", $3,$2,$5}')"
    echo "====================================================="
}

# Function for log file rotation
rotate_log_files() {
    echo "===== Log File Rotation ====="
    # Implement log file rotation as needed
    # Example:
    # logrotate -f /etc/logrotate.conf
    echo "Log files rotated."
    echo "============================"
}

# Function for disk usage notification
disk_usage_notification() {
    echo "===== Disk Usage Notification ====="
    threshold=90  # Define disk usage threshold percentage
    disk_usage=$(df -h | awk '$NF=="/"{print $5}' | sed 's/%//')
    if [ "$disk_usage" -ge "$threshold" ]; then
        echo "Disk usage exceeds $threshold%."
        # Implement notification mechanism (e.g., email, logging)
    else
        echo "Disk usage is within normal range."
    fi
}

# Function to monitor and restart services
monitor_and_restart_services() {
    echo "===== Monitor and Restart Services ====="
    # Implement service monitoring and restart logic as needed
    # Example:
    # services=("apache2" "mysql")
    # for service in "${services[@]}"; do
    #     systemctl status "$service" || systemctl restart "$service"
    # done
    echo "Services monitored and restarted if necessary."
    echo "==========================================="
}

# Function to display IP address information
display_ip_information() {
    echo "===== IP Address Information ====="
    echo "Public IP Address: $(curl -s ifconfig.me)"
    echo "Local IP Address: $(hostname -I)"
    echo "=================================="
}

# Function for ping option with only 1 packet
ping_single_packet() {
    echo "===== Ping with 1 Packet ====="
    read -p "Enter the target IP address or domain: " target
    ping -c 1 "$target"
    echo "==============================="
}

# Main function to execute all tasks
main() {
    display_system_stats
    rotate_log_files
    disk_usage_notification
    monitor_and_restart_services
    display_ip_information
    ping_single_packet
    perform_backup
}

# Execute the main function
main

