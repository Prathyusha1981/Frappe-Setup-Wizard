#!/bin/bash
# update.sh - Update bench, specific apps, or all apps

run_update() {
    print_header "Update"

    [ -z "$BENCH_PATH" ] && ! detect_bench && { print_error "No bench found."; return 1; }
    [ -z "$BENCH_PATH" ] && BENCH_PATH="$(pwd)"
    cd "$BENCH_PATH" || return 1

    echo "1. Update Bench (framework)"
    echo "2. Update Specific App"
    echo "3. Update All Apps"
    echo "4. Back"
    read -rp "Choice: " choice

    case "$choice" in
        1)
            print_info "Running bench update..."
            bench update >> "$LOG_FILE" 2>&1 && print_success "Bench updated" || print_error "Update failed"
            ;;
        2)
            read -rp "Enter app name: " app
            print_info "Pulling latest for $app..."
            (cd "apps/$app" && git pull) >> "$LOG_FILE" 2>&1 && print_success "$app updated" || print_error "$app update failed"
            bench --site all migrate >> "$LOG_FILE" 2>&1
            bench build --app "$app" >> "$LOG_FILE" 2>&1
            ;;
        3)
            print_info "Updating all apps, migrating, and rebuilding assets..."
            bench update --no-backup >> "$LOG_FILE" 2>&1 \
                && bench migrate >> "$LOG_FILE" 2>&1 \
                && bench build >> "$LOG_FILE" 2>&1 \
                && bench restart >> "$LOG_FILE" 2>&1 \
                && print_success "All apps updated, migrated, and rebuilt" \
                || print_error "Update process failed. See $LOG_FILE"
            ;;
        4) return 0 ;;
        *) print_warning "Invalid choice" ;;
    esac
}
