class MovieVideo {
	final String name;
	final String key;
	final String site;
	final String type;
	final String id;
	final bool official;
	final String publishedAt;

	late String error;

	MovieVideo({
		required this.name,
		required this.key,
		required this.site,
		required this.type,
		required this.id,
		required this.official,
		required this.publishedAt,
	});

	factory MovieVideo.fromJson(Map<String, dynamic> json) {
		return MovieVideo(
			name: json['name'] ?? '',
			key: json['key'] ?? '',
			site: json['site'] ?? '',
			type: json['type'] ?? '',
			id: json['id'] ?? '',
			official: json['official'] ?? false,
			publishedAt: json['published_at'] ?? '',
		);
	}
}