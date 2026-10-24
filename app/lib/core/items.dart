import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

const _idAlphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';
final _random = Random.secure();

/// Random PocketBase compatible record id (15 chars, a-z0-9).
String newRecordId() =>
    List.generate(15, (_) => _idAlphabet[_random.nextInt(_idAlphabet.length)])
        .join();

/// Display form of a typed item name: trimmed, single spaces.
String cleanItemName(String input) =>
    input.trim().replaceAll(RegExp(r'\s+'), ' ');

/// Key for duplicate detection: case and whitespace insensitive.
String normalizeItemName(String input) => cleanItemName(input).toLowerCase();

/// Deterministic catalog id per household + name, so two devices that add the
/// same new item offline end up with the same record instead of a duplicate.
String catalogItemId(String householdId, String normalizedName) {
  final digest =
      sha256.convert(utf8.encode('$householdId|$normalizedName')).bytes;
  return digest.take(15).map((b) => _idAlphabet[b % 36]).join();
}

/// "Frequently bought" score: purchase count, weighted towards recent buys.
/// A purchase 30 days ago counts half as much as one today.
double frequencyScore(int purchaseCount, DateTime? lastPurchased, DateTime now) {
  if (purchaseCount <= 0) return 0;
  final ageDays = lastPurchased == null
      ? 365.0
      : max(0, now.difference(lastPurchased).inHours / 24.0);
  return purchaseCount / (1 + ageDays / 30);
}
