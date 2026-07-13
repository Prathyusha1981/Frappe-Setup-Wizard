#!/bin/bash
# functions.sh - Shared helper functions for Frappe Setup Wizard

# ---------- Logging ----------
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ---------- Pretty print helpers ----------
print_success() {
    echo -e "${GREEN}✔${NC} $1"
    log "SUCCESS: $1"
}

print_error() {
    echo -e "${RED}✖${NC} $1"
    log "ERROR: $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    log "WARNING: $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
    log "INFO: $1"
}

print_header() {
    echo ""
    echo -e "${BOLD}${BLUE}===========================================${NC}"
    echo -e "${BOLD}${BLUE}   $1${NC}"
    echo -e "${BOLD}${BLUE}===========================================${NC}"
    echo ""
}

# ---------- Confirmation prompt ----------
confirm() {
    local prompt="$1"
    read -rp "$(echo -e "${YELLOW}${prompt} (y/n): ${NC}")" answer
    case "$answer" in
        [Yy]*) return 0 ;;
        *) return 1 ;;
    esac
}

# ---------- Command existence check ----------
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ---------- Run a step with a progress tag ----------
run_step() {
    local step_num="$1"
    local total_steps="$2"
    local description="$3"
    shift 3
    echo -e "${CYAN}[$step_num/$total_steps]${NC} $description..."
    log "STEP $step_num/$total_steps: $description"
    if "$@" >> "$LOG_FILE" 2>&1; then
        print_success "$description"
    else
        print_error "$description failed. See $LOG_FILE for details."
        exit 1
    fi
}

# ---------- Version selection menu ----------
select_version() {
    print_header "Select Frappe Version"
    echo "1. Version 14"
    echo "2. Version 15"
    echo "3. Version 16"
    read -rp "Choice: " choice
    case "$choice" in
        1) VERSION="version-14"; NODE_VERSION=16 ;;
        2) VERSION="version-15"; NODE_VERSION=18 ;;
        3) VERSION="version-16"; NODE_VERSION=20 ;;
        *) print_warning "Invalid choice, using default ($DEFAULT_VERSION)"; VERSION="$DEFAULT_VERSION"; NODE_VERSION="$DEFAULT_NODE" ;;
    esac
    export VERSION NODE_VERSION
}

# ---------- Detect existing bench in current directory tree ----------
detect_bench() {
    if [ -f "$PWD/Procfile" ] && [ -d "$PWD/apps" ] && [ -d "$PWD/sites" ]; then
        BENCH_PATH="$PWD"
        return 0
    fi
    # search one level down (common case: run from workspace root)
    local found
    found=$(find "$PWD" -maxdepth 2 -name "Procfile" 2>/dev/null | head -n1)
    if [ -n "$found" ]; then
        BENCH_PATH="$(dirname "$found")"
        return 0
    fi
    return 1
}
