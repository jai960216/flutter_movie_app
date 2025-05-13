import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_movie_app/data/datasource/api_config.dart';
import 'package:flutter_movie_app/data/datasource/movie_data_source.dart';
import 'package:flutter_movie_app/data/dto/movie_detail_dto/movie_detail_dto.dart';
import 'package:flutter_movie_app/data/dto/movie_response_dto/movie_response_dto.dart';

class MovieDataSourceImpl implements MovieDataSource {
  final http.Client _client;

  MovieDataSourceImpl({http.Client? client})
    : _client = client ?? http.Client();

  @override
  Future<MovieResponseDto?> fetchNowPlayingMovies() async {
    try {
      final response = await _client.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/movie/now_playing?language=ko-KR&page=1',
        ),
        headers: ApiConfig.headers,
      );

      print('fetchNowPlayingMovies 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        print(
          'fetchNowPlayingMovies 응답 데이터 일부: ${response.body.substring(0, 200)}...',
        );
        return movieResponseDtoFromJson(response.body);
      } else {
        print('fetchNowPlayingMovies 오류 응답: ${response.body}');
        return null;
      }
    } catch (e) {
      print('fetchNowPlayingMovies 오류 발생: $e');
      return null;
    }
  }

  @override
  Future<MovieResponseDto?> fetchPopularMovies() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/movie/popular?language=ko-KR&page=1'),
        headers: ApiConfig.headers,
      );

      print('fetchPopularMovies 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        print(
          'fetchPopularMovies 응답 데이터 일부: ${response.body.substring(0, 200)}...',
        );
        return movieResponseDtoFromJson(response.body);
      } else {
        print('fetchPopularMovies 오류 응답: ${response.body}');
        return null;
      }
    } catch (e) {
      print('fetchPopularMovies 오류 발생: $e');
      return null;
    }
  }

  @override
  Future<MovieResponseDto?> fetchTopRatedMovies() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/movie/top_rated?language=ko-KR&page=1'),
        headers: ApiConfig.headers,
      );

      print('fetchTopRatedMovies 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        print(
          'fetchTopRatedMovies 응답 데이터 일부: ${response.body.substring(0, 200)}...',
        );
        return movieResponseDtoFromJson(response.body);
      } else {
        print('fetchTopRatedMovies 오류 응답: ${response.body}');
        return null;
      }
    } catch (e) {
      print('fetchTopRatedMovies 오류 발생: $e');
      return null;
    }
  }

  @override
  Future<MovieResponseDto?> fetchUpcomingMovies() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/movie/upcoming?language=ko-KR&page=1'),
        headers: ApiConfig.headers,
      );

      print('fetchUpcomingMovies 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        print(
          'fetchUpcomingMovies 응답 데이터 일부: ${response.body.substring(0, 200)}...',
        );
        return movieResponseDtoFromJson(response.body);
      } else {
        print('fetchUpcomingMovies 오류 응답: ${response.body}');
        return null;
      }
    } catch (e) {
      print('fetchUpcomingMovies 오류 발생: $e');
      return null;
    }
  }

  @override
  Future<MovieDetailDto?> fetchMovieDetail(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/movie/$id?language=ko-KR'),
        headers: ApiConfig.headers,
      );

      print('fetchMovieDetail 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        print(
          'fetchMovieDetail 응답 데이터 일부: ${response.body.substring(0, 200)}...',
        );
        return movieDetailDtoFromJson(response.body);
      } else {
        print('fetchMovieDetail 오류 응답: ${response.body}');
        return null;
      }
    } catch (e) {
      print('fetchMovieDetail 오류 발생: $e');
      return null;
    }
  }
}
