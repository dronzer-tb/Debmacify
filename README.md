# DebMacify

DebMacify is a one-click setup script for Debian-based systems that:
- Debloats the OS (removes Snap, installs Flatpak)
- Applies macOS-like themes and icons
- Installs GNOME extensions and useful software
- Configures dock behavior
- Sets startup apps
- Installs and initializes Waydroid
- Installs prime-run for NVIDIA users
- Installs and switches to Nala for faster updates

## How to Use

1. Extract `debmacify_package.zip`
2. Open a terminal in the folder
3. Make the script executable:
   ```bash
   chmod +x debmacify.sh
   ```
4. Run the script:
   ```bash
   ./debmacify.sh
   ```

5. Follow the on-screen checklist (Zenity-based UI)

## Requirements

- Debian-based OS (Ubuntu, Linux Mint, etc.)
- Internet connection
- Zenity (auto-installed if missing)

## Logs

All output is logged in:
```
~/debmacify-logs/install.log
```

## Notes

- NVIDIA users: you will be informed to install drivers manually.
- Nala will be aliased to `apt` automatically in your bashrc.

Enjoy your clean, themed, and optimized Linux experience!



### Credits & Attributions

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
  
