import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _completedSaturdaysKey = 'completed_saturdays';
  static const String _conditionsPrefix = 'conditions_';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  String _conditionsKeyForDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$_conditionsPrefix$y$m$d';
  }

  Future<Map<String, bool>> loadConditionsFor(DateTime date) async {
    final prefs = await _prefs;
    final key = _conditionsKeyForDate(date);
    final map = <String, bool>{};
    final list = prefs.getStringList(key) ?? [];
    for (final entry in list) {
      final parts = entry.split('=');
      if (parts.length == 2) {
        map[parts[0]] = parts[1] == '1';
      }
    }
    return map;
  }

  Future<void> saveConditionsFor(DateTime date, Map<String, bool> conditions) async {
    final prefs = await _prefs;
    final key = _conditionsKeyForDate(date);
    final list = conditions.entries.map((e) => '${e.key}=${e.value ? '1' : '0'}').toList();
    await prefs.setStringList(key, list);
  }

  Future<Set<String>> loadCompletedSaturdays() async {
    final prefs = await _prefs;
    final list = prefs.getStringList(_completedSaturdaysKey) ?? [];
    return list.toSet();
  }

  Future<void> markSaturdayCompleted(DateTime date) async {
    final prefs = await _prefs;
    final set = await loadCompletedSaturdays();
    set.add(_dateKey(date));
    await prefs.setStringList(_completedSaturdaysKey, set.toList());
  }

  Future<void> toggleSaturdayCompletion(DateTime date, bool completed) async {
    final prefs = await _prefs;
    final set = await loadCompletedSaturdays();
    final key = _dateKey(date);
    if (completed) {
      set.add(key);
    } else {
      set.remove(key);
    }
    await prefs.setStringList(_completedSaturdaysKey, set.toList());
  }

  bool isSaturdayCompletedSync(Set<String> completedSet, DateTime date) {
    return completedSet.contains(_dateKey(date));
  }

  String _dateKey(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final da = d.day.toString().padLeft(2, '0');
    return '$y-$m-$da';
  }
}