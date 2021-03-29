import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final String authToken = "auth_token";

  //set data into shared preferences like this
  Future<void> setString(String key, String string) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, string);
  }

  //get value from shared preferences
  Future<String?> getString(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? string;
    string = pref.getString(key);
    return string;
  }

  //get value from shared preferences
  Future<bool> remove(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }

//set data into shared preferences like this
  Future<void> setAuthToken(String authToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.authToken, authToken);
  }

//get value from shared preferences
  Future<String?> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? authToken;
    authToken = pref.getString(this.authToken);
    return authToken;
  }
}
