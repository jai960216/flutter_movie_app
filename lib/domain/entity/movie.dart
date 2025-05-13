class Movie {
  final int id;
  final String posterPath;
  final String title;
  final String overview;
  final double voteAverage;
  final DateTime? releaseDate;

  Movie({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.overview,
    required this.voteAverage,
    this.releaseDate,
  });
}
