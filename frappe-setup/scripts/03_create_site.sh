#!/bin/bash
# 03_create_site.sh - Create a new site inside a bench

create_site() {
    print_header "Create New Site"

    if [ -z "$BENCH_PATH" ]; then
        if detect_bench; then
            print_info "Bench detected at $BENCH_PATH"
            if ! confirm "Use this bench"; then
                read -rp "Enter full path to bench: " BENCH_PATH
            fi
        else
            print_warning "No bench found."
            if confirm "Create one now"; then
                create_bench
            else
                read -rp "Enter full path to existing bench: " BENCH_PATH
            fi
        fi
    fi

    [ -z "$BENCH_PATH" ] && { print_error "No bench path set. Aborting."; return 1; }

    cd "$BENCH_PATH" || { print_error "Cannot access bench at $BENCH_PATH"; return 1; }

    read -rp "Enter site name (e.g. site1.local): " SITE
    [ -z "$SITE" ] && { print_error "Site name cannot be empty"; return 1; }

    read -rsp "Enter MariaDB root password: " DB_ROOT_PASS
    echo ""

    print_info "Creating site '$SITE'..."
    if bench new-site "$SITE" --mariadb-root-password "$DB_ROOT_PASS" >> "$LOG_FILE" 2>&1; then
        print_success "Site '$SITE' created"
        export SITE
    else
        print_error "Site creation failed. See $LOG_FILE"
        return 1
    fi
}
