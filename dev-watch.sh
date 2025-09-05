#!/bin/bash

# Auto-restart Jekyll when _config.yml changes
echo "Starting Jekyll with auto-restart for _config.yml changes..."

# Function to start Jekyll
start_jekyll() {
    bundle exec jekyll serve -l -H localhost --detach
    echo "Jekyll started with PID: $(cat _site/.jekyll-pid 2>/dev/null || echo 'unknown')"
}

# Function to stop Jekyll
stop_jekyll() {
    pkill -f "jekyll serve" 2>/dev/null || true
    echo "Jekyll stopped"
}

# Start Jekyll initially
start_jekyll

# Watch for _config.yml changes
echo "Watching _config.yml for changes... (Press Ctrl+C to stop)"
while true; do
    if [ "_config.yml" -nt ".config-timestamp" ]; then
        touch .config-timestamp
        echo "Config file changed - restarting Jekyll..."
        stop_jekyll
        sleep 2
        start_jekyll
    fi
    sleep 1
done