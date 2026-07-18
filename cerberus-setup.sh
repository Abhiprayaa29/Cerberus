#!/usr/bin/env bash
# =========================================================================
# Cerberus:opencode — One-Command Setup
# =========================================================================
# Jalankan script ini untuk mengaktifkan Cerberus di OpenCode.
# Cukup sekali, langsung plug and play.
#
# Usage:
#   bash cerberus-setup.sh
#
# Dibuat oleh Abhiprayaa29 (https://github.com/Abhiprayaa29)
# =========================================================================

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e ""
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║       Cerberus:opencode — Setup Wizard           ║${NC}"
echo -e "${CYAN}║  Dibuat oleh Abhiprayaa29                       ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo -e ""

# ------------------------------------------------------------------
# Step 1: Cek Prerequisites
# ------------------------------------------------------------------
echo -e "${BOLD}[1/4] Checking prerequisites...${NC}"

if ! command -v bun &> /dev/null; then
    echo -e "  ${YELLOW}⚠ Bun not found. Installing...${NC}"
    curl -fsSL https://bun.sh/install | bash
    export PATH="$HOME/.bun/bin:$PATH"
fi
echo -e "  ${GREEN}✓ Bun: $(bun --version)${NC}"

if ! command -v git &> /dev/null; then
    echo -e "  ${RED}✗ Git not found. Please install git first.${NC}"
    exit 1
fi
echo -e "  ${GREEN}✓ Git: $(git --version | head -1)${NC}"

# ------------------------------------------------------------------
# Step 2: Install Plugin oh-my-open-pentest
# ------------------------------------------------------------------
echo -e ""
echo -e "${BOLD}[2/4] Installing oh-my-open-pentest plugin...${NC}"

if ! bunx oh-my-open-pentest doctor &>/dev/null 2>&1; then
    echo -e "  ${YELLOW}Installing plugin (non-interactive mode)...${NC}"
    bunx oh-my-open-pentest install --yes 2>/dev/null || {
        echo -e "  ${YELLOW}Running interactive installer...${NC}"
        bunx oh-my-open-pentest install
    }
    echo -e "  ${GREEN}✓ Plugin installed${NC}"
else
    echo -e "  ${GREEN}✓ Plugin already installed${NC}"
fi

# ------------------------------------------------------------------
# Step 3: Konfigurasi Agent
# ------------------------------------------------------------------
echo -e ""
echo -e "${BOLD}[3/4] Configuring Cerberus agent...${NC}"

# Copy agent config ke lokasi yang benar
CONFIG_TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents"
mkdir -p "$CONFIG_TARGET"

if [ -f "cerberus-agent.jsonc" ]; then
    cp cerberus-agent.jsonc "$CONFIG_TARGET/cerberus.jsonc"
    echo -e "  ${GREEN}✓ Agent config copied to $CONFIG_TARGET/cerberus.jsonc${NC}"
else
    echo -e "  ${YELLOW}⚠ cerberus-agent.jsonc not found, skipping${NC}"
fi

# ------------------------------------------------------------------
# Step 4: Verifikasi
# ------------------------------------------------------------------
echo -e ""
echo -e "${BOLD}[4/4] Verification...${NC}"

if command -v bunx &>/dev/null; then
    bunx oh-my-open-pentest doctor 2>/dev/null && {
        echo -e ""
        echo -e "  ${GREEN}✓${NC} ${BOLD}Cerberus is ready!${NC}"
    } || {
        echo -e "  ${YELLOW}⚠ Doctor check incomplete (normal on first run)${NC}"
    }
fi

# ------------------------------------------------------------------
# Done
# ------------------------------------------------------------------
echo -e ""
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  ✅ Setup complete!                              ║${NC}"
echo -e "${CYAN}║                                                  ║${NC}"
echo -e "${CYAN}║  Next steps:                                     ║${NC}"
echo -e "${CYAN}║  1. Buka OpenCode di folder ini:                  ║${NC}"
echo -e "${CYAN}║     opencode .                                    ║${NC}"
echo -e "${CYAN}║                                                  ║${NC}"
echo -e "${CYAN}║  2. Cerberus akan aktif otomatis. Coba:           ║${NC}"
echo -e "${CYAN}║     who created you?                              ║${NC}"
echo -e "${CYAN}║                                                  ║${NC}"
echo -e "${CYAN}║  3. Atau langsung scan target:                    ║${NC}"
echo -e "${CYAN}║     fullscan https://target.example.com           ║${NC}"
echo -e "${CYAN}║                                                  ║${NC}"
echo -e "${CYAN}║  Dibuat oleh Abhiprayaa29                         ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo -e ""
