import 'package:flutter/material.dart';
import 'package:flutter_movie_app/domain/entity/movie_detail.dart';
import 'package:flutter_movie_app/presentation/viewmodel/detail_view_model.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final int movieId;

  const DetailPage({super.key, required this.movieId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    // 화면이 build된 후 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailViewModel>().fetchMovieDetail(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailViewModel>();

    if (viewModel.isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.error != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('오류: ${viewModel.error}'),
              ElevatedButton(
                onPressed: () => viewModel.fetchMovieDetail(widget.movieId),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    final movieDetail = viewModel.movieDetail;
    if (movieDetail == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text('영화 정보를 찾을 수 없습니다')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, movieDetail),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMovieInfo(movieDetail),
                _buildCategories(movieDetail.genres),
                _buildOverview(movieDetail.overview),
                _buildStats(movieDetail),
                _buildProductionCompanies(movieDetail.productionCompanyLogos),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, MovieDetail movieDetail) {
    return SliverAppBar(
      expandedHeight: 500,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'movie-poster-${movieDetail.id}',
          child: Image.network(movieDetail.posterPath, fit: BoxFit.cover),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildMovieInfo(MovieDetail movieDetail) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  movieDetail.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${movieDetail.releaseDate.year}-${movieDetail.releaseDate.month.toString().padLeft(2, '0')}-${movieDetail.releaseDate.day.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            movieDetail.tagline,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${movieDetail.runtime}분',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(List<String> genres) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            genres.map((genre) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue),
                ),
                child: Text(genre, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildOverview(String overview) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(overview, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildStats(MovieDetail movieDetail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '흥행정보',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildStatItem(
                  '평점',
                  movieDetail.voteAverage.toStringAsFixed(1),
                ),
                _buildStatItem('평점투표수', movieDetail.voteCount.toString()),
                _buildStatItem(
                  '인기점수',
                  movieDetail.popularity.toStringAsFixed(1),
                ),
                _buildStatItem('예산', '\$${movieDetail.budget}'),
                _buildStatItem('수익', '\$${movieDetail.revenue}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProductionCompanies(List<String> logoUrls) {
    if (logoUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '제작사',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: logoUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Image.network(logoUrls[index], height: 40),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
