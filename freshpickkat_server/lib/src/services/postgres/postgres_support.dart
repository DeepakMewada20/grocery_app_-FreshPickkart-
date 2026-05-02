import 'dart:convert';

import 'package:serverpod/serverpod.dart';

int clampPageLimit(
  int requested, {
  int defaultLimit = 20,
  int maxLimit = 50,
}) {
  if (requested <= 0) return defaultLimit;
  if (requested > maxLimit) return maxLimit;
  return requested;
}

String encodeCursor(Map<String, dynamic> data) {
  return base64Url.encode(utf8.encode(jsonEncode(data)));
}

Map<String, dynamic>? decodeCursor(String? token) {
  if (token == null || token.trim().isEmpty) return null;

  try {
    final decoded = utf8.decode(base64Url.decode(token));
    final json = jsonDecode(decoded);
    return json is Map<String, dynamic> ? json : null;
  } catch (_) {
    throw Exception('Invalid page token.');
  }
}

UuidValue parseUuid(
  String raw, {
  String fieldName = 'id',
}) {
  final value = raw.trim();
  if (value.isEmpty) {
    throw Exception('$fieldName is required.');
  }

  try {
    return UuidValue.withValidation(value);
  } on FormatException {
    throw Exception('Invalid $fieldName.');
  }
}

UuidValue? tryParseUuid(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  try {
    return UuidValue.withValidation(raw.trim());
  } on FormatException {
    return null;
  }
}

String? cleanNullableString(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

int asInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is BigInt) return value.toInt();
  if (value is num) return value.toInt();
  return int.parse(value.toString());
}

double asDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is BigInt) return value.toDouble();
  if (value is num) return value.toDouble();
  return double.parse(value.toString());
}

DateTime asDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.parse(value);
  throw Exception('Invalid datetime value.');
}
