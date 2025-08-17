<?php

function runAllBenchmarks() {
    $results = [];
    
    echo "Running CPU-intensive benchmarks...\n";
    $results[] = benchmarkPrimeNumbers();
    $results[] = benchmarkMatrixMultiplication();
    $results[] = benchmarkCryptographicHashing();
    $results[] = benchmarkMathOperations();
    
    echo "Running memory-intensive benchmarks...\n";
    $results[] = benchmarkLargeArraySort();
    $results[] = benchmarkMemoryAllocation();
    $results[] = benchmarkStringConcatenation();
    
    return $results;
}

function benchmarkPrimeNumbers() {
    $memBefore = memory_get_usage();
    $start = microtime(true);
    
    $count = 0;
    $limit = 100000;
    for ($i = 2; $i <= $limit; $i++) {
        if (isPrime($i)) {
            $count++;
        }
    }
    
    $duration = microtime(true) - $start;
    $memAfter = memory_get_usage();
    
    return [
        'test' => 'Prime Numbers (up to 100k)',
        'duration_ns' => intval($duration * 1e9),
        'memory_bytes' => $memAfter - $memBefore,
        'operations' => $count,
        'ops_per_sec' => $count / $duration
    ];
}

function isPrime($n) {
    if ($n < 2) return false;
    for ($i = 2; $i <= sqrt($n); $i++) {
        if ($n % $i === 0) return false;
    }
    return true;
}

function benchmarkMatrixMultiplication() {
    $memBefore = memory_get_usage();
    $start = microtime(true);
    
    $size = 500;
    $a = [];
    $b = [];
    $c = [];
    
    // 行列初期化
    for ($i = 0; $i < $size; $i++) {
        $a[$i] = [];
        $b[$i] = [];
        $c[$i] = [];
        for ($j = 0; $j < $size; $j++) {
            $a[$i][$j] = mt_rand() / mt_getrandmax();
            $b[$i][$j] = mt_rand() / mt_getrandmax();
            $c[$i][$j] = 0;
        }
    }
    
    // 行列乗算
    for ($i = 0; $i < $size; $i++) {
        for ($j = 0; $j < $size; $j++) {
            for ($k = 0; $k < $size; $k++) {
                $c[$i][$j] += $a[$i][$k] * $b[$k][$j];
            }
        }
    }
    
    $duration = microtime(true) - $start;
    $memAfter = memory_get_usage();
    $operations = $size * $size * $size;
    
    return [
        'test' => 'Matrix Multiplication (500x500)',
        'duration_ns' => intval($duration * 1e9),
        'memory_bytes' => $memAfter - $memBefore,
        'operations' => $operations,
        'ops_per_sec' => $operations / $duration
    ];
}

function benchmarkCryptographicHashing() {
    $memBefore = memory_get_usage();
    $start = microtime(true);
    
    $data = '';
    for ($i = 0; $i < 1024; $i++) {
        $data .= chr(mt_rand(0, 255));
    }
    
    $iterations = 50000;
    for ($i = 0; $i < $iterations; $i++) {
        hash('sha256', $data);
    }
    
    $duration = microtime(true) - $start;
    $memAfter = memory_get_usage();
    
    return [
        'test' => 'SHA256 Hashing (50k iterations)',
        'duration_ns' => intval($duration * 1e9),
        'memory_bytes' => $memAfter - $memBefore,
        'operations' => $iterations,
        'ops_per_sec' => $iterations / $duration
    ];
}

function benchmarkMathOperations() {
    $memBefore = memory_get_usage();
    $start = microtime(true);
    
    $iterations = 10000000;
    $result = 0.0;
    for ($i = 0; $i < $iterations; $i++) {
        $x = (float)$i;
        $result += sin($x) * cos($x) * sqrt($x + 1);
    }
    
    $duration = microtime(true) - $start;
    $memAfter = memory_get_usage();
    
    return [
        'test' => 'Math Operations (10M iterations)',
        'duration_ns' => intval($duration * 1e9),
        'memory_bytes' => $memAfter - $memBefore,
        'operations' => $iterations,
        'ops_per_sec' => $iterations / $duration
    ];
}

function benchmarkLargeArraySort() {
    $memBefore = memory_get_usage();
    $start = microtime(true);
    
    $size = 1000000;
    $data = [];
    for ($i = 0; $i < $size; $i++) {
        $data[] = mt_rand(0, 1000000);
    }
    
    sort($data);
    
    $duration = microtime(true) - $start;
    $memAfter = memory_get_usage();
    
    return [
        'test' => 'Large Array Sort (1M elements)',
        'duration_ns' => intval($duration * 1e9),
        'memory_bytes' => $memAfter - $memBefore,
        'operations' => $size,
        'ops_per_sec' => $size / $duration
    ];
}

function benchmarkMemoryAllocation() {
    $memBefore = memory_get_usage();
    $start = microtime(true);
    
    $allocations = 10000; // PHPのメモリ制限を考慮して削減
    $slices = [];
    
    for ($i = 0; $i < $allocations; $i++) {
        $slice = [];
        for ($j = 0; $j < 256; $j++) { // 1KB相当のデータ
            $slice[] = $i % 256;
        }
        $slices[] = $slice;
    }
    
    $duration = microtime(true) - $start;
    $memAfter = memory_get_usage();
    
    return [
        'test' => 'Memory Allocation (10k x 1KB)',
        'duration_ns' => intval($duration * 1e9),
        'memory_bytes' => $memAfter - $memBefore,
        'operations' => $allocations,
        'ops_per_sec' => $allocations / $duration
    ];
}

function benchmarkStringConcatenation() {
    $memBefore = memory_get_usage();
    $start = microtime(true);
    
    $iterations = 50000;
    $result = '';
    for ($i = 0; $i < $iterations; $i++) {
        $result .= "iteration_{$i}_";
    }
    
    $duration = microtime(true) - $start;
    $memAfter = memory_get_usage();
    
    return [
        'test' => 'String Concatenation (50k iterations)',
        'duration_ns' => intval($duration * 1e9),
        'memory_bytes' => $memAfter - $memBefore,
        'operations' => $iterations,
        'ops_per_sec' => $iterations / $duration
    ];
}