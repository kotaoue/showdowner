use rand::Rng;
use sha2::{Sha256, Digest};
use std::time::Instant;
use crate::output::BenchmarkResult;

pub fn run_all_benchmarks() -> Vec<BenchmarkResult> {
    let mut results = Vec::new();
    
    println!("Running CPU-intensive benchmarks...");
    results.push(benchmark_prime_numbers());
    results.push(benchmark_matrix_multiplication());
    results.push(benchmark_cryptographic_hashing());
    results.push(benchmark_math_operations());
    
    println!("Running memory-intensive benchmarks...");
    results.push(benchmark_large_array_sort());
    results.push(benchmark_memory_allocation());
    results.push(benchmark_string_concatenation());
    
    results
}

fn benchmark_prime_numbers() -> BenchmarkResult {
    let start = Instant::now();
    
    let mut count = 0;
    let limit = 100_000;
    for i in 2..=limit {
        if is_prime(i) {
            count += 1;
        }
    }
    
    let duration = start.elapsed();
    
    BenchmarkResult {
        test: "Prime Numbers (up to 100k)".to_string(),
        duration_ns: duration.as_nanos() as i64,
        memory_bytes: 0,  // Rustでは正確なメモリ測定が困難
        operations: count,
        ops_per_sec: count as f64 / duration.as_secs_f64(),
        error: None,
    }
}

fn is_prime(n: u32) -> bool {
    if n < 2 {
        return false;
    }
    for i in 2..=((n as f64).sqrt() as u32) {
        if n % i == 0 {
            return false;
        }
    }
    true
}

fn benchmark_matrix_multiplication() -> BenchmarkResult {
    let start = Instant::now();
    
    let size = 500;
    let mut rng = rand::thread_rng();
    
    let a: Vec<Vec<f64>> = (0..size)
        .map(|_| (0..size).map(|_| rng.gen::<f64>()).collect())
        .collect();
    
    let b: Vec<Vec<f64>> = (0..size)
        .map(|_| (0..size).map(|_| rng.gen::<f64>()).collect())
        .collect();
    
    let mut c = vec![vec![0.0; size]; size];
    
    for i in 0..size {
        for j in 0..size {
            for k in 0..size {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    
    let duration = start.elapsed();
    let operations = (size * size * size) as i64;
    
    BenchmarkResult {
        test: "Matrix Multiplication (500x500)".to_string(),
        duration_ns: duration.as_nanos() as i64,
        memory_bytes: 0,
        operations,
        ops_per_sec: operations as f64 / duration.as_secs_f64(),
        error: None,
    }
}

fn benchmark_cryptographic_hashing() -> BenchmarkResult {
    let start = Instant::now();
    
    let mut rng = rand::thread_rng();
    let data: Vec<u8> = (0..1024).map(|_| rng.gen::<u8>()).collect();
    
    let iterations = 50_000;
    for _ in 0..iterations {
        let mut hasher = Sha256::new();
        hasher.update(&data);
        let _result = hasher.finalize();
    }
    
    let duration = start.elapsed();
    
    BenchmarkResult {
        test: "SHA256 Hashing (50k iterations)".to_string(),
        duration_ns: duration.as_nanos() as i64,
        memory_bytes: 0,
        operations: iterations,
        ops_per_sec: iterations as f64 / duration.as_secs_f64(),
        error: None,
    }
}

fn benchmark_math_operations() -> BenchmarkResult {
    let start = Instant::now();
    
    let iterations = 10_000_000;
    let mut result = 0.0;
    for i in 0..iterations {
        let x = i as f64;
        result += x.sin() * x.cos() * (x + 1.0).sqrt();
    }
    
    let duration = start.elapsed();
    
    // resultを使用して最適化を防ぐ
    if result.is_nan() {
        println!("Unexpected NaN result");
    }
    
    BenchmarkResult {
        test: "Math Operations (10M iterations)".to_string(),
        duration_ns: duration.as_nanos() as i64,
        memory_bytes: 0,
        operations: iterations,
        ops_per_sec: iterations as f64 / duration.as_secs_f64(),
        error: None,
    }
}

fn benchmark_large_array_sort() -> BenchmarkResult {
    let start = Instant::now();
    
    let size = 1_000_000;
    let mut rng = rand::thread_rng();
    let mut data: Vec<i32> = (0..size).map(|_| rng.gen_range(0..=1_000_000)).collect();
    
    data.sort();
    
    let duration = start.elapsed();
    
    BenchmarkResult {
        test: "Large Array Sort (1M elements)".to_string(),
        duration_ns: duration.as_nanos() as i64,
        memory_bytes: 0,
        operations: size as i64,
        ops_per_sec: size as f64 / duration.as_secs_f64(),
        error: None,
    }
}

fn benchmark_memory_allocation() -> BenchmarkResult {
    let start = Instant::now();
    
    let allocations = 100_000;
    let mut slices = Vec::new();
    
    for i in 0..allocations {
        let slice_data = vec![i % 256; 256]; // 1KB相当のデータ
        slices.push(slice_data);
    }
    
    let duration = start.elapsed();
    
    BenchmarkResult {
        test: "Memory Allocation (100k x 1KB)".to_string(),
        duration_ns: duration.as_nanos() as i64,
        memory_bytes: 0,
        operations: allocations,
        ops_per_sec: allocations as f64 / duration.as_secs_f64(),
        error: None,
    }
}

fn benchmark_string_concatenation() -> BenchmarkResult {
    let start = Instant::now();
    
    let iterations = 50_000;
    let mut result = String::new();
    for i in 0..iterations {
        result.push_str(&format!("iteration_{}_", i));
    }
    
    let duration = start.elapsed();
    
    BenchmarkResult {
        test: "String Concatenation (50k iterations)".to_string(),
        duration_ns: duration.as_nanos() as i64,
        memory_bytes: 0,
        operations: iterations,
        ops_per_sec: iterations as f64 / duration.as_secs_f64(),
        error: None,
    }
}