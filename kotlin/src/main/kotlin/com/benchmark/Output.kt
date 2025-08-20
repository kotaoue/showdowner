package com.benchmark

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.File
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

@Serializable
data class SystemInfo(
    val os: String,
    val arch: String,
    val cpus: Int
)

@Serializable
data class BenchmarkReport(
    val language: String,
    val timestamp: String,
    @SerialName("kotlin_version") val kotlinVersion: String,
    @SerialName("jvm_version") val jvmVersion: String,
    val system: SystemInfo,
    val tests: List<BenchmarkResult>,
    @SerialName("total_time_seconds") val totalTimeSeconds: Double
)

object Output {
    
    fun printResults(results: List<BenchmarkResult>) {
        println("\n=== BENCHMARK RESULTS ===")
        for (result in results) {
            println("Test: ${result.test}")
            println("  Duration: ${result.durationNs} ns")
            println("  Memory: ${result.memoryBytes} bytes")
            println("  Operations: ${result.operations}")
            println("  Ops/sec: ${"%.2f".format(result.opsPerSec)}")
            println()
        }
    }
    
    fun saveResultsToJSON(results: List<BenchmarkResult>, totalTime: Double) {
        val report = BenchmarkReport(
            language = "kotlin",
            timestamp = LocalDateTime.now().toString(),
            kotlinVersion = KotlinVersion.CURRENT.toString(),
            jvmVersion = System.getProperty("java.version"),
            system = SystemInfo(
                os = System.getProperty("os.name"),
                arch = System.getProperty("os.arch"),
                cpus = Runtime.getRuntime().availableProcessors()
            ),
            tests = results,
            totalTimeSeconds = totalTime
        )
        
        val timestamp = LocalDateTime.now()
            .format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"))
        val filename = "benchmark_kotlin_$timestamp.json"
        
        try {
            val json = Json { prettyPrint = true }
            File(filename).writeText(json.encodeToString(report))
            println("Results saved to: $filename")
        } catch (e: Exception) {
            throw RuntimeException("Error writing file: ${e.message}", e)
        }
    }
}