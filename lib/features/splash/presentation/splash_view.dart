import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/custom_button_widget.dart';
import '../../../core/database/settings_provider.dart';
import '../../menu/presentation/home_container_view.dart';
import '../../onboarding/presentation/onboarding_wizard_view.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> with SingleTickerProviderStateMixin {
  bool _isSignUpMode = false;
  bool _acceptTerms = false;
  bool _showPassword = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _routeToHome() {
    final prefs = ref.read(sharedPrefsProvider);
    final isOnboarded = prefs.getBool("IsOnboarded") ?? false;

    final Widget nextScreen = isOnboarded 
        ? const HomeContainerView() 
        : const OnboardingWizardView();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  void _submitForm() {
    // Validazione dei campi per Login/Registrazione reale
    if (_isSignUpMode) {
      if (_nameController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        _showErrorSnackbar("Compila tutti i campi obbligatori!");
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        _showErrorSnackbar("Le password non coincidono!");
        return;
      }
      if (!_acceptTerms) {
        _showErrorSnackbar("Devi accettare i termini di servizio!");
        return;
      }
      
      // Salva il nome inserito in registrazione come predefinito
      final prefs = ref.read(sharedPrefsProvider);
      prefs.setString("ProfileName", _nameController.text.trim());
    } else {
      if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
        _showErrorSnackbar("Inserisci email e password!");
        return;
      }
    }

    // Login avvenuto con successo (simulato per consentire l'accesso immediato)
    _routeToHome();
  }

  void _showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.dangerAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          msg,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Sfondo a gradiente Japandi dinamico
          Positioned.fill(
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

          // Luce d'atmosfera Japandi soffusa sullo sfondo
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              key: const ValueKey('login_glow'),
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(isDark ? 0.05 : 0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: const SizedBox.shrink(),
              ),
            ),
          ),

          // 2. Contenuto scorrevole
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Logo
                    Image.asset(
                      'assets/images/logo_transparent.png',
                      height: 120,
                    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),
                    const SizedBox(height: 12),
                    Text(
                      "GUIDO",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        letterSpacing: 10.0,
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.1, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      "Il tuo compagno per la meditazione ed il respiro",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: subTextColor,
                        letterSpacing: 0.2,
                      ),
                    ).animate().fadeIn(delay: 150.ms, duration: 500.ms),
                    
                    const SizedBox(height: 24),

                    // Auth Switch Tab Card (Claymorphic)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: AppColors.japandiCardDecoration(
                            isDark,
                            borderRadius: 28,
                            opacity: 0.38,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Form Tab Switcher (Accedi / Registrati)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _buildAuthTabButton(
                                          label: "ACCEDI",
                                          isSelected: !_isSignUpMode,
                                          onTap: () => setState(() => _isSignUpMode = false),
                                          isDark: isDark,
                                          accentColor: accentColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildAuthTabButton(
                                          label: "REGISTRATI",
                                          isSelected: _isSignUpMode,
                                          onTap: () => setState(() => _isSignUpMode = true),
                                          isDark: isDark,
                                          accentColor: accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 22),

                                // 1. NOME (Solo in modalità Sign Up)
                                if (_isSignUpMode) ...[
                                  _buildInputField(
                                    controller: _nameController,
                                    hint: "Nome completo",
                                    icon: Icons.person_outline_rounded,
                                    isDark: isDark,
                                    textColor: textColor,
                                    subTextColor: subTextColor,
                                  ).animate().fadeIn(duration: 300.ms),
                                  const SizedBox(height: 14),
                                ],

                                // 2. EMAIL
                                _buildInputField(
                                  controller: _emailController,
                                  hint: "Indirizzo Email",
                                  icon: Icons.email_outlined,
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 14),

                                // 3. PASSWORD
                                _buildInputField(
                                  controller: _passwordController,
                                  hint: "Password",
                                  icon: Icons.lock_outline_rounded,
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                  obscure: !_showPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: subTextColor.withOpacity(0.7),
                                      size: 18,
                                    ),
                                    onPressed: () => setState(() => _showPassword = !_showPassword),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // 4. CONFERMA PASSWORD (Solo in modalità Sign Up)
                                if (_isSignUpMode) ...[
                                  _buildInputField(
                                    controller: _confirmPasswordController,
                                    hint: "Conferma Password",
                                    icon: Icons.lock_reset_rounded,
                                    isDark: isDark,
                                    textColor: textColor,
                                    subTextColor: subTextColor,
                                    obscure: true,
                                  ).animate().fadeIn(duration: 300.ms),
                                  const SizedBox(height: 14),
                                ],

                                // Accettazione Termini (Solo in modalità Sign Up)
                                if (_isSignUpMode) ...[
                                  GestureDetector(
                                    onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: _acceptTerms,
                                          activeColor: accentColor,
                                          checkColor: isDark ? Colors.black : Colors.white,
                                          onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Accetto Termini e Condizioni e Privacy Policy",
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                              color: subTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).animate().fadeIn(duration: 350.ms),
                                  const SizedBox(height: 16),
                                ],

                                // Pulsante di autenticazione principale
                                CustomUnityButton(
                                  text: _isSignUpMode ? "REGISTRATI" : "ACCEDI",
                                  onTap: _submitForm,
                                  accentColor: AppColors.successAccent,
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 250.ms, duration: 600.ms).scale(begin: const Offset(0.97, 0.97), end: const Offset(1, 1), curve: Curves.easeOutBack),

                    const SizedBox(height: 20),

                    // TASTO ACCEDI COME OSPITE (ACCESSIBILITÀ DIRETTA)
                    GestureDetector(
                      onTap: _routeToHome,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? Colors.white10 : Colors.black12,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          "ENTRA COME OSPITE",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                            letterSpacing: 0.5,
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
      ),
    );
  }

  Widget _buildAuthTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required Color accentColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isSelected 
                  ? (isDark ? Colors.black : Colors.white) 
                  : AppColors.getSubTextColor(isDark).withOpacity(0.8),
              letterSpacing: 0.5,
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
    required bool isDark,
    required Color textColor,
    required Color subTextColor,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: GoogleFonts.plusJakartaSans(fontSize: 13.5, color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: subTextColor.withOpacity(0.6)),
          icon: Icon(icon, color: subTextColor.withOpacity(0.7), size: 18),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
