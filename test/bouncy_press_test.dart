import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bouncy_press/bouncy_press.dart';

void main() {
  testWidgets('BouncyPress renders child properly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BouncyPress(
            onTap: () {},
            child: const Text('Press Me'),
          ),
        ),
      ),
    );

    expect(find.text('Press Me'), findsOneWidget);
  });

  testWidgets('BouncyPress triggers onTap callback', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BouncyPress(
            onTap: () => tapped = true,
            child: const Text('Press Me'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Press Me'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets('BouncyPress animates scale down on press and back on release',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: BouncyPress(
              onTap: () {},
              shrinkScale: 0.90,
              pressDuration: const Duration(milliseconds: 100),
              releaseDuration: const Duration(milliseconds: 100),
              child: const SizedBox(
                width: 100,
                height: 100,
                child: Text('Card'),
              ),
            ),
          ),
        ),
      ),
    );

    final gesture =
        await tester.startGesture(tester.getCenter(find.text('Card')));
    // TapGestureRecognizer arena timeout
    await tester.pump(const Duration(milliseconds: 100));
    // Press animation forward duration
    await tester.pump(const Duration(milliseconds: 100));

    final scaleFinder = find.descendant(
      of: find.byType(BouncyPress),
      matching: find.byType(ScaleTransition),
    );
    final scaleTransition = tester.widget<ScaleTransition>(scaleFinder);
    expect(scaleTransition.scale.value, closeTo(0.90, 0.01));

    await gesture.up();
    await tester.pumpAndSettle();

    final releasedScaleTransition =
        tester.widget<ScaleTransition>(scaleFinder);
    expect(releasedScaleTransition.scale.value, closeTo(1.0, 0.01));
  });

  testWidgets('BouncyPress animates opacity dimming when configured',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: BouncyPress(
              onTap: () {},
              dimOpacity: 0.80,
              pressDuration: const Duration(milliseconds: 100),
              releaseDuration: const Duration(milliseconds: 100),
              child: const Text('Dimming Card'),
            ),
          ),
        ),
      ),
    );

    final gesture =
        await tester.startGesture(tester.getCenter(find.text('Dimming Card')));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    final fadeFinder = find.descendant(
      of: find.byType(BouncyPress),
      matching: find.byType(FadeTransition),
    );
    final fadeTransition = tester.widget<FadeTransition>(fadeFinder);
    expect(fadeTransition.opacity.value, closeTo(0.80, 0.01));

    await gesture.up();
    await tester.pumpAndSettle();

    final releasedFade = tester.widget<FadeTransition>(fadeFinder);
    expect(releasedFade.opacity.value, closeTo(1.0, 0.01));
  });

  testWidgets('BouncyPress does not animate when disabled', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BouncyPress(
            enabled: false,
            onTap: () => tapped = true,
            child: const Text('Disabled'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Disabled'));
    await tester.pumpAndSettle();

    expect(tapped, isFalse);
    expect(find.byType(GestureDetector), findsNothing);
  });

  testWidgets('Widget extension .bouncy() works properly', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Text('Extension Text').bouncy(
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Extension Text'), findsOneWidget);
    await tester.tap(find.text('Extension Text'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });
}
