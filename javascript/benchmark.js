const crypto = require('crypto');

function runAllBenchmarks() {
    const results = [];
    
    console.log("Running CPU-intensive benchmarks...");
    results.push(benchmarkPrimeNumbers());
    results.push(benchmarkMatrixMultiplication());
    results.push(benchmarkCryptographicHashing());
    results.push(benchmarkMathOperations());
    
    console.log("Running memory-intensive benchmarks...");
    results.push(benchmarkLargeArraySort());
    results.push(benchmarkMemoryAllocation());
    results.push(benchmarkStringConcatenation());
    
    return results;
}

function benchmarkPrimeNumbers() {
    const start = process.hrtime.bigint();
    
    let count = 0;
    const limit = 100000;
    for (let i = 2; i <= limit; i++) {
        if (isPrime(i)) {
            count++;
        }
    }
    
    const duration = process.hrtime.bigint() - start;
    const durationSeconds = Number(duration) / 1e9;
    
    return {
        test: 'Prime Numbers (up to 100k)',
        duration_ns: Number(duration),
        memory_bytes: 0,  // JavaScriptでは正確なメモリ測定が困難
        operations: count,
        ops_per_sec: count / durationSeconds
    };
}

function isPrime(n) {
    if (n < 2) return false;
    for (let i = 2; i <= Math.sqrt(n); i++) {
        if (n % i === 0) return false;
    }
    return true;
}

function benchmarkMatrixMultiplication() {
    const start = process.hrtime.bigint();
    
    const size = 500;
    const a = Array(size).fill().map(() => Array(size).fill().map(() => Math.random()));
    const b = Array(size).fill().map(() => Array(size).fill().map(() => Math.random()));
    const c = Array(size).fill().map(() => Array(size).fill(0));
    
    for (let i = 0; i < size; i++) {
        for (let j = 0; j < size; j++) {
            for (let k = 0; k < size; k++) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    
    const duration = process.hrtime.bigint() - start;
    const durationSeconds = Number(duration) / 1e9;
    const operations = size * size * size;
    
    return {
        test: 'Matrix Multiplication (500x500)',
        duration_ns: Number(duration),
        memory_bytes: 0,
        operations,
        ops_per_sec: operations / durationSeconds
    };
}

function benchmarkCryptographicHashing() {
    const start = process.hrtime.bigint();
    
    const data = Buffer.alloc(1024);
    for (let i = 0; i < 1024; i++) {
        data[i] = Math.floor(Math.random() * 256);
    }
    
    const iterations = 50000;
    for (let i = 0; i < iterations; i++) {
        crypto.createHash('sha256').update(data).digest('hex');
    }
    
    const duration = process.hrtime.bigint() - start;
    const durationSeconds = Number(duration) / 1e9;
    
    return {
        test: 'SHA256 Hashing (50k iterations)',
        duration_ns: Number(duration),
        memory_bytes: 0,
        operations: iterations,
        ops_per_sec: iterations / durationSeconds
    };
}

function benchmarkMathOperations() {
    const start = process.hrtime.bigint();
    
    const iterations = 10000000;
    let result = 0.0;
    for (let i = 0; i < iterations; i++) {
        const x = i;
        result += Math.sin(x) * Math.cos(x) * Math.sqrt(x + 1);
    }
    
    const duration = process.hrtime.bigint() - start;
    const durationSeconds = Number(duration) / 1e9;
    
    // resultを使用して最適化を防ぐ
    if (isNaN(result)) {
        console.log("Unexpected NaN result");
    }
    
    return {
        test: 'Math Operations (10M iterations)',
        duration_ns: Number(duration),
        memory_bytes: 0,
        operations: iterations,
        ops_per_sec: iterations / durationSeconds
    };
}

function benchmarkLargeArraySort() {
    const start = process.hrtime.bigint();
    
    const size = 1000000;
    const data = Array(size).fill().map(() => Math.floor(Math.random() * 1000001));
    
    data.sort((a, b) => a - b);
    
    const duration = process.hrtime.bigint() - start;
    const durationSeconds = Number(duration) / 1e9;
    
    return {
        test: 'Large Array Sort (1M elements)',
        duration_ns: Number(duration),
        memory_bytes: 0,
        operations: size,
        ops_per_sec: size / durationSeconds
    };
}

function benchmarkMemoryAllocation() {
    const start = process.hrtime.bigint();
    
    const allocations = 100000;
    const slices = [];
    
    for (let i = 0; i < allocations; i++) {
        const sliceData = Array(256).fill(i % 256); // 1KB相当のデータ
        slices.push(sliceData);
    }
    
    const duration = process.hrtime.bigint() - start;
    const durationSeconds = Number(duration) / 1e9;
    
    return {
        test: 'Memory Allocation (100k x 1KB)',
        duration_ns: Number(duration),
        memory_bytes: 0,
        operations: allocations,
        ops_per_sec: allocations / durationSeconds
    };
}

function benchmarkStringConcatenation() {
    const start = process.hrtime.bigint();
    
    const iterations = 50000;
    let result = "";
    for (let i = 0; i < iterations; i++) {
        result += `iteration_${i}_`;
    }
    
    const duration = process.hrtime.bigint() - start;
    const durationSeconds = Number(duration) / 1e9;
    
    return {
        test: 'String Concatenation (50k iterations)',
        duration_ns: Number(duration),
        memory_bytes: 0,
        operations: iterations,
        ops_per_sec: iterations / durationSeconds
    };
}

module.exports = {
    runAllBenchmarks
};