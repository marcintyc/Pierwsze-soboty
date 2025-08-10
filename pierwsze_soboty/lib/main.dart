import 'package:flutter/material.dart';
import 'app.dart';
import 'services/notifications_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsService().initialize();
  runApp(const PierwszeSobotyApp());
}
