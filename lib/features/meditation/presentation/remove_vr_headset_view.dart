import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/custom_button_widget.dart';
import '../../../core/database/settings_provider.dart';

class RemoveVrHeadsetView extends ConsumerWidget {
  const RemoveVrHeadsetView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isIt = settings.language == 0;
    final isDark = settings.isDarkTheme;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.vrpano_rounded,
                  size: 100,
                  color: AppColors.sageAccent,
                ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 32),
                Text(
                  isIt ? 'RIMUOVI IL VISORE' : 'REMOVE HEADSET',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    letterSpacing: 2.0,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: 24),
                Text(
                  isIt
                      ? 'La sessione è terminata.\nSfila il visore VR per continuare.'
                      : 'The session has ended.\nTake off the VR headset to continue.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
                  ),
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                const SizedBox(height: 64),
                CustomUnityButton(
                  text: isIt ? 'FATTO' : 'DONE',
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  accentColor: AppColors.sageAccent,
                  width: 250,
                ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
