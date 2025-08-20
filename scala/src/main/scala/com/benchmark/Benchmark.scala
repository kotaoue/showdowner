package com.benchmark

import java.security.MessageDigest
import java.util.Random
import scala.collection.mutable.ListBuffer
import scala.math._

object Benchmark {
  def runAllBenchmarks(): List[BenchmarkResult] = {
    val results = ListBuffer[BenchmarkResult]()

    println("Running CPU-intensive benchmarks...")
    results += benchmarkPrimeNumbers()
    results += benchmarkMatrixMultiplication()
    results += benchmarkCryptographicHashing()
    results += benchmarkMathOperations()

    println("Running memory-intensive benchmarks...")
    results += benchmarkLargeArraySort()
    results += benchmarkMemoryAllocation()
    results += benchmarkStringConcatenation()

    results.toList
  }

  def benchmarkPrimeNumbers(): BenchmarkResult = {
    val startTime = System.nanoTime()

    var count = 0
    val limit = 100000
    for (i <- 2 to limit) {
      if (isPrime(i)) {
        count += 1
      }
    }

    val endTime = System.nanoTime()
    val duration = endTime - startTime
    val durationSeconds = duration / 1e9

    BenchmarkResult(
      test = "Prime Numbers (up to 100k)",
      durationNs = duration,
      memoryBytes = 0L, // Scalaでは正確なメモリ測定が困難
      operations = count,
      opsPerSec = count / durationSeconds
    )
  }

  private def isPrime(n: Int): Boolean = {
    if (n < 2) return false
    for (i <- 2 to sqrt(n).toInt) {
      if (n % i == 0) return false
    }
    true
  }

  def benchmarkMatrixMultiplication(): BenchmarkResult = {
    val startTime = System.nanoTime()

    val size = 500
    val random = new Random(42) // 再現可能性のためのシード

    val a = Array.ofDim[Double](size, size)
    val b = Array.ofDim[Double](size, size)
    val c = Array.ofDim[Double](size, size)

    // 行列初期化
    for (i <- 0 until size; j <- 0 until size) {
      a(i)(j) = random.nextDouble()
      b(i)(j) = random.nextDouble()
    }

    // 行列乗算
    for (i <- 0 until size; j <- 0 until size; k <- 0 until size) {
      c(i)(j) += a(i)(k) * b(k)(j)
    }

    val endTime = System.nanoTime()
    val duration = endTime - startTime
    val durationSeconds = duration / 1e9
    val operations = size * size * size

    BenchmarkResult(
      test = "Matrix Multiplication (500x500)",
      durationNs = duration,
      memoryBytes = 0L,
      operations = operations,
      opsPerSec = operations / durationSeconds
    )
  }

  def benchmarkCryptographicHashing(): BenchmarkResult = {
    val startTime = System.nanoTime()

    val random = new Random(42)
    val data = Array.fill(1024)(random.nextInt(256).toByte)
    val md = MessageDigest.getInstance("SHA-256")

    val iterations = 50000
    for (_ <- 1 to iterations) {
      md.digest(data)
      md.reset()
    }

    val endTime = System.nanoTime()
    val duration = endTime - startTime
    val durationSeconds = duration / 1e9

    BenchmarkResult(
      test = "SHA256 Hashing (50k iterations)",
      durationNs = duration,
      memoryBytes = 0L,
      operations = iterations,
      opsPerSec = iterations / durationSeconds
    )
  }

  def benchmarkMathOperations(): BenchmarkResult = {
    val startTime = System.nanoTime()

    val iterations = 10000000
    var result = 0.0
    for (i <- 0 until iterations) {
      val x = i.toDouble
      result += sin(x) * cos(x) * sqrt(x + 1)
    }

    val endTime = System.nanoTime()
    val duration = endTime - startTime
    val durationSeconds = duration / 1e9

    // resultを使用して最適化を防ぐ
    if (result.isNaN) {
      println("Unexpected NaN result")
    }

    BenchmarkResult(
      test = "Math Operations (10M iterations)",
      durationNs = duration,
      memoryBytes = 0L,
      operations = iterations,
      opsPerSec = iterations / durationSeconds
    )
  }

  def benchmarkLargeArraySort(): BenchmarkResult = {
    val startTime = System.nanoTime()

    val size = 1000000
    val random = new Random(42)
    val data = Array.fill(size)(random.nextInt(1000001))

    scala.util.Sorting.quickSort(data)

    val endTime = System.nanoTime()
    val duration = endTime - startTime
    val durationSeconds = duration / 1e9

    BenchmarkResult(
      test = "Large Array Sort (1M elements)",
      durationNs = duration,
      memoryBytes = 0L,
      operations = size,
      opsPerSec = size / durationSeconds
    )
  }

  def benchmarkMemoryAllocation(): BenchmarkResult = {
    val startTime = System.nanoTime()

    val allocations = 100000
    val arrays = ListBuffer[Array[Int]]()

    for (i <- 0 until allocations) {
      val data = Array.fill(256)(i % 256) // 1KB相当のデータ
      arrays += data
    }

    val endTime = System.nanoTime()
    val duration = endTime - startTime
    val durationSeconds = duration / 1e9

    BenchmarkResult(
      test = "Memory Allocation (100k x 1KB)",
      durationNs = duration,
      memoryBytes = 0L,
      operations = allocations,
      opsPerSec = allocations / durationSeconds
    )
  }

  def benchmarkStringConcatenation(): BenchmarkResult = {
    val startTime = System.nanoTime()

    val iterations = 50000
    val buffer = new StringBuilder()
    for (i <- 0 until iterations) {
      buffer.append(s"iteration_${i}_")
    }
    val result = buffer.toString()

    val endTime = System.nanoTime()
    val duration = endTime - startTime
    val durationSeconds = duration / 1e9

    BenchmarkResult(
      test = "String Concatenation (50k iterations)",
      durationNs = duration,
      memoryBytes = 0L,
      operations = iterations,
      opsPerSec = iterations / durationSeconds
    )
  }

  def main(args: Array[String]): Unit = {
    val startTime = System.nanoTime()

    val results = runAllBenchmarks()

    val endTime = System.nanoTime()
    val totalTime = (endTime - startTime) / 1e9

    Output.printResults(results)

    try {
      Output.saveResultsToJSON(results, totalTime)
    } catch {
      case e: Exception =>
        println(s"Error saving results: ${e.getMessage}")
        System.exit(1)
    }

    println(f"Total execution time: $totalTime%.3f seconds")
  }
}