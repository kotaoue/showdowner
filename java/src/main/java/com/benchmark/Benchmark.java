package com.benchmark;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class Benchmark {
    
    public static List<BenchmarkResult> runAllBenchmarks() {
        List<BenchmarkResult> results = new ArrayList<>();
        
        System.out.println("Running CPU-intensive benchmarks...");
        results.add(benchmarkPrimeNumbers());
        results.add(benchmarkMatrixMultiplication());
        results.add(benchmarkCryptographicHashing());
        results.add(benchmarkMathOperations());
        
        System.out.println("Running memory-intensive benchmarks...");
        results.add(benchmarkLargeArraySort());
        results.add(benchmarkMemoryAllocation());
        results.add(benchmarkStringConcatenation());
        
        return results;
    }
    
    private static BenchmarkResult benchmarkPrimeNumbers() {
        long start = System.nanoTime();
        
        int count = 0;
        int limit = 100000;
        for (int i = 2; i <= limit; i++) {
            if (isPrime(i)) {
                count++;
            }
        }
        
        long duration = System.nanoTime() - start;
        double durationSeconds = duration / 1e9;
        
        return new BenchmarkResult(
            "Prime Numbers (up to 100k)",
            duration,
            0, // Javaでは正確なメモリ測定が困難
            count,
            count / durationSeconds
        );
    }
    
    private static boolean isPrime(int n) {
        if (n < 2) return false;
        for (int i = 2; i <= Math.sqrt(n); i++) {
            if (n % i == 0) return false;
        }
        return true;
    }
    
    private static BenchmarkResult benchmarkMatrixMultiplication() {
        long start = System.nanoTime();
        
        int size = 500;
        Random random = new Random(42); // 再現可能性のためのシード
        double[][] a = new double[size][size];
        double[][] b = new double[size][size];
        double[][] c = new double[size][size];
        
        // 行列初期化
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                a[i][j] = random.nextDouble();
                b[i][j] = random.nextDouble();
            }
        }
        
        // 行列乗算
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                for (int k = 0; k < size; k++) {
                    c[i][j] += a[i][k] * b[k][j];
                }
            }
        }
        
        long duration = System.nanoTime() - start;
        double durationSeconds = duration / 1e9;
        long operations = (long) size * size * size;
        
        return new BenchmarkResult(
            "Matrix Multiplication (500x500)",
            duration,
            0,
            operations,
            operations / durationSeconds
        );
    }
    
    private static BenchmarkResult benchmarkCryptographicHashing() {
        long start = System.nanoTime();
        
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] data = new byte[1024];
            Random random = new Random(42);
            random.nextBytes(data);
            
            int iterations = 50000;
            for (int i = 0; i < iterations; i++) {
                digest.reset();
                digest.update(data);
                digest.digest();
            }
            
            long duration = System.nanoTime() - start;
            double durationSeconds = duration / 1e9;
            
            return new BenchmarkResult(
                "SHA256 Hashing (50k iterations)",
                duration,
                0,
                iterations,
                iterations / durationSeconds
            );
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }
    
    private static BenchmarkResult benchmarkMathOperations() {
        long start = System.nanoTime();
        
        int iterations = 10000000;
        double result = 0.0;
        for (int i = 0; i < iterations; i++) {
            double x = i;
            result += Math.sin(x) * Math.cos(x) * Math.sqrt(x + 1);
        }
        
        long duration = System.nanoTime() - start;
        double durationSeconds = duration / 1e9;
        
        // resultを使用して最適化を防ぐ
        if (Double.isNaN(result)) {
            System.out.println("Unexpected NaN result");
        }
        
        return new BenchmarkResult(
            "Math Operations (10M iterations)",
            duration,
            0,
            iterations,
            iterations / durationSeconds
        );
    }
    
    private static BenchmarkResult benchmarkLargeArraySort() {
        long start = System.nanoTime();
        
        int size = 1000000;
        Integer[] data = new Integer[size];
        Random random = new Random(42);
        for (int i = 0; i < size; i++) {
            data[i] = random.nextInt(1000001);
        }
        
        Arrays.sort(data);
        
        long duration = System.nanoTime() - start;
        double durationSeconds = duration / 1e9;
        
        return new BenchmarkResult(
            "Large Array Sort (1M elements)",
            duration,
            0,
            size,
            size / durationSeconds
        );
    }
    
    private static BenchmarkResult benchmarkMemoryAllocation() {
        long start = System.nanoTime();
        
        int allocations = 100000;
        List<int[]> arrays = new ArrayList<>(allocations);
        
        for (int i = 0; i < allocations; i++) {
            int[] data = new int[256]; // 1KB相当のデータ
            Arrays.fill(data, i % 256);
            arrays.add(data);
        }
        
        long duration = System.nanoTime() - start;
        double durationSeconds = duration / 1e9;
        
        return new BenchmarkResult(
            "Memory Allocation (100k x 1KB)",
            duration,
            0,
            allocations,
            allocations / durationSeconds
        );
    }
    
    private static BenchmarkResult benchmarkStringConcatenation() {
        long start = System.nanoTime();
        
        int iterations = 50000;
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < iterations; i++) {
            result.append("iteration_").append(i).append("_");
        }
        
        long duration = System.nanoTime() - start;
        double durationSeconds = duration / 1e9;
        
        return new BenchmarkResult(
            "String Concatenation (50k iterations)",
            duration,
            0,
            iterations,
            iterations / durationSeconds
        );
    }
}