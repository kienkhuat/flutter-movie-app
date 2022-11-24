import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constants/colors.dart';
import 'package:movieapp/model/movie.dart';
import 'package:movieapp/constants/poster_root_url.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movieapp/pages/movie_detailed_page.dart';
import 'package:movieapp/utilities/create_route.dart';

class  MovieCarousel extends StatefulWidget {
	final String listName;
	final Future<List<Movie>> movieList;
	const MovieCarousel({Key? key, required this.listName, required this.movieList}) : super(key: key);	
	@override
	State<StatefulWidget> createState() => _MovieCarousel();
}

class _MovieCarousel extends State<MovieCarousel> {	
	@override
	void initState() {
		super.initState();
  	}

	@override
	void dispose() {
		super.dispose();
  	}

	@override
	Widget build(BuildContext context) {
		return Container(
			margin: const EdgeInsets.only(top: 15, bottom: 15),
			child: Column(
				children: [
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Container(
								padding: const EdgeInsets.all(10),
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
									padding: const EdgeInsets.all(10),
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
					),
					SizedBox(
						height: 436,
						width: MediaQuery.of(context).size.width,
						child: FutureBuilder<List<Movie>>(
							future: widget.movieList,
							builder: (context, snapshot) {
								if (snapshot.hasData == false) {
									return const Center(child: CircularProgressIndicator(color: maGrey));
								}
								return Container(
									decoration: const BoxDecoration(
										gradient: LinearGradient(
											begin: Alignment.centerLeft, end: Alignment.centerRight,
											colors: [maBlackDarkest2, maBlackDarker, maBlackDarker, maBlackDarkest2],
											stops: [0.0, 0.08, 0.92, 1]
										)
									),
									child: CarouselSlider.builder(
										itemCount: snapshot.data?.length ?? 0,
										options: CarouselOptions(
											height: 436,
											initialPage: 0,
											scrollDirection: Axis.horizontal,
											enlargeCenterPage: true,
											viewportFraction: 1,
										),
										itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
											return GestureDetector(
												onTap: () => {
													Navigator.of(context).push(createRoute(MovieDetailedPage(
														movieId: snapshot.data![itemIndex].movieId,
														mediaType: snapshot.data![itemIndex].mediaType,
													)))
												},
												child: snapshot.data![itemIndex].posterPath != '' ? CachedNetworkImage(
													imageUrl: '$posterRootURL${snapshot.data![itemIndex].posterPath}',
													placeholder: ((context, url) => const Center(
														child: CircularProgressIndicator(color: maGrey,)
													)),
													errorWidget: (context, url, error) => const Center(
														child: Icon(Icons.error, color: maGrey)
													),
													fit: BoxFit.fitHeight,
												) : Image.asset('assets/images/movie-poster-placeholder.png')
											);
										},
									)
								);
							}
						)
					)
				]
			)
		);
	}
}