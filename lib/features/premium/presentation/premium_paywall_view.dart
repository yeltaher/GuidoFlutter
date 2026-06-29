// ignore_for_file: unused_local_variable, deprecated_member_use, use_build_context_synchronously, curly_braces_in_flow_control_structures, unused_element, unused_field
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import '../../../core/theme/custom_button_widget.dart';
import 'package:guido/l10n/app_localizations.dart';

class PremiumPaywallView extends ConsumerStatefulWidget {
  const PremiumPaywallView({super.key});

  @override
  ConsumerState<PremiumPaywallView> createState() => _PremiumPaywallViewState();
}

class _PremiumPaywallViewState extends ConsumerState<PremiumPaywallView> {
  int _selectedTier = 1; // 0 = 1 Mese, 1 = 1 Anno, 2 = A Vita

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);

    return Scaffold(
      backgroundColor: AppColors.getBgColor(isDark),
      body: Stack(
        children: [
          // Sfondo Gradiente Animato
          RepaintBoundary(
            child: Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.goldAccent.withValues(
                        alpha: isDark ? 0.15 : 0.25,
                      ),
                      AppColors.getBgColor(isDark),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // Pattern in background (opzionale)
          RepaintBoundary(
            child: Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: Image.asset(
                  'assets/images/noise.png', // Assuming a noise texture, fallback to container if missing
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header (Close button)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Semantics(
                        button: true,
                        label: "Interactive element",
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? Colors.white10 : Colors.black12,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: subTextColor,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icona Premium
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.goldAccent.withValues(alpha: 0.12),
                            border: Border.all(
                              color: AppColors.goldAccent.withValues(
                                alpha: 0.3,
                              ),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.stars_rounded,
                            color: AppColors.goldAccent,
                            size: 64,
                          ),
                        ).animate().scale(
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                        ),

                        const SizedBox(height: 24),

                        // Titolo
                        Text(
                              AppLocalizations.of(context)!.premiumTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: textColor,
                                    letterSpacing: -0.5,
                                  ),
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.1, end: 0, duration: 400.ms),

                        const SizedBox(height: 12),

                        // Sottotitolo
                        Text(
                              AppLocalizations.of(context)!.premiumSubtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: subTextColor,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                            )
                            .animate()
                            .fadeIn(delay: 300.ms)
                            .slideY(begin: 0.1, end: 0, duration: 400.ms),

                        const SizedBox(height: 36),

                        // Opzioni di Abbonamento
                        _buildSubscriptionCard(
                              index: 0,
                              title: AppLocalizations.of(
                                context,
                              )!.premium1Month,
                              price: "9,99€",
                              period: AppLocalizations.of(
                                context,
                              )!.premiumPerMonth,
                              isDark: isDark,
                              textColor: textColor,
                              subTextColor: subTextColor,
                            )
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 12),

                        _buildSubscriptionCard(
                              index: 1,
                              title: AppLocalizations.of(context)!.premium1Year,
                              price: "49,99€",
                              period: AppLocalizations.of(
                                context,
                              )!.premiumPerYear,
                              badgeText: AppLocalizations.of(
                                context,
                              )!.premiumRecommended,
                              discountText: AppLocalizations.of(
                                context,
                              )!.premiumSave58,
                              isDark: isDark,
                              textColor: textColor,
                              subTextColor: subTextColor,
                            )
                            .animate()
                            .fadeIn(delay: 500.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 12),

                        _buildSubscriptionCard(
                              index: 2,
                              title: AppLocalizations.of(
                                context,
                              )!.premiumLifetime,
                              price: "149,99€",
                              period: AppLocalizations.of(
                                context,
                              )!.premiumOneTime,
                              isDark: isDark,
                              textColor: textColor,
                              subTextColor: subTextColor,
                            )
                            .animate()
                            .fadeIn(delay: 600.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 40),

                        // Pulsante di Checkout
                        CustomUnityButton(
                              text: AppLocalizations.of(
                                context,
                              )!.premiumActivateNow,
                              onTap: () {
                                ref
                                    .read(settingsProvider.notifier)
                                    .unlockPremium();
                                Navigator.of(context).pop();
                              },
                              accentColor: AppColors.successAccent,
                              width: double.infinity,
                            )
                            .animate()
                            .fadeIn(delay: 700.ms)
                            .scale(begin: const Offset(0.95, 0.95)),

                        const SizedBox(height: 16),

                        Text(
                          AppLocalizations.of(context)!.premiumCancelAnytime,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: subTextColor.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w600,
                              ),
                        ).animate().fadeIn(delay: 800.ms),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required int index,
    required String title,
    required String price,
    required String period,
    String? badgeText,
    String? discountText,
    required bool isDark,
    required Color textColor,
    required Color subTextColor,
  }) {
    final isSelected = _selectedTier == index;
    final cardColor = isSelected
        ? AppColors.goldAccent.withValues(alpha: 0.15)
        : (isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.black.withValues(alpha: 0.03));
    final borderColor = isSelected
        ? AppColors.goldAccent
        : (isDark ? Colors.white12 : Colors.black12);

    return Semantics(
      button: true,
      label: "Interactive element",
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTier = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutQuad,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.goldAccent.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              // Radio button custom
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.goldAccent : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.goldAccent
                        : (isDark ? Colors.white30 : Colors.black26),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: Colors.black87,
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Dettagli piano
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.goldAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badgeText,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black87,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (discountText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        discountText,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.successAccent,
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              // Prezzo
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  Text(
                    period,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: subTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
