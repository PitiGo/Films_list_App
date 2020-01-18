import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peliculas/locale/locales.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/db_provider.dart';

class ListaPage extends StatefulWidget {
  @override
  _ListaPageState createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(AppLocalizations.of(context).mylist),
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: AppLocalizations.of(context).watch,
              ),
              Tab(
                text: AppLocalizations.of(context).viewed,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _crearLista(0),
            _crearLista(1),
          ],
        ),
      ),
    );
  }

  Widget _crearLista(int vistas) {
    return FutureBuilder(
      future: DBProvider.db.getAllSeenMovies(vistas),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula) {
              return Dismissible(
                onDismissed: (direction) =>
                    DBProvider.db.deletePelicula(pelicula.id),
                key: UniqueKey(),
                child: ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(
                      pelicula.getPosterImg(),
                    ),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.fill,
                  ),
                  title: Text(pelicula.title),
                  subtitle: Text(pelicula.originalTitle),
                  onTap: () {
                    // close(context, null);
                    pelicula.uniqueId = '.';
                    Navigator.pushNamed(context, 'detalle',
                        arguments: pelicula);
                  },
                  trailing: vistas == 1
                      ? Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                          IconButton(
                            tooltip: AppLocalizations.of(context).towatchagain,
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              pelicula.seen = 0;

                              DBProvider.db.updatePelicula(pelicula);

                              Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).movieadded,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              DBProvider.db.deletePelicula(pelicula.id);
                              Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).movieremoved,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.purpleAccent,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              setState(() {});
                            },
                          ),
                        ])
                      : IconButton(
                          tooltip: AppLocalizations.of(context).viewed,
                          icon: Icon(Icons.check),
                          onPressed: () async {
                            pelicula.seen = 1;

                            int ok =
                                await DBProvider.db.updatePelicula(pelicula);

                            if (ok == 1) {
                              Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).movieadded,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );

                              setState(() {});
                            } else {
                              Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).notviewed,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.purpleAccent,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                        ),
                ),
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
