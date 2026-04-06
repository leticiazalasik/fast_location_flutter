import 'package:fast_location/src/modules/initial/page/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/routes/app_routes.dart';
import 'src/modules/initial/page/home/page/home_page.dart';
import 'src/modules/history/page/history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => const InitialPage(),
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.history: (_) => const HistoryPage(),
      },
    );
  }
}
