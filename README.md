# scada-lts-setup-debian
SCADA-LTS Installation Script for Debian 12
Overview

This script simplifies the installation of SCADA-LTS (version 2.6.18) on a Debian 12 Linux machine. It automates several steps, from installing dependencies to setting up MySQL and Tomcat, allowing for a quick and easy installation process.
Features

    Automates Installation: This script handles all the necessary steps to get SCADA-LTS up and running.
    Installs Required Dependencies: Ensures that the system has all the required libraries and packages for SCADA-LTS.
    Sets Up MySQL and Tomcat: Automatically installs MySQL and Tomcat, making them ready to use with SCADA-LTS.
    Regular User Setup: Adds the specified regular user to the sudo group for seamless permissions.
    SCADA Directory Creation: Creates a dedicated directory for SCADA-LTS in /usr/local/scada.
    Handles deb cdrom Issue: Automatically comments out the deb cdrom line in /etc/apt/sources.list to prevent installation errors.

Prerequisites

    Debian 12 .
    Root Access: The script must be run as a root user (or with sudo privileges) for installation and configuration.
    Regular User: Ensure a regular user exists on the system for running SCADA-LTS (the script will use the current logged-in user).

How to Use

    Download the Script:
        Clone or download the repository to your Debian machine.

    Run the Script:
        Make the script executable:

chmod +x scada-lts-install.sh

Run the script as root:

    su -c "./scada-lts-install.sh"

Follow the Prompts:

    The script will check for required dependencies, ensure proper permissions, and download the SCADA-LTS installer.
    It will install MySQL and Tomcat, configure them, and set up the SCADA-LTS directory structure.

License

This script is provided as-is and free to use for installing SCADA-LTS on Debian-based systems.
