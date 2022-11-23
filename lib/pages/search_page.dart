import 'package:flutter/material.dart';
import 'package:movieapp/constants/colors.dart';
import 'package:movieapp/movie/movie_action.dart';
import 'package:movieapp/movie/movie_searched_list.dart';
import 'package:number_paginator/number_paginator.dart';

class SearchPage extends StatefulWidget {
	final String searchInput;
	const SearchPage({ Key? key, required this.searchInput }) : super(key: key);

	@override
	State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
	late String searchInput = widget.searchInput;
	late int pageNumber;
	late int totalPageNumber = 0;

	@override
	void initState() {
		super.initState();
		searchInput = widget.searchInput;
		pageNumber = 1;
		widget.searchInput.trim().isNotEmpty ? getSearchedTotalPage(searchInput, pageNumber).then((result) {
			if(mounted) {
				setState(() {
					totalPageNumber = result;
				});
			}
		}) : (){};
  	}

	@override
	void dispose() {
		super.dispose();
  	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: maBlack,
			appBar: _buildAppBar(),
			body: Column (
				//padding: const EdgeInsets.symmetric(horizontal: 15),
				children: [
					Container(
						padding: const EdgeInsets.symmetric(horizontal: 15),
						child: searchBar()
					),
					searchInput.trim().isNotEmpty && totalPageNumber > 0 ? Container(
						margin: const EdgeInsets.only(bottom: 10),
						child: NumberPaginator(
							numberPages: totalPageNumber,
							onPageChange: (int index) {
								setState(() {
									pageNumber = index + 1;
								});
							},
							config: const NumberPaginatorUIConfig(
								buttonSelectedBackgroundColor: maBlackDarkest,
								buttonUnselectedForegroundColor: maGrey,
							),
						)
					) : Container(),
					searchInput.trim().isNotEmpty ? MovieSearchedList(
						searchInput: searchInput, 
						pageNumber: pageNumber, 
						totalPageNumber: totalPageNumber,
					) : Container(),
				],
			)
		);
	}

	Widget searchBar() {
		return Container(
			margin: const EdgeInsets.only(top: 30, bottom: 10),
			padding: const EdgeInsets.symmetric(horizontal: 10),
			decoration: BoxDecoration(
				border: Border.all(color: maBlackDarker, width: 2, style: BorderStyle.solid),
				borderRadius: BorderRadius.circular(20),
			),
			child: TextFormField(
				onFieldSubmitted: (String input) => {
					setState(() => {searchInput = input}),
					input.trim().isNotEmpty ? getSearchedTotalPage(searchInput, pageNumber).then((result) {
						if(mounted) {
							setState(() {
								totalPageNumber = result;
							});
						}
					}) : (){}
				},
				style: const TextStyle(
					color: maGrey,
				),
				initialValue: widget.searchInput,
				decoration: const InputDecoration(
					contentPadding: EdgeInsets.symmetric(vertical: 10),
					prefixIcon: Icon(
						Icons.search,
						color: Colors.grey,
						size: 20,
					),
					prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
					border: InputBorder.none,
					hintText: 'Search...',
					hintStyle: TextStyle(color: Colors.grey),
				),
			),
		);
	}

	AppBar _buildAppBar() {
		return AppBar(
			backgroundColor: maBlackDarkest,
			centerTitle: true,
			title: const Text(
				'SEARCH', 
				style: TextStyle(
					fontWeight: FontWeight.w700,
				)
			),
		);
	}
}