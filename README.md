# Golang HTTP Client Benchmark

This reposotory contains measurement and analysis of the performance of the 
Golang HTTP client from the standard library.

The goal of this benchmark is not to compare the the performance of `http.Client` to another
HTTP client but the measure under wich conditions, in term of latency, response size, and
network quality and number of goroutine, the http.Client can perform at a substained throughput of 2000 requests per
second.

## Methodology

We use the load tester [hey](https://github.com/rakyll/hey) as the reference implementation
of a programme that use the `http.Client` to send requests to a server.

As a server use the simple mock-server described in `main.go`. It's based on `http.Server`
rom the standard library and it can be configured to control the latency and the size of the
response.

We run the benchmark using a bash script that runs `hey` and the server with different
parameters and collects the results in a CSV file.


# Golang HTTP Client Benchmark

This repository contains measurements and analysis of the performance of the Golang HTTP client from the standard library.

The goal of this benchmark is not to compare the performance of `http.Client` to other HTTP clients, but to measure under which conditions—in terms of latency, response size, and network quality—the http.Client can perform at a **sustained throughput of 2000 requests per second**.

## Methodology

We use the load tester [hey](https://github.com/rakyll/hey) as the reference implementation of a program that uses `http.Client` to send requests to a server. We also use it's output to
measure the throughput and latency of the requests.

As a server, we use the simple mock-server described in `main.go`. It's based on `http.Server` from the standard library and can be configured to control the latency and the size of the response.

We run the benchmark using a bash script that runs `hey` and the server with different parameters and collects the results in a CSV file.
