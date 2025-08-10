import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/prayer_requests_service.dart';

class PrayerFeedScreen extends StatefulWidget {
  const PrayerFeedScreen({super.key});

  @override
  State<PrayerFeedScreen> createState() => _PrayerFeedScreenState();
}

class _PrayerFeedScreenState extends State<PrayerFeedScreen> {
  final PrayerRequestsService _service = PrayerRequestsService();
  late Future<List<PrayerRequest>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _itemsFuture = _service.loadRequests();
  }

  Future<void> _addRequestDialog() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nowa prośba o modlitwę'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Tytuł')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Opis'), maxLines: 3),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Anuluj')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Dodaj')),
          ],
        );
      },
    );
    if (result == true) {
      await _service.addRequest(titleController.text.trim(), descController.text.trim());
      setState(_reload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prośby o modlitwę')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRequestDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Dodaj prośbę'),
      ),
      body: FutureBuilder<List<PrayerRequest>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Brak próśb. Dodaj pierwszą!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerRight,
                  color: Colors.redAccent,
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await _service.removeRequest(item.id);
                  setState(_reload);
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      item.prayed ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: item.prayed ? Colors.green : Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(item.title),
                    subtitle: Text('${DateFormat('d MMM y', 'pl').format(item.createdAt)}\n${item.description}'),
                    isThreeLine: true,
                    trailing: Switch.adaptive(
                      value: item.prayed,
                      onChanged: (v) async {
                        await _service.togglePrayed(item.id, v);
                        setState(_reload);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}