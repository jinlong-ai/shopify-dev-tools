#!/usr/bin/env bash
#
# SuperFaTiao Shopify Dev Tools - Bash Edition
# Universal Memory-Safe Development Kit
# Supports: Linux, macOS, WSL
#

set -e

# Version
SFD_VERSION="1.0.0"

# Configuration
MEMORY_LIMIT=${SFD_MEMORY:-4096}
MEMORY_THRESHOLD=$((MEMORY_LIMIT * 85 / 100))
RESTART_LIMIT=5
RESTART_COUNT=0
STORE=${SHOPIFY_STORE:-}
THEME=${SHOPIFY_THEME:-"SuperFaTiao"}
LOG_DIR=".logs"
PID_FILE=".sfd.pid"

# Language Detection
LANG_DETECTED=${SFD_LANG:-"auto"}
if [ "$LANG_DETECTED" = "auto" ]; then
    if [[ "${LANG:-}" =~ ^zh ]] || [[ "${LC_ALL:-}" =~ ^zh ]]; then
        LANG_DETECTED="zh"
    else
        LANG_DETECTED="en"
    fi
fi

# Messages
if [ "$LANG_DETECTED" = "zh" ]; then
    MSG_TITLE="SuperFaTiao Shopify 开发工具"
    MSG_VERSION="版本"
    MSG_MEMORY_LIMIT="内存限制"
    MSG_THRESHOLD="重启阈值"
    MSG_CHECKING="检查 Shopify CLI..."
    MSG_CLI_NOT_FOUND="未找到 Shopify CLI。安装: npm install -g @shopify/cli"
    MSG_CLI_OK="Shopify CLI 已安装"
    MSG_STARTING="启动安全开发服务器..."
    MSG_STORE_PROMPT="请输入商店域名 (如: xxx.myshopify.com)"
    MSG_CURRENT_STORE="当前商店"
    MSG_MONITORING="每10秒监控内存..."
    MSG_MEMORY="内存"
    MSG_HIGH_MEMORY="检测到高内存，正在重启..."
    MSG_RESTARTING="重启服务器 (%d/%d)..."
    MSG_MAX_RESTARTS="重启次数过多，请检查内存泄漏"
    MSG_STOPPED="开发服务器已停止"
    MSG_LOG_LOCATION="日志位置"
    MSG_AUTO_RESTART="自动重启已启用"
    MSG_PRESS_CTRLC="按 Ctrl+C 停止"
    MSG_GRACEFUL="优雅关闭..."
else
    MSG_TITLE="SuperFaTiao Shopify Dev Tools"
    MSG_VERSION="Version"
    MSG_MEMORY_LIMIT="Memory Limit"
    MSG_THRESHOLD="Restart Threshold"
    MSG_CHECKING="Checking Shopify CLI..."
    MSG_CLI_NOT_FOUND="Shopify CLI not found. Install: npm install -g @shopify/cli"
    MSG_CLI_OK="Shopify CLI installed"
    MSG_STARTING="Starting safe dev server..."
    MSG_STORE_PROMPT="Enter store domain (e.g.: xxx.myshopify.com)"
    MSG_CURRENT_STORE="Current store"
    MSG_MONITORING="Monitoring memory every 10s..."
    MSG_MEMORY="Memory"
    MSG_HIGH_MEMORY="High memory detected, restarting..."
    MSG_RESTARTING="Restarting server (%d/%d)..."
    MSG_MAX_RESTARTS="Too many restarts, check for memory leaks"
    MSG_STOPPED="Dev server stopped"
    MSG_LOG_LOCATION="Log location"
    MSG_AUTO_RESTART="Auto-restart enabled"
    MSG_PRESS_CTRLC="Press Ctrl+C to stop"
    MSG_GRACEFUL="Graceful shutdown..."
fi

# Print header
print_header() {
    echo "=================================================="
    echo "$MSG_TITLE v$SFD_VERSION"
    echo "=================================================="
    echo "$MSG_MEMORY_LIMIT: ${MEMORY_LIMIT}MB"
    echo "$MSG_THRESHOLD: ${MEMORY_THRESHOLD}MB"
    echo "=================================================="
    echo
}

# Check CLI
check_cli() {
    echo -n "[$MSG_CHECKING] "
    if command -v shopify &> /dev/null; then
        local version
        version=$(shopify --version 2>/dev/null || echo "unknown")
        echo "✓ $version"
        return 0
    else
        echo "✗"
        echo "$MSG_CLI_NOT_FOUND"
        return 1
    fi
}

