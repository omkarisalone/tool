#!/bin/bash

# ─────────────────────────────────────────────
#  @omkarnub SKIN TOOL AUTO-INSTALL TOOLKIT
#  OMKAR global launcher + dependencies
# ─────────────────────────────────────────────

# Neon Cyberpunk Theme Colors
GAMING_GREEN='\033[1;38;5;82m'    # neon green
GAMING_YELLOW='\033[1;38;5;220m'  # bright yellow
GAMING_ORANGE='\033[1;38;5;208m'  # orange
GAMING_BLUE='\033[1;38;5;45m'     # cyan-blue
GAMING_RED='\033[1;38;5;196m'     # bright red
GAMING_PURPLE='\033[1;38;5;207m'  # magenta
GAMING_CYAN='\033[1;38;5;51m'     # cyan
BANNER_COLOR='\033[1;38;5;201m'   # pink/purple title
NC='\033[0m'

# Progress bar function
progress_bar() {
    local duration=$1
    local step=$2
    local total=$3
    local message=$4
    
    local percentage=$((step * 100 / total))
    local filled=$((percentage / 2))
    local empty=$((50 - filled))
    
    printf "\r${GAMING_CYAN}[${GAMING_ORANGE}"
    printf "%0.s█" $(seq 1 $filled)
    printf "%0.s░" $(seq 1 $empty)
    printf "${GAMING_CYAN}] ${GAMING_YELLOW}%3d%%${NC} - ${GAMING_GREEN}%s${NC}" "$percentage" "$message"
    
    if [ $step -eq $total ]; then
        echo ""
    fi
}

# Banner
echo -e "${BANNER_COLOR}"
echo "╔══════════════════════════════════════════════════╗"
echo "║ @omkarnub SKIN TOOL DEPENDENCY AUTO-INSTALL KIT  ║"
echo "║      @omkarnub skin tool dependency toolkit      ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if running in Termux
if [ ! -d "/data/data/com.termux/files/usr" ]; then
    echo -e "${GAMING_RED}❌ Error: This script must be run in Termux${NC}"
    exit 1
fi

# Function to check command success
check_success() {
    if [ $? -eq 0 ]; then
        echo -e "${GAMING_GREEN}✅ Success${NC}"
    else
        echo -e "${GAMING_RED}❌ Failed${NC}"
    fi
}

# Variables
INSTALL_DIR="$HOME/OMNX"
ZIP_NAME="tool.zip"
GITHUB_ZIP_URL="https://github.com/omkarisalone/tool/archive/refs/heads/main.zip"
EXTRACT_DIR="tool-main"
MAIN_BINARY_NAME="omkar"
LAUNCHER_NAME="omkar"

# Update packages
echo -e "${GAMING_YELLOW}══════════════════════════════════════════════════${NC}"
echo -e "${GAMING_ORANGE}[1] Updating Termux packages...${NC}"
progress_bar 5 1 10 "Updating package list"
pkg update -y
check_success

# Install dependencies
echo -e "${GAMING_ORANGE}[2] Installing dependencies...${NC}"
progress_bar 5 2 10 "Installing packages"
pkg install -y python git wget unzip -o Dpkg::Options::="--force-confnew"
check_success

# Create OMNX directory in Termux home
echo -e "${GAMING_ORANGE}[3] Creating OMNX directory...${NC}"
progress_bar 5 3 10 "Setting up workspace"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit 1
check_success

# Clean previous installations
echo -e "${GAMING_ORANGE}[4] Cleaning previous installations...${NC}"
progress_bar 5 4 10 "Cleaning old files"
rm -f "$ZIP_NAME"
rm -rf "$EXTRACT_DIR"
check_success

# Download the tool
echo -e "${GAMING_ORANGE}[5] Downloading SKIN tool by OMKAR...${NC}"
echo -e "${GAMING_CYAN}📥 Downloading from GitHub...${NC}"
progress_bar 10 5 10 "Starting download"
wget -O "$ZIP_NAME" "$GITHUB_ZIP_URL"

