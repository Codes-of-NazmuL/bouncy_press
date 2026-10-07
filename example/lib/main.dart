import 'package:flutter/material.dart';
import 'package:bouncy_press/bouncy_press.dart';

void main() {
  runApp(const BouncyExampleApp());
}

class BouncyExampleApp extends StatelessWidget {
  const BouncyExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bouncy Press Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5A2E2E)),
        useMaterial3: true,
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F0),
      appBar: AppBar(
        title: const Text('Bouncy Press Demo'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Interactive Cards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.touch_app,
                      size: 32, color: Color(0xFF5A2E2E)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tap anywhere on this card',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        Text('Tapped $_counter times',
                            style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ).bouncy(
              shrinkScale: 0.95,
              onTap: () => setState(() => _counter++),
            ),
            const SizedBox(height: 24),
            const Text(
              'Custom Buttons & Icons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5A2E2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Primary Action',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ).bouncy(
                    shrinkScale: 0.94,
                    haptic: BouncyHaptic.medium,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bookmark_border,
                      color: Color(0xFF5A2E2E)),
                ).bouncy(
                  shrinkScale: 0.88,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