# Get store URL
get_store() {
    if [ -z "$STORE" ]; then
        read -p "$MSG_STORE_PROMPT: " STORE
        export SHOPIFY_STORE="$STORE"
    fi
    echo "$MSG_CURRENT_STORE: $STORE"
    echo "✓ $MSG_AUTO_RESTART"
    echo
}

# Setup environment
setup_env() {
    export NODE_OPTIONS="--max-old-space-size=$MEMORY_LIMIT --optimize-for-size"
    export SHOPIFY_FLAG_STORE="$STORE"
    export SHOPIFY_CLI_NO_ANALYTICS="1"

    mkdir -p "$LOG_DIR"
}

# Get Node memory usage (in MB)
get_memory_usage() {
    local mem_kb
    mem_kb=$(ps -o rss= -p "$(pgrep -x node | tr '\n' ' ')" 2>/dev/null | awk '{sum+=$1} END {print sum}')
    if [ -n "$mem_kb" ]; then
        echo $((mem_kb / 1024))
    else
        echo 0
    fi
}

# Cleanup on exit
cleanup() {
    echo
    echo "=================================================="
    echo "$MSG_STOPPED"
    echo "$MSG_LOG_LOCATION: $(pwd)/$LOG_DIR"
    echo "=================================================="
    rm -f "$PID_FILE"
    exit 0
}

trap cleanup SIGINT SIGTERM

# Start dev server
start_server() {
    echo "$MSG_STARTING"
    echo "$MSG_MONITORING"
    echo "$MSG_PRESS_CTRLC"
    echo

    # Start Shopify dev server in background
    shopify theme dev \
        --store="$STORE" \
        --theme="$THEME" \
        --path=. &

    local server_pid=$!
    echo $server_pid > "$PID_FILE"

    # Monitor memory
    local last_mem=0
    while kill -0 $server_pid 2>/dev/null; do
        sleep 10

        local mem_usage
        mem_usage=$(get_memory_usage)

        if [ "$mem_usage" != "$last_mem" ]; then
            printf "\r[$MSG_MEMORY: %dMB/%dMB]    " "$mem_usage" "$MEMORY_LIMIT"
            last_mem=$mem_usage
        fi

        if [ "$mem_usage" -gt "$MEMORY_THRESHOLD" ]; then
            echo
            echo "⚠ $MSG_HIGH_MEMORY"
            restart_server "$server_pid"
            break
        fi
    done

    wait $server_pid 2>/dev/null || true
}

# Restart server
restart_server() {
    local old_pid=$1

    if [ "$RESTART_COUNT" -ge "$RESTART_LIMIT" ]; then
        echo "$MSG_MAX_RESTARTS"
        kill -9 $old_pid 2>/dev/null || true
        exit 1
    fi

    RESTART_COUNT=$((RESTART_COUNT + 1))
    printf "$MSG_RESTARTING\n" "$RESTART_COUNT" "$RESTART_LIMIT"
    echo "$MSG_GRACEFUL"

    kill -TERM $old_pid 2>/dev/null || true
    sleep 3

    # Kill any remaining node processes
    pkill -x node 2>/dev/null || true
    sleep 2

    # Restart
    start_server
}

# Show help
show_help() {
    echo "Usage: sfd [store-domain] [options]"
    echo
    echo "Options:"
    echo "  -h, --help       Show help"
    echo "  -v, --version    Show version"
    echo "  -m, --memory     Set memory limit (MB)"
    echo "  -l, --lang       Set language (en/zh)"
    echo
    echo "Environment Variables:"
    echo "  SHOPIFY_STORE    Default store domain"
    echo "  SFD_MEMORY       Memory limit in MB"
    echo "  SFD_LANG         Language (en/zh)"
}

# Show version
show_version() {
    echo "sfd v$SFD_VERSION"
    echo "Platform: $(uname -s) $(uname -m)"
    echo "Shell: $SHELL"
}

# Parse arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            -m|--memory)
                MEMORY_LIMIT="$2"
                MEMORY_THRESHOLD=$((MEMORY_LIMIT * 85 / 100))
                shift 2
                ;;
            -l|--lang)
                LANG_DETECTED="$2"
                shift 2
                ;;
            -*)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                STORE="$1"
                export SHOPIFY_STORE="$STORE"
                shift
                ;;
        esac
    done
}

# Main
main() {
    parse_args "$@"
    print_header

    if ! check_cli; then
        exit 1
    fi

    get_store
    setup_env
    start_server

    cleanup
}

# Run
main "$@"
