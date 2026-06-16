import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';

class ZenSoundMixerView extends ConsumerStatefulWidget {
  const ZenSoundMixerView({Key? key}) : super(key: key);

  @override
  ConsumerState<ZenSoundMixerView> createState() => _ZenSoundMixerViewState();
}

class _ZenSoundMixerViewState extends ConsumerState<ZenSoundMixerView> with TickerProviderStateMixin {
  late AudioPlayer _waterPlayer;
  late AudioPlayer _windPlayer;
  late AudioPlayer _musicPlayer;

  bool _isWaterPlaying = false;
  bool _isWindPlaying = false;
  bool _isMusicPlaying = false;

  double _waterVolume = 0.5;
  double _windVolume = 0.5;
  double _musicVolume = 0.5;

  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    
    // Inizializza i lettori audio indipendenti per il mixer
    _waterPlayer = AudioPlayer();
    _windPlayer = AudioPlayer();
    _musicPlayer = AudioPlayer();

    // Configura i loop
    _initPlayers();

    // Animazioni di atmosfera
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  Future<void> _initPlayers() async {
    try {
      await _waterPlayer.setAsset('assets/audio/ambient/acqua.mp3');
      await _waterPlayer.setLoopMode(LoopMode.one);
      await _waterPlayer.setVolume(_waterVolume);

      await _windPlayer.setAsset('assets/audio/respirazioni/vento.m4a');
      await _windPlayer.setLoopMode(LoopMode.one);
      await _windPlayer.setVolume(_windVolume);

      await _musicPlayer.setAsset('assets/audio/ambient/musica_eterea.m4a');
      await _musicPlayer.setLoopMode(LoopMode.one);
      await _musicPlayer.setVolume(_musicVolume);
    } catch (_) {}
  }

  @override
  void dispose() {
    _waterPlayer.dispose();
    _windPlayer.dispose();
    _musicPlayer.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleWater() {
    setState(() {
      _isWaterPlaying = !_isWaterPlaying;
      if (_isWaterPlaying) {
        _waterPlayer.play();
      } else {
        _waterPlayer.pause();
      }
    });
  }

  void _toggleWind() {
    setState(() {
      _isWindPlaying = !_isWindPlaying;
      if (_isWindPlaying) {
        _windPlayer.play();
      } else {
        _windPlayer.pause();
      }
    });
  }

  void _toggleMusic() {
    setState(() {
      _isMusicPlaying = !_isMusicPlaying;
      if (_isMusicPlaying) {
        _musicPlayer.play();
      } else {
        _musicPlayer.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);
    final cardColor = AppColors.getCardColor(isDark);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Sfondo blurato glassmorphic su gradiente
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                color: isDark ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.4),
              ),
            ),
          ),

