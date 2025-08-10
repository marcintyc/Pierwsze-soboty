import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ConditionsScreen extends StatefulWidget {
  const ConditionsScreen({super.key});

  @override
  State<ConditionsScreen> createState() => _ConditionsScreenState();
}

class _ConditionsScreenState extends State<ConditionsScreen> {
  static const List<String> _conditionKeys = [
    'Spowiedź święta (z intencją wynagradzającą)',
    'Komunia święta w pierwszą sobotę',
    'Jedna część Różańca (pięć tajemnic)',
    '15-minutowe rozmyślanie nad tajemnicami różańcowymi',
  ];

  final StorageService _storage = StorageService();
  late DateTime _currentSaturday;
  Map<String, bool> _done = {for (final k in _conditionKeys) k: false};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _currentSaturday = _firstSaturdayOfCurrentMonth();
    _load();
  }

  Future<void> _load() async {
    final saved = await _storage.loadConditionsFor(_currentSaturday);
    setState(() {
      for (final k in _conditionKeys) {
        _done[k] = saved[k] ?? false;
      }
      _loading = false;
    });
  }

  Future<void> _persist() async {
    await _storage.saveConditionsFor(_currentSaturday, _done);
    if (_allDone()) {
      await _storage.toggleSaturdayCompletion(_currentSaturday, true);
      final completed = await _storage.loadCompletedSaturdays();
      if (completed.length >= 5 && mounted) {
        await _storage.incrementFullDevotionsAndResetCycle();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ukończono pełny cykl 5 sobót! Rozpoczynamy nowy.')),
        );
      }
    }
  }

  bool _allDone() => _done.values.every((v) => v);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Warunki nabożeństwa')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._done.entries.map(
            (e) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: _IconBadge(icon: _iconFor(e.key), colors: colors),
                title: Text(e.key),
                trailing: Switch.adaptive(
                  value: e.value,
                  onChanged: (v) async {
                    setState(() => _done[e.key] = v);
                    await _persist();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: _allDone() ? 1.0 : 0.0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.tertiary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_rounded, color: Colors.pinkAccent),
                    SizedBox(width: 8),
                    Text('Wszystkie warunki spełnione!'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String key) {
    if (key.startsWith('Spowiedź')) return Icons.church_rounded;
    if (key.startsWith('Komunia')) return Icons.blur_circular_rounded;
    if (key.startsWith('Jedna część')) return Icons.menu_book_rounded;
    return Icons.self_improvement_rounded;
  }

  DateTime _firstSaturdayOfCurrentMonth() {
    final now = DateTime.now();
    DateTime d = DateTime(now.year, now.month, 1);
    while (d.weekday != DateTime.saturday) {
      d = d.add(const Duration(days: 1));
    }
    return DateTime(d.year, d.month, d.day);
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final ColorScheme colors;
  const _IconBadge({required this.icon, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}