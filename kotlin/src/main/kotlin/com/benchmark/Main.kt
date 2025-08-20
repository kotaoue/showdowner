package com.benchmark

fun main() {
    val startTime = System.nanoTime()
    
    val results = Benchmark.runAllBenchmarks()
    val totalTime = (System.nanoTime() - startTime) / 1e9
    
    Output.printResults(results)
    
    try {
        Output.saveResultsToJSON(results, totalTime)
    } catch (e: Exception) {
        System.err.println("Error saving results: ${e.message}")
        kotlin.system.exitProcess(1)
    }
    
    println("Total execution time: ${"%.3f".format(totalTime)} seconds")
}