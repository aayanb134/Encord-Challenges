#!/bin/bash

log_file="./systems.log" # specify path to log file
keywords=("ERROR" "FAIL")  
alert_timeframe=10 # timeframe in minutes


# function to check if a log entry is within the specified timeframe
within_timeframe(){
    log_time=$1
    current_time=$(date +%s)
    log_time_period=$(date -d "$log_time" +%s)
    time_diff=$(( ($current_time - $log_time_period) / 60))

    if (($time_diff < $alert_timeframe)); then
        return 0
    else
        return 1
    fi
}

# main loop to monitor the log file
tail -F "$log_file" | while read -r line; do # monitors file in real time and pipes output into a while loop
    timestamp=$(echo "$line" | awk '{print $1" "$2" "$3}')

    message=$(echo "$line" | cut -d ' ' -f 4-) # extracts the message from the log entry

    if within_timeframe "$full_timestamp"; then
        for keyword in "${keywords[@]}"; do
            if echo "$message" | grep -qi "$keyword"; then
                echo "ALERT: $message"
                echo "Log entry: $line"
                break
            fi
        done
    fi
done
