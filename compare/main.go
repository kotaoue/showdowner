package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"time"
)

type BenchmarkResult struct {
	Test        string  `json:"test"`
	DurationNs  int64   `json:"duration_ns"`
	MemoryBytes int64   `json:"memory_bytes"`
	Operations  int64   `json:"operations"`
	OpsPerSec   float64 `json:"ops_per_sec"`
	Error       string  `json:"error,omitempty"`
}

type BenchmarkReport struct {
	Language        string            `json:"language"`
	Timestamp       string            `json:"timestamp"`
	Version         string            `json:"go_version,omitempty"`
	PHPVersion      string            `json:"php_version,omitempty"`
	System          SystemInfo        `json:"system"`
	Tests           []BenchmarkResult `json:"tests"`
	TotalTimeSeconds float64          `json:"total_time_seconds"`
}

type SystemInfo struct {
	OS   string `json:"os"`
	Arch string `json:"arch"`
	CPUs int    `json:"cpus"`
}

type TestComparison struct {
	Test     string                    `json:"test"`
	Results  map[string]TestResult     `json:"results"`
	Fastest  string                    `json:"fastest"`
}

type TestResult struct {
	DurationMs  float64 `json:"duration_ms"`
	MemoryBytes int64   `json:"memory_bytes"`
	OpsPerSec   float64 `json:"ops_per_sec"`
	SpeedRatio  float64 `json:"speed_ratio"`
}

type Comparison struct {
	Timestamp       string                    `json:"timestamp"`
	Languages       map[string]LanguageInfo   `json:"languages"`
	TestComparisons []TestComparison          `json:"test_comparisons"`
	Summary         Summary                   `json:"summary"`
}

type LanguageInfo struct {
	TotalTime float64    `json:"total_time"`
	Version   string     `json:"version"`
	System    SystemInfo `json:"system"`
}

type Summary struct {
	FastestOverall   string             `json:"fastest_overall"`
	SlowestOverall   string             `json:"slowest_overall"`
	SpeedDifference  float64            `json:"speed_difference"`
	TotalTimes       map[string]float64 `json:"total_times"`
}

func findBenchmarkFiles() ([]string, error) {
	patterns := []string{
		"../go/benchmark_*.json", 
		"../php/benchmark_*.json", 
		"../python3/benchmark_*.json", 
		"../rust/benchmark_*.json", 
		"../javascript/benchmark_*.json",
		"../typescript/benchmark_*.json",
		"../java/benchmark_*.json",
		"../kotlin/benchmark_*.json",
		"../cpp/benchmark_*.json",
		"../ruby/benchmark_*.json",
		"../c/benchmark_*.json",
		"../csharp/benchmark_*.json",
	}
	var files []string
	
	for _, pattern := range patterns {
		matches, err := filepath.Glob(pattern)
		if err != nil {
			return nil, fmt.Errorf("error matching pattern %s: %v", pattern, err)
		}
		
		if len(matches) > 0 {
			// 最新ファイルを取得
			sort.Slice(matches, func(i, j int) bool {
				info1, _ := os.Stat(matches[i])
				info2, _ := os.Stat(matches[j])
				return info1.ModTime().After(info2.ModTime())
			})
			files = append(files, matches[0])
		}
	}
	
	return files, nil
}

func loadBenchmarkData(filename string) (*BenchmarkReport, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to read file %s: %v", filename, err)
	}
	
	var report BenchmarkReport
	if err := json.Unmarshal(data, &report); err != nil {
		return nil, fmt.Errorf("failed to parse JSON %s: %v", filename, err)
	}
	
	return &report, nil
}

func compareResults(reports []*BenchmarkReport) *Comparison {
	if len(reports) == 0 {
		return nil
	}
	
	comparison := &Comparison{
		Timestamp:       time.Now().Format(time.RFC3339),
		Languages:       make(map[string]LanguageInfo),
		TestComparisons: []TestComparison{},
		Summary: Summary{
			TotalTimes: make(map[string]float64),
		},
	}
	
	// 言語情報収集
	for _, report := range reports {
		version := report.Version
		if report.PHPVersion != "" {
			version = report.PHPVersion
		}
		
		comparison.Languages[report.Language] = LanguageInfo{
			TotalTime: report.TotalTimeSeconds,
			Version:   version,
			System:    report.System,
		}
		comparison.Summary.TotalTimes[report.Language] = report.TotalTimeSeconds
	}
	
	// テスト名収集
	testNames := make(map[string]bool)
	for _, report := range reports {
		for _, test := range report.Tests {
			testNames[test.Test] = true
		}
	}
	
	// テスト別比較
	for testName := range testNames {
		testComp := TestComparison{
			Test:    testName,
			Results: make(map[string]TestResult),
		}
		
		var fastestTime float64 = -1
		var fastest string
		
		for _, report := range reports {
			for _, test := range report.Tests {
				if test.Test == testName {
					// エラーがある場合は計測対象外として処理
					if test.Error != "" || test.DurationNs < 0 {
						testComp.Results[report.Language] = TestResult{
							DurationMs:  -1,
							MemoryBytes: -1,
							OpsPerSec:   -1,
							SpeedRatio:  -1,
						}
					} else {
						durationMs := float64(test.DurationNs) / 1e6
						testComp.Results[report.Language] = TestResult{
							DurationMs:  durationMs,
							MemoryBytes: test.MemoryBytes,
							OpsPerSec:   test.OpsPerSec,
						}
						
						if fastestTime < 0 || durationMs < fastestTime {
							fastestTime = durationMs
							fastest = report.Language
						}
					}
					break
				}
			}
		}
		
		// 速度比率計算
		if fastest != "" {
			for lang, result := range testComp.Results {
				result.SpeedRatio = result.DurationMs / fastestTime
				testComp.Results[lang] = result
			}
			testComp.Fastest = fastest
		}
		
		comparison.TestComparisons = append(comparison.TestComparisons, testComp)
	}
	
	// 全体サマリー
	var minTime, maxTime float64 = -1, -1
	for lang, time := range comparison.Summary.TotalTimes {
		if minTime < 0 || time < minTime {
			minTime = time
			comparison.Summary.FastestOverall = lang
		}
		if maxTime < 0 || time > maxTime {
			maxTime = time
			comparison.Summary.SlowestOverall = lang
		}
	}
	
	if minTime > 0 {
		comparison.Summary.SpeedDifference = maxTime / minTime
	}
	
	return comparison
}

