#!/usr/bin/env python3

import json
import time
import platform
import sys

def print_results(results):
    print("\n=== BENCHMARK RESULTS ===")
    for result in results:
        print(f"Test: {result['test']}")
        
        if 'error' in result and result['error']:
            print(f"  Status: {result['error']}")
        else:
            print(f"  Duration: {result['duration_ns']} ns")
            print(f"  Memory: {result['memory_bytes']} bytes")
            print(f"  Operations: {result['operations']}")
            print(f"  Ops/sec: {result['ops_per_sec']:.2f}")
        print()

def save_results_to_json(results, total_time):
    report = {
        'language': 'python3',                          # 言語名
        'timestamp': time.strftime('%Y-%m-%dT%H:%M:%S%z'),  # 実行時刻
        'python_version': sys.version.split()[0],       # Pythonのバージョン
        'system': {
            'os': platform.system(),                    # OS名
            'arch': platform.machine(),                 # アーキテクチャ
            'cpus': get_cpu_count()                     # CPU数
        },
        'tests': results,                               # ベンチマーク結果
        'total_time_seconds': total_time                # 総実行時間(秒)
    }
    
    filename = f'benchmark_python3_{time.strftime("%Y%m%d_%H%M%S")}.json'
    
    try:
        with open(filename, 'w') as f:
            json.dump(report, f, indent=2)
        print(f"Results saved to: {filename}")
    except Exception as e:
        raise Exception(f'Error writing file: {e}')

def get_cpu_count():
    try:
        import multiprocessing
        return multiprocessing.cpu_count()
    except (ImportError, NotImplementedError):
        return 1