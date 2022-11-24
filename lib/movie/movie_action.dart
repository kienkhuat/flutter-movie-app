import 'dart:async';
import 'package:dio/dio.dart';
import 'package:movieapp/constants/api_key.dart';
import 'package:movieapp/model/movie.dart';
import 'package:movieapp/model/movie_cast.dart';
import 'package:movieapp/model/movie_image.dart';
import 'package:movieapp/model/movie_video.dart';

Future<List<Movie>> getUpcomingMovies() async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey');
		//print(response.data['results']);
		//return Movie.fromJsonList(jsonDecode(response.data['results']));
		List<Movie> movieList = (response.data['results'] as List).map((item) {
			return Movie.fromJson(item);
		}).toList();
		return movieList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load upcoming movies');
	}
}

Future<List<Movie>> getPopularTvSeries(int pageNumber) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/tv/popular?api_key=$apiKey&page=$pageNumber');
		//print(response.data['results']);
		//return Movie.fromJsonList(jsonDecode(response.data['results']));
		List<Movie> movieList = (response.data['results'] as List).map((item) {
			return Movie.fromJson(item);
		}).toList();
		return movieList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load popular tv series');
	}
}

Future<List<Movie>> getPopularMovies(int pageNumber) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&page=$pageNumber');
		//print(response.data['results']);
		//return Movie.fromJsonList(jsonDecode(response.data['results']));
		List<Movie> movieList = (response.data['results'] as List).map((item) {
			return Movie.fromJson(item);
		}).toList();
		return movieList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load popular tv series');
	}
}

Future<List<Movie>> getTopRatedTvSeries(int pageNumber) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey&page=$pageNumber');
		//print(response.data['results']);
		//return Movie.fromJsonList(jsonDecode(response.data['results']));
		List<Movie> movieList = (response.data['results'] as List).map((item) {
			return Movie.fromJson(item);
		}).toList();
		return movieList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load top rated tv series');
	}
}
Future<List<Movie>> getTvSeriesOnTheAir(int pageNumber) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/tv/on_the_air?api_key=$apiKey&page=$pageNumber');
		//print(response.data['results']);
		//return Movie.fromJsonList(jsonDecode(response.data['results']));
		List<Movie> movieList = (response.data['results'] as List).map((item) {
			return Movie.fromJson(item);
		}).toList();
		return movieList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load top rated tv series');
	}
}

Future<List<Movie>> getTopRatedMovies(int pageNumber) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&page=$pageNumber');
		//print(response.data['results']);
		//return Movie.fromJsonList(jsonDecode(response.data['results']));
		List<Movie> movieList = (response.data['results'] as List).map((item) {
			return Movie.fromJson(item);
		}).toList();
		return movieList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load top rated movies');
	}
}

Future<List<Movie>> getTrendingMovies(String mediaType) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/trending/$mediaType/week?api_key=$apiKey');
		//print(response.data['results']);
		//return Movie.fromJsonList(jsonDecode(response.data['results']));
		List<Movie> movieList = (response.data['results'] as List).map((item) {
			return Movie.fromJson(item);
		}).toList();
		return movieList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load trending movies');
	}
}

Future<List<Movie>> getNowPlayingMovies(String mediaType) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/$mediaType/now_playing?api_key=$apiKey');
		//print(response.data['results']);
		//return Movie.fromJsonList(jsonDecode(response.data['results']));
		List<Movie> movieList = (response.data['results'] as List).map((item) {
			return Movie.fromJson(item);
		}).toList();
		return movieList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load trending movies');
	}
}

Future<List<Movie>> getSearchedMovies(String searchInput, int pageNumber) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/search/multi?api_key=$apiKey&query=$searchInput&page=$pageNumber&include_adult=false');
		//print(response.data['results']);
		List<Movie> movieList = (response.data['results'] as List).map((item) {
			return Movie.fromJson(item);
		}).toList();
		return movieList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load searched movies');
	}
}

Future<int> getSearchedTotalPage (String searchInput, int pageNumber) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/search/multi?api_key=$apiKey&query=$searchInput&page=$pageNumber&include_adult=false');
		return response.data['total_pages'];
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load searched movies');
	}
}

Future<Movie> getMovieDetail(int movieID, String mediaType) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/$mediaType/$movieID?api_key=$apiKey');
		//print(response.data);
		return Movie.fromJson(response.data);
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load detailed movie');
	}
}

Future<List<MovieVideo>> getVideoList(int id, String mediaType) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/$mediaType/$id/videos?api_key=$apiKey');
		//print(response.data);
		List<MovieVideo> videoList = (response.data['results'] as List).map((item) {
			//print(item);
			return MovieVideo.fromJson(item);
		}).toList();
		return videoList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load videos');
	}
}

Future<List<MovieImage>> getBackdropImageList(int id, String mediaType) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/$mediaType/$id/images?api_key=$apiKey');
		//print(response.data);
		List<MovieImage> imageList = (response.data['backdrops'] as List).map((item) {
			//print(item);
			return MovieImage.fromJson(item);
		}).toList();
		return imageList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load backdrop images');
	}
}

Future<List<MovieCast>> getCastList (int id, String mediaType) async {
	try {
		var response = await Dio().get('https://api.themoviedb.org/3/$mediaType/$id/credits?api_key=$apiKey');
		//print(response.data);
		List<MovieCast> castList = (response.data['cast'] as List).map((item) {
			//print(item);
			return MovieCast.fromJson(item);
		}).toList();
		return castList;
	} catch (err) {
		// ignore: avoid_print
		print(err);
		throw Exception('Failed to load casts');
	}
}