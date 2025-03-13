class Rating {
  final double _averageRating;
  final int _reviewCount;

  Rating(this._averageRating, this._reviewCount);

  double getAverageRating() => _averageRating;

  int getReviewCount() => _reviewCount;
}
