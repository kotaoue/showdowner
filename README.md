# showdowner
個人的な興味に基づく、プログラミング言語のあれこれ比較

## 含まれるベンチマーク

### CPU集約的なテスト
- **素数計算**: 100,000以下の素数を全て計算
- **行列乗算**: 500x500の行列同士の乗算  
- **暗号化ハッシュ**: SHA256ハッシュ計算を50,000回
- **数学演算**: 三角関数・平方根計算を1,000万回

### メモリ集約的なテスト
- **大型配列ソート**: 100万要素の配列をソート
- **メモリ割り当て**: 1KB配列を100,000個作成
- **文字列結合**: 50,000回の文字列連結

## 最新ベンチマーク結果

<!-- BENCHMARK_RESULTS_START -->
[最新の結果json](comparison_latest.json)
<details><summary>詳細</summary>

```
Found benchmark files:
  ../go/benchmark_go_20260225_144410.json
  ../php/benchmark_php_20260225_144433.json
  ../python3/benchmark_python3_20260225_144407.json
  ../rust/benchmark_rust_20260225_144415.json
  ../javascript/benchmark_javascript_2026-02-25_1444.json
  ../typescript/benchmark_typescript_2026-02-25_1444.json
  ../java/benchmark_java_20260225_144408.json
  ../kotlin/benchmark_kotlin_20260225_144516.json
  ../cpp/benchmark_cpp_20260225_144413.json
  ../ruby/benchmark_ruby_20260225_144413.json
  ../c/benchmark_c_20260225_144424.json
  ../csharp/benchmark_csharp_20260225_144413.json
  ../swift/benchmark_swift_20260225_144410.json
  ../dart/benchmark_dart_20260225_144406.json
  ../scala/benchmark_scala_20260225_144443.json
  ../julia/benchmark_julia_20260225_144429.json

=== LANGUAGE PERFORMANCE COMPARISON ===
Generated: 2026-02-25T14:45:38Z

## Overall Results
Scala     : 0.000s (×NaN)
Swift     : 0.428s (×+Inf)
Cpp       : 0.439s (×+Inf)
Rust      : 0.806s (×+Inf)
Csharp    : 0.951s (×+Inf)
Julia     : 1.035s (×+Inf)
Java      : 1.746s (×+Inf)
Kotlin    : 1.858s (×+Inf)
Dart      : 2.569s (×+Inf)
Javascript: 2.957s (×+Inf)
Typescript: 3.001s (×+Inf)
Go        : 4.172s (×+Inf)
C         : 12.971s (×+Inf)
Python3   : 14.044s (×+Inf)
Ruby      : 18.407s (×+Inf)
Php       : 35.623s (×+Inf)

Fastest: Scala
Speed difference: ×0.00

## Test-by-Test Comparison

### Large Array Sort (1M elements)
Fastest: Scala
Scala     :     0.00ms (×0.00) |          0 bytes |            0 ops/sec
Julia     :    27.23ms (×0.00) |          0 bytes |     36727156 ops/sec
Rust      :    31.59ms (×0.00) |          0 bytes |     31657275 ops/sec
Cpp       :    69.20ms (×0.00) |          0 bytes |     14450641 ops/sec
Kotlin    :    99.14ms (×0.00) |          0 bytes |     10086331 ops/sec
C         :   138.72ms (×0.00) |          0 bytes |      7208826 ops/sec
Swift     :   146.21ms (×0.00) |          0 bytes |      6839629 ops/sec
Go        :   161.69ms (×0.00) |    8002832 bytes |      6184853 ops/sec
Ruby      :   285.39ms (×0.00) |          0 bytes |      3503994 ops/sec
Dart      :   333.80ms (×0.00) |          0 bytes |      2995797 ops/sec
Javascript:   345.60ms (×0.00) |          0 bytes |      2893497 ops/sec
Typescript:   349.20ms (×0.00) |          0 bytes |      2863689 ops/sec
Php       :   455.59ms (×0.00) |   16781424 bytes |      2194975 ops/sec
Java      :   533.84ms (×0.00) |          0 bytes |      1873233 ops/sec
Python3   :   559.73ms (×0.00) |          0 bytes |      1786576 ops/sec
Csharp    :  7670.08ms (×0.00) |          0 bytes |     13037691 ops/sec

### String Concatenation (50k iterations)
Fastest: Scala
Scala     :     0.00ms (×0.00) |          0 bytes |            0 ops/sec
Rust      :     2.55ms (×0.00) |          0 bytes |     19612650 ops/sec
Cpp       :     2.62ms (×0.00) |          0 bytes |     19101679 ops/sec
Python3   :     8.77ms (×0.00) |          0 bytes |      5702657 ops/sec
Julia     :    10.59ms (×0.00) |          0 bytes |      4719225 ops/sec
Php       :    10.89ms (×0.00) |     790528 bytes |      4591365 ops/sec
Typescript:    12.65ms (×0.00) |          0 bytes |      3951458 ops/sec
Dart      :    13.57ms (×0.00) |          0 bytes |      3683513 ops/sec
Javascript:    14.04ms (×0.00) |          0 bytes |      3560409 ops/sec
Java      :    17.08ms (×0.00) |          0 bytes |      2927043 ops/sec
Kotlin    :    94.72ms (×0.00) |          0 bytes |       527891 ops/sec
Csharp    :   427.97ms (×0.00) |          0 bytes |     11683335 ops/sec
Ruby      :  1808.93ms (×0.00) |          0 bytes |        27641 ops/sec
Go        :  2734.44ms (×0.00) |    3991144 bytes |        18285 ops/sec
C         : 12472.90ms (×0.00) |          0 bytes |         4009 ops/sec

### Hash Computing (50k iterations)
Fastest: C
C         :     7.91ms (×1.00) |          0 bytes |      6324326 ops/sec
Cpp       :    14.17ms (×1.79) |          0 bytes |      3528538 ops/sec

### SHA256 Hashing (50k iterations)
Fastest: Scala
Scala     :     0.00ms (×0.00) |          0 bytes |            0 ops/sec
Rust      :    34.08ms (×0.00) |          0 bytes |      1466971 ops/sec
Go        :    36.70ms (×0.00) |          8 bytes |      1362470 ops/sec
Swift     :    44.22ms (×0.00) |          0 bytes |      1130695 ops/sec
Python3   :    53.65ms (×0.00) |          0 bytes |       931943 ops/sec
Java      :    83.18ms (×0.00) |          0 bytes |       601101 ops/sec
Javascript:   115.14ms (×0.00) |          0 bytes |       434258 ops/sec
Typescript:   115.72ms (×0.00) |          0 bytes |       432078 ops/sec
Php       :   225.25ms (×0.00) |       1280 bytes |       221977 ops/sec
Ruby      :   268.10ms (×0.00) |          0 bytes |       186501 ops/sec
Julia     :   408.99ms (×0.00) |          0 bytes |       122253 ops/sec
Kotlin    :   436.99ms (×0.00) |          0 bytes |       114419 ops/sec
Dart      :   777.04ms (×0.00) |          0 bytes |        64347 ops/sec
Csharp    :  6895.59ms (×0.00) |          0 bytes |       725102 ops/sec

### Math Operations (10M iterations)
Fastest: Scala
Scala     :     0.00ms (×0.00) |          0 bytes |            0 ops/sec
Swift     :    94.95ms (×0.00) |          0 bytes |    105317386 ops/sec
Rust      :   164.69ms (×0.00) |          0 bytes |     60721465 ops/sec
C         :   170.85ms (×0.00) |          0 bytes |     58531116 ops/sec
Cpp       :   174.26ms (×0.00) |          0 bytes |     57386785 ops/sec
Go        :   188.00ms (×0.00) |          8 bytes |     53192454 ops/sec
Dart      :   260.52ms (×0.00) |          0 bytes |     38384769 ops/sec
Julia     :   439.21ms (×0.00) |          0 bytes |     22768219 ops/sec
Kotlin    :   526.96ms (×0.00) |          0 bytes |     18976778 ops/sec
Java      :   552.45ms (×0.00) |          0 bytes |     18101034 ops/sec
Ruby      :  1744.79ms (×0.00) |          0 bytes |      5731353 ops/sec
Python3   :  1765.07ms (×0.00) |          0 bytes |      5665495 ops/sec
Javascript:  1796.82ms (×0.00) |          0 bytes |      5565392 ops/sec
Typescript:  1827.47ms (×0.00) |          0 bytes |      5472051 ops/sec
Php       :  6008.67ms (×0.00) |          0 bytes |      1664263 ops/sec
Csharp    : 22635.63ms (×0.00) |          0 bytes |     44178158 ops/sec

### Memory Allocation (100k x 1KB)
Fastest: Scala
Scala     :     0.00ms (×0.00) |          0 bytes |            0 ops/sec
Kotlin    :    36.33ms (×0.00) |          0 bytes |      2752837 ops/sec
Cpp       :    43.87ms (×0.00) |          0 bytes |      2279422 ops/sec
C         :    51.23ms (×0.00) |          0 bytes |      1951827 ops/sec
Java      :    68.26ms (×0.00) |          0 bytes |      1465082 ops/sec
Rust      :    83.06ms (×0.00) |          0 bytes |      1203911 ops/sec
Go        :   107.65ms (×0.00) |  104800360 bytes |       928904 ops/sec
Julia     :   118.64ms (×0.00) |          0 bytes |       842899 ops/sec
Javascript:   150.50ms (×0.00) |          0 bytes |       664444 ops/sec
Dart      :   152.81ms (×0.00) |          0 bytes |       654425 ops/sec
Typescript:   161.77ms (×0.00) |          0 bytes |       618163 ops/sec
Ruby      :   221.10ms (×0.00) |          0 bytes |       452274 ops/sec
Python3   :   431.08ms (×0.00) |          0 bytes |       231973 ops/sec
Csharp    :  6722.45ms (×0.00) |          0 bytes |      1487553 ops/sec
Php       : 計測対象外 (メモリ不足)

### Matrix Multiplication (300x300)
Fastest: Swift
Swift     :   113.97ms (×1.00) |          0 bytes |    236904014 ops/sec

### Memory Allocation (50k x 512B)
Fastest: Swift
Swift     :    24.07ms (×1.00) |          0 bytes |      2077472 ops/sec

### String Concatenation (25k iterations)
Fastest: Swift
Swift     :     2.50ms (×1.00) |          0 bytes |      9986849 ops/sec

### Prime Numbers (up to 100k)
Fastest: Scala
Scala     :     0.00ms (×0.00) |          0 bytes |            0 ops/sec
Swift     :     2.38ms (×0.00) |          0 bytes |      4024265 ops/sec
C         :     5.44ms (×0.00) |          0 bytes |      1761878 ops/sec
Cpp       :     5.62ms (×0.00) |          0 bytes |      1707958 ops/sec
Rust      :     5.69ms (×0.00) |          0 bytes |      1686203 ops/sec
Julia     :     6.84ms (×0.00) |          0 bytes |      1402678 ops/sec
Java      :     8.26ms (×0.00) |          0 bytes |      1161448 ops/sec
Go        :     8.64ms (×0.00) |          0 bytes |      1110101 ops/sec
Javascript:     9.01ms (×0.00) |          0 bytes |      1064264 ops/sec
Dart      :     9.63ms (×0.00) |          0 bytes |       995744 ops/sec
Typescript:     9.78ms (×0.00) |          0 bytes |       981026 ops/sec
Kotlin    :    10.73ms (×0.00) |          0 bytes |       893690 ops/sec
Python3   :   101.87ms (×0.00) |          0 bytes |        94157 ops/sec
Ruby      :   354.32ms (×0.00) |          0 bytes |        27072 ops/sec
Csharp    :   582.33ms (×0.00) |          0 bytes |      1647176 ops/sec
Php       :   750.61ms (×0.00) |          0 bytes |        12779 ops/sec

### Matrix Multiplication (500x500)
Fastest: Scala
Scala     :     0.00ms (×0.00) |          0 bytes |            0 ops/sec
Julia     :     9.56ms (×0.00) |          0 bytes |  13074717513 ops/sec
C         :   123.47ms (×0.00) |          0 bytes |   1012428401 ops/sec
Cpp       :   126.93ms (×0.00) |          0 bytes |    984793070 ops/sec
Rust      :   471.27ms (×0.00) |          0 bytes |    265239878 ops/sec
Java      :   482.43ms (×0.00) |          0 bytes |    259102998 ops/sec
Typescript:   517.31ms (×0.00) |          0 bytes |    241633362 ops/sec
Javascript:   519.82ms (×0.00) |          0 bytes |    240469809 ops/sec
Kotlin    :   559.03ms (×0.00) |          0 bytes |    223603459 ops/sec
Go        :   934.95ms (×0.00) |    6181288 bytes |    133697369 ops/sec
Dart      :  1018.50ms (×0.00) |          0 bytes |    122729022 ops/sec
Python3   : 11056.01ms (×0.00) |          0 bytes |     11306065 ops/sec
Ruby      : 13724.34ms (×0.00) |          0 bytes |      9107905 ops/sec
Php       : 28169.86ms (×0.00) |   18553032 bytes |      4437367 ops/sec
Csharp    : 48805.07ms (×0.00) |          0 bytes |    256120984 ops/sec

Comparison saved to: ../comparison_20260225_144538.json
```
</details>
<!-- BENCHMARK_RESULTS_END -->
