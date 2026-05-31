import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';

class JournalEntry {
  final String date;
  final String mood;
  final String text;

  JournalEntry({required this.date, required this.mood, required this.text});

  Map<String, dynamic> toJson() => {'date': date, 'mood': mood, 'text': text};

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      date: json['date'] as String,
      mood: json['mood'] as String,
      text: json['text'] as String,
    );
  }
}

class JournalTab extends ConsumerStatefulWidget {
  const JournalTab({Key? key}) : super(key: key);

  @override
  ConsumerState<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends ConsumerState<JournalTab> {
  final TextEditingController _textController = TextEditingController();
  String _selectedMood = "Peaceful";
  List<JournalEntry> _entries = [];

  final List<Map<String, dynamic>> _moods = [
    {'name': 'Peaceful', 'icon': Icons.sentiment_satisfied_alt_outlined},
    {'name': 'Grateful', 'icon': Icons.favorite_border_rounded},
    {'name': 'Quiet', 'icon': Icons.nights_stay_outlined},
    {'name': 'Restless', 'icon': Icons.bubble_chart_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    final prefs = ref.read(sharedPrefsProvider);
    final String? entriesJson = prefs.getString("JournalEntries");
    if (entriesJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(entriesJson);
        setState(() {
          _entries = decoded.map((e) => JournalEntry.fromJson(e as Map<String, dynamic>)).toList();
        });
      } catch (_) {}
    }
  }

  Future<void> _saveEntry() async {
    if (_textController.text.trim().isEmpty) return;

    final now = DateTime.now();
    final dateStr = "${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final newEntry = JournalEntry(
      date: dateStr,
      mood: _selectedMood,
      text: _textController.text.trim(),
    );

    final updated = [newEntry, ..._entries];
    
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString("JournalEntries", jsonEncode(updated.map((e) => e.toJson()).toList()));

    setState(() {
      _entries = updated;
      _textController.clear();
      _selectedMood = "Peaceful";
    });

    FocusScope.of(context).unfocus();
  }

  Future<void> _deleteEntry(int index) async {
    final updated = List<JournalEntry>.from(_entries)..removeAt(index);
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString("JournalEntries", jsonEncode(updated.map((e) => e.toJson()).toList()));
    setState(() {
      _entries = updated;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);

    return Container(
      color: Colors.transparent, // Tab al 100% trasparente, eredita lo sfondo gradiente globale
      child: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 110.0), // Aggiunto padding inferiore extra per permettere al diario di salire sopra la barra fluttuante
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Header Serif
              Text(
                settings.language == 0 ? "Diario Zen" : "Zen Journal",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 18),

              // Mood Question Label
              Text(
                settings.language == 0 ? "Come ti senti in questo istante?" : "How do you feel in this moment?",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),

              // Mood Selector Chips Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _moods.map((m) {
                  final name = m['name'] as String;
                  final icon = m['icon'] as IconData;
                  final isSelected = _selectedMood == name;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMood = name;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? accentColor : (isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? accentColor : (isDark ? Colors.white12 : Colors.black12),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(icon, color: isSelected ? Colors.white : subTextColor, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : subTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Reflection Field Title
              Text(
                settings.language == 0 ? "Annota una tua riflessione" : "Record a reflection",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),

              // Text Entry Area Claymorphic
              Container(
                decoration: AppColors.japandiCardDecoration(isDark, borderRadius: 24.0, opacity: 0.65),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: _textController,
                  maxLines: 4,
                  maxLength: 250,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, color: textColor),
                  decoration: InputDecoration(
                    hintText: settings.language == 0
                        ? "Scrivi qui quello che senti..."
                        : "Write what you feel here...",
                    hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13.5, color: subTextColor.withOpacity(0.6)),
                    border: InputBorder.none,
                    counterStyle: TextStyle(fontSize: 10, color: subTextColor.withOpacity(0.6)),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Save Button (Pill shape)
              GestureDetector(
                onTap: _saveEntry,
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.successAccent,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.15 : 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      settings.language == 0 ? "Salva nel Diario" : "Save reflection",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Past Entries Title
              if (_entries.isNotEmpty) ...[
                Text(
                  settings.language == 0 ? "Le tue riflessioni passate" : "Past reflections",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 14),

                // Past entries list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _entries.length,
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    IconData moodIcon = Icons.sentiment_satisfied_alt_outlined;
                    if (entry.mood == 'Grateful') moodIcon = Icons.favorite_border_rounded;
                    if (entry.mood == 'Quiet') moodIcon = Icons.nights_stay_outlined;
                    if (entry.mood == 'Restless') moodIcon = Icons.bubble_chart_outlined;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: AppColors.japandiCardDecoration(isDark, borderRadius: 20.0, opacity: 0.65),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(moodIcon, size: 16, color: accentColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    entry.mood.toUpperCase(),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: subTextColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    entry.date,
                                    style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: subTextColor),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _deleteEntry(index),
                                    child: Icon(Icons.close_rounded, size: 14, color: AppColors.dangerAccent.withOpacity(0.7)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entry.text,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: textColor.withOpacity(0.95),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
