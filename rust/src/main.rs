mod benchmark;
mod output;

use std::time::Instant;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let start_time = Instant::now();
    
    let results = benchmark::run_all_benchmarks();
    let total_time = start_time.elapsed();
    
    output::print_results(&results);
    
    output::save_results_to_json(&results, total_time)?;
    
    println!("Total execution time: {:.3} seconds", total_time.as_secs_f64());
    
    Ok(())
}