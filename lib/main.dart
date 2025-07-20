import 'package:flutter/material.dart';
import './screens/home_screen.dart'; // Make sure this path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Add a boolean to track if the initialization is complete
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate any app initialization tasks here (e.g., loading data, checking auth)
    // For now, we just use a delay to simulate a 2-second splash screen.
    await Future.delayed(const Duration(seconds: 2)); // Your 2-second delay

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aquasenseia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(
            0xFF20B2CF, // Primary color value from your gradient
            <int, Color>{
              50: Color(0xFFE3F5F8), 100: Color(0xFFBAE5ED), 200: Color(0xFF8ED4E2),
              300: Color(0xFF62C4D7), 400: Color(0xFF3FBFCE), 500: Color(0xFF20B2CF),
              600: Color(0xFF1DACCB), 700: Color(0xFF19A3C5), 800: Color(0xFF1499BF),
              900: Color(0xFF0C8AB4),
            },
          ),
          accentColor: const Color(0xFF73CEE1),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'LeagueSpartan',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF20B2CF),
          foregroundColor: Colors.white,
          elevation: 4,
          toolbarTextStyle: TextStyle(fontFamily: 'LeagueSpartan', fontSize: 20),
          titleTextStyle: TextStyle(fontFamily: 'LeagueSpartan', fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      // Use a ternary operator to show a loading screen or your actual home
      home: _isInitialized ? const HomeScreen() : _buildSplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  // A simple widget to show while waiting for initialization.
  // This will display *after* the native splash screen disappears.
  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // White background consistent with native splash
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Your splash screen logo
              width: 150, // Adjust size as needed
              height: 150,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF20B2CF)), // Your app's primary color
            ),
          ],
        ),
      ),
    );
  }
}