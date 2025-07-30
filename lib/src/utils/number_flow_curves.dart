import 'package:flutter/animation.dart';
import 'dart:math' as math;

/// Custom animation curves specifically designed for NumberFlow animations
/// These curves provide smooth, natural-feeling transitions similar to the original number-flow library
class NumberFlowCurves {
  /// A smooth easing curve with a slight overshoot for digit spinning
  /// Similar to the original number-flow's smooth transitions
  static const Curve smoothSpin = _SmoothSpinCurve();

  /// An elastic curve for emphasis effects
  /// Used for scale animations and special transitions
  static const Curve elastic = _ElasticCurve();

  /// A bouncy curve for playful number transitions
  /// Great for counter animations and celebration effects
  static const Curve bounce = _BounceCurve();

  /// A smooth fade curve for opacity transitions
  /// Provides natural fade in/out effects
  static const Curve smoothFade = _SmoothFadeCurve();

  /// A spring-like curve with settable damping
  /// Mimics the spring physics of modern UI frameworks
  static Curve spring({double damping = 0.8, double velocity = 1.0}) {
    return _SpringCurve(damping: damping, velocity: velocity);
  }

  /// A curve that accelerates slowly then quickly
  /// Great for number changes that should feel responsive
  static const Curve anticipate = _AnticipateCurve();
}

/// Smooth spin curve with slight overshoot for natural digit movement
class _SmoothSpinCurve extends Curve {
  const _SmoothSpinCurve();

  @override
  double transformInternal(double t) {
    // Smooth ease-out with slight overshoot
    if (t < 0.5) {
      return 2 * t * t;
    } else {
      final f = t - 1;
      return 1 - 2 * f * f;
    }
  }
}

/// Elastic curve for bouncy animations
class _ElasticCurve extends Curve {
  const _ElasticCurve();

  @override
  double transformInternal(double t) {
    if (t == 0.0 || t == 1.0) return t;

    const double p = 0.3;
    const double s = p / 4.0;

    return math.pow(2.0, -10.0 * t) * math.sin((t - s) * (2.0 * math.pi) / p) +
        1.0;
  }
}

/// Bounce curve for playful animations
class _BounceCurve extends Curve {
  const _BounceCurve();

  @override
  double transformInternal(double t) {
    if (t < 1.0 / 2.75) {
      return 7.5625 * t * t;
    } else if (t < 2.0 / 2.75) {
      final t2 = t - 1.5 / 2.75;
      return 7.5625 * t2 * t2 + 0.75;
    } else if (t < 2.5 / 2.75) {
      final t2 = t - 2.25 / 2.75;
      return 7.5625 * t2 * t2 + 0.9375;
    } else {
      final t2 = t - 2.625 / 2.75;
      return 7.5625 * t2 * t2 + 0.984375;
    }
  }
}

/// Smooth fade curve for natural opacity transitions
class _SmoothFadeCurve extends Curve {
  const _SmoothFadeCurve();

  @override
  double transformInternal(double t) {
    // Smooth S-curve for natural fading
    return t * t * (3.0 - 2.0 * t);
  }
}

/// Spring curve with configurable damping
class _SpringCurve extends Curve {
  final double damping;
  final double velocity;

  const _SpringCurve({
    this.damping = 0.8,
    this.velocity = 1.0,
  });

  @override
  double transformInternal(double t) {
    if (t == 0.0 || t == 1.0) return t;

    final omega = math.sqrt(1.0 - damping * damping);
    final exponential = math.exp(-damping * velocity * t);
    final sinusoidal = math.sin(omega * velocity * t);

    return 1.0 -
        exponential *
            (math.cos(omega * velocity * t) + (damping / omega) * sinusoidal);
  }
}

/// Anticipate curve that starts slow then accelerates
class _AnticipateCurve extends Curve {
  const _AnticipateCurve();

  @override
  double transformInternal(double t) {
    // Anticipation effect - starts slow, then quick acceleration
    const double tension = 2.0;
    return t * t * ((tension + 1.0) * t - tension);
  }
}

/// Utility class for creating complex animation sequences
class NumberFlowAnimationSequence {
  /// Creates a staggered animation sequence for multiple digits
  static List<Curve> staggeredDigits({
    required int digitCount,
    double staggerDelay = 0.1,
    Curve baseCurve = NumberFlowCurves.smoothSpin,
  }) {
    return List.generate(digitCount, (index) {
      final delay = index * staggerDelay;
      return Interval(
        delay,
        1.0,
        curve: baseCurve,
      );
    });
  }

  /// Creates a wave-like animation pattern across digits
  static List<Curve> waveDigits({
    required int digitCount,
    double waveLength = 0.3,
    Curve baseCurve = NumberFlowCurves.smoothSpin,
  }) {
    return List.generate(digitCount, (index) {
      final progress = index / (digitCount - 1);
      final waveDelay = math.sin(progress * math.pi) * waveLength;
      return Interval(
        waveDelay,
        1.0,
        curve: baseCurve,
      );
    });
  }
}
