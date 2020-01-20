import 'package:flutter/material.dart';
import 'package:My_Films/locale/locales.dart';
import 'package:My_Films/src/pages/lista_page.dart';
import 'package:My_Films/src/providers/peliculas_providers.dart';
import 'package:My_Films/src/search/search_delegate.dart';
import 'package:My_Films/src/widgets/card_swiper_widget.dart';
import 'package:My_Films/src/widgets/movies_horizontal.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final peliculasProvider = new PeliculasProvider();
  int currentindex = 0;

  @override
  Widget build(BuildContext context) {

    
    Locale myLocale = Localizations.localeOf(context);

    peliculasProvider.language = myLocale.languageCode;
   
    peliculasProvider.getPopulares();

    return Scaffold(
      bottomNavigationBar: _crearBottomNavigationBar(),
      appBar: currentindex == 0
          ? AppBar(
              centerTitle: false,
              title: Text(AppLocalizations.of(context).title),
              backgroundColor: Colors.indigoAccent,
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

  Widget _footer(BuildContext context) {
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
              if (snapshot.hasData) {
                return MovieHorizontal(
                  siguientePagina: peliculasProvider.getPopulares,
                  peliculas: snapshot.data,
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

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentindex,
      onTap: (index) {
        currentindex = index;

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
            _footer(context),
          ],
        ),
      ),
    );
  }
}
