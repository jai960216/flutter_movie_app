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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '가장 인기있는',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildMostPopularMovie(context, viewModel),
                _buildMovieListSection(
                  context,
                  '현재 상영중',
                  viewModel.nowPlayingMovies,
                  viewModel.isLoadingNowPlaying,
                  viewModel.errorNowPlaying,
                  viewModel.fetchNowPlayingMovies,
                ),
                _buildMovieListSection(
                  context,
                  '인기순',
                  viewModel.popularMovies,
                  viewModel.isLoadingPopular,
                  viewModel.errorPopular,
                  viewModel.fetchPopularMovies,
                  showRanking: true,
                ),
                _buildMovieListSection(
                  context,
                  '평점 높은순',
                  viewModel.topRatedMovies,
                  viewModel.isLoadingTopRated,
                  viewModel.errorTopRated,
                  viewModel.fetchTopRatedMovies,
                ),
                _buildMovieListSection(
                  context,
                  '개봉예정',
                  viewModel.upcomingMovies,
                  viewModel.isLoadingUpcoming,
                  viewModel.errorUpcoming,
                  viewModel.fetchUpcomingMovies,
                ),
              ],
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
                onPressed: viewModel.fetchPopularMovies,
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

    final movie = movies.first;
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailPage(movieId: movie.id)),
          ),
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Hero(
          tag: 'movie-poster-${movie.id}',
          createRectTween:
              (begin, end) =>
                  MaterialRectCenterArcTween(begin: begin, end: end),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              movie.posterPath,
              fit: BoxFit.cover,
              height: 450,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieListSection(
    BuildContext context,
    String title,
    List<Movie>? movies,
    bool isLoading,
    String? error,
    VoidCallback onRetry, {
    bool showRanking = false,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: movies.length.clamp(0, 20),
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(movieId: movie.id),
                              ),
                            ),
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Hero(
                            tag: '$title-movie-${movie.id}',
                            createRectTween:
                                (begin, end) => MaterialRectCenterArcTween(
                                  begin: begin,
                                  end: end,
                                ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                movie.posterPath,
                                width: 120,
                                height: 180,
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
}
