import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:MyFilms/locale/locales.dart';
import 'package:MyFilms/src/models/actores_model.dart';
import 'package:MyFilms/src/models/pelicula_model.dart';
import 'package:MyFilms/src/models/videos_model.dart';
import 'package:MyFilms/src/pages/video_player_page.dart';
import 'package:MyFilms/src/providers/db_provider.dart';
import 'package:MyFilms/src/providers/peliculas_providers.dart';
// import 'package:share/share.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      bottomNavigationBar: _crearBottomNavigationBar(context),
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula,context),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10.0,
              ),
              _posterTitulo(context, pelicula),
              _descripcion(pelicula),
              _crearCasting(pelicula),
            ]),
          ),
        ],
      ),
    );
  }
Widget _crearAppbar(Pelicula pelicula,BuildContext context) {
    return SliverAppBar(
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      elevation: 2.0,
      backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/loading.gif'),
          image: NetworkImage(pelicula.getBackgroundImg()),
          fadeInDuration: Duration(milliseconds: 100),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(
                  pelicula.getPosterImg(),
                ),
                height: 150,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title,
                    style: Theme.of(context).textTheme.headline6,
                    overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle,
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star_border,
                      color: Colors.yellow,
                    ),
                    Text(
                      pelicula.voteAverage.toString(),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: actores.length,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1,
        ),
        itemBuilder: (context, index) {
          return _actorTarjeta(actores[index]);
        },
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              image: NetworkImage(
                actor.getFoto(),
              ),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _crearBottomNavigationBar(BuildContext context) {
    final peliProvider = new PeliculasProvider();
    Locale myLocale = Localizations.localeOf(context);
    peliProvider.language = myLocale.languageCode;

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.play_arrow,
              size: 40.0,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              print('Play youtube');

              Pelicula pelicula = ModalRoute.of(context).settings.arguments;

              List<Result> videos =
                  await peliProvider.getVideo(pelicula.id.toString());

              if (videos.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerPage(
                      videoId: videos.first.key,
                      caption: myLocale.languageCode ,
                    ),
                  ),
                );
              } else {
                Fluttertoast.showToast(
                  msg: 'Trailer not available',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }

              // Navigator.popAndPushNamed(context, 'video',
              //     arguments: videos.first.key);
            },
          ),
          title: Container(),
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.add,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              addMovieDB(context);
            },
          ),
          title: Container(),
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.share,
              size: 40.0,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Pelicula pelicula = ModalRoute.of(context).settings.arguments;

              // Share.share(
              //     AppLocalizations.of(context).watchthismovie +
              //         ' \n ' +
              //         pelicula.getPosterImg(),
              //     subject: AppLocalizations.of(context).watchthismovie);

                  Share.text(AppLocalizations.of(context).watchthismovie, pelicula.getPosterImg(), 'text/plain');

                // var request = await HttpClient().getUrl(Uri.parse('https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
                // var response = await request.close();
                // Uint8List bytes = await consolidateHttpClientResponseBytes(response);
                // await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
            },
          ),
          title: Container(),
        ),
      ],
    );
  }

  addMovieDB(BuildContext context) async {
    Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    print('add nueva pelicula id:');
    print(pelicula.id);

    try {
      Pelicula existe = await DBProvider.db.getPeliId(pelicula.id);

      if (existe == null) {
        await DBProvider.db.nuevaPeli(pelicula);
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).movieadded,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).moviealready,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
