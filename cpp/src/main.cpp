#include "benchmark.h"
#include "output.h"
#include <iostream>
#include <chrono>

int main() {
    auto startTime = std::chrono::high_resolution_clock::now();
    
    auto results = Benchmark::runAllBenchmarks();
    
    auto endTime = std::chrono::high_resolution_clock::now();
    auto totalDuration = std::chrono::duration_cast<std::chrono::nanoseconds>(endTime - startTime);
    double totalTime = totalDuration.count() / 1e9;
    
    Output::printResults(results);
    
    try {
        Output::saveResultsToJSON(results, totalTime);
    } catch (const std::exception& e) {
        std::cerr << "Error saving results: " << e.what() << std::endl;
        return 1;
    }
    
    std::cout << "Total execution time: " << std::fixed << std::setprecision(3) << totalTime << " seconds" << std::endl;
    
    return 0;
}