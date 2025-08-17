use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::Write;
use std::time::{Duration, SystemTime, UNIX_EPOCH};

#[derive(Serialize, Deserialize, Clone)]
pub struct BenchmarkResult {
    pub test: String,                    // テスト名
    pub duration_ns: i64,                // 実行時間(ナノ秒)
    pub memory_bytes: i64,               // メモリ使用量(バイト)
    pub operations: i64,                 // 処理回数
    pub ops_per_sec: f64,                // 1秒あたりの処理回数
    pub error: Option<String>,           // エラー情報
}

#[derive(Serialize)]
struct SystemInfo {
    os: String,                          // OS名
    arch: String,                        // アーキテクチャ
    cpus: usize,                         // CPU数
}

#[derive(Serialize)]
struct BenchmarkReport {
    language: String,                    // 言語名
    timestamp: String,                   // 実行時刻
    rust_version: String,                // Rustのバージョン
    system: SystemInfo,                  // システム情報
    tests: Vec<BenchmarkResult>,         // ベンチマーク結果
    total_time_seconds: f64,             // 総実行時間(秒)
}

pub fn print_results(results: &[BenchmarkResult]) {
    println!("\n=== BENCHMARK RESULTS ===");
    for result in results {
        println!("Test: {}", result.test);
        
        if let Some(error) = &result.error {
            println!("  Status: {}", error);
        } else {
            println!("  Duration: {} ns", result.duration_ns);
            println!("  Memory: {} bytes", result.memory_bytes);
            println!("  Operations: {}", result.operations);
            println!("  Ops/sec: {:.2}", result.ops_per_sec);
        }
        println!();
    }
}

pub fn save_results_to_json(results: &[BenchmarkResult], total_time: Duration) -> Result<(), Box<dyn std::error::Error>> {
    let report = BenchmarkReport {
        language: "rust".to_string(),
        timestamp: get_timestamp(),
        rust_version: env!("CARGO_PKG_VERSION").to_string(),
        system: SystemInfo {
            os: std::env::consts::OS.to_string(),
            arch: std::env::consts::ARCH.to_string(),
            cpus: num_cpus::get(),
        },
        tests: results.to_vec(),
        total_time_seconds: total_time.as_secs_f64(),
    };
    
    let filename = format!("benchmark_rust_{}.json", get_timestamp_for_filename());
    let json_data = serde_json::to_string_pretty(&report)?;
    
    let mut file = File::create(&filename)?;
    file.write_all(json_data.as_bytes())?;
    
    println!("Results saved to: {}", filename);
    
    Ok(())
}

fn get_timestamp() -> String {
    let now = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap();
    
    let datetime = chrono::DateTime::<chrono::Utc>::from_timestamp(now.as_secs() as i64, 0)
        .unwrap();
    
    datetime.format("%Y-%m-%dT%H:%M:%S%z").to_string()
}

fn get_timestamp_for_filename() -> String {
    let now = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap();
    
    let datetime = chrono::DateTime::<chrono::Utc>::from_timestamp(now.as_secs() as i64, 0)
        .unwrap();
    
    datetime.format("%Y%m%d_%H%M%S").to_string()
}

// num_cpusクレートが使えない場合の代替実装
#[cfg(not(feature = "num_cpus"))]
mod num_cpus {
    pub fn get() -> usize {
        std::thread::available_parallelism()
            .map(|n| n.get())
            .unwrap_or(1)
    }
}