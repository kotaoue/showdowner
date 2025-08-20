package com.benchmark

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class BenchmarkResult(
    val test: String,
    @SerialName("duration_ns") val durationNs: Long,
    @SerialName("memory_bytes") val memoryBytes: Long,
    val operations: Long,
    @SerialName("ops_per_sec") val opsPerSec: Double
)