// import 'package:device_preview/device_preview.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:My_Films/locale/locales.dart';
import 'package:My_Films/src/pages/home_page.dart';
import 'package:My_Films/src/pages/lista_page.dart';
import 'package:My_Films/src/pages/pelicula_detalle.dart';
import 'package:My_Films/src/pages/video_player_page.dart';
import 'package:launch_review/launch_review.dart';
import 'package:rate_my_app/rate_my_app.dart';

const String testDevice = "6727C74FD5CD433078521370CB5A73BC";
FirebaseAnalytics analytics = FirebaseAnalytics();
// void main() => runApp(DevicePreview(
//       builder: (BuildContext context) {
//         return MyApp();
//       },
//     ));
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static const MobileAdTargetingInfo mobileAdTargetingInfo =
      MobileAdTargetingInfo(
          testDevices: testDevice != null ? <String>[testDevice] : null,
          // nonPersonalizedAds: true,
          keywords: <String>[
        'Seguro',
        'Seguros de vida',
        'Hipoteca',
        'Prestamo',
      ]);
  static final navKey = new GlobalKey<NavigatorState>();
  MyApp({Key navKey}) : super(key: navKey);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 3,
    minLaunches: 3,
    remindDays: 2,
    remindLaunches: 5,
    googlePlayIdentifier: 'com.app.My_Films',
    // appStoreIdentifier: '1491556149',
  );

  InterstitialAd _interstitialAd;
  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: 'ca-app-pub-5709755665172014/2587728955',
        size: AdSize.smartBanner,
        targetingInfo: MyApp.mobileAdTargetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

 

  @override
  void initState() {
    super.initState();

    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-5709755665172014~1447065348');

    _bannerAd = createBannerAd()
      ..load()
      ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom);

    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        final contexto = MyApp.navKey.currentState.overlay.context;
        rateMyApp.showStarRateDialog(
          contexto,
          title: AppLocalizations.of(contexto).rate,
          message: AppLocalizations.of(contexto).leavearate,
          onRatingChanged: (stars) {
            return [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  if (stars != null) {
                    rateMyApp.save().then((v) => Navigator.pop(contexto));

                    if (stars <= 3) {
                      print('Go to contact screen');
                    } else if (stars <= 5) {
                      LaunchReview.launch(androidAppId: "com.app.My_Films");
                      print('leave a review Dialog');
                      // showDialog()
                    }
                  } else {
                    Navigator.pop(contexto);
                  }
                },
              )
            ];
          },
          dialogStyle: DialogStyle(
            titleAlign: TextAlign.center,
            messageAlign: TextAlign.center,
            messagePadding: EdgeInsets.only(bottom: 20.0),
          ),
          starRatingOptions: StarRatingOptions(),
        );
      }
    });
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    _bannerAd.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 51.0),
          child: child,
        );
      },
      navigatorKey: MyApp.navKey,
      // locale: Locale('es'),
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
        'lista': (BuildContext context) =>ListaPage(),
        'video': (BuildContext context) => VideoPlayerPage(),
      },
    );
  }
}
