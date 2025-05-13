import 'package:flutter/material.dart';
import 'package:flutter_movie_app/domain/entity/movie.dart';
import 'package:flutter_movie_app/domain/usecase/get_now_playing_movies_usecase.dart';
import 'package:flutter_movie_app/domain/usecase/get_popular_movies_usecase.dart';
import 'package:flutter_movie_app/domain/usecase/get_top_rated_movies_usecase.dart';
import 'package:flutter_movie_app/domain/usecase/get_upcoming_movies_usecase.dart';

class HomeViewModel extends ChangeNotifier {
  final GetNowPlayingMoviesUseCase _getNowPlayingMoviesUseCase;
  final GetPopularMoviesUseCase _getPopularMoviesUseCase;
  final GetTopRatedMoviesUseCase _getTopRatedMoviesUseCase;
  final GetUpcomingMoviesUseCase _getUpcomingMoviesUseCase;

  // 현재 상영중 영화 상태
  List<Movie>? _nowPlayingMovies;
  List<Movie>? get nowPlayingMovies => _nowPlayingMovies;
  bool _isLoadingNowPlaying = false;
  bool get isLoadingNowPlaying => _isLoadingNowPlaying;
  String? _errorNowPlaying;
  String? get errorNowPlaying => _errorNowPlaying;

  // 인기순 영화 상태
  List<Movie>? _popularMovies;
  List<Movie>? get popularMovies => _popularMovies;
  bool _isLoadingPopular = false;
  bool get isLoadingPopular => _isLoadingPopular;
  String? _errorPopular;
  String? get errorPopular => _errorPopular;

  // 평점 높은순 영화 상태
  List<Movie>? _topRatedMovies;
  List<Movie>? get topRatedMovies => _topRatedMovies;
  bool _isLoadingTopRated = false;
  bool get isLoadingTopRated => _isLoadingTopRated;
  String? _errorTopRated;
  String? get errorTopRated => _errorTopRated;

  // 개봉예정 영화 상태
  List<Movie>? _upcomingMovies;
  List<Movie>? get upcomingMovies => _upcomingMovies;
  bool _isLoadingUpcoming = false;
  bool get isLoadingUpcoming => _isLoadingUpcoming;
  String? _errorUpcoming;
  String? get errorUpcoming => _errorUpcoming;

  HomeViewModel({
    required GetNowPlayingMoviesUseCase getNowPlayingMoviesUseCase,
    required GetPopularMoviesUseCase getPopularMoviesUseCase,
    required GetTopRatedMoviesUseCase getTopRatedMoviesUseCase,
    required GetUpcomingMoviesUseCase getUpcomingMoviesUseCase,
  }) : _getNowPlayingMoviesUseCase = getNowPlayingMoviesUseCase,
       _getPopularMoviesUseCase = getPopularMoviesUseCase,
       _getTopRatedMoviesUseCase = getTopRatedMoviesUseCase,
       _getUpcomingMoviesUseCase = getUpcomingMoviesUseCase;

  // 모든 영화 데이터 로드
  Future<void> loadAllMovies() async {
    await Future.wait([
      fetchNowPlayingMovies(),
      fetchPopularMovies(),
      fetchTopRatedMovies(),
      fetchUpcomingMovies(),
    ]);
  }

  // 현재 상영중 영화 로드
  Future<void> fetchNowPlayingMovies() async {
    _isLoadingNowPlaying = true;
    _errorNowPlaying = null;
    notifyListeners();

    try {
      final movies = await _getNowPlayingMoviesUseCase.execute();
      _nowPlayingMovies = movies;
      _errorNowPlaying = null;
    } catch (e) {
      _errorNowPlaying = e.toString();
    } finally {
      _isLoadingNowPlaying = false;
      notifyListeners();
    }
  }

  // 인기순 영화 로드
  Future<void> fetchPopularMovies() async {
    _isLoadingPopular = true;
    _errorPopular = null;
    notifyListeners();

    try {
      final movies = await _getPopularMoviesUseCase.execute();
      _popularMovies = movies;
      _errorPopular = null;
    } catch (e) {
      _errorPopular = e.toString();
    } finally {
      _isLoadingPopular = false;
      notifyListeners();
    }
  }

  // 평점 높은순 영화 로드
  Future<void> fetchTopRatedMovies() async {
    _isLoadingTopRated = true;
    _errorTopRated = null;
    notifyListeners();

    try {
      final movies = await _getTopRatedMoviesUseCase.execute();
      _topRatedMovies = movies;
      _errorTopRated = null;
    } catch (e) {
      _errorTopRated = e.toString();
    } finally {
      _isLoadingTopRated = false;
      notifyListeners();
    }
  }

  // 개봉예정 영화 로드
  Future<void> fetchUpcomingMovies() async {
    _isLoadingUpcoming = true;
    _errorUpcoming = null;
    notifyListeners();

    try {
      final movies = await _getUpcomingMoviesUseCase.execute();
      _upcomingMovies = movies;
      _errorUpcoming = null;
    } catch (e) {
      _errorUpcoming = e.toString();
    } finally {
      _isLoadingUpcoming = false;
      notifyListeners();
    }
  }
}
