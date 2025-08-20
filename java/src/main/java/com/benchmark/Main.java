package com.benchmark;

import java.util.List;

public class Main {
    public static void main(String[] args) {
        long startTime = System.nanoTime();
        
        List<BenchmarkResult> results = Benchmark.runAllBenchmarks();
        double totalTime = (System.nanoTime() - startTime) / 1e9;
        
        Output.printResults(results);
        
        try {
            Output.saveResultsToJSON(results, totalTime);
        } catch (Exception e) {
            System.err.println("Error saving results: " + e.getMessage());
            System.exit(1);
        }
        
        System.out.printf("Total execution time: %.3f seconds%n", totalTime);
    }
}