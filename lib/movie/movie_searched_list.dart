import 'package:flutter/material.dart';
import 'package:movieapp/constants/colors.dart';
import 'package:movieapp/model/movie.dart';
import 'package:movieapp/movie/movie_action.dart';
import 'package:movieapp/movie/movie_list_tiles.dart';

class MovieSearchedList extends StatefulWidget {
	final String searchInput;
	final int pageNumber;
	final int totalPageNumber;
	const MovieSearchedList({ Key? key, required this.searchInput, required this.pageNumber, required this.totalPageNumber}) : super(key: key);

	@override
	State<MovieSearchedList> createState() => _MovieSearchedListState();
}

class _MovieSearchedListState extends State<MovieSearchedList> {
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
		return FutureBuilder<List<Movie>>(
			future: getSearchedMovies(widget.searchInput, widget.pageNumber),
			builder: (context, snapshot) {
				if (snapshot.hasData == false) {
					return Container(
						margin: const EdgeInsets.only(top: 40),
						child: const Center(child: CircularProgressIndicator(color: maGrey))
					);
				}
				return Expanded(
					child: Padding(
						padding: const EdgeInsets.symmetric(horizontal: 15),
						child: ListView(
							shrinkWrap: true,
							children: _buildSearchedList(snapshot.data!, context),
						)
					)
				);
			},
		);
	}

	List<Widget> _buildSearchedList (List<Movie> movieList, dynamic context) {
		if(movieList.isEmpty == true) {
			return [
				Container(
					margin: const EdgeInsets.only(top: 15),
					width: MediaQuery.of(context).size.width,
					child: const Center(
						child: Text(
							'No result found',
							style: TextStyle(
								color: maGrey,
								fontSize: 16,
							),
						)
					)
				)
			];
		}
		return [
			...movieListTiles(movieList, context),
		];
	}
}