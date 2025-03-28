#!/bin/bash
set -euo pipefail

url=$1

echo "Delay,Size,Concurrency,Average Latency (s),Requests/sec" > results.csv

for delay in $(seq 100 100 1000); do
    for size in $(seq 0 100 500); do
        # Configure the HTTP server
        wget "$url/config?delay=$delay&size=$size" -q --no-cache --spider

        echo "HTTP server configured with : { delay: $delay, size: $size }"
        
        for c in $(seq 200 200 1000); do
            echo "  - Running hey with concurrency: $c, Delay: $delay, Size: $size"
            
            OUTPUT=$(hey -c $c -z 10s $url)
            
            AVG_LATENCY=$(echo "$OUTPUT" | grep "Average:" | awk '{print $2}')
            REQ_PER_SEC=$(echo "$OUTPUT" | grep "Requests/sec:" | awk '{print $2}')
            
            echo "$delay,$size,$c,$AVG_LATENCY,$REQ_PER_SEC" >> results.csv
        done
    done
done

echo "Benchmark completed. Results saved in results.csv"
