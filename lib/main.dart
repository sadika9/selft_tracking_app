import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:selftrackingapp/networking/db.dart';
import 'package:selftrackingapp/page/screen/root_screen.dart';
import 'package:selftrackingapp/page/screen/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/tracker_colors.dart';

void main() {
  GetIt.instance
      .registerSingleton<DataRepository>(AppDataRepository(AppDatabase()));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID-19 Tracker',
      theme: ThemeData(
          primarySwatch: TrackerColors.primaryColor,
          backgroundColor: Color(0xfff6f6f9),
          textTheme: TextTheme(
            display1: TextStyle(color: Colors.black, fontSize: 15.0),
            display2: TextStyle(color: Colors.black54, fontSize: 12.0),
            body1: TextStyle(color: Colors.black54, fontSize: 15.0),
          )),
      supportedLocales: [Locale('en', "US"), Locale('si', "LK")],
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _screen;

  @override
  void initState() {
    super.initState();

    _screen = _createSplashScreen();

    loadLang();
  }

  Future<void> loadLang() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    String language = pref.getString("language");
    if (language != null) {
      if (language == "en") {
        AppLocalizations.of(context).load(Locale("en", "US"));
      } else if (language == "ta") {
        AppLocalizations.of(context).load(Locale("ta", "TA"));
      } else {
        AppLocalizations.of(context).load(Locale("si", "LK"));
      }
      setState(() {
        _screen = RootScreen();
      });
    } else {
      setState(() {
        _screen = WelcomeScreen();
      });
    }
  }

  Widget _createSplashScreen() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill)),
    ); // or some other widget
  }

  @override
  Widget build(BuildContext context) {
    return _screen;
  }
}
