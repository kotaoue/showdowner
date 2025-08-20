using System.Runtime.InteropServices;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace CSharpBenchmark;

public class SystemInfo
{
    [JsonPropertyName("os")]
    public string Os { get; set; } = string.Empty;
    
    [JsonPropertyName("arch")]
    public string Arch { get; set; } = string.Empty;
    
    [JsonPropertyName("cpus")]
    public int Cpus { get; set; }
}

public class BenchmarkReport
{
    [JsonPropertyName("language")]
    public string Language { get; set; } = "csharp";
    
    [JsonPropertyName("timestamp")]
    public string Timestamp { get; set; } = string.Empty;
    
    [JsonPropertyName("dotnet_version")]
    public string DotnetVersion { get; set; } = string.Empty;
    
    [JsonPropertyName("runtime_version")]
    public string RuntimeVersion { get; set; } = string.Empty;
    
    [JsonPropertyName("system")]
    public SystemInfo System { get; set; } = new();
    
    [JsonPropertyName("tests")]
    public List<BenchmarkResult> Tests { get; set; } = new();
    
    [JsonPropertyName("total_time_seconds")]
    public double TotalTimeSeconds { get; set; }
}

public static class Output
{
    public static void PrintResults(List<BenchmarkResult> results)
    {
        Console.WriteLine("\n=== BENCHMARK RESULTS ===");
        foreach (var result in results)
        {
            Console.WriteLine($"Test: {result.Test}");
            Console.WriteLine($"  Duration: {result.DurationNs} ns");
            Console.WriteLine($"  Memory: {result.MemoryBytes} bytes");
            Console.WriteLine($"  Operations: {result.Operations}");
            Console.WriteLine($"  Ops/sec: {result.OpsPerSec:F2}");
            Console.WriteLine();
        }
    }
    
    public static void SaveResultsToJson(List<BenchmarkResult> results, double totalTime)
    {
        var report = new BenchmarkReport
        {
            Timestamp = DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss"),
            DotnetVersion = Environment.Version.ToString(),
            RuntimeVersion = RuntimeInformation.FrameworkDescription,
            System = new SystemInfo
            {
                Os = GetOsName(),
                Arch = RuntimeInformation.OSArchitecture.ToString(),
                Cpus = Environment.ProcessorCount
            },
            Tests = results,
            TotalTimeSeconds = totalTime
        };
        
        var timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
        var filename = $"benchmark_csharp_{timestamp}.json";
        
        try
        {
            var options = new JsonSerializerOptions
            {
                WriteIndented = true
            };
            
            var json = JsonSerializer.Serialize(report, options);
            File.WriteAllText(filename, json);
            Console.WriteLine($"Results saved to: {filename}");
        }
        catch (Exception e)
        {
            throw new InvalidOperationException($"Error writing file: {e.Message}", e);
        }
    }
    
    private static string GetOsName()
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            return "Windows";
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            return "Linux";
        if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            return "macOS";
        return "Unknown";
    }
}