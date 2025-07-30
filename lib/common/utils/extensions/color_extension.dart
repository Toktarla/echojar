import 'package:flutter/material.dart';

extension ColorHexExtension on Color {
  /// Converts a [Color] to hex string like '#RRGGBB' or '#AARRGGBB' if includeAlpha is true
  String toHex({bool includeAlpha = true}) {
    final alpha = includeAlpha ? alphaComponent : '';
    return '#$alpha${redComponent}${greenComponent}${blueComponent}';
  }

  String get alphaComponent => alpha.toRadixString(16).padLeft(2, '0').toUpperCase();
  String get redComponent => red.toRadixString(16).padLeft(2, '0').toUpperCase();
  String get greenComponent => green.toRadixString(16).padLeft(2, '0').toUpperCase();
  String get blueComponent => blue.toRadixString(16).padLeft(2, '0').toUpperCase();
}

extension HexColorParsing on String {
  /// Converts a hex string (with or without '#') to a [Color].
  /// Accepts '#RRGGBB', 'RRGGBB', '#AARRGGBB', or 'AARRGGBB'
  Color toColor() {
    final hex = replaceAll('#', '').toUpperCase();
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16)); // Default alpha = FF
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    } else {
      throw FormatException('Invalid hex color format');
    }
  }
}
