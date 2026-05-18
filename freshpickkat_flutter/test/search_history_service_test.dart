import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freshpickkat_flutter/services/search_history_service.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const containerPrefix = 'search_history_service_test';
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  var containerIndex = 0;
  late Directory suiteDir;
  late GetStorage storage;
  late SearchHistoryService service;

  setUpAll(() async {
    suiteDir = await Directory.systemTemp.createTemp('freshpickkat_search_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
          if (call.method == 'getApplicationDocumentsDirectory') {
            return suiteDir.path;
          }
          return null;
        });
  });

  tearDownAll(() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    await suiteDir.delete(recursive: true);
  });

  setUp(() async {
    storage = GetStorage(
      '$containerPrefix${containerIndex++}',
      suiteDir.path,
    );
    await storage.initStorage;
    await storage.erase();
    service = SearchHistoryService(storage: storage);
  });

  tearDown(() async {
    await storage.erase();
  });

  test('moves duplicate query to top', () async {
    await service.saveSearch('Milk');
    await service.saveSearch('Bread');
    final searches = await service.saveSearch('milk');

    expect(searches, ['milk', 'Bread']);
    expect(service.loadRecentSearch(), ['milk', 'Bread']);
  });

  test('keeps latest query at top and max 10 items', () async {
    for (var i = 0; i < 12; i++) {
      await service.saveSearch('Item $i');
    }

    final searches = service.loadRecentSearch();

    expect(searches, hasLength(10));
    expect(searches.first, 'Item 11');
    expect(searches.last, 'Item 2');
  });

  test('removes a single search', () async {
    await service.saveSearch('Milk');
    await service.saveSearch('Bread');

    final searches = await service.removeSearch('milk');

    expect(searches, ['Bread']);
    expect(service.loadRecentSearch(), ['Bread']);
  });

  test('clears all searches', () async {
    await service.saveSearch('Milk');
    await service.saveSearch('Bread');

    await service.clearAll();

    expect(service.loadRecentSearch(), isEmpty);
  });
}
