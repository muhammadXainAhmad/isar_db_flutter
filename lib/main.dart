import 'package:flutter/material.dart';
import 'package:isar_db/screens/home_screen.dart';
import 'package:isar_db/services/database_service.dart';

void main() async{
  await _setup();
  runApp(const MyApp());
}

Future<void> _setup()async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.setup();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
