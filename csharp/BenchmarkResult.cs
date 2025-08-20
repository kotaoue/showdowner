using System.Text.Json.Serialization;

namespace CSharpBenchmark;

public class BenchmarkResult
{
    [JsonPropertyName("test")]
    public string Test { get; set; } = string.Empty;
    
    [JsonPropertyName("duration_ns")]
    public long DurationNs { get; set; }
    
    [JsonPropertyName("memory_bytes")]
    public long MemoryBytes { get; set; }
    
    [JsonPropertyName("operations")]
    public long Operations { get; set; }
    
    [JsonPropertyName("ops_per_sec")]
    public double OpsPerSec { get; set; }

    public BenchmarkResult() { }

    public BenchmarkResult(string test, long durationNs, long memoryBytes, long operations, double opsPerSec)
    {
        Test = test;
        DurationNs = durationNs;
        MemoryBytes = memoryBytes;
        Operations = operations;
        OpsPerSec = opsPerSec;
    }
}