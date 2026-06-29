import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:guido/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/custom_button_widget.dart';
import '../../../core/database/settings_provider.dart';
import '../../menu/presentation/home_container_view.dart';
import '../../onboarding/presentation/onboarding_wizard_view.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  void _routeToHome(BuildContext context, WidgetRef ref) {
    final prefs = ref.read(sharedPrefsProvider);
    final isOnboarded = prefs.getBool("IsOnboarded") ?? false;

    final Widget nextScreen = isOnboarded
        ? const HomeContainerView()
        : const OnboardingWizardView();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final double horizontalPadding = isWide
              ? constraints.maxWidth * 0.2
              : 24.0;

          return Stack(
            children: [
              // Sfondo a gradiente Japandi dinamico
              Positioned.fill(
                child: RepaintBoundary(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.getGradientByTime(isDark),
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),

              // Luce d'atmosfera Japandi soffusa
              Positioned(
                top: -80,
                right: -80,
                child: RepaintBoundary(
                  child: Container(
                    key: const ValueKey('login_glow'),
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withValues(
                        alpha: isDark ? 0.05 : 0.08,
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                      child: const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),

              // Contenuto scorrevole
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 20.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Brand Logo
                        Image.asset(
                              'assets/images/logo_transparent.png',
                              height: 120,
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .scale(begin: const Offset(0.8, 0.8)),
                        const SizedBox(height: 12),
                        Text(
                              loc.splashTitle,
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: textColor,
                                    letterSpacing: 10.0,
                                  ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: -0.1, end: 0),
                        const SizedBox(height: 8),
                        Text(
                          loc.splashSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: subTextColor,
                                letterSpacing: 0.2,
                              ),
                        ).animate().fadeIn(delay: 150.ms, duration: 500.ms),

                        const SizedBox(height: 24),

                        // Auth Switch Tab Card estrapolata in widget stateful
                        AuthFormCard(
                          isDark: isDark,
                          accentColor: accentColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          onLoginSuccess: () => _routeToHome(context, ref),
                        ),

                        const SizedBox(height: 20),

                        // TASTO ACCEDI COME OSPITE
                        Semantics(
                          button: true,
                          label: "Interactive element",
                          child: GestureDetector(
                            onTap: () => _routeToHome(context, ref),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.04)
                                    : Colors.black.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white10
                                      : Colors.black12,
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                loc.splashGuestLogin,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: accentColor,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 450.ms, duration: 500.ms),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AuthFormCard extends ConsumerStatefulWidget {
  final bool isDark;
  final Color accentColor;
  final Color textColor;
  final Color subTextColor;
  final VoidCallback onLoginSuccess;

  const AuthFormCard({
    super.key,
    required this.isDark,
    required this.accentColor,
    required this.textColor,
    required this.subTextColor,
    required this.onLoginSuccess,
  });

  @override
  ConsumerState<AuthFormCard> createState() => _AuthFormCardState();
}

class _AuthFormCardState extends ConsumerState<AuthFormCard> {
  bool _isSignUpMode = false;
  bool _acceptTerms = false;
  bool _showPassword = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm(AppLocalizations loc) {
    if (_isSignUpMode) {
      if (_nameController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        _showErrorSnackbar(loc.splashErrorFillFields);
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        _showErrorSnackbar(loc.splashErrorPasswordMismatch);
        return;
      }
      if (!_acceptTerms) {
        _showErrorSnackbar(loc.splashErrorAcceptTerms);
        return;
      }
      final prefs = ref.read(sharedPrefsProvider);
      prefs.setString("ProfileName", _nameController.text.trim());
    } else {
      if (_emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        _showErrorSnackbar(loc.splashErrorEmailPassword);
        return;
      }
    }
    widget.onLoginSuccess();
  }

  void _showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.dangerAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          msg,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return RepaintBoundary(
      child:
          ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: AppColors.japandiCardDecoration(
                      widget.isDark,
                      borderRadius: 28,
                      opacity: 0.38,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: widget.isDark
                                  ? Colors.white.withValues(alpha: 0.03)
                                  : Colors.black.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildAuthTabButton(
                                    label: loc.splashTabLogin,
                                    isSelected: !_isSignUpMode,
                                    onTap: () =>
                                        setState(() => _isSignUpMode = false),
                                  ),
                                ),
                                Expanded(
                                  child: _buildAuthTabButton(
                                    label: loc.splashTabRegister,
                                    isSelected: _isSignUpMode,
                                    onTap: () =>
                                        setState(() => _isSignUpMode = true),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),

                          if (_isSignUpMode) ...[
                            _buildInputField(
                              controller: _nameController,
                              hint: loc.splashNameHint,
                              icon: Icons.person_outline_rounded,
                            ).animate().fadeIn(duration: 300.ms),
                            const SizedBox(height: 14),
                          ],

                          _buildInputField(
                            controller: _emailController,
                            hint: loc.splashEmailHint,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 14),

                          _buildInputField(
                            controller: _passwordController,
                            hint: loc.splashPasswordHint,
                            icon: Icons.lock_outline_rounded,
                            obscure: !_showPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: widget.subTextColor.withValues(
                                  alpha: 0.7,
                                ),
                                size: 18,
                              ),
                              onPressed: () => setState(
                                () => _showPassword = !_showPassword,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          if (_isSignUpMode) ...[
                            _buildInputField(
                              controller: _confirmPasswordController,
                              hint: loc.splashConfirmPasswordHint,
                              icon: Icons.lock_reset_rounded,
                              obscure: true,
                            ).animate().fadeIn(duration: 300.ms),
                            const SizedBox(height: 14),

                            Semantics(
                              button: true,
                              label: "Interactive element",
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => _acceptTerms = !_acceptTerms,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _acceptTerms,
                                      activeColor: widget.accentColor,
                                      checkColor: widget.isDark
                                          ? Colors.black
                                          : Colors.white,
                                      onChanged: (val) => setState(
                                        () => _acceptTerms = val ?? false,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        loc.splashAcceptTerms,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: widget.subTextColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn(duration: 350.ms),
                            const SizedBox(height: 16),
                          ],

                          CustomUnityButton(
                            text: _isSignUpMode
                                ? loc.splashTabRegister
                                : loc.splashTabLogin,
                            onTap: () => _submitForm(loc),
                            accentColor: AppColors.successAccent,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 250.ms, duration: 600.ms)
              .scale(
                begin: const Offset(0.97, 0.97),
                end: const Offset(1, 1),
                curve: Curves.easeOutBack,
              ),
    );
  }

  Widget _buildAuthTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: "Interactive element",
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? widget.accentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? (widget.isDark ? Colors.black : Colors.white)
                    : widget.subTextColor.withValues(alpha: 0.8),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.06),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: widget.textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: widget.subTextColor.withValues(alpha: 0.6),
          ),
          icon: Icon(
            icon,
            color: widget.subTextColor.withValues(alpha: 0.7),
            size: 18,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
