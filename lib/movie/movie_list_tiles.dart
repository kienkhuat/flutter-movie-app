import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constants/colors.dart';
import 'package:movieapp/model/movie.dart';
import 'package:movieapp/pages/movie_detailed_page.dart';
import 'package:movieapp/constants/poster_root_url.dart';
import 'package:movieapp/utilities/create_route.dart';
import 'package:truncate/truncate.dart';

List<Widget> movieListTiles(List<Movie> movieList, dynamic context) {
		List<Widget> childs = [];
		for(int i = 0; i < movieList.length; i++) {
			childs.add(
				GestureDetector(
					onTap: () => {
						Navigator.of(context).push(createRoute(MovieDetailedPage(
							movieId: movieList[i].movieId,
							mediaType: movieList[i].mediaType,
						)))
					},
					child: Container(
						decoration: BoxDecoration(
							color: maBlackDarker,
							borderRadius: BorderRadius.circular(8),
						),
						margin: const EdgeInsets.only(bottom: 20),
						child: ClipRRect(
							borderRadius: BorderRadius.circular(8),
							child: SizedBox(
								height: 240,
								child: Row(
									children: [
										SizedBox(
											height: 240,
											child: Container(
												decoration: const BoxDecoration(color: maBlackDarkest),
												child: movieList[i].profilePath != '' || movieList[i].posterPath != '' ? CachedNetworkImage(
													imageUrl: movieList[i].mediaType == 'movie' || movieList[i].mediaType == 'tv' 
													? '$posterRootURL${movieList[i].posterPath}'
													: '$posterRootURL${movieList[i].profilePath}',
													placeholder: ((context, url) => const Center(
														child: CircularProgressIndicator(color: maGrey,)
													)),
													errorWidget: (context, url, error) => const Center(
														child: Icon(Icons.error, color: maGrey)
													),
													fit: BoxFit.fitHeight,
													width: 160,
												) : Image.asset('assets/images/movie-poster-placeholder.png')
											)
										),
										Flexible(
											child: Container(
												padding: const EdgeInsets.all(16),
												child: Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														Container(
															margin: const EdgeInsets.only(bottom: 4),
															child: Text(
																truncate(movieList[i].title, 55), 
																style: const TextStyle(
																	color: maWhite,
																	fontSize: 20,
																),
															)
														),
														movieList[i].mediaType == 'movie' || movieList[i].mediaType == 'tv' ? Row(
															children: [
																const Icon(
																	Icons.star_rounded,
																	color: Colors.orange,
																),
																Text(
																	movieList[i].voteAverage % 1 == 0
																	? movieList[i].voteAverage.toInt().toString()
																	: movieList[i].voteAverage.toStringAsFixed(1),
																	style: const TextStyle(
																		color: maWhite,
																		fontSize: 16,
																	)
																),
																const Text('/10', style: TextStyle(color: Colors.grey, fontSize: 16))
															],
														) : Text(
															movieList[i].mediaType.substring(0, 1).toUpperCase() + movieList[i].mediaType.substring(1, movieList[i].mediaType.length),
															style: const TextStyle(
																color: maGrey,
																fontSize: 16,
															)
														),
														Container(
															margin: const EdgeInsets.only(top: 4),
															child: Text(
																truncate(movieList[i].overview, 80), 
																style: const TextStyle(
																	color: maWhite,
																	fontSize: 16,
																),
																//overflow: TextOverflow.ellipsis,
															)
														),
													],
												)
											)
										)
									],
								),
							)
						)
					)
				),
			);
		}
		return childs;
	}