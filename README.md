# Golang HTTP Client Benchmark

This repository contains measurements and analysis of the performance of the Golang HTTP client from the standard library.

The goal of this benchmark is not to compare the performance of `http.Client` to other HTTP clients, but to measure under which conditions—in terms of latency, response size, and network quality—the http.Client can perform at a **sustained throughput of 2000 requests per second**.

## Methodology

We use the load tester [hey](https://github.com/rakyll/hey) as the reference implementation of a program that uses `http.Client` to send requests to a server. We also use it's output to
measure the throughput and latency of the requests.

As a server, we use the simple mock-server described in `main.go`. It's based on `http.Server` from the standard library and can be configured to control the latency and the size of the response.

We run the benchmark using a bash script that runs `hey` and the server with different parameters and collects the results in a CSV file.

The benchmark is run in 3 network configurations:
- **Localhost**: The server and the client are running on the same machine.
- **Public Network**: The client is running on a laptop and the server is running on an AWS EC2 instance.
- **Private Network**: The client is running on an AWS EC2 instance and the server is running on another AWS EC2 instance.

The following hardware was use during the benchmark:
- **Laptop (localhost)**:Dell Swift X14, i7-13700H (20 thread), 32GB RAM, Fedora 41 Workstation
- **Server**: AWS EC2 c5.4xlarge, 16 vCPU, 32GB RAM, Amazon Linux 2

I chose the c5.4xlarge instance the be sure that the server would not be the bottleneck of the benchmark.
