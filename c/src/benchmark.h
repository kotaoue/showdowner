#ifndef BENCHMARK_H
#define BENCHMARK_H

#include <stdint.h>

typedef struct {
    char test[128];
    int64_t duration_ns;
    int64_t memory_bytes;
    int64_t operations;
    double ops_per_sec;
} BenchmarkResult;

int run_all_benchmarks(BenchmarkResult* results, int max_results);

BenchmarkResult benchmark_prime_numbers(void);
BenchmarkResult benchmark_matrix_multiplication(void);
BenchmarkResult benchmark_hash_computing(void);
BenchmarkResult benchmark_math_operations(void);
BenchmarkResult benchmark_large_array_sort(void);
BenchmarkResult benchmark_memory_allocation(void);
BenchmarkResult benchmark_string_concatenation(void);

int is_prime(int n);

#endif