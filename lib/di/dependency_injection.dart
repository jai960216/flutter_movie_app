import 'package:flutter_movie_app/data/datasource/movie_data_source.dart';
import 'package:flutter_movie_app/data/datasource/movie_data_source_impl.dart';
import 'package:flutter_movie_app/domain/repository/movie_repository.dart';
import 'package:flutter_movie_app/domain/repository/movie_repository_impl.dart';
import 'package:flutter_movie_app/domain/usecase/get_movie_detail_usecase.dart';
import 'package:flutter_movie_app/domain/usecase/get_now_playing_movies_usecase.dart';
import 'package:flutter_movie_app/domain/usecase/get_popular_movies_usecase.dart';
import 'package:flutter_movie_app/domain/usecase/get_top_rated_movies_usecase.dart';
import 'package:flutter_movie_app/domain/usecase/get_upcoming_movies_usecase.dart';
import 'package:flutter_movie_app/presentation/viewmodel/detail_view_model.dart';
import 'package:flutter_movie_app/presentation/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/single_child_widget.dart';

class DependencyInjection {
  // 앱에 필요한 의존성 제공
  static List<SingleChildWidget> get providers {
    // Data Source
    final movieDataSource = MovieDataSourceImpl(client: http.Client());

    // Repository
    final movieRepository = MovieRepositoryImpl(movieDataSource);

    // Use Cases
    final getNowPlayingMoviesUseCase = GetNowPlayingMoviesUseCase(
      movieRepository,
    );
    final getPopularMoviesUseCase = GetPopularMoviesUseCase(movieRepository);
    final getTopRatedMoviesUseCase = GetTopRatedMoviesUseCase(movieRepository);
    final getUpcomingMoviesUseCase = GetUpcomingMoviesUseCase(movieRepository);
    final getMovieDetailUseCase = GetMovieDetailUseCase(movieRepository);

    return [
      // Data Layer
      Provider<MovieDataSource>.value(value: movieDataSource),
      Provider<MovieRepository>.value(value: movieRepository),

      // Domain Layer (Use Cases)
      Provider<GetNowPlayingMoviesUseCase>.value(
        value: getNowPlayingMoviesUseCase,
      ),
      Provider<GetPopularMoviesUseCase>.value(value: getPopularMoviesUseCase),
      Provider<GetTopRatedMoviesUseCase>.value(value: getTopRatedMoviesUseCase),
      Provider<GetUpcomingMoviesUseCase>.value(value: getUpcomingMoviesUseCase),
      Provider<GetMovieDetailUseCase>.value(value: getMovieDetailUseCase),

      // Presentation Layer (ViewModels)
      ChangeNotifierProvider(
        create:
            (_) => HomeViewModel(
              getNowPlayingMoviesUseCase: getNowPlayingMoviesUseCase,
              getPopularMoviesUseCase: getPopularMoviesUseCase,
              getTopRatedMoviesUseCase: getTopRatedMoviesUseCase,
              getUpcomingMoviesUseCase: getUpcomingMoviesUseCase,
            ),
      ),
      ChangeNotifierProvider.value(
        value: DetailViewModel(getMovieDetailUseCase: getMovieDetailUseCase),
      ),
    ];
  }
}
