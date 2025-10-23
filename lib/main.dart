import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart'; // importa la nueva pantalla

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
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeScreen(), // arranca en la pantalla de bienvenida
    );
  }
}
