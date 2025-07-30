/// Configuration for individual digit positions in a number
///
/// This allows you to configure specific behavior for digits at different
/// positions. For example, in a time display like "12:59", you might want
/// to ensure the minutes digit has a max of 59.
class DigitConfig {
  /// Maximum value for this digit position
  ///
  /// When a digit reaches this maximum, it wraps to 0 on the next increment.
  /// This is useful for time displays, counters with limits, etc.
  final int? max;

  /// Minimum value for this digit position
  ///
  /// When a digit reaches this minimum, it wraps to max on the next decrement.
  final int? min;

  /// Whether this digit should wrap around when reaching min/max
  ///
  /// If false, the digit will stop at the min/max value instead of wrapping.
  final bool wrap;

  /// Custom animation duration for this specific digit
  ///
  /// If null, uses the widget's default spinDuration
  final Duration? animationDuration;

  const DigitConfig({
    this.max,
    this.min,
    this.wrap = true,
    this.animationDuration,
  });

  /// Creates a digit config for time minutes (0-59)
  factory DigitConfig.minutes() {
    return const DigitConfig(max: 59, min: 0);
  }

  /// Creates a digit config for time seconds (0-59)
  factory DigitConfig.seconds() {
    return const DigitConfig(max: 59, min: 0);
  }

  /// Creates a digit config for time hours in 12-hour format (1-12)
  factory DigitConfig.hours12() {
    return const DigitConfig(max: 12, min: 1);
  }

  /// Creates a digit config for time hours in 24-hour format (0-23)
  factory DigitConfig.hours24() {
    return const DigitConfig(max: 23, min: 0);
  }

  /// Creates a digit config for a single decimal digit (0-9)
  factory DigitConfig.digit() {
    return const DigitConfig(max: 9, min: 0);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DigitConfig &&
        other.max == max &&
        other.min == min &&
        other.wrap == wrap &&
        other.animationDuration == animationDuration;
  }

  @override
  int get hashCode {
    return Object.hash(max, min, wrap, animationDuration);
  }

  @override
  String toString() {
    return 'DigitConfig(max: $max, min: $min, wrap: $wrap, animationDuration: $animationDuration)';
  }
}
