import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constants/colors.dart';
import 'package:movieapp/model/movie_cast.dart';
import 'package:movieapp/model/movie_image.dart';
import 'package:movieapp/model/movie_video.dart';
import 'package:movieapp/movie/movie_action.dart';
import 'package:movieapp/constants/poster_root_url.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieDetailedPage extends StatefulWidget {
	final int movieId;
	final String mediaType;
	const MovieDetailedPage({ Key? key, required this.movieId, required this.mediaType }) : super(key: key);

	@override
	State<MovieDetailedPage> createState() => _MovieDetailedStatePage();
}

class _MovieDetailedStatePage extends State<MovieDetailedPage> {
	late List<MovieVideo> videoList = [];
	late List<MovieImage> backdropImageList = [];
	late List<MovieCast> castList = [];
	late YoutubePlayerController _youtubeController;

	@override
	void initState() {
    	super.initState();
		_youtubeController = YoutubePlayerController(
			params: const YoutubePlayerParams(
				showControls: true,
				mute: true,
				showFullscreenButton: false,
				loop: false,
			),
		);
		_youtubeController.onFullscreenChange = ((isFullScreen) {
			print('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
		});
		widget.mediaType == 'movie' || widget.mediaType == 'tv' ? getVideoList(widget.movieId, widget.mediaType).then((result) {
			List<String> keyList = [];
			for(int index = 0; index < result.length; index++) {
				keyList.add(result[index].key);
			}
			_youtubeController.onInit = () {
				_youtubeController.cuePlaylist(list: keyList, listType: ListType.playlist);
			};
			setState(() {
				videoList = result;
			});
		}) : (){};
		widget.mediaType == 'movie' || widget.mediaType == 'tv' ? getBackdropImageList(widget.movieId, widget.mediaType).then((result) {
			setState(() {
				backdropImageList = result;
			});
		}) : (){};
		getCastList(widget.movieId, widget.mediaType).then((result) {
			setState(() {
				castList = result;
			});
		});
  	}

	@override
  void dispose() {
		//_youtubeController.close();
		super.dispose();
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: maBlack,
			appBar: _buildAppBar(),
			body: FutureBuilder(
				future: getMovieDetail(widget.movieId, widget.mediaType),
				builder:(context, snapshot) {
					if (snapshot.hasData == false) {
						return SizedBox(
							height: MediaQuery.of(context).size.height - 56,
							child: const Center(child: CircularProgressIndicator(color: maGrey))
						);
					}
					return Container(
						decoration: BoxDecoration(
							image: DecorationImage(
								image: snapshot.data!.posterPath != '' || snapshot.data!.profilePath != ''
								? CachedNetworkImageProvider('$posterRootURL${snapshot.data!.posterPath != '' ? snapshot.data?.posterPath : snapshot.data!.profilePath}')
								: const AssetImage('assets/images/movie-poster-placeholder.png') as ImageProvider,
								fit: BoxFit.cover,
            					alignment: Alignment.topCenter,
							),
						),
						child: BackdropFilter(
							filter: ImageFilter.blur(sigmaX: 30, sigmaY: 50),
							child: ListView(
								children: [
									Stack(
										children: [
											Container(
												height: 400,
												width: MediaQuery.of(context).size.width,
												child: snapshot.data!.posterPath != '' || snapshot.data!.profilePath != '' ? CachedNetworkImage(
													imageUrl: '$posterRootURL${snapshot.data!.posterPath != '' ? snapshot.data?.posterPath : snapshot.data!.profilePath}',
													fit: BoxFit.contain,
													alignment: Alignment.topCenter,
												) : Image.asset('assets/images/movie-poster-placeholder.png'),
											),
											SizedBox(
												//height: 620,
												child: Column(
													mainAxisAlignment: MainAxisAlignment.spaceBetween,
													children: [
														Container(height: 400),
														Container(
															height: 380,
															decoration: BoxDecoration(
																color: maBlackDarker.withOpacity(0.65),
																borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
															),
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only(top: 20),
																		padding: const EdgeInsets.symmetric(horizontal: 15),
																		child: Align(
																			alignment: Alignment.centerLeft,
																			child: Text(
																				snapshot.data!.title,
																				style: const TextStyle(
																					color: maWhite,
																					fontSize: 28,
																				),
																			)
																		)
																	),
																	Container(
																		padding: const EdgeInsets.symmetric(horizontal: 15),
																		margin: const EdgeInsets.only(top: 8),
																		child: Row(
																			mainAxisAlignment: MainAxisAlignment.spaceBetween,
																			children: [
																				widget.mediaType == 'movie'
																				? Row(
																					children: [
																						Text(
																							widget.mediaType.substring(0, 1).toUpperCase() + widget.mediaType.substring(1, widget.mediaType.length),
																							style: const TextStyle(
																								color: Colors.grey,
																								fontSize: 16,
																							)
																						),
																						snapshot.data!.releaseDate != '' ? Text(
																							' - ${snapshot.data!.releaseDate.substring(0, 4)} - ',
																							style: const TextStyle(
																								color: Colors.grey,
																								fontSize: 16,
																							)
																						) : const Text(
																							' - ',
																							style: TextStyle(
																								color: Colors.grey,
																								fontSize: 16,
																							)
																						),
																						Text(
																							'${snapshot.data!.runtime.toString()} minutes',
																							style: const TextStyle(
																								color: Colors.grey,
																								fontSize: 16,
																							)
																						),
																					],
																				)
																				: widget.mediaType == 'tv' ? Row(
																					children: [
																						Text(
																							'${widget.mediaType.toUpperCase()} - ',
																							style: const TextStyle(
																								color: Colors.grey,
																								fontSize: 16,
																							)
																						),
																						Text(
																							'${snapshot.data!.seasons.length} ${snapshot.data!.seasons.length > 1 ? 'seasons' : 'season'}',
																							style: const TextStyle(
																								color: Colors.grey,
																								fontSize: 16,
																							)
																						),
																					],
																				) : Container(),
																				widget.mediaType == 'movie' || widget.mediaType == 'tv' ? Row(
																					children: [
																						const Icon(
																							Icons.star_rounded,
																							color: Colors.orange,
																						),
																						Text(
																							snapshot.data!.voteAverage % 1 == 0
																							? snapshot.data!.voteAverage.toInt().toString()
																							: snapshot.data!.voteAverage.toStringAsFixed(1),
																							style: const TextStyle(
																								color: maWhite,
																								fontSize: 16,
																							)
																						),
																						const Text('/10', style: TextStyle(color: Colors.grey, fontSize: 16))
																					],
																				) : Container(),
																			],
																		)
																	),
																	widget.mediaType == 'movie' || widget.mediaType == 'tv' ? SingleChildScrollView(
																		scrollDirection: Axis.horizontal,
																		child: Container(
																			padding: const EdgeInsets.symmetric(horizontal: 15),
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.start,
																				children: renderGenres(snapshot.data!.genres),
																			)
																		)
																	) : Container(),
																	Container(
																		height: 170,
																		margin: const EdgeInsets.only(top: 20),
																		padding: const EdgeInsets.only(left: 15, right: 15),
																		child: SingleChildScrollView(
																			child: Text(
																				widget.mediaType == 'movie' || widget.mediaType == 'tv' ? snapshot.data!.overview : snapshot.data!.biography,
																				style: const TextStyle(
																					color: maGrey,
																					fontSize: 18,
																					height: 1.6,
																				),
																			)
																		)
																	)
																],
															)
														),
													],
												)
											),
										],
									),
									widget.mediaType == 'movie' || widget.mediaType == 'tv' ? Container(
										padding: const EdgeInsets.only(top: 5),
										decoration: BoxDecoration(
											color: maBlackDarker.withOpacity(0.65),
										),
										child: Column(
											children: [
												castList.isNotEmpty ? renderCasts() : Container(),
												videoList.isNotEmpty ? renderVideos() : Container(margin: const EdgeInsets.only(top: 20)),
												backdropImageList.isNotEmpty ? Column (
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														renderBackdropImages()
													],
												) : Container(),
											],
										)
									) : Container(margin: const EdgeInsets.only(bottom: 15)),
								],
							)
						)
					);
				},
			),
		);
	}

	Widget castCard(dynamic cast) {
		return Container(
			margin: const EdgeInsets.symmetric(horizontal: 4,),
			child: ClipRRect(
				borderRadius: BorderRadius.circular(15),
				child: Container(
					width: 135,
					height: 320,
					margin: const EdgeInsets.only(bottom: 6.0,),
					decoration: BoxDecoration(
						color: maBlackDarkest3,
						borderRadius: BorderRadius.circular(15),
						boxShadow: const [
							BoxShadow(
								color: Colors.black,
								offset: Offset(0.0, 1.0), //(x,y)
								blurRadius: 6.0,
							),
						],
					),
					child: Column(
						children: [
							Container(
								decoration: const BoxDecoration(color: maBlackDarkest),
								child: SizedBox(
									height: 200,
									child: CachedNetworkImage(
										imageUrl: '$posterRootURL${cast.profilePath}',
										placeholder: ((context, url) => const Center(
											child: CircularProgressIndicator(color: maGrey,)
										)),
										errorWidget: (context, url, error) => const Center(
											child: Icon(Icons.error, color: maGrey)
										),
										fit: BoxFit.fill,
									)
								)
							),
							Container(
								padding: const EdgeInsets.all(10),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										AutoSizeText(
											cast.name,
											style: const TextStyle(color: maGrey, fontWeight: FontWeight.bold),
											maxLines: 2,
											overflow: TextOverflow.ellipsis,
										),
										Container(margin: const EdgeInsets.only(top: 2)),
										AutoSizeText(
											cast.character,
											style: const TextStyle(color: maGreyDarker),
											maxLines: 2,
											minFontSize: 8,
											overflow: TextOverflow.ellipsis,
										)
									],
								),
							),
						],
					),
				)
			)
		);
	}

	Widget renderCasts () {
		int limitLength = 15;
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Container(
					padding: const EdgeInsets.all(10),
					child: const Text(
						'Casts',
						style: TextStyle(
							color: maGreyDarker,
							fontSize: 16,
							fontWeight: FontWeight.bold,
						),
					)
				),
				SingleChildScrollView(
					scrollDirection: Axis.horizontal,
					child: Row(
						children: [
							Container(margin: const EdgeInsets.only(left: 7)),
							...castList.sublist(0, castList.length > limitLength ? limitLength : castList.length).map((item) {
								return castCard(item);
							}).toList(),
							Container(margin: const EdgeInsets.only(right: 7)),
							InkWell(
								borderRadius: BorderRadius.circular(20),
								onTap:(){print('View More');},
								child: Container(
									width: 135,
									height: 320,
									margin: const EdgeInsets.only(right: 10),
									child: Center(
										child: Row(
											mainAxisAlignment: MainAxisAlignment.center,
											children: const [
												Text('View More', style: TextStyle(color: maGrey, fontWeight: FontWeight.bold, fontSize: 16)),
												Icon(Icons.arrow_right_alt, color: maGrey, size: 24),
											],
										),
									),
								)
							),
						],
					)
				)
			],
		);	
	}

	Widget renderBackdropImages () {
		int limitLength = 15;
		return Container(
			//color: maBlackDarkest,
			margin: const EdgeInsets.only(top: 15),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Container(
						padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
						child: const Text(
							'Images',
							style: TextStyle(
								color: maGreyDarker,
								fontSize: 16,
								fontWeight: FontWeight.bold,
							),
						)
					),
					CarouselSlider.builder(
						itemCount: backdropImageList.length < limitLength ? backdropImageList.length : limitLength,
						options: CarouselOptions(
							initialPage: 0,
							scrollDirection: Axis.horizontal,
							//enableInfiniteScroll: false,
							//pageSnapping: false,
							height: 190,
						),
						itemBuilder: (context, index, realIndex) {
							return Container(
								margin: const EdgeInsets.symmetric(horizontal: 15),
								child: CachedNetworkImage(
									imageUrl: '$posterRootURL${backdropImageList[index].filePath}',
									placeholder: ((context, url) => const Center(
										child: CircularProgressIndicator(color: maGrey,)
									)),
									errorWidget: (context, url, error) => const Center(
										child: Icon(Icons.error, color: maGrey)
									),
									fit: BoxFit.contain,
								)
							);
						},
					)
				],
			)
		);
	}

	Widget renderVideos () {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Container(
					margin: const EdgeInsets.only(top: 10),
					padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
					child: const Text(
						'Videos',
						style: TextStyle(
							color: maGreyDarker,
							fontSize: 16,
							fontWeight: FontWeight.bold,
						),
					)
				),
				Container(
					margin: const EdgeInsets.only(top: 10),
					padding: const EdgeInsets.symmetric(horizontal: 10),
					
					child: SizedBox(
						child: YoutubePlayerScaffold(
							controller: _youtubeController,
							aspectRatio: 16 / 9,
							builder: (context, player) {
								return player;
							},
						)
					)
				)
			],
		);
	}

	List<Widget> renderGenres (dynamic genres) {
		List<Widget> children = [];
		if(genres.isEmpty) return children;
		for(int i = 0; i < genres.length; i++) {
			children.add(
				Container(
					margin: const EdgeInsets.only(right: 8, top: 12),
					padding: const EdgeInsets.all(16),
					decoration: BoxDecoration(
						borderRadius: BorderRadius.circular(20),
						color: maBlackDarkest3,
					),
					child: Text(
						genres[i]['name'],
						style: const TextStyle(
							color: maWhite,
						),
					)
				)
			);
		}
		return children;
	}

	AppBar _buildAppBar() {
		return AppBar(
			backgroundColor: maBlackDarkest,
			centerTitle: true,
			title: const Text(
				'MOVIE DETAIL', 
				style: TextStyle(
					fontWeight: FontWeight.w700,
				)
			),
		);
	}
}