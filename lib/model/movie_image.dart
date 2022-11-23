class MovieImage {
	final double aspectRatio;
	final String filePath;
	final int height;
	final int width;
	final double voteAverage;
	final int voteCount;

	late String error;

	MovieImage({
		required this.aspectRatio,
		required this.filePath,
		required this.height,
		required this.width,
		required this.voteAverage,
		required this.voteCount,
	});

	factory MovieImage.fromJson(Map<String, dynamic> json) {
		return MovieImage(
			aspectRatio: json['aspect_ratio'] ?? 0,
			filePath: json['file_path'] ?? '',
			height: json['height'] ?? 0,
			width: json['width'] ?? 0,
			voteAverage: json['vote_average'] ?? 0,
			voteCount: json['vote_count'] ?? 0,
		);
	}
}