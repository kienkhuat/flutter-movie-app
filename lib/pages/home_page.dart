import 'package:flutter/material.dart';
import 'package:movieapp/constants/colors.dart';
import 'package:movieapp/movie/movie_action.dart';
import 'package:movieapp/movie/movie_carousel.dart';
import 'package:movieapp/movie/movie_horizontal_grid.dart';
import 'package:movieapp/pages/search_page.dart';
import 'package:movieapp/utilities/create_route.dart';

class HomePage extends StatefulWidget {
	const HomePage({Key? key}) : super(key: key);
	
	@override
	State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	late String mediaType;
	late List<Widget> widgetsToRender;
	final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
	late bool _isCustomTileExpanded = false;

	@override
	void initState() {
		super.initState();
		mediaType = 'movie';
		mediaTypeToRender();
  	}

	@override
	void dispose() {
		super.dispose();
  	}

	AppBar _buildAppBar() {
		return AppBar(
			backgroundColor: maBlackDarkest,
			centerTitle: true,
			title: const Text(
				'MOVIEAPP', 
				style: TextStyle(
					fontWeight: FontWeight.w700,
				)
			),
			actions: [	
				Container(
					margin: const EdgeInsets.only(right: 10),
					child: GestureDetector(
						onTap: () {_toggleEndDrawer();},
						child: CircleAvatar(
							child: ClipOval(
								child: Image.network(
									'https://us.123rf.com/450wm/apoev/apoev1903/apoev190300009/apoev190300009.jpg?ver=6',
								),
							),
						)
					)
				),
			],
		);
	}

	void _toggleDrawer() async {
		if(_scaffoldKey.currentState!.isDrawerOpen) {
			_scaffoldKey.currentState!.closeDrawer();
		} else {
			_scaffoldKey.currentState!.openDrawer();
		}
	}

	List<Widget> drawerMenuItem () {
		List<Widget> children = [];
		List<Map> expansionMenuList = [
			{
				'icon': Icons.movie,
				'name': 'Movie',
				'items' : [
					{
						'name': 'Latest',
					},
					{
						'name': 'Explore',
					},
					{
						'name': 'Trending',
					},
					{
						'name': 'Upcoming',
					},
					{
						'name': 'Popular',
					},
					{
						'name': 'Top rated',
					},
				]
			},
			{
				'icon': Icons.tv,
				'name': 'TV Series',
				'items': [
					{
						'name': 'Latest',
					},
					{
						'name': 'Explore',
					},
					{
						'name': 'Trending',
					},
					{
						'name': 'Popular',
					},
					{
						'name': 'Top rated',
					},
				],
			}
		];
		for(int i = 0; i < expansionMenuList.length; i++) {
			children.add(
				ExpansionTile(
					iconColor: maGrey,
					expandedAlignment: Alignment.centerLeft,
					title: Row(
						children: [
							Icon(
								expansionMenuList[i]['icon'],
								color: maGrey,
								size: 18
							),
							Container(margin: const EdgeInsets.only(right: 8)),
							Text(
								expansionMenuList[i]['name'],
								style: const TextStyle(
									color: maGrey,
									fontSize: 20
								),
							),
						],
					),
					children: (expansionMenuList[i]['items'] as List).map((item) {
						return ListTile(
							onTap: (){print(item['name']);},
							tileColor: maBlack,
							title: Container(
								padding: const EdgeInsets.only(left: 28),
								child: Text(
									item['name'],
									style: const TextStyle(
										color: maGreyDarker,
										fontSize: 16
									),
								)
							)
						);
					}).toList(),
				)
			);
		}
		return children;
	}

