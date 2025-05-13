import 'package:flutter/material.dart';
import 'package:flutter_movie_app/domain/entity/movie.dart';
import 'package:flutter_movie_app/presentation/home/detail/detailpage.dart';
import 'package:flutter_movie_app/presentation/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    print('[HomePage] initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('[HomePage] loadAllMovies 시작');
      context.read<HomeViewModel>().loadAllMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => viewModel.loadAllMovies(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '가장 인기있는',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // 가장 인기있는 영화 (큰 이미지)
                  _buildMostPopularMovie(context, viewModel),

                  // 현재 상영중 영화 섹션
                  _buildMovieSection(
                    context: context,
                    title: '현재 상영중',
                    isLoading: viewModel.isLoadingNowPlaying,
                    error: viewModel.errorNowPlaying,
                    movies: viewModel.nowPlayingMovies,
                    onRetry: () => viewModel.fetchNowPlayingMovies(),
                  ),

                  // 인기순 영화 섹션 (순위 표시 포함)
                  _buildRankedMovieSection(
                    context: context,
                    title: '인기순',
                    isLoading: viewModel.isLoadingPopular,
                    error: viewModel.errorPopular,
                    movies: viewModel.popularMovies,
                    onRetry: () => viewModel.fetchPopularMovies(),
                  ),

                  // 평점 높은순 섹션
                  _buildMovieSection(
                    context: context,
                    title: '평점 높은순',
                    isLoading: viewModel.isLoadingTopRated,
                    error: viewModel.errorTopRated,
                    movies: viewModel.topRatedMovies,
                    onRetry: () => viewModel.fetchTopRatedMovies(),
                  ),

                  // 개봉예정 섹션
                  _buildMovieSection(
                    context: context,
                    title: '개봉예정',
                    isLoading: viewModel.isLoadingUpcoming,
                    error: viewModel.errorUpcoming,
                    movies: viewModel.upcomingMovies,
                    onRetry: () => viewModel.fetchUpcomingMovies(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMostPopularMovie(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.isLoadingPopular) {
      return const SizedBox(
        height: 450,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.errorPopular != null) {
      return SizedBox(
        height: 450,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('오류: ${viewModel.errorPopular}'),
              ElevatedButton(
                onPressed: () => viewModel.fetchPopularMovies(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    final movies = viewModel.popularMovies;
    if (movies == null || movies.isEmpty) {
      return const SizedBox(
        height: 450,
        child: Center(child: Text('데이터가 없습니다')),
      );
    }

    final mostPopularMovie = movies.first;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return DetailPage(movieId: mostPopularMovie.id);
            },
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );
              return ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
                child: FadeTransition(opacity: curved, child: child),
              );
            },
          ),
        );
      },
      child: Hero(
        tag: 'movie-poster-${mostPopularMovie.id}',
        flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) {
          final shuttleChild =
              flightDirection == HeroFlightDirection.push
                  ? fromHeroContext.widget
                  : toHeroContext.widget;

          return Material(
            color: Colors.transparent,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Opacity(opacity: animation.value, child: child);
              },
              child: shuttleChild,
            ),
          );
        },

        createRectTween: (begin, end) {
          if (begin == null || end == null) {
            return RectTween(begin: begin, end: end); // fallback
          }
          return MaterialRectCenterArcTween(begin: begin, end: end);
        },

        child: Container(
          height: 450,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(mostPopularMovie.posterPath),
              fit: BoxFit.cover,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Align(alignment: Alignment.topLeft),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieSection({
    required BuildContext context,
    required String title,
    required bool isLoading,
    required String? error,
    required List<Movie>? movies,
    required VoidCallback onRetry,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180,
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('오류: $error'),
                        ElevatedButton(
                          onPressed: onRetry,
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  )
                  : movies == null || movies.isEmpty
                  ? const Center(child: Text('데이터가 없습니다'))
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length > 20 ? 20 : movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                              pageBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                              ) {
                                return DetailPage(movieId: movie.id);
                              },
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
                                final curved = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                );
                                return ScaleTransition(
                                  scale: Tween<double>(
                                    begin: 0.95,
                                    end: 1.0,
                                  ).animate(curved),
                                  child: FadeTransition(
                                    opacity: curved,
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: Hero(
                          tag: '$title-movie-${movie.id}',
                          flightShuttleBuilder: (
                            BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext,
                          ) {
                            final shuttleChild =
                                flightDirection == HeroFlightDirection.push
                                    ? fromHeroContext.widget
                                    : toHeroContext.widget;

                            return Material(
                              color: Colors.transparent,
                              child: AnimatedBuilder(
                                animation: animation,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: animation.value,
                                    child: child,
                                  );
                                },
                                child: shuttleChild,
                              ),
                            );
                          },

                          createRectTween: (begin, end) {
                            if (begin == null || end == null) {
                              return RectTween(
                                begin: begin,
                                end: end,
                              ); // fallback
                            }
                            return MaterialRectCenterArcTween(
                              begin: begin,
                              end: end,
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 180,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(movie.posterPath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildRankedMovieSection({
    required BuildContext context,
    required String title,
    required bool isLoading,
    required String? error,
    required List<Movie>? movies,
    required VoidCallback onRetry,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180,
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('오류: $error'),
                        ElevatedButton(
                          onPressed: onRetry,
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  )
                  : movies == null || movies.isEmpty
                  ? const Center(child: Text('데이터가 없습니다'))
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length > 20 ? 20 : movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                              pageBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                              ) {
                                return DetailPage(movieId: movie.id);
                              },
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
                                final curved = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                );
                                return ScaleTransition(
                                  scale: Tween<double>(
                                    begin: 0.95,
                                    end: 1.0,
                                  ).animate(curved),
                                  child: FadeTransition(
                                    opacity: curved,
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            // 영화 포스터
                            Hero(
                              tag: '$title-movie-${movie.id}',
                              flightShuttleBuilder: (
                                BuildContext flightContext,
                                Animation<double> animation,
                                HeroFlightDirection flightDirection,
                                BuildContext fromHeroContext,
                                BuildContext toHeroContext,
                              ) {
                                final shuttleChild =
                                    flightDirection == HeroFlightDirection.push
                                        ? fromHeroContext.widget
                                        : toHeroContext.widget;

                                return Material(
                                  color: Colors.transparent,
                                  child: AnimatedBuilder(
                                    animation: animation,
                                    builder: (context, child) {
                                      return Opacity(
                                        opacity: animation.value,
                                        child: child,
                                      );
                                    },
                                    child: shuttleChild,
                                  ),
                                );
                              },

                              createRectTween: (begin, end) {
                                if (begin == null || end == null) {
                                  return RectTween(
                                    begin: begin,
                                    end: end,
                                  ); // fallback
                                }
                                return MaterialRectCenterArcTween(
                                  begin: begin,
                                  end: end,
                                );
                              },
                              child: Container(
                                width: 120,
                                height: 180,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(movie.posterPath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            // 숫자를 표시할 별도의 컨테이너
                            Positioned(
                              left: 0,
                              top: 80,
                              bottom: 0,
                              width: 120,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    top: 10,
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 80,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.7),
                                          blurRadius: 5,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
