import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserStatsHelper {
  static Future<void> recordSession(SharedPreferences prefs, String sessionTitle, String sessionType) async {
    // Valori finti realistici per la durata: se è respirazione assumiamo 8 min, altrimenti 15 min
    final int minutes = sessionType == "Respirazione" ? 8 : 15;
    final int xpEarned = minutes * 2; // 2 XP al minuto

    // Aggiorna totali
    final currentMinutes = prefs.getInt("total_minutes") ?? 0;
    await prefs.setInt("total_minutes", currentMinutes + minutes);

    final currentSessions = prefs.getInt("total_sessions") ?? 0;
    await prefs.setInt("total_sessions", currentSessions + 1);

    final currentXp = prefs.getInt("profile_xp") ?? 0;
    await prefs.setInt("profile_xp", currentXp + xpEarned);

    // Gestione streak (semplificata)
    final lastDateStr = prefs.getString("last_session_date");
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    int currentStreak = prefs.getInt("current_streak") ?? 0;

    if (lastDateStr != todayStr) {
      // Potremmo controllare se era ieri per mantenere lo streak,
      // per semplicità qui incrementiamo se è un giorno diverso.
      currentStreak += 1;
      await prefs.setInt("current_streak", currentStreak);
      await prefs.setString("last_session_date", todayStr);
    }

    // Aggiungi alla history
    final historyListStr = prefs.getStringList("timeline_history") ?? [];
    
    // Creiamo un record JSON
    final record = jsonEncode({
      "title": sessionTitle,
      "type": sessionType,
      "duration": "$minutes MIN",
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
    
    historyListStr.insert(0, record); // Aggiunge all'inizio
    // Tieni solo gli ultimi 10 record
    if (historyListStr.length > 10) {
      historyListStr.removeLast();
    }
    
    await prefs.setStringList("timeline_history", historyListStr);
  }
}
