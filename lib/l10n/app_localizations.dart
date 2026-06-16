import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @premiumTitle.
  ///
  /// In it, this message translates to:
  /// **'Sblocca Guido Premium'**
  String get premiumTitle;

  /// No description provided for @premiumSubtitle.
  ///
  /// In it, this message translates to:
  /// **'L\'esperienza definitiva. Accedi a tutte le meditazioni guidate, esercizi di respirazione e audio spaziale 3D binaurale.'**
  String get premiumSubtitle;

  /// No description provided for @premium1Month.
  ///
  /// In it, this message translates to:
  /// **'1 Mese'**
  String get premium1Month;

  /// No description provided for @premium1Year.
  ///
  /// In it, this message translates to:
  /// **'1 Anno'**
  String get premium1Year;

  /// No description provided for @premiumLifetime.
  ///
  /// In it, this message translates to:
  /// **'A Vita'**
  String get premiumLifetime;

  /// No description provided for @premiumPerMonth.
  ///
  /// In it, this message translates to:
  /// **'/mese'**
  String get premiumPerMonth;

  /// No description provided for @premiumPerYear.
  ///
  /// In it, this message translates to:
  /// **'/anno'**
  String get premiumPerYear;

  /// No description provided for @premiumOneTime.
  ///
  /// In it, this message translates to:
  /// **' una tantum'**
  String get premiumOneTime;

  /// No description provided for @premiumRecommended.
  ///
  /// In it, this message translates to:
  /// **'CONSIGLIATO'**
  String get premiumRecommended;

  /// No description provided for @premiumSave58.
  ///
  /// In it, this message translates to:
  /// **'Risparmi il 58%'**
  String get premiumSave58;

  /// No description provided for @premiumActivateNow.
  ///
  /// In it, this message translates to:
  /// **'ATTIVA ORA (GRATIS)'**
  String get premiumActivateNow;

  /// No description provided for @premiumCancelAnytime.
  ///
  /// In it, this message translates to:
  /// **'Annulla in qualsiasi momento dalle impostazioni del tuo account.'**
  String get premiumCancelAnytime;

  /// No description provided for @splashTitle.
  ///
  /// In it, this message translates to:
  /// **'GUIDO'**
  String get splashTitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Il tuo compagno per la meditazione ed il respiro'**
  String get splashSubtitle;

  /// No description provided for @splashTabLogin.
  ///
  /// In it, this message translates to:
  /// **'ACCEDI'**
  String get splashTabLogin;

  /// No description provided for @splashTabRegister.
  ///
  /// In it, this message translates to:
  /// **'REGISTRATI'**
  String get splashTabRegister;

  /// No description provided for @splashNameHint.
  ///
  /// In it, this message translates to:
  /// **'Nome completo'**
  String get splashNameHint;

  /// No description provided for @splashEmailHint.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo Email'**
  String get splashEmailHint;

  /// No description provided for @splashPasswordHint.
  ///
  /// In it, this message translates to:
  /// **'Password'**
  String get splashPasswordHint;

  /// No description provided for @splashConfirmPasswordHint.
  ///
  /// In it, this message translates to:
  /// **'Conferma Password'**
  String get splashConfirmPasswordHint;

  /// No description provided for @splashAcceptTerms.
  ///
  /// In it, this message translates to:
  /// **'Accetto Termini e Condizioni e Privacy Policy'**
  String get splashAcceptTerms;

  /// No description provided for @splashGuestLogin.
  ///
  /// In it, this message translates to:
  /// **'ENTRA COME OSPITE'**
  String get splashGuestLogin;

  /// No description provided for @splashErrorFillFields.
  ///
  /// In it, this message translates to:
  /// **'Compila tutti i campi obbligatori!'**
  String get splashErrorFillFields;

  /// No description provided for @splashErrorPasswordMismatch.
  ///
  /// In it, this message translates to:
  /// **'Le password non coincidono!'**
  String get splashErrorPasswordMismatch;

  /// No description provided for @splashErrorAcceptTerms.
  ///
  /// In it, this message translates to:
  /// **'Devi accettare i termini di servizio!'**
  String get splashErrorAcceptTerms;

  /// No description provided for @splashErrorEmailPassword.
  ///
  /// In it, this message translates to:
  /// **'Inserisci email e password!'**
  String get splashErrorEmailPassword;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
