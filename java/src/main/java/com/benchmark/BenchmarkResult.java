package com.benchmark;

public class BenchmarkResult {
    private String test;
    private long durationNs;
    private long memoryBytes;
    private long operations;
    private double opsPerSec;
    
    public BenchmarkResult(String test, long durationNs, long memoryBytes, long operations, double opsPerSec) {
        this.test = test;
        this.durationNs = durationNs;
        this.memoryBytes = memoryBytes;
        this.operations = operations;
        this.opsPerSec = opsPerSec;
    }
    
    // Getters
    public String getTest() { return test; }
    public long getDurationNs() { return durationNs; }
    public long getMemoryBytes() { return memoryBytes; }
    public long getOperations() { return operations; }
    public double getOpsPerSec() { return opsPerSec; }
    
    // Setters
    public void setTest(String test) { this.test = test; }
    public void setDurationNs(long durationNs) { this.durationNs = durationNs; }
    public void setMemoryBytes(long memoryBytes) { this.memoryBytes = memoryBytes; }
    public void setOperations(long operations) { this.operations = operations; }
    public void setOpsPerSec(double opsPerSec) { this.opsPerSec = opsPerSec; }
}