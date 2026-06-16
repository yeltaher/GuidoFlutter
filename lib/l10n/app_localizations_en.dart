// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get premiumTitle => 'Unlock Guido Premium';

  @override
  String get premiumSubtitle =>
      'The ultimate experience. Access all guided meditations, breathing exercises, and binaural 3D spatial audio.';

  @override
  String get premium1Month => '1 Month';

  @override
  String get premium1Year => '1 Year';

  @override
  String get premiumLifetime => 'Lifetime';

  @override
  String get premiumPerMonth => '/month';

  @override
  String get premiumPerYear => '/year';

  @override
  String get premiumOneTime => ' one-time';

  @override
  String get premiumRecommended => 'RECOMMENDED';

  @override
  String get premiumSave58 => 'Save 58%';

  @override
  String get premiumActivateNow => 'ACTIVATE NOW (FREE)';

  @override
  String get premiumCancelAnytime =>
      'Cancel anytime from your account settings.';

  @override
  String get splashTitle => 'GUIDO';

  @override
  String get splashSubtitle => 'Your companion for meditation and breathing';

  @override
  String get splashTabLogin => 'LOGIN';

  @override
  String get splashTabRegister => 'REGISTER';

  @override
  String get splashNameHint => 'Full name';

  @override
  String get splashEmailHint => 'Email Address';

  @override
  String get splashPasswordHint => 'Password';

  @override
  String get splashConfirmPasswordHint => 'Confirm Password';

  @override
  String get splashAcceptTerms =>
      'I accept the Terms and Conditions and Privacy Policy';

  @override
  String get splashGuestLogin => 'ENTER AS GUEST';

  @override
  String get splashErrorFillFields => 'Fill in all mandatory fields!';

  @override
  String get splashErrorPasswordMismatch => 'Passwords do not match!';

  @override
  String get splashErrorAcceptTerms => 'You must accept the terms of service!';

  @override
  String get splashErrorEmailPassword => 'Enter email and password!';
}
