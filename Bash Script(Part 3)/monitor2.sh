#!/bin/bash

LOG_FILE="./systems.log"   # Define the log file to monitor
KEYWORDS=("ERROR" "FAIL")   # Define the keywords to search for

# Get the epoch time for 10 minutes ago
ten_minutes_ago=$(($(date +%s) - 600))

# Monitor the log file and process new lines as they are added
tail -F "$LOG_FILE" | while read -r line; do
    log_epoch=$(echo "$line" | awk '{print $1}')   # Extract the log's epoch time

    if [[ "$log_epoch" -ge "$ten_minutes_ago" ]]; then   # Check if the log time is within the last 10 minutes
        for keyword in "${KEYWORDS[@]}"; do
            if echo "$line" | grep -q "$keyword"; then
                echo "Alert: Found '$keyword' in log entry: $line"   # Print alert if keyword is found
            fi
        done
    fi
done
