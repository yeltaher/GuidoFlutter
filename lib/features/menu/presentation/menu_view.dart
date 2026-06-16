import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/custom_button_widget.dart';
import '../../../core/theme/animated_magic_portal.dart';
import '../../../core/database/settings_provider.dart';
import '../../breathing/breathing_feature.dart';
import '../../meditation/meditation_feature.dart';

class MenuView extends ConsumerStatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  ConsumerState<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends ConsumerState<MenuView> {
  bool _showUnlockPanel = false;

  // Link esterni identici ad allLinks di Unity
  final List<String> _allLinks = [
    "https://codepulse.it",
    "https://codepulse.it/guido-supporto",
  ];

  // Traduzioni per i testi dei menu (italiano / inglese)
  final Map<String, List<String>> _translations = {
    "it": [
      "MENU PRINCIPALE", // 0
      "Volume Musica",   // 1
      "Volume Effetti",  // 2
      "Volume Voce",     // 3
      "Voce Guida",      // 4
      "Lingua",          // 5
      "SBLOCCA VERSIONE COMPLETA", // 6
      "Sbloccato",       // 7
      "Maschile",        // 8
      "Femminile",       // 9
      "Muta Voce",       // 10
      "Visita Sito Web", // 11
      "Esci dal Gioco",  // 12
      "MEDITAZIONI",     // 13
      "RESPIRAZIONI",    // 14
      "Generale (Gratis)", // 15
      "Percorso Acqua (Premium)", // 16
      "Respirazione Aria (Gratis)", // 17
      "Respirazione Fuoco (Premium)", // 18
      "Simula Acquisto", // 19
      "ATTENZIONE: Sessione Bloccata! Sblocca la versione completa per accedere a tutti i percorsi guidati di Guido.", // 20
      "CHIUDI", // 21
    ],
    "en": [
      "MAIN MENU",       // 0
      "Music Volume",    // 1
      "Effects Volume",  // 2
      "Voice Volume",    // 3
      "Voice Guide",     // 4
      "Language",        // 5
      "UNLOCK FULL VERSION", // 6
      "Unlocked",        // 7
      "Male",            // 8
      "Female",          // 9
      "Mute Voice",      // 10
      "Visit Website",   // 11
      "Exit Game",       // 12
      "MEDITATIONS",     // 13
      "BREATHINGS",      // 14
      "General (Free)",  // 15
      "Water Path (Premium)", // 16
      "Air Breathing (Free)", // 17
      "Fire Breathing (Premium)", // 18
      "Simulate Purchase", // 19
      "WARNING: Session Locked! Unlock the full version to access all guided paths of Guido.", // 20
      "CLOSE", // 21
    ]
  };

  List<String> _getTexts(int langCode) {
    return langCode == 0 ? _translations["it"]! : _translations["en"]!;
  }

