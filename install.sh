#!/bin/bash

# ====================================================================
# OMARCHY MACOS SETUP SCRIPT
# Automated installation and configuration for Hyprland-like experience
# ====================================================================

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
cat << "EOF"
 ██████╗ ███╗   ███╗ █████╗ ██████╗  ██████╗██╗  ██╗██╗   ██╗
██╔═══██╗████╗ ████║██╔══██╗██╔══██╗██╔════╝██║  ██║╚██╗ ██╔╝
██║   ██║██╔████╔██║███████║██████╔╝██║     ███████║ ╚████╔╝ 
██║   ██║██║╚██╔╝██║██╔══██║██╔══██╗██║     ██╔══██║  ╚██╔╝  
╚██████╔╝██║ ╚═╝ ██║██║  ██║██║  ██║╚██████╗██║  ██║   ██║   
 ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   
                                                               
         macOS Setup - Hyprland-Inspired Experience            
EOF
echo -e "${NC}"

# ====================================================================
# FUNCTIONS
# ====================================================================

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# ====================================================================
# PRE-FLIGHT CHECKS
# ====================================================================

print_step "Running pre-flight checks..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not installed. Please install it first:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi
print_success "Homebrew is installed"

# ====================================================================
# INSTALLATION
# ====================================================================

print_step "Installing required packages..."

# Install core packages
brew list yabai &>/dev/null || brew install koekeishiya/formulae/yabai
brew list skhd &>/dev/null || brew install koekeishiya/formulae/skhd
brew list sketchybar &>/dev/null || brew install FelixKratz/formulae/sketchybar
brew list borders &>/dev/null || brew install FelixKratz/formulae/borders
brew list jq &>/dev/null || brew install jq

print_success "All packages installed"

# ====================================================================
# BACKUP EXISTING CONFIGS
# ====================================================================

print_step "Backing up existing configurations..."

backup_dir="$HOME/.config/omarchy-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

[ -f "$HOME/.yabairc" ] && cp "$HOME/.yabairc" "$backup_dir/"
[ -f "$HOME/.skhdrc" ] && cp "$HOME/.skhdrc" "$backup_dir/"
[ -d "$HOME/.config/sketchybar" ] && cp -r "$HOME/.config/sketchybar" "$backup_dir/"
[ -d "$HOME/.config/borders" ] && cp -r "$HOME/.config/borders" "$backup_dir/"

print_success "Backups saved to $backup_dir"

# ====================================================================
# DEPLOY CONFIGURATIONS
# ====================================================================

print_step "Deploying Omarchy configurations..."

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Deploy yabai config
if [ -f "$SCRIPT_DIR/configs/yabairc" ]; then
    cp "$SCRIPT_DIR/configs/yabairc" "$HOME/.yabairc"
    chmod +x "$HOME/.yabairc"
    print_success "yabai config deployed"
else
    print_error "yabairc not found in $SCRIPT_DIR/configs/"
    exit 1
fi

# Deploy skhd config
if [ -f "$SCRIPT_DIR/configs/skhdrc" ]; then
    cp "$SCRIPT_DIR/configs/skhdrc" "$HOME/.skhdrc"
    chmod +x "$HOME/.skhdrc"
    print_success "skhd config deployed"
else
    print_error "skhdrc not found in $SCRIPT_DIR/configs/"
    exit 1
fi

# Create config directories
mkdir -p "$HOME/.config/"{yabai,skhd,sketchybar,borders}

# Deploy SketchyBar configs
if [ -d "$SCRIPT_DIR/configs/sketchybar" ]; then
    cp -r "$SCRIPT_DIR/configs/sketchybar/"* "$HOME/.config/sketchybar/"
    chmod +x "$HOME/.config/sketchybar/sketchybarrc"
    chmod +x "$HOME/.config/sketchybar/plugins/"*.sh
    print_success "SketchyBar configs deployed"
fi

