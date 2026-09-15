import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyQuote {
  final String text;
  final String author;
  final bool isGuidoThought;
  final String? subtitle;

  const DailyQuote({
    required this.text,
    required this.author,
    this.isGuidoThought = false,
    this.subtitle,
  });
}

class DailyQuotesService {
  static const List<DailyQuote> quotes = [
    // --- 20 PENSIERI GUIDO (Consapevolezza, Respiro, Elementi Naturali, Presenza) ---
    DailyQuote(
      text: "Ogni respiro è un ritorno a casa, uno spazio calmo in cui ritrovarsi.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Nel silenzio tra l'inspirazione e l'espirazione abita la tua vera forza.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Sii come l'acqua: fluida di fronte agli ostacoli, limpida nella quiete.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Radicati nella terra del presente; le tempeste passano, le radici profonde restano.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Lascia andare con ogni espirazione ciò che non puoi controllare. Sii leggero come l'aria.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "La fiamma interiore riscalda e illumina senza bruciare: custodisci la tua energia vitale.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Non c'è fretta nel ritmo della natura. Ogni bocciolo si apre a tempo debito.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Fermati. Ascolta. Il respiro consapevole è il ponte che unisce corpo e mente.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Quando la mente si increspa come un lago al vento, basta attendere la quiete.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Non cercare la pace fuori da te. È già qui, sotto il rumore dei pensieri.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Accogli questo istante esattamente com'è, senza giudizio, con infinita gentilezza.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Un solo respiro profondo può cambiare la rotta dell'intera giornata.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "La vera meditazione non è fuggire dal mondo, ma abitare se stessi con pienezza.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Espira le tensioni accumulate, inspira nuova luce e vitalità.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "La semplicità è la forma più pura di benessere interiore.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Nel battito regolare del tuo cuore ritrovi la cadenza dell'universo intero.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Cammina con passo leggero sulla terra, lasciando che il respiro guidi ogni tuo gesto.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Oggi concediti il dono di non dover dimostrare nulla: esisti e basta.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "La chiarezza mentale nasce quando smetti di trattenere l'aria e accetti il flusso vitale.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),
    DailyQuote(
      text: "Nel tempio della consapevolezza, ogni sospiro è una preghiera di gratitudine.",
      author: "Guido",
      isGuidoThought: true,
      subtitle: "Il Respiro di Oggi",
    ),

    // --- 20 MAESTRI SPIRITUALI E FILOSOFI ---
    DailyQuote(
      text: "Il respiro è il ponte che collega la vita alla coscienza, che unisce il corpo ai pensieri.",
      author: "Thich Nhat Hanh",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "La felicità è quando ciò che pensi, ciò che dici e ciò che fai sono in armonia.",
      author: "Mahatma Gandhi",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Il silenzio è il linguaggio di Dio, tutto il resto è una misera traduzione.",
      author: "Rumi",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Un viaggio di mille miglia comincia sempre con un singolo passo.",
      author: "Lao Tzu",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "La calma interiore è il segreto della vera forza.",
      author: "Marco Aurelio",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "La pace viene da dentro. Non cercarla fuori.",
      author: "Buddha",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "La vera felicità è godersi il presente senza l'ansiosa dipendenza dal futuro.",
      author: "Seneca",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Il momento presente è l'unica cosa che hai sempre. Fai dell'Adesso il fuoco primario della tua vita.",
      author: "Eckhart Tolle",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Nel cuore di ogni inverno si nasconde una primavera palpitante, e dietro la notte sorge un'alba sorridente.",
      author: "Kahlil Gibran",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Sii calmo nel corpo, controllato nella mente e rilassato nel respiro.",
      author: "Paramahansa Yogananda",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "L'unico modo per dare un senso al cambiamento è tuffarsi in esso, muoversi con esso e unirsi alla danza.",
      author: "Alan Watts",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "La capacità di osservare senza giudicare è la più alta forma di intelligenza.",
      author: "Jiddu Krishnamurti",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Se non riesci a trovare la verità proprio dove ti trovi, dove altro ti aspetti di trovarla?",
      author: "Dogen Zenji",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Non sono le cose a turbare gli esseri umani, ma i giudizi che essi formulano sulle cose.",
      author: "Epitteto",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Nella mente del principiante ci sono molte possibilità, nella mente dell'esperto ce ne sono poche.",
      author: "Shunryu Suzuki",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Tutto il potere è dentro di te; puoi fare qualsiasi cosa e tutto.",
      author: "Swami Vivekananda",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Il silenzio è il discorso più potente; è il linguaggio della presenza.",
      author: "Ramana Maharshi",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "La pace è una presenza profonda che trasforma tutto ciò che tocca.",
      author: "Sri Aurobindo",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Chi conosce gli altri è sapiente; chi conosce se stesso è illuminato.",
      author: "Lao Tzu",
      isGuidoThought: false,
    ),
    DailyQuote(
      text: "Non sei una goccia nell'oceano. Sei l'intero oceano in una goccia.",
      author: "Rumi",
      isGuidoThought: false,
    ),
  ];

  static DailyQuote getDailyQuote([DateTime? date]) {
    final now = (date ?? DateTime.now()).toUtc();
    final startOfYear = DateTime.utc(now.year, 1, 1);
    final dayOfYear = now.difference(startOfYear).inDays;
    final quoteIndex = dayOfYear.abs() % quotes.length;
    return quotes[quoteIndex];
  }
}

class DailyQuoteNotifier extends Notifier<DailyQuote> {
  @override
  DailyQuote build() {
    return DailyQuotesService.getDailyQuote();
  }

  void refresh() {
    state = DailyQuotesService.getDailyQuote();
  }

  void setForDate(DateTime date) {
    state = DailyQuotesService.getDailyQuote(date);
  }
}

final dailyQuoteProvider =
    NotifierProvider<DailyQuoteNotifier, DailyQuote>(DailyQuoteNotifier.new);
