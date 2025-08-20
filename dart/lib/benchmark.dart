import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'benchmark_result.dart';

class Benchmark {
  static List<BenchmarkResult> runAllBenchmarks() {
    final results = <BenchmarkResult>[];

    print('Running CPU-intensive benchmarks...');
    results.add(benchmarkPrimeNumbers());
    results.add(benchmarkMatrixMultiplication());
    results.add(benchmarkCryptographicHashing());
    results.add(benchmarkMathOperations());

    print('Running memory-intensive benchmarks...');
    results.add(benchmarkLargeArraySort());
    results.add(benchmarkMemoryAllocation());
    results.add(benchmarkStringConcatenation());

    return results;
  }

  static BenchmarkResult benchmarkPrimeNumbers() {
    final stopwatch = Stopwatch()..start();

    var count = 0;
    const limit = 100000;
    for (var i = 2; i <= limit; i++) {
      if (_isPrime(i)) {
        count++;
      }
    }

    stopwatch.stop();
    final duration = stopwatch.elapsedMicroseconds * 1000; // Convert to ns
    final durationSeconds = duration / 1e9;

    return BenchmarkResult(
      test: 'Prime Numbers (up to 100k)',
      durationNs: duration,
      memoryBytes: 0, // Dartでは正確なメモリ測定が困難
      operations: count,
      opsPerSec: count / durationSeconds,
    );
  }

  static bool _isPrime(int n) {
    if (n < 2) return false;
    for (var i = 2; i <= sqrt(n); i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  static BenchmarkResult benchmarkMatrixMultiplication() {
    final stopwatch = Stopwatch()..start();

    const size = 500;
    final random = Random(42); // 再現可能性のためのシード

    final a = List.generate(size, (_) => List.generate(size, (_) => random.nextDouble()));
    final b = List.generate(size, (_) => List.generate(size, (_) => random.nextDouble()));
    final c = List.generate(size, (_) => List.filled(size, 0.0));

    // 行列乗算
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        for (var k = 0; k < size; k++) {
          c[i][j] += a[i][k] * b[k][j];
        }
      }
    }

    stopwatch.stop();
    final duration = stopwatch.elapsedMicroseconds * 1000;
    final durationSeconds = duration / 1e9;
    final operations = size * size * size;

    return BenchmarkResult(
      test: 'Matrix Multiplication (500x500)',
      durationNs: duration,
      memoryBytes: 0,
      operations: operations,
      opsPerSec: operations / durationSeconds,
    );
  }

  static BenchmarkResult benchmarkCryptographicHashing() {
    final stopwatch = Stopwatch()..start();

    final random = Random(42);
    final data = Uint8List.fromList(List.generate(1024, (_) => random.nextInt(256)));

    const iterations = 50000;
    for (var i = 0; i < iterations; i++) {
      sha256.convert(data);
    }

    stopwatch.stop();
    final duration = stopwatch.elapsedMicroseconds * 1000;
    final durationSeconds = duration / 1e9;

    return BenchmarkResult(
      test: 'SHA256 Hashing (50k iterations)',
      durationNs: duration,
      memoryBytes: 0,
      operations: iterations,
      opsPerSec: iterations / durationSeconds,
    );
  }

  static BenchmarkResult benchmarkMathOperations() {
    final stopwatch = Stopwatch()..start();

    const iterations = 10000000;
    var result = 0.0;
    for (var i = 0; i < iterations; i++) {
      final x = i.toDouble();
      result += sin(x) * cos(x) * sqrt(x + 1);
    }

    stopwatch.stop();
    final duration = stopwatch.elapsedMicroseconds * 1000;
    final durationSeconds = duration / 1e9;

    // resultを使用して最適化を防ぐ
    if (result.isNaN) {
      print('Unexpected NaN result');
    }

    return BenchmarkResult(
      test: 'Math Operations (10M iterations)',
      durationNs: duration,
      memoryBytes: 0,
      operations: iterations,
      opsPerSec: iterations / durationSeconds,
    );
  }

  static BenchmarkResult benchmarkLargeArraySort() {
    final stopwatch = Stopwatch()..start();

    const size = 1000000;
    final random = Random(42);
    final data = List.generate(size, (_) => random.nextInt(1000001));

    data.sort();

    stopwatch.stop();
    final duration = stopwatch.elapsedMicroseconds * 1000;
    final durationSeconds = duration / 1e9;

    return BenchmarkResult(
      test: 'Large Array Sort (1M elements)',
      durationNs: duration,
      memoryBytes: 0,
      operations: size,
      opsPerSec: size / durationSeconds,
    );
  }

  static BenchmarkResult benchmarkMemoryAllocation() {
    final stopwatch = Stopwatch()..start();

    const allocations = 100000;
    final arrays = <List<int>>[];

    for (var i = 0; i < allocations; i++) {
      final data = List.filled(256, i % 256); // 1KB相当のデータ
      arrays.add(data);
    }

    stopwatch.stop();
    final duration = stopwatch.elapsedMicroseconds * 1000;
    final durationSeconds = duration / 1e9;

    return BenchmarkResult(
      test: 'Memory Allocation (100k x 1KB)',
      durationNs: duration,
      memoryBytes: 0,
      operations: allocations,
      opsPerSec: allocations / durationSeconds,
    );
  }

  static BenchmarkResult benchmarkStringConcatenation() {
    final stopwatch = Stopwatch()..start();

    const iterations = 50000;
    final buffer = StringBuffer();
    for (var i = 0; i < iterations; i++) {
      buffer.write('iteration_${i}_');
    }
    final result = buffer.toString();

    stopwatch.stop();
    final duration = stopwatch.elapsedMicroseconds * 1000;
    final durationSeconds = duration / 1e9;

    return BenchmarkResult(
      test: 'String Concatenation (50k iterations)',
      durationNs: duration,
      memoryBytes: 0,
      operations: iterations,
      opsPerSec: iterations / durationSeconds,
    );
  }
}