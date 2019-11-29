import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth_utils.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:pbl_store/screens/login.dart';
import 'package:pbl_store/models/customer.dart';
import 'package:pbl_store/models/shopping_cart.dart';
import 'package:pbl_store/bloc/BlocProvider.dart';
import 'package:pbl_store/bloc/GlobalBloc.dart';
import 'package:pbl_store/models/product_model.dart';
import 'package:pbl_store/models/category_model.dart';
import 'package:pbl_store/models/address_model.dart';
import 'package:pbl_store/models/manufacturer_model.dart';

class NetworkUtils {
	static final String host = productionHost;
	static final String productionHost = '3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB@pblstore.com';
	static final String developmentHost = 'http://192.168.31.110:3000';

	static dynamic authenticateUser(String email) async {
		var uri = host + AuthUtils.endPoint;
		try {
			final response = await http.get(
				uri,
			);
			final responseJson = json.decode(response.body);
			return responseJson;
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static logoutUser(BuildContext context, SharedPreferences prefs) {
		prefs.setString(AuthUtils.authTokenKey, null);
		prefs.setInt(AuthUtils.userIdKey, null);
		prefs.setString(AuthUtils.nameKey, null);
		prefs.setString(AuthUtils.cartIDKey, null);
		BlocProvider
				.of<GlobalBloc>(context)
				.shoppingCartBloc
				.clearCart();
		Navigator.pushReplacement(
				context, MaterialPageRoute(builder: (context) => LoginPage()));
	}

	static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
		scaffoldKey.currentState.showSnackBar(
				new SnackBar(
					content: new Text(message ?? 'You are offline'),
				)
		);
	}

	static verifyPassword(String email, String password) async {
		var isCorrect;
		var url = Uri.http(host, "/api/customers",
				{'filter[email]': email, 'display': '[passwd]'});
		try {
			final response = await http.get(
				url,
			);

			final responseJson = (json.decode(response.body)['customers'] as List)
					.map((data) => Customer.fromJson(data))
					.toList();

			isCorrect = new DBCrypt().checkpw(password, responseJson[0].password);
			return isCorrect;
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static checkExistingEmail(String email) async {
		var url = Uri.http(host, "/api/customers", {'filter[email]': email});
		try {
			final response = await http.get(
				url,
			);
			final responseJson = (json.decode(response.body)['customers'] as List)
					.map((data) => Customer.fromJson(data))
					.toList();

			return responseJson;
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static fetch(String email) async {
		var url = Uri.http(
				host, "/api/customers", {'filter[email]': email, 'display': 'full'});
		try {
			final response = await http.get(
				url,
			);
			final responseJson = (json.decode(response.body)['customers'] as List)
					.map((data) => Customer.fromJson(data))
					.toList();
			return responseJson;
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static dynamic registerUser({String body}) async {
		var uri = host + AuthUtils.endPoint;
		try {
			return await http.post(
					uri,
					body: body,
					headers: {
						"Content-Type": "application/json"
					}
			).then((a) => a.statusCode == 201 ? "success" : "error");
		} catch (exception) {
			print(exception);
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static dynamic createCart({String body}) async {
		var url = Uri.http(host, "/api/carts");
		try {
			var response = await http.post(
					url,
					body: body,
					headers: {
						"Content-Type": "application/json"
					}
			);
			final responseJson = json.decode(response.body)['cart'];
			return ShoppingCart.fromJson(responseJson);
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static dynamic updateCart({String body}) async {
		var url = Uri.http(host, "/api/carts");
		try {
			return await http.put(
					url,
					body: body,
					headers: {
						"Content-Type": "application/json"
					}
			).then((a) => a.statusCode == 201 ? "success" : a.statusCode);
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static dynamic getCart(String cartID) async {
		var url = Uri.http(host, "/api/carts/$cartID");
		try {
			var response = await http.get(
				url,
			);
			final responseJson = json.decode(response.body)['cart'];
			return ShoppingCart.fromJson(responseJson);
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static getAllProducts() async {
		var url = Uri.http(host, "/api/products", {'display': 'full'});
		try {
			final response = await http.get(
					url,
					headers: {
						'Content-Type': 'application/json; charset=utf-8',
					}
			);
			final responseJson = (json.decode(
					utf8.decode(response.bodyBytes))['products'] as List)
					.map((data) => ProductModel.fromJson(data))
					.toList();
			return responseJson;
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static dynamic getSingleProduct(String productID) async {
		var url = Uri.http(host, "/api/products/$productID");
		try {
			var response = await http.get(
				url,
			);
			final responseJson = json.decode(response.body)['product'];
			return ProductModel.fromJson(responseJson);
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static dynamic createOrder({String body}) async {
		var url = Uri.http(host, "/api/orders");
		try {
			var response = await http.post(
					url,
					body: body,
					headers: {
						"Content-Type": "application/json"
					}
			);
			final responseJson = json.decode(response.body)['cart'];
			return ShoppingCart.fromJson(responseJson);
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static checkAddress(String idCustomer) async {
		var url = Uri.http(
				host, "/api/addresses", {'filter[id_customer]': idCustomer});
		try {
			final response = await http.get(
				url,
			);
			final responseJson = (json.decode(response.body)['addresses'] as List)
					.map((data) => Customer.fromJson(data))
					.toList();

			return responseJson;
		} catch (exception) {
			print(exception);
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static dynamic createAddress({String body}) async {
		var url = Uri.http(host, "/api/addresses");
		try {
			var response = await http.post(
					url,
					body: body,
					headers: {
						"Content-Type": "application/json"
					}
			);
			final responseJson = json.decode(response.body)['address'];
			return AddressModel.fromJson(responseJson);
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static dynamic getAllCategories() async {
		var url = Uri.http(host, "/api/categories", {'display': 'full'});
		try {
			final response = await http.get(
					url,
					headers: {
						'Content-Type': 'application/json; charset=utf-8',
					}
			);
			final responseJson = (json.decode(response.body)['categories'] as List)
					.map((data) => CategoryModel.fromJson(data))
					.toList();
			return responseJson;
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}
	static dynamic getManufacturers() async {
		var url = Uri.http(host, "/api/categories", {'display': 'full'});
		try {
			final response = await http.get(
					url,
					headers: {
						'Content-Type': 'application/json; charset=utf-8',
					}
			);
			final responseJson = (json.decode(response.body)['manufacturers'] as List)
					.map((data) => ManufacturerModel.fromJson(data))
					.toList();
			return responseJson;
		} catch (exception) {
			if (exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}
}
