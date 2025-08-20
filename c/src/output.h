#ifndef OUTPUT_H
#define OUTPUT_H

#include "benchmark.h"

void print_results(const BenchmarkResult* results, int count);
int save_results_to_json(const BenchmarkResult* results, int count, double total_time);

#endif