# Deploy borders config
if [ -d "$SCRIPT_DIR/configs/borders" ]; then
    cp -r "$SCRIPT_DIR/configs/borders/"* "$HOME/.config/borders/"
    chmod +x "$HOME/.config/borders/bordersrc"
    print_success "Borders config deployed"
fi

# ====================================================================
# ACCESSIBILITY PERMISSIONS
# ====================================================================

print_step "Checking accessibility permissions..."

echo ""
print_warning "IMPORTANT: You need to grant accessibility permissions!"
echo ""
echo "  1. Open System Settings > Privacy & Security > Accessibility"
echo "  2. Add and enable:"
echo "     - yabai"
echo "     - skhd"
echo "     - Terminal (or your terminal app)"
echo ""
read -p "Press Enter after granting permissions..."

# ====================================================================
# START SERVICES
# ====================================================================

print_step "Starting services..."

# Stop existing processes
killall yabai 2>/dev/null || true
killall skhd 2>/dev/null || true
killall sketchybar 2>/dev/null || true
killall borders 2>/dev/null || true

# Start yabai
yabai &
print_success "yabai started"

# Start skhd
skhd &
print_success "skhd started"

# Start sketchybar
sketchybar &
print_success "sketchybar started"

# Start borders
borders &
print_success "borders started"

sleep 2
print_success "All services started"

# ====================================================================
# SIP CONFIGURATION (OPTIONAL)
# ====================================================================

echo ""
print_step "Optional: Advanced Features (Requires SIP Partially Disabled)"
echo ""
echo "For window animations, opacity, and advanced features:"
echo ""
echo "1. Reboot into Recovery Mode (Hold Cmd+R during boot)"
echo "2. Open Terminal and run:"
echo "   csrutil enable --without debug --without fs"
echo "3. Reboot normally"
echo "4. Configure sudoers for yabai:"
echo "   echo \"\$(whoami) ALL=(root) NOPASSWD: sha256:\$(shasum -a 256 \$(which yabai) | cut -d \" \" -f 1) \$(which yabai) --load-sa\" | sudo tee /private/etc/sudoers.d/yabai"
echo "5. Uncomment scripting addition lines in ~/.yabairc"
echo ""
read -p "Have you completed these steps? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_success "Great! Restarting yabai with scripting addition..."
    sudo yabai --load-sa
    killall yabai
    yabai &
    sleep 1
fi

# ====================================================================
# COMPLETION
# ====================================================================

echo ""
echo -e "${GREEN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                  INSTALLATION COMPLETE! 🎉                     ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo "Your macOS now has an Omarchy/Hyprland-inspired setup!"
echo ""
echo "Key Features:"
echo "  ✓ BSP tiling window manager (yabai)"
echo "  ✓ Hyprland-style keybindings (skhd)"
echo "  ✓ Modern status bar (sketchybar)"
echo "  ✓ Colored window borders (borders)"
echo ""
echo "Quick Start:"
echo "  • cmd + h/j/k/l: Navigate windows"
echo "  • cmd + 1-9: Switch workspaces"
echo "  • cmd + shift + 1-9: Move window to workspace"
echo "  • cmd + f: Toggle fullscreen"
echo "  • cmd + space: Toggle floating"
echo "  • cmd + r: Enter resize mode"
echo ""
echo "Configuration files:"
echo "  ~/.yabairc"
echo "  ~/.skhdrc"
echo "  ~/.config/sketchybar/"
echo "  ~/.config/borders/"
echo ""
echo "Troubleshooting:"
echo "  • View logs: tail -f /tmp/yabai_*.log"
echo "  • Restart yabai: killall yabai && yabai &"
echo "  • Restart skhd: killall skhd && skhd &"
echo "  • Restart sketchybar: killall sketchybar && sketchybar &"
echo "  • Restart borders: killall borders && borders &"
echo "  • Restart skhd: brew services restart skhd"
echo ""
print_success "Enjoy your new setup!"
