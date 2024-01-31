import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get weather => 'Tiempo';

  @override
  String get pleaseAddCity => 'Por favor, añade ciudad';

  @override
  String get pleaseEditCity => 'Por favor, edite la ciudad';

  @override
  String get adding => 'Agregando';

  @override
  String get editing => 'Edición';

  @override
  String get enterCityName => 'Ingrese el nombre de una ciudad';

  @override
  String get cancel => 'Cancelar';

  @override
  String get add => 'Agregar';

  @override
  String get save => 'Ahorrar';

  @override
  String get error1 => 'El nombre de la ciudad no puede estar vacío';

  @override
  String get noWeather => 'No se encontró el clima.';
}
