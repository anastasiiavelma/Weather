import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:list_app/dialogs/city_dialog.dart';
import 'package:list_app/main.dart';
import 'package:list_app/models/weather_model.dart';
import 'package:list_app/services/data_service.dart';
import 'package:list_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final _dataService = DataService();
  TextEditingController cityController = TextEditingController();
  List<WeatherResponse> weatherDataList = [];
  late AnimationController _animationController;
  late Tween<Offset> _tween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    _tween = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero);

    loadData();
  }

  @override
  void dispose() {
    cityController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void changeLanguage(Locale newLocale) {
    setState(() {
      MyApp.setLocale(context, newLocale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: kSecondaryBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.weather,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          PopupMenuButton<Locale>(
            color: kAccentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (locale) {
              changeLanguage(locale);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<Locale>(
                value: const Locale('en', ''),
                child: Text(
                  'English',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              PopupMenuItem<Locale>(
                value: const Locale('es', ''),
                child: Text(
                  'Espanol',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
            icon: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(Icons.language),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
        ),
        child: Container(
          padding: const EdgeInsets.only(
            top: 30.0,
          ),
          decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
          child: weatherDataList.isEmpty
              ? Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    AppLocalizations.of(context)!.noWeather,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: weatherDataList.length,
                        itemBuilder: (context, index) {
                          final weatherData = weatherDataList[index];
                          return SlideTransition(
                            position: _animationController.drive(_tween),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                                color: kPrimaryColor,
                                child: Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    deleteCity(index);
                                  },
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: kSecondaryAccentColor,
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: kSecondaryBackgroundColor,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CityDialog(
                                            onAction: (cityName) {
                                              editCity(cityName, index);
                                            },
                                            initialCityName:
                                                weatherDataList[index].cityName,
                                            isEditing: true,
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                              weatherData.cityName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${weatherData.tempInfo.temperature}°C',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium,
                                                ),
                                                Text(
                                                  weatherData
                                                      .weatherInfo.description,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Image.network(weatherData.iconUrl),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CityDialog(onAction: addCity);
            },
          );
        },
        backgroundColor: kAccentColor,
        shape: const CircleBorder(),
        child: SizedBox(
          width: 60.0,
          height: 60.0,
          child: Icon(
            Icons.add,
            color: kBackgroundColor,
            size: 30.0,
          ),
        ),
      ),
    );
  }

  Future<void> addCity(String cityName) async {
    // if (!weatherDataList.any((data) => data.cityName == cityName)) {
      try {
        final weatherData = await _dataService.getWeather(cityName);
        setState(() {
          weatherDataList.add(weatherData);
          saveData();
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching weather data for $cityName: $e');
        }
      }
    // } else {
    //   if (kDebugMode) {
    //     print('City $cityName already exists in the list');
    //   }
    // }
  }

  Future<void> editCity(String cityName, int index) async {
    // if (!weatherDataList.any((data) => data.cityName == cityName)) {
      try {
        final weatherData = await _dataService.getWeather(cityName);
        setState(() {
          weatherDataList[index] = weatherData;
          saveData();
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching weather data for $cityName: $e');
        }
      }
    // } else {
    //   if (kDebugMode) {
    //     print('City $cityName already exists in the list');
    //   }
    // }
  }

  Future<void> deleteCity(int index) async {
    setState(() {
      weatherDataList.removeAt(index);
    });
    saveData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cityNames = prefs.getStringList('cityNames');
    if (cityNames != null) {
      for (final cityName in cityNames) {
        await addCity(cityName);
      }
    }
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cityNames =
        weatherDataList.map((data) => data.cityName).toList();
    prefs.setStringList('cityNames', cityNames);
  }
}
