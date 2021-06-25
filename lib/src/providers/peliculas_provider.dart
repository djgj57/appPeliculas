import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';
import 'dart:convert';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'dart:async';

class PeliculasProvider {
  String _apikey = '2a588dbe2261bd8797b767ae6e607403';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = [];

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    // print(decodeData['results']);

    final peliculas = Peliculas.fromJsonList(decodeData['results']);

//    print(peliculas.items[0].title);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
    });
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];
    _cargando = true;

    _popularesPage++;

    final url = Uri.http(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key': _apikey,
      'language': _language,
    });
    final resp = await http.get(url);
    final decodeData = jsonDecode(resp.body);

    final cast = Cast.fromJsonList(decodeData['cast']);
    return cast.actores;
  }
}
// Peliculas:
// https://api.themoviedb.org/3/movie/now_playing?api_key=2a588dbe2261bd8797b767ae6e607403&language=es-ES&page=1#
// Actores:
// https://api.themoviedb.org/3/movie/456740/credits?api_key=2a588dbe2261bd8797b767ae6e607403&language=es-Es#
