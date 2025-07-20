import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/models/analysis_result.dart';

class AnalysisChart extends StatelessWidget {
  final AnalysisResult result;

  const AnalysisChart({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: getTitles,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(
                      color: Colors.white70, // Couleur pour les étiquettes de l'axe Y
                      fontWeight: FontWeight.bold, // Gras
                      fontSize: 12,
                      fontFamily: 'LeagueSpartan',
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            makeGroupData(0, result.algaeLevel.toDouble(), barColor: const Color(0xFF00796B)), // Vert/bleu foncé
            makeGroupData(1, result.clarityLevel.toDouble(), barColor: const Color(0xFF0097A7)), // Bleu plus clair
            makeGroupData(2, result.conditionLevel.toDouble(), barColor: const Color(0xFF00ACC1)), // Cyan
          ],
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: 25, // Intervalles de 25%
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Colors.white12, // Lignes de grille très claires
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y, {Color barColor = Colors.white}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: 25, // Largeur de barre ajustée
          borderRadius: BorderRadius.circular(8), // Bordures plus arrondies
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Colors.white.withOpacity(0.2), // Arrière-plan transparent pour les barres
          ),
        ),
      ],
      showingTooltipIndicators: [0], // Pour montrer la valeur si vous activez les tooltips
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white, // Couleur pour les étiquettes de l'axe X
      fontWeight: FontWeight.bold, // Gras
      fontSize: 14,
      fontFamily: 'LeagueSpartan',
    );

    String text;
    Widget labelWidget;
    switch (value.toInt()) {
      case 0:
        text = 'Algues';
        labelWidget = Text(text, style: style);
        break;
      case 1:
        text = 'Clarté';
        labelWidget = Text(text, style: style);
        break;
      case 2:
        text = 'État';
        labelWidget = Text(text, style: style);
        break;
      default:
        labelWidget = const SizedBox.shrink();
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: labelWidget,
    );
  }
}