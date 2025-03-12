#!/bin/bash
set -euo pipefail

# Function to clean up and stop the server
cleanup() {
    if [[ -n "$SERVER_PID" ]]; then
        sudo kill $SERVER_PID
    fi
    exit 0
}

# Set trap to call cleanup on script exit or interruption
trap cleanup EXIT INT TERM

echo "Delay,Size,Concurrency,Average Latency (s),Requests/sec" > results.csv

for delay in $(seq 100 100 2000); do
    for size in $(seq 0 500 1000); do
        
        # Start the HTTP server
        sudo ./http-mock $delay $size &
        SERVER_PID=$!
        echo "HTTP server started with PID: $SERVER_PID, Delay: $delay, Size: $size"
        
        for c in $(seq 100 100 1500); do
            echo "  - Running hey with concurrency: $c, Delay: $delay, Size: $size"
            
            OUTPUT=$(hey -c $c -n 10000 http://localhost:8888)
            
            AVG_LATENCY=$(echo "$OUTPUT" | grep "Average:" | awk '{print $2}')
            REQ_PER_SEC=$(echo "$OUTPUT" | grep "Requests/sec:" | awk '{print $2}')
            
            echo "$delay,$size,$c,$AVG_LATENCY,$REQ_PER_SEC" >> results.csv
        done

        # Stop the HTTP server
        sudo kill $SERVER_PID
        
    done
done

echo "Benchmark completed. Results saved in results.csv"
