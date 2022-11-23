class MovieCast {
	final String knownForDepartment;
	final String name;
	final double popularity;
	final String profilePath;
	final String character;
	final String creditID;
	final int order;

	late String error;

	MovieCast({
		required this.knownForDepartment,
		required this.name,
		required this.popularity,
		required this.profilePath,
		required this.character,
		required this.creditID,
		required this.order,
	});

	factory MovieCast.fromJson(Map<String, dynamic> json) {
		return MovieCast(
			knownForDepartment: json['known_for_department'] ?? '', //String
			name: json['name'] ?? '', //string
			popularity: json['popularity'] ?? 0, //double
			profilePath: json['profile_path'] ?? '', //string
			character: json['character'] ?? '', //string
			creditID: json['credit_id'] ?? '', //string
			order: json['order'],
		);
	}
}