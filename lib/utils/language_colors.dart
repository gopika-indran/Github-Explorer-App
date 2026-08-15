import 'package:flutter/material.dart';
class LanguageColors {
  LanguageColors._();

  static const Map<String, Color> _colors = {
    'Dart': Color(0xFF00B4AB),
    'JavaScript': Color(0xFFF1E05A),
    'TypeScript': Color(0xFF3178C6),
    'Python': Color(0xFF3572A5),
    'Java': Color(0xFFB07219),
    'Kotlin': Color(0xFFA97BFF),
    'Swift': Color(0xFFF05138),
    'C++': Color(0xFFF34B7D),
    'C': Color(0xFF555555),
    'C#': Color(0xFF178600),
    'Go': Color(0xFF00ADD8),
    'Rust': Color(0xFFDEA584),
    'Ruby': Color(0xFF701516),
    'PHP': Color(0xFF4F5D95),
    'HTML': Color(0xFFE34C26),
    'CSS': Color(0xFF563D7C),
    'Shell': Color(0xFF89E051),
    'Objective-C': Color(0xFF438EFF),
  };

  static Color of(String? language) {
    if (language == null) return const Color(0xFF9DA7B3);
    return _colors[language] ?? const Color(0xFF9DA7B3);
  }
}
