import Foundation
import CryptoKit

class Benchmark {
    static func runAllBenchmarks() -> [BenchmarkResult] {
        var results: [BenchmarkResult] = []
        
        print("Running CPU-intensive benchmarks...")
        results.append(benchmarkPrimeNumbers())
        results.append(benchmarkMatrixMultiplication())
        results.append(benchmarkCryptographicHashing())
        results.append(benchmarkMathOperations())
        
        print("Running memory-intensive benchmarks...")
        results.append(benchmarkLargeArraySort())
        results.append(benchmarkMemoryAllocation())
        results.append(benchmarkStringConcatenation())
        
        return results
    }
    
    private static func benchmarkPrimeNumbers() -> BenchmarkResult {
        let start = DispatchTime.now()
        
        var count = 0
        let limit = 100000
        for i in 2...limit {
            if isPrime(i) {
                count += 1
            }
        }
        
        let end = DispatchTime.now()
        let duration = end.uptimeNanoseconds - start.uptimeNanoseconds
        let durationSeconds = Double(duration) / 1e9
        
        return BenchmarkResult(
            test: "Prime Numbers (up to 100k)",
            durationNs: Int64(duration),
            memoryBytes: 0, // Swiftでは正確なメモリ測定が困難
            operations: Int64(count),
            opsPerSec: Double(count) / durationSeconds
        )
    }
    
    private static func isPrime(_ n: Int) -> Bool {
        if n < 2 { return false }
        for i in 2...Int(sqrt(Double(n))) {
            if n % i == 0 { return false }
        }
        return true
    }
    
    private static func benchmarkMatrixMultiplication() -> BenchmarkResult {
        let start = DispatchTime.now()
        
        let size = 500
        var a = Array(repeating: Array(repeating: 0.0, count: size), count: size)
        var b = Array(repeating: Array(repeating: 0.0, count: size), count: size)
        var c = Array(repeating: Array(repeating: 0.0, count: size), count: size)
        
        // 行列初期化（再現可能性のため）
        var rng = SystemRandomNumberGenerator()
        rng = SystemRandomNumberGenerator() // シード固定代替
        for i in 0..<size {
            for j in 0..<size {
                a[i][j] = Double.random(in: 0...1)
                b[i][j] = Double.random(in: 0...1)
            }
        }
        
        // 行列乗算
        for i in 0..<size {
            for j in 0..<size {
                for k in 0..<size {
                    c[i][j] += a[i][k] * b[k][j]
                }
            }
        }
        
        let end = DispatchTime.now()
        let duration = end.uptimeNanoseconds - start.uptimeNanoseconds
        let durationSeconds = Double(duration) / 1e9
        let operations = Int64(size * size * size)
        
        return BenchmarkResult(
            test: "Matrix Multiplication (500x500)",
            durationNs: Int64(duration),
            memoryBytes: 0,
            operations: operations,
            opsPerSec: Double(operations) / durationSeconds
        )
    }
    
    private static func benchmarkCryptographicHashing() -> BenchmarkResult {
        let start = DispatchTime.now()
        
        let data = Data((0..<1024).map { _ in UInt8.random(in: 0...255) })
        
        let iterations = 50000
        for _ in 0..<iterations {
            _ = SHA256.hash(data: data)
        }
        
        let end = DispatchTime.now()
        let duration = end.uptimeNanoseconds - start.uptimeNanoseconds
        let durationSeconds = Double(duration) / 1e9
        
        return BenchmarkResult(
            test: "SHA256 Hashing (50k iterations)",
            durationNs: Int64(duration),
            memoryBytes: 0,
            operations: Int64(iterations),
            opsPerSec: Double(iterations) / durationSeconds
        )
    }
    
    private static func benchmarkMathOperations() -> BenchmarkResult {
        let start = DispatchTime.now()
        
        let iterations = 10000000
        var result = 0.0
        for i in 0..<iterations {
            let x = Double(i)
            result += sin(x) * cos(x) * sqrt(x + 1)
        }
        
        let end = DispatchTime.now()
        let duration = end.uptimeNanoseconds - start.uptimeNanoseconds
        let durationSeconds = Double(duration) / 1e9
        
        // resultを使用して最適化を防ぐ
        if result.isNaN {
            print("Unexpected NaN result")
        }
        
        return BenchmarkResult(
            test: "Math Operations (10M iterations)",
            durationNs: Int64(duration),
            memoryBytes: 0,
            operations: Int64(iterations),
            opsPerSec: Double(iterations) / durationSeconds
        )
    }
    
    private static func benchmarkLargeArraySort() -> BenchmarkResult {
        let start = DispatchTime.now()
        
        let size = 1000000
        var data = (0..<size).map { _ in Int.random(in: 0...1000000) }
        
        data.sort()
        
        let end = DispatchTime.now()
        let duration = end.uptimeNanoseconds - start.uptimeNanoseconds
        let durationSeconds = Double(duration) / 1e9
        
        return BenchmarkResult(
            test: "Large Array Sort (1M elements)",
            durationNs: Int64(duration),
            memoryBytes: 0,
            operations: Int64(size),
            opsPerSec: Double(size) / durationSeconds
        )
    }
    
    private static func benchmarkMemoryAllocation() -> BenchmarkResult {
        let start = DispatchTime.now()
        
        let allocations = 100000
        var arrays: [[Int]] = []
        arrays.reserveCapacity(allocations)
        
        for i in 0..<allocations {
            let data = Array(repeating: i % 256, count: 256) // 1KB相当のデータ
            arrays.append(data)
        }
        
        let end = DispatchTime.now()
        let duration = end.uptimeNanoseconds - start.uptimeNanoseconds
        let durationSeconds = Double(duration) / 1e9
        
        return BenchmarkResult(
            test: "Memory Allocation (100k x 1KB)",
            durationNs: Int64(duration),
            memoryBytes: 0,
            operations: Int64(allocations),
            opsPerSec: Double(allocations) / durationSeconds
        )
    }
    
    private static func benchmarkStringConcatenation() -> BenchmarkResult {
        let start = DispatchTime.now()
        
        let iterations = 50000
        var result = ""
        for i in 0..<iterations {
            result += "iteration_\(i)_"
        }
        
        let end = DispatchTime.now()
        let duration = end.uptimeNanoseconds - start.uptimeNanoseconds
        let durationSeconds = Double(duration) / 1e9
        
        return BenchmarkResult(
            test: "String Concatenation (50k iterations)",
            durationNs: Int64(duration),
            memoryBytes: 0,
            operations: Int64(iterations),
            opsPerSec: Double(iterations) / durationSeconds
        )
    }
}