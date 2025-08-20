#include "benchmark.h"
#include <iostream>
#include <chrono>
#include <cmath>
#include <algorithm>
#include <random>
#include <sstream>
#include <iomanip>

std::vector<BenchmarkResult> Benchmark::runAllBenchmarks() {
    std::vector<BenchmarkResult> results;
    
    std::cout << "Running CPU-intensive benchmarks..." << std::endl;
    results.push_back(benchmarkPrimeNumbers());
    results.push_back(benchmarkMatrixMultiplication());
    results.push_back(benchmarkCryptographicHashing());
    results.push_back(benchmarkMathOperations());
    
    std::cout << "Running memory-intensive benchmarks..." << std::endl;
    results.push_back(benchmarkLargeArraySort());
    results.push_back(benchmarkMemoryAllocation());
    results.push_back(benchmarkStringConcatenation());
    
    return results;
}

BenchmarkResult Benchmark::benchmarkPrimeNumbers() {
    auto start = std::chrono::high_resolution_clock::now();
    
    int count = 0;
    const int limit = 100000;
    for (int i = 2; i <= limit; i++) {
        if (isPrime(i)) {
            count++;
        }
    }
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
    double durationSeconds = duration / 1e9;
    
    return BenchmarkResult(
        "Prime Numbers (up to 100k)",
        duration,
        0, // C++では正確なメモリ測定が困難
        count,
        count / durationSeconds
    );
}

bool Benchmark::isPrime(int n) {
    if (n < 2) return false;
    for (int i = 2; i <= std::sqrt(n); i++) {
        if (n % i == 0) return false;
    }
    return true;
}

BenchmarkResult Benchmark::benchmarkMatrixMultiplication() {
    auto start = std::chrono::high_resolution_clock::now();
    
    const int size = 500;
    std::mt19937 gen(42); // 再現可能性のためのシード
    std::uniform_real_distribution<double> dis(0.0, 1.0);
    
    // 動的メモリ確保
    std::vector<std::vector<double>> a(size, std::vector<double>(size));
    std::vector<std::vector<double>> b(size, std::vector<double>(size));
    std::vector<std::vector<double>> c(size, std::vector<double>(size, 0.0));
    
    // 行列初期化
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            a[i][j] = dis(gen);
            b[i][j] = dis(gen);
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
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
    double durationSeconds = duration / 1e9;
    long long operations = static_cast<long long>(size) * size * size;
    
    return BenchmarkResult(
        "Matrix Multiplication (500x500)",
        duration,
        0,
        operations,
        operations / durationSeconds
    );
}

BenchmarkResult Benchmark::benchmarkCryptographicHashing() {
    auto start = std::chrono::high_resolution_clock::now();
    
    std::vector<unsigned char> data(1024);
    std::mt19937 gen(42);
    std::uniform_int_distribution<int> dis(0, 255);
    
    for (auto& byte : data) {
        byte = static_cast<unsigned char>(dis(gen));
    }
    
    const int iterations = 50000;
    std::hash<std::string> hasher;
    std::string dataStr(data.begin(), data.end());
    
    for (int i = 0; i < iterations; i++) {
        size_t hash_value = hasher(dataStr + std::to_string(i));
        // ハッシュ値を使用して最適化を防ぐ
        if (hash_value == 0) {
            std::cout << "Unexpected zero hash" << std::endl;
        }
    }
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
    double durationSeconds = duration / 1e9;
    
    return BenchmarkResult(
        "Hash Computing (50k iterations)",
        duration,
        0,
        iterations,
        iterations / durationSeconds
    );
}

BenchmarkResult Benchmark::benchmarkMathOperations() {
    auto start = std::chrono::high_resolution_clock::now();
    
    const int iterations = 10000000;
    double result = 0.0;
    for (int i = 0; i < iterations; i++) {
        double x = static_cast<double>(i);
        result += std::sin(x) * std::cos(x) * std::sqrt(x + 1);
    }
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
    double durationSeconds = duration / 1e9;
    
    // resultを使用して最適化を防ぐ
    if (std::isnan(result)) {
        std::cout << "Unexpected NaN result" << std::endl;
    }
    
    return BenchmarkResult(
        "Math Operations (10M iterations)",
        duration,
        0,
        iterations,
        iterations / durationSeconds
    );
}

BenchmarkResult Benchmark::benchmarkLargeArraySort() {
    auto start = std::chrono::high_resolution_clock::now();
    
    const int size = 1000000;
    std::vector<int> data(size);
    std::mt19937 gen(42);
    std::uniform_int_distribution<int> dis(0, 1000000);
    
    for (int& val : data) {
        val = dis(gen);
    }
    
    std::sort(data.begin(), data.end());
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
    double durationSeconds = duration / 1e9;
    
    return BenchmarkResult(
        "Large Array Sort (1M elements)",
        duration,
        0,
        size,
        size / durationSeconds
    );
}

BenchmarkResult Benchmark::benchmarkMemoryAllocation() {
    auto start = std::chrono::high_resolution_clock::now();
    
    const int allocations = 100000;
    std::vector<std::vector<int>> arrays;
    arrays.reserve(allocations);
    
    for (int i = 0; i < allocations; i++) {
        std::vector<int> data(256, i % 256); // 1KB相当のデータ
        arrays.push_back(std::move(data));
    }
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
    double durationSeconds = duration / 1e9;
    
    return BenchmarkResult(
        "Memory Allocation (100k x 1KB)",
        duration,
        0,
        allocations,
        allocations / durationSeconds
    );
}

BenchmarkResult Benchmark::benchmarkStringConcatenation() {
    auto start = std::chrono::high_resolution_clock::now();
    
    const int iterations = 50000;
    std::ostringstream result;
    for (int i = 0; i < iterations; i++) {
        result << "iteration_" << i << "_";
    }
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
    double durationSeconds = duration / 1e9;
    
    return BenchmarkResult(
        "String Concatenation (50k iterations)",
        duration,
        0,
        iterations,
        iterations / durationSeconds
    );
}