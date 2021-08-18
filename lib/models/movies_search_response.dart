import 'dart:convert';

import 'package:movies/models/models.dart';

class MoviesSearchResponse {
    MoviesSearchResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    factory MoviesSearchResponse.fromJson(String str) => MoviesSearchResponse.fromMap(json.decode(str));

    factory MoviesSearchResponse.fromMap(Map<String, dynamic> json) => MoviesSearchResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );
}
