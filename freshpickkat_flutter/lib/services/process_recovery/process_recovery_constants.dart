class ProcessRecoveryConstants {
  ProcessRecoveryConstants._();

  static const String keyRoute = 'pr_route';
  static const String keyArgs = 'pr_args';
  static const String keyTimestamp = 'pr_ts';

  static const Duration expiryDuration = Duration(minutes: 3);

  static const Set<String> blockedPatterns = {
    '/splash',
    '/login',
    '/phone-auth',
  };

  static const Set<String> registeredGetPages = {
    '/home',
    '/checkout',
    '/offers',
    '/combo-offers',
    '/coupons',
    '/location-picker',
    '/product/',
    '/category/',
    '/offer/',
  };

  static bool isRegisteredRoute(String route) =>
      registeredGetPages.any((p) => route.startsWith(p));

  static bool isBlocked(String route) =>
      blockedPatterns.any((p) => route.startsWith(p));
}
