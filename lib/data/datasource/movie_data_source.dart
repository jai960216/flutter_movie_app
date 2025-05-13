import 'package:flutter_movie_app/data/dto/movie_detail_dto/movie_detail_dto.dart';
import 'package:flutter_movie_app/data/dto/movie_response_dto/movie_response_dto.dart';

abstract interface class MovieDataSource {
  Future<MovieResponseDto?> fetchNowPlayingMovies();

  Future<MovieResponseDto?> fetchPopularMovies();

  Future<MovieResponseDto?> fetchTopRatedMovies();

  Future<MovieResponseDto?> fetchUpcomingMovies();

  Future<MovieDetailDto?> fetchMovieDetail(int id);
}
