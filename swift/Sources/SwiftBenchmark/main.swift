import Foundation

func main() {
    let startTime = DispatchTime.now()
    
    let results = Benchmark.runAllBenchmarks()
    
    let endTime = DispatchTime.now()
    let totalTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1e9
    
    Output.printResults(results)
    
    do {
        try Output.saveResultsToJSON(results, totalTime: totalTime)
    } catch {
        print("Error saving results: \(error)")
        exit(1)
    }
    
    print("Total execution time: \(String(format: "%.3f", totalTime)) seconds")
}

main()