	Drawer _buildDrawer () {
		return Drawer(
			backgroundColor:  maBlack,
			child: ListView(
				padding: EdgeInsets.zero,
				children: [
					SizedBox(
						height: 56,
						child: DrawerHeader(
							padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
							margin: const EdgeInsets.all(0),
							decoration:const BoxDecoration(
								color: maBlackDarker,
							),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									Container(),
									GestureDetector(
										onTap: _toggleDrawer,
										child: const Icon(Icons.close, color: maGrey, size: 32,)
									)
								],
							),
						)
					),
					...drawerMenuItem(),
				],
			)
		);
	}

	void _toggleEndDrawer() async {
		if(_scaffoldKey.currentState!.isEndDrawerOpen) {
			_scaffoldKey.currentState!.closeEndDrawer();
		} else {
			_scaffoldKey.currentState!.openEndDrawer();
		}
	}

	Drawer _buildEndDrawer() {
		return Drawer(
			backgroundColor:  maBlack,
			child: ListView(
				padding: EdgeInsets.zero,
				children: [
					SizedBox(
						height: 56,
						child: DrawerHeader(
							padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
							margin: const EdgeInsets.all(0),
							decoration:const BoxDecoration(
								color: maBlackDarker,
							),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									GestureDetector(
										onTap: _toggleEndDrawer,
										child: const Icon(Icons.close, color: maGrey, size: 32,)
									),
									Container(),
								],
							),
						)
					),
				],
			)
		);
	}

	BottomNavigationBar _buildBottomNavBar () {
		return BottomNavigationBar(
			backgroundColor: maBlackDarkest,
			fixedColor: maWhite,
			unselectedItemColor: const Color.fromARGB(255, 114, 113, 113),
			currentIndex: mediaType == 'tv' ? 1 : 0,
			onTap: (int value) {
				if(value == 2) {
					Navigator.of(context).push(createRoute(const SearchPage(searchInput: '')));
				}
				if(value == 1) {
					setState(() {
						mediaType = 'tv';
					});
					mediaTypeToRender();
				}
				if(value == 0) {
					setState(() {
						mediaType = 'movie';
					});
					mediaTypeToRender();
				}
			},
			items: const [
				BottomNavigationBarItem(
					icon: Icon(Icons.movie), 
					label: 'Movie'
				),
				BottomNavigationBarItem(
					icon: Icon(Icons.tv), 
					label: 'TV'
				),
				BottomNavigationBarItem(
					icon: Icon(Icons.search), 
					label: 'Search'
				),
			] 
		);
	}

	void mediaTypeToRender () {
		if(mediaType == 'movie') {
			setState(() => {
				widgetsToRender = [
					MovieHorizontalGrid(listName: 'Trending Movies', movieList: getTrendingMovies('movie'), showListTitle: true,),
					//MovieHorizontalGrid(listName: 'Upcoming Movies', movieList: getUpcomingMovies(), showListTitle: true,),
					MovieHorizontalGrid(listName: 'Popular Movies', movieList: getPopularMovies(1), showListTitle: true,),
					MovieHorizontalGrid(listName: 'Top Rated Movies', movieList: getTopRatedMovies(1), showListTitle: true,),
					//MovieCarousel(listName: 'Trending Movies', movieList: getTrendingMovies('movie'),),
					//MovieCarousel(listName: 'Upcoming Movies', movieList: getUpcomingMovies(),),
					// MovieCarousel(listName: 'Top Rated Movies', movieList: getTopRatedMovies(1),),
				]
			});
		}
		if(mediaType == 'tv') {
			setState(() => {
				widgetsToRender = [
					MovieHorizontalGrid(listName: 'Trending TV Series', movieList: getTrendingMovies('tv'), showListTitle: true,),
					MovieHorizontalGrid(listName: 'Top Rated TV Series', movieList: getTopRatedTvSeries(1), showListTitle: true,),
					MovieHorizontalGrid(listName: 'Popular TV Series', movieList: getPopularTvSeries(1), showListTitle: true,),
					//MovieCarousel(listName: 'Trending TV Series', movieList: getTrendingMovies('tv'),),
					// MovieCarousel(listName: 'Top Rated TV Series', movieList: getTopRatedTvSeries(1),),
					// MovieCarousel(listName: 'Popular TV Series', movieList: getPopularTvSeries(1),),
				]
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: maBlack,
			key: _scaffoldKey,
			appBar: _buildAppBar(),
			drawer: _buildDrawer(),
			endDrawer: _buildEndDrawer(),
			bottomNavigationBar: _buildBottomNavBar(),
			body: ListView(
				children: [
					...widgetsToRender,
					Container(padding: const EdgeInsets.only(bottom: 12)),
				],
			),
		);
	}
}