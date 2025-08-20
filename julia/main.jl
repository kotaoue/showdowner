include("src/benchmark.jl")
include("src/output.jl")

function main()
    start_time = time_ns()
    
    results = run_all_benchmarks()
    
    end_time = time_ns()
    total_time = (end_time - start_time) / 1e9
    
    print_results(results)
    
    try
        save_results_to_json(results, total_time)
    catch e
        println("Error saving results: $e")
        exit(1)
    end
    
    println("Total execution time: $(round(total_time, digits=3)) seconds")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end