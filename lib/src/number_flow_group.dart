import 'package:flutter/material.dart';

/// A simplified widget that groups multiple NumberFlow widgets
///
/// This is a basic implementation that simply wraps children.
/// In a full implementation, this would coordinate animations between
/// multiple NumberFlow widgets to prevent layout jumps.
class NumberFlowGroup extends StatelessWidget {
  /// The child widgets to group together
  final Widget child;

  /// Optional wrapper widget (e.g., Row, Column, Wrap)
  final Widget Function(Widget child)? wrapper;

  const NumberFlowGroup({
    super.key,
    required this.child,
    this.wrapper,
  });

  /// Convenience constructor for multiple children in a Row
  factory NumberFlowGroup.row({
    Key? key,
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.min,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return NumberFlowGroup(
      key: key,
      wrapper: (child) => Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
      child: const SizedBox.shrink(),
    );
  }

  /// Convenience constructor for multiple children in a Column
  factory NumberFlowGroup.column({
    Key? key,
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.min,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return NumberFlowGroup(
      key: key,
      wrapper: (child) => Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
      child: const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (wrapper != null) {
      return wrapper!(child);
    }
    return child;
  }
}
