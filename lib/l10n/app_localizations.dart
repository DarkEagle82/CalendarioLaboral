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

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendario'**
  String get calendar;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Configuración'**
  String get settings;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Resumen'**
  String get summary;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @standardWorkday.
  ///
  /// In en, this message translates to:
  /// **'Jornada Estándar'**
  String get standardWorkday;

  /// No description provided for @intensiveWorkday.
  ///
  /// In en, this message translates to:
  /// **'Jornada Intensiva'**
  String get intensiveWorkday;

  /// No description provided for @annualHours.
  ///
  /// In en, this message translates to:
  /// **'Horas Anuales'**
  String get annualHours;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @intensivePeriods.
  ///
  /// In en, this message translates to:
  /// **'Períodos Intensivos'**
  String get intensivePeriods;

  /// No description provided for @addIntensivePeriod.
  ///
  /// In en, this message translates to:
  /// **'Añadir Período Intensivo'**
  String get addIntensivePeriod;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Seleccionar Fecha'**
  String get selectDate;

  /// No description provided for @selectWeekDay.
  ///
  /// In en, this message translates to:
  /// **'Seleccionar Día de la Semana'**
  String get selectWeekDay;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Horas'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutos'**
  String get minutes;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Seleccionar Color'**
  String get selectColor;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'Inglés'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'Sistema'**
  String get system;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Claro'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Oscuro'**
  String get dark;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Calendario Laboral'**
  String get appName;

  /// No description provided for @addRule.
  ///
  /// In en, this message translates to:
  /// **'Añadir Regla'**
  String get addRule;

  /// No description provided for @ruleType.
  ///
  /// In en, this message translates to:
  /// **'Tipo de Regla'**
  String get ruleType;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Rango de Fechas'**
  String get dateRange;

  /// No description provided for @weeklyOnRange.
  ///
  /// In en, this message translates to:
  /// **'Semanal en Rango'**
  String get weeklyOnRange;

  /// No description provided for @holidayEve.
  ///
  /// In en, this message translates to:
  /// **'Víspera de Festivo'**
  String get holidayEve;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Fecha de Inicio'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'Fecha de Fin'**
  String get endDate;

  /// No description provided for @weekday.
  ///
  /// In en, this message translates to:
  /// **'Día de la Semana'**
  String get weekday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Lunes'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Martes'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Miércoles'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Jueves'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Viernes'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sábado'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Domingo'**
  String get sunday;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @totalHoursWorked.
  ///
  /// In en, this message translates to:
  /// **'Horas Totales Trabajadas'**
  String get totalHoursWorked;

  /// No description provided for @remainingHours.
  ///
  /// In en, this message translates to:
  /// **'Horas Restantes'**
  String get remainingHours;

  /// No description provided for @equivalentDays.
  ///
  /// In en, this message translates to:
  /// **'Días Equivalentes'**
  String get equivalentDays;

  /// No description provided for @totalWorkingDays.
  ///
  /// In en, this message translates to:
  /// **'Días Totales Trabajados'**
  String get totalWorkingDays;

  /// No description provided for @clearSelection.
  ///
  /// In en, this message translates to:
  /// **'Limpiar Selección'**
  String get clearSelection;

  /// No description provided for @markAsHoliday.
  ///
  /// In en, this message translates to:
  /// **'Marcar como Festivo'**
  String get markAsHoliday;

  /// No description provided for @markAsVacation.
  ///
  /// In en, this message translates to:
  /// **'Marcar como Vacaciones'**
  String get markAsVacation;

  /// No description provided for @noRulesDefined.
  ///
  /// In en, this message translates to:
  /// **'No hay reglas definidas. Pulsa \'+\' para añadir una.'**
  String get noRulesDefined;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirmar Eliminación'**
  String get confirmDeletion;

  /// No description provided for @areYouSureYouWantToDeleteThisRule.
  ///
  /// In en, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar esta regla?'**
  String get areYouSureYouWantToDeleteThisRule;

  /// No description provided for @workdayHours.
  ///
  /// In en, this message translates to:
  /// **'Horas de la Jornada'**
  String get workdayHours;

  /// No description provided for @chooseThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Elegir Color del Tema'**
  String get chooseThemeColor;

  /// No description provided for @holiday.
  ///
  /// In en, this message translates to:
  /// **'Festivo'**
  String get holiday;

  /// No description provided for @vacation.
  ///
  /// In en, this message translates to:
  /// **'Vacaciones'**
  String get vacation;
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
