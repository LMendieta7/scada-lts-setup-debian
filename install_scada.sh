#!/bin/bash

# exit immediately if a command exits with a non-zero status
set -e 
# Get the username of the regular user
REGULAR_USER=$(logname)

# File to check
SOURCE_LIST="/etc/apt/sources.list"

# SCADA-LTS version 2.6.18(stable version) download link
SCADA_LTS_URL="https://github.com/SCADA-LTS/linux-installer/releases/download/v1.4.3/Scada-LTS_v2.6.18_1_Installer_v1.4.3_Setup.zip"
SCADA_LTS_ZIP="Scada-LTS_v2.6.18_1_Installer_v1.4.3_Setup.zip"

SCADA_DIR="/usr/local/scada"

# Function to comment out the 'deb cdrom' line
comment_cdrom() {
  echo "Checking for 'deb cdrom' entries in $SOURCE_LIST..."
  if grep -q "^deb cdrom:" "$SOURCE_LIST"; then
    echo "Found 'deb cdrom' line(s). Commenting them out..."
    sed -i "/^deb cdrom:/s/^/#/" "$SOURCE_LIST"
  fi
}

# Function to install dependencies as root
install_dependencies() {
  echo "Updating package lists..."
  apt update && apt upgrade -y
  apt install -y libaio1 libnuma1 unzip wget sudo  

  echo "Adding regular user to sudo group..."
  usermod -aG sudo $REGULAR_USER

  echo "Creating SCADA directory..."
  mkdir -p "$SCADA_DIR"
  chown -R "$REGULAR_USER:$REGULAR_USER" "$SCADA_DIR"
  chmod -R 750 "$SCADA_DIR"

  echo "Dependencies installed successfully."
}

# Function to download and extract SCADA-LTS as the regular user
download_and_unzip() {
  echo "Downloading and extracting SCADA-LTS as $REGULAR_USER..."
  su - "$REGULAR_USER" -c "
    cd '$SCADA_DIR' &&
    wget '$SCADA_LTS_URL' -O '$SCADA_DIR/$SCADA_LTS_ZIP' &&
    unzip -o '$SCADA_LTS_ZIP' &&
    echo 'Download and extraction complete.'
  "
}

# Function to collect MySQL installation details from the user
get_mysql_details() {
  read -p "[MySQL Community Server] Enter hostname (default: localhost): " MYSQL_HOSTNAME
  read -p "[MySQL Community Server] Enter port (default: 3306): " MYSQL_PORT
  read -p "[MySQL Community Server] Enter database name (default: scadalts): " MYSQL_DB_NAME
  read -p "[MySQL Community Server] Enter username (default: root): " MYSQL_USERNAME
  read -p "[MySQL Community Server] Enter password (default: root): " MYSQL_PASSWD
  read -p "[MySQL Community Server] Enter root password (default: root): " MYSQL_ROOT_PASSWD
  
  echo  # Move to a new line after password input

  # Set defaults if empty
  MYSQL_HOSTNAME=${MYSQL_HOSTNAME:-"localhost"}
  MYSQL_PORT=${MYSQL_PORT:-"3306"}
  MYSQL_DB_NAME=${MYSQL_DB_NAME:-"scadalts"}
  MYSQL_USERNAME=${MYSQL_USERNAME:-"root"}
  MYSQL_PASSWD=${MYSQL_PASSWD:-"root"}
  MYSQL_ROOT_PASSWD=${MYSQL_ROOT_PASSWD:-"root"}

  # Export variables for use in the MySQL installation script
  export MYSQL_HOSTNAME MYSQL_PORT MYSQL_DB_NAME MYSQL_USERNAME MYSQL_PASSWD MYSQL_ROOT_PASSWD
}

