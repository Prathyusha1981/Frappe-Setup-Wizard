#!/bin/bash
# doctor.sh - Check the local environment for all required tools

check_tool() {
    local name="$1"
    local cmd="$2"
    local version_flag="${3:---version}"

    if command_exists "$cmd"; then
        local ver
        ver=$("$cmd" $version_flag 2>&1 | head -n1)
        print_success "$name  ${CYAN}($ver)${NC}"
    else
        print_error "$name not found"
    fi
}

run_doctor() {
    print_header "Environment Doctor"

    check_tool "Ubuntu/OS" "lsb_release" "-ds"
    check_tool "Python" "python3"
    check_tool "Node" "node"
    check_tool "Redis" "redis-server" "--version"
    check_tool "MariaDB" "mysql" "--version"
    check_tool "Bench" "bench" "--version"
    check_tool "Yarn" "yarn" "--version"
    check_tool "wkhtmltopdf" "wkhtmltopdf" "--version"
    check_tool "Git" "git" "--version"
    check_tool "npm" "npm" "--version"
    check_tool "pip" "pip3" "--version"
    check_tool "curl" "curl" "--version"

    echo ""
    if detect_bench; then
        print_success "Bench detected at: $BENCH_PATH"
    else
        print_warning "No bench detected in current path"
    fi

    echo ""
    print_info "Doctor check complete. Full log: $LOG_FILE"
}
