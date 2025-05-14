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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailViewModel>().fetchMovieDetail(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetailViewModel>();
    return _buildStateScaffold(
      isLoading: vm.isLoading,
      error: vm.error,
      detail: vm.movieDetail,
      onRetry: () => vm.fetchMovieDetail(widget.movieId),
    );
  }

  Widget _buildStateScaffold({
    required bool isLoading,
    required String? error,
    required MovieDetail? detail,
    required VoidCallback onRetry,
  }) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('오류: $error'),
              ElevatedButton(onPressed: onRetry, child: const Text('다시 시도')),
            ],
          ),
        ),
      );
    }
    if (detail == null) {
      return const Scaffold(body: Center(child: Text('영화 정보를 찾을 수 없습니다')));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'movie-poster-${detail.id}',
                createRectTween:
                    (begin, end) =>
                        MaterialRectCenterArcTween(begin: begin, end: end),
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Image.network(detail.posterPath, fit: BoxFit.cover),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${detail.releaseDate.year}-${detail.releaseDate.month.toString().padLeft(2, '0')}-${detail.releaseDate.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detail.tagline,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${detail.runtime}분',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children:
                        detail.genres
                            .map((genre) => Chip(label: Text(genre)))
                            .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(detail.overview),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