get_tomcat_details() {
  read -p "[Apache Tomcat Server] Enter port (default: 8080): " TOMCAT_PORT
  read -p "[Apache Tomcat Server] Enter username (default: tcuser): " TOMCAT_USERNAME

  read -p "[Apache Tomcat Server] Enter password (default: tcuser): " TOMCAT_PASSWORD
  echo  # Move to a new line after password input

  read -p "[Apache Tomcat Server] Enter database port (default: 3306): " TOMCAT_DB_PORT
  read -p "[Apache Tomcat Server] Enter database host (default: localhost): " TOMCAT_DB_HOST
  read -p "[Apache Tomcat Server] Enter database name (default: scadalts): " TOMCAT_DB_NAME
  read -p "[Apache Tomcat Server] Enter database username (default: root): " TOMCAT_DB_USERNAME
  read -p "[Apache Tomcat Server] Enter database password (default: root): " TOMCAT_DB_PASSWORD
  echo  # Move to a new line after password input

  # Set defaults if empty
  TOMCAT_PORT="${TOMCAT_PORT:-8080}"
  TOMCAT_USERNAME="${TOMCAT_USERNAME:-tcuser}"
  TOMCAT_PASSWORD="${TOMCAT_PASSWORD:-tcuser}"
  TOMCAT_DB_PORT="${TOMCAT_DB_PORT:-3306}"
  TOMCAT_DB_HOST="${TOMCAT_DB_HOST:-localhost}"
  TOMCAT_DB_NAME="${TOMCAT_DB_NAME:-scadalts}"
  TOMCAT_DB_USERNAME="${TOMCAT_DB_USERNAME:-root}"
  TOMCAT_DB_PASSWORD="${TOMCAT_DB_PASSWORD:-root}"

  # Export variables for later use
  export TOMCAT_PORT TOMCAT_USERNAME TOMCAT_PASSWORD
  export TOMCAT_DB_PORT TOMCAT_DB_HOST TOMCAT_DB_NAME TOMCAT_DB_USERNAME TOMCAT_DB_PASSWORD
}

# Function to install MySQL as the regular user with automated inputs
run_mysql_installer() {
  echo "Starting MySQL installation as $REGULAR_USER..."
  
  su - "$REGULAR_USER" -c "
    cd '$SCADA_DIR'
    if [ ! -x './mysql_start.sh' ]; then
      echo 'Error: mysql_start.sh is not executable or missing.'
      exit 1
    fi
    echo 'Running mysql_start.sh with automated input...'
    echo -e '$MYSQL_HOSTNAME\n$MYSQL_PORT\n$MYSQL_DB_NAME\n$MYSQL_USERNAME\n$MYSQL_PASSWD\n$MYSQL_ROOT_PASSWD' | ./mysql_start.sh 
  " & MYSQL_PID=$!
  echo "MySQL installation started in the background (PID: $MYSQL_PID)."

}

# Function to install Tomcat as the regular user with automated inputs
run_tomcat_installer() {
  echo "Starting Tomcat installation as $REGULAR_USER..."
  
  su - "$REGULAR_USER" -c "
    cd '$SCADA_DIR'
    if [ ! -x './tomcat_start.sh' ]; then
      echo 'Error: tomcat_start.sh is not executable or missing.'
      exit 1
    fi
    echo 'Running tomcat_start.sh with automated input...'
    echo -e '$TOMCAT_PORT\n$TOMCAT_USERNAME\n$TOMCAT_PASSWORD\n$TOMCAT_DB_PORT\n$TOMCAT_DB_HOST\n$TOMCAT_DB_NAME\n$TOMCAT_DB_USERNAME\n$TOMCAT_DB_PASSWORD' | ./tomcat_start.sh
  " & TOMCAT_PID=$!
  
  echo "Tomcat installation started in the background (PID: $TOMCAT_PID)."
 
}

check_scadalts_running() {
  echo
  echo "Checking if SCADA-LTS web interface is accessible..."
  SCADA_URL="http://localhost:$TOMCAT_PORT/Scada-LTS/login.htm"  # Change this if needed
  LOCAL_IP=$(hostname -I | awk '{print $1}')
  REMOTE_URL="http://$LOCAL_IP:$TOMCAT_PORT/Scada-LTS/login.htm"
  while true; do
    if wget --spider -q "$SCADA_URL"; then
      echo
      echo -e "\n=============================="
      echo "SCADA-LTS is up and running at $REMOTE_URL"
      echo -e "=============================="
      return 0  # Success, SCADA-LTS is running
    fi
    echo -e "\n=============================="
    echo "SCADA-LTS not ready yet. Retrying in 10 seconds..."
    sleep 10
  done
}

# Main execution

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Please switch to root using 'su -' and try again."
  exit 1
fi

# Starting SCADA-LTS installation process
echo "Starting SCADA-LTS installation script..."

# Comment out any 'deb cdrom' lines in the sources list
comment_cdrom
sleep 1
# Install required dependencies and prepare the environment
echo "Installing dependencies..."
install_dependencies
sleep 1
# Switch to the regular user to download and extract SCADA-LTS
echo "Switching to regular user for download and extraction..."
download_and_unzip
sleep 1
# Gather MySQL installation details
get_mysql_details
sleep 3

echo "Starting MySQL installation..."
run_mysql_installer
sleep 10
# getting tomcat information from user
get_tomcat_details
# Install Tomcat
echo "Starting Tomcat installation..."
run_tomcat_installer
sleep 15

# echo "Creating systemd services for MySQL and Tomcat..."
# bash "$(dirname "$0")/create_systemd_services.sh"
echo
check_scadalts_running
echo "SCADA-LTS installation process completed successfully!"
echo

