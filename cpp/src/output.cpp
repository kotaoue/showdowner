#include "output.h"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <chrono>
#include <sstream>
#include <thread>

void Output::printResults(const std::vector<BenchmarkResult>& results) {
    std::cout << "\n=== BENCHMARK RESULTS ===" << std::endl;
    for (const auto& result : results) {
        std::cout << "Test: " << result.test << std::endl;
        std::cout << "  Duration: " << result.duration_ns << " ns" << std::endl;
        std::cout << "  Memory: " << result.memory_bytes << " bytes" << std::endl;
        std::cout << "  Operations: " << result.operations << std::endl;
        std::cout << "  Ops/sec: " << std::fixed << std::setprecision(2) << result.ops_per_sec << std::endl;
        std::cout << std::endl;
    }
}

void Output::saveResultsToJSON(const std::vector<BenchmarkResult>& results, double totalTime) {
    // 現在時刻取得
    auto now = std::chrono::system_clock::now();
    auto time_t = std::chrono::system_clock::to_time_t(now);
    auto tm = *std::localtime(&time_t);
    
    // タイムスタンプ生成
    std::ostringstream timestampStream;
    timestampStream << std::put_time(&tm, "%Y%m%d_%H%M%S");
    std::string timestamp = timestampStream.str();
    
    std::string filename = "benchmark_cpp_" + timestamp + ".json";
    std::ofstream file(filename);
    
    if (!file.is_open()) {
        throw std::runtime_error("Error writing file: Could not open " + filename);
    }
    
    file << "{\n";
    file << "  \"language\": \"cpp\",\n";
    
    // タイムスタンプ（ISO形式）
    std::ostringstream isoStream;
    isoStream << std::put_time(&tm, "%Y-%m-%dT%H:%M:%S");
    file << "  \"timestamp\": \"" << isoStream.str() << "\",\n";
    
    file << "  \"compiler\": \"" << __VERSION__ << "\",\n";
    file << "  \"cpp_standard\": \"C++17\",\n";
    file << "  \"system\": {\n";
    file << "    \"os\": \"" << 
#ifdef __APPLE__
        "macOS"
#elif defined(__linux__)
        "Linux"
#elif defined(_WIN32)
        "Windows"
#else
        "Unknown"
#endif
        << "\",\n";
    file << "    \"arch\": \"" << 
#ifdef __x86_64__
        "x86_64"
#elif defined(__aarch64__)
        "aarch64"
#elif defined(__arm__)
        "arm"
#else
        "unknown"
#endif
        << "\",\n";
    file << "    \"cpus\": " << std::thread::hardware_concurrency() << "\n";
    file << "  },\n";
    
    file << "  \"tests\": [\n";
    for (size_t i = 0; i < results.size(); i++) {
        const auto& result = results[i];
        file << "    {\n";
        file << "      \"test\": \"" << result.test << "\",\n";
        file << "      \"duration_ns\": " << result.duration_ns << ",\n";
        file << "      \"memory_bytes\": " << result.memory_bytes << ",\n";
        file << "      \"operations\": " << result.operations << ",\n";
        file << "      \"ops_per_sec\": " << std::fixed << std::setprecision(2) << result.ops_per_sec << "\n";
        file << "    }";
        if (i < results.size() - 1) {
            file << ",";
        }
        file << "\n";
    }
    file << "  ],\n";
    
    file << "  \"total_time_seconds\": " << std::fixed << std::setprecision(3) << totalTime << "\n";
    file << "}\n";
    
    file.close();
    std::cout << "Results saved to: " << filename << std::endl;
}