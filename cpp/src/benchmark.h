#pragma once

#include <string>
#include <vector>

struct BenchmarkResult {
    std::string test;
    long long duration_ns;
    long long memory_bytes;
    long long operations;
    double ops_per_sec;
    
    BenchmarkResult(const std::string& test, long long duration_ns, long long memory_bytes, 
                   long long operations, double ops_per_sec)
        : test(test), duration_ns(duration_ns), memory_bytes(memory_bytes), 
          operations(operations), ops_per_sec(ops_per_sec) {}
};

class Benchmark {
public:
    static std::vector<BenchmarkResult> runAllBenchmarks();
    
private:
    static BenchmarkResult benchmarkPrimeNumbers();
    static BenchmarkResult benchmarkMatrixMultiplication();
    static BenchmarkResult benchmarkCryptographicHashing();
    static BenchmarkResult benchmarkMathOperations();
    static BenchmarkResult benchmarkLargeArraySort();
    static BenchmarkResult benchmarkMemoryAllocation();
    static BenchmarkResult benchmarkStringConcatenation();
    
    static bool isPrime(int n);
};