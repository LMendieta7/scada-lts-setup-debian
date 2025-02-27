# SCADA-LTS Installation Script for Debian 12

## Overview

This script automates the installation of **SCADA-LTS** v2.6.18 on **Debian 12**, supporting both **VM** and LXC environments. It handles all necessary setup steps, including installing dependencies, configuring MySQL and Tomcat, and creating a dedicated SCADA directory. For LXC installations, you must create a non-root user before running the script.

## Features

- **Automated Installation**: The script automates the entire process, from installing dependencies to configuring MySQL and Tomcat.
- **Installs Required Dependencies**: Automatically installs necessary libraries and packages for SCADA-LTS.
- **Regular User Setup**: Adds the specified regular user to the sudo group for proper permissions.
- **SCADA Directory Creation**: Creates a dedicated directory for SCADA-LTS at `/usr/local/scada`.
- **Handles `deb cdrom` Issue**: Automatically comments out the `deb cdrom` line in `/etc/apt/sources.list` to prevent installation errors.

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
### Official SCADA-LTS GitHub Repository

For the official SCADA-LTS installation scripts and further details, please visit the [SCADA-LTS GitHub Repository.](https://github.com/SCADA-LTS/linux-installer)
