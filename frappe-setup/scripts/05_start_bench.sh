#!/bin/bash
# 05_start_bench.sh - Start the bench dev server

start_bench() {
    print_header "Start Bench"

    [ -z "$BENCH_PATH" ] && ! detect_bench && { print_error "No bench found."; return 1; }
    [ -z "$BENCH_PATH" ] && BENCH_PATH="$(pwd)"

    cd "$BENCH_PATH" || { print_error "Cannot access bench at $BENCH_PATH"; return 1; }
    print_info "Starting bench at $BENCH_PATH (Ctrl+C to stop)"
    log "Starting bench at $BENCH_PATH"
    bench start
}
