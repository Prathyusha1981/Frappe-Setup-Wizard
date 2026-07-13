#!/bin/bash
# 01_dependencies.sh - Install system dependencies required for Frappe/Bench

install_dependencies() {
    print_header "Installing Dependencies"

    run_step 1 6 "Updating package lists" sudo apt-get update -y
    run_step 2 6 "Installing base packages (git, curl, python3, pip)" \
        sudo apt-get install -y git curl python3-dev python3-pip python3-venv software-properties-common

    run_step 3 6 "Installing MariaDB" sudo apt-get install -y mariadb-server mariadb-client libmysqlclient-dev

    run_step 4 6 "Installing Redis" sudo apt-get install -y redis-server

    run_step 5 6 "Installing wkhtmltopdf" sudo apt-get install -y xvfb libfontconfig wkhtmltopdf

    if ! command_exists node || [ "$(node -v | grep -oP '(?<=v)\d+')" != "$NODE_VERSION" ]; then
        run_step 6 6 "Installing Node.js $NODE_VERSION via NodeSource" bash -c "
            curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash - &&
            sudo apt-get install -y nodejs &&
            sudo npm install -g yarn
        "
    else
        print_success "Node.js $NODE_VERSION already installed"
    fi

    if ! command_exists bench; then
        print_info "Installing frappe-bench via pip"
        sudo pip3 install frappe-bench >> "$LOG_FILE" 2>&1 && print_success "frappe-bench installed" \
            || print_error "frappe-bench installation failed"
    else
        print_success "bench already installed"
    fi

    print_success "All dependencies installed"
}
