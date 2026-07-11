import 'package:get_storage/get_storage.dart';
import 'package:freshpickkat_flutter/services/process_recovery/process_recovery_constants.dart';
import 'package:freshpickkat_flutter/services/process_recovery/process_recovery_models.dart';

class ProcessRecoveryStorage {
  final _box = GetStorage();

  void save(SavedRouteState state) {
    final json = state.toJson();
    _box.write(ProcessRecoveryConstants.keyRoute, json['route']);
    _box.write(ProcessRecoveryConstants.keyArgs, json['argumentsJson']);
    _box.write(ProcessRecoveryConstants.keyTimestamp, json['timestamp']);
  }

  SavedRouteState? load() {
    final route = _box.read<String>(ProcessRecoveryConstants.keyRoute);
    final args = _box.read<String?>(ProcessRecoveryConstants.keyArgs);
    final ts = _box.read<String?>(ProcessRecoveryConstants.keyTimestamp);
    if (route == null || route.isEmpty || ts == null) return null;
    return SavedRouteState(
      route: route,
      argumentsJson: args,
      timestamp: DateTime.parse(ts),
    );
  }

  void clear() {
    _box.remove(ProcessRecoveryConstants.keyRoute);
    _box.remove(ProcessRecoveryConstants.keyArgs);
    _box.remove(ProcessRecoveryConstants.keyTimestamp);
  }
}
