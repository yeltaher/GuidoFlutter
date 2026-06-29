import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette di colori ed estetica minimalista in stile Japandi Dinamico (Light & Dark).
class AppColors {
  // --- PALETTE JAPANDI LIGHT (GIORNO) ---
  static const Color lightBg = Color(0xFFECE7DF); // Sabbia calda mockup / Crema
  static const Color lightCard = Color(0xFFF5F2EC); // Argilla chiara mockup
  static const Color lightText = Color(
    0xFF2D322F,
  ); // Antracite desaturato mockup
  static const Color lightTextSub = Color(
    0xFF6E7571,
  ); // Slate grigio-verde mockup
  static const Color sageAccent = Color(
    0xFF8CA693,
  ); // Verde salvia desaturato mockup
  static const Color lightBorder = Color(0x228CA693);

  // --- PALETTE JAPANDI DARK (NOTTE) ---
  static const Color darkBg = Color(
    0xFF0F1115,
  ); // Pietra vulcanica ardesia scurissima
  static const Color darkCard = Color(0xFF16191E); // Argilla scura levigata
  static const Color darkText = Color(
    0xFFECE7E0,
  ); // Avorio caldo / Bianco antico
  static const Color darkTextSub = Color(0xFF8E959E); // Slate grigio medio
  static const Color goldAccent = Color(
    0xFFD9A05B,
  ); // Oro antico caldo / Luce candela
  static const Color darkBorder = Color(0x33D9A05B);

  // --- ALTRI ACCENTI ---
  static const Color dangerAccent = Color(
    0xFFC94C4C,
  ); // Rosso argilla soffice per uscire
  static const Color successAccent = Color(
    0xFF5E8C7A,
  ); // Verde bosco/selezionato Japandi

  // Gradienti dinamici basati sull'orario, adattati all'estetica Japandi
  // 1. Mattina Japandi (Sabbia & Salvia soffusa)
  static const List<Color> morningLightGradient = [
    Color(0xFFEFECE5),
    Color(0xFFDFDDD6),
  ];
  static const List<Color> morningDarkGradient = [
    Color(0xFF0C0E11),
    Color(0xFF1B2320), // Tocco verde muschio scurissimo
  ];

  // 2. Pomeriggio Japandi (Toni argilla/terracotta caldi)
  static const List<Color> afternoonLightGradient = [
    Color(0xFFF2ECE0),
    Color(0xFFE6DAC8),
  ];
  static const List<Color> afternoonDarkGradient = [
    Color(0xFF0F1115),
    Color(0xFF231E17), // Tocco terra d'ombra bruciata
  ];

  // 3. Sera/Notte Japandi (Ardesia nera profonda)
  static const List<Color> eveningLightGradient = [
    Color(0xFFE9E5DC),
    Color(0xFFDCD6CC),
  ];
  static const List<Color> eveningDarkGradient = [
    Color(0xFF0A0C0F),
    Color(0xFF121419),
  ];

  /// Restituisce il gradiente esatto basato sull'orario del giorno e sul tema
  static List<Color> getGradientByTime(bool isDarkTheme) {
    final hour = DateTime.now().hour;
    if (isDarkTheme) {
      if (hour >= 6 && hour < 13) {
        return morningDarkGradient;
      } else if (hour >= 13 && hour < 19) {
        return afternoonDarkGradient;
      } else {
        return eveningDarkGradient;
      }
    } else {
      if (hour >= 6 && hour < 13) {
        return morningLightGradient;
      } else if (hour >= 13 && hour < 19) {
        return afternoonLightGradient;
      } else {
        return eveningLightGradient;
      }
    }
  }

  // --- HELPER DIVERSIFICATI PER TEMA ---

  static Color getBgColor(bool isDarkTheme) => isDarkTheme ? darkBg : lightBg;
  static Color getCardColor(bool isDarkTheme) =>
      isDarkTheme ? darkCard : lightCard;
  static Color getTextColor(bool isDarkTheme) =>
      isDarkTheme ? darkText : lightText;
  static Color getSubTextColor(bool isDarkTheme) =>
      isDarkTheme ? darkTextSub : lightTextSub;
  static Color getActiveAccentColor(bool isDarkTheme) =>
      isDarkTheme ? goldAccent : sageAccent;
  static Color getBorderColor(bool isDarkTheme) =>
      isDarkTheme ? darkBorder : lightBorder;

  /// Stile di decorazione Japandi "Claymorphism" e "Glassmorphism"
  static BoxDecoration japandiCardDecoration(
    bool isDarkTheme, {
    double borderRadius = 24.0,
    double opacity = 0.5,
  }) {
    return BoxDecoration(
      color: getCardColor(
        isDarkTheme,
      ).withValues(alpha: isDarkTheme ? opacity : 0.8),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isDarkTheme
            ? goldAccent.withValues(alpha: 0.04)
            : sageAccent.withValues(alpha: 0.04),
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: isDarkTheme
              ? Colors.black.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.02),
          blurRadius: 18,
          spreadRadius: -2,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

/// Definizione dei temi Japandi a livello applicazione
class AppTheme {
  static ThemeData themeData(bool isDarkTheme) {
    final baseTextColor = AppColors.getTextColor(isDarkTheme);
    final baseSubColor = AppColors.getSubTextColor(isDarkTheme);

    return ThemeData(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: AppColors.getBgColor(isDarkTheme),
      colorScheme: ColorScheme(
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        primary: AppColors.getActiveAccentColor(isDarkTheme),
        onPrimary: isDarkTheme ? Colors.black : Colors.white,
        secondary: AppColors.successAccent,
        onSecondary: Colors.white,
        error: AppColors.dangerAccent,
        onError: Colors.white,
        surface: AppColors.getCardColor(isDarkTheme),
        onSurface: baseTextColor,
      ),
      textTheme: TextTheme(
        // Playfair Display per l'eleganza classica Japandi nei titoli
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          color: baseTextColor,
          letterSpacing: 1.2,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: baseTextColor,
          letterSpacing: 0.8,
        ),
        // Plus Jakarta Sans per il massimo comfort visivo ed eleganza geometrica nei testi
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          color: baseSubColor,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          color: baseTextColor,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: baseSubColor,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Helper di utilità globale per controllare l'orientamento dello schermo.
/// Utilizza un MethodChannel nativo su Android per bypassare i blocchi rotazione (Auto-Rotate Off) dell'OS.
class AppOrientation {
  static const _channel = MethodChannel('com.codepulse.guido/orientation');

  static Future<void> forceLandscape() async {
    try {
      // Nasconde immediatamente le barre di stato e navigazione per evitare glitch di layout e massimizzare l'area VR
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (_) {}
    try {
      // Forza a livello nativo Android (ignora blocco rotazione ed evita letterboxing)
      await _channel.invokeMethod('forceLandscape');
    } catch (e) {
      debugPrint("Errore rotazione landscape nativa: $e");
    }
    if (!Platform.isAndroid) {
      try {
        // Chiamata standard Flutter come fallback solo per piattaforme non-Android
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } catch (_) {}
    }
  }

  static Future<void> forcePortrait() async {
    try {
      // Ripristina la visualizzazione standard delle barre di sistema
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } catch (_) {}
    try {
      // Ripristina a livello nativo Android
      await _channel.invokeMethod('forcePortrait');
    } catch (e) {
      debugPrint("Errore rotazione portrait nativa: $e");
    }
    if (!Platform.isAndroid) {
      try {
        // Chiamata standard Flutter come fallback solo per piattaforme non-Android
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } catch (_) {}
    }
  }
}
