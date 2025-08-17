#!/usr/bin/env python
# -*- coding: utf-8 -*-

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
        print("Error saving results: %s" % str(e))
        return 1
    
    print("Total execution time: %.3f seconds" % total_time)
    return 0

if __name__ == "__main__":
    exit(main())