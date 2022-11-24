import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constants/colors.dart';
import 'package:movieapp/constants/poster_root_url.dart';
import 'package:movieapp/model/movie.dart';
import 'package:movieapp/pages/movie_detailed_page.dart';
import 'package:movieapp/utilities/create_route.dart';

class MovieCarouselAlternate extends StatefulWidget {
	final String listName;
	final String mediaType;
	final Future<List<Movie>> movieList;
	final bool showListTitle;
	const MovieCarouselAlternate({ Key? key, required this.listName, required this.movieList, required this.showListTitle, required this.mediaType }) : super(key: key);

	@override
	State<MovieCarouselAlternate> createState() => _MovieCarouselAlternateState();
}

class _MovieCarouselAlternateState extends State<MovieCarouselAlternate> {

	Widget _buildListTitle() {
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: [
				Container(
					padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
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
						padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
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
			builder:(context, snapshot) {
				if (snapshot.hasData == false) {
					return const SizedBox(
						height: 300,
						child: Center(child: CircularProgressIndicator(color: maGrey))
					);
				}
				return Container(
					margin: const EdgeInsets.only(top: 30),
					child: Column(
						children: [
							widget.showListTitle ? _buildListTitle() : Container(),
							CarouselSlider.builder(
								itemCount: snapshot.data?.length ?? 0,
								options: CarouselOptions(
									initialPage: 0,
									height: 270,
									scrollDirection: Axis.horizontal,
									enlargeCenterPage: true,
									viewportFraction: 0.8,
								),
								itemBuilder: (context, index, realIndex) {
									return movieCarouselCard(snapshot.data![index]);
								},
							)
						],
					)
				); 
			},
		);
	}

	Widget movieCarouselCard(Movie movie) {
		return GestureDetector(
			onTap: () {
				Navigator.of(context).push(createRoute(MovieDetailedPage(
					movieId: movie.movieId,
					mediaType: widget.mediaType,
				)));
			},
			child: ClipRRect(
				borderRadius: BorderRadius.circular(20),
				child: Stack(
					children: [
						Container(
							color: maBlackDarker,
							child: movie.posterPath != '' && movie.backdropPath != '' ? CachedNetworkImage(
								imageUrl: '$posterRootURL${movie.backdropPath != '' ? movie.backdropPath : movie.posterPath}',
								placeholder: ((context, url) => const SizedBox(
									child: Center(
										child: CircularProgressIndicator(color: maGrey,)
									))
								),
								errorWidget: (context, url, error) => const SizedBox(
									child: Center(
										child: Icon(Icons.error, color: maGrey)
									)
								),
								height: 1000,
								width: 1000,
								fit: BoxFit.cover,
							) : Image.asset('assets/images/movie_poster_placeholder.png'),
						),
						Column(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Container(),
								Container(
									padding: const EdgeInsets.all(10),
									height: 50,
									width: 1000,
									color: maBlackDarker.withOpacity(0.8),
									child: Column(
										children: [
											AutoSizeText(
												movie.title,
												maxLines: 1,
												overflow: TextOverflow.ellipsis,
												style: const TextStyle(
													color: maGrey,
													fontSize: 16,
													fontWeight: FontWeight.bold,
												),
											),
										]
									),
								),
							],
						),
					],
				),
			)
		);
	}
}