import 'package:flutter_movie_app/data/datasource/api_config.dart';
import 'package:flutter_movie_app/data/datasource/movie_data_source.dart';
import 'package:flutter_movie_app/domain/entity/movie.dart';
import 'package:flutter_movie_app/domain/entity/movie_detail.dart';
import 'package:flutter_movie_app/domain/repository/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieDataSource _dataSource;

  MovieRepositoryImpl(this._dataSource);

  @override
  Future<List<Movie>?> fetchNowPlayingMovies() async {
    final dto = await _dataSource.fetchNowPlayingMovies();
    if (dto == null) return null;

    return dto.results
        .map(
          (movieDto) => Movie(
            id: movieDto.id,
            posterPath: '${ApiConfig.imageBaseUrl}${movieDto.posterPath}',
            title: movieDto.title,
            overview: movieDto.overview,
            voteAverage: movieDto.voteAverage,
            releaseDate: movieDto.releaseDate,
          ),
        )
        .toList();
  }

  @override
  Future<List<Movie>?> fetchPopularMovies() async {
    final dto = await _dataSource.fetchPopularMovies();
    if (dto == null) return null;

    return dto.results
        .map(
          (movieDto) => Movie(
            id: movieDto.id,
            posterPath: '${ApiConfig.imageBaseUrl}${movieDto.posterPath}',
            title: movieDto.title,
            overview: movieDto.overview,
            voteAverage: movieDto.voteAverage,
            releaseDate: movieDto.releaseDate,
          ),
        )
        .toList();
  }

  @override
  Future<List<Movie>?> fetchTopRatedMovies() async {
    final dto = await _dataSource.fetchTopRatedMovies();
    if (dto == null) return null;

    return dto.results
        .map(
          (movieDto) => Movie(
            id: movieDto.id,
            posterPath: '${ApiConfig.imageBaseUrl}${movieDto.posterPath}',
            title: movieDto.title,
            overview: movieDto.overview,
            voteAverage: movieDto.voteAverage,
            releaseDate: movieDto.releaseDate,
          ),
        )
        .toList();
  }

  @override
  Future<List<Movie>?> fetchUpcomingMovies() async {
    final dto = await _dataSource.fetchUpcomingMovies();
    if (dto == null) return null;

    return dto.results
        .map(
          (movieDto) => Movie(
            id: movieDto.id,
            posterPath: '${ApiConfig.imageBaseUrl}${movieDto.posterPath}',
            title: movieDto.title,
            overview: movieDto.overview,
            voteAverage: movieDto.voteAverage,
            releaseDate: movieDto.releaseDate,
          ),
        )
        .toList();
  }

  @override
  Future<MovieDetail?> fetchMovieDetail(int id) async {
    final dto = await _dataSource.fetchMovieDetail(id);
    if (dto == null) return null;

    // 장르 이름만 추출
    final genres = dto.genres.map((genre) => genre.name).toList();

    // 제작사 로고 경로 추출 (null인 경우 필터링)
    final productionCompanyLogos =
        dto.productionCompanies
            .where((company) => company.logoPath != null)
            .map((company) => '${ApiConfig.imageBaseUrl}${company.logoPath}')
            .toList();

    return MovieDetail(
      budget: dto.budget,
      genres: genres,
      id: dto.id,
      productionCompanyLogos: productionCompanyLogos,
      overview: dto.overview,
      popularity: dto.popularity,
      releaseDate: dto.releaseDate,
      revenue: dto.revenue,
      runtime: dto.runtime,
      tagline: dto.tagline,
      title: dto.title,
      voteAverage: dto.voteAverage,
      voteCount: dto.voteCount,
      posterPath: '${ApiConfig.imageBaseUrl}${dto.posterPath}',
    );
  }
}
