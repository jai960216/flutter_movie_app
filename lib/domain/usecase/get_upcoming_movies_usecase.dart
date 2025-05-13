import 'package:flutter_movie_app/domain/entity/movie.dart';
import 'package:flutter_movie_app/domain/repository/movie_repository.dart';

class GetUpcomingMoviesUseCase {
  final MovieRepository _repository;

  GetUpcomingMoviesUseCase(this._repository);

  Future<List<Movie>?> execute() {
    return _repository.fetchUpcomingMovies();
  }
}
