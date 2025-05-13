import 'package:flutter/material.dart';
import 'package:flutter_movie_app/domain/entity/movie_detail.dart';
import 'package:flutter_movie_app/domain/usecase/get_movie_detail_usecase.dart';

class DetailViewModel extends ChangeNotifier {
  final GetMovieDetailUseCase _getMovieDetailUseCase;

  MovieDetail? _movieDetail;
  MovieDetail? get movieDetail => _movieDetail;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  DetailViewModel({required GetMovieDetailUseCase getMovieDetailUseCase})
    : _getMovieDetailUseCase = getMovieDetailUseCase;

  // 영화 상세 정보 로드
  Future<void> fetchMovieDetail(int movieId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final detail = await _getMovieDetailUseCase.execute(movieId);
      _movieDetail = detail;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
