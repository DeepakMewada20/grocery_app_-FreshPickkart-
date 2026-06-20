import 'dart:io';

class EnvService {
  static final Map<String, String> _fileValues = {};
  static bool _loaded = false;

  static void _loadFile([String path = '.env']) {
    if (_loaded) return;
    _loaded = true;

    final file = File(path);
    if (!file.existsSync()) return;

    for (final line in file.readAsLinesSync()) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      final idx = trimmed.indexOf('=');
      if (idx <= 0) continue;

      final key = trimmed.substring(0, idx).trim();
      var value = trimmed.substring(idx + 1).trim();

      if ((value.startsWith('"') && value.endsWith('"')) ||
          (value.startsWith("'") && value.endsWith("'"))) {
        value = value.substring(1, value.length - 1);
      }

      _fileValues[key] = value;
    }
  }

  static String? get(
    String key, {
    String path = '.env',
    List<String> fallbacks = const [],
  }) {
    if (!_loaded) {
      _loadFile(path);
    }
    final fromEnv = Platform.environment[key] ?? _fileValues[key];
    if (fromEnv != null && fromEnv.isNotEmpty) {
      return fromEnv;
    }
    for (final fallback in fallbacks) {
      final value = Platform.environment[fallback] ?? _fileValues[fallback];
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}
