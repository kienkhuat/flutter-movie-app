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
	final String mediaType;
	final bool showListTitle;
	const MovieHorizontalGrid({Key? key, required this.listName, required this.movieList, required this.showListTitle, required this.mediaType}) : super(key: key);

	@override
	State<MovieHorizontalGrid> createState() => _MovieHorizontalGridState();
}

class _MovieHorizontalGridState extends State<MovieHorizontalGrid> {

	Widget _buildListTitle() {
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: [
				Container(
					padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
						padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
							mediaType: widget.mediaType,
						)));
					},
					child: ClipRRect(
						borderRadius: BorderRadius.circular(20),
						child: Container(
							height: 500,
							decoration: BoxDecoration(
								color: maBlackDarkest,
								image: DecorationImage(
									image: movies[index].posterPath != '' ? CachedNetworkImageProvider(
										'$posterRootURL${movies[index].posterPath}',
									) : const AssetImage('assets/images/movie_poster_placeholder.png') as ImageProvider,
									fit: BoxFit.cover,
								),
							),
							child: Column(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									Container(),
									Column(
										children: [
											Container(
												width: 1000,
												padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
												decoration: BoxDecoration(
													color: maBlackDarker.withOpacity(0.8),
													border: Border.all(
														width: 0, 
														color: maBlackDarker.withOpacity(0.8),
														style: BorderStyle.none,
													),
												),
												child: Text(
													movies[index].title,
													style: const TextStyle(
														color: maWhite,
														fontWeight: FontWeight.bold,
													),
												),
											),
											Container(
												height: 100,
												width: 1000,
												decoration: BoxDecoration(
													color: maBlackDarker.withOpacity(0.8),
													border: Border.all(
														width: 0, 
														color: maBlackDarker,
														style: BorderStyle.none,
													),
												),
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
															movies[index].overview,
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
						),
					)
				),
			);
		}
		return children;
	}
}