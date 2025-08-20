import Foundation

struct BenchmarkResult: Codable {
    let test: String
    let durationNs: Int64
    let memoryBytes: Int64
    let operations: Int64
    let opsPerSec: Double
    
    enum CodingKeys: String, CodingKey {
        case test
        case durationNs = "duration_ns"
        case memoryBytes = "memory_bytes"
        case operations
        case opsPerSec = "ops_per_sec"
    }
}