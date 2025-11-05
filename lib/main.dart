import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_navigation.dart'; // importa la pantalla de navegación principal

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App Repartidor",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF660000), // color principal
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/main': (context) => const MainNavigation(), // 🔥 ruta hacia la navegación moderna
      },
    );
  }
}
