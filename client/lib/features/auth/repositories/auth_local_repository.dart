import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalRepository {
  late SharedPreferences _sharedPreferences;
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
}
