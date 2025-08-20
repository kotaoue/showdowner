#pragma once

#include "benchmark.h"
#include <vector>

class Output {
public:
    static void printResults(const std::vector<BenchmarkResult>& results);
    static void saveResultsToJSON(const std::vector<BenchmarkResult>& results, double totalTime);
};