import 'dart:math' as math;

/// Utility class for formatting numbers with various options
class NumberFormatter {
  /// Format a number with the given options
  static String format(
    num value, {
    String? locale,
    int? decimalPlaces,
    bool useGroupSeparator = true,
    String? currencySymbol,
    bool showSign = false,
    String? prefix,
    String? suffix,
    NumberNotation notation = NumberNotation.standard,
  }) {
    String result = _formatCore(
      value,
      decimalPlaces: decimalPlaces,
      notation: notation,
    );

    if (useGroupSeparator &&
        value.abs() >= 1000 &&
        notation == NumberNotation.standard) {
      result = _addGroupSeparator(result);
    }

    if (showSign && value > 0) {
      result = '+$result';
    }

    if (currencySymbol != null) {
      result = '$currencySymbol$result';
    }

    if (prefix != null) {
      result = '$prefix$result';
    }

    if (suffix != null) {
      result = '$result$suffix';
    }

    return result;
  }

  /// Core number formatting logic
  static String _formatCore(
    num value, {
    int? decimalPlaces,
    NumberNotation notation = NumberNotation.standard,
  }) {
    switch (notation) {
      case NumberNotation.standard:
        if (decimalPlaces != null) {
          return value.toStringAsFixed(decimalPlaces);
        }
        return value.toString();

      case NumberNotation.compact:
        return _formatCompact(value, decimalPlaces: decimalPlaces);

      case NumberNotation.scientific:
        return value.toStringAsExponential(decimalPlaces ?? 2);

      case NumberNotation.engineering:
        return _formatEngineering(value, decimalPlaces: decimalPlaces);
    }
  }

  /// Format number in compact notation (e.g., 1.2K, 3.4M, 5.6B)
  static String _formatCompact(num value, {int? decimalPlaces}) {
    final absValue = value.abs();
    final isNegative = value < 0;

    String suffix = '';
    double scaledValue = absValue.toDouble();

    if (absValue >= 1e12) {
      scaledValue = absValue / 1e12;
      suffix = 'T';
    } else if (absValue >= 1e9) {
      scaledValue = absValue / 1e9;
      suffix = 'B';
    } else if (absValue >= 1e6) {
      scaledValue = absValue / 1e6;
      suffix = 'M';
    } else if (absValue >= 1e3) {
      scaledValue = absValue / 1e3;
      suffix = 'K';
    }

    final places = decimalPlaces ?? (scaledValue >= 10 ? 0 : 1);
    String result = scaledValue.toStringAsFixed(places);

    // Remove unnecessary trailing zeros
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'\.?0+$'), '');
    }

    return '${isNegative ? '-' : ''}$result$suffix';
  }

  /// Format number in engineering notation
  static String _formatEngineering(num value, {int? decimalPlaces}) {
    if (value == 0) return '0';

    final absValue = value.abs();
    final isNegative = value < 0;
    final log10 = math.log(absValue) / math.ln10;
    final exponent = (log10 / 3).floor() * 3;
    final coefficient = absValue / math.pow(10, exponent);

    final places = decimalPlaces ?? 2;
    String result = coefficient.toStringAsFixed(places);

    // Remove unnecessary trailing zeros
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'\.?0+$'), '');
    }

    return '${isNegative ? '-' : ''}${result}e$exponent';
  }

  /// Add group separators (commas) to a number string
  static String _addGroupSeparator(String number, {String separator = ','}) {
    final parts = number.split('.');
    String integerPart = parts[0];
    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Handle negative sign
    final isNegative = integerPart.startsWith('-');
    if (isNegative) {
      integerPart = integerPart.substring(1);
    }

    // Add separators to integer part
    String result = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        result += separator;
      }
      result += integerPart[i];
    }

    return '${isNegative ? '-' : ''}$result$decimalPart';
  }

  /// Parse a formatted number string back to a number
  static num? parse(String formattedNumber) {
    if (formattedNumber.isEmpty) return null;

    // Remove common formatting characters
    String cleaned =
        formattedNumber.replaceAll(',', '').replaceAll(' ', '').trim();

    // Handle compact notation
    final compactMatch =
        RegExp(r'^([+-]?\d*\.?\d+)([KMBT])$', caseSensitive: false)
            .firstMatch(cleaned);
    if (compactMatch != null) {
      final numPart = double.tryParse(compactMatch.group(1)!);
      final suffix = compactMatch.group(2)!.toUpperCase();
      if (numPart != null) {
        switch (suffix) {
          case 'K':
            return numPart * 1e3;
          case 'M':
            return numPart * 1e6;
          case 'B':
            return numPart * 1e9;
          case 'T':
            return numPart * 1e12;
        }
      }
    }

    // Handle standard number parsing
    return num.tryParse(cleaned);
  }

  /// Check if a string represents a valid formatted number
  static bool isValidNumber(String value) {
    return parse(value) != null;
  }
}

/// Number notation styles
enum NumberNotation {
  /// Standard decimal notation (123456.78)
  standard,

  /// Compact notation with suffixes (123.5K, 1.2M)
  compact,

  /// Scientific notation (1.23e5)
  scientific,

  /// Engineering notation (123.5e3)
  engineering,
}
