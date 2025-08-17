#!/usr/bin/env python3

import benchmark
import output
import time

def main():
    start_time = time.time()
    
    results = benchmark.run_all_benchmarks()
    total_time = time.time() - start_time
    
    output.print_results(results)
    
    try:
        output.save_results_to_json(results, total_time)
    except Exception as e:
        print(f"Error saving results: {e}")
        return 1
    
    print(f"Total execution time: {total_time:.3f} seconds")
    return 0

if __name__ == "__main__":
    exit(main())