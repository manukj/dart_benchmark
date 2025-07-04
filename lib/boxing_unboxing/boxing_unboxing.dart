import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';

const int iterations = 1000000;
const int benchmarkRuns = 10;

class NoBoxingBenchmark extends BenchmarkBase {
  late List<int> numbers;

  NoBoxingBenchmark() : super('NoBoxing');

  @override
  void setup() {
    numbers = List.generate(iterations, (index) => index);
  }

  @override
  void run() {
    int sum = 0;
    for (int i = 0; i < numbers.length; i++) {
      sum += numbers[i];
    }

    if (sum < 0) print('Unexpected result');
  }
}

class BoxingBenchmark extends BenchmarkBase {
  late List<Object> boxedNumbers;

  BoxingBenchmark() : super('Boxing');

  @override
  void setup() {
    boxedNumbers = List.generate(iterations, (index) => index as Object);
  }

  @override
  void run() {
    int sum = 0;
    for (int i = 0; i < boxedNumbers.length; i++) {
      sum += boxedNumbers[i] as int;
    }

    if (sum < 0) print('Unexpected result');
  }
}

void runMultipleBenchmarks(BenchmarkBase benchmark, String name) {
  List<double> times = [];

  for (int i = 0; i < benchmarkRuns; i++) {
    double time = benchmark.measure();
    times.add(time);
  }

  double average = times.reduce((a, b) => a + b) / times.length;

  double variance =
      times.map((time) => pow(time - average, 2)).reduce((a, b) => a + b) /
          times.length;
  double stdDev = sqrt(variance);

  print('$name Results ($benchmarkRuns runs):');
  print('  Average: ${average.toStringAsFixed(2)} μs');
  print('  Standard Deviation: ${stdDev.toStringAsFixed(2)} μs');
  print(
      '  Individual times: ${times.map((t) => t.toStringAsFixed(2)).join(', ')} μs');
}

void main() {
  print('Running benchmarks...');
  print('Iterations: $iterations');
  print('Number of runs per benchmark: $benchmarkRuns');

  print('Lower scores (microseconds) indicate better performance.');
  print('');

  print('1. No Boxing Benchmark (Direct primitive operations):');
  runMultipleBenchmarks(NoBoxingBenchmark(), 'No Boxing');
  print('');

  print('2. Boxing Benchmark (Object wrapper with unboxing):');
  runMultipleBenchmarks(BoxingBenchmark(), 'Boxing');
  print('');
}
