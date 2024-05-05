#!/bin/bash

# Create backup directory if it doesn't exist
mkdir -p /var/backup

# Backup before upgrade
echo -e "
\e[32m#############################
#        Starting Backup     #
#############################\e[0m
"
tar -cvzf /var/backup/before_upgrade_backup.tar.gz / 2>&1 | tee -a /tmp/update-output.txt
echo -e "
\e[32m#############################
#       Backup Complete      #
#############################\e[0m
"

# Update and upgrade Ubuntu
echo -e "
\e[32m#############################
#     Updating Data Base    #
#############################\e[0m
"
apt-get update | tee /tmp/update-output.txt

echo -e "
\e[32m##############################
# Upgrading Operating System #
##############################\e[0m
"
apt-get upgrade -y | tee -a /tmp/update-output.txt

echo -e "
\e[32m#############################
#   Starting Full Upgrade   #
#############################\e[0m
"
apt-get dist-upgrade -y | tee -a /tmp/update-output.txt
echo -e "
\e[32m#############################
#   Full Upgrade Complete   #
#############################\e[0m
"

echo -e "
\e[32m#############################
#    Starting Apt Clean     #
#############################\e[0m
"
apt-get clean | tee -a /tmp/update-output.txt
echo -e "
\e[32m#############################
#     Apt Clean Complete    #
#############################\e[0m
"

# Create backup after upgrade
echo -e "
\e[32m#############################
#        Starting Backup     #
#############################\e[0m
"
tar -cvzf /var/backup/after_upgrade_backup.tar.gz / 2>&1 | tee -a /tmp/update-output.txt
echo -e "
\e[32m#############################
#       Backup Complete      #
#############################\e[0m
"

# Check for existence of update-output.txt and exit if not there.
if [ -f "/tmp/update-output.txt"  ]; then

    # Search for issues user may want to see and display them at end of run.
    echo -e "
\e[32m#####################################################
#   Checking for actionable messages from install   #
#####################################################\e[0m
"
    egrep -wi --color 'warning|error|critical|reboot|restart|autoclean|autoremove' /tmp/update-output.txt | uniq
    echo -e "
\e[32m#############################
#    Cleaning temp files    #
#############################\e[0m
"

    rm /tmp/update-output.txt

else

    # Exit with message if update-output.txt file is not there.
    echo -e "
\e[32m#########################################################
# No items to check given your chosen options. Exiting. #
#########################################################\e[0m
"

fi

exit 0
