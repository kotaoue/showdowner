package com.benchmark;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class Output {
    
    public static void printResults(List<BenchmarkResult> results) {
        System.out.println("\n=== BENCHMARK RESULTS ===");
        for (BenchmarkResult result : results) {
            System.out.println("Test: " + result.getTest());
            System.out.println("  Duration: " + result.getDurationNs() + " ns");
            System.out.println("  Memory: " + result.getMemoryBytes() + " bytes");
            System.out.println("  Operations: " + result.getOperations());
            System.out.printf("  Ops/sec: %.2f%n", result.getOpsPerSec());
            System.out.println();
        }
    }
    
    public static void saveResultsToJSON(List<BenchmarkResult> results, double totalTime) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode report = mapper.createObjectNode();
        
        // 基本情報
        report.put("language", "java");
        report.put("timestamp", LocalDateTime.now().toString());
        report.put("java_version", System.getProperty("java.version"));
        report.put("jvm_name", System.getProperty("java.vm.name"));
        report.put("jvm_version", System.getProperty("java.vm.version"));
        
        // システム情報
        ObjectNode system = mapper.createObjectNode();
        system.put("os", System.getProperty("os.name"));
        system.put("arch", System.getProperty("os.arch"));
        system.put("cpus", Runtime.getRuntime().availableProcessors());
        report.set("system", system);
        
        // テスト結果
        ArrayNode tests = mapper.createArrayNode();
        for (BenchmarkResult result : results) {
            ObjectNode test = mapper.createObjectNode();
            test.put("test", result.getTest());
            test.put("duration_ns", result.getDurationNs());
            test.put("memory_bytes", result.getMemoryBytes());
            test.put("operations", result.getOperations());
            test.put("ops_per_sec", result.getOpsPerSec());
            tests.add(test);
        }
        report.set("tests", tests);
        
        // 総実行時間
        report.put("total_time_seconds", totalTime);
        
        // ファイル名生成
        String timestamp = LocalDateTime.now()
            .format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String filename = "benchmark_java_" + timestamp + ".json";
        
        try {
            mapper.writerWithDefaultPrettyPrinter().writeValue(new File(filename), report);
            System.out.println("Results saved to: " + filename);
        } catch (IOException e) {
            throw new IOException("Error writing file: " + e.getMessage(), e);
        }
    }
}