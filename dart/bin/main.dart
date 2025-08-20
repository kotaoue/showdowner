import 'dart:io';
import '../lib/benchmark.dart';
import '../lib/output.dart';

void main() async {
  final startTime = DateTime.now();
  
  final results = Benchmark.runAllBenchmarks();
  
  final endTime = DateTime.now();
  final totalTime = endTime.difference(startTime).inMicroseconds / 1e6;
  
  Output.printResults(results);
  
  try {
    await Output.saveResultsToJSON(results, totalTime);
  } catch (error) {
    print('Error saving results: $error');
    exit(1);
  }
  
  print('Total execution time: ${totalTime.toStringAsFixed(3)} seconds');
}