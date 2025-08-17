const fs = require('fs');
const os = require('os');

function printResults(results) {
    console.log("\n=== BENCHMARK RESULTS ===");
    for (const result of results) {
        console.log(`Test: ${result.test}`);
        
        if (result.error) {
            console.log(`  Status: ${result.error}`);
        } else {
            console.log(`  Duration: ${result.duration_ns} ns`);
            console.log(`  Memory: ${result.memory_bytes} bytes`);
            console.log(`  Operations: ${result.operations}`);
            console.log(`  Ops/sec: ${result.ops_per_sec.toFixed(2)}`);
        }
        console.log();
    }
}

function saveResultsToJSON(results, totalTime) {
    const report = {
        language: 'javascript',                          // 言語名
        timestamp: new Date().toISOString(),             // 実行時刻
        node_version: process.version,                   // Node.jsのバージョン
        system: {
            os: os.platform(),                          // OS名
            arch: os.arch(),                            // アーキテクチャ
            cpus: os.cpus().length                      // CPU数
        },
        tests: results,                                 // ベンチマーク結果
        total_time_seconds: totalTime                   // 総実行時間(秒)
    };
    
    const timestamp = new Date().toISOString()
        .replace(/[:.]/g, '')
        .replace('T', '_')
        .substring(0, 15);
    
    const filename = `benchmark_javascript_${timestamp}.json`;
    
    try {
        fs.writeFileSync(filename, JSON.stringify(report, null, 2));
        console.log(`Results saved to: ${filename}`);
    } catch (error) {
        throw new Error(`Error writing file: ${error.message}`);
    }
}

module.exports = {
    printResults,
    saveResultsToJSON
};