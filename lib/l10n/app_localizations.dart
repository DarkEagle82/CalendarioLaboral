import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Calendario Laboral'**
  String get appTitle;

  /// No description provided for @calendar.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get calendar;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @summary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get summary;

  /// No description provided for @calendar2025.
  ///
  /// In es, this message translates to:
  /// **'Calendario 2025'**
  String get calendar2025;

  /// No description provided for @markHoliday.
  ///
  /// In es, this message translates to:
  /// **'Marcar como Festivo'**
  String get markHoliday;

  /// No description provided for @markVacation.
  ///
  /// In es, this message translates to:
  /// **'Marcar Vacac.'**
  String get markVacation;

  /// No description provided for @markIntensiveWorkday.
  ///
  /// In es, this message translates to:
  /// **'Marcar J. Intensiva'**
  String get markIntensiveWorkday;

  /// No description provided for @clearSelection.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clearSelection;

  /// No description provided for @holiday.
  ///
  /// In es, this message translates to:
  /// **'Festivo'**
  String get holiday;

  /// No description provided for @vacation.
  ///
  /// In es, this message translates to:
  /// **'Vacac.'**
  String get vacation;

  /// No description provided for @intensiveWorkday.
  ///
  /// In es, this message translates to:
  /// **'J. Intensiva'**
  String get intensiveWorkday;

  /// No description provided for @totalHoursWorked.
  ///
  /// In es, this message translates to:
  /// **'Total de horas trabajadas'**
  String get totalHoursWorked;

  /// No description provided for @annualHours.
  ///
  /// In es, this message translates to:
  /// **'Horas anuales'**
  String get annualHours;

  /// No description provided for @remainingHours.
  ///
  /// In es, this message translates to:
  /// **'Horas restantes'**
  String get remainingHours;

  /// No description provided for @darkMode.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get darkMode;

  /// No description provided for @chooseThemeColor.
  ///
  /// In es, this message translates to:
  /// **'Elegir color del tema'**
  String get chooseThemeColor;

  /// No description provided for @pickAColor.
  ///
  /// In es, this message translates to:
  /// **'Elige un color'**
  String get pickAColor;

  /// No description provided for @done.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get done;

  /// No description provided for @standardWorkday.
  ///
  /// In es, this message translates to:
  /// **'Jornada laboral normal'**
  String get standardWorkday;

  /// No description provided for @intensiveWorkdayHours.
  ///
  /// In es, this message translates to:
  /// **'Horas de jornada intensiva'**
  String get intensiveWorkdayHours;

  /// No description provided for @annualHoursGoal.
  ///
  /// In es, this message translates to:
  /// **'Horas anuales de convenio'**
  String get annualHoursGoal;

  /// No description provided for @totalWorkingDays.
  ///
  /// In es, this message translates to:
  /// **'Total de días trabajados'**
  String get totalWorkingDays;

  /// No description provided for @intensiveWorkdayPeriod.
  ///
  /// In es, this message translates to:
  /// **'Periodo de jornada intensiva'**
  String get intensiveWorkdayPeriod;

  /// No description provided for @startDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de inicio'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de fin'**
  String get endDate;

  /// No description provided for @selectDate.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar fecha'**
  String get selectDate;

  /// No description provided for @equivalentDays.
  ///
  /// In es, this message translates to:
  /// **'Días equivalentes'**
  String get equivalentDays;

  /// No description provided for @year.
  ///
  /// In es, this message translates to:
  /// **'Año'**
  String get year;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
