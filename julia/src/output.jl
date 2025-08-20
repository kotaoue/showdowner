using JSON3
using Dates

include("benchmark_result.jl")

struct SystemInfo
    os::String
    arch::String
    cpus::Int
end

struct BenchmarkReport
    language::String
    timestamp::String
    julia_version::String
    system::SystemInfo
    tests::Vector{BenchmarkResult}
    total_time_seconds::Float64
end

function print_results(results::Vector{BenchmarkResult})
    println("\n=== BENCHMARK RESULTS ===")
    for result in results
        println("Test: $(result.test)")
        println("  Duration: $(result.duration_ns) ns")
        println("  Memory: $(result.memory_bytes) bytes")
        println("  Operations: $(result.operations)")
        println("  Ops/sec: $(round(result.ops_per_sec, digits=2))")
        println()
    end
end

function save_results_to_json(results::Vector{BenchmarkResult}, total_time::Float64)
    report = BenchmarkReport(
        "julia",
        Dates.format(now(UTC), "yyyy-mm-ddTHH:MM:SSZ"),
        string(VERSION),
        SystemInfo(
            get_os_name(),
            get_architecture(),
            Sys.CPU_THREADS
        ),
        results,
        total_time
    )

    timestamp = Dates.format(now(), "yyyymmdd_HHMMSS")
    filename = "benchmark_julia_$(timestamp).json"

    # BenchmarkResultを辞書に変換する関数
    function benchmark_result_to_dict(br::BenchmarkResult)
        return Dict(
            "test" => br.test,
            "duration_ns" => br.duration_ns,
            "memory_bytes" => br.memory_bytes,
            "operations" => br.operations,
            "ops_per_sec" => br.ops_per_sec
        )
    end

    # BenchmarkReportを辞書に変換
    report_dict = Dict(
        "language" => report.language,
        "timestamp" => report.timestamp,
        "julia_version" => report.julia_version,
        "system" => Dict(
            "os" => report.system.os,
            "arch" => report.system.arch,
            "cpus" => report.system.cpus
        ),
        "tests" => [benchmark_result_to_dict(result) for result in report.tests],
        "total_time_seconds" => report.total_time_seconds
    )

    open(filename, "w") do io
        JSON3.pretty(io, report_dict)
    end

    println("Results saved to: $filename")
end

function get_os_name()
    if Sys.iswindows()
        return "Windows"
    elseif Sys.isapple()
        return "macOS"
    elseif Sys.islinux()
        return "Linux"
    else
        return "Unknown"
    end
end

function get_architecture()
    arch = string(Sys.ARCH)
    if arch == "x86_64"
        return "x86_64"
    elseif arch == "aarch64"
        return "arm64"
    else
        return arch
    end
end