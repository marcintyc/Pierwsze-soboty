import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _reload();
    // Scroll after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoScrollToCurrent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  int _currentOrNextIndex(List<DateTime> dates) {
    final now = DateTime.now();
    for (int i = 0; i < dates.length; i++) {
      final d = dates[i];
      if (!DateTime(d.year, d.month, d.day).isBefore(DateTime(now.year, now.month, now.day))) {
        return i;
      }
    }
    return dates.length - 1;
  }

  void _autoScrollToCurrent() {
    final now = DateTime.now();
    final year = now.year;
    final dates = _firstSaturdaysOfYear(year);
    final idx = _currentOrNextIndex(dates);
    final double approxItemHeight = 80.0;
    final double desired = idx * approxItemHeight;
    if (_scrollController.hasClients) {
      final max = _scrollController.position.maxScrollExtent;
      final double offset = math.min(max, desired);
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
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
                controller: _scrollController,
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