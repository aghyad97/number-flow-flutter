# NumberFlow for Flutter

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/pub/v/number_flow.svg?style=for-the-badge" alt="pub package">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge" alt="License: MIT">
</p>

<p align="center">
  <strong>✨ Beautiful, smooth animated number transitions for Flutter ✨</strong>
</p>

<p align="center">
  A Flutter port of the popular <a href="https://github.com/barvian/number-flow">number-flow</a> library, bringing smooth digit-by-digit animations to your Flutter apps with enhanced visual effects and polished transitions.
</p>

---

## 🎬 Live Demo

<p align="center">
  <img src="https://github.com/aghyad97/number-flow-flutter/blob/main/demo/demo.gif?raw=true" alt="NumberFlow Demo" width="600">
</p>

<p align="center">
  <em>✨ Watch NumberFlow in action: smooth digit animations, randomized directions, and seamless width transitions ✨</em>
</p>

**Demo Features Shown:**

- 🎯 **Smooth digit-by-digit animations** with perfect timing
- 🎲 **Randomized spin directions** - each digit chooses up ⬆️ or down ⬇️
- 📏 **Animated width transitions** with faded edges when digit count changes
- 💰 **Currency formatting** with prefix/suffix styling
- 📊 **Percentage displays** with automatic color changes
- 🎪 **Custom animation curves** (elastic, bounce, spring, smooth)
- 📈 **Compact notation** for large numbers (1.23M, 1.23B)

---

## 🌟 Features

| Feature                           | Description                                          |
| --------------------------------- | ---------------------------------------------------- |
| 🎯 **Smooth Digit Animations**    | Each digit spins individually with perfect timing    |
| 🎨 **Randomized Directions**      | Digits spin in random directions for dynamic effects |
| 📏 **Animated Width Transitions** | Smooth expansion/contraction with faded edges        |
| ⚡ **High Performance**           | Optimized for 60fps animations                       |
| 🎛️ **Highly Customizable**        | Control timing, curves, styling, and behavior        |
| 📱 **Accessibility Support**      | Respects motion preferences automatically            |
| 🔧 **Advanced Formatting**        | Prefix/suffix, decimals, grouping, compact notation  |
| 🎪 **Custom Animation Curves**    | Built-in curves inspired by the original library     |

---

## 🚀 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  number_flow: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## 🎯 Quick Start

### Basic Usage

```dart
import 'package:number_flow/number_flow.dart';

NumberFlow(
  value: 1234.56,
  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
)
```

### Interactive Example

```dart
class AnimatedCounter extends StatefulWidget {
  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberFlow(
          value: _value,
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () => setState(() => _value = Random().nextDouble() * 10000),
          child: Text('Randomize'),
        ),
      ],
    );
  }
}
```

---

## 🎨 Visual Examples

### 💰 Currency Display

Perfect for stock prices, financial data, and e-commerce:

```dart
NumberFlow(
  value: stockPrice,
  prefix: '\$',
  suffix: ' USD',
  decimalPlaces: 2,
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.green,
  ),
  spinCurve: NumberFlowCurves.smoothSpin,
)
```

**Visual Effect:** `$123.45 USD` → `$1,234.56 USD` with smooth width expansion

### 📊 Percentage Changes

Great for statistics, progress indicators, and data visualization:

```dart
NumberFlow(
  value: percentage,
  suffix: '%',
  showSign: true,
  decimalPlaces: 2,
  trend: NumberFlowTrend.auto,
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: percentage >= 0 ? Colors.green : Colors.red,
  ),
  spinCurve: NumberFlowCurves.elastic,
)
```

**Visual Effect:** `+12.34%` → `-5.67%` with color change and elastic bounce

### 🔢 Counters and Metrics

Perfect for dashboards, analytics, and real-time data:

```dart
NumberFlow(
  value: counter,
  trend: NumberFlowTrend.up,
  style: TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
  spinDuration: Duration(milliseconds: 600),
  spinCurve: NumberFlowCurves.bounce,
)
```

**Visual Effect:** Digits bounce playfully with randomized directions

### 📈 Large Numbers with Compact Notation

Ideal for follower counts, views, and big metrics:

```dart
NumberFlow(
  value: 1234567890,
  notation: NumberNotation.compact, // Shows as "1.23B"
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.orange,
  ),
  spinCurve: NumberFlowCurves.spring(damping: 0.6),
)
```

**Visual Effect:** `1.23M` → `1.23B` with spring physics

---

## 🎪 Animation System

### Core Animation Features

#### 🎲 Randomized Direction Spinning

