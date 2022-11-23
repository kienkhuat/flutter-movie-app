import 'package:flutter/material.dart';

Route createRoute(dynamic page) {
	return PageRouteBuilder(
		transitionDuration: const Duration(milliseconds: 250),
		pageBuilder:  ((context, animation, secondaryAnimation) => page),
		transitionsBuilder: (context, animation, secondaryAnimation, child) {
			const begin = Offset(1.0, 0.0); // (x, y)
			const end = Offset(0.0, 0.0);
			final tween = Tween(begin: begin, end: end);
			final offsetAnimation = animation.drive(tween);
			return SlideTransition(
				position: offsetAnimation,
				child: child,
			);
		},
	);
}