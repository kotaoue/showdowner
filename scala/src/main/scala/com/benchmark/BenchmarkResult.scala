package com.benchmark

case class BenchmarkResult(
  test: String,
  durationNs: Long,
  memoryBytes: Long,
  operations: Long,
  opsPerSec: Double
)