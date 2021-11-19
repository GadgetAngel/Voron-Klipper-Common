#!/bin/bash
KLIPPER_CONFIG_PATH="${HOME}/klipper_config"
SYSTEMDDIR="/etc/systemd/system"

# Step 1:  Verify Klipper has been installed
check_klipper()
{
    if [ "$(sudo systemctl list-units --full -all -t service --no-legend | grep -F "klipper.service")" ]; then
        echo "Klipper service found!"
    else
        echo "Klipper service not found, please install Klipper first"
        exit -1
    fi

}

# Step 2: link macros and configs
create_links()
{
    echo "Linking macro and config to klipper_config..."
    ln -s "${SRCDIR}/macros" "${KLIPPER_CONFIG_PATH}/macros/common"
    ln -s "${SRCDIR}/configs" "${KLIPPER_CONFIG_PATH}/configs/common"
}

# Step 4: restarting Klipper
restart_klipper()
{
    echo "Restarting Klipper..."
    sudo systemctl restart klipper
}

# Helper functions
verify_ready()
{
    if [ "$EUID" -eq 0 ]; then
        echo "This script must not run as root"
        exit -1
    fi
}

# Force script to exit if an error occurs
set -e

# Find SRCDIR from the pathname of this script
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/ && pwd )"

# Parse command line arguments
while getopts "k:" arg; do
    case $arg in
        k) KLIPPER_CONFIG_PATH=$OPTARG;;
    esac
done

# Run steps
verify_ready
create_links
restart_klipper