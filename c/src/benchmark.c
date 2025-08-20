#include "benchmark.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

// 高精度タイマー
static int64_t get_time_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000000000LL + ts.tv_nsec;
}

// 比較関数（qsort用）
static int compare_ints(const void* a, const void* b) {
    int ia = *(const int*)a;
    int ib = *(const int*)b;
    return (ia > ib) - (ia < ib);
}

// 簡単なハッシュ関数
static uint32_t simple_hash(const char* data, size_t len) {
    uint32_t hash = 5381;
    for (size_t i = 0; i < len; i++) {
        hash = ((hash << 5) + hash) + (unsigned char)data[i];
    }
    return hash;
}

int run_all_benchmarks(BenchmarkResult* results, int max_results) {
    int count = 0;
    
    printf("Running CPU-intensive benchmarks...\n");
    if (count < max_results) results[count++] = benchmark_prime_numbers();
    if (count < max_results) results[count++] = benchmark_matrix_multiplication();
    if (count < max_results) results[count++] = benchmark_hash_computing();
    if (count < max_results) results[count++] = benchmark_math_operations();
    
    printf("Running memory-intensive benchmarks...\n");
    if (count < max_results) results[count++] = benchmark_large_array_sort();
    if (count < max_results) results[count++] = benchmark_memory_allocation();
    if (count < max_results) results[count++] = benchmark_string_concatenation();
    
    return count;
}

BenchmarkResult benchmark_prime_numbers(void) {
    int64_t start = get_time_ns();
    
    int count = 0;
    const int limit = 100000;
    for (int i = 2; i <= limit; i++) {
        if (is_prime(i)) {
            count++;
        }
    }
    
    int64_t duration = get_time_ns() - start;
    double duration_seconds = duration / 1e9;
    
    BenchmarkResult result;
    strcpy(result.test, "Prime Numbers (up to 100k)");
    result.duration_ns = duration;
    result.memory_bytes = 0; // Cでは正確なメモリ測定が困難
    result.operations = count;
    result.ops_per_sec = count / duration_seconds;
    
    return result;
}

int is_prime(int n) {
    if (n < 2) return 0;
    for (int i = 2; i <= (int)sqrt(n); i++) {
        if (n % i == 0) return 0;
    }
    return 1;
}

BenchmarkResult benchmark_matrix_multiplication(void) {
    int64_t start = get_time_ns();
    
    const int size = 500;
    
    // 動的メモリ確保
    double** a = malloc(size * sizeof(double*));
    double** b = malloc(size * sizeof(double*));
    double** c = malloc(size * sizeof(double*));
    
    for (int i = 0; i < size; i++) {
        a[i] = malloc(size * sizeof(double));
        b[i] = malloc(size * sizeof(double));
        c[i] = calloc(size, sizeof(double));
    }
    
    // 行列初期化（再現可能性のため）
    srand(42);
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            a[i][j] = (double)rand() / RAND_MAX;
            b[i][j] = (double)rand() / RAND_MAX;
        }
    }
    
    // 行列乗算
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            for (int k = 0; k < size; k++) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    
    // メモリ解放
    for (int i = 0; i < size; i++) {
        free(a[i]);
        free(b[i]);
        free(c[i]);
    }
    free(a);
    free(b);
    free(c);
    
    int64_t duration = get_time_ns() - start;
    double duration_seconds = duration / 1e9;
    int64_t operations = (int64_t)size * size * size;
    
    BenchmarkResult result;
    strcpy(result.test, "Matrix Multiplication (500x500)");
    result.duration_ns = duration;
    result.memory_bytes = 0;
    result.operations = operations;
    result.ops_per_sec = operations / duration_seconds;
    
    return result;
}

