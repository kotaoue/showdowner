require 'json'
require 'rbconfig'

class Output
  def self.print_results(results)
    puts "\n=== BENCHMARK RESULTS ==="
    results.each do |result|
      puts "Test: #{result.test}"
      puts "  Duration: #{result.duration_ns} ns"
      puts "  Memory: #{result.memory_bytes} bytes"
      puts "  Operations: #{result.operations}"
      puts "  Ops/sec: #{'%.2f' % result.ops_per_sec}"
      puts
    end
  end
  
  def self.save_results_to_json(results, total_time)
    report = {
      language: 'ruby',
      timestamp: Time.now.iso8601,
      ruby_version: RUBY_VERSION,
      ruby_engine: RUBY_ENGINE,
      ruby_platform: RUBY_PLATFORM,
      system: {
        os: RbConfig::CONFIG['host_os'],
        arch: RbConfig::CONFIG['host_cpu'],
        cpus: get_cpu_count
      },
      tests: results.map(&:to_h),
      total_time_seconds: total_time
    }
    
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    filename = "benchmark_ruby_#{timestamp}.json"
    
    begin
      File.write(filename, JSON.pretty_generate(report))
      puts "Results saved to: #{filename}"
    rescue => e
      raise "Error writing file: #{e.message}"
    end
  end
  
  private
  
  def self.get_cpu_count
    case RbConfig::CONFIG['host_os']
    when /darwin/
      `sysctl -n hw.ncpu`.to_i
    when /linux/
      `nproc`.to_i
    when /mswin|mingw|cygwin/
      ENV['NUMBER_OF_PROCESSORS'].to_i
    else
      1 # フォールバック
    end
  rescue
    1 # エラー時のフォールバック
  end
end