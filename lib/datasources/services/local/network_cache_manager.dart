import 'dart:convert';
import 'local_storage_service.dart';

/// A robust cache manager for saving and retrieving JSON API responses.
class NetworkCacheManager {
  static const Duration _defaultCacheDuration = Duration(seconds: 45);

  /// Save JSON data to cache with a timestamp.
  static Future<void> saveJson({
    required String key,
    required Map<String, dynamic> jsonData,
    Duration? cacheDuration,
  }) async {
    // Always replace existing data: clear old cache first
    await LocalStorageServices.deleteData(_dataKey(key));
    await LocalStorageServices.deleteData(_timeKey(key));
    final now = DateTime.now().millisecondsSinceEpoch;
    await LocalStorageServices.setData(_dataKey(key), jsonEncode(jsonData));
    await LocalStorageServices.setIntData(_timeKey(key), now);
  }

  /// Retrieve JSON data from cache if valid, else remove and return null.
  static Future<Map<String, dynamic>?> getJson({
    required String key,
    Duration? cacheDuration,
  }) async {
    final duration = cacheDuration ?? _defaultCacheDuration;
    final dataKey = _dataKey(key);
    final timeKey = _timeKey(key);

    final hasData = await LocalStorageServices.iskeyexists(dataKey);
    final hasTime = LocalStorageServices.iskeyexists(timeKey);
    if (!hasData || !hasTime) {
      _remove(key);
      return null;
    }

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(
      LocalStorageServices.getIntData(timeKey),
    );
    final isValid = DateTime.now().difference(cacheTime) <= duration;
    if (!isValid) {
      _remove(key);
      return null;
    }

    try {
      final raw = LocalStorageServices.getData(dataKey);
      if (raw.isEmpty) {
        _remove(key);
        return null;
      }
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        _remove(key);
        return null;
      }
    } catch (_) {
      _remove(key);
      return null;
    }
  }

  /// Remove cache entry for a key.
  static Future<void> remove(String key) => _remove(key);

  static Future<void> _remove(String key) async {
    LocalStorageServices.deleteData(_dataKey(key));
    LocalStorageServices.deleteData(_timeKey(key));
  }

  static String _dataKey(String key) => 'cache_data_$key';
  static String _timeKey(String key) => 'cache_time_$key';
}
