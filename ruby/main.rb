#!/usr/bin/env ruby

require_relative 'benchmark'
require_relative 'output'

def main
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
  
  results = Benchmark.run_all_benchmarks
  total_time = (Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond) - start_time) / 1e9
  
  Output.print_results(results)
  
  begin
    Output.save_results_to_json(results, total_time)
  rescue => e
    puts "Error saving results: #{e.message}"
    exit 1
  end
  
  puts "Total execution time: #{'%.3f' % total_time} seconds"
end

main if __FILE__ == $0