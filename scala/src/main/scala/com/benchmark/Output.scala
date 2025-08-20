package com.benchmark

import org.json4s._
import org.json4s.native.JsonMethods._
import org.json4s.native.Serialization
import org.json4s.native.Serialization.write
import java.io.{File, PrintWriter}
import java.time.{LocalDateTime, ZoneOffset}
import java.time.format.DateTimeFormatter

case class SystemInfo(
  os: String,
  arch: String,
  cpus: Int
)

case class BenchmarkReport(
  language: String,
  timestamp: String,
  scalaVersion: String,
  system: SystemInfo,
  tests: List[BenchmarkResult],
  totalTimeSeconds: Double
)

object Output {
  implicit val formats: Formats = Serialization.formats(NoTypeHints)

  def printResults(results: List[BenchmarkResult]): Unit = {
    println("\n=== BENCHMARK RESULTS ===")
    results.foreach { result =>
      println(s"Test: ${result.test}")
      println(s"  Duration: ${result.durationNs} ns")
      println(s"  Memory: ${result.memoryBytes} bytes")
      println(s"  Operations: ${result.operations}")
      println(f"  Ops/sec: ${result.opsPerSec}%.2f")
      println()
    }
  }

  def saveResultsToJSON(results: List[BenchmarkResult], totalTime: Double): Unit = {
    val report = BenchmarkReport(
      language = "scala",
      timestamp = LocalDateTime.now(ZoneOffset.UTC).format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) + "Z",
      scalaVersion = getScalaVersion,
      system = SystemInfo(
        os = getOSName,
        arch = getArchitecture,
        cpus = Runtime.getRuntime.availableProcessors()
      ),
      tests = results,
      totalTimeSeconds = totalTime
    )

    val timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"))
    val filename = s"benchmark_scala_$timestamp.json"

    val jsonString = write(report)
    val prettyJson = pretty(render(parse(jsonString)))

    val writer = new PrintWriter(new File(filename))
    try {
      writer.write(prettyJson)
    } finally {
      writer.close()
    }

    println(s"Results saved to: $filename")
  }

  private def getScalaVersion: String = {
    scala.util.Properties.versionString
  }

  private def getOSName: String = {
    System.getProperty("os.name")
  }

  private def getArchitecture: String = {
    System.getProperty("os.arch")
  }
}