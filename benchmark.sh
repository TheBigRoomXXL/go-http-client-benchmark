#!/bin/bash
set -euo pipefail # Exit on error, undefined variable, or failed pipe

cleanup() {
    sudo tc qdisc del dev lo root # Remove the network configuration
    kill $(jobs -p) # Kill the background process
}
trap cleanup EXIT # Ensure cleanup is called on exit

./http-mock 0 200 > /dev/null 2>&1 & # Start the server with delay=0 and responseSize=200KB


echo "Delay,Bandwidth,Concurrency,Average Latency (s),Requests/sec" > results.csv
for delay in $(seq 100 100 500); do
    echo "- Delay: ${delay}ms"
    for bandwidth in $(seq 1 1 10); do
        echo "  - Bandwidth: ${bandwidth}Gbps"
        sudo tc qdisc add dev lo root tbf rate ${bandwidth}gbit burst 512kb latency ${delay}ms
        
        for concurency in $(seq 200 200 1000); do
            echo "    - Concurrency: $concurency"
            OUTPUT=$(hey -c $concurency -z 8s http://localhost:8888)
            echo "$OUTPUT"
            AVG_LATENCY=$(echo "$OUTPUT" | grep "Average:" | awk '{print $2}')
            REQ_PER_SEC=$(echo "$OUTPUT" | grep "Requests/sec:" | awk '{print $2}')
            
            echo "$delay,$bandwidth,$concurency,$AVG_LATENCY,$REQ_PER_SEC" >> results.csv
        done

        sudo tc qdisc del dev lo root # Remove the network configuration
        echo "  - Network configuration removed"
    done
done

echo "Benchmark completed. Results saved in results.csv"


sudo tc qdisc add dev lo root tbf rate 1gbit burst 128kb latency 50ms
