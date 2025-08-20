using Random
using SHA
using LinearAlgebra

include("benchmark_result.jl")

function run_all_benchmarks()
    results = BenchmarkResult[]

    println("Running CPU-intensive benchmarks...")
    push!(results, benchmark_prime_numbers())
    push!(results, benchmark_matrix_multiplication())
    push!(results, benchmark_cryptographic_hashing())
    push!(results, benchmark_math_operations())

    println("Running memory-intensive benchmarks...")
    push!(results, benchmark_large_array_sort())
    push!(results, benchmark_memory_allocation())
    push!(results, benchmark_string_concatenation())

    return results
end

function benchmark_prime_numbers()
    start_time = time_ns()

    count = 0
    limit = 100000
    for i in 2:limit
        if is_prime(i)
            count += 1
        end
    end

    end_time = time_ns()
    duration = end_time - start_time
    duration_seconds = duration / 1e9

    return BenchmarkResult(
        "Prime Numbers (up to 100k)",
        duration,
        0, # Juliaでは正確なメモリ測定が困難
        count,
        count / duration_seconds
    )
end

function is_prime(n)
    if n < 2
        return false
    end
    for i in 2:Int(sqrt(n))
        if n % i == 0
            return false
        end
    end
    return true
end

function benchmark_matrix_multiplication()
    start_time = time_ns()

    size = 500
    Random.seed!(42) # 再現可能性のためのシード

    a = rand(Float64, size, size)
    b = rand(Float64, size, size)
    
    # 行列乗算
    c = a * b

    end_time = time_ns()
    duration = end_time - start_time
    duration_seconds = duration / 1e9
    operations = size * size * size

    return BenchmarkResult(
        "Matrix Multiplication (500x500)",
        duration,
        0,
        operations,
        operations / duration_seconds
    )
end

function benchmark_cryptographic_hashing()
    start_time = time_ns()

    Random.seed!(42)
    data = rand(UInt8, 1024)

    iterations = 50000
    for _ in 1:iterations
        sha256(data)
    end

    end_time = time_ns()
    duration = end_time - start_time
    duration_seconds = duration / 1e9

    return BenchmarkResult(
        "SHA256 Hashing (50k iterations)",
        duration,
        0,
        iterations,
        iterations / duration_seconds
    )
end

function benchmark_math_operations()
    start_time = time_ns()

    iterations = 10000000
    result = 0.0
    for i in 1:iterations
        x = Float64(i)
        result += sin(x) * cos(x) * sqrt(x + 1)
    end

    end_time = time_ns()
    duration = end_time - start_time
    duration_seconds = duration / 1e9

    # resultを使用して最適化を防ぐ
    if isnan(result)
        println("Unexpected NaN result")
    end

    return BenchmarkResult(
        "Math Operations (10M iterations)",
        duration,
        0,
        iterations,
        iterations / duration_seconds
    )
end

function benchmark_large_array_sort()
    start_time = time_ns()

    size = 1000000
    Random.seed!(42)
    data = rand(1:1000001, size)

    sort!(data)

    end_time = time_ns()
    duration = end_time - start_time
    duration_seconds = duration / 1e9

    return BenchmarkResult(
        "Large Array Sort (1M elements)",
        duration,
        0,
        size,
        size / duration_seconds
    )
end

function benchmark_memory_allocation()
    start_time = time_ns()

    allocations = 100000
    arrays = Vector{Vector{Int}}()

    for i in 1:allocations
        data = fill(i % 256, 256) # 1KB相当のデータ
        push!(arrays, data)
    end

    end_time = time_ns()
    duration = end_time - start_time
    duration_seconds = duration / 1e9

    return BenchmarkResult(
        "Memory Allocation (100k x 1KB)",
        duration,
        0,
        allocations,
        allocations / duration_seconds
    )
end

function benchmark_string_concatenation()
    start_time = time_ns()

    iterations = 50000
    buffer = IOBuffer()
    for i in 1:iterations
        print(buffer, "iteration_$(i)_")
    end
    result = String(take!(buffer))

    end_time = time_ns()
    duration = end_time - start_time
    duration_seconds = duration / 1e9

    return BenchmarkResult(
        "String Concatenation (50k iterations)",
        duration,
        0,
        iterations,
        iterations / duration_seconds
    )
end