import 'package:flutter/material.dart';
import 'package:number_flow/number_flow.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NumberFlow Demo',
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const NumberFlowDemo(),
    );
  }
}

class NumberFlowDemo extends StatefulWidget {
  const NumberFlowDemo({super.key});

  @override
  State<NumberFlowDemo> createState() => _NumberFlowDemoState();
}

class _NumberFlowDemoState extends State<NumberFlowDemo> {
  double _currentValue = 123.45;
  double _stockPrice = 1234.56;
  double _percentage = 12.3;
  int _counter = 0;
  double _bigNumber = 987654;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('NumberFlow Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instruction header
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Text(
                '💡 Click any card to change the numbers and see the animations!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // Basic Usage
            _buildSection(
              'Basic Usage',
              NumberFlow(
                value: _currentValue,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                setState(() {
                  _currentValue = _generateRandomNumber(0, 9999);
                });
              },
            ),

            const SizedBox(height: 20),

            // Currency Example with Enhanced Spinning
            _buildSection(
              'Currency with Enhanced Spinning',
              NumberFlow(
                value: _stockPrice,
                prefix: '\$',
                suffix: ' USD',
                decimalPlaces: 2,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
                prefixStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
                suffixStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
                spinCurve: NumberFlowCurves.smoothSpin,
              ),
              onTap: () {
                setState(() {
                  _stockPrice = _generateRandomNumber(100, 2000);
                });
              },
            ),

            const SizedBox(height: 20),

            // Percentage with Scale Effect
            _buildSection(
              'Percentage with Scale Effect',
              NumberFlow(
                value: _percentage,
                suffix: '%',
                showSign: true,
                decimalPlaces: 2,
                trend: NumberFlowTrend.auto,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _percentage >= 0 ? Colors.green : Colors.red,
                ),
                spinCurve: NumberFlowCurves.elastic,
              ),
              onTap: () {
                setState(() {
                  _percentage = _generateRandomPercentage();
                });
              },
            ),

            const SizedBox(height: 20),

            // Counter with Bounce Effect
            _buildSection(
              'Counter with Bounce Effect',
              NumberFlow(
                value: _counter,
                trend: NumberFlowTrend.up,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                spinDuration: const Duration(milliseconds: 600),
                opacityDuration: const Duration(milliseconds: 300),
                spinCurve: NumberFlowCurves.bounce,
              ),
              onTap: () {
                setState(() {
                  _counter = _generateRandomInt(0, 100);
                });
              },
            ),

            const SizedBox(height: 20),

            // Grouped Numbers Example
            _buildSection(
              'Grouped Numbers with Staggered Animation',
              NumberFlowGroup.row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Price', style: TextStyle(fontSize: 12)),
                      NumberFlow(
                        value: _stockPrice,
                        prefix: '\$',
                        decimalPlaces: 2,

                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        spinCurve: NumberFlowCurves.smoothSpin,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Change', style: TextStyle(fontSize: 12)),
                      NumberFlow(
                        value: _percentage,
                        suffix: '%',
                        showSign: true,
                        decimalPlaces: 2,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _percentage >= 0 ? Colors.green : Colors.red,
                        ),
                        spinCurve: NumberFlowCurves.anticipate,
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _stockPrice = _generateRandomNumber(100, 2000);
                  _percentage = _generateRandomPercentage();
                });
              },
            ),

            const SizedBox(height: 40),

            // Custom Animation Timing Example
            _buildSection(
              'Custom Animation with Smooth Fade',
              NumberFlow(
                value: _currentValue,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                transformDuration: const Duration(milliseconds: 1200),
                spinDuration: const Duration(milliseconds: 800),
                opacityDuration: const Duration(milliseconds: 400),
                transformCurve: NumberFlowCurves.elastic,
                spinCurve: NumberFlowCurves.smoothSpin,
                opacityCurve: NumberFlowCurves.smoothFade,
              ),
              onTap: () {
                setState(() {
                  _currentValue = _generateRandomNumber(0, 9999);
                });
              },
            ),

            const SizedBox(height: 20),

            // Compact Notation Example
            _buildSection(
              'Compact Notation (K, M, B)',
              NumberFlow(
                value: _bigNumber * 1000, // Make it even bigger
                notation: NumberNotation.compact,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                spinCurve: NumberFlowCurves.spring(damping: 0.6),
              ),
              onTap: () {
                setState(() {
                  _bigNumber = _generateRandomNumber(100000, 9999999);
                });
              },
            ),

            const SizedBox(height: 20),

            // Start From Zero Example
            _buildSection(
              'Start From Zero (Great for cached data)',
              Column(
                children: [
                  NumberFlow(
                    value: _bigNumber,
                    startFromZero: true,
                    startFromZeroDelay: const Duration(milliseconds: 300),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                    spinDuration: const Duration(milliseconds: 1000),
                    spinCurve: NumberFlowCurves.smoothSpin,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Starts from 0 with 300ms delay',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _bigNumber = _generateRandomNumber(1000, 99999);
                });
              },
            ),

            const SizedBox(height: 20),

            // Start From Zero with longer delay example
            _buildSection(
              'Start From Zero with Longer Delay',
              Column(
                children: [
                  NumberFlow(
                    value: _counter.toDouble(),
                    startFromZero: true,
                    startFromZeroDelay: const Duration(milliseconds: 1000),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                    spinDuration: const Duration(milliseconds: 800),
                    spinCurve: NumberFlowCurves.elastic,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Starts from 0 with 1000ms delay',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _counter = _generateRandomInt(100, 9999);
                });
              },
            ),

            // Add some bottom padding
            const SizedBox(height: 40),

            // Debug Test Section
            Card(
              elevation: 0,
              color: Colors.yellow[50],
              child: InkWell(
                onTap: () {
                  setState(() {
                    _counter = _generateRandomInt(0, 9999);
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'DEBUG: Smooth Animation Test',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      NumberFlow(
                        value: _counter.toDouble(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                        animated: true,
                        spinDuration: const Duration(milliseconds: 750),
                        opacityDuration: const Duration(milliseconds: 350),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Counter value: $_counter',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Smooth timing with random directions:\n• Consistent speed • Polished curves • Random up/down spins',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child, {VoidCallback? onTap}) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Center(child: child),
            ],
          ),
        ),
      ),
    );
  }

  double _generateRandomNumber(double min, double max) {
    final random = math.Random();
    final baseValue = min + (max - min) * random.nextDouble();

    // Randomly decide the format:
    // 40% chance of integer
    // 30% chance of 1 decimal place
    // 30% chance of 2 decimal places
    final formatType = random.nextInt(10);

    if (formatType < 4) {
      // Return integer (round to nearest whole number)
      return baseValue.roundToDouble();
    } else if (formatType < 7) {
      // Return 1 decimal place
      return double.parse(baseValue.toStringAsFixed(1));
    } else {
      // Return 2 decimal places
      return double.parse(baseValue.toStringAsFixed(2));
    }
  }

  int _generateRandomInt(int min, int max) {
    final random = math.Random();
    return min + random.nextInt(max - min + 1);
  }

  double _generateRandomPercentage() {
    final random = math.Random();
    final baseValue = (random.nextDouble() - 0.5) * 100; // -50 to +50

    // 60% chance of 1-2 decimal places, 40% chance of integer
    final formatType = random.nextInt(10);

    if (formatType < 4) {
      return baseValue.roundToDouble();
    } else {
      return double.parse(baseValue.toStringAsFixed(random.nextInt(2) + 1));
    }
  }
}
