import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrayerRequest {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool prayed;

  PrayerRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.prayed,
  });

  PrayerRequest copyWith({String? title, String? description, bool? prayed}) {
    return PrayerRequest(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      prayed: prayed ?? this.prayed,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'prayed': prayed,
      };

  static PrayerRequest fromMap(Map<String, dynamic> map) => PrayerRequest(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        prayed: map['prayed'] as bool,
      );
}

class PrayerRequestsService {
  static const String _key = 'prayer_requests';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<List<PrayerRequest>> loadRequests() async {
    final prefs = await _prefs;
    final list = prefs.getStringList(_key) ?? [];
    final items = list
        .map((s) => jsonDecode(s) as Map<String, dynamic>)
        .map(PrayerRequest.fromMap)
        .toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> saveRequests(List<PrayerRequest> items) async {
    final prefs = await _prefs;
    final list = items.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_key, list);
  }

  Future<void> addRequest(String title, String description) async {
    final items = await loadRequests();
    final now = DateTime.now();
    final req = PrayerRequest(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: now,
      prayed: false,
    );
    items.insert(0, req);
    await saveRequests(items);
  }

  Future<void> togglePrayed(String id, bool prayed) async {
    final items = await loadRequests();
    final idx = items.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(prayed: prayed);
      await saveRequests(items);
    }
  }

  Future<void> removeRequest(String id) async {
    final items = await loadRequests();
    items.removeWhere((e) => e.id == id);
    await saveRequests(items);
  }
}