import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:peliculas/locale/locales.dart';
import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/lista_page.dart';
import 'package:peliculas/src/pages/pelicula_detalle.dart';
import 'package:peliculas/src/pages/video_player_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
 
    return MaterialApp(
      // locale: Locale('de'),
      localizationsDelegates: [
        // ... delegado[s] de localización específicos de la app aquí
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('es', 'ES'), // Spanish
        const Locale('fr', 'FR'), // French
        const Locale('de', 'DE'),
        const Locale('pt', 'PT'),
        // ... other locales the app supports
      ],
      debugShowCheckedModeBanner: false,
      title: 'Movies app',
      onGenerateTitle: (BuildContext context) =>AppLocalizations.of(context).title,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => PeliculaDetalle(),
        'lista': (BuildContext context) => ListaPage(),
        'video':(BuildContext context) => VideoPlayerPage(),
      },
    );
  }
}