#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import time
import platform
import sys

def print_results(results):
    print("\n=== BENCHMARK RESULTS ===")
    for result in results:
        print("Test: %s" % result['test'])
        
        if 'error' in result and result['error']:
            print("  Status: %s" % result['error'])
        else:
            print("  Duration: %d ns" % result['duration_ns'])
            print("  Memory: %d bytes" % result['memory_bytes'])
            print("  Operations: %d" % result['operations'])
            print("  Ops/sec: %.2f" % result['ops_per_sec'])
        print()

def save_results_to_json(results, total_time):
    report = {
        'language': 'python2',                          # 言語名
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
    
    filename = 'benchmark_python2_%s.json' % time.strftime('%Y%m%d_%H%M%S')
    
    try:
        with open(filename, 'w') as f:
            json.dump(report, f, indent=2)
        print("Results saved to: %s" % filename)
    except Exception as e:
        raise Exception('Error writing file: %s' % str(e))

def get_cpu_count():
    try:
        import multiprocessing
        return multiprocessing.cpu_count()
    except (ImportError, NotImplementedError):
        return 1