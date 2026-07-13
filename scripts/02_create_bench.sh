#!/bin/bash
# 02_create_bench.sh - Create a new Frappe bench

create_bench() {
    print_header "Create New Bench"

    if ! command_exists bench; then
        print_error "bench is not installed. Run 'Install Dependencies' first."
        return 1
    fi

    select_version

    read -rp "Enter bench name [default: frappe-bench]: " BENCH_NAME
    BENCH_NAME="${BENCH_NAME:-frappe-bench}"

    mkdir -p "$WORKSPACE"
    cd "$WORKSPACE" || { print_error "Cannot access workspace $WORKSPACE"; return 1; }

    if [ -d "$WORKSPACE/$BENCH_NAME" ]; then
        print_warning "Bench '$BENCH_NAME' already exists at $WORKSPACE/$BENCH_NAME"
        if ! confirm "Continue and use the existing bench"; then
            return 1
        fi
        BENCH_PATH="$WORKSPACE/$BENCH_NAME"
        export BENCH_PATH
        return 0
    fi

    print_info "Creating bench '$BENCH_NAME' with Frappe $VERSION..."
    if bench init "$BENCH_NAME" --frappe-branch "$VERSION" >> "$LOG_FILE" 2>&1; then
        print_success "Bench '$BENCH_NAME' created"
        BENCH_PATH="$WORKSPACE/$BENCH_NAME"
        export BENCH_PATH
    else
        print_error "Bench creation failed. See $LOG_FILE"
        return 1
    fi
}
