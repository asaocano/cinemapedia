import 'movie_moviedb.dart';

/*
 Representa cómo llega la película desde la api de the movie database
 Los Models representan los datos crudos de la API
 */
class MovieDbResponse {
  MovieDbResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final Dates? dates;
  final int page;
  final List<MovieFromMovieDb> results;
  final int totalPages;
  final int totalResults;

  /* 
    - Método que convierte el JSON que viene de la API en un objeto de Dart 
    que puede usarse en la app.
    - Transforma datos crudos de la API en un objeto Dart listo para usar
    */
  factory MovieDbResponse.fromJson(Map<String, dynamic> json) =>
      MovieDbResponse(
        dates: json["dates"] != null ? Dates.fromJson(json["dates"]) : null,
        page: json["page"],
        results: List<MovieFromMovieDb>.from(
          json["results"].map((x) => MovieFromMovieDb.fromJson(x)),
        ),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  /*
     Convierte la clase a un modelo json similar al que regresa la api al consultarla
     */
  Map<String, dynamic> toJson() => {
    "dates": dates == null ? null : dates!.toJson(),
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Dates {
  Dates({required this.maximum, required this.minimum});

  final DateTime maximum;
  final DateTime minimum;

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
    maximum: DateTime.parse(json["maximum"]),
    minimum: DateTime.parse(json["minimum"]),
  );

  Map<String, dynamic> toJson() => {
    "maximum":
        "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
    "minimum":
        "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
  };
}
