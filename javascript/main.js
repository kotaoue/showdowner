#!/usr/bin/env node

const benchmark = require('./benchmark');
const output = require('./output');

function main() {
    const startTime = process.hrtime.bigint();
    
    const results = benchmark.runAllBenchmarks();
    const totalTime = Number(process.hrtime.bigint() - startTime) / 1e9;
    
    output.printResults(results);
    
    try {
        output.saveResultsToJSON(results, totalTime);
    } catch (error) {
        console.error(`Error saving results: ${error.message}`);
        process.exit(1);
    }
    
    console.log(`Total execution time: ${totalTime.toFixed(3)} seconds`);
}

if (require.main === module) {
    main();
}