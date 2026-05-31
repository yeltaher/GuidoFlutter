import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import '../../menu/presentation/home_container_view.dart';

class OnboardingWizardView extends ConsumerStatefulWidget {
  const OnboardingWizardView({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingWizardView> createState() => _OnboardingWizardViewState();
}

class _OnboardingWizardViewState extends ConsumerState<OnboardingWizardView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 10; // Steps 1-8 are Qs, Step 9 is loading, Step 10 is final recommendation

  // Form & Input States
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Profile Customization States
  int _selectedCommitment = 1; // 0 = 5min, 1 = 10min, 2 = 20min, 3 = 30min+
  int _selectedStyle = 0; // 0 = Guided, 1 = Music, 2 = Silence, 3 = Breathing

  // Quiz States (Multi-select Lists)
  final List<String> _selectedProblems = [];
  final List<String> _selectedGoals = [];
  final List<String> _selectedStrengths = [];
  final List<String> _selectedWeaknesses = [];
  final List<String> _selectedDesires = [];

  // Animation & Transition triggers
  bool _isProcessing = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }
    if (_currentPage < _totalPages - 1) {
      FocusScope.of(context).unfocus();
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );

      // Se siamo arrivati alla pagina di caricamento (Step 9)
      if (_currentPage == 8) {
        _runProcessingAnimation();
      }
    }
  }

  void _prevPage() {
    if (_currentPage > 0 && _currentPage != 8) { // Non consentiamo il ritorno durante l'elaborazione o dopo
      FocusScope.of(context).unfocus();
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // Simula il calcolo personalizzato del sentiero Zen dell'utente per 2.5 secondi
  void _runProcessingAnimation() async {
    setState(() {
      _isProcessing = true;
    });
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _currentPage = 9;
      });
      _pageController.jumpToPage(9);
    }
  }

  // Salva le risposte locali e porta l'utente nella Home
  void _completeOnboarding() async {
    final prefs = ref.read(sharedPrefsProvider);
    
    // Salvataggio dei dati personali in SharedPreferences
    await prefs.setString("ProfileName", _nameController.text.trim());
    await prefs.setInt("ProfileCommitment", _selectedCommitment);
    await prefs.setInt("ProfileStyle", _selectedStyle);
    await prefs.setStringList("QuizProblems", _selectedProblems);
    await prefs.setStringList("QuizGoals", _selectedGoals);
    await prefs.setStringList("QuizStrengths", _selectedStrengths);
    await prefs.setStringList("QuizWeaknesses", _selectedWeaknesses);
    await prefs.setStringList("QuizDesires", _selectedDesires);
    
    // Salva il percorso raccomandato
    final recommended = _calculateRecommendation();
    await prefs.setString("QuizRecommendedTitle", recommended["title"] ?? "Meditazione Naturale");
    await prefs.setString("QuizRecommendedDesc", recommended["desc"] ?? "");
    await prefs.setString("QuizRecommendedBadge", recommended["badge"] ?? "");

    // Segna l'onboarding come completato
    await prefs.setBool("IsOnboarded", true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeContainerView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    }
  }

  // Genera la raccomandazione del percorso in base alle scelte dell'utente
  Map<String, String> _calculateRecommendation() {
    // Calcoliamo se consigliare meditazione acqua, vento, o naturale
    if (_selectedProblems.contains("Ansia o stress eccessivo") || _selectedGoals.contains("Ritrovare la pace interiore")) {
      return {
        "title": "Percorso Acqua (Consigliato)",
        "desc": "Una meditazione fluida incentrata sullo scorrere dei pensieri per allentare tensioni mentali e ritrovare la tua calma interiore.",
        "badge": "CALMA & RILASSAMENTO",
      };
    } else if (_selectedProblems.contains("Mancanza di concentrazione") || _selectedGoals.contains("Migliorare la produttività")) {
      return {
        "title": "Respiro del Vento (Consigliato)",
        "desc": "Un ciclo respiratorio energizzante e focalizzato per spazzare via il rumore mentale e centrare l'attenzione sul presente.",
        "badge": "FOCUS & CHIAREZZA",
      };
    } else {
      return {
        "title": "Meditazione Naturale (Consigliato)",
        "desc": "Un percorso immersivo che unisce la respirazione lenta alla connessione mentale con i suoni organici della natura selvatica.",
        "badge": "RILASSAMENTO PROFONDO",
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _currentPage < 8
          ? Container(
              color: Colors.transparent,
              child: SafeArea(
                top: false,
                bottom: true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Pulsante Indietro
                      Opacity(
                        opacity: _currentPage > 0 ? 1.0 : 0.0,
                        child: IgnorePointer(
                          ignoring: _currentPage == 0,
                          child: OnboardingSpringButton(
                            onTap: _prevPage,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              child: Text(
                                "INDIETRO",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: subTextColor,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Pulsante Avanti
                      Flexible(
                        child: OnboardingSpringButton(
                          onTap: _nextPage,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 220),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      _currentPage == 7 ? "SCOPRI IL TUO SENTIERO" : "AVANTI",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? Colors.black : Colors.white,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: isDark ? Colors.black : Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          // 1. Sfondo a gradiente Japandi dinamico coerente con l'app
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
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(isDark ? 0.04 : 0.07),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: const SizedBox.shrink(),
              ),
            ),
          ),

          // 2. Struttura principale dell'Onboarding
          SafeArea(
            child: Column(
              children: [
                // Top Progress Bar (solo durante le domande, nascondi in caricamento e fine)
                if (_currentPage < 8)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "SETUP ZEN",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: subTextColor,
                                letterSpacing: 1.5,
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: animation.drive(
                                      Tween<Offset>(
                                        begin: const Offset(0.0, 0.35),
                                        end: Offset.zero,
                                      ),
                                    ),
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                "${_currentPage + 1} di 8",
                                key: ValueKey<int>(_currentPage),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: subTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: (_currentPage + 1) / 8),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return Stack(
                                  children: [
                                    Container(
                                      height: 6,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.white10 : Colors.black12,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    Container(
                                      height: 6,
                                      width: constraints.maxWidth * value,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            accentColor.withOpacity(0.6),
                                            accentColor,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(3),
                                        boxShadow: [
                                          BoxShadow(
                                            color: accentColor.withOpacity(0.35),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                // Pagine del Setup
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(), // Bloccato: una cosa alla volta con i pulsanti
                    children: [
                      _buildStepName(textColor, subTextColor, accentColor, isDark),
                      _buildStepCommitment(textColor, subTextColor, accentColor, isDark),
                      _buildStepStyle(textColor, subTextColor, accentColor, isDark),
                      _buildStepProblems(textColor, subTextColor, accentColor, isDark),
                      _buildStepGoals(textColor, subTextColor, accentColor, isDark),
                      _buildStepStrengths(textColor, subTextColor, accentColor, isDark),
                      _buildStepWeaknesses(textColor, subTextColor, accentColor, isDark),
                      _buildStepDesires(textColor, subTextColor, accentColor, isDark),
                      _buildStepProcessing(textColor, subTextColor, accentColor, isDark),
                      _buildStepRecommendation(textColor, subTextColor, accentColor, isDark),
                    ],
                  ),
                ),
                // Barra Navigazione Inferiore spostata in Scaffold.bottomNavigationBar
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET DI CONFIGURAZIONE DEGLI STEP ---

  // STEP 1: Richiesta Nome con validazione
  Widget _buildStepName(Color textColor, Color subTextColor, Color accentColor, bool isDark) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 100.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              "Benvenuto in Guido.",
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 10),
            Text(
              "Iniziamo impostando il tuo profilo personale. Come preferisci che ti chiamiamo?",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: subTextColor,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
            const SizedBox(height: 30),
            
            // Input Box stile Claymorphic
            Container(
              decoration: AppColors.japandiCardDecoration(isDark, borderRadius: 22.0, opacity: 0.4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                    child: TextFormField(
                      controller: _nameController,
                      style: GoogleFonts.plusJakartaSans(fontSize: 16, color: textColor, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "Scrivi qui il tuo nome...",
                        hintStyle: GoogleFonts.plusJakartaSans(color: subTextColor.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Per favore, inserisci un nome per il profilo";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  // STEP 2: Impegno temporale giornaliero
  Widget _buildStepCommitment(Color textColor, Color subTextColor, Color accentColor, bool isDark) {
    final List<Map<String, dynamic>> options = [
      {"title": "🧘  5 Minuti", "desc": "Ideale per pause brevi ed efficaci"},
      {"title": "🌿  10 Minuti", "desc": "Raccomandato per principianti"},
      {"title": "🌊  20 Minuti", "desc": "Perfetto per approfondire la presenza"},
      {"title": "🏔️  30+ Minuti", "desc": "Per un rilassamento e immersione totale"},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 100.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "Ritrova il tuo tempo.",
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: -0.5,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text(
            "Quanto tempo desideri dedicare alla tua meditazione quotidiana?",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: subTextColor,
              height: 1.45,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 24),

          // Griglia di opzioni a selezione singola
          Column(
            children: List.generate(options.length, (idx) {
              final isSelected = _selectedCommitment == idx;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: OnboardingChoiceCard(
                  title: options[idx]["title"]!,
                  desc: options[idx]["desc"]!,
                  isSelected: isSelected,
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  accentColor: accentColor,
                  onTap: () {
                    setState(() {
                      _selectedCommitment = idx;
                    });
                  },
                ),
              ).animate().fadeIn(delay: (200 + idx * 50).ms, duration: 350.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack, duration: 400.ms);
            }),
          ),
        ],
      ),
    );
  }

  // STEP 3: Stile di Meditazione Preferito
  Widget _buildStepStyle(Color textColor, Color subTextColor, Color accentColor, bool isDark) {
    final List<Map<String, dynamic>> options = [
      {"title": "🎙️  Voce Guida", "desc": "Un insegnante ti accompagna passo-passo"},
      {"title": "🎵  Solo Musica", "desc": "Sfondi acustici ed eterei della natura"},
      {"title": "🤫  Silenzio Zen", "desc": "Meditazione silenziosa senza accompagnamento"},
      {"title": "🫁  Respirazione", "desc": "Sessioni focalizzate sul controllo polmonare"},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 100.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "Il tuo stile preferito.",
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: -0.5,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text(
            "Quale tipologia di sessione si adatta meglio alla tua routine?",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: subTextColor,
              height: 1.45,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 24),

          Column(
            children: List.generate(options.length, (idx) {
              final isSelected = _selectedStyle == idx;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: OnboardingChoiceCard(
                  title: options[idx]["title"]!,
                  desc: options[idx]["desc"]!,
                  isSelected: isSelected,
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  accentColor: accentColor,
                  onTap: () {
                    setState(() {
                      _selectedStyle = idx;
                    });
                  },
                ),
              ).animate().fadeIn(delay: (200 + idx * 50).ms, duration: 350.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack, duration: 400.ms);
            }),
          ),
        ],
      ),
    );
  }

  // STEP 4: Quiz - Difficoltà / Problemi riscontrati (Multi-select)
  Widget _buildStepProblems(Color textColor, Color subTextColor, Color accentColor, bool isDark) {
    final List<String> options = [
      "Ansia o stress eccessivo",
      "Difficoltà ad addormentarmi",
      "Mancanza di concentrazione",
      "Stanchezza mentale / Burnout",
      "Difficoltà a gestire le emozioni",
    ];

    return _buildMultiSelectStep(
      title: "Cosa ti preoccupa di più?",
      desc: "Seleziona le sfide o i problemi principali che riscontri maggiormente in questo periodo:",
      options: options,
      selectedList: _selectedProblems,
      textColor: textColor,
      subTextColor: subTextColor,
      accentColor: accentColor,
      isDark: isDark,
    );
  }

  // STEP 5: Quiz - Obiettivi (Multi-select)
  Widget _buildStepGoals(Color textColor, Color subTextColor, Color accentColor, bool isDark) {
    final List<String> options = [
      "Ritrovare la pace interiore",
      "Dormire meglio e profondamente",
      "Migliorare la produttività",
      "Imparare a respirare consapevolmente",
      "Sbloccare il mio potenziale spirituale",
    ];

    return _buildMultiSelectStep(
      title: "I tuoi obiettivi.",
      desc: "Cosa desideri ottenere principalmente attraverso la tua pratica su Guido?",
      options: options,
      selectedList: _selectedGoals,
      textColor: textColor,
      subTextColor: subTextColor,
      accentColor: accentColor,
      isDark: isDark,
    );
  }

  // STEP 6: Quiz - Punti Forti (Multi-select)
  Widget _buildStepStrengths(Color textColor, Color subTextColor, Color accentColor, bool isDark) {
    final List<String> options = [
      "Sono aperto alle novità",
      "Sono molto determinato",
      "So ascoltare il mio corpo",
      "Riesco a trovare del tempo per me",
      "Ho un atteggiamento positivo",
    ];

    return _buildMultiSelectStep(
      title: "I tuoi punti forti.",
      desc: "Quali sono le tue risorse interiori o le tue qualità migliori in questo istante?",
      options: options,
      selectedList: _selectedStrengths,
      textColor: textColor,
      subTextColor: subTextColor,
      accentColor: accentColor,
      isDark: isDark,
    );
  }

  // STEP 7: Quiz - Punti Deboli (Multi-select)
  Widget _buildStepWeaknesses(Color textColor, Color subTextColor, Color accentColor, bool isDark) {
    final List<String> options = [
      "Mi distraggo facilmente",
      "Tendo a procrastinare",
      "Ho ritmi di sonno irregolari",
      "Mi sento sopraffatto dai pensieri",
      "Faccio fatica a rilassarmi del tutto",
    ];

    return _buildMultiSelectStep(
      title: "Le tue fragilità.",
      desc: "Su quali aspetti o punti deboli interiori vorresti lavorare maggiormente?",
      options: options,
      selectedList: _selectedWeaknesses,
      textColor: textColor,
      subTextColor: subTextColor,
      accentColor: accentColor,
      isDark: isDark,
    );
  }

  // STEP 8: Quiz - Cosa si vuole tassativamente ottenere (Multi-select)
  Widget _buildStepDesires(Color textColor, Color subTextColor, Color accentColor, bool isDark) {
    final List<String> options = [
      "Un rituale quotidiano da seguire",
      "Una guida vocale che mi ispiri",
      "Uno spazio intimo offline per riflettere",
      "Tecniche di respirazione avanzate",
      "Un'esperienza immersiva in 3D/VR",
    ];

    return _buildMultiSelectStep(
      title: "Cosa vuoi da Guido?",
      desc: "Cosa vorresti tassativamente trovare e sperimentare all'interno dell'app?",
      options: options,
      selectedList: _selectedDesires,
      textColor: textColor,
      subTextColor: subTextColor,
      accentColor: accentColor,
      isDark: isDark,
    );
  }

  // STEP 9: Processing Animation (Mandala loop)
  Widget _buildStepProcessing(Color textColor, Color subTextColor, Color accentColor, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mandala animato polmonare per simulare respiro profondo di caricamento
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.08),
                border: Border.all(color: accentColor.withOpacity(0.2), width: 2),
              ),
              child: Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withOpacity(0.2),
                  ),
                ),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 2.seconds, curve: Curves.easeInOutSine),
            
            const SizedBox(height: 40),
            
            Text(
              "Sto tessendo il tuo percorso...",
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 12),
            Text(
              "Guido sta analizzando le tue risposte per strutturare una routine di consapevolezza su misura per te.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: subTextColor,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  // STEP 10: Schermata Finale di Raccomandazione Custom
  Widget _buildStepRecommendation(Color textColor, Color subTextColor, Color accentColor, bool isDark) {
    final recommendation = _calculateRecommendation();
    final name = _nameController.text.trim();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Icona Successo animata
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.successAccent.withOpacity(0.12),
                ),
                child: const Icon(
                  Icons.spa_rounded,
                  color: AppColors.successAccent,
                  size: 34,
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              
              const SizedBox(height: 20),
              
              Text(
                "Profilo Zen Creato!",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ).animate().fadeIn(delay: 150.ms),
              
              const SizedBox(height: 6),
              
              Text(
                "Benvenuto nel tuo cammino, $name.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: subTextColor,
                ),
              ).animate().fadeIn(delay: 250.ms),
              
              const SizedBox(height: 24),

              // Scheda Raccomandazione Vetrificata Glassmorphic
              ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: AppColors.japandiCardDecoration(
                      isDark,
                      borderRadius: 26,
                      opacity: 0.35,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge Percorso Consigliato
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: accentColor.withOpacity(0.2), width: 1.0),
                          ),
                          child: Text(
                            recommendation["badge"]!.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Titolo
                        Text(
                          recommendation["title"]!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        
                        // Descrizione
                        Text(
                          recommendation["desc"]!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: subTextColor.withOpacity(0.9),
                            height: 1.45,
                          ),
                        ),
                        
                        const SizedBox(height: 18),
                        
                        // Piccola icona con promemoria tempo quotidiano scelto
                        Row(
                          children: [
                            Icon(Icons.alarm_on_rounded, size: 16, color: accentColor),
                            const SizedBox(width: 6),
                            Text(
                              "Impegno scelto: ${_selectedCommitmentText()}",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.05, end: 0),
              
              const SizedBox(height: 30),

              // Bottone Finale di Completamento
              GestureDetector(
                onTap: _completeOnboarding,
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.successAccent,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "ENTRA NELLO SPAZIO ZEN",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.spa_outlined, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER METODI ---

  String _selectedCommitmentText() {
    switch (_selectedCommitment) {
      case 0: return "5 Minuti al giorno";
      case 1: return "10 Minuti al giorno";
      case 2: return "20 Minuti al giorno";
      default: return "30+ Minuti al giorno";
    }
  }

  // Costruttore generico per step a selezione multipla (Quiz)
  Widget _buildMultiSelectStep({
    required String title,
    required String desc,
    required List<String> options,
    required List<String> selectedList,
    required Color textColor,
    required Color subTextColor,
    required Color accentColor,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: -0.5,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              color: subTextColor,
              height: 1.45,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 24),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 100.0),
              physics: const BouncingScrollPhysics(),
              children: List.generate(options.length, (idx) {
                final val = options[idx];
                final isSelected = selectedList.contains(val);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: OnboardingChoiceCard(
                    title: val,
                    isSelected: isSelected,
                    isDark: isDark,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    accentColor: accentColor,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedList.remove(val);
                        } else {
                          selectedList.add(val);
                        }
                      });
                    },
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: accentColor, size: 20)
                        : Icon(Icons.radio_button_off_rounded, color: subTextColor.withOpacity(0.4), size: 20),
                  ),
                ).animate().fadeIn(delay: (150 + idx * 40).ms, duration: 300.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack, duration: 400.ms);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingChoiceCard extends StatefulWidget {
  final String title;
  final String? desc;
  final bool isSelected;
  final VoidCallback onTap;
  final Color textColor;
  final Color subTextColor;
  final Color accentColor;
  final bool isDark;
  final Widget? trailing;

  const OnboardingChoiceCard({
    Key? key,
    required this.title,
    this.desc,
    required this.isSelected,
    required this.onTap,
    required this.textColor,
    required this.subTextColor,
    required this.accentColor,
    required this.isDark,
    this.trailing,
  }) : super(key: key);

  @override
  State<OnboardingChoiceCard> createState() => _OnboardingChoiceCardState();
}

class _OnboardingChoiceCardState extends State<OnboardingChoiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.animateTo(1.0, duration: const Duration(milliseconds: 80), curve: Curves.easeOut),
      onTapUp: (_) {
        _controller.animateTo(0.0, duration: const Duration(milliseconds: 350), curve: Curves.elasticOut);
        widget.onTap();
      },
      onTapCancel: () => _controller.animateTo(0.0, duration: const Duration(milliseconds: 150), curve: Curves.easeOut),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: widget.desc != null ? 16 : 14,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected 
                ? widget.accentColor.withOpacity(0.12)
                : (widget.isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.025)),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.isSelected ? widget.accentColor : (widget.isDark ? Colors.white10 : Colors.black12),
              width: 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: widget.accentColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: widget.isSelected ? widget.accentColor : widget.textColor,
                      ),
                      child: Text(widget.title),
                    ),
                    if (widget.desc != null) ...[
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: widget.isSelected ? widget.accentColor.withOpacity(0.8) : widget.subTextColor,
                        ),
                        child: Text(widget.desc!),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: 12),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

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
    return GestureDetector(
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
    );
  }
}
