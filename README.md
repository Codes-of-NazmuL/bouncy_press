# Bouncy Press 🎾

A tactile, high-performance spring press and bounce micro-interaction widget for Flutter with built-in haptics and **zero third-party dependencies**.

Turn any button, card, tile, or icon into a delightfully responsive physical surface.

[![pub package](https://img.shields.io/badge/pub.dev-1.0.0-blue.svg)](https://github.com/Codes-of-NazmuL/bouncy_press)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?logo=flutter&logoColor=white)](https://flutter.dev)

---

## ✨ Features

- 🌿 **Zero Dependencies:** Pure Flutter framework (`flutter/material.dart` + `flutter/services.dart`).
- ⚡️ **Snappy Spring Dynamics:** Distinct press compression and spring-back release curves.
- 📳 **Haptic Feedback Built-in:** Subtle haptics (`light`, `medium`, `heavy`, `selection`, `none`).
- 📜 **Scroll-Proof:** Reliably springs back if the user starts scrolling inside a `ListView` or `SingleChildScrollView`.
- 🪄 **1-Line Extension:** Just append `.bouncy()` to any Flutter widget.
- 🎨 **Subtle Dimming (Optional):** Supports micro-opacity dimming alongside scaling.

---

## 📦 Installation

Add `bouncy_press` via Git in your `pubspec.yaml`:

```yaml
dependencies:
  bouncy_press:
    git:
      url: https://github.com/Codes-of-NazmuL/bouncy_press.git
      ref: main
```

Or install from terminal:

```bash
flutter pub add 'bouncy_press:{"git":{"url":"https://github.com/Codes-of-NazmuL/bouncy_press.git"}}'
```

---

## 🚀 Quick Usage

### 1. Extension Method (Simplest)

Call `.bouncy()` directly on your widgets:

```dart
import 'package:flutter/material.dart';
import 'package:bouncy_press/bouncy_press.dart';

// Button with bounce:
ElevatedButton(
  onPressed: () {},
  child: const Text('Tap Me'),
).bouncy(
  onTap: () => print('Pressed!'),
);

// Card with bounce:
Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  ),
  child: const Text('Interactive Card'),
).bouncy(
  shrinkScale: 0.95,
  onTap: () => print('Card Tapped'),
);
```

### 2. Widget Wrapper

```dart
BouncyPress(
  onTap: () => print('Clicked!'),
  shrinkScale: 0.94,
  haptic: BouncyHaptic.light,
  child: MyCustomCard(),
)
```

---

## ⚙️ Customization Options

| Property | Type | Default | Description |
|---|---|---|---|
| `shrinkScale` | `double` | `0.96` | Target scale factor when pressed down. |
| `dimOpacity` | `double` | `1.0` | Target opacity when pressed down (1.0 = no dimming). |
| `pressDuration` | `Duration` | `100ms` | Duration taken to compress down on touch. |
| `releaseDuration` | `Duration` | `160ms` | Duration taken to spring back up on release. |
| `pressCurve` | `Curve` | `Curves.easeInOut` | Curve during compression. |
| `releaseCurve` | `Curve` | `Curves.easeOutCubic` | Curve during spring-back. |
| `haptic` | `BouncyHaptic` | `BouncyHaptic.light` | Feedback triggered on touch down. |
| `enabled` | `bool` | `true` | When false, disables all animations & gestures. |

---

## 👨‍💻 Author & Maintainer

Created with ❤️ by **Nazmul Islam**

- **GitHub:** [@Codes-of-NazmuL](https://github.com/Codes-of-NazmuL)


Feel free to star ⭐️ the repository and contribute!

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
