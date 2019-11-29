import 'package:pbl_store/bloc/BlocProvider.dart';
import 'package:pbl_store/bloc/ShoppingCartBloc.dart';

class GlobalBloc implements BlocBase {
  ShoppingCartBloc shoppingCartBloc;

  GlobalBloc() {
    shoppingCartBloc = ShoppingCartBloc();
  }

  void dispose() {
    shoppingCartBloc.dispose();
  }
}