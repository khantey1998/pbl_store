import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/models/customer.dart';
import 'package:pbl_store/models/shopping_cart.dart';

class AuthUtils {

	static final String endPoint = '/api/customers';

	// Keys to store and fetch data from SharedPreferences
	static final String authTokenKey = 'access_token';
	static final String userIdKey = 'id';
	static final String nameKey = 'name';
	static final String emailKey = 'email';
	static final String cartIDKey = 'cart_id';

	static String getToken(SharedPreferences prefs) {
		return prefs.getString(authTokenKey);
	}

	static insertDetails(SharedPreferences prefs, List<Customer> response, ShoppingCart cart) {
		prefs.setString(authTokenKey, response[0].securityKey);
		prefs.setString(userIdKey, response[0].id);
		prefs.setString(nameKey, response[0].firstName+" "+response[0].lastName);
		prefs.setString(emailKey, response[0].email);
		prefs.setString(cartIDKey, cart.id);
	}
}