# Omarchy macOS Setup

A Hyprland-inspired window management and aesthetics setup for macOS, bringing the best of Linux tiling window managers to Apple Silicon and Intel Macs.

## 🎯 Overview

This setup replicates the beautiful, modern experience of [Omarchy](https://omarchy.org/) (DHH's Arch Linux distribution using Hyprland) on macOS using:

- **yabai** - BSP tiling window manager
- **skhd** - Hotkey daemon for keyboard-driven workflow
- **SketchyBar** - Modern, customizable status bar
- **JankyBorders** - Colored window borders

## ✨ Features

### Window Management
- ✅ **BSP (Binary Space Partitioning) layout** - Automatic, intelligent window tiling
- ✅ **Smooth animations** - Window transitions with configurable easing
- ✅ **Opacity effects** - Transparent inactive windows
- ✅ **Gap and padding** - Aesthetic spacing between windows
- ✅ **Multi-display support** - Seamless workspace across monitors

### Keybindings (Hyprland-style)
- ✅ **SUPER (cmd) key** as primary modifier
- ✅ **Vim-like navigation** (hjkl)
- ✅ **Workspace switching** with number keys
- ✅ **Resize mode** for modal window resizing
- ✅ **Floating window management**

### Visual Aesthetics
- ✅ **Colored window borders** - Blue for active, grey for inactive
- ✅ **Modern status bar** - Workspace indicators, system info, clock
- ✅ **Catppuccin Mocha color scheme** - Beautiful, consistent palette
- ✅ **Blurred bar background** - Modern macOS aesthetic

## 📦 Installation

### Quick Install

```bash
# Run the automated setup script
./omarchy-setup.sh
```

### Manual Installation

```bash
# Install tools via Homebrew
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
brew install FelixKratz/formulae/sketchybar
brew install FelixKratz/formulae/borders
brew install jq

# Copy configuration files
cp ~/.yabairc.omarchy ~/.yabairc
cp ~/.skhdrc.omarchy ~/.skhdrc

# Make configs executable
chmod +x ~/.yabairc ~/.skhdrc
chmod +x ~/.config/sketchybar/sketchybarrc
chmod +x ~/.config/sketchybar/plugins/*.sh

# Start services
brew services start yabai
brew services start skhd
brew services start sketchybar
brew services start borders
```

## 🔑 Essential Keybindings

### Window Navigation
- `cmd + h/j/k/l` - Focus window (left/down/up/right)
- `cmd + tab` - Focus recent window
- `cmd + shift + tab` - Focus largest window

### Window Movement
- `cmd + shift + h/j/k/l` - Swap window position
- `cmd + ctrl + h/j/k/l` - Warp (re-insert) window

### Workspace Management
- `cmd + 1-9` - Switch to workspace 1-9
- `cmd + shift + 1-9` - Move window to workspace
- `cmd + [/]` - Previous/next workspace

### Window Actions
- `cmd + f` - Toggle fullscreen
- `cmd + space` - Toggle float/tile
- `cmd + e` - Toggle split orientation
- `cmd + p` - Toggle picture-in-picture
- `cmd + m` - Minimize window
- `cmd + shift + q` - Close window

### Resize Mode
- `cmd + r` - Enter resize mode
- `h/j/k/l` - Resize window (in resize mode)
- `escape` or `return` - Exit resize mode

### Space Management
- `cmd + shift + 0` - Balance windows
- `cmd + shift + r` - Rotate tree 90°
- `cmd + shift + x/y` - Mirror tree (horizontal/vertical)
- `cmd + shift + n` - Create new space
- `cmd + shift + w` - Destroy space

### Display Management
- `cmd + ctrl + 1/2/3` - Focus display
- `cmd + ctrl + shift + 1/2/3` - Move window to display

### System
- `cmd + return` - Launch terminal
- `cmd + shift + return` - Launch browser
- `cmd + ctrl + shift + r` - Restart yabai
- `cmd + ctrl + shift + s` - Restart skhd

## 🎨 Color Scheme (Catppuccin Mocha)

```
Background: #1e1e2e
Foreground: #cdd6f4
Blue:       #89b4fa (Active elements)
Red:        #f38ba8
Green:      #a6e3a1
Yellow:     #f9e2af
Grey:       #6c7086 (Inactive elements)
```

## ⚙️ Advanced Configuration

### Enabling Scripting Addition (Optional)

For advanced features like window animations and opacity:

1. **Disable SIP partially** (requires reboot into Recovery Mode):
   ```bash
   csrutil enable --without debug --without fs
   ```

2. **Configure sudoers**:
   ```bash
   echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
   ```

3. **Uncomment lines in ~/.yabairc**:
   ```bash
   # Uncomment these lines:
   # yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
   # sudo yabai --load-sa
   ```

4. **Restart yabai**:
   ```bash
   brew services restart yabai
   ```

### Customization

#### Modifying Keybindings
Edit `~/.skhdrc` to customize keybindings. After changes:
```bash
brew services restart skhd
```

#### Changing Window Manager Behavior
Edit `~/.yabairc` for window management settings. After changes:
```bash
brew services restart yabai
```

#### Customizing Status Bar
Edit `~/.config/sketchybar/sketchybarrc` and plugins in `~/.config/sketchybar/plugins/`. After changes:
```bash
brew services restart sketchybar
```

#### Adjusting Window Border Colors
Edit `~/.config/borders/bordersrc`. After changes:
```bash
brew services restart borders
```

## 🐛 Troubleshooting

### Yabai not working
- Check accessibility permissions: System Settings > Privacy & Security > Accessibility
- View logs: `tail -f /tmp/yabai_*.log`
- Restart: `brew services restart yabai`

### Keybindings not responding
- Grant accessibility to skhd
- Check config syntax: `skhd -c ~/.skhdrc`
- Restart: `brew services restart skhd`

### SketchyBar not showing
- Check if running: `ps aux | grep sketchybar`
- View logs: `tail -f /tmp/sketchybar*.log`
- Restart: `brew services restart sketchybar`

### Borders not appearing
- Restart: `brew services restart borders`
- Check if running: `ps aux | grep borders`

### Spaces not labeled correctly
Ensure you have at least 6 desktop spaces created in Mission Control.

## 📚 Resources

- [yabai Documentation](https://github.com/koekeishiya/yabai)
- [skhd Documentation](https://github.com/koekeishiya/skhd)
- [SketchyBar Documentation](https://felixkratz.github.io/SketchyBar/)
- [Hyprland Documentation](https://hyprland.org/) (inspiration source)
- [Omarchy](https://omarchy.org/)

## 🔄 Differences from Hyprland

| Feature | Hyprland (Linux) | Yabai (macOS) |
|---------|------------------|---------------|
| **Compositor** | Wayland | macOS native |
| **SIP Required** | N/A | Partially disabled for advanced features |
| **GPU Animations** | Native | Limited |
| **Blur Effects** | Compositor-level | macOS native |
| **Touchpad Gestures** | Full support | Limited |
| **Setup Complexity** | Medium | Medium-High |

## 🤝 Contributing

Feel free to customize and share your configurations! This setup is designed to be a starting point for your own Omarchy-inspired macOS experience.

## 📝 License

MIT License - Free to use and modify.

---

**Enjoy your beautiful, keyboard-driven macOS setup! 🚀**
