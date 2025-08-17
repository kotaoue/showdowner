package main

import (
	"encoding/json"
	"fmt"
	"os"
	"runtime"
	"time"
)

type BenchmarkResult struct {
	Test        string        `json:"test"`                    // テスト名
	Duration    time.Duration `json:"duration_ns"`             // 実行時間(ナノ秒)
	MemoryUsed  int64         `json:"memory_bytes"`            // メモリ使用量(バイト)
	Operations  int64         `json:"operations"`              // 処理回数
	OpsPerSec   float64       `json:"ops_per_sec"`             // 1秒あたりの処理回数
}

type BenchmarkReport struct {
	Language    string            `json:"language"`              // 言語名
	Timestamp   string            `json:"timestamp"`             // 実行時刻
	GoVersion   string            `json:"go_version"`            // Goのバージョン
	System      SystemInfo        `json:"system"`                // システム情報
	Tests       []BenchmarkResult `json:"tests"`                 // ベンチマーク結果
	TotalTime   float64           `json:"total_time_seconds"`    // 総実行時間(秒)
}

type SystemInfo struct {
	OS       string `json:"os"`                                 // OS名
	Arch     string `json:"arch"`                               // アーキテクチャ
	CPUs     int    `json:"cpus"`                               // CPU数
}

func PrintResults(results []BenchmarkResult) {
	fmt.Println("\n=== BENCHMARK RESULTS ===")
	for _, result := range results {
		fmt.Printf("Test: %s\n", result.Test)
		fmt.Printf("  Duration: %v\n", result.Duration)
		fmt.Printf("  Memory: %d bytes\n", result.MemoryUsed)
		fmt.Printf("  Operations: %d\n", result.Operations)
		fmt.Printf("  Ops/sec: %.2f\n", result.OpsPerSec)
		fmt.Println()
	}
}

func SaveResultsToJSON(results []BenchmarkResult, totalTime time.Duration) error {
	report := BenchmarkReport{
		Language:    "go",
		Timestamp:   time.Now().Format("2006-01-02T15:04:05Z07:00"),
		GoVersion:   runtime.Version(),
		System: SystemInfo{
			OS:   runtime.GOOS,
			Arch: runtime.GOARCH,
			CPUs: runtime.NumCPU(),
		},
		Tests:     results,
		TotalTime: totalTime.Seconds(),
	}
	
	jsonData, err := json.MarshalIndent(report, "", "  ")
	if err != nil {
		return fmt.Errorf("error marshaling JSON: %v", err)
	}
	
	filename := fmt.Sprintf("benchmark_go_%s.json", time.Now().Format("20060102_150405"))
	err = os.WriteFile(filename, jsonData, 0644)
	if err != nil {
		return fmt.Errorf("error writing file: %v", err)
	}
	
	fmt.Printf("Results saved to: %s\n", filename)
	return nil
}