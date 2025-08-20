package com.benchmark

import java.security.MessageDigest
import kotlin.math.*
import kotlin.random.Random

object Benchmark {
    
    fun runAllBenchmarks(): List<BenchmarkResult> {
        val results = mutableListOf<BenchmarkResult>()
        
        println("Running CPU-intensive benchmarks...")
        results.add(benchmarkPrimeNumbers())
        results.add(benchmarkMatrixMultiplication())
        results.add(benchmarkCryptographicHashing())
        results.add(benchmarkMathOperations())
        
        println("Running memory-intensive benchmarks...")
        results.add(benchmarkLargeArraySort())
        results.add(benchmarkMemoryAllocation())
        results.add(benchmarkStringConcatenation())
        
        return results
    }
    
    private fun benchmarkPrimeNumbers(): BenchmarkResult {
        val start = System.nanoTime()
        
        var count = 0
        val limit = 100000
        for (i in 2..limit) {
            if (isPrime(i)) {
                count++
            }
        }
        
        val duration = System.nanoTime() - start
        val durationSeconds = duration / 1e9
        
        return BenchmarkResult(
            test = "Prime Numbers (up to 100k)",
            durationNs = duration,
            memoryBytes = 0, // Kotlinでは正確なメモリ測定が困難
            operations = count.toLong(),
            opsPerSec = count / durationSeconds
        )
    }
    
    private fun isPrime(n: Int): Boolean {
        if (n < 2) return false
        for (i in 2..sqrt(n.toDouble()).toInt()) {
            if (n % i == 0) return false
        }
        return true
    }
    
    private fun benchmarkMatrixMultiplication(): BenchmarkResult {
        val start = System.nanoTime()
        
        val size = 500
        val random = Random(42) // 再現可能性のためのシード
        val a = Array(size) { DoubleArray(size) { random.nextDouble() } }
        val b = Array(size) { DoubleArray(size) { random.nextDouble() } }
        val c = Array(size) { DoubleArray(size) }
        
        // 行列乗算
        for (i in 0 until size) {
            for (j in 0 until size) {
                for (k in 0 until size) {
                    c[i][j] += a[i][k] * b[k][j]
                }
            }
        }
        
        val duration = System.nanoTime() - start
        val durationSeconds = duration / 1e9
        val operations = size.toLong() * size * size
        
        return BenchmarkResult(
            test = "Matrix Multiplication (500x500)",
            durationNs = duration,
            memoryBytes = 0,
            operations = operations,
            opsPerSec = operations / durationSeconds
        )
    }
    
    private fun benchmarkCryptographicHashing(): BenchmarkResult {
        val start = System.nanoTime()
        
        val digest = MessageDigest.getInstance("SHA-256")
        val data = ByteArray(1024)
        Random(42).nextBytes(data)
        
        val iterations = 50000
        repeat(iterations) {
            digest.reset()
            digest.update(data)
            digest.digest()
        }
        
        val duration = System.nanoTime() - start
        val durationSeconds = duration / 1e9
        
        return BenchmarkResult(
            test = "SHA256 Hashing (50k iterations)",
            durationNs = duration,
            memoryBytes = 0,
            operations = iterations.toLong(),
            opsPerSec = iterations / durationSeconds
        )
    }
    
    private fun benchmarkMathOperations(): BenchmarkResult {
        val start = System.nanoTime()
        
        val iterations = 10000000
        var result = 0.0
        for (i in 0 until iterations) {
            val x = i.toDouble()
            result += sin(x) * cos(x) * sqrt(x + 1)
        }
        
        val duration = System.nanoTime() - start
        val durationSeconds = duration / 1e9
        
        // resultを使用して最適化を防ぐ
        if (result.isNaN()) {
            println("Unexpected NaN result")
        }
        
        return BenchmarkResult(
            test = "Math Operations (10M iterations)",
            durationNs = duration,
            memoryBytes = 0,
            operations = iterations.toLong(),
            opsPerSec = iterations / durationSeconds
        )
    }
    
    private fun benchmarkLargeArraySort(): BenchmarkResult {
        val start = System.nanoTime()
        
        val size = 1000000
        val data = IntArray(size) { Random(42).nextInt(1000001) }
        
        data.sort()
        
        val duration = System.nanoTime() - start
        val durationSeconds = duration / 1e9
        
        return BenchmarkResult(
            test = "Large Array Sort (1M elements)",
            durationNs = duration,
            memoryBytes = 0,
            operations = size.toLong(),
            opsPerSec = size / durationSeconds
        )
    }
    
    private fun benchmarkMemoryAllocation(): BenchmarkResult {
        val start = System.nanoTime()
        
        val allocations = 100000
        val arrays = mutableListOf<IntArray>()
        
        repeat(allocations) { i ->
            val data = IntArray(256) { i % 256 } // 1KB相当のデータ
            arrays.add(data)
        }
        
        val duration = System.nanoTime() - start
        val durationSeconds = duration / 1e9
        
        return BenchmarkResult(
            test = "Memory Allocation (100k x 1KB)",
            durationNs = duration,
            memoryBytes = 0,
            operations = allocations.toLong(),
            opsPerSec = allocations / durationSeconds
        )
    }
    
    private fun benchmarkStringConcatenation(): BenchmarkResult {
        val start = System.nanoTime()
        
        val iterations = 50000
        val result = StringBuilder()
        repeat(iterations) { i ->
            result.append("iteration_${i}_")
        }
        
        val duration = System.nanoTime() - start
        val durationSeconds = duration / 1e9
        
        return BenchmarkResult(
            test = "String Concatenation (50k iterations)",
            durationNs = duration,
            memoryBytes = 0,
            operations = iterations.toLong(),
            opsPerSec = iterations / durationSeconds
        )
    }
}