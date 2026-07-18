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
echo -e "${BOLD}[1/5] Checking prerequisites...${NC}"

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
echo -e "${BOLD}[2/5] Installing oh-my-open-pentest plugin...${NC}"

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
echo -e "${BOLD}[3/5] Configuring Cerberus agent...${NC}"

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
# Step 4: 9Router Model Routing
# ------------------------------------------------------------------
echo -e ""
echo -e "${BOLD}[4/5] 9Router model routing...${NC}"
echo -e "  ${YELLOW}i Cerberus needs these models:${NC}"
echo -e "     claude-opus-4-7, claude-sonnet-4.5, claude-haiku-4.5"
echo -e "     gpt-5.5, gpt-5.4-mini-fast"
echo -e ""

# Cek apakah 9Router berjalan
N9R_DIR="${HOME}/.9router"
if curl -sf http://localhost:20128/api/status &>/dev/null; then
    echo -e "  ${GREEN}✓ 9Router running at http://localhost:20128${NC}"

    # Generate CLI auth token dari machine-id + cli-secret
    N9R_MACHINE_ID="$(cat "$N9R_DIR/machine-id" 2>/dev/null || echo "")"
    N9R_CLI_SECRET="$(cat "$N9R_DIR/auth/cli-secret" 2>/dev/null || echo "")"
    N9R_TOKEN="$(printf '%s' "${N9R_MACHINE_ID}9r-cli-auth${N9R_CLI_SECRET}" | sha256sum | head -c 16)"

    # Helper function untuk 9Router API
    n9r_api() {
        local method="$1" path="$2" body="${3:-}"
        local args=(-s -X "$method" "http://localhost:20128$path" \
            -H "x-9r-cli-token: $N9R_TOKEN" \
            -H "Content-Type: application/json")
        [ -n "$body" ] && args+=(-d "$body")
        curl "${args[@]}"
    }

    # 4a. Update model aliases
    echo -e ""
    echo -e "  ${BOLD}4a. Updating model aliases...${NC}"

    # Baca aliases existing
    EXISTING_ALIASES=$(cat "$N9R_DIR/mitm/aliases.json" 2>/dev/null || echo "{}")

    # Merge dengan aliases Cerberus
    python3 -c "
import json, sys

aliases = json.loads('''$EXISTING_ALIASES''')

# Model aliases untuk Cerberus
cerberus_aliases = {
    # Anthropic Claude
    \"claude-opus-4-7\": \"anthropic/claude-opus-4-7\",
    \"claude-sonnet-4-5\": \"anthropic/claude-sonnet-4-5\",
    \"claude-sonnet-4.5\": \"anthropic/claude-sonnet-4-5\",
    \"claude-haiku-4-5\": \"anthropic/claude-haiku-4-5\",
    \"claude-haiku-4.5\": \"anthropic/claude-haiku-4-5\",

    # OpenAI GPT
    \"gpt-5.5\": \"openai/gpt-5.5\",
    \"gpt-5-4-mini-fast\": \"openai/gpt-5-4-mini-fast\",
    \"gpt-5.4-mini-fast\": \"openai/gpt-5-4-mini-fast\",

    # Cerberus shorthand
    \"cerberus\": \"anthropic/claude-opus-4-7\",
    \"cipher\": \"anthropic/claude-sonnet-4-5\",
    \"scout\": \"anthropic/claude-haiku-4-5\",
    \"intel\": \"openai/gpt-5-4-mini-fast\",
}

aliases.update(cerberus_aliases)
json.dump(aliases, sys.stdout, indent=2)
" > "$N9R_DIR/mitm/aliases.json"

    echo -e "  ${GREEN}✓ Model aliases updated${NC}"

    # 4b. Cek provider yang terdaftar
    echo -e ""
    echo -e "  ${BOLD}4b. Checking registered providers...${NC}"

    PROVIDERS=$(n9r_api GET /api/providers)
    echo -e "  ${YELLOW}i Registered:${NC}"
    echo "$PROVIDERS" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    items = d.get('data', d) if isinstance(d, dict) else d
    if isinstance(items, list):
        for p in items:
            name = p.get('name', p.get('provider', '?'))
            provider = p.get('provider', '')
            print(f'    • {name} ({provider})')
    else:
        print('    (check providers manually)')
except:
    print('    (no providers registered)')
" 2>/dev/null || echo -e "  ${YELLOW}⚠ Could not list providers${NC}"

    # 4c. Setup combos untuk Cerberus
    echo -e ""
    echo -e "  ${BOLD}4c. Setting up model combos...${NC}"

    # Cek apakah combos sudah ada
    COMBO_EXISTS=$(n9r_api GET /api/combos 2>/dev/null | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    items = d.get('data', d) if isinstance(d, dict) else d
    if isinstance(items, list):
        names = [c.get('name','') for c in items]
        print(','.join(names))
    else:
        print('')
except:
    print('')
" 2>/dev/null || echo "")

    if echo "$COMBO_EXISTS" | grep -q "cerberus-main"; then
        echo -e "  ${GREEN}✓ Combo 'cerberus-main' already exists${NC}"
    else
        n9r_api POST /api/combos '{
            "name": "cerberus-main",
            "models": [
                "cerberus",
                "claude-opus-4-7",
                "claude-sonnet-4-5",
                "claude-haiku-4-5",
                "gpt-5.5",
                "gpt-5-4-mini-fast"
            ]
        }' > /dev/null 2>&1 && echo -e "  ${GREEN}✓ Combo 'cerberus-main' created${NC}" \
            || echo -e "  ${YELLOW}⚠ Could not create combo (already exists or no permission)${NC}"
    fi

    # 4d. Update settings kalo ada combo baru
    echo -e ""
    echo -e "  ${BOLD}4d. Updating fallback strategies...${NC}"

    n9r_api PATCH /api/settings '{
        "comboStrategies": {
            "cerberus-main": {
                "fallbackStrategy": "priority",
                "judgeModel": "cerberus"
            }
        }
    }' > /dev/null 2>&1 && echo -e "  ${GREEN}✓ Fallback strategies updated${NC}" \
        || echo -e "  ${YELLOW}⚠ Could not update settings${NC}"

    echo -e ""
    echo -e "  ${GREEN}✓ 9Router configuration complete${NC}"
else
    echo -e "  ${YELLOW}⚠ 9Router not running at localhost:20128${NC}"
    echo -e "  ${YELLOW}  Start 9Router first, then re-run this script.${NC}"
    echo -e "  ${YELLOW}  Or configure providers manually via:${NC}"
    echo -e "  ${YELLOW}  bash ~/.9router/setup-oneshot.sh${NC}"
fi

# ------------------------------------------------------------------
# Step 5: Verifikasi
# ------------------------------------------------------------------
echo -e ""
echo -e "${BOLD}[5/5] Verification...${NC}"

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
