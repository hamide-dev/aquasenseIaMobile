import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/services/gemini_api_service.dart';
import '/models/analysis_result.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GeminiApiService _apiService = GeminiApiService();
  bool _isLoading = false;
  File? _selectedImage; // Pour stocker l'image sélectionnée

  // Pour l'animation du titre
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Durée de l'animation d'apparition du titre
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.5), // Commence au-dessus
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward(); // Démarre l'animation du titre
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Méthode pour la sélection de l'image (caméra ou galerie)
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
    // Ferme le bottom sheet après la sélection
    if (mounted) Navigator.pop(context);
  }

  // Méthode pour lancer l'analyse
  Future<void> _startAnalysis() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez d\'abord sélectionner une image.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiService.analyzeImage(_selectedImage!);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              imageFile: _selectedImage!,
              analysisResult: result,
            ),
          ),
        ).then((_) {
          // Réinitialiser l'image sélectionnée après le retour de l'écran de résultats
          setState(() {
            _selectedImage = null;
          });
        });
      }
    } catch (e) {
      String errorMessage = 'Erreur lors de l\'analyse.';
      if (e.toString().contains('You exceeded your current quota')) {
        errorMessage = 'Limite d\'utilisation de l\'API atteinte. Veuillez vérifier votre compte Google AI.';
      } else {
        errorMessage = 'Erreur: ${e.toString()}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Méthode pour afficher la boîte de dialogue de sélection de la source d'image
  void _showImageSourceSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Rendre le fond transparent
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Poignée pour glisser
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
                margin: const EdgeInsets.only(bottom: 15),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF20B2CF)),
                title: const Text('Prendre une photo', style: TextStyle(fontSize: 18)),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF20B2CF)),
                title: const Text('Choisir depuis la galerie', style: TextStyle(fontSize: 18)),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.32, 0.78], // 32% et 78% comme demandé
            colors: [
              Color(0xFF20B2CF), // Couleur 1
              Color(0xFF73CEE1), // Couleur 2
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- DEBUT : AJOUT DU LOGO ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0), // Espacement sous le logo
                    child: Image.asset(
                      'assets/images/logo.png', // Chemin vers votre image logo.png
                      height: 120, // Hauteur du logo (ajustez si besoin)
                      // width: 120, // Vous pouvez aussi définir une largeur si nécessaire
                    ),
                  ),
                  // --- FIN : AJOUT DU LOGO ---

                  // Titre "AQUASENSEIA" avec animation
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _animationController, // Utilise la même animation de fondu
                      child: Text(
                        'AQUASENSEIA',
                        style: TextStyle(
                          fontSize: 48, // Taille de police augmentée
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Texte blanc pour contraste
                          letterSpacing: 3,
                          fontFamily: 'LeagueSpartan', // Applique la police ici
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80), // Espacement ajusté

                  // Bouton "take a picture or upload file"
                  ElevatedButton.icon(
                    onPressed: _showImageSourceSelection, // Ouvre la sélection
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Fond noir
                      foregroundColor: Colors.white, // Texte blanc
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Bordures arrondies
                      ),
                      elevation: 5,
                    ),
                    icon: const Icon(Icons.camera_alt, size: 28), // Icône de caméra
                    label: const Text(
                      'take a picture or upload file',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 20), // Espacement entre les boutons

                  // Conteneur pour l'image sélectionnée (optionnel, pour feedback visuel)
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),

                  // Bouton "start analysis" (activé/désactivé)
                  _isLoading
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : ElevatedButton(
                    onPressed: _selectedImage != null ? _startAnalysis : null, // Désactivé si pas d'image
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      disabledBackgroundColor: Colors.grey[700], // Couleur quand désactivé
                      disabledForegroundColor: Colors.grey[400], // Couleur du texte quand désactivé
                    ),
                    child: const Text(
                      'start analysis',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}