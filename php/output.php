<?php

function printResults($results) {
    echo "\n=== BENCHMARK RESULTS ===\n";
    foreach ($results as $result) {
        printf("Test: %s\n", $result['test']);
        printf("  Duration: %d ns\n", $result['duration_ns']);
        printf("  Memory: %d bytes\n", $result['memory_bytes']);
        printf("  Operations: %d\n", $result['operations']);
        printf("  Ops/sec: %.2f\n", $result['ops_per_sec']);
        echo "\n";
    }
}

function saveResultsToJSON($results, $totalTime) {
    $report = [
        'language' => 'php',                          // 言語名
        'timestamp' => date('c'),                     // 実行時刻
        'php_version' => PHP_VERSION,                 // PHPのバージョン
        'system' => [
            'os' => PHP_OS,                          // OS名
            'arch' => php_uname('m'),                // アーキテクチャ
            'cpus' => getProcessorCount()            // CPU数
        ],
        'tests' => $results,                         // ベンチマーク結果
        'total_time_seconds' => $totalTime           // 総実行時間(秒)
    ];
    
    $jsonData = json_encode($report, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    if ($jsonData === false) {
        throw new Exception('Error encoding JSON: ' . json_last_error_msg());
    }
    
    $filename = sprintf('benchmark_php_%s.json', date('Ymd_His'));
    if (file_put_contents($filename, $jsonData) === false) {
        throw new Exception('Error writing file: ' . $filename);
    }
    
    printf("Results saved to: %s\n", $filename);
}

function getProcessorCount() {
    if (function_exists('shell_exec')) {
        // Unix系OS
        $count = shell_exec('nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1');
        return intval(trim($count));
    }
    return 1; // デフォルト値
}