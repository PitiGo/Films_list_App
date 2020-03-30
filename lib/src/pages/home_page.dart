import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:MyFilms/locale/locales.dart';
import 'package:MyFilms/src/pages/lista_page.dart';
import 'package:MyFilms/src/providers/peliculas_providers.dart';
import 'package:MyFilms/src/search/search_delegate.dart';
import 'package:MyFilms/src/widgets/card_swiper_widget.dart';
import 'package:MyFilms/src/widgets/movies_horizontal.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

const String testDevice = "6727C74FD5CD433078521370CB5A73BC";

// FirebaseAnalytics analytics = FirebaseAnalytics();
class _HomePageState extends State<HomePage> {
  final peliculasProvider = new PeliculasProvider();
  
  int currentindex = 0;

  InterstitialAd _interstitialAd;

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

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: 'ca-app-pub-5709755665172014/1056538322',
        // size: AdSize.banner,
        targetingInfo: mobileAdTargetingInfo,
        listener: (MobileAdEvent event) {
          print("InterstitialAd $event");
        });
  }

  @override
  Widget build(BuildContext context) {
    
    Locale myLocale = Localizations.localeOf(context);

    peliculasProvider.language = myLocale.languageCode;

    peliculasProvider.getPopulares();
    peliculasProvider.getTopRated();

    return Scaffold(
      bottomNavigationBar: _crearBottomNavigationBar(),
      appBar: currentindex == 0
          ? AppBar(
              centerTitle: true,
              title: Text(AppLocalizations.of(context).title),
              backgroundColor: Theme.of(context).primaryColor,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: DataSearch(),
                    );
                  },
                ),
              ],
            )
          : null,
      body: _callPage(currentindex),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasError) {
          return Container(
            height: 400,
            child: Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return CardSwiper(
            peliculas: snapshot.data,
          );
        } else {
          return Container(
            height: 400,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
    //
  }

  Widget _footerPopular(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              AppLocalizations.of(context).popular,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  height: 400,
                  child: Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                return MovieHorizontal(
                  siguientePagina: peliculasProvider.getPopulares,
                  peliculas: snapshot.data,
                  subGroupMovies: 'popular',
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          // FutureBuilder(
          //   future: peliculasProvider.getPopulares(),
          //   builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          //     if (snapshot.hasData) {
          //       return MovieHorizontal(
          //         peliculas: snapshot.data,
          //       );
          //     } else {
          //       return Center(child: CircularProgressIndicator(),);
          //     }
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _footerTopRated(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Top rated',
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          StreamBuilder(
            stream: peliculasProvider.topRatedStream,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  height: 400,
                  child: Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                return MovieHorizontal(
                  siguientePagina: peliculasProvider.getTopRated,
                  peliculas: snapshot.data,
                  subGroupMovies: 'top',
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentindex,
      onTap: (index) {
        currentindex = index;
        if (currentindex == 1) {
          _interstitialAd = createInterstitialAd()
            ..load()
            ..show();
        }

        setState(() {});
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.star,
            size: 40.0,
          ),
          title: Text(AppLocalizations.of(context).discover),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list, size: 40.0),
          title: Text(AppLocalizations.of(context).mylist),
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.search, size: 40.0),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          ),
          title: Text(AppLocalizations.of(context).search),
        ),
      ],
    );
  }

  Widget _callPage(int currentindex) {
    switch (currentindex) {
      case 0:
        return _mainPage();
      case 1:
        // _interstitialAd = createInterstitialAd()..load()..show();
        return ListaPage();
      default:
        return _mainPage();
    }
  }

  Widget _mainPage() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: <Widget>[
            _swiperTarjetas(),
            _footerPopular(context),
            _footerTopRated(context),
          ],
        ),
      ),
    );
  }
}
