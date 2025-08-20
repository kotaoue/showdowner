class BenchmarkResult {
  final String test;
  final int durationNs;
  final int memoryBytes;
  final int operations;
  final double opsPerSec;

  BenchmarkResult({
    required this.test,
    required this.durationNs,
    required this.memoryBytes,
    required this.operations,
    required this.opsPerSec,
  });

  Map<String, dynamic> toJson() => {
        'test': test,
        'duration_ns': durationNs,
        'memory_bytes': memoryBytes,
        'operations': operations,
        'ops_per_sec': opsPerSec,
      };
}