class AnalysisResult {
  final int algaeLevel;
  final int clarityLevel;
  final int conditionLevel;
  final List<String> recommendations;

  AnalysisResult({
    required this.algaeLevel,
    required this.clarityLevel,
    required this.conditionLevel,
    required this.recommendations,
  });

  factory AnalysisResult.fromString(String responseText) {
    try {
      final parts = responseText.split('|');
      final algae = int.parse(parts[0].split(':')[1].trim());
      final clarity = int.parse(parts[1].split(':')[1].trim());
      final condition = int.parse(parts[2].split(':')[1].trim());
      final recos = parts[3].split(':')[1].trim().split(';');

      return AnalysisResult(
        algaeLevel: algae,
        clarityLevel: clarity,
        conditionLevel: condition,
        recommendations: recos,
      );
    } catch (e) {
      // Retourne des valeurs par défaut en cas d'erreur de parsing
      return AnalysisResult(
        algaeLevel: 0,
        clarityLevel: 0,
        conditionLevel: 0,
        recommendations: ["L'analyse a échoué. Veuillez réessayer avec une autre image."],
      );
    }
  }
}