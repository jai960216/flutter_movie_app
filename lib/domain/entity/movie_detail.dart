class MovieDetail {
  /// 영화의 예산
  final int budget;

  /// 영화의 장르 리스트 (예: ["액션", "드라마", "스릴러"])
  final List<String> genres;

  /// 영화의 고유 ID (API에서 유니크한 식별자)
  final int id;

  /// 제작 회사 로고들의 리스트 (각 로고는 이미지 경로 또는 URL일 수 있음)
  final List<String> productionCompanyLogos;

  /// 영화에 대한 간략한 설명 (줄거리)
  final String overview;

  /// 영화의 인기 점수 (예: TMDB에서 제공하는 popularity 점수)
  final double popularity;

  /// 영화의 개봉일 (예: 2023-05-01)
  final DateTime releaseDate;

  /// 영화의 총 수익 (revenue)
  final int revenue;

  /// 영화의 상영 시간 (분 단위)
  final int runtime;

  /// 영화의 태그라인 (짧은 홍보 문구)
  final String tagline;

  /// 영화의 제목
  final String title;

  /// 영화의 평균 평점 (예: 8.4)
  final double voteAverage;

  /// 영화에 대한 총 투표 수
  final int voteCount;

  /// 영화 포스터 경로
  final String posterPath;

  MovieDetail({
    required this.budget,
    required this.genres,
    required this.id,
    required this.productionCompanyLogos,
    required this.overview,
    required this.popularity,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.tagline,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    required this.posterPath,
  });
}
