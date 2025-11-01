// lib/services/tip_service.dart

import 'dart:convert';
import 'dart:developer';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:doctor_gen_app/models/tip.dart';

class TipService {
  static final TipService _instance = TipService._internal();
  factory TipService() => _instance;
  TipService._internal();

  final _gemini = Gemini.instance;

  List<Tip> _dailyTips = [];
  DateTime? _lastGenerated;

  Future<List<Tip>> getDailyTips(List<String> recentChats) async {
    final today = DateTime.now();

    // Reuse already generated tips for today
    if (_lastGenerated != null &&
        _lastGenerated!.day == today.day &&
        _dailyTips.isNotEmpty) {
      log("Returning cached daily tips");
      return _dailyTips;
    }

    try {
      final chatSummary = recentChats.join("\n");

      final prompt = """
You are a helpful and positive health assistant.
Based on the user's recent conversation topics below:
$chatSummary

Generate exactly 3 personalized daily health tips related to their wellbeing, habits, or lifestyle.
Keep them short, encouraging, and actionable.

Return ONLY a valid JSON array like this:
[
  {
    "title": "Tip title",
    "description": "Brief tip details (1-2 sentences)",
    "imageKey": "hydrate | food | exercise | sleep | yoga"
  }
]
Do not include any markdown, text outside JSON, or explanations.
""";

      // Use Gemini’s `text()` method for lightweight generation
      final response = await _gemini.prompt(parts: [Part.text(prompt)]);

      if (response == null || response.output == null) {
        log("Gemini returned null or empty response for tips");
        return [];
      }

      String raw = response.output ?? "";

      // Clean Gemini's possible markdown formatting
      raw = raw.replaceAll('```json', '').replaceAll('```', '').trim();

      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        log("Unexpected Gemini response format: $raw");
        return [];
      }

      final generated =
          decoded.map<Tip>((item) {
            return Tip(
              title: item['title'] ?? 'Health Tip',
              description: item['description'] ?? '',
              imageUrl: _mapImage(item['imageKey'] ?? ''),
            );
          }).toList();

      _dailyTips = generated;
      _lastGenerated = today;
      log("Generated ${generated.length} daily tips");
      return _dailyTips;
    } catch (e, stack) {
      log("Error generating daily tips: $e");
      log(stack.toString());
      return [];
    }
  }

  String _mapImage(String key) {
    switch (key.toLowerCase()) {
      case 'hydrate':
        return 'assets/images/hydrate.png';
      case 'food':
        return 'assets/images/food.png';
      case 'exercise':
        return 'assets/images/exercise.png';
      case 'sleep':
        return 'assets/images/sleep.png';
      case 'yoga':
        return 'assets/images/yoga.png';
      default:
        return 'assets/images/health.png';
    }
  }
}
