class Movie {
	final String movieTitle;
	final String backdropPath;
	final int movieId;
	final String movieOverview;
	final String posterPath;
	final String mediaType;
	final String releaseDate;
	final double voteAverage;
	final double voteCount;
	final List<dynamic> genres;
	final int runtime;
	final List<dynamic> seasons;
	//For People not movie
	final String profilePath;
	final String biography;

	late String error;

	Movie({
		required this.movieTitle,
		required this.backdropPath,
		required this.movieId,
		required this.movieOverview,
		required this.posterPath,
		required this.mediaType,
		required this.releaseDate,
		required this.voteAverage,
		required this.voteCount,
		required this.genres,
		required this.runtime,
		required this.seasons,
		required this.profilePath,
		required this.biography,
	});

	factory Movie.fromJson(Map<String, dynamic> json) {
		return Movie(
			backdropPath: json['backdrop_path'] ?? '',
        	movieId: json['id'],
        	movieOverview: json['overview'] ?? '',
			posterPath: json['poster_path'] ?? '',
			releaseDate: json['release_date'] ?? '',
			movieTitle: json['title']?.isEmpty ?? true ? json['name'] : json['title'],
			voteCount: json['vote_count'] ?? 0, //double
			mediaType: json['media_type'] ?? '', //String
			voteAverage: json['vote_average'] ?? 0,//double
			genres: json['genres'] ?? [],
			runtime: json['runtime'] ?? 0,
			seasons: json['seasons'] ?? [], //List
			profilePath: json['profile_path'] ?? '',
			biography: json['biography'] ?? '',
		);
	}
}