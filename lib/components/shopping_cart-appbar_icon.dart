import 'package:pbl_store/bloc/BlocProvider.dart';
import 'package:pbl_store/bloc/GlobalBloc.dart';
import 'package:pbl_store/models/shopping_cart.dart';
import 'package:pbl_store/screens/shoppingcart_screen.dart';
import 'package:flutter/material.dart';

class ShoppingCartAppBarIcon extends StatefulWidget {
  ShoppingCartAppBarIcon();

  @override
  ShoppingCartAppBarIconState createState() => ShoppingCartAppBarIconState();
}

class ShoppingCartAppBarIconState extends State<ShoppingCartAppBarIcon> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: StreamBuilder(
        stream:
        BlocProvider.of<GlobalBloc>(context).shoppingCartBloc.cartStream,
        initialData: ShoppingCart(),
        builder: (context, snapshot) {
          int count = 0;
          if (snapshot.hasData) {
            if (snapshot.data is ShoppingCart) {
              count = snapshot.data.products.length;
            }
          }
          return Chip(
            label: Text(count.toString()),
            backgroundColor: Colors.transparent,
            avatar: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
        );
      },
    );
  }
}