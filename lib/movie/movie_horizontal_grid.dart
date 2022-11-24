import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constants/colors.dart';
import 'package:movieapp/constants/poster_root_url.dart';
import 'package:movieapp/model/movie.dart';
import 'package:movieapp/pages/movie_detailed_page.dart';
import 'package:movieapp/utilities/create_route.dart';

class MovieHorizontalGrid extends StatefulWidget {
	final String listName;
	final Future<List<Movie>> movieList;
	final bool showListTitle;
	const MovieHorizontalGrid({Key? key, required this.listName, required this.movieList, required this.showListTitle}) : super(key: key);

	@override
	State<MovieHorizontalGrid> createState() => _MovieHorizontalGridState();
}

class _MovieHorizontalGridState extends State<MovieHorizontalGrid> {

	Widget _buildListTitle() {
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: [
				Container(
					padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
					child: Text(
						widget.listName,
						style: const TextStyle(
							color: maGrey,
							fontSize: 20,
						)
					)
				),
				GestureDetector(
					onTap: () {print('See All Tapped');}, 
					child: Container(
						padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
						child: const Text(
							'See all',
							style: TextStyle(
								color: Colors.grey,
								fontSize: 16,
							)
						)
					)
				)
			]
		);
	}

	@override
	Widget build(BuildContext context) {
		return FutureBuilder(
			future: widget.movieList,
			builder: (context, snapshot) {
				if (snapshot.hasData == false) {
					return const SizedBox(
						height: 500,
						child: Center(child: CircularProgressIndicator(color: maGrey))
					);
				}
				return Column(
					children: [
						widget.showListTitle ? _buildListTitle() : Container(),
						SizedBox(
							height: 600,
							child: GridView.count(
								crossAxisCount: 2,
								padding: const EdgeInsets.all(15),
								mainAxisSpacing: 15,
								crossAxisSpacing: 15,
								childAspectRatio: 1.5,
								scrollDirection: Axis.horizontal,
								children: movieGridWidgetList(snapshot.data!)
							)
						)
					],
				);
			},
		);
  	}

	List<Widget> movieGridWidgetList (List<Movie> movies) {
		List<Widget> children = [];
		for(int index = 0; index < movies.length; index++) {
			children.add(
				GestureDetector(
					onTap:() {
						Navigator.of(context).push(createRoute(MovieDetailedPage(
							movieId: movies[index].movieId,
							mediaType: movies[index].mediaType != '' ? movies[index].mediaType : 'movie',
						)));
					},
					child: ClipRRect(
						borderRadius: BorderRadius.circular(20),
						child: Container(
							decoration: const BoxDecoration(
								color: maBlackDarker
							),
							child: Stack(
								children: [
									movies[index].posterPath != '' ? CachedNetworkImage(
										imageUrl: '$posterRootURL${movies[index].posterPath}',
										placeholder: ((context, url) => const Center(
											child: CircularProgressIndicator(color: maGrey,)
										)),
										errorWidget: (context, url, error) => const Center(
											child: Icon(Icons.error, color: maGrey)
										),
										fit: BoxFit.cover,
										height: 500,
									) : Image.asset('assets/images/movie_poster_placeholder.png'),
									Column(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											Container(),
											Column(
												children: [
													Container(
														width: double.infinity,
														padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
														color: maBlackDarker.withOpacity(0.8),
														child: Text(
															movies[index].movieTitle,
															style: const TextStyle(
																color: maWhite,
																fontWeight: FontWeight.bold,
															),
														),
													),
													Container(
														height: 100,
														width: double.infinity,
														color: maBlackDarker.withOpacity(0.8),
														padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
														child: Column(
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																Row(
																	mainAxisAlignment: MainAxisAlignment.spaceBetween,
																	children: [
																		Row(
																			children: [
																				Container(),
																					const Icon(
																						Icons.star_rounded,
																						color: Colors.orange,
																						size: 14
																				),
																				Text(
																					movies[index].voteAverage % 1 == 0
																					? movies[index].voteAverage.toInt().toString()
																					: movies[index].voteAverage.toStringAsFixed(1),
																					style: const TextStyle(
																						color: maWhite,
																						fontSize: 14,
																					)
																				),
																				const Text('/10', style: TextStyle(color: Colors.grey, fontSize: 14)),
																			],
																		),
																		movies[index].releaseDate != '' ? Text(
																			movies[index].releaseDate.substring(0, 4),
																			style: const TextStyle(
																				color: maGrey,
																				fontSize: 14,
																			)
																		) : Container()
																	],
																),
																AutoSizeText(
																	movies[index].movieOverview,
																	style: const TextStyle(
																		color: maGreyDarker,
																	),
																	maxLines: 3,
																	overflow: TextOverflow.ellipsis,
																),
															],
														)
													)
												],
											),
										],
									),
								],
							),
						),
					)
				),
			);
		}
		return children;
	}
}