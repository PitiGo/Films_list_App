import 'dart:io';

import 'package:My_Films/src/models/actores_model.dart';
import 'package:My_Films/src/models/pelicula_model.dart';
import 'package:My_Films/src/providers/exceptions.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:My_Films/src/models/videos_model.dart';

class PeliculasProvider {
  String _apiKey = 'e8686676734d36b9c2b28f181906511b';
  String _url = 'api.themoviedb.org';
  String _language = 'es-Es';

  set language(value) {
    _language = value;
  }

  get language => _language;

  int _popularesPage = 1;
  int _topRatedPage = 1;
  bool _cargandoPopulares = false;
  bool _cargandoTopRated = false;

  List<Pelicula> _populares = new List();
  List<Pelicula> _topRated = new List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();
  final _topRatedStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  Function(List<Pelicula>) get topRatedSink =>
      _topRatedStreamController.sink.add;
  Stream<List<Pelicula>> get topRatedStream => _topRatedStreamController.stream;

  void disposeStreams() {
    _popularesStreamController.close();
    _topRatedStreamController.close();
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargandoPopulares) return [];

    _cargandoPopulares = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);

    popularesSink(_populares);

    _cargandoPopulares = false;

    return resp;
  }

  Future<List<Pelicula>> getTopRated() async {
    if (_cargandoTopRated) return [];

    _cargandoTopRated = true;

    _topRatedPage++;

    final url = Uri.https(_url, '3/movie/top_rated', {
      'api_key': _apiKey,
      'language': _language,
      'page': _topRatedPage.toString(),
    });

    final resp = await _procesarRespuesta(url);

    _topRated.addAll(resp);

    topRatedSink(_topRated);

    _cargandoTopRated = false;

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
      'language': 'en-En' /* _language */,
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
    try {
      final respuesta = await http.get(url);

      // final decodedDAta = json.decode(respuesta.body);
      final decodedDAta = _returnResponse(respuesta);
      final peliculas = new Peliculas.fromJsonList(decodedDAta['results']);
      return peliculas.items;
    } on SocketException {
      throw FetchDataException('No Internet connection!');
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());

        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        break;
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        break;
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    return await _procesarRespuesta(url);
  }
}
