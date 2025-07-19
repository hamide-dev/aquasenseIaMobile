import 'package:flutter/material.dart';
import './screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aquasenseia',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'LeagueSpartan', // Définir la police par défaut ici
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF20B2CF), // Couleur cohérente pour les AppBar
          foregroundColor: Colors.white, // Couleur du texte et des icônes de l'AppBar
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false, // Supprime le bandeau de débogage
    );
  }
}