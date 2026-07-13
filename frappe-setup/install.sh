#!/bin/bash
# install.sh - Frappe Setup Wizard - Main Entry Point
set -uo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=config.sh
source "$PROJECT_ROOT/config.sh"
# shellcheck source=functions.sh
source "$PROJECT_ROOT/functions.sh"

# Source all script modules
for f in "$PROJECT_ROOT"/scripts/*.sh; do
    # shellcheck disable=SC1090
    source "$f"
done

log "=== Frappe Setup Wizard started ==="

show_menu() {
    clear
    echo -e "${BOLD}${BLUE}==========================================="
    echo -e "        Frappe Setup Wizard"
    echo -e "===========================================${NC}"
    echo ""
    echo "1. Install Dependencies"
    echo "2. Create New Bench"
    echo "3. Create New Site"
    echo "4. Install Apps"
    echo "5. Start Bench"
    echo "6. Update Existing Bench"
    echo "7. Doctor (Check Environment)"
    echo "8. Cleanup"
    echo "9. Exit"
    echo ""
    read -rp "Choose: " CHOICE
}

main() {
    while true; do
        show_menu
        case "$CHOICE" in
            1) install_dependencies ;;
            2) create_bench ;;
            3) create_site ;;
            4) install_apps ;;
            5) start_bench ;;
            6) run_update ;;
            7) run_doctor ;;
            8) run_cleanup ;;
            9) echo -e "${CYAN}Goodbye!${NC}"; log "=== Wizard exited ==="; exit 0 ;;
            *) print_warning "Invalid option, try again." ;;
        esac
        echo ""
        read -rp "Press Enter to return to menu..." _
    done
}

main
