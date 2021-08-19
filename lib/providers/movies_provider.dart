import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies/helpers/debouncer.dart';

import 'package:movies/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = 'fffc745c77912c5c8e8678b1b37c22da';
  final String _baseUrl = 'api.themoviedb.org';

  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> movieCast = {};
  Map<String, List<Movie>> moviesSearched = {};

  int _popularPage = 0;

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionsStreamController = new StreamController.broadcast();

  MoviesProvider() {
    print('MoviesProvider initialized.');

    getNowPlayingMovies();
    getPopularMovies();
  }

  Stream<List<Movie>> get suggestionStream => _suggestionsStreamController.stream;

  Future<String> _getJsonData(String path, {String? language = 'es-ES', int? page = 1, String query = ''}) async {
    Map<String, dynamic> urlQueries = { 'api_key': _apiKey };

    if (language != null) urlQueries['language'] = language;
    if (page != null) urlQueries['page'] = page.toString();
    if (query.isNotEmpty) urlQueries['query'] = query;

    final url = Uri.https(
      _baseUrl,
      path,
      urlQueries
    );
    final response = await http.get(url);

    return response.body;
  }

  getNowPlayingMovies() async {
    final String jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    nowPlayingMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final String jsonData = await _getJsonData('3/movie/popular', page: _popularPage);
    final popularsResponse = PopularsResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularsResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits', language: null, page: null);
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    movieCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> getSearchMovies(String query) async {
    if (moviesSearched.containsKey(query)) return moviesSearched[query]!;

    final String jsonData =
        await _getJsonData('3/search/movie', query: query, page: null);
    final moviesSearchResponse = MoviesSearchResponse.fromJson(jsonData);

    moviesSearched[query] = moviesSearchResponse.results;

    return moviesSearchResponse.results;
  }

  void getSuggestionsByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await getSearchMovies(value);
      _suggestionsStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
