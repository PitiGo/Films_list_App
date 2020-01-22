// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:My_Films/locale/locales.dart';
import 'package:My_Films/src/pages/home_page.dart';
import 'package:My_Films/src/pages/lista_page.dart';
import 'package:My_Films/src/pages/pelicula_detalle.dart';
import 'package:My_Films/src/pages/video_player_page.dart';

// void main() => runApp(DevicePreview(
//       builder: (BuildContext context) {
//         return MyApp();
//       },
//     ));
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: Locale('de'),
      // locale: DevicePreview.of(context).locale, // <--- Add the locale
      // builder: DevicePreview.appBuilder, // <--- Add the builder
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
      title: 'My Films',
      theme: ThemeData(

        primaryColor: Color(0xFFF3CE13),


      ),
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => PeliculaDetalle(),
        'lista': (BuildContext context) => ListaPage(),
        'video': (BuildContext context) => VideoPlayerPage(),
      },
    );
  }
}