Each digit randomly chooses to spin up ⬆️ or down ⬇️, creating dynamic visual effects:

```dart
// When changing from 1234 to 5678:
// '1' might spin UP to '5'
// '2' might spin DOWN to '6'
// '3' might spin UP to '7'
// '4' might spin DOWN to '8'
```

#### 📏 Smooth Width Transitions

Automatic width animation when digit count changes:

```dart
// Smooth expansion: 99 → 100
// Smooth contraction: 1000 → 999
// With faded edges for polished look
```

#### ⏱️ Coordinated Timing

All digits animate together with consistent, polished timing:

```dart
NumberFlow(
  value: myNumber,
  spinDuration: Duration(milliseconds: 600),    // All digits sync
  opacityDuration: Duration(milliseconds: 350), // Fade timing
  transformDuration: Duration(milliseconds: 600), // Width changes
)
```

### Custom Animation Curves

NumberFlow includes professionally designed curves:

```dart
// Available curves:
NumberFlowCurves.smoothSpin    // Smooth with slight overshoot
NumberFlowCurves.elastic       // Elastic bounce effect
NumberFlowCurves.bounce        // Playful bounce animation
NumberFlowCurves.smoothFade    // Natural opacity transitions
NumberFlowCurves.spring()      // Configurable spring physics
NumberFlowCurves.anticipate    // Slow start, quick acceleration
```

**Usage Example:**

```dart
NumberFlow(
  value: myValue,
  spinCurve: NumberFlowCurves.elastic,
  opacityCurve: NumberFlowCurves.smoothFade,
  transformCurve: NumberFlowCurves.smoothSpin,
)
```

---

## 🎛️ Comprehensive API Reference

### Core Parameters

| Parameter  | Type         | Default      | Description                       |
| ---------- | ------------ | ------------ | --------------------------------- |
| `value`    | `num`        | **required** | The number to display and animate |
| `style`    | `TextStyle?` | `null`       | Text styling for the number       |
| `animated` | `bool`       | `true`       | Enable/disable all animations     |

### Text & Formatting

| Parameter           | Type         | Default | Description                          |
| ------------------- | ------------ | ------- | ------------------------------------ |
| `prefix`            | `String?`    | `null`  | Text before the number (e.g., "$")   |
| `suffix`            | `String?`    | `null`  | Text after the number (e.g., " USD") |
| `prefixStyle`       | `TextStyle?` | `null`  | Custom styling for prefix            |
| `suffixStyle`       | `TextStyle?` | `null`  | Custom styling for suffix            |
| `decimalPlaces`     | `int?`       | `null`  | Fixed decimal places                 |
| `useGroupSeparator` | `bool`       | `true`  | Add commas for thousands             |
| `showSign`          | `bool`       | `false` | Show + for positive numbers          |
| `locale`            | `String?`    | `null`  | Locale for number formatting         |

### Number Notation

| Parameter  | Type             | Default    | Description         |
| ---------- | ---------------- | ---------- | ------------------- |
| `notation` | `NumberNotation` | `standard` | Number format style |

**NumberNotation Options:**

- `NumberNotation.standard` → `1234567`
- `NumberNotation.compact` → `1.23M`
- `NumberNotation.scientific` → `1.23e6`
- `NumberNotation.engineering` → `1.235e6`

### Animation Control

| Parameter           | Type       | Default   | Description             |
| ------------------- | ---------- | --------- | ----------------------- |
| `transformDuration` | `Duration` | `600ms`   | Width transition timing |
| `spinDuration`      | `Duration` | `600ms`   | Digit spin timing       |
| `opacityDuration`   | `Duration` | `350ms`   | Fade transition timing  |
| `transformCurve`    | `Curve`    | `easeOut` | Width animation curve   |
| `spinCurve`         | `Curve`    | `easeOut` | Digit spin curve        |
| `opacityCurve`      | `Curve`    | `easeOut` | Opacity animation curve |

### Animation Behavior

| Parameter                 | Type              | Default | Description                       |
| ------------------------- | ----------------- | ------- | --------------------------------- |
| `trend`                   | `NumberFlowTrend` | `auto`  | Animation direction preference    |
| `isolate`                 | `bool`            | `false` | Disable group coordination        |
| `respectMotionPreference` | `bool`            | `true`  | Honor accessibility settings      |
| `willChange`              | `bool`            | `false` | Hint for performance optimization |

**NumberFlowTrend Options:**

- `NumberFlowTrend.auto` → Direction based on value change
- `NumberFlowTrend.up` → Always animate upward
- `NumberFlowTrend.down` → Always animate downward

### Callbacks