BenchmarkResult benchmark_hash_computing(void) {
    int64_t start = get_time_ns();
    
    char* data = malloc(1024);
    srand(42);
    for (int i = 0; i < 1024; i++) {
        data[i] = rand() % 256;
    }
    
    const int iterations = 50000;
    uint32_t hash_sum = 0;
    
    for (int i = 0; i < iterations; i++) {
        uint32_t hash = simple_hash(data, 1024);
        hash_sum += hash; // 最適化を防ぐ
    }
    
    // hash_sumを使用して最適化を防ぐ
    if (hash_sum == 0) {
        printf("Unexpected zero hash sum\n");
    }
    
    free(data);
    
    int64_t duration = get_time_ns() - start;
    double duration_seconds = duration / 1e9;
    
    BenchmarkResult result;
    strcpy(result.test, "Hash Computing (50k iterations)");
    result.duration_ns = duration;
    result.memory_bytes = 0;
    result.operations = iterations;
    result.ops_per_sec = iterations / duration_seconds;
    
    return result;
}

BenchmarkResult benchmark_math_operations(void) {
    int64_t start = get_time_ns();
    
    const int iterations = 10000000;
    double result = 0.0;
    for (int i = 0; i < iterations; i++) {
        double x = (double)i;
        result += sin(x) * cos(x) * sqrt(x + 1);
    }
    
    int64_t duration = get_time_ns() - start;
    double duration_seconds = duration / 1e9;
    
    // resultを使用して最適化を防ぐ
    if (isnan(result)) {
        printf("Unexpected NaN result\n");
    }
    
    BenchmarkResult bench_result;
    strcpy(bench_result.test, "Math Operations (10M iterations)");
    bench_result.duration_ns = duration;
    bench_result.memory_bytes = 0;
    bench_result.operations = iterations;
    bench_result.ops_per_sec = iterations / duration_seconds;
    
    return bench_result;
}

BenchmarkResult benchmark_large_array_sort(void) {
    int64_t start = get_time_ns();
    
    const int size = 1000000;
    int* data = malloc(size * sizeof(int));
    
    srand(42);
    for (int i = 0; i < size; i++) {
        data[i] = rand() % 1000001;
    }
    
    qsort(data, size, sizeof(int), compare_ints);
    
    free(data);
    
    int64_t duration = get_time_ns() - start;
    double duration_seconds = duration / 1e9;
    
    BenchmarkResult result;
    strcpy(result.test, "Large Array Sort (1M elements)");
    result.duration_ns = duration;
    result.memory_bytes = 0;
    result.operations = size;
    result.ops_per_sec = size / duration_seconds;
    
    return result;
}

BenchmarkResult benchmark_memory_allocation(void) {
    int64_t start = get_time_ns();
    
    const int allocations = 100000;
    int** arrays = malloc(allocations * sizeof(int*));
    
    for (int i = 0; i < allocations; i++) {
        arrays[i] = malloc(256 * sizeof(int)); // 1KB相当のデータ
        for (int j = 0; j < 256; j++) {
            arrays[i][j] = i % 256;
        }
    }
    
    // メモリ解放
    for (int i = 0; i < allocations; i++) {
        free(arrays[i]);
    }
    free(arrays);
    
    int64_t duration = get_time_ns() - start;
    double duration_seconds = duration / 1e9;
    
    BenchmarkResult result;
    strcpy(result.test, "Memory Allocation (100k x 1KB)");
    result.duration_ns = duration;
    result.memory_bytes = 0;
    result.operations = allocations;
    result.ops_per_sec = allocations / duration_seconds;
    
    return result;
}

BenchmarkResult benchmark_string_concatenation(void) {
    int64_t start = get_time_ns();
    
    const int iterations = 50000;
    size_t buffer_size = iterations * 20; // 十分なサイズを確保
    char* result = malloc(buffer_size);
    result[0] = '\0';
    
    for (int i = 0; i < iterations; i++) {
        char temp[32];
        snprintf(temp, sizeof(temp), "iteration_%d_", i);
        strncat(result, temp, buffer_size - strlen(result) - 1);
    }
    
    free(result);
    
    int64_t duration = get_time_ns() - start;
    double duration_seconds = duration / 1e9;
    
    BenchmarkResult bench_result;
    strcpy(bench_result.test, "String Concatenation (50k iterations)");
    bench_result.duration_ns = duration;
    bench_result.memory_bytes = 0;
    bench_result.operations = iterations;
    bench_result.ops_per_sec = iterations / duration_seconds;
    
    return bench_result;
}