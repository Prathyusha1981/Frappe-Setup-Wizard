#!/bin/bash
# config.sh - Global configuration, colors, and defaults for Frappe Setup Wizard

# ---------- Colors ----------
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export BOLD='\033[1m'
export NC='\033[0m' # No Color

# ---------- Paths ----------
export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LOG_DIR="$PROJECT_ROOT/logs"
export CONF_FILE="$PROJECT_ROOT/configs/apps.conf"
export LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d)-install.log"

mkdir -p "$LOG_DIR"

# ---------- Load user config (if present) ----------
if [ -f "$CONF_FILE" ]; then
    # shellcheck disable=SC1090
    source "$CONF_FILE"
fi

# ---------- Defaults (used if not set in apps.conf) ----------
DEFAULT_VERSION="${DEFAULT_VERSION:-version-15}"
DEFAULT_NODE="${DEFAULT_NODE:-18}"
DEFAULT_APPS="${DEFAULT_APPS:-erpnext}"
WORKSPACE="${WORKSPACE:-$HOME/Projects}"

export DEFAULT_VERSION DEFAULT_NODE DEFAULT_APPS WORKSPACE
