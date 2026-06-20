import 'dart:math';

class IdGeneratorService {
  static final Random _random = Random();

  static String generateBannerId() {
    final number = _random.nextInt(999999).toString().padLeft(6, '0');
    return 'offerbanner_$number';
  }

  static String generateVariantId({
    required String productName,
    required int variantNumber,
    int quickNumberLength = 4,
  }) {
    final name = productName.trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final quickNum = _random
        .nextInt(
          quickNumberLength == 4
              ? 9999
              : quickNumberLength == 5
              ? 99999
              : 999999,
        )
        .toString()
        .padLeft(quickNumberLength, '0');

    return '${name}v$variantNumber$quickNum';
  }

  static int generateQuickNumber({int length = 4}) {
    final max = length == 4
        ? 9999
        : length == 5
        ? 99999
        : 999999;
    return _random.nextInt(max) + 1;
  }
}
