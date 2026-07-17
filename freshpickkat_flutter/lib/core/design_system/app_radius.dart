import 'screen_scale.dart';

class AppRadius {
  AppRadius._();

  static double get small => ScreenScale.r(4);
  static double get medium => ScreenScale.r(8);
  static double get large => ScreenScale.r(12);
  static double get extraLarge => ScreenScale.r(16);
  static double get pill => 999;
  static double get circle => 9999;

  static double get button => ScreenScale.r(8);
  static double get card => ScreenScale.r(12);
  static double get input => ScreenScale.r(8);
  static double get dialog => ScreenScale.r(16);
  static double get sheet => ScreenScale.r(16);
  static double get badge => ScreenScale.r(4);
}
