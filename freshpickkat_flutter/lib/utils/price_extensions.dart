extension PriceFormatter on double {
  /// Simple formatter to show 100 instead of 100.0, but keep decimals if they exist.
  String get formatPrice {
    if (this % 1 == 0) {
      return toInt().toString();
    }
    // For values like 100.78, this will return "100.78"
    // For values like 100.5, this will return "100.5"
    String s = toString();
    if (s.contains('.')) {
      // Sometimes toString() can result in 100.0 if not careful or floating point precision
      s = s.replaceAll(RegExp(r'\.0$'), '');
    }
    return s;
  }
}
