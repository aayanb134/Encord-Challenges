#!/bin/bash

log_file="./systems.log" # specify path to log file
keywords=("ERROR" "FAIL") # specify keywords to search for

# function to check logs for keywords within the last 10 minutes
check_logs() {

    # get current time and time 10 minutes ago in epoch format
    current_time=$(date +%s)
    ten_minutes_ago=$(($current_time - 600))

    # read log file line by line and check if log entry is within last 10 minutes
    tail -F "$log_file" | while read line; do
        log_time=$(echo "$line" | awk '{print $1 " " $2 " " $3}')

        # convert log time to epoch format
        log_epoch=$(date -d "$(date +%Y) $log_time" +%s 2> /dev/null)

        if [[ "$log_epoch" -ge "$ten_minutes_ago" ]]; then
            for keyword in "${keywords[@]}"; do
                if echo "$line" | grep -q "$keyword"; then
                    echo "Alert: Found '$keyword' in log entry: $line"
                fi
            done
        fi
    done
}

check_logs