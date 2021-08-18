import 'dart:convert';

import 'package:movies/models/models.dart';

class PopularsResponse {
  PopularsResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalMovies,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalMovies;

  factory PopularsResponse.fromJson(String str) =>
      PopularsResponse.fromMap(json.decode(str));

  factory PopularsResponse.fromMap(Map<String, dynamic> json) =>
      PopularsResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalMovies: json["total_results"],
      );
}


