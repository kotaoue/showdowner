#!/usr/bin/env node

import { runAllBenchmarks } from './benchmark';
import { printResults, saveResultsToJSON } from './output';

function main(): void {
    const startTime = process.hrtime.bigint();
    
    const results = runAllBenchmarks();
    const totalTime = Number(process.hrtime.bigint() - startTime) / 1e9;
    
    printResults(results);
    
    try {
        saveResultsToJSON(results, totalTime);
    } catch (error) {
        console.error(`Error saving results: ${(error as Error).message}`);
        process.exit(1);
    }
    
    console.log(`Total execution time: ${totalTime.toFixed(3)} seconds`);
}

if (require.main === module) {
    main();
}