func printComparison(comp *Comparison) {
	if comp == nil {
		fmt.Println("No comparison data available")
		return
	}
	
	fmt.Println("\n=== LANGUAGE PERFORMANCE COMPARISON ===")
	fmt.Printf("Generated: %s\n\n", comp.Timestamp)
	
	// 全体結果
	fmt.Println("## Overall Results")
	minTime := comp.Summary.TotalTimes[comp.Summary.FastestOverall]
	
	// 言語を速度順にソート
	type LangTime struct {
		Lang string
		Time float64
	}
	
	var langTimes []LangTime
	for lang, time := range comp.Summary.TotalTimes {
		langTimes = append(langTimes, LangTime{Lang: lang, Time: time})
	}
	
	sort.Slice(langTimes, func(i, j int) bool {
		return langTimes[i].Time < langTimes[j].Time
	})
	
	for _, lt := range langTimes {
		ratio := lt.Time / minTime
		fmt.Printf("%-10s: %.3fs (×%.2f)\n", 
			capitalize(lt.Lang), lt.Time, ratio)
	}
	
	fmt.Printf("\nFastest: %s\n", capitalize(comp.Summary.FastestOverall))
	fmt.Printf("Speed difference: ×%.2f\n\n", comp.Summary.SpeedDifference)
	
	// テスト別比較
	fmt.Println("## Test-by-Test Comparison")
	for _, test := range comp.TestComparisons {
		fmt.Printf("\n### %s\n", test.Test)
		fmt.Printf("Fastest: %s\n", capitalize(test.Fastest))
		
		// 結果を速度順にソート（計測不可は最下位）
		type LangResult struct {
			Lang   string
			Result TestResult
		}
		
		var langResults []LangResult
		for lang, result := range test.Results {
			langResults = append(langResults, LangResult{Lang: lang, Result: result})
		}
		
		// ソート: 計測不可(-1)は最下位、それ以外は速度順
		sort.Slice(langResults, func(i, j int) bool {
			a, b := langResults[i].Result, langResults[j].Result
			if a.DurationMs < 0 && b.DurationMs < 0 {
				return false // 両方計測不可の場合は順序維持
			}
			if a.DurationMs < 0 {
				return false // aが計測不可の場合はbより後
			}
			if b.DurationMs < 0 {
				return true // bが計測不可の場合はaより前
			}
			return a.DurationMs < b.DurationMs // 通常の速度比較
		})
		
		for _, lr := range langResults {
			if lr.Result.DurationMs < 0 {
				fmt.Printf("%-10s: %s\n", capitalize(lr.Lang), "計測対象外 (メモリ不足)")
			} else {
				fmt.Printf("%-10s: %8.2fms (×%.2f) | %10d bytes | %12.0f ops/sec\n",
					capitalize(lr.Lang),
					lr.Result.DurationMs,
					lr.Result.SpeedRatio,
					lr.Result.MemoryBytes,
					lr.Result.OpsPerSec,
				)
			}
		}
	}
}

func saveComparisonToJSON(comp *Comparison) (string, error) {
	filename := fmt.Sprintf("../comparison_%s.json", time.Now().Format("20060102_150405"))
	
	jsonData, err := json.MarshalIndent(comp, "", "  ")
	if err != nil {
		return "", fmt.Errorf("failed to encode JSON: %v", err)
	}
	
	if err := os.WriteFile(filename, jsonData, 0644); err != nil {
		return "", fmt.Errorf("failed to write file: %v", err)
	}
	
	fmt.Printf("\nComparison saved to: %s\n", filename)
	return filename, nil
}

func capitalize(s string) string {
	if len(s) == 0 {
		return s
	}
	return string(s[0]-32) + s[1:]
}

func main() {
	files, err := findBenchmarkFiles()
	if err != nil {
		fmt.Printf("Error finding benchmark files: %v\n", err)
		os.Exit(1)
	}
	
	if len(files) == 0 {
		fmt.Println("No benchmark files found. Please run benchmarks first:")
		fmt.Println("  make go")
		fmt.Println("  make php")
		os.Exit(1)
	}
	
	fmt.Println("Found benchmark files:")
	for _, file := range files {
		fmt.Printf("  %s\n", file)
	}
	
	var reports []*BenchmarkReport
	for _, file := range files {
		report, err := loadBenchmarkData(file)
		if err != nil {
			fmt.Printf("Error loading %s: %v\n", file, err)
			continue
		}
		reports = append(reports, report)
	}
	
	if len(reports) == 0 {
		fmt.Println("No valid benchmark data found")
		os.Exit(1)
	}
	
	comparison := compareResults(reports)
	printComparison(comparison)
	
	_, err = saveComparisonToJSON(comparison)
	if err != nil {
		fmt.Printf("Error saving comparison: %v\n", err)
		os.Exit(1)
	}
}