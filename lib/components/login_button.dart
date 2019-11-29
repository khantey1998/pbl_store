import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
	final VoidCallback onPressed;

	LoginButton({this.onPressed});

	@override
	Widget build(BuildContext context) {
		return new Container(
				margin: const EdgeInsets.symmetric(vertical: 12.0),
				child: new Material(
						elevation: 3.0,
						borderRadius: BorderRadius.circular(5.0),
						color: Colors.blue,
						child: new MaterialButton(
								minWidth: MediaQuery
										.of(context)
										.size
										.width,
								height: 42.0,
								child: new Text(
										'Log In',
										style: new TextStyle(
											color: Colors.white,
											fontWeight: FontWeight.bold,
											fontSize: 18
										)
								),
								onPressed: onPressed
						)
				)
		);
	}
}
