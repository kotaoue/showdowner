#!/usr/bin/env python3

import time
import random
import hashlib
import math

def run_all_benchmarks():
    results = []
    
    print("Running CPU-intensive benchmarks...")
    results.append(benchmark_prime_numbers())
    results.append(benchmark_matrix_multiplication())
    results.append(benchmark_cryptographic_hashing())
    results.append(benchmark_math_operations())
    
    print("Running memory-intensive benchmarks...")
    results.append(benchmark_large_array_sort())
    results.append(benchmark_memory_allocation())
    results.append(benchmark_string_concatenation())
    
    return results

def benchmark_prime_numbers():
    start = time.time()
    
    count = 0
    limit = 100000
    for i in range(2, limit + 1):
        if is_prime(i):
            count += 1
    
    duration = time.time() - start
    
    return {
        'test': 'Prime Numbers (up to 100k)',
        'duration_ns': int(duration * 1e9),
        'memory_bytes': 0,  # Python3では正確なメモリ測定が困難
        'operations': count,
        'ops_per_sec': count / duration
    }

def is_prime(n):
    if n < 2:
        return False
    for i in range(2, int(math.sqrt(n)) + 1):
        if n % i == 0:
            return False
    return True

def benchmark_matrix_multiplication():
    start = time.time()
    
    size = 500
    a = [[random.random() for _ in range(size)] for _ in range(size)]
    b = [[random.random() for _ in range(size)] for _ in range(size)]
    c = [[0.0 for _ in range(size)] for _ in range(size)]
    
    for i in range(size):
        for j in range(size):
            for k in range(size):
                c[i][j] += a[i][k] * b[k][j]
    
    duration = time.time() - start
    operations = size * size * size
    
    return {
        'test': 'Matrix Multiplication (500x500)',
        'duration_ns': int(duration * 1e9),
        'memory_bytes': 0,
        'operations': operations,
        'ops_per_sec': operations / duration
    }

def benchmark_cryptographic_hashing():
    start = time.time()
    
    data = bytes([random.randint(0, 255) for _ in range(1024)])
    
    iterations = 50000
    for _ in range(iterations):
        hashlib.sha256(data).hexdigest()
    
    duration = time.time() - start
    
    return {
        'test': 'SHA256 Hashing (50k iterations)',
        'duration_ns': int(duration * 1e9),
        'memory_bytes': 0,
        'operations': iterations,
        'ops_per_sec': iterations / duration
    }

def benchmark_math_operations():
    start = time.time()
    
    iterations = 10000000
    result = 0.0
    for i in range(iterations):
        x = float(i)
        result += math.sin(x) * math.cos(x) * math.sqrt(x + 1)
    
    duration = time.time() - start
    
    return {
        'test': 'Math Operations (10M iterations)',
        'duration_ns': int(duration * 1e9),
        'memory_bytes': 0,
        'operations': iterations,
        'ops_per_sec': iterations / duration
    }

def benchmark_large_array_sort():
    start = time.time()
    
    size = 1000000
    data = [random.randint(0, 1000000) for _ in range(size)]
    data.sort()
    
    duration = time.time() - start
    
    return {
        'test': 'Large Array Sort (1M elements)',
        'duration_ns': int(duration * 1e9),
        'memory_bytes': 0,
        'operations': size,
        'ops_per_sec': size / duration
    }

def benchmark_memory_allocation():
    start = time.time()
    
    allocations = 100000
    slices = []
    
    for i in range(allocations):
        slice_data = [i % 256] * 256  # 1KB相当のデータ
        slices.append(slice_data)
    
    duration = time.time() - start
    
    return {
        'test': 'Memory Allocation (100k x 1KB)',
        'duration_ns': int(duration * 1e9),
        'memory_bytes': 0,
        'operations': allocations,
        'ops_per_sec': allocations / duration
    }

def benchmark_string_concatenation():
    start = time.time()
    
    iterations = 50000
    result = ""
    for i in range(iterations):
        result += f"iteration_{i}_"
    
    duration = time.time() - start
    
    return {
        'test': 'String Concatenation (50k iterations)',
        'duration_ns': int(duration * 1e9),
        'memory_bytes': 0,
        'operations': iterations,
        'ops_per_sec': iterations / duration
    }