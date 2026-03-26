import 'dart:math';

class IdGenerator {
  static final Random _random = Random();

  static String generateBannerId() {
    final number = _random.nextInt(999999).toString().padLeft(6, '0');
    return 'offerbanner_$number';
  }
}
