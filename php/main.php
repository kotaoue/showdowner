<?php

require_once 'benchmark.php';
require_once 'output.php';

$startTime = microtime(true);

$results = runAllBenchmarks();
$totalTime = microtime(true) - $startTime;

printResults($results);

try {
    saveResultsToJSON($results, $totalTime);
} catch (Exception $e) {
    echo "Error saving results: " . $e->getMessage() . "\n";
    exit(1);
}

printf("Total execution time: %.3f seconds\n", $totalTime);