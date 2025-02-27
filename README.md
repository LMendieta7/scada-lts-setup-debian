# SCADA-LTS Installation Script for Debian 12

## Overview

This script automates the installation of **SCADA-LTS version 2.6.18** on a **Debian 12** Linux machine. It handles all the necessary steps to quickly set up SCADA-LTS, including installing required dependencies, configuring MySQL and Tomcat, and setting up a dedicated SCADA directory.

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

### 1. Download the Script
