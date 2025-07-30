import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../number_flow.dart';

/// Plugin interface for NumberFlow extensions
abstract class NumberFlowPlugin {
  /// Apply the plugin to a NumberFlow widget state
  void apply(NumberFlowState state);

  /// Clean up any resources when the plugin is removed
  void dispose() {}
}

/// Plugin that makes number transitions appear to pass through intermediate values
///
/// Instead of directly animating from the old value to the new value,
/// this plugin creates the illusion that the number is counting through
/// all the intermediate values at high speed.
class ContinuousPlugin implements NumberFlowPlugin {
  /// Duration for each intermediate step
  final Duration stepDuration;

  /// Maximum number of intermediate steps to show
  final int maxSteps;

  /// Whether to show fractional intermediate values
  final bool showFractionalSteps;

  Timer? _timer;
  StreamSubscription? _subscription;

  ContinuousPlugin({
    this.stepDuration = const Duration(milliseconds: 50),
    this.maxSteps = 20,
    this.showFractionalSteps = false,
  });

  @override
  void apply(NumberFlowState state) {
    // This would integrate with the NumberFlow state to create
    // intermediate value animations
    _setupContinuousAnimation(state);
  }

  void _setupContinuousAnimation(NumberFlowState state) {
    // Listen for value changes and create intermediate animations
    // This is a simplified implementation - in practice, this would
    // need to integrate more deeply with the NumberFlow widget's
    // animation system
  }

  /// Calculate intermediate values between old and new values
  List<num> calculateIntermediateValues(num oldValue, num newValue) {
    if (oldValue == newValue) return [newValue];

    final difference = newValue - oldValue;
    final steps = math.min(maxSteps, difference.abs().ceil());

    if (steps <= 1) return [newValue];

    final List<num> values = [];
    final stepSize = difference / steps;

    for (int i = 1; i <= steps; i++) {
      final intermediateValue = oldValue + (stepSize * i);

      if (showFractionalSteps) {
        values.add(intermediateValue);
      } else {
        values.add(intermediateValue.round());
      }
    }

    // Ensure we end with the exact target value
    if (values.isNotEmpty && values.last != newValue) {
      values[values.length - 1] = newValue;
    }

    return values;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _subscription?.cancel();
  }
}

/// Plugin for customizing easing curves with spring physics
class SpringPlugin implements NumberFlowPlugin {
  /// Spring stiffness (higher = faster animation)
  final double stiffness;

  /// Spring damping (higher = less bouncy)
  final double damping;

  /// Mass of the spring system
  final double mass;

  const SpringPlugin({
    this.stiffness = 100.0,
    this.damping = 10.0,
    this.mass = 1.0,
  });

  @override
  void apply(NumberFlowState state) {
    // This would apply custom spring physics to the animations
    // Implementation would depend on the animation system
  }

  /// Create a spring curve with the given parameters
  Curve createSpringCurve() {
    // This is a simplified spring curve implementation
    // In practice, you'd want a more sophisticated spring physics implementation
    return Curves.elasticOut;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}

/// Plugin for adding sound effects to number transitions
class SoundPlugin implements NumberFlowPlugin {
  /// Callback to play sound when animation starts
  final VoidCallback? onAnimationStart;

  /// Callback to play sound when animation completes
  final VoidCallback? onAnimationComplete;

  /// Callback to play sound for each digit change
  final VoidCallback? onDigitChange;

  const SoundPlugin({
    this.onAnimationStart,
    this.onAnimationComplete,
    this.onDigitChange,
  });

  @override
  void apply(NumberFlowState state) {
    // This would integrate with the NumberFlow's callback system
    // to trigger sounds at appropriate times
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
