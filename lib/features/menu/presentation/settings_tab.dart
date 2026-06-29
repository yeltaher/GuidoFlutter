import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import '../../meditation/meditation_feature.dart';
import '../../splash/splash_feature.dart';

class SettingsTab extends ConsumerStatefulWidget {
  const SettingsTab({super.key});

  @override
  ConsumerState<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<SettingsTab> {
  final String _websiteUrl = "https://codepulse.it";

  Future<void> _openUrl() async {
    final url = Uri.parse(_websiteUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    final isDark = settings.isDarkTheme;
    final textColor = AppColors.getTextColor(isDark);
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final subColor = AppColors.getSubTextColor(isDark);

    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            SafeArea(
              left: false,
              right: false,
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Header Serif (Fisso)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "IMPOSTAZIONI ZEN",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        24.0,
                        0.0,
                        24.0,
                        110.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Settings Control Panel (Claymorphic)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: AppColors.japandiCardDecoration(
                                  isDark,
                                  borderRadius: 24,
                                  opacity: 0.35,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 1. VOLUME MUSICA (SLIDER)
                                    _buildVolumeSlider(
                                      title: "VOLUME MUSICA",
                                      value: settings.musicVolume,
                                      onChanged: (val) => settingsNotifier
                                          .changeMusicVolume(val),
                                      isDark: isDark,
                                      accentColor: accentColor,
                                      subTextColor: subColor,
                                    ),
                                    const SizedBox(height: 20),

                                    // 2. VOLUME EFFETTI (SLIDER)
                                    _buildVolumeSlider(
                                      title: "VOLUME EFFETTI",
                                      value: settings.effectsVolume,
                                      onChanged: (val) => settingsNotifier
                                          .changeEffectsVolume(val),
                                      isDark: isDark,
                                      accentColor: accentColor,
                                      subTextColor: subColor,
                                    ),
                                    const SizedBox(height: 20),

                                    // 3. VOLUME VOCE (SLIDER + MUTE)
                                    _buildVoiceVolumeSlider(
                                      title: "VOLUME VOCE GUIDA",
                                      value: settings.voiceVolume,
                                      isMuted: settings.isVoiceMuted,
                                      onChanged: (val) => settingsNotifier
                                          .changeVoiceVolume(val),
                                      onMuteToggle: () =>
                                          settingsNotifier.toggleVoiceMute(
                                            !settings.isVoiceMuted,
                                          ),
                                      isDark: isDark,
                                      accentColor: accentColor,
                                      subTextColor: subColor,
                                    ),

                                    Divider(
                                      height: 36,
                                      color: isDark
                                          ? Colors.white10
                                          : Colors.black12,
                                    ),

                                    // 4. VOCE GUIDA (GENDER TOGGLE)
                                    _buildToggleSetting(
                                      title: "GENERE VOCE GUIDA",
                                      option1: "MASCHILE",
                                      option2: "FEMMINILE",
                                      isOption1Selected: settings.voiceSex == 0,
                                      onOption1Tap: () =>
                                          settingsNotifier.changeVoiceSex(0),
                                      onOption2Tap: () =>
                                          settingsNotifier.changeVoiceSex(1),
                                      isDark: isDark,
                                    ),
                                    const SizedBox(height: 20),

                                    // 5. TEMA APPLICAZIONE (THEME TOGGLE)
                                    _buildToggleSetting(
                                      title: "TEMA GIORNO / NOTTE",
                                      option1: "GIORNO",
                                      option2: "NOTTE",
                                      isOption1Selected: !settings.isDarkTheme,
                                      onOption1Tap: () => settingsNotifier
                                          .toggleDarkTheme(false),
                                      onOption2Tap: () => settingsNotifier
                                          .toggleDarkTheme(true),
                                      isDark: isDark,
                                    ),

                                    Divider(
                                      height: 36,
                                      color: isDark
                                          ? Colors.white10
                                          : Colors.black12,
                                    ),

                                    // 6. CALIBRAZIONE GIROSCOPIO VR
                                    _buildCalibrationSetting(
                                      isDark: isDark,
                                      accentColor: accentColor,
                                      subTextColor: subColor,
                                      isCalibrated: settings.vrCalibrated,
                                      onCalibrateTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const VrCalibrationScreen(
                                                  isFromSettings: true,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 28),

                          // Website & exit buttons
                          _buildFooterButtons(
                            context,
                            settings.isUnlocked,
                            isDark,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Costruisce una riga per la regolazione del volume tramite Slider
  Widget _buildVolumeSlider({
    required String title,
    required int value,
    required Function(int) onChanged,
    required bool isDark,
    required Color accentColor,
    required Color subTextColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: subTextColor,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accentColor,
            inactiveTrackColor: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.08),
            thumbColor: accentColor,
            overlayColor: accentColor.withValues(alpha: 0.12),
            valueIndicatorColor: accentColor,
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 0.0,
            max: 3.0,
            divisions: 3,
            onChanged: (val) => onChanged(val.round()),
          ),
        ),
      ],
    );
  }

  /// Costruisce lo Slider specifico per la voce con l'icona mute sul lato
  Widget _buildVoiceVolumeSlider({
    required String title,
    required int value,
    required bool isMuted,
    required Function(int) onChanged,
    required VoidCallback onMuteToggle,
    required bool isDark,
    required Color accentColor,
    required Color subTextColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: subTextColor,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Semantics(
              button: true,
              label: "Interactive element",
              child: GestureDetector(
                onTap: onMuteToggle,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isMuted
                        ? AppColors.dangerAccent.withValues(alpha: 0.12)
                        : accentColor.withValues(alpha: 0.06),
                  ),
                  child: Icon(
                    isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    color: isMuted ? AppColors.dangerAccent : accentColor,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: isMuted
                      ? subTextColor.withValues(alpha: 0.3)
                      : accentColor,
                  inactiveTrackColor: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.08),
                  thumbColor: isMuted
                      ? subTextColor.withValues(alpha: 0.5)
                      : accentColor,
                  overlayColor: accentColor.withValues(alpha: 0.12),
                  valueIndicatorColor: accentColor,
                  trackHeight: 4.0,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8.0,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 16.0,
                  ),
                ),
                child: Slider(
                  value: value.toDouble(),
                  min: 0.0,
                  max: 3.0,
                  divisions: 3,
                  onChanged: isMuted ? null : (val) => onChanged(val.round()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Costruisce una riga per le impostazioni booleane
  Widget _buildToggleSetting({
    required String title,
    required String option1,
    required String option2,
    required bool isOption1Selected,
    required VoidCallback onOption1Tap,
    required VoidCallback onOption2Tap,
    required bool isDark,
  }) {
    final subTextColor = AppColors.getSubTextColor(isDark);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: subTextColor,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildToggleButton(
                option1,
                isOption1Selected,
                onOption1Tap,
                isDark,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildToggleButton(
                option2,
                !isOption1Selected,
                onOption2Tap,
                isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleButton(
    String label,
    bool isActive,
    VoidCallback onTap,
    bool isDark,
  ) {
    final accentColor = AppColors.getActiveAccentColor(isDark);
    return Semantics(
      button: true,
      label: "Interactive element",
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? accentColor
                : (isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.black.withValues(alpha: 0.04)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? accentColor
                  : (isDark ? Colors.white12 : Colors.black12),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: isActive
                    ? (isDark ? Colors.black : Colors.white)
                    : AppColors.getSubTextColor(isDark),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalibrationSetting({
    required bool isDark,
    required Color accentColor,
    required Color subTextColor,
    required bool isCalibrated,
    required VoidCallback onCalibrateTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CALIBRAZIONE GIROSCOPIO VR",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: subTextColor,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isCalibrated
                        ? Icons.check_circle_rounded
                        : Icons.warning_rounded,
                    color: isCalibrated
                        ? AppColors.successAccent
                        : Colors.amber,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isCalibrated ? "Calibrato ✓" : "Non calibrato ✗",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isCalibrated
                          ? AppColors.successAccent
                          : Colors.amber,
                    ),
                  ),
                ],
              ),
              Semantics(
                button: true,
                label: "Interactive element",
                child: GestureDetector(
                  onTap: onCalibrateTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "CALIBRA",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterButtons(
    BuildContext context,
    bool isUnlocked,
    bool isDark,
  ) {
    return Column(
      children: [
        _buildActionBtn(
          label: isUnlocked ? "SBLOCCATO" : "SBLOCCA PREMIUM",
          onTap: () {
            if (!isUnlocked) {
              context.push('/premium');
            }
          },
          isDark: isDark,
          accentColor: isUnlocked
              ? AppColors.successAccent
              : AppColors.goldAccent,
          isFilled: true,
        ),
        const SizedBox(height: 12),
        _buildActionBtn(
          label: "VISITA SITO WEB",
          onTap: _openUrl,
          isDark: isDark,
          accentColor: AppColors.getSubTextColor(isDark).withValues(alpha: 0.5),
          isFilled: false,
        ),
        const SizedBox(height: 12),
        _buildActionBtn(
          label: "LOGOUT",
          onTap: () async {
            final prefs = ref.read(sharedPrefsProvider);
            await prefs.setBool("IsOnboarded", false);
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashView()),
                (route) => false,
              );
            }
          },
          isDark: isDark,
          accentColor: AppColors.dangerAccent,
          isFilled: false,
        ),
      ],
    );
  }

  Widget _buildActionBtn({
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    required Color accentColor,
    bool isFilled = false,
  }) {
    return Semantics(
      button: true,
      label: "Interactive element",
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isFilled
                ? accentColor
                : (isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.black.withValues(alpha: 0.04)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isFilled
                  ? accentColor
                  : accentColor.withValues(alpha: 0.5),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: isFilled
                    ? (isDark ? Colors.black : Colors.white)
                    : accentColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
