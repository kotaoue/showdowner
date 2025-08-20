#define _POSIX_C_SOURCE 199309L
#include "benchmark.h"
#include "output.h"
#include <stdio.h>
#include <time.h>

// 高精度タイマー
static int64_t get_time_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000000000LL + ts.tv_nsec;
}

int main(void) {
    int64_t start_time = get_time_ns();
    
    const int max_results = 10;
    BenchmarkResult results[max_results];
    
    int count = run_all_benchmarks(results, max_results);
    
    int64_t end_time = get_time_ns();
    double total_time = (end_time - start_time) / 1e9;
    
    print_results(results, count);
    
    if (save_results_to_json(results, count, total_time) != 0) {
        printf("Error saving results\n");
        return 1;
    }
    
    printf("Total execution time: %.3f seconds\n", total_time);
    
    return 0;
}