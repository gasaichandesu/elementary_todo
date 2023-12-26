import 'package:elementary_todo/app/app.dart';
import 'package:elementary_todo/app/di/di_container.dart';
import 'package:flutter/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  runApp(
    App(),
  );
}
