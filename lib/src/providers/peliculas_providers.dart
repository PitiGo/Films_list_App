import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/videos_model.dart';

class PeliculasProvider {
  String _apiKey = 'e8686676734d36b9c2b28f181906511b';
  String _url = 'api.themoviedb.org';
  String _language = 'es-Es';

  set language(value) {
    _language = value;
  }

  get language => _language;

  int _popularesPage = 1;
  bool _cargando = false;

  List<Pelicula> _populares = new List();
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString(),
    });

      final resp = await _procesarRespuesta(url);
    
      _populares.addAll(resp);

      popularesSink(_populares);

      _cargando = false;

      return resp;
   
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key': _apiKey,
      'language': _language,
    });

    final resp = await http.get(url);
    final decodedDAta = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedDAta['cast']);

    return cast.actores;
  }
   Future<List<Result>> getVideo(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/videos', {
      'api_key': _apiKey,
      'language': _language,
    });

    final resp = await http.get(url);
    final decodedDAta = json.decode(resp.body);

    final cast = new Video.fromJsonList(decodedDAta['results']);

    return cast.videos;
  }

  // Future <Pelicula> getPeliculaById(String peliId)async{

  //   final url = Uri.https(_url, '3/movie/$peliId/', {
  //     'api_key': _apiKey,
  //     'language': _language,

  //   });

  // }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    
    final respuesta = await http.get(url);
    
    final decodedDAta = json.decode(respuesta.body);

    final peliculas = new Peliculas.fromJsonList(decodedDAta['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    return await _procesarRespuesta(url);
  }
}
