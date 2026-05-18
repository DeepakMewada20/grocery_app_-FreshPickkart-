import 'package:get_storage/get_storage.dart';

class SearchHistoryService {
  SearchHistoryService({GetStorage? storage})
    : _storage = storage ?? GetStorage();

  static const String key = 'recent_searches';
  static const int maxItems = 10;

  final GetStorage _storage;

  List<String> loadRecentSearch() {
    final raw = _storage.read<List<dynamic>>(key);
    if (raw == null) return const <String>[];

    return raw
        .whereType<String>()
        .map((query) => query.trim())
        .where((query) => query.isNotEmpty)
        .take(maxItems)
        .toList();
  }

  Future<List<String>> saveSearch(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) return loadRecentSearch();

    final updated = [
      normalizedQuery,
      ...loadRecentSearch().where(
        (item) => item.toLowerCase() != normalizedQuery.toLowerCase(),
      ),
    ].take(maxItems).toList();

    await _storage.write(key, updated);
    return updated;
  }

  Future<List<String>> removeSearch(String query) async {
    final normalizedQuery = query.trim().toLowerCase();
    final updated = loadRecentSearch()
        .where((item) => item.toLowerCase() != normalizedQuery)
        .toList();

    await _storage.write(key, updated);
    return updated;
  }

  Future<void> clearAll() {
    return _storage.remove(key);
  }
}
