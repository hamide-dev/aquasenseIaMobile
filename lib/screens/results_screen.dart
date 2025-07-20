import 'dart:io';
import 'package:flutter/material.dart';
import '/models/analysis_result.dart';
import '/widgets/analysis_chart.dart'; // Assurez-vous que ce chemin est correct

class ResultsScreen extends StatefulWidget {
  final File imageFile;
  final AnalysisResult analysisResult;

  const ResultsScreen({
    super.key,
    required this.imageFile,
    required this.analysisResult,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Durée des animations d'entrée
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2), // Commence légèrement en dessous
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward(); // Démarre l'animation à l'initialisation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Résultats de l\'Analyse',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'LeagueSpartan', // Applique la police à l'AppBar
          ),
        ),
        backgroundColor: const Color(0xFF20B2CF), // Couleur cohérente avec le dégradé
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.32, 0.78],
            colors: [
              Color(0xFF20B2CF),
              Color(0xFF73CEE1),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image analysée avec animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.0, -0.1), end: Offset.zero).animate(
                    CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.file(widget.imageFile,
                          height: 250, width: double.infinity, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Graphique avec animation
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📊 Niveaux de Qualité',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Texte blanc pour le contraste sur le gradient
                          fontFamily: 'LeagueSpartan',
                        ),
                      ),
                      const Divider(color: Colors.white54, thickness: 2, height: 20), // Séparateur blanc
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: AnalysisChart(result: widget.analysisResult),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Conteneur de recommandations avec animation
              SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(
                  CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 Recommandations',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Texte blanc pour le contraste
                          fontFamily: 'LeagueSpartan',
                        ),
                      ),
                      const Divider(color: Colors.white54, thickness: 2, height: 20), // Séparateur blanc
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9), // Fond blanc semi-transparent
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.white, width: 2), // Bordure blanche
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.analysisResult.recommendations
                              .map((reco) => Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline, color: Color(0xFF20B2CF), size: 20), // Icône bleue
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    reco,
                                    style: const TextStyle(fontSize: 16.5, color: Colors.black87, height: 1.4), // Texte plus foncé
                                  ),
                                ),
                              ],
                            ),
                          ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.send, color: Colors.white),
                          label: const Text(
                            'Envoi au Ministère des Eaux',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF20B2CF),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () async {
                            // Simulation d'envoi (ici, on peut ajouter un délai ou une fausse requête HTTP)
                            await Future.delayed(const Duration(seconds: 1));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Les données ont été transmises avec succès au Ministère des Eaux.',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Color(0xFF20B2CF),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}