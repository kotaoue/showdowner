using System.Diagnostics;
using CSharpBenchmark;

var stopwatch = Stopwatch.StartNew();

var results = Benchmark.RunAllBenchmarks();

stopwatch.Stop();
var totalTime = stopwatch.Elapsed.TotalSeconds;

Output.PrintResults(results);

try
{
    Output.SaveResultsToJson(results, totalTime);
}
catch (Exception e)
{
    Console.Error.WriteLine($"Error saving results: {e.Message}");
    Environment.Exit(1);
}

Console.WriteLine($"Total execution time: {totalTime:F3} seconds");