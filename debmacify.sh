#!/bin/bash

# Credits & Attributions

# Credits & Attributions

This script, DebMacify, integrates and automates work from various open source and community-developed resources. Full credit goes to the respective authors:

- **Ubuntu/Debian Debloat Script**  
  Original Author: [demirdegerli](https://gist.github.com/demirdegerli)  
  Source: https://gist.github.com/demirdegerli/b7087c84ef55a1909c21e4966659a2ba

- **WhiteSur GTK Theme, Icon Pack, Wallpapers**  
  Author: [vinceliuice](https://github.com/vinceliuice)  
  GitHub Repos:  
  - https://github.com/vinceliuice/WhiteSur-gtk-theme  
  - https://github.com/vinceliuice/WhiteSur-icon-theme  
  - https://github.com/vinceliuice/WhiteSur-wallpapers

- **Software installed via Flatpak/apt** includes open source and proprietary apps owned by their respective developers, such as:
  - Gnome Extensions: Blur My Shell, Dash to Dock, Magic Lamp, etc.
  - Flatpak apps: Minecraft Bedrock Launcher, Discord, OBS Studio, ProtonVPN, etc.

- **Waydroid installer** uses their official documentation for setup.  
  - https://docs.waydro.id/

- **AI-Generated Automation**  
  Parts of this script were developed with assistance from OpenAI’s ChatGPT to accelerate shell scripting, error handling, and UI development using Zenity.


#!/bin/bash

set -e

# Log Setup
LOGDIR="$HOME/debmacify-logs"
LOGFILE="$LOGDIR/install.log"
SUMMARY="$LOGDIR/summary.txt"
mkdir -p "$LOGDIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "DebMacify started."

# Zenity Check
if ! command -v zenity &>/dev/null; then
    log "Installing Zenity..."
    sudo apt update && sudo apt install -y zenity
fi

# Welcome
zenity --info --title="DebMacify Setup" --text="Welcome to DebMacify!\nThis script will transform and set up your Debian-based system."

# Checklist of tasks
CHOICES=$(zenity --list --checklist --title="DebMacify Tasks" --width=600 --height=400 --text="Select what you want to do:" --column="Select" --column="Task" TRUE "Debloat OS (remove Snap, add Flatpak)" TRUE "Apply macOS-like Theme & Icons" TRUE "Install GNOME Shell Extensions" TRUE "Configure Dock (Position & Autohide)" TRUE "Install Useful Applications" TRUE "Startup Apps: Flameshot & Stretchly" TRUE "Initialize Waydroid" TRUE "NVIDIA: Show Driver Instructions & Install prime-run" TRUE "System Update & Nala preference")

log "User selected: $CHOICES"

# Debloat
if echo "$CHOICES" | grep -q "Debloat"; then
    log "Running debloat script..."
    wget -qO- https://gist.githubusercontent.com/demirdegerli/b7087c84ef55a1909c21e4966659a2ba/raw | bash | tee -a "$LOGFILE"
    log "Debloat completed."
fi

# Theme
if echo "$CHOICES" | grep -q "macOS"; then
    log "Installing WhiteSur themes..."
    sudo apt install -y git gtk2-engines-murrine gtk2-engines-pixbuf
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git ~/WhiteSur-gtk-theme
    bash ~/WhiteSur-gtk-theme/install.sh
    git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git ~/WhiteSur-icon-theme
    bash ~/WhiteSur-icon-theme/install.sh
    git clone https://github.com/vinceliuice/WhiteSur-wallpapers.git ~/Pictures/WhiteSur-wallpapers
    log "Theme applied."
fi

# GNOME Extensions
if echo "$CHOICES" | grep -q "Extensions"; then
    log "Installing GNOME extensions..."
    sudo apt install -y gnome-shell-extensions gnome-tweaks
    EXT_LIST=("blur-my-shell" "search-light" "dash-to-dock" "desktop-icons-ng" "user-theme")
    for ext in "${EXT_LIST[@]}"; do
        log "Installing extension: $ext (manual installation or GNOME website may be needed)"
    done
fi

# Dock Configuration
if echo "$CHOICES" | grep -q "Dock"; then
    POSITION=$(zenity --list --title="Dock Position" --text="Select dock position:" --radiolist         --column "Select" --column "Position"         TRUE "BOTTOM" FALSE "LEFT" FALSE "RIGHT")
    AUTOHIDE=$(zenity --question --title="Autohide Dock" --text="Do you want to enable dock auto-hide?" && echo "true" || echo "false")
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position "$POSITION"
    gsettings set org.gnome.shell.extensions.dash-to-dock autohide "$AUTOHIDE"
    log "Dock configured."
fi

# App Install
if echo "$CHOICES" | grep -q "Useful Applications"; then
    log "Installing applications..."
    flatpak install -y flathub io.mrarm.mcpelauncher com.discordapp.Discord com.protonvpn.ProtonVPN     io.github.localsend.localsend_app org.videolan.VLC org.kde.kdenlive io.github.itsmeow.betterdiscordctl     tv.kodi.Kodi org.stremio.Stremio com.obsproject.Studio app.deskreen.Deskreen org.libreoffice.LibreOffice     org.qbittorrent.qBittorrent org.gnome.Shotwell org.gnome.Boxes
    sudo apt install -y gotop htop neofetch flameshot stretchly teamviewer nvidia-settings
    log "Application installation complete."
fi

# Startup Apps
if echo "$CHOICES" | grep -q "Startup"; then
    mkdir -p ~/.config/autostart
    cp /usr/share/applications/flameshot.desktop ~/.config/autostart/
    cp /usr/share/applications/stretchly.desktop ~/.config/autostart/
    log "Startup apps set."
fi

# Waydroid
if echo "$CHOICES" | grep -q "Waydroid"; then
    log "Installing Waydroid..."
    sudo add-apt-repository -y ppa:waydroid-dev/dev
    sudo apt update && sudo apt install -y waydroid
    sudo waydroid init
    sudo systemctl enable waydroid-container
    sudo systemctl start waydroid-container
    log "Waydroid initialized."
fi

# NVIDIA
if echo "$CHOICES" | grep -q "NVIDIA"; then
    if lspci | grep -i nvidia; then
        zenity --info --title="NVIDIA Drivers" --text="You have an NVIDIA GPU.\nPlease install drivers manually.\nprime-run will be installed."
        sudo apt install -y nvidia-prime
    fi
fi

# Update + Nala
if echo "$CHOICES" | grep -q "System Update"; then
    log "Installing nala and updating system..."
    sudo apt install -y nala
    echo "alias apt='nala'" >> ~/.bashrc
    source ~/.bashrc
    sudo nala update && sudo nala upgrade -y
    log "System updated."
fi

log "DebMacify completed."
zenity --info --title="DebMacify" --text="All selected tasks completed. Check logs in $LOGDIR"
