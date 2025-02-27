# SCADA-LTS Installation Script for Debian 12

## Overview

This script automates the installation of **SCADA-LTS** v2.6.18 on **Debian 12**, supporting both **VM** and LXC environments. It handles all necessary setup steps, including installing dependencies, configuring MySQL and Tomcat, and creating a dedicated SCADA directory. For LXC installations, you must create a non-root user before running the script.

## Features

- **Automated Installation**: The script automates the entire process, from installing dependencies to configuring MySQL and Tomcat.
- **Installs Required Dependencies**: Automatically installs necessary libraries and packages for SCADA-LTS.
- **Regular User Setup**: Adds the specified regular user to the sudo group for proper permissions.
- **SCADA Directory Creation**: Creates a dedicated directory for SCADA-LTS at `/usr/local/scada`.
- **Handles `deb cdrom` Issue**: Automatically comments out the `deb cdrom` line in `/etc/apt/sources.list` to prevent installation errors.
- **MySQL and Tomcat Input:** After running the script, you will be prompted to enter MySQL and Tomcat configuration details. You can **press the Enter key** to accept the default values provided in the official SCADA-LTS tutorial.
-**Service Confirmation**: After installation, the script will confirm when MySQL and Tomcat services are running correctly and provide a link to access SCADA-LTS via a browser.
  
## Prerequisites

- **Debian 12** (or similar Debian-based distributions).
- **Root Access**: The script must be run as a root user or with sudo privileges to perform installation and configuration tasks.
- **Regular User**: Ensure a regular user exists on the system. The script uses the currently logged-in user for installing SCADA-LTS.

## How to Use

### 1. Download the Script

Clone or download the repository to your Debian machine. You can download the script using `wget`:

```bash
wget https://raw.githubusercontent.com/LMendieta7/scada-lts-setup-debian/main/install_scada.sh
```

### 2. Make the Script Executable

Once the script is downloaded, make it executable:

```bash
chmod +x install_scada.sh 
```

### 3. Run the Script as Root

Once the script is executable, run it as root using `su -c`:

```bash
su -c "./install_scada.sh"
```
### 4. Enter MySQL and Tomcat Details
During the installation process, the script will prompt you for MySQL and Tomcat configuration details. Press **Enter** to accept the default values provided in the official SCADA-LTS tutorial.

### 5. Service Confirmation
Once the script finishes, it will display a message indicating when the MySQL and Tomcat services are running correctly. It will also provide a link to access SCADA-LTS in your browser

### Official SCADA-LTS GitHub Repository

For the official SCADA-LTS installation scripts and further details, please visit the [SCADA-LTS GitHub Repository.](https://github.com/SCADA-LTS/linux-installer)
