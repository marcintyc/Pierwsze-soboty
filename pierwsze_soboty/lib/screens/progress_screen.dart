import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final StorageService _storage = StorageService();
  late Future<Set<String>> _completedFuture;
  late Future<int> _fullDevotionsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _completedFuture = _storage.loadCompletedSaturdays();
    _fullDevotionsFuture = _storage.loadFullDevotionsCount();
  }

  List<DateTime> _firstSaturdaysOfYear(int year) {
    final List<DateTime> dates = [];
    for (int month = 1; month <= 12; month++) {
      DateTime d = DateTime(year, month, 1);
      while (d.weekday != DateTime.saturday) {
        d = d.add(const Duration(days: 1));
      }
      dates.add(d);
    }
    return dates;
  }

  Future<void> _onToggle(DateTime d, bool val) async {
    await _storage.toggleSaturdayCompletion(d, val);
    final set = await _storage.loadCompletedSaturdays();
    if (set.length >= 5) {
      await _storage.incrementFullDevotionsAndResetCycle();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ukończono pełny cykl 5 sobót! Rozpoczynamy nowy.')),
        );
      }
    }
    setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final year = now.year;
    final dates = _firstSaturdaysOfYear(year);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Kalendarz i postęp')),
      body: FutureBuilder<Set<String>>(
        future: _completedFuture,
        builder: (context, snapCompleted) {
          final completed = snapCompleted.data ?? <String>{};
          final count = completed.length > 5 ? 5 : completed.length;
          return FutureBuilder<int>(
            future: _fullDevotionsFuture,
            builder: (context, snapFull) {
              final full = snapFull.data ?? 0;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Ukończone nabożeństwa (pełne cykle): $full', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _ProgressHearts(count: count, colors: colors),
                  const SizedBox(height: 16),
                  Text('Pierwsze soboty $year', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...dates.map((d) => _SaturdayTile(
                        date: d,
                        completed: _storage.isSaturdayCompletedSync(completed, d),
                        onChanged: (val) => _onToggle(d, val),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SaturdayTile extends StatelessWidget {
  final DateTime date;
  final bool completed;
  final Future<void> Function(bool) onChanged;
  const _SaturdayTile({required this.date, required this.completed, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('d MMMM y', 'pl');
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          completed ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: completed ? const Color(0xFFE53935) : colors.primary,
        ),
        title: Text(df.format(date)),
        trailing: Switch.adaptive(
          value: completed,
          onChanged: (v) => onChanged(v),
        ),
      ),
    );
  }
}

class _ProgressHearts extends StatelessWidget {
  final int count;
  final ColorScheme colors;
  const _ProgressHearts({required this.count, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final filled = i < count;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Icon(
            filled ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: filled ? const Color(0xFFE53935) : colors.primary,
            size: 26,
          ),
        );
      }),
    );
  }
}