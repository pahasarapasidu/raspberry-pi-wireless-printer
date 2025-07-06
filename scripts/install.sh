#!/bin/bash

# Raspberry Pi Wireless Printer Server Installation Script
# This script automates the setup of CUPS print server with Samba support

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root. Please run as a regular user."
   exit 1
fi

# Welcome message
echo -e "${GREEN}"
echo "=================================================================="
echo "    Raspberry Pi Wireless Printer Server Installation"
echo "=================================================================="
echo -e "${NC}"

# Check if running on Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo; then
    print_warning "This script is designed for Raspberry Pi. Continue anyway? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update system
print_status "Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Install required packages
print_status "Installing CUPS and related packages..."
sudo apt install -y cups printer-driver-gutenprint

# Install Samba for Windows compatibility
print_status "Installing Samba for Windows compatibility..."
sudo apt install -y samba

# Add user to printer admin group
print_status "Adding user to printer admin group..."
sudo usermod -a -G lpadmin pi

# Configure CUPS for remote access
print_status "Configuring CUPS for remote access..."
sudo cupsctl --remote-any

# Configure firewall
print_status "Configuring firewall..."
sudo ufw allow 631/tcp comment "CUPS"
sudo ufw allow 445/tcp comment "Samba"
sudo ufw allow 139/tcp comment "Samba"

# Start and enable services
print_status "Starting and enabling services..."
sudo systemctl enable cups
sudo systemctl start cups
sudo systemctl enable smbd
sudo systemctl start smbd

# Get IP address
IP_ADDRESS=$(hostname -I | cut -d' ' -f1)

# Create basic Samba configuration
print_status "Configuring Samba..."
sudo tee -a /etc/samba/smb.conf > /dev/null <<EOF

[printers]
   comment = All Printers
   browseable = no
   path = /var/spool/samba
   printable = yes
   guest ok = no
   read only = yes
   create mask = 0700

[print$]
   comment = Printer Drivers
   path = /var/lib/samba/printers
   browseable = yes
   read only = yes
   guest ok = no
EOF

# Restart Samba to apply configuration
sudo systemctl restart smbd

# Check if printer is connected
print_status "Checking for connected printers..."
if lsusb | grep -i "canon\|hp\|brother\|epson" > /dev/null; then
    print_success "Printer detected via USB!"
else
    print_warning "No printer detected. Make sure your printer is connected via USB and powered on."
fi

# Installation complete
echo -e "${GREEN}"
echo "=================================================================="
echo "             Installation Complete!"
echo "=================================================================="
echo -e "${NC}"

print_success "CUPS print server is now running!"
print_success "Samba file sharing is configured for Windows compatibility."

echo ""
echo "Next steps:"
echo "1. Access CUPS web interface at: http://${IP_ADDRESS}:631"
echo "2. Go to Administration > Add Printer"
echo "3. Select your printer and configure it"
echo "4. Enable 'Share This Printer' option"
echo ""
echo "Client setup:"
echo "- Windows: Use \\\\${IP_ADDRESS}\\printer-name"
echo "- Linux: Printer should auto-discover"
echo "- Android: Use Canon Print Service or Mopria"
echo ""
echo "For troubleshooting, check the logs:"
echo "- CUPS logs: sudo tail -f /var/log/cups/error_log"
echo "- Samba logs: sudo tail -f /var/log/samba/log.smbd"
echo ""

print_success "Your Raspberry Pi is now ready to serve as a wireless print server!"