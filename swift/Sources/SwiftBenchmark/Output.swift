import Foundation

struct SystemInfo: Codable {
    let os: String
    let arch: String
    let cpus: Int
}

struct BenchmarkReport: Codable {
    let language: String
    let timestamp: String
    let swiftVersion: String
    let system: SystemInfo
    let tests: [BenchmarkResult]
    let totalTimeSeconds: Double
    
    enum CodingKeys: String, CodingKey {
        case language
        case timestamp
        case swiftVersion = "swift_version"
        case system
        case tests
        case totalTimeSeconds = "total_time_seconds"
    }
}

class Output {
    static func printResults(_ results: [BenchmarkResult]) {
        print("\n=== BENCHMARK RESULTS ===")
        for result in results {
            print("Test: \(result.test)")
            print("  Duration: \(result.durationNs) ns")
            print("  Memory: \(result.memoryBytes) bytes")
            print("  Operations: \(result.operations)")
            print("  Ops/sec: \(String(format: "%.2f", result.opsPerSec))")
            print()
        }
    }
    
    static func saveResultsToJSON(_ results: [BenchmarkResult], totalTime: Double) throws {
        let report = BenchmarkReport(
            language: "swift",
            timestamp: ISO8601DateFormatter().string(from: Date()),
            swiftVersion: getSwiftVersion(),
            system: SystemInfo(
                os: getOSName(),
                arch: getArchitecture(),
                cpus: ProcessInfo.processInfo.processorCount
            ),
            tests: results,
            totalTimeSeconds: totalTime
        )
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let timestamp = formatter.string(from: Date())
        let filename = "benchmark_swift_\(timestamp).json"
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(report)
        
        let url = URL(fileURLWithPath: filename)
        try jsonData.write(to: url)
        print("Results saved to: \(filename)")
    }
    
    private static func getSwiftVersion() -> String {
        #if swift(>=5.8)
        return "5.8+"
        #elseif swift(>=5.7)
        return "5.7"
        #elseif swift(>=5.6)
        return "5.6"
        #else
        return "5.5 or earlier"
        #endif
    }
    
    private static func getOSName() -> String {
        #if os(macOS)
        return "macOS"
        #elseif os(iOS)
        return "iOS"
        #elseif os(watchOS)
        return "watchOS"
        #elseif os(tvOS)
        return "tvOS"
        #elseif os(Linux)
        return "Linux"
        #else
        return "Unknown"
        #endif
    }
    
    private static func getArchitecture() -> String {
        #if arch(x86_64)
        return "x86_64"
        #elseif arch(arm64)
        return "arm64"
        #elseif arch(arm)
        return "arm"
        #else
        return "unknown"
        #endif
    }
}