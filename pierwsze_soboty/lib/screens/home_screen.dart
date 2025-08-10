import 'package:flutter/material.dart';
import '../services/notifications_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pierwsze Soboty')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text('Nabożeństwo pierwszych sobót', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text(
              '„Tym, którzy przez pięć miesięcy w pierwsze soboty odprawią nabożeństwa, '
              'w stanie łaski i w intencji wynagradzającej jej Niepokalanemu Sercu, '
              'wyjednam łaski potrzebne do zbawienia.”',
            ),
            const SizedBox(height: 24),
            _PrimaryButton(
              icon: Icons.favorite,
              label: 'Rozpocznij nabożeństwo',
              onPressed: () => Navigator.pushNamed(context, '/conditions'),
            ),
            const SizedBox(height: 12),
            _PrimaryButton(
              icon: Icons.calendar_month,
              label: 'Kalendarz postępu',
              onPressed: () => Navigator.pushNamed(context, '/progress'),
            ),
            const SizedBox(height: 12),
            _PrimaryButton(
              icon: Icons.info_outline,
              label: 'Informacje',
              onPressed: () => Navigator.pushNamed(context, '/info'),
            ),
            const SizedBox(height: 12),
            _PrimaryButton(
              icon: Icons.notifications_active,
              label: 'Ustaw przypomnienie o pierwszej sobocie',
              onPressed: () async {
                await NotificationsService().scheduleFirstSaturdayReminder();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Przypomnienie ustawione')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(label),
        ),
      ),
    );
  }
}