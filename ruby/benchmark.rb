require 'digest'
require 'json'

class BenchmarkResult
  attr_accessor :test, :duration_ns, :memory_bytes, :operations, :ops_per_sec
  
  def initialize(test, duration_ns, memory_bytes, operations, ops_per_sec)
    @test = test
    @duration_ns = duration_ns
    @memory_bytes = memory_bytes
    @operations = operations
    @ops_per_sec = ops_per_sec
  end
  
  def to_h
    {
      test: @test,
      duration_ns: @duration_ns,
      memory_bytes: @memory_bytes,
      operations: @operations,
      ops_per_sec: @ops_per_sec
    }
  end
end

class Benchmark
  def self.run_all_benchmarks
    results = []
    
    puts "Running CPU-intensive benchmarks..."
    results << benchmark_prime_numbers
    results << benchmark_matrix_multiplication
    results << benchmark_cryptographic_hashing
    results << benchmark_math_operations
    
    puts "Running memory-intensive benchmarks..."
    results << benchmark_large_array_sort
    results << benchmark_memory_allocation
    results << benchmark_string_concatenation
    
    results
  end
  
  private
  
  def self.benchmark_prime_numbers
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
    
    count = 0
    limit = 100000
    (2..limit).each do |i|
      count += 1 if prime?(i)
    end
    
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond) - start_time
    duration_seconds = duration / 1e9
    
    BenchmarkResult.new(
      "Prime Numbers (up to 100k)",
      duration,
      0, # Rubyでは正確なメモリ測定が困難
      count,
      count / duration_seconds
    )
  end
  
  def self.prime?(n)
    return false if n < 2
    (2..Math.sqrt(n)).each do |i|
      return false if n % i == 0
    end
    true
  end
  
  def self.benchmark_matrix_multiplication
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
    
    size = 500
    srand(42) # 再現可能性のためのシード
    
    a = Array.new(size) { Array.new(size) { rand } }
    b = Array.new(size) { Array.new(size) { rand } }
    c = Array.new(size) { Array.new(size, 0.0) }
    
    # 行列乗算
    (0...size).each do |i|
      (0...size).each do |j|
        (0...size).each do |k|
          c[i][j] += a[i][k] * b[k][j]
        end
      end
    end
    
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond) - start_time
    duration_seconds = duration / 1e9
    operations = size * size * size
    
    BenchmarkResult.new(
      "Matrix Multiplication (500x500)",
      duration,
      0,
      operations,
      operations / duration_seconds
    )
  end
  
  def self.benchmark_cryptographic_hashing
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
    
    srand(42)
    data = Array.new(1024) { rand(256) }.pack('C*')
    
    iterations = 50000
    iterations.times do
      Digest::SHA256.hexdigest(data)
    end
    
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond) - start_time
    duration_seconds = duration / 1e9
    
    BenchmarkResult.new(
      "SHA256 Hashing (50k iterations)",
      duration,
      0,
      iterations,
      iterations / duration_seconds
    )
  end
  
  def self.benchmark_math_operations
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
    
    iterations = 10000000
    result = 0.0
    iterations.times do |i|
      x = i.to_f
      result += Math.sin(x) * Math.cos(x) * Math.sqrt(x + 1)
    end
    
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond) - start_time
    duration_seconds = duration / 1e9
    
    # resultを使用して最適化を防ぐ
    puts "Unexpected NaN result" if result.nan?
    
    BenchmarkResult.new(
      "Math Operations (10M iterations)",
      duration,
      0,
      iterations,
      iterations / duration_seconds
    )
  end
  
  def self.benchmark_large_array_sort
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
    
    size = 1000000
    srand(42)
    data = Array.new(size) { rand(1000001) }
    
    data.sort!
    
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond) - start_time
    duration_seconds = duration / 1e9
    
    BenchmarkResult.new(
      "Large Array Sort (1M elements)",
      duration,
      0,
      size,
      size / duration_seconds
    )
  end
  
  def self.benchmark_memory_allocation
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
    
    allocations = 100000
    arrays = []
    
    allocations.times do |i|
      data = Array.new(256, i % 256) # 1KB相当のデータ
      arrays << data
    end
    
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond) - start_time
    duration_seconds = duration / 1e9
    
    BenchmarkResult.new(
      "Memory Allocation (100k x 1KB)",
      duration,
      0,
      allocations,
      allocations / duration_seconds
    )
  end
  
  def self.benchmark_string_concatenation
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
    
    iterations = 50000
    result = ""
    iterations.times do |i|
      result += "iteration_#{i}_"
    end
    
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond) - start_time
    duration_seconds = duration / 1e9
    
    BenchmarkResult.new(
      "String Concatenation (50k iterations)",
      duration,
      0,
      iterations,
      iterations / duration_seconds
    )
  end
end