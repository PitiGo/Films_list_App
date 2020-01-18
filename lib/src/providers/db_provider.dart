import 'dart:io';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'PelisDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) async {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Movies ('
          'id INTEGER PRIMARY KEY,'
          'title TEXT,'
          'poster_path TEXT,'
          'original_title TEXT,'
          'vote_count INTEGER,'
          'video BOOL,'
          'popularity INTEGER,'
          'original_language TEXT,'
          'adult BOOL,'
          'backdrop_path TEXT,'
          'genre_ids INTEGER,'
          'vote_average INTEGER,'
          'overview TEXT,'
          'release_date TEXT,'
          'seen INTEGER'
          ')');
    });
  }

//CREAR REGISTROS

  nuevaPeliRaw(Pelicula pelicula) async {
    final db = await database;

    final res = await db.rawInsert("INSERT INTO Movies (id,title,posterpath) "
        "VALUES (${pelicula.id}, '${pelicula.title}','${pelicula.getPosterImg()}')");

    return res;
  }

  nuevaPeli(Pelicula pelicula) async {
    final db = await database;
    final res = await db.insert('Movies', pelicula.toJson());
    return res;
  }

  //SELECT -Obtener información

  Future<Pelicula> getPeliId(int id) async {
    final db = await database;

    final res = await db.query('Movies', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? Pelicula.fromJson(res.first) : null;
  }


  Future<List<Pelicula>> getAllMovies() async {
    final db = await database;

    final res = await db.query('Movies');


    List<Pelicula> list =  res.isNotEmpty ? res.map((c) => Pelicula.fromJson(c)).toList() : [];


    return list;
  }

  Future<List<Pelicula>> getAllSeenMovies(int vistaOno) async {
    final db = await database;

    final res = await db.query('Movies', where: 'seen = ?',whereArgs: [vistaOno]);


    List<Pelicula> list =  res.isNotEmpty ? res.map((c) => Pelicula.fromJson(c)).toList() : [];

    return list;
  }
 
  // Future<List<Pelicula>> getScansPorTipo(String tipo) async {
  //   final db = await database;

  //   final res = await db.rawQuery("SELECT * FROM Peliculas where tipo='$tipo'");

  //   List<Pelicula> list =
  //       res.isNotEmpty ? res.map((c) => Pelicula.fromJson(c)).toList() : [];

  //   return list;
  // }

  //ACTUALIZAR Registros

  Future<int> updatePelicula(Pelicula pelicula) async {
    final db = await database;

    final res = await db.update('Movies', pelicula.toJson(),
        where: 'id= ?', whereArgs: [pelicula.id]);

    return res;
  }

  //ELIMINAR Registros

  Future<int> deletePelicula(int id) async {
    final db = await database;

    final res = await db.delete('Movies', where: 'id=?', whereArgs: [id]);

    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;

    final res = await db.rawDelete('DELETE FROM Movies');

    return res;
  }
}
