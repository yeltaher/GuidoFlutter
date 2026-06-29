// ignore_for_file: unused_local_variable, deprecated_member_use, use_build_context_synchronously, curly_braces_in_flow_control_structures, unused_element, unused_field
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import 'home_tab.dart';
import 'home_japandi_tab.dart';
import 'meditate_tab.dart';
import 'journal_tab.dart';
import 'me_tab.dart';
import 'settings_tab.dart';

class HomeContainerView extends ConsumerStatefulWidget {
  const HomeContainerView({super.key});

  @override
  ConsumerState<HomeContainerView> createState() => _HomeContainerViewState();
}

class _HomeContainerViewState extends ConsumerState<HomeContainerView> {
  late PageController _pageController;

  final List<Widget> _tabs = const [
    HomeTab(),
    MeditateTab(),
    JournalTab(),
    MeTab(),
    SettingsTab(),
  ];

  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(activeTabProvider);
    _pageController = PageController(initialPage: initialTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final cardColor = AppColors.getCardColor(isDark);
    final subColor = AppColors.getSubTextColor(isDark);

    final currentIndex = ref.watch(activeTabProvider);

    // Ascolta i cambi di tab per animare la pagina con scorrimento a molla 3D
    ref.listen<int>(activeTabProvider, (previous, next) {
      if (_pageController.hasClients && _pageController.page?.round() != next) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutQuint,
        );
      }
    });

    // La modalità VR viene gestita esclusivamente all'interno di MeditationView e BreathingView.
    // Il guscio di navigazione principale rimane sempre in modalità flat.
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody:
          true, // Consente alle pagine di estendersi sotto la bottom navigation bar fluttuante occupando tutto lo schermo
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.getGradientByTime(isDark),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              top:
                  false, // Per consentire al gradiente dello sfondo di estendersi fino al notch
              bottom:
                  false, // Consente il riempimento completo e fluttuante sotto la barra
              left: false,
              right: false,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _tabs.length,
                onPageChanged: (index) {
                  ref.read(activeTabProvider.notifier).state = index;
                },
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  Widget tabWidget;
                  switch (index) {
                    case 0:
                      tabWidget = HomeJapandiTab(
                        isActive: currentIndex == index,
                      );
                      break;
                    case 3:
                      tabWidget = MeTab(isActive: currentIndex == index);
                      break;
                    default:
                      tabWidget = _tabs[index];
                  }

                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 0.0;
                      if (_pageController.position.haveDimensions) {
                        value = (_pageController.page ?? 0) - index;
                      } else {
                        value = (currentIndex - index).toDouble();
                      }

                      value = value.clamp(-1.0, 1.0);

                      // Calcolo dell'effetto Depth (zoom-out tridimensionale)
                      final double scale = 1.0 - (value.abs() * 0.10);
                      final double opacity = 1.0 - (value.abs() * 0.60);

                      // Calcolo dell'effetto Parallasse e Rotazione (3D tilt di stampo premium)
                      final double rotationY =
                          value * -0.12; // Leggera rotazione 3D sull'asse Y

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.0008) // Aggiunge prospettiva 3D
                          ..scale(scale, scale)
                          ..rotateY(rotationY),
                        alignment: Alignment.center,
                        child: Opacity(
                          opacity: opacity.clamp(0.0, 1.0),
                          child: child,
                        ),
                      );
                    },
                    child: tabWidget,
                  );
                },
              ),
            ),

            // Barra di navigazione fluttuante posizionata esplicitamente in alto a sovrapporsi
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? cardColor.withValues(alpha: 0.25)
                          : cardColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.04),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.2 : 0.01,
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            0,
                            Icons.home_rounded,
                            Icons.home_rounded,
                            "Home",
                            isDark,
                            accentColor,
                            subColor,
                            textColor,
                          ),
                          _buildNavItem(
                            1,
                            Icons.spa_outlined,
                            Icons.spa,
                            "Meditate",
                            isDark,
                            accentColor,
                            subColor,
                            textColor,
                          ),
                          _buildNavItem(
                            2,
                            Icons.book_outlined,
                            Icons.book,
                            "Journal",
                            isDark,
                            accentColor,
                            subColor,
                            textColor,
                          ),
                          _buildNavItem(
                            3,
                            Icons.person_outline,
                            Icons.person,
                            "Me",
                            isDark,
                            accentColor,
                            subColor,
                            textColor,
                          ),
                          _buildNavItem(
                            4,
                            Icons.settings_outlined,
                            Icons.settings,
                            "Settings",
                            isDark,
                            accentColor,
                            subColor,
                            textColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData iconOutline,
    IconData iconSelected,
    String label,
    bool isDark,
    Color accentColor,
    Color subColor,
    Color textColor,
  ) {
    final currentIndex = ref.watch(activeTabProvider);
    final isSelected = currentIndex == index;

    return Semantics(
      button: true,
      label: "Interactive element",
      child: GestureDetector(
        onTap: () {
          if (currentIndex != index) {
            ref.read(activeTabProvider.notifier).state = index;
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icona minimal del tab (in salvia desaturato quando selezionato)
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              padding: const EdgeInsets.all(4),
              child: Icon(
                isSelected ? iconSelected : iconOutline,
                color: isSelected
                    ? accentColor
                    : subColor.withValues(alpha: 0.7),
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            // Testo etichetta minimal in Plus Jakarta Sans
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected ? textColor : subColor.withValues(alpha: 0.6),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            // Pallino indicatore attivo animato sotto l'icona (come da mockup)
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              scale: isSelected ? 1.0 : 0.0,
              child: Container(
                width: 4.0,
                height: 4.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == 0 ? accentColor : accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
