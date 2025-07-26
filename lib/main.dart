import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}