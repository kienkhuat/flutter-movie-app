import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieapp/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'Movie App',
			theme: ThemeData(
				primarySwatch: Colors.blue,
				//useMaterial3: true,
			),
			home: const HomePage(),
		);
	}
}