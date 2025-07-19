import 'dart:io';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '/models/analysis_result.dart';

class GeminiApiService {
  // ATTENTION: Clé API exposée dans le code. À sécuriser pour la production!
  static const String _apiKey = 'AIzaSyDRA90k4yqswTgjUmmIUsN_MZnm_RNil-Q';

  Future<AnalysisResult> analyzeImage(File imageFile) async {
    // Changement du modèle vers 'gemini-1.5-flash'
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
    final Uint8List imageBytes = await imageFile.readAsBytes();

    final prompt = TextPart(
        "Analyse cette image d'eau (aquarium, étang, etc.). Fournis une estimation en pourcentage du niveau d'algues, de la clarté de l'eau (propriété) et de l'état général (en bonne état). Ensuite, donne 3 recommandations courtes et claires pour l'utilisateur. Formate ta réponse EXACTEMENT comme suit, sans texte supplémentaire : ALGUES: [pourcentage] | CLARTE: [pourcentage] | ETAT: [pourcentage] | RECOS: [reco1];[reco2];[reco3]");

    final imagePart = DataPart('image/jpeg', imageBytes);

    final response = await model.generateContent([
      Content.multi([prompt, imagePart])
    ]);

    if (response.text == null) {
      throw Exception("L'API n'a retourné aucune réponse.");
    }

    // Gestion des cas où la réponse est vide ou incorrecte après le split
    try {
      return AnalysisResult.fromString(response.text!);
    } catch (e) {
      print('Erreur de parsing de la réponse Gemini: $e');
      // Retourne un AnalysisResult avec un message d'erreur clair
      return AnalysisResult(
        algaeLevel: 0,
        clarityLevel: 0,
        conditionLevel: 0,
        recommendations: ["L'analyse a échoué. Le format de réponse de l'IA est incorrect."],
      );
    }
  }
}