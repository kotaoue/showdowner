#include "output.h"
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <sys/utsname.h>

void print_results(const BenchmarkResult* results, int count) {
    printf("\n=== BENCHMARK RESULTS ===\n");
    for (int i = 0; i < count; i++) {
        const BenchmarkResult* result = &results[i];
        printf("Test: %s\n", result->test);
        printf("  Duration: %lld ns\n", (long long)result->duration_ns);
        printf("  Memory: %lld bytes\n", (long long)result->memory_bytes);
        printf("  Operations: %lld\n", (long long)result->operations);
        printf("  Ops/sec: %.2f\n", result->ops_per_sec);
        printf("\n");
    }
}

int save_results_to_json(const BenchmarkResult* results, int count, double total_time) {
    // タイムスタンプ生成
    time_t now = time(NULL);
    struct tm* tm_info = localtime(&now);
    char timestamp[32];
    strftime(timestamp, sizeof(timestamp), "%Y%m%d_%H%M%S", tm_info);
    
    char filename[64];
    snprintf(filename, sizeof(filename), "benchmark_c_%s.json", timestamp);
    
    FILE* file = fopen(filename, "w");
    if (!file) {
        printf("Error writing file: Could not open %s\n", filename);
        return -1;
    }
    
    // システム情報取得
    struct utsname uname_data;
    uname(&uname_data);
    
    long cpu_count = sysconf(_SC_NPROCESSORS_ONLN);
    if (cpu_count <= 0) cpu_count = 1;
    
    // JSON出力
    fprintf(file, "{\n");
    fprintf(file, "  \"language\": \"c\",\n");
    
    // タイムスタンプ（ISO形式）
    char iso_timestamp[32];
    strftime(iso_timestamp, sizeof(iso_timestamp), "%Y-%m-%dT%H:%M:%S", tm_info);
    fprintf(file, "  \"timestamp\": \"%s\",\n", iso_timestamp);
    
    fprintf(file, "  \"compiler\": \"%s\",\n", 
#ifdef __VERSION__
        __VERSION__
#else
        "unknown"
#endif
    );
    fprintf(file, "  \"c_standard\": \"C99\",\n");
    fprintf(file, "  \"system\": {\n");
    fprintf(file, "    \"os\": \"%s\",\n", uname_data.sysname);
    fprintf(file, "    \"arch\": \"%s\",\n", uname_data.machine);
    fprintf(file, "    \"cpus\": %ld\n", cpu_count);
    fprintf(file, "  },\n");
    
    fprintf(file, "  \"tests\": [\n");
    for (int i = 0; i < count; i++) {
        const BenchmarkResult* result = &results[i];
        fprintf(file, "    {\n");
        fprintf(file, "      \"test\": \"%s\",\n", result->test);
        fprintf(file, "      \"duration_ns\": %lld,\n", (long long)result->duration_ns);
        fprintf(file, "      \"memory_bytes\": %lld,\n", (long long)result->memory_bytes);
        fprintf(file, "      \"operations\": %lld,\n", (long long)result->operations);
        fprintf(file, "      \"ops_per_sec\": %.2f\n", result->ops_per_sec);
        fprintf(file, "    }");
        if (i < count - 1) {
            fprintf(file, ",");
        }
        fprintf(file, "\n");
    }
    fprintf(file, "  ],\n");
    
    fprintf(file, "  \"total_time_seconds\": %.3f\n", total_time);
    fprintf(file, "}\n");
    
    fclose(file);
    printf("Results saved to: %s\n", filename);
    return 0;
}