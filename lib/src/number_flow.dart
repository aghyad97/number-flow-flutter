import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'models/number_flow_trend.dart';
import 'models/digit_config.dart';
import 'plugins/continuous_plugin.dart';
import 'utils/number_formatter.dart';

/// Main NumberFlow widget for animated number transitions
class NumberFlow extends StatefulWidget {
  /// The number value to display
  final num value;

  /// Optional prefix text
  final String? prefix;

  /// Optional suffix text
  final String? suffix;

  /// Number formatting options
  final String? locale;
  final int? decimalPlaces;
  final bool useGroupSeparator;
  final String? currencySymbol;
  final bool showSign;
  final NumberNotation notation;

  /// Animation timing configurations
  final Duration transformDuration;
  final Duration spinDuration;
  final Duration opacityDuration;
  final Curve transformCurve;
  final Curve spinCurve;
  final Curve opacityCurve;

  /// Animation behavior
  final NumberFlowTrend trend;
  final bool isolate;
  final bool animated;
  final bool respectMotionPreference;
  final bool willChange;

  /// Digit configuration
  final Map<int, DigitConfig> digits;

  /// Plugins
  final List<NumberFlowPlugin> plugins;

  /// Styling
  final TextStyle? style;
  final TextStyle? prefixStyle;
  final TextStyle? suffixStyle;

  /// Callbacks
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationComplete;