| Parameter             | Type            | Default | Description                    |
| --------------------- | --------------- | ------- | ------------------------------ |
| `onAnimationStart`    | `VoidCallback?` | `null`  | Called when animation begins   |
| `onAnimationComplete` | `VoidCallback?` | `null`  | Called when animation finishes |

---

## 🏗️ Advanced Features

### Grouped Animations

Coordinate multiple NumberFlow widgets:

```dart
NumberFlowGroup.row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Column(
      children: [
        Text('Price'),
        NumberFlow(
          value: stockPrice,
          prefix: '\$',
          decimalPlaces: 2,
        ),
      ],
    ),
    Column(
      children: [
        Text('Change'),
        NumberFlow(
          value: changePercent,
          suffix: '%',
          showSign: true,
          style: TextStyle(
            color: changePercent >= 0 ? Colors.green : Colors.red,
          ),
        ),
      ],
    ),
  ],
)
```

### Custom Styling Examples

#### Gradient Text Effect

```dart
NumberFlow(
  value: myValue,
  style: TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    foreground: Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue, Colors.purple],
      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
  ),
)
```

#### Different Styles for Components

```dart
NumberFlow(
  value: 1234.56,
  prefix: '\$',
  suffix: ' USD',
  style: TextStyle(fontSize: 32, color: Colors.green),
  prefixStyle: TextStyle(fontSize: 24, color: Colors.grey),
  suffixStyle: TextStyle(fontSize: 20, color: Colors.grey),
)
```

---

## 📱 Real-World Use Cases

### E-commerce Cart Total

```dart
NumberFlow(
  value: cartTotal,
  prefix: '\$',
  decimalPlaces: 2,
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  spinCurve: NumberFlowCurves.smoothSpin,
)
```

### Live Statistics Dashboard

```dart
Column(
  children: [
    NumberFlow(
      value: activeUsers,
      suffix: ' users online',
      notation: NumberNotation.compact,
    ),
    NumberFlow(
      value: revenue,
      prefix: '\$',
      notation: NumberNotation.compact,
      decimalPlaces: 1,
    ),
  ],
)
```

### Gaming Score Display

```dart
NumberFlow(
  value: playerScore,
  style: TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.amber,
  ),
  spinCurve: NumberFlowCurves.bounce,
)
```

### Financial Trading Interface

```dart
NumberFlow(
  value: stockPrice,
  prefix: '\$',
  decimalPlaces: 2,
  showSign: true,
  trend: NumberFlowTrend.auto,
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: stockPrice >= previousPrice ? Colors.green : Colors.red,
  ),
)
```

---

## 🎨 Design Philosophy

NumberFlow follows these design principles:

### 🌊 **Smooth & Natural**

- All animations use carefully crafted curves
- Transitions feel organic and pleasant
- No jarring or abrupt movements

### 🎯 **Performance First**

- Optimized for 60fps on all devices
- Minimal computational overhead
- Hardware-accelerated when possible

### ♿ **Accessible by Default**

- Respects system motion preferences
- Works with screen readers
- Follows Flutter accessibility guidelines

### 🎨 **Visually Polished**

- Faded edges during width transitions
- Coordinated timing across all elements
- Professional appearance out of the box

---

## 🔧 Migration & Compatibility

### From Basic Text Widgets

```dart
// Before
Text('${myNumber.toStringAsFixed(2)}')

// After
NumberFlow(
  value: myNumber,
  decimalPlaces: 2,
)
```

### Performance Considerations

- Use `animated: false` for static displays
- Consider `isolate: true` for independent animations
- Set `respectMotionPreference: false` if motion is essential

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **🐛 Bug Reports**: Open an issue with detailed reproduction steps
2. **✨ Feature Requests**: Suggest improvements or new features
3. **🔧 Pull Requests**: Submit code improvements or fixes
4. **📖 Documentation**: Help improve examples and guides

### Development Setup

```bash
git clone https://github.com/aghyad97/number-flow-flutter
cd number_flow
flutter packages get
cd example && flutter run
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Inspiration & Credits

This library is inspired by and aims to be a faithful Flutter port of the excellent [**number-flow**](https://github.com/barvian/number-flow) library by [Max Barvian](https://github.com/barvian).

---

<p align="center">
  <strong>Made with ❤️ for the Flutter community</strong>
</p>

<p align="center">
  <a href="https://github.com/aghyad97/number-flow-flutter">⭐ Star on GitHub</a> •
  <a href="https://pub.dev/packages/number_flow">📦 View on pub.dev</a> •
  <a href="https://github.com/aghyad97/number-flow-flutter/issues">🐛 Report Issues</a>
</p>
