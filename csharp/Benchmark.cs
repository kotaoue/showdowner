using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;

namespace CSharpBenchmark;

public static class Benchmark
{
    public static List<BenchmarkResult> RunAllBenchmarks()
    {
        var results = new List<BenchmarkResult>();
        
        Console.WriteLine("Running CPU-intensive benchmarks...");
        results.Add(BenchmarkPrimeNumbers());
        results.Add(BenchmarkMatrixMultiplication());
        results.Add(BenchmarkCryptographicHashing());
        results.Add(BenchmarkMathOperations());
        
        Console.WriteLine("Running memory-intensive benchmarks...");
        results.Add(BenchmarkLargeArraySort());
        results.Add(BenchmarkMemoryAllocation());
        results.Add(BenchmarkStringConcatenation());
        
        return results;
    }
    
    private static BenchmarkResult BenchmarkPrimeNumbers()
    {
        var stopwatch = Stopwatch.StartNew();
        
        var count = 0;
        const int limit = 100000;
        for (var i = 2; i <= limit; i++)
        {
            if (IsPrime(i))
            {
                count++;
            }
        }
        
        stopwatch.Stop();
        var durationSeconds = stopwatch.Elapsed.TotalSeconds;
        
        return new BenchmarkResult(
            "Prime Numbers (up to 100k)",
            stopwatch.ElapsedTicks * 100, // Ticksをナノ秒に変換
            0, // C#では正確なメモリ測定が困難
            count,
            count / durationSeconds
        );
    }
    
    private static bool IsPrime(int n)
    {
        if (n < 2) return false;
        for (var i = 2; i <= Math.Sqrt(n); i++)
        {
            if (n % i == 0) return false;
        }
        return true;
    }
    
    private static BenchmarkResult BenchmarkMatrixMultiplication()
    {
        var stopwatch = Stopwatch.StartNew();
        
        const int size = 500;
        var random = new Random(42); // 再現可能性のためのシード
        
        var a = new double[size, size];
        var b = new double[size, size];
        var c = new double[size, size];
        
        // 行列初期化
        for (var i = 0; i < size; i++)
        {
            for (var j = 0; j < size; j++)
            {
                a[i, j] = random.NextDouble();
                b[i, j] = random.NextDouble();
            }
        }
        
        // 行列乗算
        for (var i = 0; i < size; i++)
        {
            for (var j = 0; j < size; j++)
            {
                for (var k = 0; k < size; k++)
                {
                    c[i, j] += a[i, k] * b[k, j];
                }
            }
        }
        
        stopwatch.Stop();
        var durationSeconds = stopwatch.Elapsed.TotalSeconds;
        var operations = (long)size * size * size;
        
        return new BenchmarkResult(
            "Matrix Multiplication (500x500)",
            stopwatch.ElapsedTicks * 100,
            0,
            operations,
            operations / durationSeconds
        );
    }
    
    private static BenchmarkResult BenchmarkCryptographicHashing()
    {
        var stopwatch = Stopwatch.StartNew();
        
        var data = new byte[1024];
        var random = new Random(42);
        random.NextBytes(data);
        
        const int iterations = 50000;
        using var sha256 = SHA256.Create();
        
        for (var i = 0; i < iterations; i++)
        {
            sha256.ComputeHash(data);
        }
        
        stopwatch.Stop();
        var durationSeconds = stopwatch.Elapsed.TotalSeconds;
        
        return new BenchmarkResult(
            "SHA256 Hashing (50k iterations)",
            stopwatch.ElapsedTicks * 100,
            0,
            iterations,
            iterations / durationSeconds
        );
    }
    
    private static BenchmarkResult BenchmarkMathOperations()
    {
        var stopwatch = Stopwatch.StartNew();
        
        const int iterations = 10000000;
        var result = 0.0;
        for (var i = 0; i < iterations; i++)
        {
            var x = (double)i;
            result += Math.Sin(x) * Math.Cos(x) * Math.Sqrt(x + 1);
        }
        
        stopwatch.Stop();
        var durationSeconds = stopwatch.Elapsed.TotalSeconds;
        
        // resultを使用して最適化を防ぐ
        if (double.IsNaN(result))
        {
            Console.WriteLine("Unexpected NaN result");
        }
        
        return new BenchmarkResult(
            "Math Operations (10M iterations)",
            stopwatch.ElapsedTicks * 100,
            0,
            iterations,
            iterations / durationSeconds
        );
    }
    
    private static BenchmarkResult BenchmarkLargeArraySort()
    {
        var stopwatch = Stopwatch.StartNew();
        
        const int size = 1000000;
        var random = new Random(42);
        var data = new int[size];
        
        for (var i = 0; i < size; i++)
        {
            data[i] = random.Next(1000001);
        }
        
        Array.Sort(data);
        
        stopwatch.Stop();
        var durationSeconds = stopwatch.Elapsed.TotalSeconds;
        
        return new BenchmarkResult(
            "Large Array Sort (1M elements)",
            stopwatch.ElapsedTicks * 100,
            0,
            size,
            size / durationSeconds
        );
    }
    
    private static BenchmarkResult BenchmarkMemoryAllocation()
    {
        var stopwatch = Stopwatch.StartNew();
        
        const int allocations = 100000;
        var arrays = new List<int[]>(allocations);
        
        for (var i = 0; i < allocations; i++)
        {
            var data = new int[256]; // 1KB相当のデータ
            Array.Fill(data, i % 256);
            arrays.Add(data);
        }
        
        stopwatch.Stop();
        var durationSeconds = stopwatch.Elapsed.TotalSeconds;
        
        return new BenchmarkResult(
            "Memory Allocation (100k x 1KB)",
            stopwatch.ElapsedTicks * 100,
            0,
            allocations,
            allocations / durationSeconds
        );
    }
    
    private static BenchmarkResult BenchmarkStringConcatenation()
    {
        var stopwatch = Stopwatch.StartNew();
        
        const int iterations = 50000;
        var result = new StringBuilder();
        for (var i = 0; i < iterations; i++)
        {
            result.Append($"iteration_{i}_");
        }
        
        stopwatch.Stop();
        var durationSeconds = stopwatch.Elapsed.TotalSeconds;
        
        return new BenchmarkResult(
            "String Concatenation (50k iterations)",
            stopwatch.ElapsedTicks * 100,
            0,
            iterations,
            iterations / durationSeconds
        );
    }
}