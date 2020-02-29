import 'package:flutter/material.dart';
import 'package:pbl_store/screens/login.dart';
import 'package:pbl_store/screens/main_home.dart';
import 'package:pbl_store/bloc/GlobalBloc.dart';
import 'package:pbl_store/bloc/BlocProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/logo.jpg"), context);
    precacheImage(AssetImage("assets/slide1.png"), context);
    precacheImage(AssetImage("assets/slide2.png"), context);
    precacheImage(AssetImage("assets/slide3.png"), context);
    precacheImage(AssetImage("assets/slide4.png"), context);
    precacheImage(AssetImage("assets/slide5.jpg"), context);
    precacheImage(AssetImage("assets/featured.png"), context);
      precacheImage(AssetImage("assets/bg2.jpg"), context);
    precacheImage(AssetImage("assets/industrial-supply.png"), context);
    precacheImage(AssetImage("assets/product.jpg"), context);
    return BlocProvider<GlobalBloc>(
      bloc: GlobalBloc(),
      child: MaterialApp(
        title: 'PBL Store',
        home: Scaffold(
          body: LoginPage(),
        ),
        routes: {
          MainHomePage.routeName: (BuildContext context) => new MainHomePage()
        },
      ),
    );
  }
}