  Future<void> _openUrl(int index) async {
    final url = Uri.parse(_allLinks[index]);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _setUnlockPanelVisible(bool visible) {
    setState(() {
      _showUnlockPanel = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    
    final texts = _getTexts(settings.language);
    final isVrMode = settings.isVrMode;

    if (isVrMode) {
      // Modalità VR stereoscopica sdoppiata per Google Cardboard (Side-by-Side)
      return Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          children: [
            // Occhio sinistro (Interattivo)
            Expanded(
              child: ClipRect(
                child: _buildSingleEyeMenu(context, settings, settingsNotifier, texts, vrOffset: -3.5, isLeft: true),
              ),
            ),
            // Linea divisoria nera per il visore Cardboard
            Container(
              width: 2.0,
              color: Colors.black,
            ),
            // Occhio destro
            Expanded(
              child: ClipRect(
                child: _buildSingleEyeMenu(context, settings, settingsNotifier, texts, vrOffset: 3.5, isLeft: false),
              ),
            ),
          ],
        ),
      );
    } else {
      // Modalità flat standard
      return Scaffold(
        body: _buildSingleEyeMenu(context, settings, settingsNotifier, texts, vrOffset: 0.0, isLeft: true, showFooter: true),
      );
    }
  }

  /// Costruisce l'interfaccia del menu principale per un singolo occhio
  Widget _buildSingleEyeMenu(
    BuildContext context,
    SettingsState settings,
    SettingsNotifier settingsNotifier,
    List<String> texts, {
    required double vrOffset,
    required bool isLeft,
    bool showFooter = false,
  }) {
    final isVr = settings.isVrMode;
    final isDark = settings.isDarkTheme;
    final double portalSize = isVr ? 120.0 : 210.0;
    final double titleFontSize = isVr ? 18.0 : 32.0;
    final textColor = AppColors.getTextColor(isDark);
    final accentColor = AppColors.getActiveAccentColor(isDark);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.getGradientByTime(isDark),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Luce soffusa angolare in stile aurora minimal per atmosfera zen
          Positioned(
            top: -140,
            left: isLeft ? -100 : 100,
            child: Container(
              key: ValueKey('menu_ambient_glow_$isLeft'),
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(isDark ? 0.04 : 0.07),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                child: const SizedBox.shrink(),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isVr ? 12.0 : 22.0, 
                vertical: isVr ? 8.0 : 20.0
              ),
              child: Column(
                children: [
                  // 1. Titolo Principale in elegante Playfair Display
                  const SizedBox(height: 10),
                  Text(
                    texts[0],
                    style: GoogleFonts.playfairDisplay(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      letterSpacing: isVr ? 2.5 : 5.0,
                    ),
                  ),
                  SizedBox(height: isVr ? 6 : 14),

                  // 2. Portale Magico Animato Nativo ('Zen Japandi Garden' con laghetto e petali cadenti)
                  Container(
                    height: isVr ? 130 : 220,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: AnimatedMagicPortalWidget(
                      width: portalSize,
                      height: portalSize,
                      isMeditating: false,
                      vrEyeOffset: vrOffset,
                    ),
                  ),
                  SizedBox(height: isVr ? 12 : 24),

                  // 3. Pannello di Controllo Impostazioni Japandi Claymorphic
                  _buildSettingsPanel(context, settings, settingsNotifier, texts),
                  SizedBox(height: isVr ? 12 : 24),

                  // 4. Pannello Selezione Meditazioni e Respirazioni Japandi
                  _buildSelectionPanel(context, settings, texts),
                  
                  // 5. Footer (Sito e Chiudi)
                  if (showFooter || (isVr && isLeft)) ...[
                    SizedBox(height: isVr ? 12 : 24),
                    _buildFooterButtons(context, texts),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // 6. Pannello di Sblocco Premium Glassmorphic Overlay
          if (_showUnlockPanel && (!isVr || isLeft)) 
            Positioned.fill(
              child: _buildUnlockOverlay(context, settingsNotifier, texts),
            ),
        ],
      ),
    );
  }

  /// Mixer Audio e Preferenze Japandi
  Widget _buildSettingsPanel(
    BuildContext context,
    SettingsState settings,
    SettingsNotifier notifier,
    List<String> texts,
  ) {
    final isVr = settings.isVrMode;
    final isDark = settings.isDarkTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(isVr ? 16 : 24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: EdgeInsets.all(isVr ? 12 : 20),
          decoration: AppColors.japandiCardDecoration(
            isDark,
            borderRadius: isVr ? 16 : 24,
            opacity: 0.35,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Controllo Volume Musica
              _buildVolumeRow(texts[1], settings.musicVolume, (index) => notifier.changeMusicVolume(index), isVr, isDark),
              SizedBox(height: isVr ? 10 : 18),
              
              // Controllo Volume Effetti
              _buildVolumeRow(texts[2], settings.effectsVolume, (index) => notifier.changeEffectsVolume(index), isVr, isDark),
              SizedBox(height: isVr ? 10 : 18),

              // Controllo Volume Voce & Mute
              _buildVoiceVolumeRow(settings, notifier, texts, isVr, isDark),
              Divider(height: isVr ? 20 : 30, color: isDark ? Colors.white10 : Colors.black12),

              // Genere della Voce (Maschile / Femminile)
              _buildVoiceSexRow(settings, notifier, texts, isVr, isDark),
              SizedBox(height: isVr ? 10 : 18),

              // Selezione Lingua (Italiano / Inglese)
              _buildLanguageRow(settings, notifier, texts, isVr, isDark),
              SizedBox(height: isVr ? 10 : 18),

              // Selettore del Tema Dinamico Japandi (Light vs Dark) - RICHIESTO!
              _buildThemeModeRow(settings, notifier, isVr, isDark),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms);
  }

  /// Riga Volume con design minimalista
  Widget _buildVolumeRow(String title, int currentValue, Function(int) onSelected, bool isVr, bool isDark) {
    final textStyle = GoogleFonts.outfit(
      fontSize: isVr ? 11 : 14,
      fontWeight: FontWeight.w700,
      color: AppColors.getTextColor(isDark).withOpacity(0.95),
      letterSpacing: 0.8,
    );

    if (isVr) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: textStyle),
          const SizedBox(height: 5),
          _buildVolumeSelector(currentValue, onSelected, true, isDark),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.toUpperCase(), style: textStyle),
          _buildVolumeSelector(currentValue, onSelected, false, isDark),
        ],
      );
    }
  }

  /// Selettore a 4 pillole orizzontali ad alto feedback visivo
  Widget _buildVolumeSelector(int currentValue, Function(int) onSelected, bool isVr, bool isDark) {
    final double boxWidth = isVr ? 24.0 : 34.0;
    final double boxHeight = isVr ? 18.0 : 24.0;
    final double fontSize = isVr ? 9.0 : 11.0;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    
    return Row(
      children: List.generate(4, (index) {
        final isSelected = currentValue == index;
        return Semantics(button: true, label: "Interactive element", child: GestureDetector(
          onTap: () => onSelected(index),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: boxWidth,
            height: boxHeight,
            decoration: BoxDecoration(
              color: isSelected ? accentColor.withOpacity(0.85) : (isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? accentColor : (isDark ? Colors.white12 : Colors.black12),
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                index.toString(),
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? (isDark ? Colors.black : Colors.white) : AppColors.getSubTextColor(isDark),
                ),
              ),
            ),
          ),
        ));
      }),
    );
  }

  Widget _buildVoiceVolumeRow(SettingsState settings, SettingsNotifier notifier, List<String> texts, bool isVr, bool isDark) {
    final titleStyle = GoogleFonts.outfit(
      fontSize: isVr ? 11 : 14,
      fontWeight: FontWeight.w700,
      color: AppColors.getTextColor(isDark).withOpacity(0.95),
      letterSpacing: 0.8,
    );
    final accentColor = AppColors.getActiveAccentColor(isDark);

    if (isVr) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texts[3].toUpperCase(), style: titleStyle),
          const SizedBox(height: 5),
          Row(
            children: [
              IconButton(
                iconSize: 18,
                constraints: const BoxConstraints(maxHeight: 24, maxWidth: 24),
                padding: EdgeInsets.zero,
                icon: Icon(
                  settings.isVoiceMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: settings.isVoiceMuted ? AppColors.dangerAccent : accentColor,
                ),
                onPressed: () => notifier.toggleVoiceMute(!settings.isVoiceMuted),
              ),
              const SizedBox(width: 8),
              _buildVolumeSelector(settings.voiceVolume, (index) => notifier.changeVoiceVolume(index), true, isDark),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(texts[3].toUpperCase(), style: titleStyle),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  settings.isVoiceMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: settings.isVoiceMuted ? AppColors.dangerAccent : accentColor,
                ),
                onPressed: () => notifier.toggleVoiceMute(!settings.isVoiceMuted),
              ),
              const SizedBox(width: 4),
              _buildVolumeSelector(settings.voiceVolume, (index) => notifier.changeVoiceVolume(index), false, isDark),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildVoiceSexRow(SettingsState settings, SettingsNotifier notifier, List<String> texts, bool isVr, bool isDark) {
    final titleStyle = GoogleFonts.outfit(
      fontSize: isVr ? 11 : 14,
      fontWeight: FontWeight.w700,
      color: AppColors.getTextColor(isDark).withOpacity(0.95),
      letterSpacing: 0.8,
    );

    if (isVr) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texts[4].toUpperCase(), style: titleStyle),
          const SizedBox(height: 5),
          Row(
            children: [
              _buildToggleButton(texts[8], settings.voiceSex == 0, () => notifier.changeVoiceSex(0), true, isDark),
              const SizedBox(width: 8),
              _buildToggleButton(texts[9], settings.voiceSex == 1, () => notifier.changeVoiceSex(1), true, isDark),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(texts[4].toUpperCase(), style: titleStyle),
          Row(
            children: [
              _buildToggleButton(texts[8], settings.voiceSex == 0, () => notifier.changeVoiceSex(0), false, isDark),
              const SizedBox(width: 10),
              _buildToggleButton(texts[9], settings.voiceSex == 1, () => notifier.changeVoiceSex(1), false, isDark),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildLanguageRow(SettingsState settings, SettingsNotifier notifier, List<String> texts, bool isVr, bool isDark) {
    final titleStyle = GoogleFonts.outfit(
      fontSize: isVr ? 11 : 14,
      fontWeight: FontWeight.w700,
      color: AppColors.getTextColor(isDark).withOpacity(0.95),
      letterSpacing: 0.8,
    );

    if (isVr) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texts[5].toUpperCase(), style: titleStyle),
          const SizedBox(height: 5),
          Row(
            children: [
              _buildToggleButton("ITA", settings.language == 0, () => notifier.changeLanguage(0), true, isDark),
              const SizedBox(width: 8),
              _buildToggleButton("ENG", settings.language == 1, () => notifier.changeLanguage(1), true, isDark),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(texts[5].toUpperCase(), style: titleStyle),
          Row(
            children: [
              _buildToggleButton("ITA", settings.language == 0, () => notifier.changeLanguage(0), false, isDark),
              const SizedBox(width: 10),
              _buildToggleButton("ENG", settings.language == 1, () => notifier.changeLanguage(1), false, isDark),
            ],
          ),
        ],
      );
    }
  }

  /// Selettore per il tema dinamico Japandi (Chiaro vs Scuro)
  Widget _buildThemeModeRow(SettingsState settings, SettingsNotifier notifier, bool isVr, bool isDark) {
    final titleStyle = GoogleFonts.outfit(
      fontSize: isVr ? 11 : 14,
      fontWeight: FontWeight.w700,
      color: AppColors.getTextColor(isDark).withOpacity(0.95),
      letterSpacing: 0.8,
    );
    final String label = settings.language == 0 ? "TEMA JAPANDI" : "JAPANDI THEME";

    if (isVr) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: titleStyle),
          const SizedBox(height: 5),
          Row(
            children: [
              _buildToggleButton(settings.language == 0 ? "CHIARO" : "LIGHT", !settings.isDarkTheme, () => notifier.toggleDarkTheme(false), true, isDark),
              const SizedBox(width: 8),
              _buildToggleButton(settings.language == 0 ? "SCURO" : "DARK", settings.isDarkTheme, () => notifier.toggleDarkTheme(true), true, isDark),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: titleStyle),
          Row(
            children: [
              _buildToggleButton(settings.language == 0 ? "CHIARO" : "LIGHT", !settings.isDarkTheme, () => notifier.toggleDarkTheme(false), false, isDark),
              const SizedBox(width: 10),
              _buildToggleButton(settings.language == 0 ? "SCURO" : "DARK", settings.isDarkTheme, () => notifier.toggleDarkTheme(true), false, isDark),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildVrModeRow(SettingsState settings, SettingsNotifier notifier, bool isVr, bool isDark) {
    final titleStyle = GoogleFonts.outfit(
      fontSize: isVr ? 11 : 14,
      fontWeight: FontWeight.w700,
      color: AppColors.getTextColor(isDark).withOpacity(0.95),
      letterSpacing: 0.8,
    );
    final accentColor = AppColors.getActiveAccentColor(isDark);

    if (isVr) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4),
          Text(
            (settings.language == 0 ? "MODALITÀ VR CARDBOARD" : "VR CARDBOARD MODE").toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: accentColor.withOpacity(0.9),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Semantics(button: true, label: "Interactive element", child: GestureDetector(
            onTap: () => notifier.toggleVrMode(false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.dangerAccent.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.dangerAccent.withOpacity(0.8), width: 1.2),
              ),
              child: Text(
                settings.language == 0 ? "DISATTIVA VR" : "DEACTIVATE VR",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          )),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (settings.language == 0 ? "MODALITÀ VR CARDBOARD" : "VR CARDBOARD MODE").toUpperCase(),
            style: titleStyle,
          ),
          Row(
            children: [
              _buildToggleButton("OFF", !settings.isVrMode, () => notifier.toggleVrMode(false), false, isDark),
              const SizedBox(width: 10),
              _buildToggleButton("VR 3D", settings.isVrMode, () => notifier.toggleVrMode(true), false, isDark),
            ],
          ),
        ],
      );
    }
  }

  /// Toggle Button minimalista in stile Japandi
  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap, bool isVr, bool isDark) {
    final accentColor = AppColors.getActiveAccentColor(isDark);
    return Semantics(button: true, label: "Interactive element", child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isVr ? 12 : 18, 
          vertical: isVr ? 6 : 8
        ),
        decoration: BoxDecoration(
          color: isActive ? accentColor.withOpacity(0.85) : (isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? accentColor : (isDark ? Colors.white12 : Colors.black12),
            width: 1.0,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: isVr ? 9 : 12,
            fontWeight: FontWeight.w800,
            color: isActive ? (isDark ? Colors.black : Colors.white) : AppColors.getSubTextColor(isDark),
            letterSpacing: 0.5,
          ),
        ),
      ),
    ));
  }

  /// Pannello per la selezione delle meditazioni e respirazioni Japandi
  Widget _buildSelectionPanel(BuildContext context, SettingsState settings, List<String> texts) {
    final isVr = settings.isVrMode;
    final isDark = settings.isDarkTheme;
    final baseTextColor = AppColors.getTextColor(isDark);

    return ClipRRect(
      borderRadius: BorderRadius.circular(isVr ? 16 : 24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isVr ? 12 : 20),
          decoration: AppColors.japandiCardDecoration(
            isDark,
            borderRadius: isVr ? 16 : 24,
            opacity: 0.35,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sezione Meditazioni in Playfair Display
              Row(
                children: [
                  Icon(Icons.spa_outlined, color: AppColors.getSubTextColor(isDark).withOpacity(0.8), size: isVr ? 16 : 20),
                  const SizedBox(width: 8),
                  Text(
                    texts[13].toUpperCase(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: isVr ? 13 : 18,
                      fontWeight: FontWeight.w800,
                      color: baseTextColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isVr ? 10 : 16),
              
              // Meditazione 1 (Gratis)
              _buildSelectionCard(
                context: context,
                title: texts[15],
                isLocked: false,
                isVr: isVr,
                isDark: isDark,
                onTap: () {
                  launchZenSession(
                    context: context,
                    ref: ref,
                    title: texts[15],
                    voicePath: settings.language == 0
                        ? 'assets/audio/voci/it/meditazione_percorso_acqua_procedimento_it.m4a'
                        : 'assets/audio/voci/en/meditazione_generale.m4a',
                    ambientPath: 'assets/audio/ambient/musica_eterea.m4a',
                  );
                },
              ),
              SizedBox(height: isVr ? 8 : 12),

              // Meditazione 2 (Premium)
              _buildSelectionCard(
                context: context,
                title: texts[16],
                isLocked: !settings.isUnlocked,
                isVr: isVr,
                isDark: isDark,
                onTap: () {
                  if (settings.isUnlocked) {
                    final hour = DateTime.now().hour;
                    final isIt = settings.language == 0;
                    String voiceAsset = isIt 
                        ? 'assets/audio/voci/it/meditazione_percorso_acqua_procedimento_it.m4a'
                        : 'assets/audio/voci/en/meditazione_generale.m4a';
                    
                    if (hour >= 6 && hour < 13) {
                      voiceAsset = isIt 
                          ? 'assets/audio/voci/it/mattina.m4a'
                          : 'assets/audio/voci/en/mattina.m4a';
                    } else if (hour >= 13 && hour < 19) {
                      voiceAsset = isIt 
                          ? 'assets/audio/voci/it/pomeriggio.m4a'
                          : 'assets/audio/voci/en/pomeriggio.m4a';
                    } else {
                      voiceAsset = isIt 
                          ? 'assets/audio/voci/it/sera.m4a'
                          : 'assets/audio/voci/en/sera.m4a';
                    }

                    launchZenSession(
                      context: context,
                      ref: ref,
                      title: texts[16],
                      voicePath: voiceAsset,
                      ambientPath: 'assets/audio/ambient/acqua.mp3',
                    );
                  } else {
                    _setUnlockPanelVisible(true);
                  }
                },
              ),
              Divider(height: isVr ? 20 : 36, color: isDark ? Colors.white10 : Colors.black12),

              // Sezione Respirazioni
              Row(
                children: [
                  Icon(Icons.air_rounded, color: AppColors.getSubTextColor(isDark).withOpacity(0.8), size: isVr ? 16 : 20),
                  const SizedBox(width: 8),
                  Text(
                    texts[14].toUpperCase(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: isVr ? 13 : 18,
                      fontWeight: FontWeight.w800,
                      color: baseTextColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isVr ? 10 : 16),

              // Respirazione 1 (Gratis)
              _buildSelectionCard(
                context: context,
                title: texts[17],
                isLocked: false,
                isVr: isVr,
                isDark: isDark,
                onTap: () {
                  launchZenSession(
                    context: context,
                    ref: ref,
                    title: texts[17],
                    breathingAudioPath: 'assets/audio/respirazioni/vento.m4a',
                  );
                },
              ),
              SizedBox(height: isVr ? 8 : 12),

              // Respirazione 2 (Premium)
              _buildSelectionCard(
                context: context,
                title: texts[18],
                isLocked: !settings.isUnlocked,
                isVr: isVr,
                isDark: isDark,
                onTap: () {
                  if (settings.isUnlocked) {
                    launchZenSession(
                      context: context,
                      ref: ref,
                      title: texts[18],
                      breathingAudioPath: 'assets/audio/respirazioni/cuore.m4a',
                    );
                  } else {
                    _setUnlockPanelVisible(true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }

  /// Scheda di Selezione Premium Japandi
  Widget _buildSelectionCard({
    required BuildContext context,
    required String title,
    required bool isLocked,
    required bool isVr,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Semantics(button: true, label: "Interactive element", child: GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: isVr ? 14 : 20, vertical: isVr ? 11 : 17),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.02),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isLocked 
                  ? AppColors.goldAccent.withOpacity(0.18) 
                  : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isVr ? 12 : 15,
                    fontWeight: FontWeight.w600,
                    color: isLocked ? AppColors.getSubTextColor(isDark).withOpacity(0.8) : AppColors.getTextColor(isDark),
                  ),
                ),
              ),
              if (isLocked)
                Icon(
                  Icons.lock_rounded,
                  color: AppColors.goldAccent.withOpacity(0.8),
                  size: isVr ? 16 : 20,
                )
              else
                Icon(
                  Icons.play_circle_fill_rounded,
                  color: AppColors.successAccent.withOpacity(0.85),
                  size: isVr ? 18 : 24,
                ),
            ],
          ),
        ),
      ),
    ));
  }

  /// Bottoni per links esterni e chiusura app
  Widget _buildFooterButtons(BuildContext context, List<String> texts) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    return Column(
      children: [
        CustomUnityButton(
          text: texts[11],
          onTap: () => _openUrl(0),
          accentColor: AppColors.getSubTextColor(isDark).withOpacity(0.5),
          width: 210,
        ),
        const SizedBox(height: 12),
        CustomUnityButton(
          text: texts[12],
          onTap: () {
            SystemNavigator.pop();
          },
          accentColor: AppColors.dangerAccent,
          width: 210,
        ),
      ],
    ).animate().fadeIn(delay: 550.ms, duration: 500.ms);
  }

  /// Il pannello di sblocco premium a comparsa Japandi
  Widget _buildUnlockOverlay(
    BuildContext context,
    SettingsNotifier notifier,
    List<String> texts,
  ) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final textColor = AppColors.getTextColor(isDark);

    return Stack(
      children: [
        Positioned.fill(
          child: Semantics(button: true, label: "Interactive element", child: GestureDetector(
            onTap: () => _setUnlockPanelVisible(false),
            child: Container(
              color: Colors.black.withOpacity(0.75),
            ),
          )),
        ),

        // Scheda in vetro centrale Japandi
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                width: 325,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                decoration: AppColors.japandiCardDecoration(
                  isDark,
                  borderRadius: 30,
                  opacity: 0.45,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.goldAccent.withOpacity(0.12),
                      ),
                      child: const Icon(
                        Icons.stars_rounded,
                        color: AppColors.goldAccent,
                        size: 50,
                      ),
                    ).animate().scale(duration: 450.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 18),

                    // Titolo Premium in Playfair Display
                    Text(
                      texts[6],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: AppColors.goldAccent,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Descrizione
                    Text(
                      texts[20],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        color: textColor.withOpacity(0.9),
                        height: 1.55,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Vantaggi inclusi
                    Column(
                      children: [
                        _buildBenefitRow(texts[5] == "Lingua" ? "Audio Spaziale 3D Binaurale" : "3D Binaural Spatial Audio", isDark),
                        const SizedBox(height: 8),
                        _buildBenefitRow(texts[5] == "Lingua" ? "Tutte le Meditazioni & Respirazioni" : "All Meditations & Breathings", isDark),
                        const SizedBox(height: 8),
                        _buildBenefitRow(texts[5] == "Lingua" ? "Modalità offline senza pubblicità" : "Offline mode & No Ads", isDark),
                      ],
                    ),
                    const SizedBox(height: 26),

                    // Pulsanti Azione
                    CustomUnityButton(
                      text: texts[19],
                      onTap: () {
                        notifier.unlockPremium();
                        _setUnlockPanelVisible(false);
                      },
                      accentColor: AppColors.successAccent,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 12),
                    CustomUnityButton(
                      text: texts[21],
                      onTap: () => _setUnlockPanelVisible(false),
                      accentColor: AppColors.dangerAccent.withOpacity(0.85),
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().scale(begin: const Offset(0.94, 0.94), end: const Offset(1, 1), curve: Curves.easeOutBack, duration: 300.ms),
      ],
    );
  }

  Widget _buildBenefitRow(String text, bool isDark) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline_rounded, color: AppColors.goldAccent, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextColor(isDark).withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
