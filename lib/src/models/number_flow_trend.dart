/// Enum for controlling the animation direction of digit transitions
enum NumberFlowTrend {
  /// Always animate digits upward (0→1→2→...→9→0)
  up,

  /// Always animate digits downward (9→8→7→...→0→9)
  down,

  /// Animate based on the actual number change direction
  /// - If new value > old value: animate up
  /// - If new value < old value: animate down
  /// - If values are equal: no animation
  auto,
}

extension NumberFlowTrendExtension on NumberFlowTrend {
  /// Get the animation direction for a given value change
  int getDirection(num oldValue, num newValue) {
    switch (this) {
      case NumberFlowTrend.up:
        return 1;
      case NumberFlowTrend.down:
        return -1;
      case NumberFlowTrend.auto:
        if (oldValue == newValue) return 0;
        return newValue > oldValue ? 1 : -1;
    }
  }
}
