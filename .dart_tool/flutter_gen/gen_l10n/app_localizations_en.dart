import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get weather => 'Weather';

  @override
  String get pleaseAddCity => 'Please, add city';

  @override
  String get pleaseEditCity => 'Please, edit edit';

  @override
  String get adding => 'Adding';

  @override
  String get editing => 'Editing';

  @override
  String get enterCityName => 'Enter a city name';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get error1 => 'City name can\'t be empty';

  @override
  String get noWeather => 'No weather found.';
}
