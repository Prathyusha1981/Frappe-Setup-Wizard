#!/bin/bash
# 04_install_apps.sh - Dynamically install one or more Frappe apps

install_apps() {
    print_header "Install Apps"

    [ -z "$BENCH_PATH" ] && ! detect_bench && { print_error "No bench found. Create one first."; return 1; }
    [ -z "$BENCH_PATH" ] && BENCH_PATH="$(pwd)"
    cd "$BENCH_PATH" || { print_error "Cannot access bench at $BENCH_PATH"; return 1; }

    if [ -z "$SITE" ]; then
        read -rp "Enter site name to install apps on: " SITE
    fi

    echo -e "${CYAN}Enter app names or git URLs, space separated${NC}"
    echo -e "${CYAN}Example: erpnext hrms payments https://github.com/my-org/custom_app.git${NC}"
    read -rp "Apps: " -a apps

    if [ "${#apps[@]}" -eq 0 ]; then
        print_warning "No apps entered. Using default: $DEFAULT_APPS"
        read -ra apps <<< "$DEFAULT_APPS"
    fi

    local total=${#apps[@]}
    local i=0
    for app in "${apps[@]}"; do
        i=$((i + 1))
        local app_name
        if [[ "$app" == http*://* ]]; then
            app_name=$(basename "$app" .git)
            print_info "[$i/$total] Fetching custom app '$app_name' from $app"
            bench get-app "$app_name" "$app" >> "$LOG_FILE" 2>&1
        else
            app_name="$app"
            print_info "[$i/$total] Fetching app '$app_name' (branch: ${VERSION:-$DEFAULT_VERSION})"
            bench get-app "$app_name" --branch "${VERSION:-$DEFAULT_VERSION}" >> "$LOG_FILE" 2>&1
        fi

        if [ $? -ne 0 ]; then
            print_error "Failed to fetch $app_name"
            continue
        fi

        print_info "Installing '$app_name' on site '$SITE'"
        if bench --site "$SITE" install-app "$app_name" >> "$LOG_FILE" 2>&1; then
            print_success "$app_name installed"
        else
            print_error "$app_name failed to install on $SITE"
        fi
    done
}
