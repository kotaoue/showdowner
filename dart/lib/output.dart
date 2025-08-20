import 'dart:convert';
import 'dart:io';
import 'benchmark_result.dart';

class SystemInfo {
  final String os;
  final String arch;
  final int cpus;

  SystemInfo({
    required this.os,
    required this.arch,
    required this.cpus,
  });

  Map<String, dynamic> toJson() => {
        'os': os,
        'arch': arch,
        'cpus': cpus,
      };
}

class BenchmarkReport {
  final String language;
  final String timestamp;
  final String dartVersion;
  final SystemInfo system;
  final List<BenchmarkResult> tests;
  final double totalTimeSeconds;

  BenchmarkReport({
    required this.language,
    required this.timestamp,
    required this.dartVersion,
    required this.system,
    required this.tests,
    required this.totalTimeSeconds,
  });

  Map<String, dynamic> toJson() => {
        'language': language,
        'timestamp': timestamp,
        'dart_version': dartVersion,
        'system': system.toJson(),
        'tests': tests.map((t) => t.toJson()).toList(),
        'total_time_seconds': totalTimeSeconds,
      };
}

class Output {
  static void printResults(List<BenchmarkResult> results) {
    print('\n=== BENCHMARK RESULTS ===');
    for (final result in results) {
      print('Test: ${result.test}');
      print('  Duration: ${result.durationNs} ns');
      print('  Memory: ${result.memoryBytes} bytes');
      print('  Operations: ${result.operations}');
      print('  Ops/sec: ${result.opsPerSec.toStringAsFixed(2)}');
      print('');
    }
  }

  static Future<void> saveResultsToJSON(
      List<BenchmarkResult> results, double totalTime) async {
    final report = BenchmarkReport(
      language: 'dart',
      timestamp: DateTime.now().toIso8601String(),
      dartVersion: Platform.version.split(' ').first,
      system: SystemInfo(
        os: _getOSName(),
        arch: _getArchitecture(),
        cpus: Platform.numberOfProcessors,
      ),
      tests: results,
      totalTimeSeconds: totalTime,
    );

    final now = DateTime.now();
    final timestamp = '${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
    final filename = 'benchmark_dart_$timestamp.json';

    final encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(report.toJson());

    final file = File(filename);
    await file.writeAsString(jsonString);
    print('Results saved to: $filename');
  }

  static String _getOSName() {
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return 'Unknown';
  }

  static String _getArchitecture() {
    final executable = Platform.executable;
    if (executable.contains('arm64')) return 'arm64';
    if (executable.contains('x64') || executable.contains('x86_64')) return 'x86_64';
    if (executable.contains('arm')) return 'arm';
    return 'unknown';
  }
}