if [ ! -f "$ZIP_NAME" ]; then
    echo -e "${GAMING_RED}❌ Error: Failed to download the tool${NC}"
    exit 1
fi
progress_bar 10 7 10 "Download complete"
check_success

# Extract files
echo -e "${GAMING_ORANGE}[6] Extracting files...${NC}"
progress_bar 5 6 10 "Extracting archive"
unzip -o "$ZIP_NAME" > /dev/null 2>&1
rm -f "$ZIP_NAME"
progress_bar 5 7 10 "Organizing files"

if [ -d "$EXTRACT_DIR" ]; then
    mv "$EXTRACT_DIR"/* .
    rm -rf "$EXTRACT_DIR"
fi
check_success

# Install Python modules
echo -e "${GAMING_ORANGE}[7] Installing Python modules...${NC}"
progress_bar 9 1 9 "Installing requests"
pip install requests > /dev/null 2>&1
progress_bar 9 2 9 "Installing rich"
pip install rich > /dev/null 2>&1
progress_bar 9 3 9 "Installing colorama"
pip install colorama > /dev/null 2>&1
progress_bar 9 4 9 "Installing tqdm"
pip install tqdm > /dev/null 2>&1
progress_bar 9 5 9 "Installing pycryptodome"
pip install pycryptodome > /dev/null 2>&1
progress_bar 9 6 9 "Installing zstandard==0.22.0"
pip install zstandard==0.22.0 > /dev/null 2>&1
progress_bar 9 7 9 "Installing textual"
pip install textual > /dev/null 2>&1
progress_bar 9 8 9 "Installing gmalg (optional)"
pip install gmalg > /dev/null 2>&1 2>/dev/null || echo -e "${GAMING_YELLOW}[!] gmalg skipped (optional)${NC}"
progress_bar 9 9 9 "Python modules complete"
echo -e "${GAMING_GREEN}✅ Python dependencies installed${NC}"

# Set up the binary executable
echo -e "${GAMING_ORANGE}[8] Setting up executable...${NC}"
progress_bar 5 8 10 "Checking binary"

MAIN_FILE=""

if [ -f "$MAIN_BINARY_NAME" ]; then
    chmod +x "$MAIN_BINARY_NAME"
    MAIN_FILE="$MAIN_BINARY_NAME"
    echo -e "${GAMING_GREEN}✅ Main tool file detected: ${MAIN_BINARY_NAME}${NC}"
else
    # Try to find any executable file
    MAIN_FILE=$(find . -maxdepth 1 -type f -executable | head -1)
    if [ -n "$MAIN_FILE" ]; then
        echo -e "${GAMING_YELLOW}⚠️  Found executable: $MAIN_FILE${NC}"
        if [ "$MAIN_FILE" != "./$MAIN_BINARY_NAME" ] && [ "$MAIN_FILE" != "$MAIN_BINARY_NAME" ]; then
            mv "$MAIN_FILE" "$MAIN_BINARY_NAME"
            chmod +x "$MAIN_BINARY_NAME"
            MAIN_FILE="$MAIN_BINARY_NAME"
            echo -e "${GAMING_GREEN}✅ Renamed to '${MAIN_BINARY_NAME}'${NC}"
        fi
    else
        echo -e "${GAMING_RED}❌ Error: No executable file found in the package${NC}"
        echo -e "${GAMING_YELLOW}📁 Files in directory:${NC}"
        ls -la
        exit 1
    fi
fi

# Create launcher script in Termux bin directory
echo -e "${GAMING_ORANGE}[9] Creating launcher command '${LAUNCHER_NAME}'...${NC}"
progress_bar 5 9 10 "Setting up command"

cat > "$PREFIX/bin/${LAUNCHER_NAME}" << 'EOF'
#!/bin/bash
TOOL_DIR="$HOME/OMNX"
TOOL_BIN="$TOOL_DIR/omkar"

# Check if tool directory exists
if [ ! -d "$TOOL_DIR" ]; then
    echo -e "\033[1;91m❌ Error: OMKAR SKIN tool directory not found!\033[0m"
    echo -e "\033[1;93mReinstall with the installer script.\033[0m"
    exit 1
fi

# Check if tool file exists
if [ ! -f "$TOOL_BIN" ]; then
    echo -e "\033[1;91m❌ Error: omkar tool not found in $TOOL_DIR/\033[0m"
    exit 1
fi

# Ensure it's executable
chmod +x "$TOOL_BIN" 2>/dev/null

# Change to tool directory and execute
cd "$TOOL_DIR"
exec "./omkar" "$@"
EOF

chmod +x "$PREFIX/bin/${LAUNCHER_NAME}"

# Remove existing aliases
sed -i '/alias omkar/d' ~/.bashrc 2>/dev/null
sed -i '/alias omkar/d' ~/.zshrc 2>/dev/null

# Create new alias (optional backup)
echo "alias omkartool='cd ~/OMNX && ./omkar'" >> ~/.bashrc

if [ -f ~/.zshrc ]; then
    echo "alias omkartool='cd ~/OMNX && ./omkar'" >> ~/.zshrc
fi

progress_bar 5 10 10 "Installation complete"
check_success

# Final setup
echo -e "${GAMING_YELLOW}══════════════════════════════════════════════════${NC}"
source ~/.bashrc 2>/dev/null

# Display completion message
echo -e "${BANNER_COLOR}"
echo "╔══════════════════════════════════════════════════╗"
echo "║            SKIN TOOL INSTALL COMPLETE            ║"
echo "║                 POWERED BY OMKAR                 ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${GAMING_GREEN}🎮 SKIN Tool by OMKAR successfully installed!${NC}"
echo ""
echo -e "${GAMING_CYAN}🚀 Quick Start:${NC}"
echo -e "   ${GAMING_YELLOW}Type: ${GAMING_ORANGE}omkar${GAMING_YELLOW} to start the tool${NC}"
echo ""
echo -e "${GAMING_CYAN}📁 Installation Location:${NC}"
echo -e "   ${GAMING_GREEN}$INSTALL_DIR/${NC}"
echo ""
echo -e "${GAMING_CYAN}✅ Launcher created at:${NC}"
echo -e "   ${GAMING_GREEN}$PREFIX/bin/omkar${NC}"
echo ""
echo -e "${GAMING_CYAN}🔧 Testing installation:${NC}"
echo -e "   ${GAMING_YELLOW}Run: ${GAMING_ORANGE}which omkar${GAMING_YELLOW} (should show $PREFIX/bin/omkar)${NC}"
echo -e "   ${GAMING_YELLOW}Run: ${GAMING_ORANGE}omkar${GAMING_YELLOW} to start the tool${NC}"
echo ""
echo -e "${GAMING_YELLOW}══════════════════════════════════════════════════${NC}"
echo -e "${GAMING_GREEN}💡 SKIN tool is now available anywhere in Termux!${NC}"
echo -e "${GAMING_GREEN}✨ Just type ${GAMING_ORANGE}omkar${GAMING_GREEN} and press Enter${NC}"
echo -e "${GAMING_YELLOW}══════════════════════════════════════════════════${NC}"

# Show ASCII art
echo -e "${GAMING_CYAN}"
echo "    ___   ___   ___   ___  "
echo "   | S | | K | | I | | N | "
echo "   ‾‾‾   ‾‾‾   ‾‾‾   ‾‾‾   "
echo "  ┌──────────────────────┐ "
echo "  │   SKIN TOOL BY OMKAR │ "
echo "  │        READY         │ "
echo "  └──────────────────────┘ "
echo -e "${NC}"

# Test the installation
echo -e "${GAMING_YELLOW}🔍 Testing installation...${NC}"
if command -v omkar > /dev/null 2>&1; then
    echo -e "${GAMING_GREEN}✅ Launcher 'omkar' installed successfully!${NC}"
    echo -e "${GAMING_GREEN}✅ You can now run 'omkar' from anywhere${NC}"
else
    echo -e "${GAMING_YELLOW}⚠️  Note: You may need to restart Termux or run:${NC}"
    echo -e "${GAMING_GREEN}   source ~/.bashrc${NC}"
fi