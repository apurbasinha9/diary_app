import 'package:diary_app/controller/auth_gate.dart';
import 'package:diary_app/firebase_options.dart';
import 'package:diary_app/model/diary_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(DiaryModelAdapter());
  await Hive.openBox('diary_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary App',
      theme: ThemeData(
        textTheme: GoogleFonts.aDLaMDisplayTextTheme(),
        // scaffoldBackgroundColor: const Color.fromARGB(255, 1, 24, 35),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 216, 216, 216)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
