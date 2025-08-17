package main

import (
	"fmt"
	"time"
)

func main() {
	startTime := time.Now()
	
	results := RunAllBenchmarks()
	totalTime := time.Since(startTime)
	
	PrintResults(results)
	
	err := SaveResultsToJSON(results, totalTime)
	if err != nil {
		fmt.Printf("Error saving results: %v\n", err)
		return
	}
	
	fmt.Printf("Total execution time: %.3f seconds\n", totalTime.Seconds())
}