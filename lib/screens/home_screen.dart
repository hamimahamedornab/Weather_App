import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utility//loc.dart';
import '../utility//jeson.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}
class _HomeScreenViewState extends State<HomeScreenView> {
  // bool isLoading = true;
  String cityName = 'Savar';
  late Loc loc;
  late Jeson jeson;
  final String apiKey = '6c9b73b16da5173df65fa8284911a7c7';

  Future<bool> getWeatherData({
    required String cityName,
    String? stateCode,
    required String countryCode,
  }) async {
    final String geocodingUrl =
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName,$countryCode&limit=1&appid=$apiKey';

    final Response geocodingResponse = await get(Uri.parse(geocodingUrl));
    if (geocodingResponse.statusCode != 200) {
      return false;
    }

    final List<dynamic> geocodingData = json.decode(geocodingResponse.body);
    loc = Loc.fromJson(geocodingData[0]);

    final String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${loc.latitude}&lon=${loc.longitude}&units=metric&appid=$apiKey';

    final Response response = await get(Uri.parse(url));
    if (response.statusCode != 200) {
      return false;
    }
    jeson = Jeson.fromJson(jsonDecode(response.body));

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Weather'),
        backgroundColor: Colors.greenAccent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              gradient: LinearGradient(
                colors: [Colors.greenAccent,Colors.redAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

              )
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {
                cityName = 'Mirpur';
              });
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: Ink(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.greenAccent,
              Colors.redAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future: getWeatherData(countryCode: '+880', cityName: cityName),
          builder: (cntxt, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData == true && snapshot.data == true) {
              return Column(
                children: <Widget>[
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 60, left: 10, right: 10),
                  ),
                  const Flexible(child: SizedBox(height: 50)),
                  Text(
                    loc.cityName,
                    style: GoogleFonts.openSans(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Updated: ${DateFormat('hh:mm a').format(jeson.dateTime)}',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Flexible(child: SizedBox(height: 40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          'http://openweathermap.org/img/w/${jeson.weatherIcon}.png',

                        ),
                      ),
                      const Flexible(child: SizedBox(height: 20)),
                      Text(
                        '${jeson.temperature.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        children: <Widget>[
                          Text(
                            'max: ${jeson.maxTemperature.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'min: ${jeson.minTemperature.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Flexible(child: SizedBox(height: 40)),
                  Text(
                    jeson.main,
                    style: GoogleFonts.openSans(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(
                  'City Name "$cityName", Not found.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
