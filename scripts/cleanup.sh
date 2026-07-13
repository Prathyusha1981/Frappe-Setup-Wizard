#!/bin/bash
# cleanup.sh - Recover from partial/failed installs

run_cleanup() {
    print_header "Cleanup"

    echo "1. Delete Site"
    echo "2. Delete Bench"
    echo "3. Remove App from Bench"
    echo "4. Clear Cache"
    echo "5. Remove Logs"
    echo "6. Back"
    read -rp "Choice: " choice

    case "$choice" in
        1)
            [ -z "$BENCH_PATH" ] && ! detect_bench && { print_error "No bench found."; return 1; }
            cd "$BENCH_PATH" || return 1
            read -rp "Site name to delete: " site
            if confirm "This will permanently delete '$site' and its database. Continue"; then
                bench drop-site "$site" --force >> "$LOG_FILE" 2>&1 \
                    && print_success "Site '$site' deleted" \
                    || print_error "Failed to delete site '$site'"
            fi
            ;;
        2)
            read -rp "Full path of bench to delete: " path
            if [ -d "$path" ] && confirm "This will permanently delete '$path'. Continue"; then
                rm -rf "$path" && print_success "Bench '$path' deleted"
            else
                print_warning "Path not found or cancelled"
            fi
            ;;
        3)
            [ -z "$BENCH_PATH" ] && ! detect_bench && { print_error "No bench found."; return 1; }
            cd "$BENCH_PATH" || return 1
            read -rp "App name to remove: " app
            read -rp "Site to remove it from: " site
            bench --site "$site" uninstall-app "$app" >> "$LOG_FILE" 2>&1
            bench remove-app "$app" >> "$LOG_FILE" 2>&1
            print_success "Removed app '$app'"
            ;;
        4)
            [ -z "$BENCH_PATH" ] && ! detect_bench && { print_error "No bench found."; return 1; }
            cd "$BENCH_PATH" || return 1
            bench clear-cache >> "$LOG_FILE" 2>&1 && print_success "Cache cleared"
            ;;
        5)
            if confirm "Delete all logs in $LOG_DIR"; then
                find "$LOG_DIR" -type f -name "*.log" -delete
                print_success "Logs removed"
            fi
            ;;
        6) return 0 ;;
        *) print_warning "Invalid choice" ;;
    esac
}
