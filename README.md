<p align="center">
  <img src="syslinux/splash.png" alt="ArchCosta" width="480"/>
</p>

<h1 align="center">ArchCosta</h1>

<p align="center">
  <strong>A minimal, custom Arch Linux distribution with MangoWM Wayland compositor</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Arch%20Linux-Rolling-blue?style=flat-square&logo=archlinux" alt="Arch Linux"/>
  <img src="https://img.shields.io/badge/Wayland-MangoWM-purple?style=flat-square" alt="Wayland"/>
  <img src="https://img.shields.io/badge/License-GPL--3.0-green?style=flat-square" alt="GPL-3.0"/>
  <img src="https://img.shields.io/badge/Status-Active-brightgreen?style=flat-square" alt="Active"/>
</p>

---

## Overview

ArchCosta is a personal Arch Linux-based distribution built on the [archiso](https://wiki.archlinux.org/title/Archiso) build system. It features a clean Wayland desktop environment powered by the [MangoWM](https://github.com/DreamMaoMao/mango) compositor, with a custom dark purple/rose color palette and curated selection of tools.

This is a personal project maintained for my own use, but anyone is welcome to try it, fork it, or build upon it.

## Features

| Feature | Description |
|---------|-------------|
| **MangoWM** | Lightweight Wayland compositor with tiling, floating, and scroller layouts |
| **Waybar** | Top panel with workspaces, clock, battery, and network indicators |
| **Rofi** | Application launcher with custom themed interface |
| **Foot** | Fast, minimal Wayland terminal emulator |
| **Mako** | Notification daemon with matching color scheme |
| **Swaybg** | Wallpaper manager with curated wallpaper collection |
| **Thunar** | Full-featured file manager with volume management |
| **Firefox** | Pre-configured web browser |
| **NetworkManager** | Network management with rofi integration |
| **Built-in Installers** | Both TUI and browser-based system installers |

## Screenshots

<div align="center">

> *The boot splash, desktop, and wallpapers are all custom-generated with the ArchCosta color palette.*

</div>

## Color Palette

```
Background:    #1a1025    ████████
Surface:       #251848    ████████
Foreground:    #e0d0e8    ████████
Accent:        #c0568b    ████████
Urgent:        #f2729a    ████████
Dim:           #7b4178    ████████
```

## Wallpapers

ArchCosta ships with 4 custom-generated wallpapers:

| # | Name | Style |
|---|------|-------|
| 01 | Aurora Landscape | Mountain silhouette with aurora borealis effect |
| 02 | Geometric Pattern | Hexagonal grid with accent glow |
| 03 | Abstract Waves | Flowing gradient wave layers |
| 04 | Constellation | Minimal star field with constellation lines |

All wallpapers are in the purple/rose palette and complement the Waybar, Rofi, and Mako themes.

## Building the ISO

### Prerequisites

- An Arch Linux system (or similar)
- `archiso` package installed
- Root privileges

### Build Steps

```bash
# Clone the repository
git clone https://github.com/archcosta-os/archcosta.git
cd archcosta

# Build the ISO (requires root)
sudo ./build -v .
```

The ISO will be generated in the `out/` directory.

### Build Options

```
./build [options] <profile_dir>

Options:
  -A <name>     Set application name
  -C <file>     pacman configuration file
  -D <dir>      Installation directory
  -L <label>    ISO volume label
  -P <pub>      ISO publisher
  -o <dir>      Output directory
  -w <dir>      Working directory
  -v            Verbose output
  -r            Remove working directory after build
```

## Project Structure

```
archcosta/
├── airootfs/                  # Root filesystem overlay
│   ├── etc/
│   │   ├── os-release         # Distribution identification
│   │   ├── hosts              # Host configuration
│   │   ├── locale.conf        # Locale settings
│   │   ├── passwd             # User accounts
│   │   ├── shadow             # Password hashes
│   │   ├── modprobe.d/        # Kernel module configuration
│   │   ├── mkinitcpio.conf.d/ # Initramfs configuration
│   │   ├── polkit-1/rules.d/  # PolicyKit rules
│   │   └── systemd/           # Systemd services and mounts
│   ├── root/
│   │   └── customize_airootfs.sh  # ISO customization script
│   └── skel/                  # Default user configuration
│       ├── .bash_profile      # Login shell (starts MangoWM)
│       ├── .bashrc            # Shell configuration
│       ├── .vimrc             # Vim configuration
│       ├── .config/           # Application configurations
│       │   ├── foot/          # Terminal emulator
│       │   ├── gtk-3.0/       # GTK theme
│       │   ├── mako/          # Notifications
│       │   ├── mango/         # Window manager
│       │   ├── rofi/          # Application launcher
│       │   ├── waybar/        # Status bar
│       │   └── xfce4/         # Thunar file manager
│       ├── Backgrounds/       # Wallpaper collection
│       ├── Documents/         # User documentation
│       └── Scripts/           # Utility scripts
├── efiboot/                   # UEFI boot configuration
│   └── loader/
│       ├── loader.conf        # systemd-boot config
│       └── entries/           # Boot entries
├── syslinux/                  # BIOS boot configuration
│   ├── syslinux.cfg           # Boot menu
│   └── splash.png             # Boot splash image
├── build                      # ISO build script
├── packages.x86_64            # Package list
├── pacman.conf                # Pacman configuration
├── profiledef.sh              # Profile definition
├── LICENSE                    # GPL-3.0 license
└── README.md                  # This file
```

## Keybindings

| Key | Action |
|-----|--------|
| `Super+Return` | Open terminal |
| `Super+Space` | Application launcher |
| `Super+w` | Open Firefox |
| `Super+q` | Close window |
| `Super+f` | Toggle fullscreen |
| `Super+s` | Toggle floating |
| `Super+g` | Toggle gaps |
| `Super+1-9` | Switch to tag |
| `Super+Shift+1-9` | Move window to tag |
| `Super+Shift+e` | Power menu |
| `Super+Shift+p` | Pacman menu |
| `Super+l` | Lock screen |

See `Documents/Keybindings` for the complete reference.

## Customization

### Changing the Wallpaper

Edit `airootfs/etc/skel/.config/mango/config.conf` and update the `exec-once=swaybg` line:

```conf
exec-once=swaybg -i /home/live/Backgrounds/archcosta-wallpaper-01.png -m fill
```

Available wallpapers:
- `archcosta-wallpaper-01.png` - Aurora Landscape (default)
- `archcosta-wallpaper-02.png` - Geometric Pattern
- `archcosta-wallpaper-03.png` - Abstract Waves
- `archcosta-wallpaper-04.png` - Constellation

### Adding Packages

Edit `packages.x86_64` to add or remove packages from the live ISO.

### Modifying Colors

The color scheme is defined in multiple locations:
- `airootfs/etc/skel/.config/mango/config.conf` - Window manager colors
- `airootfs/etc/skel/.config/waybar/style.css` - Panel colors
- `airootfs/etc/skel/.config/rofi/theme.rasi` - Launcher colors
- `airootfs/etc/skel/.config/foot/foot.ini` - Terminal colors
- `airootfs/etc/skel/.config/mako/config` - Notification colors

## Post-Installation

After installing ArchCosta to disk:

1. **Update the system**: `sudo pacman -Syu`
2. **Install yay** (AUR helper): `~/Scripts/install-yay`
3. **Initialize keyring**: `~/Scripts/fix-keys`
4. **Customize your desktop**: Edit files in `~/.config/`

## Contributing

This is a personal project, but contributions are welcome:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test by building the ISO
5. Submit a pull request

## Acknowledgments

- [Arch Linux](https://archlinux.org/) - The base distribution
- [archiso](https://gitlab.archlinux.org/archlinux/archiso) - The ISO build tool
- [MangoWM](https://github.com/DreamMaoMao/mango) - The Wayland compositor
- [Waybar](https://github.com/Alexays/Waybar) - The status bar
- [Rofi](https://github.com/DaveDavenport/rofi) - The application launcher
- [Foot](https://codeberg.org/dnkl/foot) - The terminal emulator

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <sub>Built with care on Arch Linux</sub>
</p>
