package main

import (
	"crypto/sha256"
	"fmt"
	"math"
	"math/rand"
	"runtime"
	"sort"
	"time"
)

func RunAllBenchmarks() []BenchmarkResult {
	results := []BenchmarkResult{}
	
	fmt.Println("Running CPU-intensive benchmarks...")
	results = append(results, benchmarkPrimeNumbers())
	results = append(results, benchmarkMatrixMultiplication())
	results = append(results, benchmarkCryptographicHashing())
	results = append(results, benchmarkMathOperations())
	
	fmt.Println("Running memory-intensive benchmarks...")
	results = append(results, benchmarkLargeArraySort())
	results = append(results, benchmarkMemoryAllocation())
	results = append(results, benchmarkStringConcatenation())
	
	return results
}

func benchmarkPrimeNumbers() BenchmarkResult {
	start := time.Now()
	var memBefore runtime.MemStats
	runtime.GC()
	runtime.ReadMemStats(&memBefore)
	
	count := 0
	limit := 100000
	for i := 2; i <= limit; i++ {
		if isPrime(i) {
			count++
		}
	}
	
	duration := time.Since(start)
	var memAfter runtime.MemStats
	runtime.ReadMemStats(&memAfter)
	
	return BenchmarkResult{
		Test:       "Prime Numbers (up to 100k)",
		Duration:   duration,
		MemoryUsed: int64(memAfter.Alloc - memBefore.Alloc),
		Operations: int64(count),
		OpsPerSec:  float64(count) / duration.Seconds(),
	}
}

func isPrime(n int) bool {
	if n < 2 {
		return false
	}
	for i := 2; i <= int(math.Sqrt(float64(n))); i++ {
		if n%i == 0 {
			return false
		}
	}
	return true
}

func benchmarkMatrixMultiplication() BenchmarkResult {
	start := time.Now()
	var memBefore runtime.MemStats
	runtime.GC()
	runtime.ReadMemStats(&memBefore)
	
	size := 500
	a := make([][]float64, size)
	b := make([][]float64, size)
	c := make([][]float64, size)
	
	for i := 0; i < size; i++ {
		a[i] = make([]float64, size)
		b[i] = make([]float64, size)
		c[i] = make([]float64, size)
		for j := 0; j < size; j++ {
			a[i][j] = rand.Float64()
			b[i][j] = rand.Float64()
		}
	}
	
	for i := 0; i < size; i++ {
		for j := 0; j < size; j++ {
			for k := 0; k < size; k++ {
				c[i][j] += a[i][k] * b[k][j]
			}
		}
	}
	
	duration := time.Since(start)
	var memAfter runtime.MemStats
	runtime.ReadMemStats(&memAfter)
	
	operations := int64(size * size * size)
	
	return BenchmarkResult{
		Test:       "Matrix Multiplication (500x500)",
		Duration:   duration,
		MemoryUsed: int64(memAfter.Alloc - memBefore.Alloc),
		Operations: operations,
		OpsPerSec:  float64(operations) / duration.Seconds(),
	}
}

func benchmarkCryptographicHashing() BenchmarkResult {
	start := time.Now()
	var memBefore runtime.MemStats
	runtime.GC()
	runtime.ReadMemStats(&memBefore)
	
	data := make([]byte, 1024)
	for i := range data {
		data[i] = byte(rand.Intn(256))
	}
	
	iterations := 50000
	for i := 0; i < iterations; i++ {
		sha256.Sum256(data)
	}
	
	duration := time.Since(start)
	var memAfter runtime.MemStats
	runtime.ReadMemStats(&memAfter)
	
	return BenchmarkResult{
		Test:       "SHA256 Hashing (50k iterations)",
		Duration:   duration,
		MemoryUsed: int64(memAfter.Alloc - memBefore.Alloc),
		Operations: int64(iterations),
		OpsPerSec:  float64(iterations) / duration.Seconds(),
	}
}

func benchmarkMathOperations() BenchmarkResult {
	start := time.Now()
	var memBefore runtime.MemStats
	runtime.GC()
	runtime.ReadMemStats(&memBefore)
	
	iterations := 10000000
	result := 0.0
	for i := 0; i < iterations; i++ {
		x := float64(i)
		result += math.Sin(x) * math.Cos(x) * math.Sqrt(x+1)
	}
	
	duration := time.Since(start)
	var memAfter runtime.MemStats
	runtime.ReadMemStats(&memAfter)
	
	return BenchmarkResult{
		Test:       "Math Operations (10M iterations)",
		Duration:   duration,
		MemoryUsed: int64(memAfter.Alloc - memBefore.Alloc),
		Operations: int64(iterations),
		OpsPerSec:  float64(iterations) / duration.Seconds(),
	}
}

func benchmarkLargeArraySort() BenchmarkResult {
	start := time.Now()
	var memBefore runtime.MemStats
	runtime.GC()
	runtime.ReadMemStats(&memBefore)
	
	size := 1000000
	data := make([]int, size)
	for i := 0; i < size; i++ {
		data[i] = rand.Intn(1000000)
	}
	
	sort.Ints(data)
	
	duration := time.Since(start)
	var memAfter runtime.MemStats
	runtime.ReadMemStats(&memAfter)
	
	return BenchmarkResult{
		Test:       "Large Array Sort (1M elements)",
		Duration:   duration,
		MemoryUsed: int64(memAfter.Alloc - memBefore.Alloc),
		Operations: int64(size),
		OpsPerSec:  float64(size) / duration.Seconds(),
	}
}

func benchmarkMemoryAllocation() BenchmarkResult {
	start := time.Now()
	var memBefore runtime.MemStats
	runtime.GC()
	runtime.ReadMemStats(&memBefore)
	
	allocations := 100000
	slices := make([][]byte, allocations)
	
	for i := 0; i < allocations; i++ {
		slices[i] = make([]byte, 1024)
		for j := range slices[i] {
			slices[i][j] = byte(i % 256)
		}
	}
	
	duration := time.Since(start)
	var memAfter runtime.MemStats
	runtime.ReadMemStats(&memAfter)
	
	return BenchmarkResult{
		Test:       "Memory Allocation (100k x 1KB)",
		Duration:   duration,
		MemoryUsed: int64(memAfter.Alloc - memBefore.Alloc),
		Operations: int64(allocations),
		OpsPerSec:  float64(allocations) / duration.Seconds(),
	}
}

func benchmarkStringConcatenation() BenchmarkResult {
	start := time.Now()
	var memBefore runtime.MemStats
	runtime.GC()
	runtime.ReadMemStats(&memBefore)
	
	iterations := 50000
	result := ""
	for i := 0; i < iterations; i++ {
		result += fmt.Sprintf("iteration_%d_", i)
	}
	
	duration := time.Since(start)
	var memAfter runtime.MemStats
	runtime.ReadMemStats(&memAfter)
	
	return BenchmarkResult{
		Test:       "String Concatenation (50k iterations)",
		Duration:   duration,
		MemoryUsed: int64(memAfter.Alloc - memBefore.Alloc),
		Operations: int64(iterations),
		OpsPerSec:  float64(iterations) / duration.Seconds(),
	}
}