  const NumberFlow({
    Key? key,
    required this.value,
    this.prefix,
    this.suffix,
    this.locale,
    this.decimalPlaces,
    this.useGroupSeparator = true,
    this.currencySymbol,
    this.showSign = false,
    this.notation = NumberNotation.standard,
    this.transformDuration = const Duration(milliseconds: 600),
    this.spinDuration = const Duration(milliseconds: 600),
    this.opacityDuration = const Duration(milliseconds: 350),
    this.transformCurve = Curves.easeOut,
    this.spinCurve = Curves.easeOut,
    this.opacityCurve = Curves.easeOut,
    this.trend = NumberFlowTrend.auto,
    this.isolate = false,
    this.animated = true,
    this.respectMotionPreference = true,
    this.willChange = false,
    this.digits = const {},
    this.plugins = const [],
    this.style,
    this.prefixStyle,
    this.suffixStyle,
    this.onAnimationStart,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<NumberFlow> createState() => NumberFlowState();
}

class NumberFlowState extends State<NumberFlow> with TickerProviderStateMixin {
  late AnimationController _transformController;
  late AnimationController _spinController;
  late AnimationController _opacityController;

  late Animation<double> _transformAnimation;
  late Animation<double> _spinAnimation;
  late Animation<double> _opacityAnimation;

  num _previousValue = 0;
  String _currentText = '';
  String _previousText = '';
  List<_DigitTransition> _digitTransitions = [];

  // Group integration - forward declaration, will be set in didChangeDependencies
  dynamic _group;

  @override
  void initState() {
    super.initState();

    _transformController = AnimationController(
      duration: widget.transformDuration,
      vsync: this,
    );

    _spinController = AnimationController(
      duration: widget.spinDuration,
      vsync: this,
    );

    _opacityController = AnimationController(
      duration: widget.opacityDuration,
      vsync: this,
    );

    _transformAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transformController,
      curve: widget.transformCurve,
    ));

    _spinAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _spinController,
      curve: widget.spinCurve,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _opacityController,
      curve: widget.opacityCurve,
    ));

    _previousValue = widget.value;
    _updateText();

    // Apply plugins
    for (final plugin in widget.plugins) {
      plugin.apply(this);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Register with NumberFlowGroup if present - will be implemented when group is available
    // final groupData = NumberFlowGroup.of(context);
    // if (groupData != null) {
    //   _group = groupData.group;
    //   _group!.registerNumberFlow(this);
    // }
  }

  @override
  void didUpdateWidget(NumberFlow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value && widget.animated) {
      _animateToNewValue(oldWidget.value, widget.value);
    } else if (!widget.animated) {
      _previousValue = widget.value;
      _updateText();
    }

    // Update animation controllers if durations changed
    if (oldWidget.transformDuration != widget.transformDuration) {
      _transformController.duration = widget.transformDuration;
    }
    if (oldWidget.spinDuration != widget.spinDuration) {
      _spinController.duration = widget.spinDuration;
    }
    if (oldWidget.opacityDuration != widget.opacityDuration) {
      _opacityController.duration = widget.opacityDuration;
    }
  }

  void _animateToNewValue(num oldValue, num newValue) {
    _previousValue = oldValue;
    _previousText = _currentText;

    setState(() {
      _updateText();
      _prepareDigitTransitions(oldValue, newValue);
    });

    widget.onAnimationStart?.call();

    // Coordinate with group if present
    if (_group != null && !widget.isolate) {
      // _group!.coordinateAnimations();
      _startAnimation(); // For now, start animation directly
    } else {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _transformController.reset();
    _spinController.reset();
    _opacityController.reset();

    _transformController.forward();
    _spinController.forward();
    _opacityController.forward().then((_) {
      widget.onAnimationComplete?.call();
    });
  }

  void _updateText() {
    _currentText = NumberFormatter.format(
      widget.value,
      locale: widget.locale,
      decimalPlaces: widget.decimalPlaces,
      useGroupSeparator: widget.useGroupSeparator,
      currencySymbol: widget.currencySymbol,
      showSign: widget.showSign,
      // Don't include prefix/suffix in the core text - handle separately
      notation: widget.notation,
    );
  }

  void _prepareDigitTransitions(num oldValue, num newValue) {
    final oldString = NumberFormatter.format(
      oldValue,
      locale: widget.locale,
      decimalPlaces: widget.decimalPlaces,
      useGroupSeparator: widget.useGroupSeparator,
      currencySymbol: widget.currencySymbol,
      showSign: widget.showSign,
      prefix: widget.prefix,
      suffix: widget.suffix,
      notation: widget.notation,
    );
    final newString = _currentText;

    _digitTransitions.clear();

    final maxLength = math.max(oldString.length, newString.length);

    for (int i = 0; i < maxLength; i++) {
      final oldChar = i < oldString.length ? oldString[i] : '';
      final newChar = i < newString.length ? newString[i] : '';

      if (oldChar != newChar && _isDigit(oldChar) && _isDigit(newChar)) {
        final oldDigit = int.tryParse(oldChar) ?? 0;
        final newDigit = int.tryParse(newChar) ?? 0;

        // Apply digit configuration if available
        final digitConfig = widget.digits[i];
        final adjustedTransition = _applyDigitConfig(
          oldDigit,
          newDigit,
          digitConfig,
        );

        _digitTransitions.add(_DigitTransition(
          position: i,
          fromDigit: adjustedTransition.fromDigit,
          toDigit: adjustedTransition.toDigit,
          direction: widget.trend.getDirection(oldValue, newValue),
          config: digitConfig,
          forcedDirection: _generateRandomDirection(),
        ));
      }
    }
  }

  _DigitTransitionData _applyDigitConfig(
    int oldDigit,
    int newDigit,
    DigitConfig? config,
  ) {
    if (config == null) {
      return _DigitTransitionData(fromDigit: oldDigit, toDigit: newDigit);
    }

    // Apply min/max constraints
    int adjustedOld = oldDigit;
    int adjustedNew = newDigit;

    if (config.max != null) {
      adjustedOld = math.min(adjustedOld, config.max!);
      adjustedNew = math.min(adjustedNew, config.max!);
    }

    if (config.min != null) {
      adjustedOld = math.max(adjustedOld, config.min!);
      adjustedNew = math.max(adjustedNew, config.min!);
    }

    return _DigitTransitionData(
      fromDigit: adjustedOld,
      toDigit: adjustedNew,
    );
  }

  bool _isDigit(String char) {
    return char.isNotEmpty && int.tryParse(char) != null;
  }

  /// Generate a random direction for individual digit animations
  int _generateRandomDirection() {
    final random = math.Random();
    // 50% up, 50% down
    return random.nextBool() ? 1 : -1;
  }

  @override
  Widget build(BuildContext context) {
    // Ensure we have valid text before building
    if (_currentText.isEmpty) {
      _updateText();
    }

    // Respect motion preferences if enabled
    if (widget.respectMotionPreference) {
      final mediaQuery = MediaQuery.of(context);
      if (mediaQuery.disableAnimations) {
        return _buildStaticText();
      }
    }

    if (!widget.animated) {
      return _buildStaticText();
    }

    return AnimatedBuilder(
      animation: Listenable.merge(
          [_transformAnimation, _spinAnimation, _opacityAnimation]),
      builder: (context, child) {
        return _buildAnimatedText();
      },
    );
  }

  Widget _buildStaticText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.prefix != null)
          Text(
            widget.prefix!,
            style: widget.prefixStyle ?? widget.style,
          ),
        Text(
          _currentText,
          style: widget.style,
        ),
        if (widget.suffix != null)
          Text(
            widget.suffix!,
            style: widget.suffixStyle ?? widget.style,
          ),
      ],
    );
  }

  Widget _buildAnimatedText() {
    final lineHeight = (widget.style?.fontSize ?? 14.0) * 1.2;

    return AnimatedSize(
      duration: widget.transformDuration,
      curve: widget.transformCurve,
      alignment: Alignment.center,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.0),
              Colors.black.withOpacity(1.0),
              Colors.black.withOpacity(1.0),
              Colors.black.withOpacity(0.0),
            ],
            stops: const [0.0, 0.02, 0.98, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: SizedBox(
            height: lineHeight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.prefix != null)
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                      opacity: 1.0, // Keep prefix always visible
                      duration: widget.opacityDuration,
                      child: Text(
                        widget.prefix!,
                        style: widget.prefixStyle ?? widget.style,
                      ),
                    ),
                  ),
                ..._buildAnimatedDigits(),
                if (widget.suffix != null)
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                      opacity: 1.0, // Keep suffix always visible
                      duration: widget.opacityDuration,
                      child: Text(
                        widget.suffix!,
                        style: widget.suffixStyle ?? widget.style,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedDigits() {
    final List<Widget> widgets = [];

    for (int i = 0; i < _currentText.length; i++) {
      final char = _currentText[i];

      if (_isDigit(char)) {
        final transition = _digitTransitions.firstWhere(
          (t) => t.position == i,
          orElse: () => _DigitTransition(
            position: i,
            fromDigit: int.tryParse(char) ?? 0,
            toDigit: int.tryParse(char) ?? 0,
            direction: 0,
          ),
        );
        widgets.add(_buildAnimatedDigit(transition));
      } else {
        // For non-digit characters (commas, dots, etc.)
        widgets.add(
          SizedBox(
            height: (widget.style?.fontSize ?? 14.0) * 1.2,
            child: Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: 1.0, // Keep non-digits always visible
                duration: widget.opacityDuration,
                child: Text(
                  char,
                  style: widget.style,
                ),
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildAnimatedDigit(_DigitTransition transition) {
    if (transition.fromDigit == transition.toDigit) {
      return Text(
        transition.toDigit.toString(),
        style: widget.style,
      );
    }

    final fontSize = widget.style?.fontSize ?? 14.0;
    final lineHeight = fontSize * 1.2;

    // Use the random direction if available, otherwise fall back to trend direction
    final effectiveDirection =
        transition.forcedDirection ?? transition.direction;

    // Measure the digit width to ensure proper sizing
    final textPainter = TextPainter(
      text: TextSpan(text: '0', style: widget.style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final digitWidth = textPainter.width;

    return ClipRect(
      child: SizedBox(
        width: digitWidth,
        height: lineHeight,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Outgoing digit
            Positioned(
              left: 0,
              top: _spinAnimation.value * lineHeight * -effectiveDirection,
              width: digitWidth,
              child: Opacity(
                opacity: 1 - _opacityAnimation.value,
                child: Text(
                  transition.fromDigit.toString(),
                  style: widget.style,
                ),
              ),
            ),
            // Incoming digit
            Positioned(
              left: 0,
              top: (1 - _spinAnimation.value) * lineHeight * effectiveDirection,
              width: digitWidth,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Text(
                  transition.toDigit.toString(),
                  style: widget.style,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Start a coordinated animation (called by NumberFlowGroup)
  Future<void> startCoordinatedAnimation() async {
    _startAnimation();

    // Wait for animation to complete
    await Future.wait([
      _transformController.forward(),
      _spinController.forward(),
      _opacityController.forward(),
    ]);
  }

  /// Check if this NumberFlow is currently animating
  bool get isAnimating {
    return _transformController.isAnimating ||
        _spinController.isAnimating ||
        _opacityController.isAnimating;
  }

  @override
  void dispose() {
    // Unregister from group
    // _group?.unregisterNumberFlow(this);

    // Dispose plugins
    for (final plugin in widget.plugins) {
      plugin.dispose();
    }

    _transformController.dispose();
    _spinController.dispose();
    _opacityController.dispose();
    super.dispose();
  }
}

/// Helper class for digit transition data
class _DigitTransition {
  final int position;
  final int fromDigit;
  final int toDigit;
  final int direction;
  final DigitConfig? config;
  final int? forcedDirection; // Override for random directions

  _DigitTransition({
    required this.position,
    required this.fromDigit,
    required this.toDigit,
    required this.direction,
    this.config,
    this.forcedDirection,
  });
}

/// Helper class for applying digit configuration
class _DigitTransitionData {
  final int fromDigit;
  final int toDigit;

  _DigitTransitionData({
    required this.fromDigit,
    required this.toDigit,
  });
}