          // Luce Zen fluttuante
          Positioned(
            top: 150,
            left: 50,
            right: 50,
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(isDark ? 0.04 : 0.08),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                  child: const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                        color: textColor,
                        onPressed: () => context.pop(),
                      ),
                      Text(
                        settings.language == 0 ? "MIXER DI SUONI" : "SOUND MIXER",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: subTextColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 48), // bilanciamento
                    ],
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 10),

                  // Mandala rotante e pulsante in mezzo
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Sfondo bagliore
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final scale = 0.85 + (_pulseController.value * 0.15);
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: 170,
                                  height: 170,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: accentColor.withOpacity(0.04),
                                    border: Border.all(color: accentColor.withOpacity(0.1), width: 1.5),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Mandala in lenta rotazione
                          RotationTransition(
                            turns: _rotationController,
                            child: Icon(
                              Icons.spa_rounded,
                              size: 78,
                              color: accentColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Mixer sliders
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Card Sound 1: 🌊 ACQUA
                        _buildMixerCard(
                          title: settings.language == 0 ? "🌊 Pioggia e Acqua" : "🌊 Rain & Water",
                          isPlaying: _isWaterPlaying,
                          volume: _waterVolume,
                          isDark: isDark,
                          accentColor: accentColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          cardColor: cardColor,
                          onToggle: _toggleWater,
                          onVolumeChanged: (val) {
                            setState(() {
                              _waterVolume = val;
                              _waterPlayer.setVolume(_waterVolume);
                            });
                          },
                        ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(begin: 0.05, end: 0),

                        const SizedBox(height: 14),

                        // Card Sound 2: 🍃 VENTO
                        _buildMixerCard(
                          title: settings.language == 0 ? "🍃 Soffio del Vento" : "🍃 Whisper of Wind",
                          isPlaying: _isWindPlaying,
                          volume: _windVolume,
                          isDark: isDark,
                          accentColor: accentColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          cardColor: cardColor,
                          onToggle: _toggleWind,
                          onVolumeChanged: (val) {
                            setState(() {
                              _windVolume = val;
                              _windPlayer.setVolume(_windVolume);
                            });
                          },
                        ).animate().fadeIn(delay: 250.ms, duration: 400.ms).slideY(begin: 0.05, end: 0),

                        const SizedBox(height: 14),

                        // Card Sound 3: 🎵 MUSICA
                        _buildMixerCard(
                          title: settings.language == 0 ? "🎵 Onde Eteree" : "🎵 Ethereal Waves",
                          isPlaying: _isMusicPlaying,
                          volume: _musicVolume,
                          isDark: isDark,
                          accentColor: accentColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          cardColor: cardColor,
                          onToggle: _toggleMusic,
                          onVolumeChanged: (val) {
                            setState(() {
                              _musicVolume = val;
                              _musicPlayer.setVolume(_musicVolume);
                            });
                          },
                        ).animate().fadeIn(delay: 350.ms, duration: 400.ms).slideY(begin: 0.05, end: 0),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tasto Esci con click elastico
                  Semantics(button: true, label: "Interactive element", child: GestureDetector(
                    onTapDown: (_) {},
                    child: OnboardingSpringButton(
                      onTap: () => context.pop(),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.black12,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            settings.language == 0 ? "RITORNA AL GIARDINO" : "RETURN TO GARDEN",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )).animate().fadeIn(delay: 450.ms),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMixerCard({
    required String title,
    required bool isPlaying,
    required double volume,
    required bool isDark,
    required Color accentColor,
    required Color textColor,
    required Color subTextColor,
    required Color cardColor,
    required VoidCallback onToggle,
    required ValueChanged<double> onVolumeChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: AppColors.japandiCardDecoration(isDark, borderRadius: 24.0, opacity: 0.45),
      child: Row(
        children: [
          // Toggle icon con springy feel
          OnboardingSpringButton(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isPlaying ? accentColor : (isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPlaying ? accentColor : (isDark ? Colors.white12 : Colors.black12),
                  width: 1.0,
                ),
              ),
              child: Icon(
                isPlaying ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                color: isPlaying ? (isDark ? Colors.black : Colors.white) : subTextColor,
                size: 18,
              ),
            ),
          ),
          
          const SizedBox(width: 16),

          // Slider e Titolo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isPlaying ? accentColor : textColor,
                  ),
                ),
                const SizedBox(height: 2),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3.0,
                    activeTrackColor: accentColor,
                    inactiveTrackColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.1),
                    thumbColor: accentColor,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    overlayColor: accentColor.withOpacity(0.12),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
                  ),
                  child: Slider(
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: isPlaying ? onVolumeChanged : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget ricopiato localmente per retrocompatibilità in caso di import ritardati
class OnboardingSpringButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const OnboardingSpringButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  State<OnboardingSpringButton> createState() => _OnboardingSpringButtonState();
}

class _OnboardingSpringButtonState extends State<OnboardingSpringButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(button: true, label: "Interactive element", child: GestureDetector(
      onTapDown: (_) => _controller.animateTo(1.0, duration: const Duration(milliseconds: 80), curve: Curves.easeOut),
      onTapUp: (_) {
        _controller.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.elasticOut);
        widget.onTap();
      },
      onTapCancel: () => _controller.animateTo(0.0, duration: const Duration(milliseconds: 150), curve: Curves.easeOut),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    ));
  }
}
