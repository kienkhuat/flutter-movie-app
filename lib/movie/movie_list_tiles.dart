import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constants/colors.dart';
import 'package:movieapp/model/movie.dart';
import 'package:movieapp/pages/movie_detailed_page.dart';
import 'package:movieapp/constants/poster_root_url.dart';
import 'package:movieapp/utilities/create_route.dart';
import 'package:truncate/truncate.dart';

List<Widget> movieListTiles(List<Movie> movieList, dynamic context, String mediaType) {
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
												child: movieList[i].posterPath != '' ? CachedNetworkImage(
													imageUrl: '$posterRootURL${movieList[i].posterPath}',
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
																truncate(movieList[i].movieTitle, 55), 
																style: const TextStyle(
																	color: maWhite,
																	fontSize: 20,
																),
															)
														),
														Row(
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
														),
														Container(
															margin: const EdgeInsets.only(top: 4),
															child: Text(
																truncate(movieList[i].movieOverview, 80), 
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